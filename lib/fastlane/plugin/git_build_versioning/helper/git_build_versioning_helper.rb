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
        full_name = @str.split('refs/tags/').last
        m = full_name.match(/^#{@tag_prefix}(\d+)$/)
        if m && m[1]
          number_or_nil(m[1])
        end
      end

      def is_build_number?
        build_number != nil
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
                  .map(&:build_number)
                  .last

        if current.nil?
          latest = tags
                   .map(&:build_number)
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
            .map(&:build_number)
            .last
      end

      def self.current_build_number(tag_prefix)
        head = self.head
        tags = self.build_tags(tag_prefix)

        tags.select { |t| t.hash == head }
            .map(&:build_number)
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
          tags = builds.split(/\r?\n/)
                       .map { |s| GitBuildTag.new(s, tag_prefix) }
                       .reject { |t| t.build_number.nil? }
                       .sort_by(&:build_number)

          tags
        else
          UI.user_error!("No git repository detected")
        end
      end
    end
  end
end
