[h: basicToon = dndb_getBasicToon ()]

<!-- Clear all of the states/bars -->
[h: setState ("Bloodied", 0)]
[h: setState ("Dying", 0)]
[h: setState ("Dead", 0)]
[h: setState ("Stable", 0)]
[h: setBarVisible ("DSPass", 0)]
[h: setBarVisible ("DSFail", 0)]

<!-- Read the HP state -->
[h: isHalved = getState ("Exhaustion 4")]
[h: isDead = getState ("Exhaustion 6")]
[h: hitPoints = json.get (basicToon, "hitPoints")]
[h: log.debug (hitPoints)]
[h: current = json.get (hitPoints, "currentHp")]
[h: maximum = json.get (hitPoints, "maxHp")]
[h: temporary = json.get (hitPoints, "tempHp")]
[h: dsPass = json.get (hitPoints, "dsPass")]
[h: dsFail = json.get (hitPoints, "dsFail")]

<!-- Set the properties --> 
<!-- dont apply effects of half-max from exhaustion. Not sure I want to do that yet -->
[h: halfMax = round (math.floor( maximum / 2))]
[h, if (maximum < current): current = maximum; ""]
[h: setProperty ("HP", current)]
[h: setProperty ("TempHP", temporary)]
[h: setProperty ("MaxHP", maximum)]

<!-- Set the states/bars --> 
[h, if (current < halfMax && current > 0): setState ("Bloodied", 1); setState ("Bloodied", 0);]
[h, if (current == 0 && isDead == 0 && dsPass < 3 && dsFail < 4), code: {
	[h: setState ("Dying", 1)]
	[h: setBar ("DSPass", 0.25 * dsPass)]
	[h: setBar ("DSFail", 0.25 * dsFail)]
}; {}]
[h: setState ("Dead", if ((current == 0 && dsFail >= 3) || isDead, 1, 0))]
[h: setState ("Stable", if ((current == 0 && dsPass >= 3), 1, 0))]
[h: setBar ("HP", current / maximum)]
[h, if (temporary > 0): setBar ("TempHP", temporary / maximum); setBarVisible ("TempHP", 0)]