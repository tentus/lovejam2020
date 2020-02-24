CreditsScene = {
    speed = 100,
    logo = SpriteComponent('assets/logos/game_logo.png'),
    text = [[

Adrianna Reifinger
@wryloaf

Brian Donovan
@smoothieviceroy

Grace Mauro
@giglet_grace

Ian Murray

Thomas Holden
@tsholden

Tyler Weisman


Powered by Love
love2d.org



anim8 and inspect by Enrique García Cota
github.com/kikito/anim8
github.com/kikito/inspect.lua

Baton by Andrew Minnich
github.com/tesselode/baton

hump by Matthias Richter
github.com/vrld/hump

lovebird by rxi
github.com/rxi/lovebird

Simple Tiled Implementation by Landon Manning
github.com/karai17/Simple-Tiled-Implementation



Thank you for playing!
]]
}


function CreditsScene:enter()
    self.y = love.graphics.getHeight() + (self.logo.y * 2)
    local _, count = string.gsub(self.text, '\n', '')
    self.limit = count * -18
end


function CreditsScene:update(dt)
    dt = self.speed * dt
    if Bindings:down('up') then
        dt = -dt
    end
    if Bindings:down('a') or Bindings:down('down') then
        dt = dt * 2
    end

    self.y = self.y - dt

    if self.y < self.limit or Bindings:down('b') then
        Gamestate.pop()
    end
end


function CreditsScene:draw()
    local width = love.graphics.getWidth()
    self.logo:draw(width / 2, math.floor(self.y) - self.logo.y)
    love.graphics.printf(self.text, 0, math.floor(self.y), width, "center")
end
