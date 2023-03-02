waitTime = .05 //0.0001 // in seconds

kegpath = [{"y":9,"x":3},{"y":9,"x":50},{"y":10,"x":50},{"y":10,"x":58},{"y":12,"x":58},{"y":12,"x":6},{"y":14,"x":6},{"y":14,"x":58},{"y":17,"x":58},{"y":17,"x":6},{"y":17,"x":69},{"y":14,"x":69},{"y":14,"x":70},{"y":12,"x":70},{"y":12,"x":73},{"y":14,"x":73},{"y":14,"x":74},{"y":27,"x":74},{"y":27,"x":76},{"y":33,"x":76},{"y":33,"x":75},{"y":54,"x":75},{"y":54,"x":70},{"y":57,"x":70},{"y":57,"x":66},{"y":59,"x":66},{"y":59,"x":7},{"y":35,"x":7},{"y":35,"x":4},{"y":60,"x":4},{"y":35,"x":4},{"y":35,"x":7},{"y":34,"x":7},{"y":34,"x":8},{"y":21,"x":8},{"y":21,"x":3},{"y":21,"x":8},{"y":19,"x":8},{"y":19,"x":3}]
coffeePath = [{"x":8,"y":14},{"x":8,"y":18},{"x":22,"y":18},{"x":22,"y":13},{"x":22,"y":18},{"x":24,"y":18},{"x":24,"y":21},{"x":24,"y":18},{"x":26,"y":18},{"x":26,"y":21},{"x":26,"y":18},{"x":33,"y":18},{"x":28,"y":18},{"x":28,"y":21},{"x":33,"y":21},{"x":28,"y":21},{"x":28,"y":27},{"x":27,"y":27},{"x":27,"y":32},{"x":27,"y":27},{"x":24,"y":27},{"x":24,"y":32},{"x":24,"y":27},{"x":32,"y":27},{"x":29,"y":27},{"x":29,"y":32},{"x":29,"y":27},{"x":32,"y":27},{"x":32,"y":32},{"x":32,"y":27},{"x":28,"y":27},{"x":28,"y":18},{"x":22,"y":18},{"x":8,"y":18},{"x":8,"y":14}]

kegpath2 = [{"x": 3, "y": 9}, {"x": 50, "y": 9}, {"x": 50, "y": 10}, {"x": 58, "y": 10}, {"x": 58, "y": 12}, {"x": 6, "y": 12}, {"x": 6, "y": 14}, {"x": 58, "y": 14}, {"x": 58, "y": 17, "choices": [0, 1, 3]}, {"x": 69, "y": 17}, {"x": 69, "y": 14}, {"x": 70, "y": 14}, {"x": 70, "y": 12}, {"x": 73, "y": 12}, {"x": 73, "y": 14}, {"x": 74, "y": 14}, {"x": 74, "y": 27}, {"x": 76, "y": 27}, {"x": 76, "y": 33}, {"x": 75, "y": 33}, {"x": 75, "y": 54}, {"x": 70, "y": 54}, {"x": 70, "y": 57}, {"x": 66, "y": 57}, {"x": 66, "y": 59}, {"x": 7, "y": 59}, {"x": 7, "y": 35, "choices": [0, 2, 3]},{"x":4,"y":35},{"x":4,"y":60},{"x":4,"y":35},{"x":7,"y":35},{"x": 7, "y": 34}, {"x": 8, "y": 34}, {"x": 8, "y": 21, "choices": [0, 2, 3]}, {"x": 3, "y": 21}, {"x": 8, "y": 21}, {"x": 8, "y": 19}, {"x": 3, "y": 19, "choices": [0, 1, 2]}]

PathPoint = {"x":0,"y":0,"d":0,"v":0}
kegpathStart = new PathPoint
kegpathStart.x = 3
kegpathStart.y = 9
coffeepathStart = new PathPoint
coffeepathStart.x = 8
coffeepathStart.y = 14
coffeepathStart.d = 2

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
    if direction < 0 or direction > 3 then
        print "bad direction " + direction
        wait 1
        return
    end if
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
    wait waitTime
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
                wait waitTime
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
                wait waitTime
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
                wait waitTime
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
                wait waitTime
                //farmThisTile
            else
                stuck = stuck + 1
            end if
        end if
        wait waitTime
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
            wait waitTime
            tryToEscape(stuck, clearPath)
            stuck = stuck + 1
        end if
        if stuck > 6 then
            print "stuck, giving up"
            stuck = 0
            wait waitTime
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
    if inTile == -1 then 
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

