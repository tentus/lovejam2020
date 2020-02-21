-- behavior for items which can be damaged
-- we can safely assume most Damagable things will also be Killable
Damagable = Class{
    health = 1,
    invincibility = {
        remaining = 0,
        duration = 1,
    }
}


function Damagable:update(dt)
    self.invincibility.remaining = self.invincibility.remaining - dt
end


function Damagable:invincible()
    return self.invincibility.remaining > 0
end


function Damagable:damage()
    if self:invincible() then return end

    self.health = self.health - 1

    if self.kill and self.health < 1 then
        self:kill()
    else
        -- todo: play damage sfx
        self.invincibility.remaining = self.invincibility.duration
    end
end
