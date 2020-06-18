[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=fals"))]
	[h: return (0, error)]
}]

[h: setState ("Bloodied", 0)]
[h: setState ("Dying", 0)]

[h: isHalved = getState ("Exhaustion 4")]
[h: isDead = getState ("Exhaustion 6")]
[h: hitPoints = json.get (basicToon, "hitPoints")]
[h: log.debug (hitPoints)]
[h: current = json.get (hitPoints, "currentHp")]
[h: maximum = json.get (hitPoints, "maxHp")]
<!-- dont apply effects of half-max from exhaustion. Not sure I want to do that yet -->
[h: halfMax = round (math.floor( maximum / 2))]
[h, if (maximum < current): current = maximum]
[h: setProperty ("HP", current)]
[h: setProperty ("TempHP", json.get (hitPoints, "tempHp"))]
[h: setProperty ("MaxHP", maximum)]
[h, if (current < halfMax): setState ("Bloodied", 1); setState ("Bloodied", 0)]
[h, if (current == 0 && isDead == 0), code: {
	[h: setState ("Dying", 1)]
}]
[h, if (current > 0 && isDead == 0), code: {
	[h: setState ("Dead", 0)]
}]
[h, if (isDead > 0), code: {
	[h: setState ("Dying", 0)]
	[h: setState ("Dead", 1)]
}]
