_G.love = require "love"

local game = {
 state = {
  menu = true,
  paused = false,
  running = false,
  ended = false
 }
}

function love.load()
 love.mouse.setVisible(true)
end

function love.update(dt)

end

function love.draw()

end