inventoryCount = function(cat="Fertilizer")
    count = 0
    for ic in range(0,11)
        if me.inventory[ic] then
            count = count + 1
        end if
    end for
    return count
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

selectInventoryByName = function(name="Grass Starter", cofmin=0)
    for sibni in range(0,11)
        inv = me.inventory[sibni]
        if inv.hasIndex("name") and inv.name == name then
            print "found coffee of " + inv.stack
            print "min is " + cofmin
            if cofmin == 0 or inv.stack >= cofmin then
                me.select sibni
                return sibni
            end if
        end if
    end for
    return -1
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

waterIt = function()
    while true
        for i in range(0,11)
            inv = me.inventory[i]
            if inv.hasIndex("type") and inv.type == "WateringCan" and inv.waterLeft > 0 then
                me.select i
                me.useTool
                return
            end if
        end for
        world.chat "Coffee bot out of water"
        stayOnFloorToPoint(coffeepathStart)
        wait waitTime
    end while
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

stayOnFlooring = function()
    open = []
    x = me.position.x
    y = me.position.y
        if facingFloor then
            open.push me.facing
        end if
        me.left
        if facingFloor then
            open.push me.facing
        end if
        me.right
        me.right
        if facingFloor then
            open.push me.facing
        end if
    if open then
        go = floor(rnd*open.len)
        face(open[go])
        me.forward
    else 
        me.right
        if facingFloor then
            me.forward
        end if       
    end if
    wait waitTime
end function

getVisitedIndex = function(x,y,visitedPoints)
    for i in range (0,visitedPoints.len-1)
        p = visitedPoints[i]
        if x == p.x and y == p.y then
            return i
        end if
    end for
    return -1
end function

tileIsFloor = function(x,y,dir,dist)
    t = me.position.area.tile(x,y)
    if t and t.hasIndex("name") and t.name == "Flooring" then
        return true
    end if
    return false
end function

stayOnFloorGo = function(visitedPoints)
    tiles = []
    x = me.position.x
    y = me.position.y
    p = []

    wait waitTime

    for dir in range(0,3)
        for dist in range(1,3)
            if dir == north then 
                xx = x
                yy = y - dist
            else if dir == south then 
                xx = x
                yy = y + dist
            else if dir == east then 
                xx = x + dist
                yy = y
            else if dir == west then 
                xx = x - dist
                yy = y
            end if   
            if tileIsFloor(xx,yy,dir,dist) then 
                tiles.push{"x":xx,"y":yy,"d":dir,"v":0}
            else
                break
            end if
        end for
    end for

    for tile in range(0,tiles.len-1)
        if tiles.len < 1 then break
        t = tiles[tile]
        vi = getVisitedIndex(t.x,t.y,visitedPoints)
        if vi == -1 then
            p.push(t)
        else
            visitedPoints[vi].d = t.d
            p.push(visitedPoints[vi])
        end if
    end for

    if p.len == 0 then
        print "no points"
        wait 1
        return
    end if

    for i in range(0, p.len-1)
        for j in range(0, p.len-1)
            if j == i then continue
            if p[i].v > p[j].v then p[i].remove = true
        end for
    end for

    i = 0
    while i < p.len
        if p[i].hasIndex("remove") then 
            p.remove i
        else 
            i = i + 1
        end if
    end while

    if p.len > 1 then
        random = floor(rnd * p.len)
        p[0] = p[random]
    else
        return
    end if
print "choice " + fName(p[0])
    face(p[0].d)
    wait waitTime
print "facing " + fName(me.facing)
    me.forward
    
    if x != me.position.x or y != me.position.y then 
        i = getVisitedIndex(me.position.x,me.position.y,visitedPoints)
        if i == -1 then
            here = new PathPoint
            here.x = me.position.x
            here.y = me.position.y
            here.d = me.facing
            here.v = 1
            visitedPoints.push(here)
        else
            visitedPoints[i].d = me.facing
            visitedPoints[i].v = visitedPoints[i].v + 1
        end if
    end if
end function

