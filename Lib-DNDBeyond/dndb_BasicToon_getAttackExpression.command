[h: attackObj = getProperty ("attackExpressionJSON")]
[h, if (json.type (attackObj) != "OBJECT"), code: {
	[log.error ("dndb_BasicToon_getAttackExpression: invalid attack expression found; resetting")]
	[log.error ("id: " + currentToken()]
	[attackObj = "{}"]
}]
[h: decodedAttackObj = "{}"]
[h, foreach (field, json.fields (attackObj)), code: {
	[value = json.get (attackObj, field)]
	[decodedAttackObj = json.set (decodedAttackObj, decode (field), value)]
}]
[h: macro.return = decodedAttackObj]