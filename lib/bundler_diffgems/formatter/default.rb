# frozen_string_literal: true
module BundlerDiffgems
  module Formatter
    class Default
      def render(gems)
        gems.map { |gem| render_line(gem) }.join("\n")
      end

      private

      def render_line(gem)
        lines = []
        lines << format('%s: %s =>', gem[:name], gem[:before])
        lines << " #{gem[:after]}" if gem[:after].size.positive?
        lines << " - #{gem[:compare_url]}" if gem[:compare_url]
        lines.join
      end
    end
  end
end
