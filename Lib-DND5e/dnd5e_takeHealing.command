<!-- Read the health info and heal the damage -->
[h: abort(input("value|0|Enter Healing:|TEXT|WIDTH=4"))]
[h: params = json.set("{}", "id", currentToken(), "current", getProperty("HP"), "maximum", getProperty("MaxHP"), "healing", value)]
[h, macro("dnd5e_healDamage@Lib:DnD5e"): params]