require 'spec_helper'

command 'bump' do
  include_examples 'needless_argument', 'tag', :boolean

  describe '--pull' do
    pending
  end

  describe '--no-pull' do
    pending
  end
end
