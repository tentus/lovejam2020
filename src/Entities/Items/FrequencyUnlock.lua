FrequencyUnlock = Class{
    __includes = {BaseItem, Collectible},
    classname = 'FrequencyUnlock',

    sprite = SpriteComponent('assets/sprites/items/unlock.png'),
}

function FrequencyUnlock:init(world, object)
    self.frequency = object.properties.frequency or 1

    BaseItem.init(self, world, object)
end


function FrequencyUnlock:beginContact(other)
    if other.classname == Player.classname then
        -- we're relying on the inventory system to avoid duplicate insertions
        table.insert(other.frequency.unlocked, self.frequency)

        Collectible.beginContact(self, other)
        self:kill()
    end
end
