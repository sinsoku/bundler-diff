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
      output = JSON.dump(output) if @escape_json
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

    def parse_options! # rubocop:disable Metrics/MethodLength
      opt = OptionParser.new
      opt.banner = 'Usage: bundle diffgems [options]'
      opt.on('-c', '--commit COMMIT', 'Specify a commit') { |val| @commit = val }
      formatter_desc = [
        'Choose a formatter',
        '  default',
        '  md_table'
      ]
      opt.on('-f', '--format FORMATTER', *formatter_desc) { |val| @format = val.to_sym }
      opt.on('--escape-json', 'Escape output as a JSON string') do |val|
        @escape_json = val
      end
      opt.on('-v', '--version', 'Display the version') do
        puts BundlerDiff::VERSION
        exit
      end
      options = opt.parse(@args)
      @commit ||= options.shift
    end

    def set_access_token!
      access_token = GemsComparator.config.client.access_token || hub_token
      return if access_token.nil?

      GemsComparator.configure do |config|
        config.client = Octokit::Client.new(access_token: access_token)
      end
    end

    def hub_token
      hub_config_path = "#{ENV['HOME']}/.config/hub"
      return unless File.exist?(hub_config_path)

      yaml = YAML.load_file(hub_config_path)
      yaml.dig('github.com', 0, 'oauth_token')
    end

    def commit
      @commit || DEFAULT_OPTIONS[:commit]
    end

    def formatter
      format = @format || DEFAULT_OPTIONS[:format]
      BundlerDiff.formatters[format] || Formatter::Default
    end
  end
end
