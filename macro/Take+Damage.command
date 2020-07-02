<!-- Read the damage and the properties and make sure they are numbers --> 
[h: abort(input("dmg|0|Enter Damage:|TEXT|WIDTH=4"))]
[h, if (!isNumber(dmg) || dmg < 0): dmg = 0; '']
[h: current = getProperty("HP")]
[h, if (!isNumber(current)): current = 0; '']
[h: temporary = getProperty("TempHP")]
[h, if (!isNumber(temporary)): temporary = 0; '']
[h: maximum = getProperty("MaxHP")]
[h, if (!isNumber(maximum)): maximum = 0; '']

<!-- Remove temp hit points -->
[h, if (dmg >= temporary), code: {
	[h: dmg = dmg - temporary]
	[h: temporary = 0]
};{
	[h: temporary = temporary - dmg]
	[h: dmg = 0]
}]

<!-- Subtract the damage from the current hitpoints and set properties -->
[h, if (dmg >= current): current = 0; current = current - dmg]
[h: setProperty("HP", current)]
[h: setProperty("TempHP", temporary)]

<!-- Calculate effective and set bars -->
[h: effectiveHP = current + temporary]
[h: effectiveMaxHP = maximum + temporary]
[h: effectiveDamage = effectiveMaxHP - effectiveHP]
[h: setBar("HP", current / effectiveMaxHP)]
[h: setBar("Damage", effectiveDamage / effectiveMaxHP)]

<!-- Set states -->
[h, if (isPC()), code: {
	[h: setState("Dying", if(current == 0, 1, 0))]
};{
	[h: setState("Dead", if(current == 0, 1, 0))]
	[h, if (current == 0): removeFromInitiative(id) ; ""]
}]
[h: setState("Bloodied", if(current > 0 && current <= (maximum / 2), 1, 0))]