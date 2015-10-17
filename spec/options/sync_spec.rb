require 'spec_helper'

# TODO consider adding --sync as an alias for both pull & push

command 'bump' do
  include_examples 'needless_argument', 'tag', :boolean

  describe '--sync' do
    pending
  end

  describe '--no-sync' do
    pending
  end
end
