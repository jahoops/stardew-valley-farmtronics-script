segments = []
xx = 10
yy = 18
for cols in range(1,3)
    xx = 10
    for rows in range (1,4)
        segments.push({"x1":xx,"y1":yy,"x2":xx+16,"y2":yy+12})
        xx = xx + 17
    end for
    yy = yy + 13
end for

north = 0
east = 1
south = 2
west = 3

fName = function(f)    
    if f==0 then return "north"
    if f==1 then return "east"
    if f==2 then return "south"
    if f==3 then return "west"
end function

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

canGoForward = function()
    if not facingFloor and (not me.ahead or me.ahead.passable) then
        return true
    else 
        return false
    end if
end function

tryToEscape = function(stuck=3, clearPath=false)
    //world.chat "trying to escape at " + me.position.x + "," + me.position.y
    for tryToEscape_i in range(1,2)
        f = floor(rnd * 4)
        face(f)
        for j in range(1,2)
            if canGoForward then 
                if clearPath then me.clearAhead
                me.forward
                farmThisTile
            end if
        end for
    end for
    return
end function

goForwardOrEscape = function(clearPath=false)
    if canGoForward then 
        me.forward
    else 
        tryToEscape(clearPath)
    end if
end function

gotoPosition = function(gotoX, gotoY, clearPath=false, getWater=false)
    //print "going to position (" + gotoX + "," +   + ")"
    wait .1
    myX = me.position.x
    myY = me.position.y
    myLastX = me.position.x
    myLastY = me.position.y
    stuck = 0
    while true
        if myX < gotoX then 
            faceEast
            if canGoForward then 
                if clearPath then me.clearAhead
                print "can go forward, going " + fName(me.facing)
                me.forward
                wait .1
                if getWater then
                    useWateringCan
                    if waterLevel > 10 then return
                end if
                //farmThisTile
            else
                stuck = stuck + 1
            end if
        end if
        if myX > gotoX then
            faceWest
            if canGoForward then 
                if clearPath then me.clearAhead
                print "can go forward, going " + fName(me.facing)
                me.forward
                wait .1
                if getWater then
                    useWateringCan
                    if waterLevel > 10 then return
                end if
                //farmThisTile
            else
                stuck = stuck + 1
            end if
        end if
        if myY < gotoY then 
            faceSouth
            if canGoForward then 
                if clearPath then me.clearAhead
                print "can go forward, going " + fName(me.facing)
                me.forward
                wait .1
                if getWater then
                    useWateringCan
                    if waterLevel > 10 then return
                end if
                //farmThisTile
            else
                stuck = stuck + 1
            end if
        end if
        if myY > gotoY then 
            faceNorth
            if canGoForward then 
                if clearPath then me.clearAhead
                print "can go forward, going " + fName(me.facing)
                me.forward
                wait .1
                if getWater then
                    useWateringCan
                    if waterLevel > 10 then return
                end if
                //farmThisTile
            else
                stuck = stuck + 1
            end if
        end if
        wait .1
        myX = me.position.x
        myY = me.position.y 
        if myX==gotoX then   
            if myY==gotoY then
                return true
            end if
        end if
        myLastX = me.position.x
        myLastY = me.position.y
        if stuck > 3 then 
            print "stuck so trying to escape"
            wait .1
            tryToEscape(stuck, clearPath)
            stuck = stuck + 1
        end if
        if stuck > 6 then
            print "stuck, giving up"
            stuck = 0
            wait .1
            return false
        end if
    end while   
end function

onetime = true

changeDirTypes = ["MiniJukebox","Fence","BotObject","Character","Building"]
clearTypes = ["Grass","Stone","Twig","Weeds","Bush"]

whatIsTile = function(inTile)
    //print inTile
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
        end if
        if tileCrop.hasIndex("dead") and tileCrop.dead then 
            whatItIs = "cropDead"
        end if
        if tileCrop.hasIndex("harvestable") and tileCrop.harvestable then
            if tileCrop.hasIndex("harvestMethod") and tileCrop.harvestMethod then 
                whatItIs = "cropHarvestScythe"
            else if tileCrop.hasIndex("harvestMethod") and not tileCrop.harvestMethod then 
                whatItIs = "cropHarvest"
            end if
        end if
    else if inTile.hasIndex("type") then
        if inTile.type == "HoeDirt" then 
            whatItIs = "hoe"
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
    //print whatItIs
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
        else
            faceWest
        end if
    else 
        if y < watery then
            faceSouth
        else
            faceNorth
        end if
    end if
    goForwardOrEscape
