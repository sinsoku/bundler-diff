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
        compare_url = [icon_for(gem), url_for(gem)].compact.join ' '

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

      def state_for(gem)
        case gem[:compare_url]
        when /master$/
          :warning
        when URI::DEFAULT_PARSER.make_regexp
          :success
        when nil
          :failure
        else
          :error
        end
      end

      def icon_for(gem)
        case state_for(gem)
        when :warning
          ':warning:'
        when :success
          nil
        when :failure
          'Failed to find projects GitHub URL'
        else
          ':bug:'
        end
      end

      def url_for(gem)
        case state_for(gem)
        when :warning, :success
          before, after = gem.fetch_values(:before, :after)
          "[#{gem[:name]}@ #{before}...#{after}](#{gem[:compare_url]})"
        when :error
          gem[:compare_url]
        end
      end
    end
  end
end
