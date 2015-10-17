require 'spec_helper'

command 'bump' do
  include_examples 'mandatory_argument', 'file'

  describe '--file=x' do
    context 'with invalid file' do
      pending
    end
  end

  describe '--file=sample/file/version.rb' do
    pending

    describe '--input=sample/input/version.rb' do
      pending
    end

    describe '--output=sample/output/version.rb' do
      pending
    end
  end
end
