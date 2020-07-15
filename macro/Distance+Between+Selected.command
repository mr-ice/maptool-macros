[h: me = currentToken()]
[h: selected = getSelected()]
[h: log.info("before: me=" + me + " selected   =" + selected)]
[h, if (me == ""), code: {
	[h: me = listGet(selected, 0)]
	[h: selected = listDelete(selected, 0)]
}]
[h: log.info("after: me=" + me + " selected   =" + selected)]
[h, foreach(other, selected), code: {
	[h: meHeight = getProperty("Elevation", me)]
	[h: meHeight = if(isNumber(meHeight), meHeight, 0)]
	[h: otherHeight = getProperty("Elevation", other)]
	[h: otherHeight = if(isNumber(otherHeight), otherHeight, 0)]
	[h: height = math.abs(meHeight - otherHeight)]
	[h, if (other != me): broadcast("Distance between " + getName(me) + " and " + getName(other) + " is " 
									+ math.max(height, getDistance(other, 1, me, "ONE_ONE_ONE")) + "<br/>"); '']
}]