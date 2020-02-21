-- intended to a child of other entities, but is also handy directly in scenes
SpriteComponent = Class{
}


function SpriteComponent:init(imagePath)
    self.image = love.graphics.newImage(imagePath)

    -- set offsets for image drawing, since it won't change
    self.x = self.image:getWidth() / 2
    self.y = self.image:getHeight() / 2
end


function SpriteComponent:draw(x, y, flip)
    local sx, ox = 1, 0
    if flip then
        sx = -1
        ox = self.image:getWidth()
    end
    love.graphics.draw(self.image, x - self.x, y - self.y, 0, sx, 1, ox, 0)
end
