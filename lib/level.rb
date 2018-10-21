# @TODO
#
# add cursor movements (?)
#
require_relative 'grid'
require_relative 'tile'

class Level < Window
  attr_accessor :grid
  attr_accessor :line

  def create
    set( { title: 'Linky', background: 'black', height: 640, width: 640 } )
    self.grid = Grid.new(
      {
        dots: {
          red: [0, 23],
          yellow: [1, 12],
          blue: [8, 11],
          green: [16, 24]
        }
      } 
    )
    self.line = []
    tiles = self.grid.tiles
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
   
  def remove_line(event)
    return if self.line.empty?
    bool = false
    if self.grid.out_of_grid(event) || line_check
	    self.line.each do |tile|
        tile.color = 'navy'
      end
      bool = true
    end
    self.line.clear
    bool
  end 

  def line_check
    return true if self.line.empty? ||
	    !same_color(self.line.first&.dot&.color, self.line.last&.dot&.color) ||
	    self.line.first == self.line.last
     false
  end

  private

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

  def same_color(color_1, color_2)
    return false unless color_1 && color_2
    return true if color_1.r == color_2.r && color_1.b == color_2.b && color_1.g == color_2.g
    false
  end
end

