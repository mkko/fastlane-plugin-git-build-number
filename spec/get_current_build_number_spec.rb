require 'spec_helper'

describe Fastlane::Actions::CurrentBuildNumberAction do
  before(:each) do
    allow(Fastlane::Actions).to receive(:sh).with("git rev-parse HEAD").and_return('')
    
    ##puts Fastlane.actions
  end
    
  describe 'Get current build number' do
    it "Parses the current build number correctly" do
      allow(Fastlane::Actions).to receive(:sh)
        .with("git ls-remote --tags --refs --quiet | grep `git rev-parse HEAD`", anything)
        .and_return("48082151e7efb50daa6ddb9c0486b80de36e8ea3	refs/tags/build/1071")
      
      result = Fastlane::FastFile.new.parse("lane :test do
        get_current_build_number
      end").runner.execute(:test)
    
      expect(result).to eq('1071')
    end

    it "Returns nil when no build number" do
      allow(Fastlane::Actions).to receive(:sh)
        .with("git ls-remote --tags --refs --quiet | grep `git rev-parse HEAD`", anything)
        .and_return('')
      
      result = Fastlane::FastFile.new.parse("lane :test do
        #get_current_build_number
      end").runner.execute(:test)
      
      expect(result).to eq(nil)
    end
    
    it "Works with multiple build numbers on same commit" do
      allow(Fastlane::Actions).to receive(:sh)
        .with("git ls-remote --tags --refs --quiet | grep `git rev-parse HEAD`", anything)
        .and_return("48082151e7efb50daa6ddb9c0486b80de36e8ea3	refs/tags/build/1071\n377ce4ab818ab5fa70bef02fd79aa23232369a58	refs/tags/build/1073\n7e40b9288c3272b1b876a6ea2f0bf8c8a83ace02	refs/tags/build/1072")
      
      result = Fastlane::FastFile.new.parse("lane :test do
        #get_current_build_number
      end").runner.execute(:test)
      
      expect(result).to eq('1073')
    end
  end
end
