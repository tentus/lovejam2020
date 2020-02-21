BaseItem = Class{
    __includes = {Killable, Physical},
    classname = 'BaseItem',

    -- the size of our circular body and other physics properties
    radius = 16,
    isSensor = true,

    --death_audio = 'assets/audio/collect.ogg',

    -- sprite = SpriteComponent,
}


function BaseItem:init(world, object)
    Physical.createBody(self, world, object.x, object.y)
end


function BaseItem:draw()
    if not self.dead then
        self.sprite:draw(self:bodyPosition())
    end
end

