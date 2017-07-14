require "wisper"

module Hoops
  class Operation
    include Wisper::Publisher

    SignalError = Class.new(RuntimeError)

    def self.call(*args)
      operation = new(*args)
      yield operation if block_given?
      operation.call
    end

    singleton_class.send(:alias_method, :[], :call)

    def on_success(*args, &block)
      on(success_code, &block)
    end

    def self.success_code
      @success_code ||= if name.nil? || name == ''
                          :success
                        else
                          code = name.
                            gsub(/(.)([A-Z](?=[a-z]))/,'\1_\2').
                            gsub('::','').
                            downcase

                          "#{code}_success".to_sym
                        end
    end

    def self.success_code=(code)
      @success_code = code
    end

    private

    def success_code
      self.class.success_code
    end

    def success!(*args)
      lock!(:success)
      broadcast(success_code, *args)
      true
    end

    def failure!(code, *args)
      lock!(:failure)
      broadcast(code, *args)
      false
    end

    def signal!(code, *args)
      check_lock(:success)
      broadcast(code, *args)
      true
    end

    def lock!(signal)
      @lock ||= Lock.new(signal)
      check_lock(signal)
    end

    def check_lock(signal)
      @lock.nil? || @lock.allow?(signal)
    end

    def forward_failure(other_operation, *ev_codes, as: nil)
      forward(:failure!, other_operation, *ev_codes, as: as)
    end

    def forward_success(other_operation, *ev_codes, as: nil)
      forward(:success!, other_operation, *ev_codes, as: as)
    end

    def forward_signal(other_operation, *ev_codes, as: nil)
      forward(:signal!, other_operation, *ev_codes, as: as)
    end

    def forward(method, other_operation, *ev_codes, as: nil)
      ev_codes.each do |code|
        other_operation.on(code) do |*args|
          send(method, as ? as : code, *args)
        end
      end
    end
  end
end

require 'hoops/operation/lock'
