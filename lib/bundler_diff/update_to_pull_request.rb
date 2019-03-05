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
      # repo = 'sinsoku/bundler-diff'
      # base = 'master'
      #
      # tree = client.create_tree(repo, [path: 'Gemfile.lock', mode: '100644', type: 'blob', content: content], base_tree: base_tree)
      # commit = client.create_commit(repo, "foo", tree.sha, ['a4c5b3c60cddccb9ede3559ca5d680da204f7f6b'])
      # branch = client.create_ref(repo, "heads/bar", commit.sha)
      # pr = client.create_pull_request(repo, base, branch.ref, 'title', body)
    end

    private

    def parse_options(args)
    end
  end
end

# require "bundler/cli"
# require "bundler/cli/update"
#
# Bundler::Definition.prepend(Module.new do
#   def lock(*)
#     contents = to_lock
#
#     # Convert to \r\n if the existing lock has them
#     # i.e., Windows with `git config core.autocrlf=true`
#     contents.gsub!(/\n/, "\r\n") if @lockfile_contents.match("\r\n")
#
#     if @lockfile_contents == contents
#       # diffがない
#     else
#       # prを作る
#     end
#   end
# end)
