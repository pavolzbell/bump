require 'spec_helper'

command 'bump' do
  include_examples 'needless_argument', 'tag', :boolean

  describe '--silent' do
    pending
  end

  describe '--no-silent' do
    pending
  end
end
