
    for y in range(0, farm.height-1)
        for x in range(0, farm.width-1)
            t = farm.tile(x,y)
            if t and t.hasIndex("passable") and t.passable == 1 and t.name != "Building" and t.name != "Flooring" and t.name != "HoeDirt" then 
                print t.name + " " + x + " " + y
            end if
        end for
    end for

    return4 = function(arrayin)
        return arrayin[4]
    end function
    x = [1,2,3,4,5]
    y = return4(x)
    print "x: " + x[4]
    print "y: " + y
    x[4] = 99
    print "x: " + x[4]
    print "y: " + y

exit


f = file.open("kegpath.txt", "a")
    f.write "["
    for y in range(0, farm.height-1)
        for x in range(0, farm.width-1)
            t = farm.tile(x,y)
            if t and t.hasIndex("name") and t.name.indexOf("Flooring") > -1 then 
                f.write "{""x"":" + x + ",""y"":" + y + "}," + char(13)
            end if
        end for
    end for
    f.write "]"
f.close

exit

    planted = []
    for x in range(-100, farm.width+100)
        for y in range(-100, farm.height+100)
            t = farm.tile(x,y)
            if t and t.hasIndex("crop") and t.crop and t.crop.hasIndex("name") then 
                notfound = true
                if planted then
                    for i in range(0,planted.len-1)
                        if planted[i] == t.crop.name then
                            notfound = false
                            break
                        end if
                    end for
                    if notfound then planted.push(t.crop.name)
                else 
                    planted.push(t.crop.name)
                end if
            end if
        end for
    end for
    print planted

        for x in range(9, 14)
        for y in range(0, farm.height-1)
            t = farm.tile(x,y)
            if t and t.hasIndex("name") and t.name.indexOf("Iridium Sprinkler") > -1 then 
                print t.name + " " + x + " " + y
            end if
        end for
    end for

