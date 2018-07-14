# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BundlerDiff do
  describe '.formatters' do
    subject { BundlerDiff.formatters }
    it { is_expected.to include default: BundlerDiff::Formatter::Default }
    it { is_expected.to include md_table: BundlerDiff::Formatter::MdTable }
  end
end
