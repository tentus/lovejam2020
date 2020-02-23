Checkpoint = Class {
    __includes = {Physical},
    classname = 'Checkpoint',

    isSensor = true,
    isOn = false,

    base = love.graphics.newImage('assets/sprites/checkpoint-base.png'),
    crystal = love.graphics.newImage('assets/sprites/checkpoint-crystal.png'),

    width = 64,
    height = 128,
}


function Checkpoint:init(world, object)
    self.x = object.x
    self.y = object.y

    Physical.createBody(self, world, object.x, object.y)
end


function Checkpoint:makeShapes()
    return {
        love.physics.newRectangleShape(self.width, self.height)
    }
end


function Checkpoint:draw()
    -- todo: make this fancy
    if self.isOn then
        love.graphics.draw(self.crystal, self.x - (self.width / 2), self.y - (self.height / 2))
    end

    love.graphics.draw(self.base, self.x - (self.width / 2), self.y)
end


function Checkpoint:beginContact(other)
    if other.classname == Player.classname then
        -- turn off the old checkpoint, replace it with us, and then flip us on
        -- if the old checkpoint is us, well... doesn't matter
        other.lastCheckpoint.isOn = false
        other.lastCheckpoint = self
        self.isOn = true
    end
end