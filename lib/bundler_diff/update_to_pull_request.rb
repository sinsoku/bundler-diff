# frozen_string_literal: true

module BundlerDiff
  class UpdateToPullRequest
    def self.invoke(args = ARGV)
      new(args).invoke
    end

    def initialize(args = [])
      @args = args
    end

    def invoke
      # TODO:
      #
      # $ bundle update
      # $ git add Gemfile.lock
      # $ git commit --author="foo <mail@example.com>
      # $ git push
      # $ curl -X POST :api_endpoint/repos/:owner/:repo/pulls
    end

    private

    def parse_options(args)
    end
  end
end
