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
