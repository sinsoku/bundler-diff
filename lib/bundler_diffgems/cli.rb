# frozen_string_literal: true
require 'gems_comparator'
require 'json'
require 'optparse'

module BundlerDiffgems
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
    rescue => e
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
      opt = OptionParser.new
      opt.on('-c', '--comit=COMMIT') { |val| @commit = val }
      opt.on('-f', '--format=FORMATTER') { |val| @format = val.to_sym }
      opt.on('--escape-json') { |val| @escape_json = val }
      options = opt.parse(@args)
      @commit ||= options.shift
    end

    def set_access_token!
      return if GemsComparator.config.client.access_token
      hub_config_path = "#{ENV['HOME']}/.config/hub"
      return unless File.exist?(hub_config_path)

      yaml = YAML.load_file(hub_config_path)
      oauth_token = yaml.dig('github.com', 0, 'oauth_token')
      return if oauth_token.nil?
      GemsComparator.configure do |config|
        config.client = Octokit::Client.new(access_token: oauth_token)
      end
    end

    def commit
      @commit || DEFAULT_OPTIONS[:commit]
    end

    def formatter
      format = @format || DEFAULT_OPTIONS[:format]
      BundlerDiffgems.formatters[format] || Formatter::Default
    end
  end
end
