local sti = require 'libraries.sti'

WorldScene = {
    transition = 0,
    transitionLength = 0.25,

    backgrounds = {},

    -- camera = Camera,
    -- map = sti map,
    -- physics = physics world,
    -- player = Player instance,
}


function WorldScene:init()
    love.physics.setMeter(64)

    self.player = Player()
    self.camera = Camera(self.player)

    self.mapName = 'level-00'
    self.previousMap = 'start'

    for i=2, 8 do
        table.insert(self.backgrounds, i, love.graphics.newImage('assets/backgrounds/' .. i .. '.png'))
    end

    Inventory.items = {}
    Inventory.coins = {}

    -- special case for init
    self:loadMap()
end


function WorldScene:update(dt)
    Stats:addPlaytime(dt)

    if Bindings:pressed('pause') then
        Gamestate.pop()
    end

    if self.transition > 0 then
        self.transition = self.transition - dt
        if self.transition <= 0 then
            self:loadMap(self.enteringFrom)
        end
        return
    end

    self.camera:update(dt)
    self.physics:update(dt)
    self.map:update(dt)

    if self.player.lastCheckpoint.queued then
        self.player:warpToCheckpoint()
    end

    for _, object in pairs(self.map.objects) do
        if object.ent and object.ent.update and not object.ent.dead then
            object.ent:update(dt)
        end
    end

    -- now that we're done with other updates, bring our your dead
    for i, object in pairs(self.map.objects) do
        if object.ent and object.ent.dead then
            if object.ent.body then
                object.ent.body:destroy()
            end

            self.map.objects[i] = nil
        end
    end
end


function WorldScene:draw()
    -- draw fixed-position background
    local img = self.backgrounds[self.player:getFrequency()]
    local swidth, sheight = love.window.getMode()
    local iwidth, iheight = img:getDimensions()
    local scale = math.max(swidth / iwidth, sheight / iheight)
    love.graphics.draw(img, 0, 0, 0, scale, scale)

    -- determine how much we need to translate around to see the player
    local tx, ty = self.camera:translate()

    -- Draw map
    self.map:draw(tx, ty)

    Hud:draw()
    Fader:draw()
    Hud:drawFPS()
end


function WorldScene:enter()
    self:resize(love.window.getMode())
end


function WorldScene:resize(w, h)
    self.map:resize(w, h)
end


function WorldScene:loadMap()
    -- Load map
    self.map = sti("maps/" .. self.mapName .. ".lua", {"box2d"})

    -- Prepare physics world
    self.physics = love.physics.newWorld(0, 1000)

    local function beginContact(a, b, c)
        -- we bind the entities to their fixture userdata, so they can handle their own logic on collision
        if a.getUserData then a = a:getUserData() end
        if b.getUserData then b = b:getUserData() end
        if a and a.beginContact then a:beginContact(b, c) end
        if b and b.beginContact then b:beginContact(a, c) end
    end
    self.physics:setCallbacks(beginContact)    -- omitting other callbacks for brevity

    self.map:box2d_init(self.physics)

    -- entities are rendered by map layers they spawn from
    for _, layer in ipairs(self.map.layers) do
        if layer.type == "objectgroup" then
            function layer:draw()
	            for _, object in ipairs(layer.objects) do
                    if object.ent and object.ent.draw then
                        object.ent:draw()
                    end
                end
            end
        end
    end

    -- create a body for the player based on the names of the spawn points
    local spawn = self:getSpawnPoint()
    self.player:createBody(self.physics, spawn.x, spawn.y)
    spawn.ent = self.player

    self:spawnEntities()

    self.camera:jump()

    Fader:start(1, self.transitionLength)

    Stats:add('Transitions')

    -- now is a good time to clean up unreachable data.
    -- without this, the texturememory can double over the course of a normal session
    collectgarbage()
end


-- if we do not find a spawn point with a name matching the previous map, we return the last spawn we saw
function WorldScene:getSpawnPoint()
    local spawn

    for _, object in pairs(self.map.objects) do
        if object.type == 'Spawn' then
            spawn = object
            if object.name == self.previousMap then
                return spawn
            end
        end
    end

    return spawn
end


function WorldScene:spawnEntities()
    for _, object in pairs(self.map.objects) do
        local ent = _G[object.type]
        if ent and not (ent.isCollected and ent:isCollected(self.mapName)) then
            object.ent = ent(self.physics, object)
        end
    end
end


function WorldScene:startTransition(mapName)
    -- check that we're not already transitioing
    if self.transition > 0 then return end

    Fader:start(0, self.transitionLength)
    self.transition = self.transitionLength

    self.previousMap = self.mapName
    self.mapName = mapName
end
