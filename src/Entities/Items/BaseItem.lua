BaseItem = Class{
    __includes = {Killable, Physical},
    classname = 'BaseItem',

    -- the size of our circular body and other physics properties
    radius = 16,
    isSensor = true,

    --death_audio = 'assets/audio/collect.ogg',

    -- sprite = SpriteComponent,
    bob = {
        rate = 0.25,
        position = 0,
        amplitude = 4,
    },
}


function BaseItem:init(world, object)
    Physical.createBody(self, world, object.x, object.y)
end


function BaseItem:update(dt)
    self.bob.position = self.bob.position + dt
end


function BaseItem:draw()
    if not self.dead then
        local x, y = self:bodyPosition()
        self.sprite:draw(x, y + (math.sin(self.bob.rate * self.bob.position) * self.bob.amplitude))
    end
end