stayOnFloorToPoint = function(destinationPoint)
    print "stay on floor to point " + destinationPoint
    here = new PathPoint
    here.x = me.position.x
    here.y = me.position.y
    here.d = north
    here.v = 1
    visitedPoints = []
    visitedPoints.push(here)
    while me.position.x != destinationPoint.x or me.position.y != destinationPoint.y
        stayOnFloorGo(visitedPoints)
        wait waitTime
    end while
end function

stayOnFloorDoAll = function(dir)
    visitedPoints = [{"x":me.position.x,"y":me.position.y,"d":-1,"v":99999}]
    face(dir)
    me.forward
    while true
        doCoffee()
        me.right
        if me.ahead then
            doCoffee()
        end if
        me.right
        me.right
        if me.ahead then
            doCoffee()
        end if
        me.right
        stayOnFloorGo(visitedPoints)
    end while
end function

doCellar = function()
    while true
        for dc_i in range(1,4)
            me.right
            wait waitTime
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
                    if selectInventoryByCat("Fruit") then 
                        me.placeItem
                    else if selectInventoryByCat("Vegetable") then 
                        me.placeItem
                    end if
                else if name == "Furnace" then
                    me.harvest
                    if selectInventoryByName("Quartz") or selectInventoryByName("Iridium Ore") then me.placeItem
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
        if canGoForward == "floor" then
            me.forward
        else
            me.right
        end if
        //if world.timeOfDay > 2200 then exit
    end while
end function

doKeg = function()
    wait waitTime
    if not me.ahead then return
    name = me.ahead.name
    if name == "Keg" then
        if me.harvest then
            print "Keg harvested"
        end if
        wait waitTime
        s = selectInventoryByName("Coffee Bean",5)
        if s > -1 then //selectInventoryByCat("Fruit") or selectInventoryByName("Hops") or selectInventoryByName("Wheat") or 
            print "placing coffee in keg"
            me.placeItem
        else
            //world.chat "keybot out of stuff to put in keg " + me.position.x + "," + me.position.y
            //wait 10
        end if
    else if name == "Preserves Jar" then
        me.harvest
        if selectInventoryByCat("Vegetable") then 
            me.placeItem
        else
            world.chat "keybot out of veg at " + me.position.x + "," + me.position.y
            wait 10
        end if
    else if name == "Statue Of Perfection" then
        me.harvest
    else if name == "Chest" then
        tentries = 0
        while (selectInventoryByCat("Artisan Goods") or selectInventoryByName("Coffee")) and tentries<10
            me.placeItem
            tentries = tentries + 1
            wait waitTime
        end while
    end if
end function

doCoffee = function()
    if not me.ahead then return
    name = me.ahead.name
    if name == "Garden Pot" then
        me.takeItem
        wait waitTime
        waterIt()
    else if name == "Building" and me.ahead.hasIndex("action") and me.ahead.action == "kitchen" then
        for i in range(0,7)
            me.select i
            me.useTool
            wait .1
        end for
    else if name == "Chest" then
        tries = 0
        while selectInventoryByName("Coffee Bean") and tries<3
            me.placeItem
            tries = tries + 1
            wait waitTime
        end while
    end if
end function

isOnPoint = function(path,point)
    for i in range(0,path.len-1)
        if path[i].x == point.x and path[i].y == point.y then return i
    end for
    return -1
end function

gotoNextPoint = function(path)
    tries = 100
    while tries > 0
        tries = tries - 1
        i = isOnPoint(path,me.position)
        if i > -1 then 
            return i
        end if
        if facingFloor then
            me.forward
        else
            me.right
        end if
        wait waitTime
    end while
    world.chat "something wrong, not finding next point at " + me.position.x + "," + me.position.y 
    wait 10
end function

followPath = function(path,point) 
    facing = me.facing
    go_x = -1
    go_y = -1
    if point.x > me.position.x then 
        go_x = east
    else if point.x < me.position.x then
        go_x = west
    end if
    if facing != go_x then
        if point.y > me.position.y then
            go_y = south
        else if point.y < me.position.y then
            go_y = north
        end if
    end if
    if facing != go_y then
        if go_x == -1 and go_y == -1 then
            return "on point"
        end if
    else 
        go_x = -1
    end if
    if go_x != -1 and go_y != -1 then
        if isHeads then
            face(go_x)
        else
            face(go_y)
        end if
    else if go_x != -1 then
        face(go_x)
    else
        face(go_y)
    end if
    wait .1
    print me.position.x + "," + me.position.y + " to " + point.x + "," + point.y + " going " + fName(me.facing)
    if canGoForward == "floor" then
        me.forward
    else
        world.chat "blocked at " + me.position.x + "," + me.position.y + " going to point " + point
        return "blocked"    
    end if

    wait waitTime
    return true
