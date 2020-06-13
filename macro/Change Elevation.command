[h: changes = "['+20','+10','+5',0,-5,-10,-20]"]
[h: junk = abort(input("elevation|"+elevation+"|Set Elevation (0 clears)|text",
  "elevation_index|"
  + json.toList(changes)
  + "|Elevation Change|radio|SELECT=3 ORIENT=V SPAN=FALSE"
  ))]
[h: elevation = add(elevation, number(json.get(changes,elevation_index)))]
[h,if(elevation == 0):resetProperty("elevation");setProperty("elevation", elevation)]