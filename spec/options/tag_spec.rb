require 'spec_helper'

command 'bump' do
  include_examples 'needless_argument', 'tag', :boolean

  describe '--tag' do
    pending
  end

  describe '--no-tag' do
    pending
  end
end
