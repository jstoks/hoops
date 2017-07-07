
module Hoops
  class Operation
    class Lock
      def initialize(signal)
        @signal = signal
      end

      def allow?(other)
        raise Operation::SignalError, <<-ERROR.strip if other != signal
          Operation result already locked to #{signal}. Cannot broadcast #{other}.
        ERROR

        true
      end

      private
      attr_reader :signal
    end
  end
end
