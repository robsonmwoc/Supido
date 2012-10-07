require 'spec_helper'

describe Supido::AbstractBenchmarkBase do

  before { set_default_configuration }

  context "When implements the  AbstractBenchmarkBase" do
    subject { Supido::SampleBenchmarkTool.new }

    it "should raise an error when build was not implemented" do
      lambda {
        subject.build(nil)
      }.should raise_error Supido::AbstractInterface::InterfaceNotImplementedError
    end

    it "should raise an error when report was not implemented" do
      lambda {
        subject.report(nil)
      }.should raise_error Supido::AbstractInterface::InterfaceNotImplementedError
    end

  end

end