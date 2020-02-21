DeathScene = {
    image = SpriteComponent('assets/logos/you_died.png'),

    -- measured in seconds
    fadeLength = 3,
}

function DeathScene:enter(from)
    self.from = from -- persist previous scene
    self.alpha = 0
    Fader:start(0, 3)
end

function DeathScene:update(dt)
    self.alpha = self.alpha + (dt / self.fadeLength)
end

function DeathScene:draw()
    -- draw underlying screen
    self.from:draw()

    love.graphics.setColor(1,1,1, math.min(self.alpha, 1))
    self.image:draw(
        (love.graphics.getWidth() / 2),
        (love.graphics.getHeight() / 2)
    )
    love.graphics.setColor(1, 1, 1)
end

function DeathScene:keyreleased()
    WorldScene:init()
    Gamestate.pop()
end

