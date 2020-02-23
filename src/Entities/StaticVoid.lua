-- kills player when they phase through the ground/tiles into an area they shouldn't be
StaticVoid = Class{
    __includes = {Physical},
    classname = 'StaticVoid',

    isSensor = true,
    image = love.graphics.newImage('assets/sprites/static-void.png'),
}

function StaticVoid:init(world, object)
    self.name = object.name

    self.width = object.width
    self.height = object.height
    -- Sets the rectangle's dimensions
    self.image:setWrap("repeat", "repeat")
    self.quad = love.graphics.newQuad( 0, 0, self.width, self.height, self.image:getDimensions() )

    Physical.createBody(self, world, object.x + (self.width / 2), object.y + (self.height / 2))
end


function StaticVoid:makeShapes()
    return {
        love.physics.newRectangleShape(self.width, self.height)
    }
end

function StaticVoid:draw()
    love.graphics.draw(self.image, self.quad, self.body:getX() - (self.width / 2), self.body:getY() - (self.height / 2))
end


function StaticVoid:beginContact(other)
    if other.classname == Player.classname then
        -- todo: warp you back to the checkpoint on phase death in void
        other:damage()
    end
end