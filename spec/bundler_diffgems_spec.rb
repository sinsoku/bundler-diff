# frozen_string_literal: true
require 'spec_helper'

RSpec.describe BundlerDiffgems do
  describe '.formatters' do
    subject { BundlerDiffgems.formatters }
    it { is_expected.to include default: BundlerDiffgems::Formatter::Default }
    it { is_expected.to include md_table: BundlerDiffgems::Formatter::MdTable }
  end
end
