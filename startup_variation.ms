sections = []
xx = 10
yy = 18
for cols in range(1,3)
    xx = 10
    for rows in range (1,4)
        sections.push({"x1":xx,"y1":yy,"x2":xx+16,"y2":yy+12})
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

facingFloor = function()
    if me.ahead and me.ahead.type == "Flooring" then
        return true
    else
        return false
    end if
end function

facingSprinkler = function()
    if me.ahead and me.ahead.name == "Iridium Sprinkler" then
        return true
    else
        return false
    end if
end function

canGoForward = function()
    if facingFloor then 
        return "floor"
    else if facingSprinkler then
        return "sprinkler"
    else if not me.ahead or me.ahead.passable then
        return "go"
    else 
        return "not passable"
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

gotoPosition = function(gotoX, gotoY, clearPath=false)
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
    else if inTile.hasIndex("name") and inTile.name == "Iridium Sprinkler" then
        whatItIs = "sprinkler"
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

outcomes = {"not found":0,"NULL":10,"floor":-9999,"crop":9999,"cropDry":15,"cropDead":10,"cropHarvestScythe":9999,"cropHarvest":9999,"hoe":10,"clear":50,"chest":10,"fruitTree":0,"water":1000,"changeDirection":10,"passable":10}
scoreTiles = function(arrayOfWhats)
    if not arrayOfWhats then return -999
    st_score = 0
    for st_i in range(0,arrayOfWhats.len-1)
        st_what = arrayOfWhats[st_i]
        if st_what=="water" then
            //ignore water
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

selectInventoryByType = function(type="Hoe")
    for sibti in range(0,11)
        if me.inventory[sibti].hasIndex("type") and me.inventory[sibti].type == type then
            me.select sibti
            return sibti
        end if
    end for
    return -1
end function

usePickaxe = function()
    if selectInventoryByType("Pickaxe") > -1 then me.useTool
end function

useScythe = function()
    if selectInventoryByName("Scythe") > -1 then me.useTool
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

dirLeft = function()
    curFace = me.facing
    if curFace == north then return west
    if curFace == east then return north
    if curFace == south then return east
    if curFace == west then return south
end function

dirRight = function()
    curFace = me.facing
    if curFace == north then return east
    if curFace == east then return south
    if curFace == south then return west
    if curFace == west then return north
end function

tileLeft = function(distance=1)
    curFace = me.facing
    curX = me.position.x
    curY = me.position.y
    if curFace == north then curX = curX - distance
    if curFace == east then curY = curY - distance
    if curFace == south then curX = curX + distance
    if curFace == west then curY = curY + distance
    return me.position.area.tile(curX, curY)
end function

tileRight = function(distance=1)
    curFace = me.facing
    curX = me.position.x
    curY = me.position.y
    if curFace == north then curX = curX + distance
    if curFace == east then curY = curY + distance
    if curFace == south then curX = curX - distance
    if curFace == west then curY = curY - distance
    return me.position.area.tile(curX, curY)
end function

stayOnFlooring = function()
    open = []
    if facingFloor then
        open.push me.facing
    end if
    t = tileLeft
    if t and t.type == "Flooring" then
        print "tile left which is dir " + fName(dirLeft) + " of current facing " + fName(me.facing)
        open.push dirLeft
    end if
    t = tileRight
    if t and t.type == "Flooring" then
        print "tile right which is dir " + fName(dirRight) + " of current facing " + fName(me.facing)
        open.push dirRight
    end if
    if open then
        go = floor(rnd*open.len)
        face(open[go])
        print "selected random dir on floor is " + fName(open[go]) + ", now current facing " + fName(me.facing)
        me.forward
    else 
        // turn around
        print "turning around"
        me.right
        me.right
        print "now current facing " + fName(me.facing)
        if facingFloor then
            print "moved forward"
            me.forward
        end if       
    end if
    wait .2
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
            wait .1
        end if
        me.right
        me.right
        if me.ahead then
            doKeg
            wait .1
        end if
        me.right
        wait .1
        stayOnFlooring
    end while
end function

