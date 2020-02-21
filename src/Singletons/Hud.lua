local function hudImage(file)
    return love.graphics.newImage('assets/sprites/hud/' .. file)
end

Hud = {
    edge = 10,
    show = {
        health    = true,
        inventory = true,
        fps       = true,
    },
    images = {
        health  = hudImage('health_icon.png'),
        damage  = hudImage('damage_icon.png'),
        coin    = hudImage('coin_icon.png'),
    },
}


function Hud:toggle(which)
    self.show[which] = not self.show[which]
end


function Hud:draw()
    local spacing = 40

    -- health in top left
    if self.show.health then
        local player = WorldScene.player

        for i=1, player.maxHealth do
            local icon = ((player.health < i) and self.images.damage or self.images.health)
            love.graphics.draw(icon, ((i - 1) * spacing) + self.edge, self.edge)
        end
    end

    -- coins total in bottom left
    if self.show.inventory then
        local height = love.graphics.getHeight()

        love.graphics.push()
        love.graphics.translate(self.edge, height - self.edge)
        love.graphics.draw(self.images.coin, 0, -spacing)
        love.graphics.print('x ' .. Inventory:totalCoins(), spacing, 8 - spacing)
        love.graphics.pop()
    end
end


function Hud:drawFPS()
    if self.show.fps then
        local width, height = love.window.getMode()
        love.graphics.printf(love.timer.getFPS(), -self.edge, height - 20 - self.edge, width, "right")
    end
end


function Hud:changeEdge(delta)
    -- for now we assume the change is positive
    self.edge = (self.edge + delta) % 200
end
