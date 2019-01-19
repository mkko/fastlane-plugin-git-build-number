describe Fastlane::Actions::ReserveBuildNumberAction do
  #describe '#run' do
  #  it "executes the correct git command" do
  #    #allow(Fastlane::Helper::GitBuildVersioningHelper).to receive(:is_git?).and_return(true)
  #    
  #    allow(Fastlane::Actions).to receive(:sh).with("git rev-parse HEAD").and_return('')
  #    allow(Fastlane::Actions).to receive(:sh).with("git ls-remote --tags --refs --quiet", anything).and_return('')
  #    
  #    # result = Fastlane::FastFile.new.parse("lane :test do
  #    #   git_tags
  #    # end").runner.execute(:test)
  #    
  #    result = Fastlane::Actions::ReserveBuildNumberAction.run(nil)
  #    
  #    expect(result).to eq([])
  #  end
  #  
  #  #it 'prints a message' do
  #  #  expect(Fastlane::UI).to receive(:message).with("is git")
  #  #
  #  #  Fastlane::Actions::GitBuildVersioningAction.run(nil)
  #  #end
  #end
end
