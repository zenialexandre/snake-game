local love = require "love"

function handle_movement_by_keyboard(in_game_snake, movement_direction)
    if movement_direction == "right" then
        in_game_snake.position_x = in_game_snake.position_x + 0.5
    elseif movement_direction == "left" then
        in_game_snake.position_x = in_game_snake.position_x - 0.5
    elseif movement_direction == "up" then
        in_game_snake.position_y = in_game_snake.position_y - 0.5
    elseif movement_direction == "down" then
        in_game_snake.position_y = in_game_snake.position_y + 0.5
    end
end

function check_border_collision(in_game_snake, movement_direction)
    if movement_direction == "right" and in_game_snake.position_x == love.graphics.getWidth() - in_game_snake.width then
        love.window.close()
    elseif movement_direction == "left" and in_game_snake.position_x == 0 then
        love.window.close()
    elseif movement_direction == "down" and in_game_snake.position_y == love.graphics.getHeight() - in_game_snake.height then
        love.window.close()
    elseif movement_direction == "up" and in_game_snake.position_y == 0 then
        love.window.close()
    end
end

function check_eaten_fruit(in_game_snake, in_game_fruit)
    if (in_game_snake.position_y + in_game_snake.height > in_game_fruit.position_y)
        and (in_game_snake.position_y < in_game_fruit.position_y + in_game_fruit.height)
        and (in_game_snake.position_x + in_game_snake.width > in_game_fruit.position_x)
        and (in_game_snake.position_x < in_game_fruit.position_x + in_game_fruit.width) then
        in_game_fruit.position_x = math.random(1, love.graphics.getWidth() / 1.25)
        in_game_fruit.position_y = math.random(1, love.graphics.getHeight() / 1.25)
    end
end