end function

outcomes = {"not found":0,"NULL":10,"floor":-9999,"crop":9999,"cropDry":15,"cropDead":10,"cropHarvestScythe":9999,"cropHarvest":9999,"hoe":10,"clear":50,"chest":10,"fruitTree":0,"water":1000,"changeDirection":10,"passable":10}
scoreTiles = function(arrayOfWhats)
    if not arrayOfWhats then return -999
    st_score = 0
    for st_i in range(0,arrayOfWhats.len-1)
        st_what = arrayOfWhats[st_i]
        if st_what=="water" and waterLevel==0 then
            st_score = st_score + outcomes.water
        else if st_what=="floor" and st_i < 2 then
            st_score = st_score + outcomes.floor
        else
            print "else score is " + outcomes[st_what]
            st_score = st_score + outcomes[st_what]
        end if
    end for
    return st_score
end function

bestDirection = function(__x,__y)
    bdwest = []
    bdeast = []
    bdnorth = []
    bdsouth = []
    bd_current = me.facing 
    choice = -1
    for bdx in range(__x-8,__x-1)
        bdt = me.position.area.tile(bdx,__y)
        bdwest.push(whatIsTile(bdt))
    end for
    for bdx in range(__x+1,__x+8)
        bdt = me.position.area.tile(bdx,__y)
        bdeast.push(whatIsTile(bdt))
    end for
    for bdy in range(__y-8,__y+1)
        bdt = me.position.area.tile(__x,bdy)
        bdnorth.push(whatIsTile(bdt))
    end for
    for bdy in range(__y+1,__y+8)
        bdt = me.position.area.tile(__x,bdy)
        bdsouth.push(whatIsTile(bdt))
    end for

    scwest = scoreTiles(bdwest)
    if bd_current == west then scwest = scwest + floor(rnd*50)

    sceast = scoreTiles(bdeast)
    if bd_current == east then sceast = sceast + floor(rnd*50)

    scnorth = scoreTiles(bdnorth)
    if bd_current == north then scnorth = scnorth + floor(rnd*50)

    scsouth = scoreTiles(bdwest)
    if bd_current == south then scsouth = scsouth + floor(rnd*50)

    print "west scores " + scwest
    schigh = scwest
    choice = west

    print "east scores " + sceast
    if sceast > schigh then
        schigh = sceast
        choice = east
    end if
    print "north scores " + scnorth
    if scnorth > schigh then
        schigh = scnorth
        choice = north
    end if

    print "south scores " + scsouth
    if scsouth > schigh then
        schigh = scsouth
        choice = south
    end if
    print "choice is " + choice + " score " + schigh
    return choice
end function

selectInventoryByCat = function(cat="Fertilizer")
    for sibci in range(0,11)
        if me.inventory[sibci].hasIndex("category") and me.inventory[sibci].category == cat then
            me.select sibci
            return true
        end if
    end for
    return false
end function

selectInventoryByName = function(name="Grass Starter")
    for sibni in range(0,11)
        if me.inventory[sibni].hasIndex("name") and me.inventory[sibni].name == name then
            me.select sibni
            return true
        end if
    end for
    return false
end function

selectInventoryByType = function(type="WateringCan")
    for sibti in range(0,11)
        if me.inventory[sibti].hasIndex("type") and me.inventory[sibti].type == type then
            me.select sibti
            return sibti
        end if
    end for
    return -1
end function

waterLevel = function()
    i = selectInventoryByType("WateringCan")
    if i > -1 then 
        return me.inventory[i].waterLeft
    else
        return -1
    end if
end function

usePickaxe = function()
    if selectInventoryByType("Pickaxe") > -1 then me.useTool
end function

useScythe = function()
    if selectInventoryByName("Scythe") > -1 then me.useTool
end function

useWateringCan = function()
    if selectInventoryByType("WateringCan") > -1 then me.useTool
end function

useHoe = function()
    if selectInventoryByType("Hoe") > -1 then me.useTool
end function

farmedItemsToSave = ["Fruit","Vegetable","Flower","Resource"]
saveFarmedItemsToChest = function
    for sfi in range(0,11)
        if me.inventory[sfi].hasIndex("category") and farmedItemsToSave.indexOf(me.inventory[sfi].category) > -1 then
            me.select me.inventory[sfi].name
            me.placeItem
        end if
    end for
end function

