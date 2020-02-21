-- responsible for forcing the map to load a new area
Door = Class{
    __includes = {Physical},
    classname = 'Door',

    isSensor = true,
}


function Door:init(world, object)
    self.name = object.name

    self.width = object.width
    self.height = object.height

    Physical.createBody(self, world, object.x + (self.width / 2), object.y + (self.height / 2))
end


function Door:makeShapes()
    return {
        love.physics.newRectangleShape(self.width, self.height)
    }
end


function Door:beginContact(other)
    if other.classname == Player.classname then
        WorldScene:startTransition(self.name)
    end
end