system File.expand_path '../fixtures/unpack', __FILE__
Dir.glob(File.expand_path '../support/*.rb', __FILE__).each { |f| require_relative f }
Dir.glob(File.expand_path '../**/concerns/*.rb', __FILE__).each { |f| require_relative f }
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'bump'
