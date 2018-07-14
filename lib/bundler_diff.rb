# frozen_string_literal: true

require 'parallel'
require 'bundler_diff/cli'
require 'bundler_diff/formatter/default'
require 'bundler_diff/formatter/md_table'
require 'bundler_diff/version'

module BundlerDiff
  def self.formatters
    @formatters ||= {
      default: Formatter::Default,
      md_table: Formatter::MdTable
    }
  end
end
