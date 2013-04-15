require "puppet-newrelic/version"
require 'new_relic/agent'

module Puppet
  module Parser
    module Functions

      def self.singleton_method_added method
        return unless method.to_s == "newfunction"
        return if instance_variable_defined?(:@added)

        @added = true

        class << self
          alias newfunction_without_newrelic newfunction
          alias newfunction newfunction_with_newrelic
        end
      end

      def self.newfunction_with_newrelic name, options = {}, &block
        newfunction_without_newrelic(name, options, &block)

        func = environment_module.instance_method(:"function_#{name}")
        environment_module.send(:define_method, :"orig_function_#{name}", func)
        environment_module.send(:define_method, :"function_#{name}") do |args|
          ::NewRelic::Agent::MethodTracer.trace_execution_scoped("Custom/PuppetFunction/#{name}") do
            send(:"orig_function_#{name}", args)
          end
        end
      end
    end
  end

  module Network
    module HTTP
      module Handler
        def self.method_added name
          name = name.to_sym
          names = [:do_find, :do_head, :do_search, :do_destroy, :do_save]
          return unless names.include?(name)
          return if instance_variable_defined?(:"@_#{name}_added")

          instance_variable_set(:"@_#{name}_added", true)

          class_eval <<-EOC
            def #{name}_with_newrelic(indirection_name, key, params, request, response)
              perform_action_with_newrelic_trace({ :name => indirection_name, :params => params, :request => request }) do
                #{name}_without_newrelic(indirection_name, key, params, request, response)
              end
            end

            alias #{name}_without_newrelic #{name}
            alias #{name} #{name}_with_newrelic
            EOC
        end

        include ::NewRelic::Agent::Instrumentation::ControllerInstrumentation
      end
    end
  end
end