end function

runPathTo = function(path, point)
    while followPath(path, point) != "on point"
        wait .1
    end while
end function

doKegsSpin = function()
    doKeg
    me.right
    wait waitTime
    doKeg
    me.right
    me.right
    wait waitTime
    doKeg
    me.right
    wait waitTime
end function

doKegs = function()
    i = gotoNextPoint(kegpath) + 1
    if i>kegpath.len-1 then i=0  
    print "going to " + kegpath[i]
    while true
        ks = followPath(kegpath, kegpath[i])
        doKegsSpin
        while ks != "on point"
            if canGoForward == "floor" then
                me.forward
            else
                i = gotoNextPoint(kegpath)
                break            
            end if
            doKegsSpin
        end while
        i = i + 1
        if i>kegpath.len-1 then i=0  
    end while
end function

findPointOnPath = function(x,y,path)
    found = []
    for i in range(0,path.len-1)
        p = path[i]
        if p.x == x or p.y == y then
            found.push({"x":p.x,"y":p.y,"i":i})
        end if
    end for
    dist = 9999
    best = -1
    for i in range(0,found.len-1)
        d = abs(found[i].x - x) + abs(found[i].y - y)
        if d < dist then
            best = found[i].i
            dist = d
        end if
        // should check for clear path
    end for
    return best
end function

dirToPoint = function(point)
    x = me.position.x
    y = me.position.y
    d = -1
    if point.x > x then 
        return east
    else if point.x < x then 
        return west
    else if point.y > y then 
        return south
    else if point.y < y then 
        return north
    end if 
    print " bad direction going from " + x + "," + y + " to " + point
    return d
end function

gotoPoint = function(point)
    d = dirToPoint(point)
    face(d)
    me.forward
    wait waitTime
end function

doKegs2 = function()
    x = me.position.x
    y = me.position.y
    i = findPointOnPath(x,y,kegpath2)
    i = i + 1
    
    if i>kegpath2.len-1 then i=0 
    print "found " + i + " : " + kegpath2[i] 
    while true
        print "going to " + kegpath2[i]
        gotoPoint(kegpath2[i])
        if me.position.x == kegpath2[i].x and me.position.y == kegpath2[i].y then
            i = i + 1
            if i>kegpath2.len-1 then i=0 
        end if
        doKegsSpin
        wait waitTime
    end while
end function


doCoffees = function()
    i = gotoNextPoint(coffeePath) + 1
    start_i = i
    if i>coffeePath.len-1 then i=0  
    print "going to " + coffeePath[i]
    while true
        doCoffee()
        me.right
        if me.ahead then
            doCoffee()
        end if
        me.right
        me.right
        if me.ahead then
            doCoffee()
        end if
        me.right
        fp = followPath(coffeePath, coffeePath[i])
        
        if fp == "blocked" then
            me.right
            wait 1
        end if
        if fp == "on point" then
            i = i + 1
            if i>coffeePath.len-1 then
                runPathTo(coffeePath, coffeePath[0])
                exit
            end if
        end if
    end while
end function

trellised = ["Hops Starter","Grape Starter","Bean Starter","Seed"]
tendTile = function(noTrellis)  
    if world.season < 3 then            
        if selectInventoryByCat("Fertilizer") then me.placeItem
        seeded = false
        for i in range(0,trellised.len-1)
            if i == trellised.len-1 then
                if selectInventoryByCat("Seed") then 
                    me.placeItem
                    seeded = true
                end if
            end if
            if not noTrellis then
                if not seeded and selectInventoryByName(trellised[i]) then 
                    if me.position.x%2==1 and me.position.y%2==1 then
                        me.placeItem
                        seeded = true
                    end if
                end if
            end if
        end for
    end if
end function

farmThisTile = function(noTrellis)
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
                tendTile(noTrellis)
            else if _t == "hoe" then
                print "using hoe"
                useHoe
                tendTile(noTrellis)
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
            tendTile(noTrellis)
        end if
        wait waitTime
    end for
    wait waitTime
