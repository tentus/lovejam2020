local baton = require 'libraries.baton'

Bindings = baton.new {
    controls = {
        up     = {'key:w', 'key:up',    'button:dpup',    'axis:lefty-', 'wheel:y+'},
        down   = {'key:s', 'key:down',  'button:dpdown',  'axis:lefty+', 'wheel:y-'},
        left   = {'key:a', 'key:left',  'button:dpleft',  'axis:leftx-', 'wheel:x-'},
        right  = {'key:d', 'key:right', 'button:dpright', 'axis:leftx+', 'wheel:x+'},

        a = {'key:space', 'button:a', 'key:return'},    -- jump
        b = {'key:f',     'button:b'},                  -- attack
        x = {'key:e',     'button:x', 'key:r'},         -- frequency up
        y = {'key:q',     'button:y', 'key:tab'},       -- frequency down

        pause = {'key:escape', 'key:backspace', 'button:start'}
    },
    pairs = {
        move = {'left', 'right', 'up', 'down'}
    },
    joystick = love.joystick.getJoysticks()[1],
}
