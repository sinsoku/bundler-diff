# frozen_string_literal: true

require 'spec_helper'

module BundlerDiff
  RSpec.describe CLI do
    describe '#invoke' do
      RAKE_URL = 'https://github.com/ruby/rake/compare/v11.3.0...v12.0.0'

      let(:rake_gem) do
        { name: 'rake',
          before: '11.3.0',
          after: '12.0.0',
          compare_url: RAKE_URL }
      end
      let(:rspec_gem) do
        { name: 'rspec',
          before: '3.5.0',
          after: '',
          compare_url: nil }
      end
      let(:gems) { [rake_gem, rspec_gem] }
      let(:cli) { CLI.new }

      before do
        allow(cli).to receive(:before_lockfile) { 'before_lockfile' }
        allow(cli).to receive(:after_lockfile) { 'after_lockfile' }
        allow(GemsComparator).to receive(:compare) { gems }
      end

      it 'should display the gem changes' do
        expected = <<~CHANGES
          rake: 11.3.0 => 12.0.0 - #{RAKE_URL}
          rspec: 3.5.0 =>
        CHANGES
        expect { cli.invoke }.to output(expected).to_stdout
        expect(GemsComparator).to have_received(:compare)
          .with('before_lockfile', 'after_lockfile')
      end
    end
  end
end
