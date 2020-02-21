-- behavior for items that can be permanently collected
Collectible = Class{
}


function Collectible:isCollected(map)
    return Inventory:hasItem(self.classname, map)
end


function Collectible:beginContact(other)
    Inventory:collectItem(self.classname, WorldScene.mapName)
end
