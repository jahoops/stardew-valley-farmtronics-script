
//me.position.area.name
//me.position.area.width (height)
//me.position.x (y)
//if me.ahead.hasIndex("dead")

north = 0
east = 1
south = 2
west = 3

face = function(direction)
    while not me.facing == direction
        me.right
    end while
end function
faceNorth = function()
    while not me.facing == north
        me.right
    end while
end function
faceEast = function()
    while not me.facing == east
        me.right
    end while
end function
faceSouth = function()
    while not me.facing == south
        me.right
    end while
end function
faceWest = function()
    while not me.facing == west
        me.right
    end while
end function

gotoPosition = function(posX, posY)
    print "going to position (" + posX + "," + posY + ")"
    myX = me.position.x
    myY = me.position.y
    myLastX = me.position.x
    myLastY = me.position.y
    stuck = 0
    while true
        if myX < posX then 
            faceEast
            me.forward
        end if
        if myX > posX then
            faceWest
            me.forward
        end if
        if myY < posY then 
            faceSouth
            me.forward
        end if
        if myY > posY then 
            faceNorth
            me.forward
        end if
        wait .5
        myX = me.position.x
        myY = me.position.y 
        if myX==posX then   
            if myY==posY then
                break
            end if
        end if
        if(myX == myLastX and myY == myLastY) then
            stuck = stuck + 1
        else 
            stuck = 0
            myLastX = me.position.x
            myLastY = me.position.y
        end if
        if stuck == 3 then
            for i in range(1,4)
                f = floor(rnd * 4)
                face(f)
                for j in range(1,5)
                    me.forward
                end for
            end for
            stuck = 0
        end if
    end while
    print "arrived at (" + posX + "," + posY + ")"
end function

onetime = true

changeDirTypes = ["MiniJukebox","Fence","BotObject","Character","Building"]
clearTypes = ["Grass","Stone","Twig","Weeds","Bush"]

whatIsTile = function(inTile)
    print inTile
    whatItIs = "not found"
    if inTile == null then 
        whatItIs = "NULL"
    else if inTile.hasIndex("type") and inTile.type == "Flooring" then
        whatItIs = "floor"
    else if inTile.hasIndex("crop") and inTile.crop != null then 
        tileCrop = inTile.crop
         whatItIs = "crop"
        if inTile.hasIndex("dry") and inTile.dry then 
            whatItIs = "cropDry"
        else if tileCrop.hasIndex("dead") and tileCrop.dead then 
            whatItIs = "cropDead"
        else if tileCrop.hasIndex("harvestable") and tileCrop.harvestable then
            if tileCrop.hasIndex("harvestMethod") and tileCrop.harvestMethod then 
                whatItIs = "cropHarvestScythe"
            else if tileCrop.hasIndex("harvestMethod") and not tileCrop.harvestMethod then 
                whatItIs = "cropHarvest"
            end if
        end if
    else if inTile.hasIndex("type") then
        if inTile.type == "HoeDirt" then 
            whatItIs = "hoe"
        else if inTile.type == "Clump" then 
            whatItIs = "clump"
        else if clearTypes.indexOf(inTile.type) > -1 then 
            whatItIs = "clear"
        else if inTile.type == "Object" and clearTypes.indexOf(inTile.name) > -1 then 
            whatItIs = "clear"
        else if inTile.type == "Chest" then 
            whatItIs = "chest"
        else if inTile.type == "FruitTree" then 
            whatItIs = "fruitTree"
        else if inTile.type == "Property" and inTile.name == "Water" then 
            whatItIs = "water"
        else if changeDirTypes.indexOf(inTile.type) > -1 then 
            whatItIs = "changeDirection"
        end if
    else if inTile.hasIndex("passable") and inTile.passable == 1 then 
        whatItIs = "passable"
    end if
    print whatItIs
    return whatItIs
end function

getWater = function()
    x = me.position.x
    y = me.position.y
    dx = abs(waterx - x)
    dy = abs(watery - y)
    if dx > dy then
        if x < waterx then 
            faceEast
            me.forward
        else
            faceWest
            me.forward
        end if
    else 
        if y < watery then
            faceSouth
            me.forward
        else
            faceNorth
            me.forward
        end if
    end if
    if me.ahead and me.ahead.hasIndex("passable") and not me.ahead.passable then
        change_direction
        me.forward
    end if
