-- helps with entities that have physics bodies
-- since a single body might need a complex shape, we treat the shapes and fixtures as tables
Physical = Class{
    -- body    = Body,
    shape = {
        -- Shape
    },
    fixture = {
        -- Fixture
    },
}


function Physical:createBody(world, x, y)
    self.body    = love.physics.newBody(world, x, y, self.bodyType or 'static')
    self.shapes  = self:makeShapes()
    for i, shape in ipairs(self.shapes) do
        self.fixture[i] = love.physics.newFixture(self.body, shape)
        self.fixture[i]:setSensor(self.isSensor or false)
        self.fixture[i]:setUserData(self)
    end
end


-- separated so it can be overridden for rectangles or compound shapes
function Physical:makeShapes()
    return {
        love.physics.newCircleShape(self.radius)
    }
end


function Physical:bodyPosition()
    return self.body:getPosition()
end
