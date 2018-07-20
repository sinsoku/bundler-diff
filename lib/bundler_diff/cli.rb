# frozen_string_literal: true

require 'gems_comparator'
require 'json'
require 'optparse'

module BundlerDiff
  class CLI
    DEFAULT_OPTIONS = {
      commit: 'HEAD',
      format: :default
    }.freeze

    def self.invoke(args = ARGV)
      new(args).invoke
    end

    def initialize(args = [])
      @args = args
    end

    def invoke
      parse_options!
      set_access_token!

      gems = GemsComparator.compare(before_lockfile, after_lockfile)
      output = formatter.new.render(gems)
      output = JSON.dump(output) if @options[:escape_json]
      puts output
    rescue StandardError => e
      puts e.inspect
    end

    private

    def file_name
      @file_name ||= File.exist?('gems.locked') ? 'gems.locked' : 'Gemfile.lock'
    end

    def before_lockfile
      `git show #{commit}:#{file_name}`.tap do
        raise unless $?.success? # rubocop:disable Style/SpecialGlobalVars
      end
    end

    def after_lockfile
      File.read(file_name)
    end

    def parse_options!
      @options = BundlerDiff.parse_options(@args)

      if @options.key?(:version)
        puts BundlerDiff::VERSION
        exit
      end
      @options[:commit] ||= DEFAULT_OPTIONS[:commit]
      @options[:format] ||= DEFAULT_OPTIONS[:format]
      @options[:access_token] ||=
        ENV['BUNDLER_DIFF_GITHUB_TOKEN'] || ENV['GITHUB_TOKEN'] || hub_token
    end

    def set_access_token!
      return if @options[:access_token].nil?

      GemsComparator.configure do |config|
        config.client = Octokit::Client.new(access_token: @options[:access_token])
      end
    end

    def hub_token
      hub_config_path = "#{ENV['HOME']}/.config/hub"
      return unless File.exist?(hub_config_path)

      yaml = YAML.load_file(hub_config_path)
      yaml.dig('github.com', 0, 'oauth_token')
    end

    def commit
      @options[:commit]
    end

    def formatter
      format = @options[:format]
      BundlerDiff.formatters[format] || Formatter::Default
    end
  end
end
