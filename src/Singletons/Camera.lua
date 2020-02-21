local function mid_screen()
    local width, height = love.window.getMode()
    return width / 2, height / 2
end

Camera = Class{
    x = 0,
    y = 0,
    speed = 16,     -- higher values mean we can keep up with the player better
    limit = 256,    -- max pixels per second (mostly applicable when teleporting)
    -- target = (should implement ":getTargetPosition()" pseudo interface)
}


function Camera:init(target)
    self.target = target
end


function Camera:update(dt)
    local tx, ty = self.target:getTargetPosition()

    local function pan(a, b, dt)
        return a + (math.min(math.max(b - a, -self.limit), self.limit) * self.speed * dt)
    end
    self.x = pan(self.x, tx, dt)
    self.y = pan(self.y, ty, dt)
end


function Camera:jump()
    self.x, self.y = self.target:getTargetPosition()
end


function Camera:translate()
    local width, height = mid_screen()
    return width - self.x, height - self.y
end


function Camera:onScreen(x, y)
    local width, height = mid_screen()
    return not (
        x < self.x - width or
        x > self.x + width or
        y < self.y - height or
        y > self.y + height
    )
end
