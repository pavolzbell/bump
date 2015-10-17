require 'spec_helper'

shared_examples_for 'release' do |schema, version|
  context "with #{schema} at #{version}" do
    before(:each) { load_sample_and_input }
    after(:each) { unload_sample }

    it('bumps major to 2.0.0') { expect(bump '--release major').to pin '2.0.0' }
    it('bumps minor to 1.3.0') { expect(bump '--release minor').to pin '1.3.0' }
    it('bumps patch to 1.2.4') { expect(bump '--release patch').to pin '1.2.4' }
    it('bumps to 1.2.3') { expect(bump '--release pre').to pin '1.2.3' }

    describe '--pre=rc1' do
      it('bumps major to 2.0.0 ignoring pre-release') { expect(bump '--release --pre rc1 major').to pin '2.0.0' }
      it('bumps minor to 1.3.0 ignoring pre-release') { expect(bump '--release --pre rc1 minor').to pin '1.3.0' }
      it('bumps patch to 1.2.4 ignoring pre-release') { expect(bump '--release --pre rc1 patch').to pin '1.2.4' }
      it('bumps to 1.2.3 ignoring pre-release') { expect(bump '--release --pre rc1 pre').to pin '1.2.3' }
    end
  end
end

command 'bump' do
  include_examples 'needless_argument', 'release'

  describe '--release' do
    include_examples 'release', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end

    include_examples 'release', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'config/version.rb' }
    end
  end
end
