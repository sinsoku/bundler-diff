# frozen_string_literal: true
require 'bundler_diffgems/cli'
require 'bundler_diffgems/formatter/default'
require 'bundler_diffgems/formatter/md_table'
require 'bundler_diffgems/version'

module BundlerDiffgems
  def self.formatters
    @formatters ||= {
      default: Formatter::Default,
      md_table: Formatter::MdTable
    }
  end
end
