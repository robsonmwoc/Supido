require 'spec_helper'

describe Supido::Profile do
  
  before { set_default_configuration }

  context "Setting up a profile" do
    
    it "should have a new with timestamp" do 
      profile = ::Supido::Profile.new("ProfileName")
      ::Supido::Profile.name.should match /profile_name_(\d+)/
    end

  end

  context "Queue actions" do

    subject { Supido::Profile.new("ProfileName") }

    it "should raise an error with not block" do
      lambda {
        subject.queue_action("ActionName")
      }.should raise_error "No block given"
    end

  end

  context "Run and analize actions" do

    subject { Supido::Profile.new("ProfileName") }

    before {
      subject.queue_action("VisitingGoogle") do |action|
        action.url = "http://google.com"
        action.concurrency = 1
        action.requests = 1
      end
    }

    it "should run the profile"

  end
end