require 'spec_helper'

shared_examples_for 'root' do |schema, version|
  context "with #{schema} at #{version} in my/application" do
    before(:each) { load_sample && Dir['*'].each { |f| FileUtils.mkpath(root) && FileUtils.mv(f, root) }}
    after(:each) { unload_sample }

    it('bumps major to 2.0.0.rc0') { expect(bump "--root=#{root} major").to pin '2.0.0.rc0' }
  end
end

command 'bump' do
  describe '--root' do
    it 'exists on empty root' do
      expect(bump '--root=').to fail_with('invalid option: --root=')
    end
  end

  describe '--root=x' do
    it 'exists on non-existing root' do
      # TODO this probably needs some stderr message
      expect(bump '--root=x').to fail_with status: 1
    end
  end

  describe '--root=my/application' do
    include_examples 'root', 'gem', '1.2.3.rc0' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:root) { 'my/application' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'my/application/lib/sample/version.rb' }
    end

    include_examples 'root', 'rails', '1.2.3.rc0' do
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:root) { 'my/application' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'my/application/config/version.rb' }
    end
  end
end
