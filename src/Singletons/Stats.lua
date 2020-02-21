Stats = {
    -- holds a list of events and their counts, eg:
    events = {
        Deaths = 0,
    },

    -- measured in seconds
    playtime = 0.0,
}


function Stats:add(event, value)
    self.events[event] = (self.events[event] or 0) + (value or 1)
end


function Stats:addPlaytime(dt)
    self.playtime = self.playtime + dt
end


function Stats:getPlaytime()
    -- todo: formatting for hours/minutes
    return 'Playtime : ' .. math.floor(self.playtime)
end


function Stats:print()
    local str = ''
    for k, v in pairs(self.events) do
        str = str .. '\n\n' .. k .. '  :  ' .. math.floor(v)
    end
    return str
end