stayOnFlooring = function()
    open = []
    fc = me.facing
    if me.ahead and me.ahead.type == "Flooring" then
        open.push me.facing
    end if
    me.left
    if me.ahead and me.ahead.type == "Flooring" then
        open.push me.facing
    end if
    me.right
    me.right
    if me.ahead and me.ahead.type == "Flooring" then
        open.push me.facing
    end if
    if open then
        go = floor(rnd*open.len)
        face(open[go])
        me.forward
        return
    end if
    face(fc)
    me.right
    me.right 
end function

doCellar = function()
    while true
        for dc_i in range(1,4)
            me.right
            wait .2
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
        //if world.timeOfDay > 2200 then exit
    end while
end function

doKeg = function()
    name = me.ahead.name
    if name == "Keg" then
        me.harvest
        if selectInventoryByCat("Fruit") or selectInventoryByName("Hops") or selectInventoryByName("Wheat") then 
            me.placeItem
        else
            world.chat "keybot out of fruit, hops, wheat at " + me.position.x + "," + me.position.y
            wait 60
        end if
    else if name == "Preserves Jar" then
        me.harvest
        if selectInventoryByName("Eggplant") then 
            me.placeItem
        else
            world.chat "keybot out of eggplant at " + me.position.x + "," + me.position.y
            wait 60
        end if
    else if name == "Chest" then
        if selectInventoryByCat("Artisan Goods") then me.placeItem
    end if
end function

doKegs = function()
    while true
        me.right
        if me.ahead then
            doKeg
        end if
        me.right
        me.right
        if me.ahead then
            doKeg
        end if
        me.right
        wait .2
        stayOnFlooring
    end while
end function

facingFloor = function()
    if me.ahead and me.ahead.type == "Flooring" then
        return true
    else
        return false
    end if
end function

tendTile = function(_t)  
    if world.season < 3 and world.dayOfSeason < 15 then            
        if selectInventoryByCat("Fertilizer") then me.placeItem
        if selectInventoryByCat("Seed") then me.placeItem
    end if
    if me.ahead and me.ahead.hasIndex("dry") and me.ahead.dry then  
        if waterLevel<10 then 
            getWaterAndReturn
        end if
        useWateringCan
    end if
end function

farmThisTile = function()
    wait .1
    _t  = "floor" 
    for ftti in range(0,3)
        if me.ahead then
            _t = whatIsTile(me.ahead)
            if _t == "floor" then
            else if _t == "crop" then
                me.harvest
            else if _t == "cropDead" then 
                me.clearAhead
                useHoe
                tendTile
            else if _t == "hoe" then
                useHoe
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
        wait .1
    end for
end function

farmAroundThisTile = function()
    farmThisTile
    me.left
    farmThisTile
    me.left
    farmThisTile
    me.left
    farmThisTile
    me.left
end function

doClearAll = function()
    startx = me.position.x
    starty = me.position.y
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

getUnstuck = function(x,y)
    stuck = 0
    while me.position.x != x or me.position.y != y
        heads1 = isHeads
        heads2 = isHeads
        if heads1 then
            gotoPosY(me.position.y +  5 - floor(rnd*11))
            gotoPosX(me.position.x +  5 - floor(rnd*11))
        else
            gotoPosX(me.position.x +  5 - floor(rnd*11))   
            gotoPosY(me.position.y +  5 - floor(rnd*11))                 
        end if
        if heads2 then
            gotoPosY(y)
            gotoPosX(x)
        else
            gotoPosX(x)
            gotoPosY(y)                    
        end if
        if stuck>0 then
            print "Stuck times " + stuck + " at " + me.position
        end if
        stuck = stuck + 1
    end while
    print "made it to " + me.position + " = " + x + "," + y + " h1:" + heads1 + " h2:" + heads2
end function

gotoPosX = function(gpxin_x)
    while me.position.x < gpxin_x
        faceEast
        if canGoForward then
            me.forward
            farmAroundThisTile
            wait .1
        else
            return
        end if
    end while
    while me.position.x > gpxin_x
        faceWest
        if canGoForward then
        farmAroundThisTile
            me.forward
            wait .1
        else
            return
        end if
    end while
end function

gotoPosY = function(gpyin_y)
    while me.position.y < gpyin_y
        faceSouth
        if canGoForward then
            me.forward
            wait .1
        else
            return
        end if
    end while
    while me.position.y > gpyin_y
        faceNorth
        if canGoForward then
            me.forward
            wait .1
        else
            return
        end if
    end while
end function

