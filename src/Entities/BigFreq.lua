-- the most basic of enemies
-- technically brainless :D
BigFreak = Class {
    __includes = {Physical, Killable},
    classname = 'BigFreak',

     -- physics stuff
    bodyType = 'dynamic',
    radius = 63,

    -- moveDir reflects the orientation of the movement
    moveDir = 1,
    moveSpeed = 120,

    image = love.graphics.newImage('assets/sprites/big-freak.png'),
}

function BigFreak:init(world, object)
    local grid = anim8.newGrid(128, 128, self.image:getWidth(), self.image:getHeight())
    self.anim = anim8.newAnimation(grid(1,1, 2,1, 3,1), .2),

    Physical.createBody(self, world, object.x, object.y)
end


function BigFreak:update(dt)
    local _, yVel = self.body:getLinearVelocity()

    if self:shouldTurn(self.moveDir) then
        self:changeDir()
    end

    self.body:setLinearVelocity(self.moveDir * self.moveSpeed, yVel)

    self.anim.flippedH = (self.moveDir == 1)
    self.anim:update(dt)
end


function BigFreak:draw()
    local x, y = self:bodyPosition()
    self.anim:draw(self.image, x, y, 0, 1, 1, self.radius, self.radius)

    --love.graphics.circle("line", x, y, self.radius)
end


function BigFreak:shouldTurn(dir)
    local rayLength = 2
    local xOffset = self.radius * dir

    -- check if there is something in front of us, or nothing in front and below
    return self:castRay(0, 0, xOffset + (rayLength * dir), 0)
        or not self:castRay(xOffset, self.radius, xOffset, self.radius + rayLength)
end


function BigFreak:castRay(x1, y1, x2, y2)
    local hit = false
    local function rayCastCallback(fixture)
        -- ignore the player and plow into them
        hit = (fixture:getUserData().classname ~= Player.classname)

        return -1
    end

    local x, y = self.body:getPosition()

    self.body:getWorld():rayCast(
        x + x1, y + y1,
        x + x2, y + y2,
        rayCastCallback
    )
    return hit
end


function BigFreak:changeDir()
    local xVel, yVel = self.body:getLinearVelocity()

    -- dude can about-face very abruptly
    self.body:setLinearVelocity(-xVel / 2, yVel)

    self.moveDir = -self.moveDir
end


function BigFreak:beginContact(other)
    if other.damage then
        other:damage()
        self:changeDir()
    end
end