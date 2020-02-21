SplashScene = {
    step = 0,
    time = {
        passed = 0,
        limit = 4,
        fade = 1,
    },
    logos = {
        SpriteComponent('assets/logos/beardville_logo.png'),
        SpriteComponent('assets/logos/love_logo.png'),
    },
}


function SplashScene:init()
    self:proceed()
end


function SplashScene:update(dt)
    self.time.passed = self.time.passed + dt
    if self.time.passed >= self.time.limit then
        self:proceed()
    elseif self.time.passed >= (self.time.limit - self.time.fade) and not Fader:isActive() then
        Fader:start(0, self.time.fade)
    end
end


function SplashScene:draw()
    local screenWidth, screenHeight = love.window.getMode()
    self.logos[self.step]:draw(
        (screenWidth / 2),
        (screenHeight / 2)
    )

    Fader:draw()
end


function SplashScene:keyreleased()
    self:proceed()
end


function SplashScene:proceed()
    if self.step < #self.logos then
        self.time.passed = 0
        self.step = self.step + 1
        Fader:start(1, self.time.fade)
    else
        Gamestate.switch(MenuScene)
    end
end
