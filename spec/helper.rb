here = File.dirname(__FILE__)
gamebox_root = File.expand_path(File.join(here, '..', 'lib'))

require File.join(File.dirname(__FILE__),'..', 'lib', 'gamebox')
RSpec.configure do |config|
  config.mock_with :mocha
end
