describe Fastlane::Actions::GitBuildVersioningAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The git_build_versioning plugin is working!")

      Fastlane::Actions::GitBuildVersioningAction.run(nil)
    end
  end
end
