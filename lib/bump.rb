require 'bump/version'

module Bump
  def self.run(*args)
    `#{File.expand_path '../../bin/bump', __FILE__} #{args * ' '} 2> /dev/null`
  end
end
