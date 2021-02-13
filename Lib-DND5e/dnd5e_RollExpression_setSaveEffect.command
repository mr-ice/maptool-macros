[h: re = arg(0)]
[h: effect = arg (1)]
<!-- if the save effect is non-null, add the saveable type -->
[h, if (encode (effect) != ""), code: {
	[re = dnd5e_RollExpression_addType (re, dnd5e_Type_Saveable())]
	[re = json.set (re, "saveEffectDescription", effect)]
}]
[h: macro.return = re]