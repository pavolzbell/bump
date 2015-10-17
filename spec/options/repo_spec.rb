require 'spec_helper'

command 'bump' do
  include_examples 'mandatory_argument', 'repo'

  describe '--repo=x' do
    context 'with invalid repository' do
      pending
    end
  end

  describe '--repo=target' do
    pending
  end
end
