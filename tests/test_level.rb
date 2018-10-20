require_relative '../lib/level'
require 'test/unit'

class TestLevel < Test::Unit::TestCase
  def test_create_level
    lvl = Level.new
    return true if lvl.create
    false
  end
end
