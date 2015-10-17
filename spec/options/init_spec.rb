require 'spec_helper'

shared_examples_for 'init' do |application, schema|
  after(:each) { unload_sample }

  it 'creates files' do
    load_empty_sample
    bump("--init #{application} #{"--schema #{schema}" if schema}").call
    expect(last_command_started).to be_successfully_executed
    expect('.bump').to have_same_file_content_like("%/#{desire}/.bump")
    expect('bin/bump').to have_same_file_content_like("%/#{desire}/bin/bump")
    expect(output).to have_same_file_content_like("%/#{desire}/#{input}")
  end

  context 'when files already exist' do
    it 'does not overwrite existing files' do
      load_sample
      bump("--init #{application} #{"--schema #{schema}" if schema}").call
      expect(last_command_started).to be_successfully_executed
      expect('.bump').to have_same_file_content_like("%/#{sample}/.bump")
      expect('bin/bump').to have_same_file_content_like("%/#{desire}/bin/bump")
      expect(output).to have_same_file_content_like("%/#{sample}/#{input}")
    end
  end
end

command 'bump' do
  include_examples 'mandatory_argument', 'init'

  describe '--init=x' do
    context 'with invalid target' do
      pending
    end
  end

  describe '--init=sample:Sample' do
    include_examples 'init', 'sample:Sample' do
      let(:desire) { 'gem-sample-init' }
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end

    describe '--root=sample/target' do
      pending
    end
  end

  describe '--init=sample:Sample --schema=gem' do
    include_examples 'init', 'sample:Sample', 'gem' do
      let(:desire) { 'gem-sample-init' }
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:input) { 'lib/sample/version.rb' }
      let(:output) { 'lib/sample/version.rb' }
    end
  end

  describe '--init=sample:Sample --schema=rails' do
    include_examples 'init', 'sample:Sample', 'rails' do
      let(:desire) { 'rails-sample-init' }
      let(:sample) { 'rails-sample-1.2.3.rc0' }
      let(:input) { 'config/version.rb' }
      let(:output) { 'config/version.rb' }
    end
  end
end
