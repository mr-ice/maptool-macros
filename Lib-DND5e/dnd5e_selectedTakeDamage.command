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
	[h: params = json.set("{}", "id", id, "current", getProperty("HP", id), "temporary", getProperty("TempHP", id), "damage", damage)]
	[h, macro("dnd5e_removeDamage@Lib:DnD5e"): params]
}]