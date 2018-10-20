require 'ruby2d'

class Grid < Square
  attr_accessor :tiles
  attr_accessor :rows
  attr_accessor :columns
  
  def initialize
    @rows = 5
    @columns = 5
  end
end
