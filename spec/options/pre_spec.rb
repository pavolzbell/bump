require 'spec_helper'

shared_examples_for 'pre' do |schema, version|
  context "with #{schema} at #{version}" do
    before(:each) { load_sample_and_input }
    after(:each) { unload_sample }

    it('strips pre-release bumping major to 2.0.0') { expect(bump '--pre "" major').to pin '2.0.0' }
    it('strips pre-release bumping minor to 1.3.0') { expect(bump '--pre "" minor').to pin '1.3.0' }
    it('strips pre-release bumping patch to 1.2.4') { expect(bump '--pre "" patch').to pin '1.2.4' }
    it('strips pre-release bumping to 1.2.3') { expect(bump '--pre "" pre').to pin '1.2.3' }
  end
end

shared_examples_for 'pre_rc1' do |schema, version|
  context "with #{schema} at #{version}" do
    before(:each) { load_sample_and_input }
    after(:each) { unload_sample }

    it('bumps major to 2.0.0.rc1') { expect(bump '--pre rc1 major').to pin '2.0.0.rc1' }
    it('bumps minor to 1.3.0.rc1') { expect(bump '--pre rc1 minor').to pin '1.3.0.rc1' }
    it('bumps patch to 1.2.4.rc1') { expect(bump '--pre rc1 patch').to pin '1.2.4.rc1' }
    it('bumps pre to 1.2.3.rc1') { expect(bump '--pre rc1 pre').to pin '1.2.3.rc1' }

    describe '--release' do
      it('ignores pre-release bumping major to 2.0.0') { expect(bump '--pre rc1 --release major').to pin '2.0.0' }
      it('ignores pre-release bumping minor to 1.3.0') { expect(bump '--pre rc1 --release minor').to pin '1.3.0' }
      it('ignores pre-release bumping patch to 1.2.4') { expect(bump '--pre rc1 --release patch').to pin '1.2.4' }
      it('ignores pre-release bumping to 1.2.3') { expect(bump '--pre rc1 --release pre').to pin '1.2.3' }
    end
  end
end

command 'bump' do
  describe '--pre=' do
    include_examples 'pre', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end

    include_examples 'pre', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'config/version.rb' }
    end
  end

  describe '--pre=rc1' do
    include_examples 'pre_rc1', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end

    include_examples 'pre_rc1', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'config/version.rb' }
    end
  end
end