trellised = ["Hops Starter","Grape Starter","Bean Starter","Seed"]
tendTile = function(_t)  
    if world.season < 3 and world.dayOfSeason < 15 then            
        if selectInventoryByCat("Fertilizer") then me.placeItem
        seeded = false
        for i in range(0,trellised.len)
            if i == trellised.len then
                if selectInventoryByCat("Seed") then me.placeItem
            end if
            if not seeded and selectInventoryByName(trellised[i]) then 
                if me.position.x%2==1 and me.position.y%2==1 then
                    me.placeItem
                    seeded = true
                end if
            end if
        end for

    end if
end function

farmThisTile = function()
    _t  = "floor" 
    for ftti in range(0,3)
        if me.ahead then
            _t = whatIsTile(me.ahead)
            if _t == "floor" or _t == "sprinkler" then
            else if _t == "crop" then
                me.harvest
            else if _t == "cropDead" then 
                me.clearAhead
                print "using hoe"
                useHoe
                tendTile
            else if _t == "hoe" then
                print "using hoe"
                useHoe
                tendTile
            else if _t == "cropHarvest" then 
                me.harvest
            else if _t == "cropHarvestScythe" then 
                useScythe
            else if _t == "clear" then 
                me.clearAhead
            else if _t == "chest" then
                saveFarmedItemsToChest
            else if _t  == "passable" then
                me.harvest
                me.clearAhead
            end if
        else
            print "using hoe"
            useHoe
            tendTile
        end if
        wait .1
    end for
    wait .1
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
        wait .2
    end while
    print "made it to " + me.position + " = " + x + "," + y + " h1:" + heads1 + " h2:" + heads2
end function

gotoPosX = function(gpxin_x)
    print "632 going to x=" + gpxin_x
    while me.position.x < gpxin_x
        faceEast
        if canGoForward == "go" then
            print "going east "
            me.forward
            wait 1
        else
            print "can't go east, go south and exit gotoPosX"
            faceSouth
            if canGoForward then me.forward
            return             
        end if
    end while
    counter = 0
    while me.position.x > gpxin_x
        faceWest
        if canGoForward == "go" then
            print "going west "
            me.forward
            wait 1
        else
            print "can't go west, go south and exit gotoPosX"
            faceSouth
            if canGoForward then me.forward
            return             
        end if
    end while
end function

gotoPosY = function(gpyin_y)
    counter = 0
    while me.position.y < gpyin_y and counter < 100
        faceSouth
        if canGoForward == "go" then
            me.forward
            wait 1
        else
            if isHeads then
                faceWest
                if canGoForward then me.forward
                wait .1
            else
                faceEast
                if canGoForward then me.forward
                wait .1
            end if             
        end if
        counter = counter + 1
    end while
    counter = 0
    while me.position.y > gpyin_y and counter < 100
        faceNorth
        if canGoForward == "go" then
            me.forward
            wait 1
        else
            if isHeads then
                faceWest
                if canGoForward then me.forward
                wait .1
            else
                faceEast
                if canGoForward then me.forward
                wait .1
            end if             
        end if
        counter = counter + 1
    end while
end function

isHeads = function()
    if floor(rnd*2)==1 then
        return true
    else
        return false
    end if
end function

farmAllRow = function(fa_x)
    print "going to x " + fa_x
    gotoPosX(fa_x)
    if me.position.x == fa_x then 
        farmAroundThisTile
    end if
end function

farmAll = function(fa_section)
    print " initial farmAll " + sections[fa_section]
    fas = sections[fa_section]
    isOdd = fas.y1%2 ==1 
    gotoPosX(fas.x1)
    gotoPosY(fas.y1)
    stuck = 0
    while true
        print "in while"
        for fa_y in range(fas.y1,fas.y2)
            isOdd2 = fa_y%2 == 1
            if isOdd==isOdd2 then
                print "going to y " + fa_y
                gotoPosY(fa_y)
                if me.position.y == fa_y then
                    if(abs(fas.x1-me.position.x)<abs(fas.x2-me.position.x)) then
                        for fa_x in range(fas.x1,fas.x2)
                            farmAllRow(fa_x)
                        end for
                    else 
                        for fa_x in range(fas.x2,fas.x1)
                            farmAllRow(fa_x)
                        end for
                    end if
                else
                    continue
                end if
            else  
                continue
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

