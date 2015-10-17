require 'spec_helper'

command 'bump' do
  include_examples 'mandatory_argument', 'output'

  describe '--output=x' do
    context 'with invalid output' do
      pending
    end
  end

  describe '--output=sample/output/version.rb' do
    pending
  end
end
