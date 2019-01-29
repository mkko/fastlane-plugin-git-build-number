require 'fastlane/action'
require_relative '../helper/git_build_versioning_helper'

module Fastlane
  module Actions

    class GetGitBuildNumberAction < Action
      def self.run(params)
        tag_prefix = (params[:tag_prefix] || 'build/')
        Helper::GitBuildVersioningHelper.current_build_number(tag_prefix)
      end

      def self.description
        "Use git for tagging your builds for unique distributed sequential build numbers"
      end

      def self.output
        [
          ['GIT_BUILD_NUMBER', 'The build number from git']
        ]
      end

      def self.authors
        ["Mikko Välimäki"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        <<-DETAILS
        DETAILS
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :tag_prefix,
                                  env_name: "GIT_BUILD_VERSIONING_TAG_PREFIX",
                               description: "A prefix to be used with tag names",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
