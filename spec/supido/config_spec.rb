require 'spec_helper'

describe Supido::Configuration do
  let(:config) { Supido.config }

  context "default settings" do
    it "should the benchmark_tool default value be" do
      benchmark_tool = config.benchmark_tool.new
      benchmark_tool.is_a?(::Supido::Tools::ApacheBenchmark).should be_true
    end

    it "should the log_path default value be" do
      config.log_path.should == "/tmp"
    end
  end

  context "changing configurations" do
    before {
      Supido.configure do |config|
        config.benchmark_tool = ::Supido::SampleBenchmarkTool
        config.log_path = "/new/path"
      end
    }
    
    let(:config) { Supido.config }

    it "should set up the benchmark_tool" do
      benchmark_tool = config.benchmark_tool.new
      benchmark_tool.is_a?(::Supido::SampleBenchmarkTool).should be_true
    end

    it "should set up the log_path" do
      config.log_path.should == "/new/path"
    end

  end
end
