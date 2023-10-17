local love = require "love"

function Fruit()
    return {
        position_x = math.random(1, love.graphics.getWidth() / 1.35),
        position_y = math.random(1, love.graphics.getHeight() / 1.35),
        width = 25,
        height = 25
    }
end

return Fruit
