require 'test_helper'

class RailspackTest < Minitest::Test
  def test_has_a_version
    assert_equal Railspack::VERSION, '0.1.0'
  end
end
