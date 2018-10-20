# @TODO
#
# add cursor movements (?)
#
require_relative 'grid'
require_relative 'tile'

class Level < Window
  attr_accessor :grid
  attr_accessor :line

  def draw_grid(y, x, tile_size, margin)
    tiles = []
    starting_x = x
    self.grid.columns.times do
      x = starting_x
      self.grid.rows.times do
        tiles << Tile.new(
          x: x,
  	  y: y,
          size: tile_size,
          color: 'navy'
	)
        x += tile_size + margin
      end
      y += tile_size + margin
    end
    dots = {
        red: [tiles[0], tiles[23]],
        yellow: [tiles[1], tiles[12]],
        blue: [tiles[8], tiles[11]],
        green: [tiles[16], tiles[24]]
       }
    draw_dot(dots)
    tiles
  end
  
  def tile_center_position(tile)
    x = tile.x + (tile.size / 2)
    y = tile.y + (tile.size / 2)
    [x, y]
  end
  
  def draw_dot(dots)
    dots.each do |key, value|
      color = key.to_s
      value.each do |tile|
        instanciate_dot(tile, color)
      end
    end
  end
  
  def instanciate_dot(tile, color)
    points = tile_center_position(tile)
    points_x = points[0]
    points_y = points[1]
      tile.dot = Circle.new(
        x: points_x,
        y: points_y,
	radius: 33,
        sectors: 32,
        color: color,
      )
  end
  
  
  def mouse_down(event)
    type = event.type.to_s
    return unless type = 'move' || type = 'down'
    self.grid.tiles.each do |tile|
      if (event.x > tile.x && event.x < tile.x + tile.size) &&
         (event.y > tile.y && event.y < tile.y + tile.size)
        draw_line(tile)
      end
    end
  end
  
  def draw_line(tile)
    return if self.line.include?(tile)
    if (self.line.empty? && !tile.dot.nil?) || right_of(tile) || left_of(tile) || up_of(tile) || down_of(tile)
      self.line << tile
    end
    return if self.line.empty?
    dot_color = self.line.first.dot.color
    self.line.last.color = [dot_color.r, dot_color.g, dot_color.b, 0.5]
  end
  
  def up_of(tile)
    return false if self.line.last.nil?
    self.grid.tiles.index(self.line.last) - self.grid.rows == self.grid.tiles.index(tile)
  end
  
  def down_of(tile)
    return false if self.line.last.nil?
    self.grid.tiles.index(self.line.last) + self.grid.rows == self.grid.tiles.index(tile)
  end
  
  def left_of(tile)
    return false if self.line.last.nil?
    self.grid.tiles.index(self.line.last) - 1 == self.grid.tiles.index(tile)
  end
  
  def right_of(tile)
    return false if self.line.last.nil?
    self.grid.tiles.index(self.line.last) + 1 == self.grid.tiles.index(tile)
  end
  
  def mouse_up(event)
    return if self.line.empty?
    if out_of_grid(event) || self.line.last.dot.nil? || !same_color(self.line.first&.dot&.color, self.line.last&.dot&.color)
      remove_line
    else
      valid_line
    end
  end
  
  def same_color(color_1, color_2)
    return false unless color_1 && color_2
    return true if color_1.r == color_2.r && color_1.b == color_2.b && color_1.g == color_2.g
    false
  end
  
  def out_of_grid(event)
    self.grid.tiles.each do |tile|
      if tile.contains? event.x, event.y
	return false
      else
        true
      end
    end
  end
  
  def valid_line
    self.line.clear
  end
  
  def remove_line
    self.line.each do |tile|
      tile.color = 'navy'
    end
    self.line.clear
  end

  def create
    set( { title: 'Linky', background: 'black', height: 640, width: 640 } )
    grid = Grid.new
    self.grid = grid
    self.line = []
    self.grid.tiles = draw_grid(60, 60, 100, 2)
  end
end

