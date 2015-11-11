require 'spec_helper'

command 'bump' do
  include_examples 'mandatory_argument', 'input'

  describe '--input=x' do
    context 'with invalid input' do
      let(:sample) { 'gem-sample-1.2.3.rc0' }
      let(:fix) { "Already on 'master'\nbump: " }

      before(:each) { load_sample }
      after(:each) { unload_sample }

      it 'exists on empty file' do
        input = '%/inputs/gem-empty-file.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on missing module' do
        input = '%/inputs/gem-missing-module.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on incorrect module name' do
        input = '%/inputs/gem-incorrect-module-name.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on missing constant name' do
        input = '%/inputs/gem-missing-constant.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on incorrect constant name' do
        input = '%/inputs/gem-incorrect-constant-name.rb'
        stderr = "#{fix}unable to resolve #{relative_path input}"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on 2 version numbers' do
        input = '%/inputs/gem-2-version-numbers.rb'
        stderr = "#{fix}invalid version data: 1,2"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on 5 version nubmers' do
        input = '%/inputs/gem-5-version-numbers.rb'
        stderr = "#{fix}invalid version data: 1,2,3,4,5"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on missing number' do
        input = '%/inputs/gem-missing-major-number.rb'
        stderr = "#{fix}invalid version data: ,2,3"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on missing minor number' do
        input = '%/inputs/gem-missing-minor-number.rb'
        stderr = "#{fix}invalid version data: 1,,3"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end

      it 'exists on missing patch number' do
        input = '%/inputs/gem-missing-patch-number.rb'
        stderr = "#{fix}invalid version data: 1,2"
        expect(bump "--input '#{expand_path input}'").to fail_with(stderr: stderr)
      end
    end
  end

  describe '--input=sample/input/version.rb' do
    pending
  end
end
