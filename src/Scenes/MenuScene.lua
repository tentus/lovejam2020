-- if the value passed is a function, return its return value
local function value(v)
    return (type(v) == 'function') and v() or v
end

local function playGame()
    Gamestate.push(WorldScene)
end

local function toggleWindowFlag(flag)
    local w, h, f = love.window.getMode()

    -- some flags are numeric, so we toggle them from 0 to 1 and back
    if type(f[flag]) == "number" then
        f[flag] = (f[flag] + 1) % 2
    else
        f[flag] = not f[flag]
    end
    
    love.window.setMode(w, h, f)
end

MenuScene = {
    level = 'root',
    cursor = 1,
    options = {
        root = {   -- top menu
            {
                function()
                    return WorldScene.entered and 'Continue' or 'Play'
                end,
                function()
                    playGame()
                end
            },
            {
                'Settings',
                'settings'
            },
            {
                'Stats',
                'stats'
            },
            {
                'Credits',
                function()
                    Gamestate.push(CreditsScene)
                end
            },
            {
                'Quit',
                function()
                    love.event.quit()
                end
            },
        },
        settings = {
            {
                'HUD Settings',
                'hud'
            },
            {
                'Video Settings',
                'video'
            },
            {
                'Audio Settings',
                'audio'
            },
            {
                'Back',
                'root'
            }
        },
        video = {
            {
                'Fullscreen',
                function()
                    love.window.setFullscreen(not love.window.getFullscreen())
                end
            },
            {
                'VSYNC',
                function()
                    toggleWindowFlag('vsync')
                end
            },
            {
                'Window Border',
                function()
                    toggleWindowFlag('borderless')
                end
            },
            {
                'Back',
                'settings'
            }
        },
        hud = {
            {
                'Toggle FPS',
                function()
                    Hud:toggle('fps')
                end
            },
            {
                'Toggle Health',
                function()
                    Hud:toggle('health')
                end
            },
            {
                'Toggle Inventory',
                function()
                    Hud:toggle('inventory')
                end
            },
            {
                function()
                    return 'Edge Distance: ' .. Hud.edge
                end,
                function()
                    Hud:changeEdge(10)
                end
            },
            {
                'Back',
                'settings'
            }
        },
        audio = {
            {
                function()
                    return 'Master Volume: ' .. AudioManager:getVolume('master')
                end,
                function()
                    AudioManager:changeVolume('master', -.1)
                end
            },
            {
                function()
                    return 'Music Volume: ' .. AudioManager:getVolume('music')
                end,
                function()
                    AudioManager:changeVolume('music', -.1)
                end
            },
            {
                function()
                    return 'SFX Volume: ' .. AudioManager:getVolume('sfx')
                end,
                function()
                    AudioManager:changeVolume('sfx', -.1)
                end
            },
            {
                'Back',
                'settings'
            }
        },
        stats = {
            {
                function()
                    return Stats:getPlaytime() .. Stats:print()
                end,
                'root'
            },
        },
    },
    lineHeight = 36,
    logo = SpriteComponent('assets/logos/game_logo.png'),
}


function MenuScene:draw()
    local width, height = love.window.getMode()
    local halfWidth = width / 2
    local halfHeight = height / 2

    self.logo:draw(halfWidth, halfHeight - self.logo.y)

    for i=1, #self.options[self.level] do
        if i == self.cursor then
            love.graphics.print('->', halfWidth - 32, halfHeight + (i * self.lineHeight))
        end

        love.graphics.print(value(self.options[self.level][i][1]), halfWidth, halfHeight + (i * self.lineHeight))
    end

    Hud:drawFPS()
end


function MenuScene:update(dt)
    if Bindings:pressed('up') then
        self.cursor = self.cursor - 1
        if self.cursor < 1 then
            self.cursor = #self.options[self.level]
        end
    elseif Bindings:pressed('down') then
        self.cursor = self.cursor + 1
        if self.cursor > #self.options[self.level] then
            self.cursor = 1
        end
    elseif Bindings:pressed('a') then
        local action = self.options[self.level][self.cursor][2]
        if type(action) == 'function' then
            action()
        else
            self:goTo(action)
        end
    elseif Bindings:pressed('b') or Bindings:pressed('pause') then
        if self.level ~= 'root' then
            self:goTo('root')
        elseif WorldScene.entered then
            playGame()
        end
    end
end


function MenuScene:goTo(level)
    self.cursor = 1
    self.level = level
end
