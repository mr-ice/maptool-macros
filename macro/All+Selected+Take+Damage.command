[h: sIds = getSelected()]
[h: sNames = getSelectedNames()]
[h, if (sNames == ""): names = "No tokens selected!"; names = ""]
[h, forEach(name, sNames): names = names + "<li>" + name]
[h: title = "junk|<html><b>Apply damage to the selected tokens:</b><ul>" + names + "</ul></html>|-|LABEL|SPAN=TRUE"]
[h: log.info("IDs:'" + sIds + "' Names:" + sNames)]

<!-- Read the damage and the properties and make sure they are numbers --> 
[h: abort(input(title, "sDamage|0|Enter Damage:|TEXT|WIDTH=4"))]
[h, if (!isNumber(sDamage) || sDamage < 0): sDamage = 0; '']
[h, foreach(id, sIds), code: {
	[h: dmg = sDamage]
	[h: log.info("ID: " + id + " Damage=" + dmg)]
	
	[h: current = getProperty("HP", id)]
	[h, if (!isNumber(current)): current = 0; '']
	[h: temporary = getProperty("TempHP", id)]
	[h, if (!isNumber(temporary)): temporary = 0; '']
	[h: maximum = getProperty("MaxHP", id)]
	[h, if (!isNumber(maximum)): maximum = 0; '']
	[h: log.info("Before: current=" + current + " temporary=" + temporary + " maximum=" + maximum)]

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
	[h: setProperty("HP", current, id)]
	[h: setProperty("TempHP", temporary, id)]
	[h: log.info("After: current=" + current + " temporary=" + temporary + " maximum=" + maximum)]

	<!-- Calculate effective and set bars -->
	[h: effectiveHP = current + temporary]
	[h: effectiveMaxHP = maximum + temporary]
	[h: effectiveDamage = effectiveMaxHP - effectiveHP]
	[h: log.info("effectiveHP=" + effectiveHP + " effectiveMaxHP=" + effectiveMaxHP + " effectiveDamage=" + effectiveDamage)]
	[h: setBar("HP", current / effectiveMaxHP, id)]
	[h: setBar("Damage", effectiveDamage / effectiveMaxHP, id)]

	<!-- Set states -->
	[h, if (isPC()), code: {
		[h: setState("Dying", if(current == 0, 1, 0), id)]
	};{
		[h: setState("Dead", if(current == 0, 1, 0), id)]
		[h, if (current == 0): removeFromInitiative(id) ; ""]
	}]
	[h: setState("Bloodied", if(current > 0 && current <= (maximum / 2), 1, 0), id)]
}]
