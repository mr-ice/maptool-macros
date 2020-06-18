[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode(basicToon) == ""), code: {
	[h: errMsg = "Token needs to sync with DnDBeyond first"]
	[h: abort( input(" junk | | " + errMsg + " | LABEL | TEXT=false"))]
	[r: return (0, errMsg)]
}; {}]
[h: toonAttackJson = json.get (basicToon, "attacks")]
[h: existingAttackJson = getProperty ("attackJSON")]
<!-- Merge the attack JSON, which means overwrite common key names, add new ones, -->
<!-- but do not clear custom keys -->

<!-- We gotta roll our own merge -->
<!-- Iterate the existing array. If an attack is found the  new array of the same -->
<!-- name, ignore it. Otherwise add the attack to the array. Return the results -->
[h: newAttackJSON = toonAttackJson]

[h, foreach (existingAttack, existingAttackJson), code: {
	[h: newAttack = ""]
	[h: append = 1]
	[h, foreach (toonAttack, toonAttackJson), code: {
		[h: toonAttackName = json.get (toonAttack, "name")]
		[h: existingAttackJsonName = json.get (existingAttack, "name")]
		[h, if (toonAttackName == existingAttackJsonName): append = 0]
	}]
	[h, if (append > 0): newAttackJSON = json.append (newAttackJSON, existingAttack); ""]
}]

[h: setProperty ("attackJSON", newAttackJSON)]