require 'spec_helper'

RSpec.describe Hoops::Operation do

  let(:result) { "RESULT" }
  let(:error) { "ERROR" }

  let(:op_class) do
    Class.new(described_class) do
      attr_reader :valid

      def initialize(valid)
        @valid = valid
      end

      def call
        if valid
          success!("RESULT")
        else
          failure!(:invalid_result, "ERROR")
        end

        failure!(valid, "DOUBLE RESULT") if valid == :double_error
      end
    end
  end

  context "when the operation is a success" do
    it "should broadcast sucess events" do
      expect { op_class.call(true) }.to broadcast(:success, result)
    end
  end

  context "when the operation fails" do
    it "should broadcast failure events" do
      expect { op_class.call(false) }.to broadcast(:invalid_result, error)
    end
  end

  context "when the operation signals twice" do
    it "should raise an exception" do
      expect { op_class.call(:double_error) }.to raise_error(Hoops::Operation::SignalError)
    end
  end
end