end function

farmAroundThisTile = function()
    farmThisTile(true)
    me.left
    farmThisTile
    me.right
    me.right
    farmThisTile
    me.right
end function

doClearAll = function(width,height)
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

gotoPosX = function(gpxin_x)
    while me.position.x < gpxin_x
        faceEast
        if canGoForward == "go" then
        else
            faceSouth
            if canGoForward then me.forward
            wait waitTime
            return             
        end if
    end while
    while me.position.x > gpxin_x
        faceWest
        if canGoForward == "go" then
            me.forward
        else
            faceSouth
            if canGoForward then me.forward
            wait waitTime
            return             
        end if
    end while
    wait waitTime
end function

gotoPosY = function(gpyin_y)
    while me.position.y < gpyin_y
        faceSouth
        if canGoForward == "go" then
            me.forward
        else
            if isHeads then
                me.left
            else
                me.right
            end if
            me.forward
            me.forward
            me.forward
            faceSouth
        end if
    end while
    while me.position.y > gpyin_y
        faceNorth
        if canGoForward == "go" then
            me.forward
        else
             if isHeads then
                me.left
            else
                me.right
            end if
            me.forward
            me.forward
            me.forward            
        end if
    end while
    wait waitTime
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

farmAll = function(fa_y)
    print " initial farmAll " + fa_y
    gotoPosY(fa_y)
    if me.position.y != fa_y then
        world.chat " no on y=" + fa_y + " at " + me.position
        wait 60
    end if
    going = east
    while true
        if world.timeOfDay > 2100 then
            faceEast
            if canGoForward=="go" then 
                me.forward
                wait waitTime
                farmAroundThisTile
            else
                exit
            end if
        else if going == east then
            faceEast
            if me.position.x < 73 then 
                if canGoForward=="go" then 
                    me.forward
                    wait waitTime
                    farmAroundThisTile
                    faceEast
                else 
                    faceWest
                    going = west
                    continue
                end if
            else 
                faceWest
                going = west
                continue
            end if
        else if going == west then 
            faceWest
            if me.position.x > 9 then 
                if canGoForward=="go" then 
                    me.forward
                    wait waitTime
                    farmAroundThisTile
                    faceWest
                else 
                    faceEast
                    going = east
                    continue
                end if
            else 
                faceEast
                going = east
                continue
            end if
        else
            faceEast
            going = east
            continue
        end if
    end while
end function

starting_y = [19,21,24,26,29,31,34,36,39,41,44,46,49,51,54,56]
if me.position.area.name == "Cellar" then
    doCellar
else
    botname = me.name
    world.chat "I am at " + me.position.x + "," + me.position.y + " inventory slots full: " + inventoryCount
    if me.name == "Farmtronics Bot Keg" then doKegs2

    if me.name == "Farmtronics Bot Zero" then farmAll(starting_y[0])
    if me.name == "Farmtronics Bot 1" then farmAll(starting_y[1])
    if me.name == "Farmtronics Bot 2" then farmAll(starting_y[2])
    if me.name == "Farmtronics Bot 3" then farmAll(starting_y[3])
    if me.name == "Farmtronics Bot 4" then farmAll(starting_y[4])
    if me.name == "Farmtronics Bot 5" then farmAll(starting_y[5])
    if me.name == "Farmtronics Bot 6" then farmAll(starting_y[6])
    if me.name == "Farmtronics Bot 7" then farmAll(starting_y[7])
    if me.name == "Farmtronics Bot 8" then farmAll(starting_y[8])
    if me.name == "Farmtronics Bot 9" then farmAll(starting_y[9])
    if me.name == "Farmtronics Bot 10" then farmAll(starting_y[10])
    if me.name == "Farmtronics Bot 11" then farmAll(starting_y[11])
    if me.name == "Farmtronics Bot 12" then farmAll(starting_y[12])
    if me.name == "Farmtronics Bot 13" then farmAll(starting_y[13])
    if me.name == "Farmtronics Bot 14" then farmAll(starting_y[14])
    if me.name == "Farmtronics Bot 15" then farmAll(starting_y[15])
    if me.name == "Farmtronics Bot 56" then 
        stayOnFloorToPoint(coffeepathStart)
        stayOnFloorDoAll(south)
    end if
end if

