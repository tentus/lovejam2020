
Checkpoint = Class {
    __includes = {Physical},
    classname = 'Checkpoint',

    isSensor = true,
    isOn = false,
    image = love.graphics.newImage('assets/sprites/static-void.png'),
}


function Checkpoint:init(world, object)
    self.name = object.name

    print(object.width)
    self.width = object.width
    self.height = object.height
    -- Sets the rectangle's dimensions
    self.quad = love.graphics.newQuad( 0, 0, self.width, self.height, self.image:getDimensions())

    Physical.createBody(self, world, object.x + (self.width / 2), object.y + (self.height / 2))
end


function Checkpoint:makeShapes()
    return {
        love.physics.newRectangleShape(self.width, self.height)
    }
end


function Checkpoint:draw()
    return {
        love.physics.newRectangleShape(self.width, self.height)
    }
end


function Checkpoint:beginContact(other)
    local x, y = self:bodyPosition()

    if other.classname == Player.classname and self.isOn == false then
        self.isOn = true
        Player.checkpoint = {x, y}
        print(self.isOn);
    end
end