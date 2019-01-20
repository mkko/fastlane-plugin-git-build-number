require 'fastlane_core/ui/ui'

def number_or_nil(string)
  num = string.to_i
  num if num.to_s == string
end

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GitBuildTag
      def initialize(str, tag_prefix)
        # Instance variables
        @tag_prefix = tag_prefix
        @str = str
      end

      def hash
        (@str.split('refs/tags/').first || '').strip
      end

      def build_number
        if self.is_build_number?
          tag_name = @str.split('refs/tags/').last.delete_prefix(@tag_prefix)
          number_or_nil(tag_name)
        else
          nil
        end
      end

      def is_build_number?
        (@str.split('refs/tags/').last || '').start_with?(@tag_prefix)
      end

      def to_s
        "GitBuildTag<#{self.hash}, #{self.build_number}>"
      end
    end

    class GitBuildVersioningHelper
      def self.is_git?
        Actions.sh('git rev-parse HEAD', log: false)
        return true
      rescue
        return false
      end
      # class methods that you define here become available in your action
      # as `Helper::GitBuildVersioningHelper.your_method`
      #
      def self.reserve_build_number(tag_prefix)
        head = self.head
        tags = self.build_tags(tag_prefix)

        current = tags
          .select { |t| t.hash == head }
          .map { |t| t.build_number }
          .last

        if current == nil
          latest = tags
            .map { |t| t.build_number }
            .last
          current = (latest || 0) + 1
          
          tag_name = "#{tag_prefix}#{current}"
          Actions.sh("git tag #{tag_name} && git push --quiet origin #{tag_name}", log: false)
          UI.success("Tagging #{tag_name}")
        else
          UI.success("Current commit already tagged as build #{tag_name}")
        end
        
        current
      end

      def self.last_build_number(tag_prefix)
        self.build_tags(tag_prefix)
          .map { |t| t.build_number }
          .last
      end

      def self.current_build_number(tag_prefix)
        head = self.head
        tags = self.build_tags(tag_prefix)

        tags.select { |t| t.hash == head }
          .map { |t| t.build_number }
          .last
      end

      def self.head
        if self.is_git?
          head = Actions.sh("git rev-parse HEAD", log: false)
          (head || "").strip
        else
          UI.user_error!("No git repository detected")
        end
      end

      def self.build_tags(tag_prefix)
        if self.is_git?

          builds = Actions.sh("git ls-remote --tags --refs --quiet", log: false)
          tags = builds.split( /\r?\n/ )
            .map { |s| GitBuildTag.new(s, tag_prefix) }
            .select { |t| t.build_number != nil }
            .sort { |a,b| a.build_number <=> b.build_number }

          tags
        else
          UI.user_error!("No git repository detected")
        end
      end

      def self.show_message
        UI.message("Hello from the git_build_versioning plugin helper!")
      end
    end
  end
end
