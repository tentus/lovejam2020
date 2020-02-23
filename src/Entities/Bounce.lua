-- responsible for forcing the map to load a new area
Bounce = Class{
    __includes = {Physical},
    classname = 'Bounce',

    image = love.graphics.newImage('assets/sprites/sparkle.png'),

    -- it takes a second before the contact can apply more force
    charge = 1,
}


function Bounce:init(world, object)
    self.force = object.properties.force or 900

    self.width = object.width
    self.height = object.height

    local x = object.x + (self.width / 2)

    self.particles = love.graphics.newParticleSystem(self.image)
    self.particles:setPosition(x, object.y + self.height - 8)
    self.particles:setEmissionRate(10)
    self.particles:setParticleLifetime(2)
    self.particles:setLinearAcceleration(0, -100, 0, -200)
    self.particles:setEmissionArea("uniform", self.width / 2, 0)
    self.particles:start()

    Physical.createBody(self, world, x, object.y + (self.height / 2))
end


function Bounce:update(dt)
    self.charge = self.charge + dt

    self.particles:update(dt)
end


function Bounce:draw()
    love.graphics.draw(self.particles)

    --[[for _, shape in ipairs(self.shapes) do
        love.graphics.polygon("line", {
            self.body:getWorldPoints(shape:getPoints())
        })
    end]]
end


function Bounce:makeShapes()
    return {
        love.physics.newRectangleShape(self.width, self.height)
    }
end


function Bounce:beginContact(other)
    if self.charge >= 1 then
        self.charge = 0
        local x = other.body:getLinearVelocity()
        other.body:setLinearVelocity(x, -self.force)
    end
end