getWaterAndReturn = function()
    savepos = {"x":me.position.x, "y":me.position.y}
    saveFacing = me.facing
    //west well
    dist = abs(savepos.x-10) + abs(savepos.y-43)
    waterpos = {"x":10,"y":44,"d":dist}
    //east well
    dist = abs(savepos.x-57) + abs(savepos.y-41)
    if dist < waterpos.d then
        waterpos = {"x":56,"y":41,"d":dist}
    end if
    //north well
    dist = abs(savepos.x-31) + abs(savepos.y-20)
    if dist < waterpos.d then
        waterpos = {"x":31,"y":19,"d":dist}
    end if
    //lake east
    dist = abs(savepos.x-47) + abs(savepos.y-53)
    if dist < waterpos.d then
        waterpos = {"x":46,"y":53,"d":dist}
    end if
    //lake west
    dist = abs(savepos.x-32) + abs(savepos.y-53)
    if dist < waterpos.d then
        waterpos = {"x":33,"y":53,"d":dist}
    end if
    //pond
    dist = abs(savepos.x-69) + abs(savepos.y-31)
    if dist < waterpos.d then
        waterpos = {"x":70,"y":31,"d":dist}
    end if

    stuck = 0
    while waterLevel < 10
        gotoPosY(waterpos.y)
        gotoPosX(waterpos.x)
        stuck = stuck + 1
        if  stuck > 3 then
            print "getting unstuck 714"
            getUnstuck(waterpos.x,waterpos.y)
            stuck = 0
        end if  
        for dir in range(0,3)
            face(dir)
            wait .5
            useWateringCan
            wait .5
        end for
        print "should be full now " + waterLevel + " at waterpos " + waterpos + " actually at " + me.position
    end while
    gotoPosX(savepos.x)
    gotoPosY(savepos.y)
    face(saveFacing)
end function

isHeads = function()
    if floor(rnd*2)==1 then
        return true
    else
        return false
    end if
end function

farmAll = function(fa_segment)
    print " initial farmAll " + fa_segment
    fas = segments[fa_segment]
    isOdd = fas.y1%2 ==1 
    gotoPosX(fas.x1)
    gotoPosY(fas.y1)
    stuck = 0
    while true
        for fa_y in range(fas.y1,fas.y2)
            if isOdd and fa_y%2 == 1 then
                print "going to y " + fa_y
                gotoPosY(fa_y)
                if me.position.y == fa_y then
                    if fa_y%2 == 1 then
                        for fa_x in range(fas.x1,fas.x2)
                            print "going to x " + fa_x
                            gotoPosX(fa_x)
                            if me.position.x == fa_x then 
                                farmAroundThisTile
                                stuck = 0
                            else
                                 stuck =  stuck + 1
                                if  stuck > 3 then
                                    print "getting unstuck 773"
                                    getUnstuck(fa_x,fa_y)
                                    stuck = 0
                                    break
                                end if  
                            end if
                        end for
                    else
                        for fa_x in range(fas.x2,fas.x1)
                            gotoPosX(fa_x)
                            if me.position.x == fa_x then 
                                farmAroundThisTile
                                stuck = 0
                            else
                                 stuck =  stuck + 1
                                if  stuck > 3 then
                                    print "getting unstuck 789"
                                    getUnstuck(fa_x,fa_y)
                                    stuck = 0
                                    break
                                end if  
                            end if
                        end for
                    end if  
                end if
            else  
            end if                  
        end for
    end while
end function

if me.position.area.name == "Cellar" then
    doCellar
else
    botname = me.name
    world.chat "I am at " + me.position.x + "," + me.position.y
    if me.name == "Farmtronics Bot 13" then doKegs  
    if me.name == "Farmtronics Bot Zero" then farmAll(0)
    if me.name == "Farmtronics Bot 1" then farmAll(1)
    if me.name == "Farmtronics Bot 2" then farmAll(2)
    if me.name == "Farmtronics Bot 3" then farmAll(3)
    if me.name == "Farmtronics Bot 4" then farmAll(4)
    if me.name == "Farmtronics Bot 5" then farmAll(5)
    if me.name == "Farmtronics Bot 6" then farmAll(6)
    if me.name == "Farmtronics Bot 7" then farmAll(7)
    if me.name == "Farmtronics Bot 8" then farmAll(8)
    if me.name == "Farmtronics Bot 9" then farmAll(9)
    if me.name == "Farmtronics Bot 10" then farmAll(10)
    if me.name == "Farmtronics Bot 11" then farmAll(11)
    if me.name == "Farmtronics Bot Cellar" then farmAll(11)
end if

