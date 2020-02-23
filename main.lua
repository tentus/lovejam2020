Class       = require 'libraries.hump.class'
Gamestate   = require 'libraries.hump.gamestate'
lovebird    = require 'libraries.lovebird'
inspect     = require 'libraries.inspect'
anim8       = require 'libraries.animation.anim8'

function love.load()
    local function requireDir(dir)
        local files = love.filesystem.getDirectoryItems(dir)
        for _, file in pairs(files) do
            if string.sub(file, -4) == '.lua' then
                require(dir .. '/' .. string.gsub( file, '.lua', ''))
            else
                requireDir(dir .. '/' .. file)
            end
        end
    end

    requireDir('src')

    AudioManager:stream('assets/music/quincy_Theme1.ogg')

    love.graphics.setFont(
        love.graphics.newFont(16)
    )

    Gamestate.registerEvents()
    Gamestate.switch(SplashScene)
end

function love.update(dt)
    lovebird.update()
    Fader:update(dt)
    AudioManager:update()
    Bindings:update()
end

function love.keypressed(key)
    if key == '1' or key == 'f1' then
        love.window.setFullscreen(not love.window.getFullscreen())
    elseif key == '2' or key == 'f2' then
        love.system.openURL("http://" .. lovebird.whitelist[1] .. ":" .. lovebird.port )
    elseif key == '4' or key == 'f4' then
        love.event.quit()
    end
end
