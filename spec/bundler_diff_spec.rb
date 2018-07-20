# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundlerDiff do
  describe '.formatters' do
    subject { BundlerDiff.formatters }
    it { is_expected.to include default: BundlerDiff::Formatter::Default }
    it { is_expected.to include md_table: BundlerDiff::Formatter::MdTable }
  end

  describe '.parse_options' do
    context 'when args is "-c @^ -f md_table"' do
      subject { BundlerDiff.parse_options(%w[-c @^ -f md_table]) }
      it { is_expected.to include commit: '@^', format: :md_table }
    end

    context 'when args is "@^"' do
      subject { BundlerDiff.parse_options('@^') }
      it { is_expected.to include commit: '@^' }
    end

    context 'when args is "--escape_json"' do
      subject { BundlerDiff.parse_options('--escape_json') }
      it { is_expected.to include escape_json: true }
    end

    context 'when args is "--access-token abc"' do
      subject { BundlerDiff.parse_options(%w[--access-token abc]) }
      it { is_expected.to include access_token: 'abc' }
    end
  end
end
