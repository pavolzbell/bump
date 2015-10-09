Dir.glob(File.expand_path '../fixtures/*.tgz', __FILE__).each { |f| `tar -xf #{f} && mv #{File.basename f, '.tgz'} spec/fixtures` unless File.exists?(f[0..-5]) }
Dir.glob(File.expand_path '../support/*.rb', __FILE__).each { |f| require_relative f }
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bump'