end function

selectInventoryByCat = function(cat="Fertilizer")
    for i in range(0,11)
        if me.inventory[i].hasIndex("category") and me.inventory[i].category == cat then
            me.select me.inventory[i].name
            return true
        end if
    end for
    return false
end function

selectInventoryByName = function(name="Grass Starter")
    for i in range(0,11)
        if me.inventory[i].hasIndex("name") and me.inventory[i].name == name then
            me.select me.inventory[i].name
            return true
        end if
    end for
    return false
end function

selectInventoryByType = function(type="WateringCan")
    for i in range(0,11)
        if me.inventory[i].hasIndex("type") and me.inventory[i].type == type then
            me.select me.inventory[i].name
            return i
        end if
    end for
    return -1
end function

waterLevel = function()
    i =selectInventoryByType("WateringCan")
    return me.inventory[i].waterLeft
end function

usePickaxe = function()
    if selectInventoryByType("Pickaxe") > -1 then me.useTool
end function

useAxe = function()
    if selectInventoryByType("Axe") > -1 then me.useTool
end function

useScythe = function()
    if selectInventoryByType("Scythe") > -1 then me.useTool
end function

useWateringCan = function()
    if selectInventoryByType("WateringCan") > -1 then me.useTool
end function

useHoe = function()
    if selectInventoryByType("Hoe") > -1 then me.useTool
end function

farmedItemsToSave = ["Fruit","Vegetable","Flower","Resource"]
saveFarmedItemsToChest = function
    for i in range(0,11)
        if me.inventory[i].hasIndex("category") and farmedItemsToSave.indexOf(me.inventory[i].category) > -1 then
            me.select me.inventory[i].name
            me.placeItem
        end if
    end for
end function

stayOnFlooring = function()
    if me.ahead and me.ahead.type == "Flooring" then 
        me.forward
        return
    end if
    me.left
    if me.ahead and me.ahead.type == "Flooring" then 
        me.forward
        return
    end if
    me.right
    me.right
    if me.ahead and me.ahead.type == "Flooring" then 
        me.forward
        return
    end if
    me.right
end function

doCellar = function()
    while true
        for i in range(1,4)
            me.right
            wait .5
            if me.ahead then
                type = me.ahead.type
                name = me.ahead.name
                if type == "Cask" then
                    me.harvest
                    if selectInventoryByCat("Fruit") then me.placeItem
                else if name == "Chest" then
                    if selectInventoryByCat("Artisan Goods") then me.placeItem
                    if selectInventoryByCat("Seed") then me.placeItem
                    if selectInventoryByName("Copper Bar") then me.placeItem
                else if name == "Preserves Jar" then
                    me.harvest
                    if selectInventoryByCat("Fruit") then me.placeItem
                else if name == "Seed Maker" then
                    me.harvest
                    if selectInventoryByCat("Vegetable") then me.placeItem
                else if name == "Furnace" then
                    me.harvest
                    if selectInventoryByName("Copper Ore") then me.placeItem
                else if name == "Crystalarium" then
                    me.harvest
                else if name == "Oil Maker" then
                    me.harvest
                    if selectInventoryByName("Truffle") then me.placeItem
                else if name == "Charcoal Kiln" then
                    me.harvest
                    if selectInventoryByName("Wood") then me.placeItem
                end if
            end if
        end for
        stayOnFlooring
        if world.timeOfDay > 2200 then exit
    end while
end function

tendTile = function(_t)
    if selectInventoryByName("Grass Starter") then me.placeItem                 
    if selectInventoryByCat("Fertilizer") then me.placeItem
    if selectInventoryByCat("Seed") then me.placeItem
    if me.ahead and me.ahead.hasIndex("dry") and me.ahead.dry then  
        useWateringCan
    end if
end function

