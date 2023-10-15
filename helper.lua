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
