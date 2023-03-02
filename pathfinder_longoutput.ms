// take bots off flooring first

// set the area you are looking in
_area = farm

// set the position of the starting point Flooring
start_x = 3
start_y = 9
globals.path = []

globals.north = 0
globals.east = 1
globals.south = 2
globals.west = 3

i = 0
x = -1
y = -1

t = _area.tile(start_x,start_y)
if t and t.hasIndex("name") and t.name.indexOf("Flooring") > -1 then 
    print "starting tile found"
    globals.path.push({"i":i,"x":start_x,"y":start_y,"n":-1,"e":-1,"s":-1,"w":-1})
    x = start_x
    y = start_y
else
    print "starting tile not Flooring"
    exit
end if

findTileByXY = function(x,y)
    for i in range(0, globals.path.len-1)
        tile = globals.path[i]
        if tile.x == x and tile.y == y then
            print "exists: " + i
            return i
        end if
    end for
    return -1
end function

// recursive function, might blow stack, depends
doTile = function(i,x,y)
    //print "doing " + i + "," + x + "," + y
    for dir in range(0,3)
        xx = x
        yy = y
        if dir == globals.north then 
            yy = y - 1
        else if dir == globals.south then 
            yy = y + 1
        else if dir == globals.east then 
            xx = x + 1
        else if dir == globals.west then 
            xx = x - 1
        end if   
        //print xx + "," + yy + " - " + dir
        t = _area.tile(xx,yy)
        //print t
        if t and t.hasIndex("name") and t.name.indexOf("Flooring") > -1 then 
            if dir == north and globals.path[i].n == -1 then 
                ti = findTileByXY(xx,yy) 
                if ti > -1 then
                    globals.path[i].n = ti
                else
                    print i + " : " + xx + "," + yy + " - " + dir
                    globals.path[i].n = globals.path.len
                    globals.path.push({"i":globals.path.len,"x":xx,"y":yy,"n":-1,"e":-1,"s":i,"w":-1})
                    ii = globals.path.len-1
                    doTile(ii,xx,yy)
                end if
            else if dir == south and globals.path[i].s == -1 then
                ti = findTileByXY(xx,yy) 
                if ti > -1 then
                    globals.path[i].s = ti
                else
                    print i + " : " + xx + "," + yy + " - " + dir
                    globals.path[i].s = globals.path.len
                    globals.path.push({"i":globals.path.len,"x":xx,"y":yy,"n":i,"e":-1,"s":-1,"w":-1})
                    ii = globals.path.len-1
                    doTile(ii,xx,yy)
                end if
            else if dir == east and globals.path[i].e == -1 then
                ti = findTileByXY(xx,yy) 
                if ti > -1 then
                    globals.path[i].e = ti
                else
                    print i + " : " + xx + "," + yy + " - " + dir
                    globals.path[i].e = globals.path.len
                    globals.path.push({"i":globals.path.len,"x":xx,"y":yy,"n":-1,"e":-1,"s":-1,"w":i})
                    ii = globals.path.len-1
                    doTile(ii,xx,yy)
                end if
            else if dir == west and globals.path[i].w == -1 then
                ti = findTileByXY(xx,yy) 
                if ti > -1 then
                    globals.path[i].w = ti
                else
                    print i + " : " + xx + "," + yy + " - " + dir
                    globals.path[i].w = globals.path.len
                    globals.path.push({"i":globals.path.len,"x":xx,"y":yy,"n":-1,"e":i,"s":-1,"w":-1})
                    ii = globals.path.len-1
                    doTile(ii,xx,yy)
                end if
            end if 
        else
            continue
        end if
    end for
end function

doTile(0,start_x,start_y)

// write globals.path to file
f = file.open("kegpath.txt", "w")
    f.write globals.path
f.close
