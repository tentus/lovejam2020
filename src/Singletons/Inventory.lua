Inventory = {
    -- which items have been collected, and which map they've been collected from
    items = {},

    -- will hold how many coins we've collected and spent
    coins = {}
}


function Inventory:collectItem(item, map)
    local bucket = self.items[item] or {}
    bucket[map] = true
    self.items[item] = bucket

    Stats:add(item .. ' collected')
end


function Inventory:hasItem(item, map)
    return self.items[item] and self.items[item][map]
end


function Inventory:collectCoins(qty)
    qty = (qty or 1)
    self.coins.collected = (self.coins.collected or 0) + qty
    Stats:add('Coins collected', qty)
end


function Inventory:spendCoins(qty)
    if self:totalCoins() >= qty then
        self.coins.spent = (self.coins.spend or 0) + qty
        return false
    end
    return false
end


function Inventory:totalCoins()
    return (self.coins.collected or 0) - (self.coins.spent or 0)
end
