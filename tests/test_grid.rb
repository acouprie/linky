require_relative '../lib/grid'
require 'test/unit'

class TestGrid < Test::Unit::TestCase
  def test_number_of_tiles
    lvl = Level.new
    tiles = lvl.create
    assert_equal(25,tiles.size) 
  end
end
