[h: changes = "['+20','+10','+5',0,-5,-10,-20]"]
[h: junk = abort(input("elevation|"+elevation+"|Set Elevation (0 clears)|text",
  "elevation_index|"
  + json.toList(changes)
  + "|Elevation Change|radio|SELECT=3 ORIENT=V SPAN=FALSE"
  ))]
[h: elevation = add(elevation, number(json.get(changes,elevation_index)))]
[h,if(elevation == 0),CODE:
{
	[h:resetProperty("elevation")]
	[h:setBarVisible("ElevationPositive", 0)]
	[h:setBarVisible("ElevationNegative", 0)]
};
{
	[h:setProperty("elevation", elevation)]
	[h, if(elevation > 0), CODE:
	{
		[h:setBar("ElevationPositive", elevation / 100)]
		[h:setBarVisible("ElevationNegative", 0)]
	};
	{
		[h:setBar("ElevationNegative", math.abs(elevation) / 100)]
		[h:setBarVisible("ElevationPositive", 0)]
	}]
}]
