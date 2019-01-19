require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GitTag
      def initialize(str, tag_prefix)
        # Instance variables
        @tag_prefix = tag_prefix
        @str = str
      end
  
      def hash
        @str.split('refs/tags/').first
      end
      
      def tag_name
        if self.is_build_number?
          @str.split('refs/tags/').last.delete_prefix(@tag_prefix)
        else
          nil
        end
      end
  
      def is_build_number?
        @str.split('refs/tags/').last.start_with?(@tag_prefix)
      end
    end  
    
    class GitBuildVersioningHelper
      def self.is_git?
        puts "is_git?"
        Actions.sh('git rev-parse HEAD')
        return true
      rescue
        return false
      end
      # class methods that you define here become available in your action
      # as `Helper::GitBuildVersioningHelper.your_method`
      #
      def self.reserve_build_number(tag_prefix)
        if self.is_git?
          puts "is_git? yes"
          builds = Actions.sh("git ls-remote --tags --refs --quiet", log: false)
          tags = builds.split( /\r?\n/ )
            .map { |s| GitTag.new(s, tag_prefix) }
            .select { |t| t.is_build_number? }
            .map { |t| t.tag_name }
            .sort
          
          puts builds
        else
          UI.user_error!("No git repository detected")
        end
      end
      
      def self.current_build_number(tag_prefix)
        if self.is_git?

          builds = Actions.sh("git ls-remote --tags --refs --quiet | grep `git rev-parse HEAD`", log: false)
          tags = builds.split( /\r?\n/ )
            .map { |s| GitTag.new(s, tag_prefix) }
            .select { |t| t.is_build_number? }
            .map { |t| t.tag_name }
            .sort
            
          tags.last
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
