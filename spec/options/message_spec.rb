require 'spec_helper'

shared_examples_for 'message_pattern' do |schema, version|
  context "with #{schema} at #{version}" do
    before(:each) { load_sample_and_input }
    after(:each) { unload_sample }

    it('bumps major to 2.0.0.rc0') { expect(bump '--message "%a %m-%n-%p-%r %v" major').to finish_with version: '2.0.0.rc0', message: 'Sample 2-0-0-rc0 2.0.0.rc0' }
    it('bumps minor to 1.3.0.rc0') { expect(bump '--message "%a %m-%n-%p-%r %v" minor').to finish_with version: '1.3.0.rc0', message: 'Sample 1-3-0-rc0 1.3.0.rc0' }
    it('bumps patch to 1.2.4.rc0') { expect(bump '--message "%a %m-%n-%p-%r %v" patch').to finish_with version: '1.2.4.rc0', message: 'Sample 1-2-4-rc0 1.2.4.rc0' }
    it('bumps pre to 1.2.3.rc1') { expect(bump '--message "%a %m-%n-%p-%r %v" pre').to finish_with version: '1.2.3.rc1', message: 'Sample 1-2-3-rc1 1.2.3.rc1' }

    describe '--name="%v"' do
      it('bumps major to 2.0.0.rc0') { expect(bump '--message "%a %m-%n-%p-%r %v" --name "%v" major').to finish_with version: '2.0.0.rc0', message: 'Sample 2-0-0-rc0 2.0.0.rc0', name: '2.0.0.rc0' }
      it('bumps minor to 1.3.0.rc0') { expect(bump '--message "%a %m-%n-%p-%r %v" --name "%v" minor').to finish_with version: '1.3.0.rc0', message: 'Sample 1-3-0-rc0 1.3.0.rc0', name: '1.3.0.rc0' }
      it('bumps patch to 1.2.4.rc0') { expect(bump '--message "%a %m-%n-%p-%r %v" --name "%v" patch').to finish_with version: '1.2.4.rc0', message: 'Sample 1-2-4-rc0 1.2.4.rc0', name: '1.2.4.rc0' }
      it('bumps pre to 1.2.3.rc1') { expect(bump '--message "%a %m-%n-%p-%r %v" --name "%v" pre').to finish_with version: '1.2.3.rc1', message: 'Sample 1-2-3-rc1 1.2.3.rc1', name: '1.2.3.rc1' }
    end
  end
end

command 'bump' do
  include_examples 'mandatory_argument', 'message'

  describe '--message=x' do
    context 'with invalid message' do
      pending
    end
  end

  describe '--message="%a %m-%n-%p-%r %v"' do
    include_examples 'message_pattern', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end

    include_examples 'message_pattern', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'config/version.rb' }
    end
  end
end
