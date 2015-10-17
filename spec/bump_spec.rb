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
  it 'has version number' do
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

  context 'with .bump in Git root' do
    before(:each) { load_empty_sample }
    after(:each) { unload_sample }

    it 'ignores arguments' do
      File.write '.bump', 'invalid-argument'
      expect(bump '--no-pull').to fail_with(stderr: "Already on 'master'\nbump: unable to compute path for gem schema")
    end

    it 'parses options' do
      File.write '.bump', '--invalid-option'
      expect(bump '--no-pull').to fail_with('invalid option: --invalid-option')
    end

    context 'with override from command line' do
      it 'honors actual arguments' do
        File.write '.bump', '--branches=x'
        expect(bump '--no-pull --branches=y').to fail_with(stderr: "error: pathspec 'y' did not match any file(s) known to git.")
      end

      it 'exits fast on invalid option' do
        File.write '.bump', '--invalid-option=x'
        expect(bump '--no-pull --invalid-option=y').to fail_with('invalid option: --invalid-option=x')
      end
    end
  end

  context 'with .bump in custom root' do
    pending
  end

  context 'with syntax' do
    let(:missing_argument) { 'bump: missing argument: %s' }
    let(:no_files_matched) { "error: pathspec '%s' did not match any file(s) known to git." }

    it '-o' do
      expect(bump '-b').to fail_with(stderr: missing_argument % '-b')
    end

    it '-ox' do
      expect(bump '-bx').to fail_with(stderr: no_files_matched % 'x')
    end

    it '-o x' do
      expect(bump '--b x').to fail_with(stderr: no_files_matched % 'x')
    end

    it '--opt' do
      expect(bump '--branches').to fail_with(stderr: missing_argument % '--branches')
    end

    it '--opt x' do
      expect(bump '--branches x').to fail_with(stderr: no_files_matched % 'x')
    end

    it '--opt=x' do
      expect(bump '--branches=x').to fail_with(stderr: no_files_matched % 'x')
    end
  end

  context 'with invalid arguments' do
    let(:sample) { 'gem-sample-1.2.3.rc0' }

    before(:each) { load_sample }
    after(:each) { unload_sample }

    it 'exists on too many arguments' do
      expect(bump 'major minor').to fail_with('too many arguments')
    end

    it 'exists on unknown arguments' do
      expect(bump 'invalid-argument').to fail_with('invalid argument: invalid-argument')
    end

    it 'exists on unknown options' do
      expect(bump '-X').to fail_with('invalid option: -X')
      expect(bump '-Xx').to fail_with('invalid option: -Xx')
      expect(bump '-X x').to fail_with('invalid option: -X')
      expect(bump '--invalid-option').to fail_with('invalid option: --invalid-option')
      expect(bump '--invalid-option x').to fail_with('invalid option: --invalid-option')
      expect(bump '--invalid-option=x').to fail_with('invalid option: --invalid-option=x')
    end
  end
end
