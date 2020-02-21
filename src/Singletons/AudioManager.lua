AudioManager = {
    -- for short one-off sounds we can cache the source in memory
    cache = {},

    queue = {},

    -- a streaming Source for music
    streaming = nil,

    -- we have three layered volume settings to to tweak
    volume = {
        master = 1,
        music  = 1,
        sfx    = 1,
    },
}


function AudioManager:update(dt)
    if table.getn(self.queue) > 0 and not self.streaming:isPlaying() then
        local queued = table.remove(self.queue,1)
        self:stream(queued)
    end
end


function AudioManager:streamNext(file)
    table.insert(self.queue, file)
    self.streaming:setLooping(false)
end


function AudioManager:play(file)
    if not self.cache[file] then
        self.cache[file] = love.audio.newSource(file, "static")
    end
    self.cache[file]:setVolume(self.volume.sfx)
    love.audio.play(self.cache[file])
end


function AudioManager:stream(file)
    self.streaming = love.audio.newSource(file, "stream")
    self.streaming:setLooping(true)
    love.audio.play(self.streaming)
end


function AudioManager:changeVolume(target, increment)
    local v = math.min(self.volume[target] + increment, 1)
    self.volume[target] = v < 0 and 1 or v
    love.audio.setVolume(self.volume.master)

    if self.streaming then
        self.streaming:setVolume(self.volume.music)
    end
end


function AudioManager:getVolume(target)
    return math.floor(self.volume[target] * 100)
end
