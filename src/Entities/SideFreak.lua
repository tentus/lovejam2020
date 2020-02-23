-- a static, damage-dealing object
SideFreak = Class{
    __includes = {Physical},
    classname = 'SideFreak',

    -- drawing stuff
    sprite = SpriteComponent('assets/sprites/side-freak.png'),

    speed = 128,
    direction = 1,
}


function SideFreak:init(world, object)
    self.speed = object.properties.speed or 128

    self.radius = object.height / 2
    self.limits = {
        left = object.x + self.radius,
        right = (object.x + object.width) - self.radius,
    }

    Physical.createBody(self, world, object.x + self.radius, object.y + self.radius)
end


function SideFreak:update(dt)
    local x, y = self:bodyPosition()

    x = x + ((self.speed * self.direction) * dt)
    if x < self.limits.left or x > self.limits.right then
        x = math.max(math.min(x, self.limits.right), self.limits.left)
        self.direction = self.direction * -1
    end

    self.body:setPosition(x, y)
end


function SideFreak:draw()
    local x, y = self:bodyPosition()
    --love.graphics.line(self.get)
    self.sprite:draw(x, y)
end


function SideFreak:beginContact(other)
    if other.damage then
        other:damage()
    end
end