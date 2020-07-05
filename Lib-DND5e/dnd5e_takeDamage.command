<!-- Read the damage and the properties and make sure they are numbers --> 
[h: abort(input("dmg|0|Enter Damage:|TEXT|WIDTH=4"))]
[h, if (!isNumber(dmg) || dmg < 0): dmg = 0; '']
[h: params = json.set("{}", "id", currentToken(), "current", getProperty("HP"), "temporary", getProperty("TempHP"), "damage", dmg)]
[h, macro("dnd5e_removeDamage@Lib:DnD5e"): params]