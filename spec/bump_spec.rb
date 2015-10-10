require 'ostruct'
require 'spec_helper'

Schema = BumpHelper::Schema

SCHEMAS = [
  Schema.new(:gem, path: 'lib/sample/version.rb'),
  Schema.new(:rails, path: 'config/version.rb')
]

describe Bump, type: :aruba do
  it 'has a version number' do
    expect(Bump::VERSION).not_to be nil
  end

  SCHEMAS.each do |schema|
    context "when initializing as #{schema}" do
      let(:init) { "#{schema}-sample-init" }
      let(:sample) { "#{schema}-sample-1.2.3.rc0" }
      let(:input) { schema.path }
      let(:output) { schema.path }

      after(:each) { unload_sample }

      it 'creates files' do
        load_empty_sample
        bump("--init=sample:Sample --schema=#{schema}").call
        expect(last_command_started).to be_successfully_executed
        expect('.bump').to have_same_file_content_like("%/#{init}/.bump")
        expect('bin/bump').to have_same_file_content_like("%/#{init}/bin/bump")
        expect(output).to have_same_file_content_like("%/#{init}/#{schema.path}")
      end

      context 'when files already exist' do
        it 'does not overwrite existing files' do
          load_sample
          bump("--init=sample:Sample --schema=#{schema}").call
          expect(last_command_started).to be_successfully_executed
          expect('.bump').to have_same_file_content_like("%/#{sample}/.bump")
          expect('bin/bump').to have_same_file_content_like("%/#{init}/bin/bump")
          expect(output).to have_same_file_content_like("%/#{sample}/#{schema.path}")
        end
      end
    end

    context "with #{schema}-sample-1.2.3.rc0" do
      let(:init) { "#{schema}-sample-init" }
      let(:sample) { "#{schema}-sample-1.2.3.rc0" }
      let(:input) { schema.path }
      let(:output) { schema.path }

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
      expect(bump 'major minor').to fail_with('too many arguments')
    end

    it 'exists on unknown arguments' do
      expect(bump 'pre-release').to fail_with('invalid argument: pre-release')
    end

    it 'exists on unknown options' do
      expect(bump '--unknown-option=hello').to fail_with('invalid option: --unknown-option=hello')
    end

    it 'exists on empty root' do
      expect(bump '--root=').to fail_with('invalid option: --root=')
    end

    it 'exists on non-existing root' do
      # TODO this probably needs some stderr message
      expect(bump '--root=hello').to fail_with status: 1
    end

    it 'exists on empty schema' do
      expect(bump '--schema=').to fail_with('invalid option: --schema=')
    end

    it 'exists on unknown schema' do
      expect(bump '--schema=hello').to fail_with('invalid option: --schema=hello')
    end

    context 'with invalid input' do
      let(:fix) { "Already on 'master'\nbump: " }

      it 'exists on empty file' do
        input = '%/inputs/gem-empty-file.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on missing module' do
        input = '%/inputs/gem-missing-module.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on incorrect module name' do
        input = '%/inputs/gem-incorrect-module-name.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on missing constant name' do
        input = '%/inputs/gem-missing-constant.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on incorrect constant name' do
        input = '%/inputs/gem-incorrect-constant-name.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on 2 version numbers' do
        input = '%/inputs/gem-2-version-numbers.rb'
        stderr = "#{fix}invalid version data: 1,2"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on 5 version nubmers' do
        input = '%/inputs/gem-5-version-numbers.rb'
        stderr = "#{fix}invalid version data: 1,2,3,4,5"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on missing major number' do
        input = '%/inputs/gem-missing-major-number.rb'
        stderr = "#{fix}invalid version data: ,2,3"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on missing minor number' do
        input = '%/inputs/gem-missing-minor-number.rb'
        stderr = "#{fix}invalid version data: 1,,3"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end

      it 'exists on missing patch number' do
        input = '%/inputs/gem-missing-patch-number.rb'
        stderr = "#{fix}invalid version data: 1,2"
        expect(bump "--input=#{expand_path input} major").to fail_with(stderr: stderr)
      end
    end
  end
end
