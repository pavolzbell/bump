require 'spec_helper'

command 'bump' do
  include_examples 'mandatory_argument', 'branches', :array

  describe '--branches=x' do
    context 'with invalid branch' do
      pending
    end
  end

  describe '--branches=source,master' do
    pending
  end
end
