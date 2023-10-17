local love = require "love"
local snake = require "Snake"

function change_game_state(game_properties, new_state)
    game_properties.state["starting_point"] = new_state == "starting_point"
    game_properties.state["paused"] = new_state == "paused"
    game_properties.state["running"] = new_state == "running"
    game_properties.state["ended"] = new_state == "ended"
end

function handle_movement_by_keyboard(in_game_snake, movement_direction, movement_speed)
    if movement_direction == "right" then
        in_game_snake.position_x = in_game_snake.position_x + movement_speed
    elseif movement_direction == "left" then
        in_game_snake.position_x = in_game_snake.position_x - movement_speed
    elseif movement_direction == "up" then
        in_game_snake.position_y = in_game_snake.position_y - movement_speed
    elseif movement_direction == "down" then
        in_game_snake.position_y = in_game_snake.position_y + movement_speed
    end
end

function handle_game_replay(game_properties, in_game_snake, in_game_fruit)
    if game_properties.state["ended"] then
        clean_tail_segments(in_game_snake)
        game_properties.fruits_eaten = 0
        in_game_snake.position_x = 380
        in_game_snake.position_y = 280
        in_game_fruit.position_x = math.random(1, love.graphics.getWidth() / 1.25)
        in_game_fruit.position_y = math.random(1, love.graphics.getWidth() / 1.25)
        change_game_state(game_properties, "running")
    else
        change_game_state(game_properties, "running")
    end
end

function handle_game_pause(game_properties)
    if game_properties.state["running"] then
        change_game_state(game_properties, "paused")
    end
end

function handle_snake_segments(game_properties, in_game_snake)
    local snake_old_position_x = in_game_snake.position_x
    local snake_old_position_y = in_game_snake.position_y

    if not rawequal(in_game_snake.tail_segments, nil) then
        for _, segment in ipairs(in_game_snake.tail_segments) do
            local temp_x, temp_y = segment.position_x, segment.position_y
            segment.position_x, segment.position_y = snake_old_position_x, snake_old_position_y
            snake_old_position_x, snake_old_position_y = temp_x, temp_y
        end
    end
end

function check_border_collision(game_properties, in_game_snake, movement_direction)
    if movement_direction == "right" and in_game_snake.position_x == love.graphics.getWidth() - in_game_snake.width then
        change_game_state(game_properties, "ended")
    elseif movement_direction == "left" and in_game_snake.position_x == 0 then
        change_game_state(game_properties, "ended")
    elseif movement_direction == "down" and in_game_snake.position_y == love.graphics.getHeight() - in_game_snake.height then
        change_game_state(game_properties, "ended")
    elseif movement_direction == "up" and in_game_snake.position_y == 0 then
        change_game_state(game_properties, "ended")
    end
end

function check_tail_collision(game_properties, in_game_snake, movement_direction)
    if not rawequal(in_game_snake.tail_segments, nil) then
        for index = 10, #in_game_snake.tail_segments do
            if check_generic_object_collision(in_game_snake, in_game_snake.tail_segments[index]) then
                change_game_state(game_properties, "ended")
            end
        end
    end
end

function check_eaten_fruit(in_game_snake, in_game_fruit, game_properties)
    if check_generic_object_collision(in_game_snake, in_game_fruit) then
        local tail_segment = snake()
        tail_segment.width, tail_segment.height = 25, 25
        tail_segment.position_x, tail_segment.position_y = 0, 0
        in_game_fruit.position_x = math.random(1, love.graphics.getWidth() / 1.10)
        in_game_fruit.position_y = math.random(1, love.graphics.getHeight() / 1.10)
        game_properties.fruits_eaten = game_properties.fruits_eaten + 1
        table.insert(in_game_snake.tail_segments, tail_segment)
    end
end

function check_game_state(game_properties, fonts)
    if game_properties.state["starting_point"] then
        love.graphics.printf("Press a movement key to begin.", fonts.large.font, 0, 50, love.graphics.getWidth(), "center")
    elseif game_properties.state["paused"] then
        love.graphics.printf("Paused, press a movement key to continue.", fonts.large.font, 0, 50, love.graphics.getWidth(), "center")
        love.graphics.printf("Fruits eaten: " .. game_properties.fruits_eaten, fonts.medium.font, 0, 90, love.graphics.getWidth(), "center")
    elseif game_properties.state["ended"] then
        love.graphics.setFont(fonts.large.font)
        love.graphics.printf("Game Ended! :(", fonts.large.font, 0, 50, love.graphics.getWidth(), "center")
        love.graphics.printf("You eated " .. game_properties.fruits_eaten .. " fruits.", fonts.medium.font, 0, 90, love.graphics.getWidth(), "center")
        love.graphics.printf("Press any movement key to replay it.", fonts.medium.font, 0, 120, love.graphics.getWidth(), "center")
    end
end

function check_generic_object_collision(first_actor, second_actor)
    return (first_actor.position_y + first_actor.height > second_actor.position_y)
        and (first_actor.position_y < second_actor.position_y + second_actor.height)
        and (first_actor.position_x + first_actor.width > second_actor.position_x)
        and (first_actor.position_x < second_actor.position_x + second_actor.width)
end

function clean_tail_segments(in_game_snake)
    if not rawequal(in_game_snake.tail_segments, nil) then
        for index, _ in ipairs(in_game_snake.tail_segments) do
            in_game_snake.tail_segments[index] = nil
        end
    end
end
