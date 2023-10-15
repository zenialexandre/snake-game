math.randomseed(os.time())

_G.love = require "love"
require "helper"
local snake = require "Snake"
local fruit = require "Fruit"

local game = {
 state = {
  menu = true,
  paused = false,
  running = false,
  ended = false
 }
}

local in_game_snake = snake()
local in_game_fruit = fruit()
local movement_direction = ""

function love.load()
    love.mouse.setVisible(false)
end

function love.update(dt)
    handle_movement_by_keyboard(in_game_snake, movement_direction)
    check_border_collision(in_game_snake, movement_direction)
    check_eaten_fruit(in_game_snake, in_game_fruit)
end

function love.keypressed(key)
    if key == "d" or key == "right" then
        movement_direction = "right"
    elseif key == "a" or key == "left" then
        movement_direction = "left"
    elseif key == "w" or key == "up" then
        movement_direction = "up"
    elseif key == "s" or key == "down" then
        movement_direction = "down"
    end
end

function love.draw()
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.rectangle("fill", in_game_snake.position_x, in_game_snake.position_y, in_game_snake.width, in_game_snake.height)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", in_game_fruit.position_x, in_game_fruit.position_y, in_game_fruit.width, in_game_fruit.height)
end
