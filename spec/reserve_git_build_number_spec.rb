require 'spec_helper'

tags = <<-eos
4a49d1e1a9173fdb61779152a68ce7c0e65dde3e	refs/tags/build/67
4a49d1e1a9173fdb61779152a68ce7c0e65dde3e	refs/tags/build/68
9fb11431ae504fcc48f3c0fc34322bf7ac0be13e	refs/tags/build/69
2b12bd9e1b50c369eceda350a2741aeca7ea1c91	refs/tags/build/70
48082151e7efb50daa6ddb9c0486b80de36e8ea3	refs/tags/build/71
7e40b9288c3272b1b876a6ea2f0bf8c8a83ace02	refs/tags/build/72
377ce4ab818ab5fa70bef02fd79aa23232369a58	refs/tags/build/73
eos

describe Fastlane::Actions::ReserveGitBuildNumberAction do
  before(:each) do
    allow(Fastlane::Actions).to receive(:sh)
      .with("git ls-remote --tags --refs --quiet", anything)
      .and_return(tags)
  end

  describe 'Reserve build number' do
    it "Returns current build if there's one" do

      allow(Fastlane::Actions).to receive(:sh).with("git rev-parse HEAD", anything)
        .and_return('48082151e7efb50daa6ddb9c0486b80de36e8ea3')

      result = Fastlane::FastFile.new.parse("lane :test do
        reserve_build_number
      end").runner.execute(:test)

      expect(result).to eq(71)
    end

    it "Works with multiple build numbers on same commit" do
      allow(Fastlane::Actions).to receive(:sh).with("git rev-parse HEAD", anything)
        .and_return('4a49d1e1a9173fdb61779152a68ce7c0e65dde3e')

      result = Fastlane::FastFile.new.parse("lane :test do
        reserve_build_number
      end").runner.execute(:test)

      expect(result).to eq(68)
    end

    it "Returns new build number when no current build" do
      expected_build = 74
      expected_tag = "build/#{expected_build}"

      allow(Fastlane::Actions).to receive(:sh).with("git rev-parse HEAD", anything)
        .and_return('954a29b7a3e69433d080a950be20550f6e2b1306')

      allow(Fastlane::Actions).to receive(:sh).with("git rev-parse HEAD", anything)
        .and_return('954a29b7a3e69433d080a950be20550f6e2b1306')

      expect(Fastlane::Actions::AddGitTagAction).to receive(:run)
        .with(tag: expected_tag)

      expect(Fastlane::Actions::PushGitTagsAction).to receive(:run)
        .with(tag: expected_tag)

      result = Fastlane::FastFile.new.parse("lane :test do
        reserve_build_number
      end").runner.execute(:test)

      expect(result).to eq(74)
    end
  end
end
