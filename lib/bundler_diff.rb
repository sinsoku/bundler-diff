# frozen_string_literal: true

require 'parallel'
require 'bundler_diff/cli'
require 'bundler_diff/formatter/default'
require 'bundler_diff/formatter/md_table'
require 'bundler_diff/version'

module BundlerDiff
  class << self
    def formatters
      @formatters ||= {
        default: Formatter::Default,
        md_table: Formatter::MdTable
      }
    end

    def parse_options(args) # rubocop:disable Metrics/MethodLength
      options = {}

      opt = OptionParser.new
      opt.banner = 'Usage: bundle diffgems [options]'
      opt.on('-c', '--commit COMMIT', 'Specify a commit') { |val| options[:commit] = val }
      formatter_desc = [
        'Choose a formatter',
        '  default',
        '  md_table'
      ]
      opt.on('-f', '--format FORMATTER', *formatter_desc) do |val|
        options[:format] = val.to_sym
      end
      opt.on('--escape-json', 'Escape output as a JSON string') do |val|
        options[:escape_json] = val
      end
      opt.on('--access-token ACCESS_TOKEN', 'Set access token for GitHub API') do |val|
        options[:access_token] = val
      end

      opt.on('-v', '--version', 'Display the version') { options[:version] = true }

      remaining_args = opt.parse(args)
      options[:commit] ||= remaining_args.shift
      options
    end
  end
end
