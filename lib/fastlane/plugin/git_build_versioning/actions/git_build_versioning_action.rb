require 'fastlane/action'
require_relative '../helper/git_build_versioning_helper'

module Fastlane
  module Actions
    class GitBuildVersioningAction < Action
      def self.run(params)
        UI.message("The git_build_versioning plugin is working!")
      end

      def self.description
        "Use git for tagging your builds for distributed sequential builds"
      end

      def self.authors
        ["Mikko Välimäki"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This plugin will store build numbers as tags in the git repository. This makes it possible to create unique but reproducible builds in a distributed system. Storing build numbers in the git repository has several benefits over the traditional bump commits: each build is guaranteed to always have unique build number, the build numbers don't cause merge conflicts, it is very lightweight (when comparing to bump commits) and finally, it is highly visual as you can see your builds in the git history."
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "GIT_BUILD_VERSIONING_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
