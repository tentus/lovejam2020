-- encompasses both the physical side of the player and the meta side, such as inputs and health tracking
Player = Class{
    __includes = {Physical, Damagable, Killable},
    classname = 'Player',

    -- physics stuff
    bodyType = 'dynamic',
    radius = 31,
    jumps = {
        remaining = 0,
        max = 1,
    },

    walkForce = 500,
    jumpForce = 775,

    -- drawing stuff
    image = love.graphics.newImage('assets/sprites/player.png'),
    offsets = {},
    currentAnim = 'idle',
    flipped = false,
    anims = {},

    -- override default health
    health = 3,
    maxHealth = 5,
}


function Player:init()
    local gridsize = 128
    -- set offsets for image drawing, since it won't change
    self.offsets.x = gridsize * 0.5
    self.offsets.y = gridsize * 0.5

    local grid = anim8.newGrid(gridsize, gridsize, self.image:getWidth(), self.image:getHeight())
    self.anims = {
        idle = anim8.newAnimation(grid(1,1), .2),
        jump = anim8.newAnimation(grid(1,2), .2),
        walk = anim8.newAnimation(grid(1,3, 2,3, 3,3, 4,3), .2),
    }
end


function Player:update(dt)
    Damagable.update(self, dt)

    local xVel, yVel = self.body:getLinearVelocity()

    if (Bindings:pressed('a') or Bindings:pressed('up'))
        and self.jumps.remaining > 0 then
            self.jumps.remaining = self.jumps.remaining - 1
            self.body:applyLinearImpulse(0, -self.jumpForce)
    end

    local x = Bindings:get('move')
    if x ~= 0 and math.abs(xVel) < self.walkForce then
            self.body:applyForce(self.walkForce * x * 5, 0)
    else
        -- todo: this is an inelegant way to apply braking
        self.body:applyForce(-10 * xVel, 0)
    end

    -- update animation based on movement
    local threshold = 10

    if math.abs(yVel) > threshold then
        self.currentAnim = 'jump'
    elseif math.abs(xVel) > threshold then
        self.currentAnim = 'walk'
    else
        self.currentAnim = 'idle'
    end

    -- facing is separate from animation choosing, so it can be "carried" between animations, to avoid flickering
    if math.abs(xVel) > threshold then
        self.flipped = (xVel < 0)
    end

    self.anims[self.currentAnim].flippedH = self.flipped

    self.anims[self.currentAnim]:update(dt)
end


function Player:draw()
    -- if we're in the invincibility period, flash red
    if self:invincible() then
        love.graphics.setColor(1, 0, 0)
    end

    local x, y = self:bodyPosition()
    self.anims[self.currentAnim]:draw(self.image, x - self.offsets.x, y - self.offsets.y)

    if self:invincible() then
        love.graphics.setColor(1, 1, 1)
    end
end


function Player:beginContact()
    -- todo: this makes the assumption that any collision replenishes our jumps.
    -- we need to add logic to compare the body of the "other" to our own, and see if it's beneath us
    if self.jumps.remaining < self.jumps.max then
        self.jumps.remaining = self.jumps.remaining + 1
    end
end


function Player:createBody(world, x, y)
    Physical.createBody(self, world, x, y)

    self.body:setFixedRotation(true)
end


function Player:makeShapes()
    return {
        love.physics.newCircleShape(0, self.radius, self.radius),
        love.physics.newCircleShape(0, -self.radius, self.radius),
    }
end


function Player:getTargetPosition()
    -- this shouldn't happen, but an errant coord is better than a crash if the GC is running slow
    if not self.body or self.body:isDestroyed() then
        return 0, 0
    end
    return self:bodyPosition()
end


function Player:incrementHealth()
    self.maxHealth = self.maxHealth + 1
    self.health = self.maxHealth
end


function Player:heal()
    self.health = math.min(self.health + 1, self.maxHealth)
end


function Player:damage()
    Damagable.damage(self)
    Stats:add('Damage taken')
end


function Player:kill()
    Gamestate.push(DeathScene)
    Stats:add('Deaths')
end
