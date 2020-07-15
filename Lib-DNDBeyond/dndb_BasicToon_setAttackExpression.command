[h: attackObj = arg (0)]
[h, if (json.type (attackObj) != "OBJECT"), code: {
	[log.error ("dndb_BasicToon_setAttackExpression: invalid attack expression provided; aborting")]
	[log.error ("id: " + currentToken()]
	[macro.return = attackObj]
	[return (0)]
}]
[h: encodedAttackObj = "{}"]
[h, foreach (field, json.fields (attackObj)), code: {
	[value = json.get (attackObj, field)]
	[encodedAttackObj = json.set (encodedAttackObj, encode (field), value)]
}]
[h: setProperty ("attackExpressionJSON", encodedAttackObj)]
[h: macro.return = encodedAttackObj]