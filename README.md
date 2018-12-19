# highfield_map_build_for_vrep
Build highfield map for simulation on Vrep

## build hihgfield map composed of cuboids and cylinders
Input parameters at transferfiles.txt: shape -- rect/circ
                  height -- the height of each object
                  x0  -- the postion of object in x coordinate
                  y0 -- the postion of object in y coordinate
                  xa -- the lenght of rectangle/ the radius of circle
                  ya -- the width of rectangle/ 0 if circle
                  orient -- oriention of each object
                  
After running main.m, you can get a .txt file, which is a highfiled map.
You can input highfield map to Vrep for simulation. 
 
