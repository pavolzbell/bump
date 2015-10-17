require 'spec_helper'

command 'bump' do
  include_examples 'needless_argument', 'tag', :boolean

  describe '--push' do
    pending
  end

  describe '--no-push' do
    pending
  end
end
