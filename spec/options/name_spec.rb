require 'spec_helper'

shared_examples_for 'name_pattern' do |schema, version|
  context "with #{schema} at #{version}" do
    before(:each) { load_sample_and_input }
    after(:each) { unload_sample }

    it('bumps major to 2.0.0.rc0') { expect(bump '--name "%a_%m-%n-%p-%r_%v" major').to finish_with version: '2.0.0.rc0', name: 'Sample_2-0-0-rc0_2.0.0.rc0' }
    it('bumps minor to 1.3.0.rc0') { expect(bump '--name "%a_%m-%n-%p-%r_%v" minor').to finish_with version: '1.3.0.rc0', name: 'Sample_1-3-0-rc0_1.3.0.rc0' }
    it('bumps patch to 1.2.4.rc0') { expect(bump '--name "%a_%m-%n-%p-%r_%v" patch').to finish_with version: '1.2.4.rc0', name: 'Sample_1-2-4-rc0_1.2.4.rc0' }
    it('bumps pre to 1.2.3.rc1') { expect(bump '--name "%a_%m-%n-%p-%r_%v" pre').to finish_with version: '1.2.3.rc1', name: 'Sample_1-2-3-rc1_1.2.3.rc1' }

    describe '--message="%v"' do
      it('bumps major to 2.0.0.rc0') { expect(bump '--name "%a_%m-%n-%p-%r_%v" --message "%v" major').to finish_with version: '2.0.0.rc0', name: 'Sample_2-0-0-rc0_2.0.0.rc0', message: '2.0.0.rc0' }
      it('bumps minor to 1.3.0.rc0') { expect(bump '--name "%a_%m-%n-%p-%r_%v" --message "%v" minor').to finish_with version: '1.3.0.rc0', name: 'Sample_1-3-0-rc0_1.3.0.rc0', message: '1.3.0.rc0' }
      it('bumps patch to 1.2.4.rc0') { expect(bump '--name "%a_%m-%n-%p-%r_%v" --message "%v" patch').to finish_with version: '1.2.4.rc0', name: 'Sample_1-2-4-rc0_1.2.4.rc0', message: '1.2.4.rc0' }
      it('bumps pre to 1.2.3.rc1') { expect(bump '--name "%a_%m-%n-%p-%r_%v" --message "%v" pre').to finish_with version: '1.2.3.rc1', name: 'Sample_1-2-3-rc1_1.2.3.rc1', message: '1.2.3.rc1' }
    end
  end
end

command 'bump' do
  describe '--name=' do
    pending
  end

  describe '--name="%a %v"' do
    pending
  end

  describe '--name="%a_%m-%n-%p-%r_%v' do
    include_examples 'name_pattern', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end

    include_examples 'name_pattern', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'config/version.rb' }
    end
  end
end
