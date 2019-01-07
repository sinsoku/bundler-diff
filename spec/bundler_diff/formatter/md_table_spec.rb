# frozen_string_literal: true

require 'spec_helper'

module BundlerDiff
  RSpec.describe Formatter::MdTable do
    let(:formatter) { Formatter::MdTable.new }

    describe '#render' do
      RAKE_URL = 'https://github.com/ruby/rake/compare/v11.3.0...v12.0.0'
      WARNING_URL = 'https://github.com/sinsoku/warning_gem/compare/v0.1.0...master'

      let(:error_gem) do
        { name: 'error_gem',
          before: '0.1.0',
          after: '0.2.0',
          compare_url: 'RuntimeError' }
      end
      let(:rake_gem) do
        { name: 'rake',
          before: '11.3.0',
          after: '12.0.0',
          homepage: RAKE_URL,
          compare_url: RAKE_URL }
      end
      let(:rspec_gem) do
        { name: 'rspec',
          before: '3.5.0',
          after: '',
          compare_url: nil }
      end
      let(:warning_gem) do
        { name: 'warning_gem',
          before: '0.1.0',
          after: '0.2.0',
          compare_url: WARNING_URL }
      end
      let(:gems) { [error_gem, rake_gem, rspec_gem, warning_gem] }

      it 'should return output formatted as md_table' do
        expected = <<~TABLE.chomp
          | gem | before | after | compare |
          |---|---|---|---|
          | error_gem | 0.1.0 | 0.2.0 | :bug: RuntimeError |
          | [rake](#{RAKE_URL}) | 11.3.0 | 12.0.0 | [rake@ 11.3.0...12.0.0](#{RAKE_URL}) |
          | rspec | 3.5.0 |  | Failed to find projects GitHub URL |
          | warning_gem | 0.1.0 | 0.2.0 | :warning: [warning_gem@ 0.1.0...0.2.0](#{WARNING_URL}) |
        TABLE
        expect(formatter.render(gems)).to eq expected
      end
    end
  end
end
