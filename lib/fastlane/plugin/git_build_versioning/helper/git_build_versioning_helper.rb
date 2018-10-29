require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GitBuildVersioningHelper
      # class methods that you define here become available in your action
      # as `Helper::GitBuildVersioningHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the git_build_versioning plugin helper!")
      end
    end
  end
end
