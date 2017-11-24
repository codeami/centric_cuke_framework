# frozen_string_literal: true

require 'delegate'

# A class for extending other classes / modules with before / after hooks.
#
class Hookable < SimpleDelegator
  def initialize(obj, method_hooks, additional_contexts = [])
    super(obj)

    additional_contexts = [additional_contexts] unless additional_contexts.is_a?(Array)

    _add_hooks(:before, method_hooks, additional_contexts)
    _add_hooks(:after, method_hooks, additional_contexts)

    method_hooks.map {|h| h[:before] || h[:after]}.uniq.each do |method|
      define_singleton_method(method) do |*args, &block|
        self.send("before_#{method}") if self.respond_to? "before_#{method}"
        #val = __getobj__.send(method, *args, &block)
        val = super(*args, &block)
        self.send("after_#{method}") if self.respond_to? "after_#{method}"
        val
      end
    end
  end

  def class
    __getobj__.class
  end

  private

  def _add_hooks(which, method_hooks, additional_contexts)
    method_hooks.select {|hook| hook.key?(which)}.each do |hook|
      hook[:contexts] = hook.fetch(:contexts, []).concat(additional_contexts)
      define_singleton_method("#{which}_#{hook[which]}") do |*args, &block|
        hook[:call].each do |hook_fn|
          if hook_fn.is_a?(Proc)
            hook_fn.call
          else
            context = hook[:contexts].unshift(__getobj__).find {|c| c.respond_to?(hook_fn)}
            raise "No context found for #{which} hook: #{hook_fn}" unless context
            context.send(hook_fn)
          end
        end
      end
    end
  end
end

