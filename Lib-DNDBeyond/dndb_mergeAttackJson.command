[h: basicToon = dndb_getBasicToon ()]
[h: toonAttackJson = json.get (basicToon, "attacks")]
[h, if (json.type (toonAttackJson) == "ARRAY"), code: {
	[errMsg = json.get (basicToon, "name") + " requires full initialization."]
	[log.error (errMsg)]
	[broadcast ("<font color='red'><b>" + errMsg + "</b></font>", "self")]
	[return (0)]
}; {""}]
[h: existingAttackJson = dndb_BasicToon_getAttackExpression ()]]
[h, if (json.type (existingAttackJson) != "OBJECT"): existingAttackJson = "{}"; ""]
<!-- Merge the attack JSON, which means overwrite common key names, add new ones, -->
<!-- but do not clear custom keys -->

<!-- Set toonAttackJson as last so it is authorative -->
[h: toonAttackJson = json.merge (existingAttackJson, toonAttackJson)]
[h: dndb_BasicToon_setAttackExpression (toonAttackJson)]