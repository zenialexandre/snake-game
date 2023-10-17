math.randomseed(os.time())

_G.love = require "love"
require "helper"

local snake = require "Snake"
local fruit = require "Fruit"
local in_game_snake = snake()
local in_game_fruit = fruit()
local last_movement_direction = ""
local movement_direction = ""
local movement_speed = 5;

local game_properties = {
    state = {
        starting_point = true,
        paused = false,
        running = false,
        ended = false
    },
    fruits_eaten = 0
}

local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    massive = {
        font = love.graphics.newFont(60),
        size = 60
    }
}

function love.load()
    love.mouse.setVisible(false)
end

function love.update(dt)
    if game_properties.state["running"] then
        handle_movement_by_keyboard(in_game_snake, last_movement_direction, movement_direction, movement_speed)
        check_border_collision(game_properties, in_game_snake, movement_direction)
        check_eaten_fruit(in_game_snake, in_game_fruit, game_properties)
        handle_snake_segments(game_properties, in_game_snake)
        check_tail_collision(game_properties, in_game_snake)
    end
end

function love.keypressed(key)
    if key == "d" or key == "right" then
        last_movement_direction = movement_direction
        movement_direction = "right"
        handle_game_replay(game_properties, in_game_snake, in_game_fruit)
    elseif key == "a" or key == "left" then
        last_movement_direction = movement_direction
        movement_direction = "left"
        handle_game_replay(game_properties, in_game_snake, in_game_fruit)
    elseif key == "w" or key == "up" then
        last_movement_direction = movement_direction
        movement_direction = "up"
        handle_game_replay(game_properties, in_game_snake, in_game_fruit)
    elseif key == "s" or key == "down" then
        last_movement_direction = movement_direction
        movement_direction = "down"
        handle_game_replay(game_properties, in_game_snake, in_game_fruit)
    elseif key == "escape" then
        handle_game_pause(game_properties)
    elseif love.keyboard.isDown("lctrl", "=") then
        movement_speed = movement_speed + 5
    elseif love.keyboard.isDown("lctrl", "-") then
        movement_speed = movement_speed - 5
    end
end

function love.draw()
    love.graphics.setColor(0, 0.8, 0)
    love.graphics.rectangle("fill", in_game_snake.position_x, in_game_snake.position_y, in_game_snake.width, in_game_snake.height)

    if not rawequal(in_game_snake.tail_segments, nil) then
        for _, segment in ipairs(in_game_snake.tail_segments) do
            love.graphics.rectangle("fill", segment.position_x, segment.position_y,
                in_game_snake.width, in_game_snake.height, 5, 5)
        end
    end

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", in_game_fruit.position_x, in_game_fruit.position_y, in_game_fruit.width, in_game_fruit.height)

    check_game_state(game_properties, fonts)
end
