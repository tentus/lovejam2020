Health = Class{
    __includes = {BaseItem},
    classname = 'Health',
    sprite = SpriteComponent('assets/sprites/items/health.png'),

    death_audio = 'assets/sfx/quincy_Health.ogg',
}


function Health:beginContact(other)
    if other.classname == Player.classname then
        other:heal()
        self:kill()
        Stats:add('Health collected')
    end
end