farmThisTile = function()
    if me.ahead then
        _t = whatIsTile(me.ahead)
        if _t == "crop" then
            me.harvest
        else if _t == "cropdead" then 
            usePickaxe
            tendTile
        else if _t == "hoe" then
            useHoe
            tendTile
        else if _t == "clump" then
            useAxe
            tendTile
        else if _t == "cropDry" then
            me.harvest
            tendTile
        else if _t == "cropHarvest" then 
            me.harvest
        else if _t == "cropHarvestScythe" then 
            useScythe
        else if _t == "clear" then 
            me.clearAhead
        else if _t == "chest" then
            saveFarmedItemsToChest
        else if _t == "water" then 
            tendTile
        else if _t  == "fruitTree" then 
            me.harvest
        else if _t  == "passable" then
            me.harvest
            me.clearAhead
        end if
    else
        useHoe
        tendTile
    end if
end function

doFarm = function()
    while true
        for i in range(0,3)
            me.right
        end for
        stayOnFlooring
        wait .5
        if world.timeOfDay > 2200 then exit
    end while
end function

doClearAll = function(width, height)
    startx = me.position.x
    starty = me.position.ys
    for y in range(1,height)
        if y%2 == 1 then
            for x in range(1,width)
                faceEast
                me.clearAhead
                useHoe
                me.forward
            end for
        else
            for x in range(1,width)
                faceWest
                me.clearAhead
                useHoe
                me.forward
            end for
        end if
        if(y < height) then 
            faceSouth
            me.forward
        end if   
    end for
    gotoPosition(startx,starty)
    faceNorth
    saveFarmedItemsToChest
end function

getWaterAndReturn = function()
    saveFacing = me.facing
    savepos = {"x":me.position.x, "y":me.position.y}

    //east well
    dist = abs(savepos.x-57) + abs(savepos.y-41)
    waterpos = {"x":57,"y":41,"d":dist,"f":west}
    //north well
    dist = abs(savepos.x-31) + abs(savepos.y-20)
    if dist < waterpos.d then
        waterpos = {"x":31,"y":20,"d":dist,"f":north}
    end if
    //lake
    dist = abs(savepos.x-44) + abs(savepos.y-50)
    if dist < waterpos.d then
        waterpos = {"x":44,"y":50,"d":dist,"f":south}
    end if
    //pond
    dist = abs(savepos.x-69) + abs(savepos.y-31)
    if dist < waterpos.d then
        waterpos = {"x":69,"y":31,"d":dist,"f":east}
    end if

    gotoPosition(waterpos.x,waterpos.y)
    face(waterpos.f)
    useWateringCan
    gotoPosition(savepos.x,savepos.y)
    face(saveFacing)
end function

doFarmAll = function(width, height)
    startx = me.position.x
    starty = me.position.y
    for y in range(1,height)
        if y%2 == 1 then
            for x in range(1,width)
                faceEast
                if waterLevel < 1 then getWaterAndReturn
                farmThisTile
                me.forward
            end for
        else
            for x in range(1,width)
                faceWest
                if waterLevel < 1 then getWaterAndReturn
                farmThisTile
                me.forward
            end for
        end if
        me.forward
        if(y < height) then 
            faceSouth
            me.forward
        end if    
    end for
    gotoPosition(startx,starty)
    faceNorth
    saveFarmedItemsToChest
end function

if me.position.area.name == "Cellar" then
    doCellar
else
    if me.name == "Farmtronics Bot 28"  then
        gotoPosition(8,20)
        doFarmAll(20,24)
        //doClearAll(40,24)
    else if me.name == "Farmtronics Bot 21"  then
        gotoPosition(28,20)
        doFarmAll(20,24)
        //doClearAll(40,24)
    else if me.name == "Farmtronics Bot 7" then
        gotoPosition(57,45)
        doFarmAll(19,10)w
        //doClearAll(19,10)
    else if me.name == "Farmtronics Bot 32" then
        gotoPosition(59,19)
        doFarmAll(10,23)
        //doClearAll(10,20)
    else if me.name.indexOf("Farmtronics Bot")>-1 then
        world.chat "I am " + me.name + " at " + me.position.x + "," + me.position.y
        gotoPosition(70,20)
    end if
end if

