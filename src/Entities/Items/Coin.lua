Coin = Class{
    __includes = {BaseItem},
    classname = 'Coin',

    sprite = SpriteComponent('assets/sprites/items/coin.png'),

    death_audio = 'assets/sfx/quincy_Coin.ogg',
}


function Coin:beginContact(other)
    Inventory:collectCoins(1)
    self:kill()
end
