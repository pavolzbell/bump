require 'ostruct'
require 'spec_helper'

class Setup < OpenStruct
end

describe Bump, type: :aruba do
  it 'has a version number' do
    expect(Bump::VERSION).not_to be nil
  end

  SETUPS = [
    Setup.new(sample: 'gem-sample-1.2.3.rc0', input: 'lib/sample/version.rb', output: 'lib/sample/version.rb'),
    Setup.new(sample: 'rails-sample-1.2.3.rc0', input: 'config/version.rb', output: 'config/version.rb')
  ].each do |s|
    context "with #{s.sample}" do
      let(:sample) { s.sample }
      let(:input) { s.input }
      let(:output) { s.output }

      before(:each) { load_sample_and_input }
      after(:each) { unload_sample }

      it('bumps major to 2.0.0.rc0') { expect(bump 'major').to pin '2.0.0.rc0' }
      it('bumps minor to 1.3.0.rc0') { expect(bump 'minor').to pin '1.3.0.rc0' }
      it('bumps patch to 1.2.4.rc0') { expect(bump 'patch').to pin '1.2.4.rc0' }
      it('bumps pre to 1.2.3.rc1') { expect(bump 'pre').to pin '1.2.3.rc1' }

      context 'when releasing' do
        it('bumps major to 2.0.0') { expect(bump '-r major').to pin '2.0.0' }
        it('bumps minor to 1.3.0') { expect(bump '-r minor').to pin '1.3.0' }
        it('bumps patch to 1.2.4') { expect(bump '-r patch').to pin '1.2.4' }
        it('bumps to 1.2.3') { expect(bump '-r pre').to pin '1.2.3' }

        context 'when also trying to pre-release as rc1' do
          it('bumps major to 2.0.0 ignoring pre-release') { expect(bump '-r -p rc1 major').to pin '2.0.0' }
          it('bumps minor to 1.3.0 ignoring pre-release') { expect(bump '-r -p rc1 minor').to pin '1.3.0' }
          it('bumps patch to 1.2.4 ignoring pre-release') { expect(bump '-r -p rc1 patch').to pin '1.2.4' }
          it('bumps to 1.2.3 ignoring pre-release') { expect(bump '-r -p rc1 pre').to pin '1.2.3' }
        end
      end

      context 'when pre-releasing as rc1' do
        it('bumps major to 2.0.0.rc1') { expect(bump '-p rc1 major').to pin '2.0.0.rc1' }
        it('bumps minor to 1.3.0.rc1') { expect(bump '-p rc1 minor').to pin '1.3.0.rc1' }
        it('bumps patch to 1.2.4.rc1') { expect(bump '-p rc1 patch').to pin '1.2.4.rc1' }
        it('bumps pre to 1.2.3.rc1') { expect(bump '-p rc1 pre').to pin '1.2.3.rc1' }

        context 'when also trying to release' do
          it('ignores pre-release bumping major to 2.0.0') { expect(bump '-p rc1 -r major').to pin '2.0.0' }
          it('ignores pre-release bumping minor to 1.3.0') { expect(bump '-p rc1 -r minor').to pin '1.3.0' }
          it('ignores pre-release bumping patch to 1.2.4') { expect(bump '-p rc1 -r patch').to pin '1.2.4' }
          it('ignores pre-release bumping to 1.2.3') { expect(bump '-p rc1 -r pre').to pin '1.2.3' }
        end
      end

      context 'with empty pre-release' do
        it('strips pre-release bumping major to 2.0.0') { expect(bump '-p "" major').to pin '2.0.0' }
        it('strips pre-release bumping minor to 1.3.0') { expect(bump '-p "" minor').to pin '1.3.0' }
        it('strips pre-release bumping patch to 1.2.4') { expect(bump '-p "" patch').to pin '1.2.4' }
        it('strips pre-release bumping to 1.2.3') { expect(bump '-p "" pre').to pin '1.2.3' }
      end

      context 'with custom commit message' do
        it('bumps major to 2.0.0.rc0') { expect(bump '-m "Hello %a %m-%n-%p-%r %v" major').to finish_with version: '2.0.0.rc0', message: 'Hello Sample 2-0-0-rc0 2.0.0.rc0' }
        it('bumps minor to 1.3.0.rc0') { expect(bump '-m "Hello %a %m-%n-%p-%r %v" minor').to finish_with version: '1.3.0.rc0', message: 'Hello Sample 1-3-0-rc0 1.3.0.rc0' }
        it('bumps patch to 1.2.4.rc0') { expect(bump '-m "Hello %a %m-%n-%p-%r %v" patch').to finish_with version: '1.2.4.rc0', message: 'Hello Sample 1-2-4-rc0 1.2.4.rc0' }
        it('bumps pre to 1.2.3.rc1') { expect(bump '-m "Hello %a %m-%n-%p-%r %v" pre').to finish_with version: '1.2.3.rc1', message: 'Hello Sample 1-2-3-rc1 1.2.3.rc1' }
      end

      context 'with custom tag name' do
        it('bumps major to 2.0.0.rc0') { expect(bump '-n "Hello_%a_%m-%n-%p-%r_%v" major').to finish_with version: '2.0.0.rc0', name: 'Hello_Sample_2-0-0-rc0_2.0.0.rc0' }
        it('bumps minor to 1.3.0.rc0') { expect(bump '-n "Hello_%a_%m-%n-%p-%r_%v" minor').to finish_with version: '1.3.0.rc0', name: 'Hello_Sample_1-3-0-rc0_1.3.0.rc0' }
        it('bumps patch to 1.2.4.rc0') { expect(bump '-n "Hello_%a_%m-%n-%p-%r_%v" patch').to finish_with version: '1.2.4.rc0', name: 'Hello_Sample_1-2-4-rc0_1.2.4.rc0' }
        it('bumps pre to 1.2.3.rc1') { expect(bump '-n "Hello_%a_%m-%n-%p-%r_%v" pre').to finish_with version: '1.2.3.rc1', name: 'Hello_Sample_1-2-3-rc1_1.2.3.rc1' }
      end

      context 'when both custom commit message and tag name' do
        it('bumps major to 2.0.0.rc0') { expect(bump '-m "%a %m-%n-%p-%r" -n "%v" major').to finish_with version: '2.0.0.rc0', message: 'Sample 2-0-0-rc0', name: '2.0.0.rc0' }
        it('bumps minor to 1.3.0.rc0') { expect(bump '-m "%a %m-%n-%p-%r" -n "%v" minor').to finish_with version: '1.3.0.rc0', message: 'Sample 1-3-0-rc0', name: '1.3.0.rc0' }
        it('bumps patch to 1.2.4.rc0') { expect(bump '-m "%a %m-%n-%p-%r" -n "%v" patch').to finish_with version: '1.2.4.rc0', message: 'Sample 1-2-4-rc0', name: '1.2.4.rc0' }
        it('bumps pre to 1.2.3.rc1') { expect(bump '-m "%a %m-%n-%p-%r" -n "%v" pre').to finish_with version: '1.2.3.rc1', message: 'Sample 1-2-3-rc1', name: '1.2.3.rc1' }
      end
    end
  end

  context 'with invalid arguments' do
    let(:sample) { 'gem-sample-1.2.3.rc0' }

    before(:each) { load_sample }
    after(:each) { unload_sample }

    it 'exists on too many arguments' do
      expect(bump 'major minor').to fail_on('too many arguments')
    end

    it 'exists on unknown arguments' do
      expect(bump 'pre-release').to fail_on('invalid argument: pre-release')
    end

    it 'exists on unknown options' do
      expect(bump '--unknown-option=hello').to fail_on('invalid option: --unknown-option=hello')
    end

    it 'exists on empty root' do
      # TODO this probably needs some stderr message
      expect(bump '--root=').to fail_with status: 1
    end

    it 'exists on non-existing root' do
      # TODO this probably needs some stderr message
      expect(bump '--root=hello').to fail_with status: 1
    end

    it 'exists on empty schema' do
      expect(bump '--schema=').to fail_on('invalid option: --schema=')
    end

    it 'exists on unknown schema' do
      expect(bump '--schema=hello').to fail_on('invalid option: --schema=hello')
    end

    context 'with invalid input' do
      def args(input)
        "--schema=gem --input=#{expand_path "gem-#{input}"} major"
      end

      # TODO these probably need some stderr messages
      it('exists on empty file') { expect(bump args('empty-file')).to fail_with status: 1 }
      it('exists on inlined file') { expect(bump args('inlined-file')).to fail_with status: 1 }
      it('exists on missing module name') { expect(bump args('missing-module-name')).to fail_with status: 1 }
      it('exists on incorrect constant name') { expect(bump args('incorrect-constant-name')).to fail_with status: 1 }
      it('exists on 2 version numbers') { expect(bump args('2-version-numbers')).to fail_with status: 1 }
      it('exists on 5 vrsion numbers') { expect(bump args('5-version-numbers')).to fail_with status: 1 }
    end
  end
end
