Fader = {
    increment = 0,
    alpha = 0,
}


function Fader:update(dt)
    if self:isActive() then
        self.alpha = math.max(math.min(self.alpha + (self.increment * dt), 1), 0)

        if (self.alpha == 0 and self.increment < 0) or (self.alpha == 1 and self.increment > 0) then
            self.increment = 0
        end
    end
end


function Fader:draw()
    if self.alpha ~= 0 then
        local colors = {love.graphics.getColor()}
        local width, height = love.window.getMode()
        love.graphics.setColor(0, 0, 0, self.alpha)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(colors)
    end
end


function Fader:start(alpha, duration)
    self.alpha = alpha or 1
    self.increment = 1 / (duration or 1)
    if alpha > 0.5 then
        self.increment = -self.increment
    end
end


function Fader:isActive()
    return self.increment ~= 0
end
