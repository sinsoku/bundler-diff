# frozen_string_literal: true

module BundlerDiff
  module Formatter
    class MdTable
      ITEMS = %w[gem before after compare].freeze
      HEADER = "| #{ITEMS.join(' | ')} |"
      HR = "#{'|---' * ITEMS.size}|"
      TEMPLATE = "#{'| %s ' * ITEMS.size}|"

      def render(gems)
        rows = gems.map { |gem| render_row(gem) }
        [HEADER, HR, *rows].join("\n")
      end

      private

      def render_row(gem)
        name = format_name(gem)
        before, after = gem.fetch_values(:before, :after)
        compare_url = "#{icon_for(gem)} #{url_for(gem)}"

        format TEMPLATE, name, before, after, compare_url
      end

      def format_name(gem)
        url = gem[:homepage] || gem[:github_url]
        if url
          "[#{gem[:name]}](#{url})"
        else
          gem[:name]
        end
      end

      def icon_for(gem)
        case gem[:compare_url]
        when /master$/
          ':warning:'
        when URI::DEFAULT_PARSER.make_regexp
          ':white_check_mark:'
        when nil
          ':x:'
        else
          ':bug:'
        end
      end

      def url_for(gem)
        case icon_for(gem)
        when ':warning:', ':white_check_mark:'
          before, after = gem.fetch_values(:before, :after)
          "[#{gem[:name]}@ #{before}...#{after}](#{gem[:compare_url]})"
        when ':bug:'
          gem[:compare_url]
        else
          ''
        end
      end
    end
  end
end
