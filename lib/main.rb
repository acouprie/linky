require 'ruby2d'
require_relative 'level'

@down = false
level = Level.new
tiles = level.create

on :mouse do |event|
  case event.type
  when :move
    if @down
      level.mouse_down(event)
    end
  when :up
    @down = false
    level.remove_line(event)
  when :down
    @down = true
    level.mouse_down(event)
  end
  level.erase_line(event) if event.button == :right
end

update do
  level.win
end

level.show
