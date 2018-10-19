require 'ruby2d'

set title: 'Linky', background: 'black', height: 640, width: 640

# grid values
@starting_point_x = 60
@starting_point_y = 60
@rows = 5
@columns = 5

# tiles values
@tile_size = 100
@tile_margin = 2

# Circles radius is equal to 66% of the size of a tile
@radius = @tile_size - (@tile_size * 0.66)

# collections of objects
@tiles = []
@dots = []
@line = []

# mouse events
@down = false

class Tile < Square
  attr_accessor :dot
end

def draw_grid
  y = @starting_point_y
  @columns.times do
    x = @starting_point_x
    @rows.times do
      @tiles << Tile.new(
        x: x,
	y: y,
        size: @tile_size,
        color: 'navy',
      )
      x += @tile_size + @tile_margin
    end
    y += @tile_size + @tile_margin
  end
end

def tile_center_position(tile)
  x = tile.x + (@tile_size / 2)
  y = tile.y + (@tile_size / 2)
  [x, y]
end

def draw_dot(tiles, color)
  tiles.each do |tile|
    instanciate_dot(tile, color)
  end
end

def instanciate_dot(tile, color)
  points = tile_center_position(tile)
  points_x = points[0]
  points_y = points[1]
  if (@dots << Circle.new(
      x: points_x,
      y: points_y,
      radius: @radius,
      sectors: 32,
      color: color,
    ))
    tile.dot = @dots.last
  end
end

draw_grid
draw_dot([@tiles[0], @tiles[23]], 'red')
draw_dot([@tiles[1], @tiles[12]], 'yellow')
draw_dot([@tiles[8], @tiles[11]], 'blue')
draw_dot([@tiles[16], @tiles[24]], 'green')

on :mouse do |event|
  case event.type
  when :move
    down(event)
  when :up
    @down = false
    mouse_up(event)
  when :down
    @down = true
  end
end

def down(event)
  return unless @down == true
  @tiles.each do |tile|
    if (event.x > tile.x && event.x < tile.x + @tile_size) &&
       (event.y > tile.y && event.y < tile.y + @tile_size)
      draw_line(tile)
    end
  end
end

def draw_line(tile)
  return if @line.include?(tile)
  if (@line.empty? && !tile.dot.nil?) || right_of(tile) || left_of(tile) || up_of(tile) || down_of(tile)
    @line << tile
  end
  return if @line.empty?
  dot_color = @line.first.dot.color
  @line.each do |tile|
    #next unless tile.dot.nil?
    tile.color = [dot_color.r, dot_color.g, dot_color.b, 0.5]
  end
end

def up_of(tile)
  return false if @line.last.nil?
  @tiles.index(@line.last) - @rows == @tiles.index(tile)
end

def down_of(tile)
  return false if @line.last.nil?
  @tiles.index(@line.last) + @rows == @tiles.index(tile)
end

def left_of(tile)
  return false if @line.last.nil?
  @tiles.index(@line.last) - 1 == @tiles.index(tile)
end

def right_of(tile)
  return false if @line.last.nil?
  @tiles.index(@line.last) + 1 == @tiles.index(tile)
end

def mouse_up(event)
  return if @line.empty?
  if out_of_grid(event) || @line.last.dot.nil? || !same_color(@line.first&.dot&.color, @line.last&.dot&.color)
    remove_line
  end
end

def same_color(color_1, color_2)
  return false unless color_1 && color_2
  return true if color_1.r == color_2.r && color_1.b == color_2.b && color_1.g == color_2.g
  false
end

def out_of_grid(event)
  return true if event.x < @starting_point_x ||
    event.y < @starting_point_y ||
    event.x > (@tile_size + @tile_margin) * @rows ||
    event.y > (@tile_size + @tile_margin) * @columns
  false
end

def remove_line
  @line.each do |tile|
    tile.color = 'navy'
  end
  @line.clear
end

show
