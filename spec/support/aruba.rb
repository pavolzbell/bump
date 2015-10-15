require 'aruba/rspec'

RSpec.configure do |c|
  c.alias_example_group_to :command, type: :aruba
end
