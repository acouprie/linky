require_relative '../lib/level'
require 'test/unit'

class TestLevel < Test::Unit::TestCase
  def test_create_level
    lvl = Level.new
    return true if lvl.create
    false
  end

  def test_valid_line
    lvl = Level.new
    lvl.create
    lvl.line = [lvl.grid.tiles[0], lvl.grid.tiles[23]]
    event = Ruby2D::Window::MouseEvent.new
    event.x = lvl.grid.tiles[23].x + 10
    event.y = lvl.grid.tiles[23].y + 10
    assert !lvl.remove_line(event)
  end

  def test_only_one_dot_line
    lvl = Level.new
    lvl.create
    assert lvl.line_check
  end

  def test_same_color
    lvl = Level.new
    color = Color.new('navy')
    lvl.send :same_color, color, color
  end

  def test_not_same_color
    lvl = Level.new
    color = Color.new('navy')
    color2 = Color.new('red')
    lvl.send :same_color, color, color2
  end
end
