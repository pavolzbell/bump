require 'spec_helper'

shared_examples_for 'root' do |schema, version|
  context "with #{schema} at #{version} in my/application" do
    before(:each) { load_sample && Dir['*'].each { |f| FileUtils.mkpath(root) && FileUtils.mv(f, root) }}
    after(:each) { unload_sample }

    it('bumps major to 2.0.0.rc0') { expect(bump "--root='#{root}' major").to pin '2.0.0.rc0' }
  end
end

command 'bump' do
  include_examples 'mandatory_argument', 'root'

  describe '--root=x' do
    context 'with invalid root' do
      it 'exists on non-existing root' do
        # TODO this probably needs some stderr message
        expect(bump '--root=x major').to fail_with status: 1
      end
    end
  end

  describe '--root=sample/target' do
    include_examples 'root', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:root) { 'sample/target' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'sample/target/lib/sample/version.rb' }
    end

    include_examples 'root', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:root) { 'sample/target' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'sample/target/config/version.rb' }
    end
  end
end
