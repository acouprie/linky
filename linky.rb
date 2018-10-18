require 'ruby2d'

set title: 'Linky', background: 'black', height: 640, width: 640

@tile_size = 100
@tile_margin = 2
@starting_point_x = 60
@starting_point_y = 60
@rows = 5
@columns = 5
# Circles radius is equal to 66% of the size of a tile
@radius = @tile_size - (@tile_size * 0.66)
@tiles = []
@dots = []
@line = []

# mouse
@move = false
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

def draw_dot(tiles)
  tiles.each do |tile|
    instanciate_dot(tile)
  end
end

def instanciate_dot(tile)
  points = tile_center_position(tile)
  points_x = points[0]
  points_y = points[1]
  if (@dots << Circle.new(
      x: points_x,
      y: points_y,
      radius: @radius,
      sectors: 32,
      color: 'red',
    ))
    tile.dot = @dots.last
  end
end

draw_grid
draw_dot([@tiles[1]])
draw_dot([@tiles[3]])

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
  @line << tile
  @line.each do |tile|
    tile.color = 'red'
  end
end

def mouse_up(event)
  @tiles.each do |tile|
    if (event.x > tile.x && event.x < tile.x + @tile_size) &&
      (event.y > tile.y && event.y < tile.y + @tile_size) && tile.dot.nil?
      remove_line
    end
  end 
end

def remove_line
  @line.each do |tile|
    tile.color = 'navy'
  end
  @line.clear
end

show
