# @TODO
#
# add cursor movements (?)
#
require_relative 'grid'
require_relative 'tile'
require_relative 'levels/dots_position'

class Level < Window
  attr_accessor :grid, :line

  def draw_grid(level=nil)
    @level = level || 0
    set( { title: 'Linky', background: 'black', height: 640, width: 640 } )
    @grid = Grid.new(DOTS[@level])
    @line = []
    @tiles = @grid.tiles
  end
  
  def win
    return false unless find_tile_by_color(Color.new('navy')).empty?
    return self.close if DOTS[@level + 1].nil?
    self.clear
    self.draw_grid(@level + 1) 
  end

  def mouse_down(event)
    return unless event.type = :move || event.button == :left
    @tiles.each do |tile|
      free_tiles = find_tile_by_color(Color.new('navy'))
      draw_line(tile) if tile.contains?(event.x, event.y) && free_tiles.include?(tile)
    end
  end
  
  def draw_line(tile)
    return if @line.include?(tile)
    if draw_line_conditions(tile)
      @line << tile
    end
    color_tile
  end

  def color_tile
    return if @line.empty?
    dot_color = @line.first.dot.color
    @line.last.color = [dot_color.r, dot_color.g, dot_color.b, 0.5]
  end

  def erase_line(event)
    return unless event.button == :right
    line = []
    @tiles.each do |tile|
      if tile.contains?(event.x, event.y)
        line = find_tile_by_color(tile.color)
        line.each do |tile|
          tile.color = 'navy'
        end
        return true
      end
    end
    false
  end
   
  def remove_line(event)
    return if @line.empty?
    bool = false
    if @grid.out_of_grid(event) || line_check
      @line.each do |tile|
        tile.color = 'navy'
      end
      bool = true
    end
    @line.clear
    bool
  end 

  def line_check
    return true if @line.empty? ||
	    !same_color(@line.first&.dot&.color, @line.last&.dot&.color) ||
	    @line.first == @line.last
     false
  end

  private

  def beside(tile)
    return true if right_of(tile) || left_of(tile) || up_of(tile) || down_of(tile)
    false
  end

  def up_of(tile)
    return false if @line.last.nil?
    @tiles.index(@line.last) - @grid.grid_size == @tiles.index(tile)
  end
  
  def down_of(tile)
    return false if @line.last.nil?
    @tiles.index(@line.last) + @grid.grid_size == @tiles.index(tile)
  end
  
  def left_of(tile)
    return false if @line.last.nil?
    @tiles.index(@line.last) - 1 == @tiles.index(tile)
  end
  
  def right_of(tile)
    return false if @line.last.nil?
    @tiles.index(@line.last) + 1 == @tiles.index(tile)
  end

  def same_color(color_1, color_2)
    return false unless color_1 && color_2
    return true if color_1.r == color_2.r && color_1.b == color_2.b && color_1.g == color_2.g
    false
  end
  
  def find_tile_by_color(color)
    result = []
    @tiles.each do |tile|
      if same_color(color, tile.color)
        result << tile
      end
    end
    result
  end

  def draw_line_conditions(tile)
    return true if @line.empty? && !tile.dot.nil? ||
      beside(tile) &&
      (tile.dot.nil? ||
      same_color(@line.first&.dot&.color, tile&.dot&.color))
    false
  end
end
