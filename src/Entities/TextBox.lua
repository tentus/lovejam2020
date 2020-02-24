-- responsible for forcing the map to load a new area
TextBox = Class{
    __includes = {},
    classname = 'TextBox',

    padding = 4,
}


function TextBox:init(world, object)
    self.text = object.text
    self.width = object.width
    self.height = object.height
    self.x = object.x
    self.y = object.y
    self.halign = object.halign or "left"
end


function TextBox:draw()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        self.text,
        self.x + self.padding, self.y + self.padding,
        self.width - (self.padding * 2),
        self.halign
    )
end
