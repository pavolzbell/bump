require 'ostruct'
require 'spec_helper'

shared_examples_for 'bump' do |schema, version|
  context "with #{schema} at #{version}" do
    before(:each) { load_sample_and_input }
    after(:each) { unload_sample }

    it('bumps major to 2.0.0.rc0') { expect(bump 'major').to pin '2.0.0.rc0' }
    it('bumps minor to 1.3.0.rc0') { expect(bump 'minor').to pin '1.3.0.rc0' }
    it('bumps patch to 1.2.4.rc0') { expect(bump 'patch').to pin '1.2.4.rc0' }
    it('bumps pre to 1.2.3.rc1') { expect(bump 'pre').to pin '1.2.3.rc1' }
  end
end

command 'bump' do
  it 'has a version number' do
    expect(Bump::VERSION).not_to be nil
  end

  include_examples 'bump', 'gem', '1.2.3.rc0' do
    let(:sample) { 'gem-sample-1.2.3.rc0' }
    let(:input) { 'lib/sample/version.rb' }
    let(:output) { 'lib/sample/version.rb' }
  end

  include_examples 'bump', 'rails', '1.2.3.rc0' do
    let(:sample) { 'rails-sample-1.2.3.rc0' }
    let(:input) { 'config/version.rb' }
    let(:output) { 'config/version.rb' }
  end

  context 'with invalid arguments' do
    let(:sample) { 'gem-sample-1.2.3.rc0' }

    before(:each) { load_sample }
    after(:each) { unload_sample }

    it 'exists on too many arguments' do
      expect(bump 'major minor').to fail_with('too many arguments')
    end

    it 'exists on unknown arguments' do
      expect(bump 'pre-release').to fail_with('invalid argument: pre-release')
    end

    it 'exists on unknown options' do
      expect(bump '--unknown-option=hello').to fail_with('invalid option: --unknown-option=hello')
    end
  end
end
