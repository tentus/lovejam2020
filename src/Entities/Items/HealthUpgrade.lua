HealthUpgrade = Class{
    __includes = {BaseItem, Collectible},
    classname = 'HealthUpgrade',

    sprite = SpriteComponent('assets/sprites/items/health_upgrade.png'),
}


function HealthUpgrade:beginContact(other)
    if other.classname == Player.classname then
        other:incrementHealth()
        Collectible.beginContact(self, other)
        self:kill()
    end
end
