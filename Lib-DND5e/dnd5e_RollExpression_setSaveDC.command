<!-- if the dc is greater than 0 add the saveable type. -->
[h: re = arg (0)]
[h: saveDc = arg (1)]
[h, if (!isNumber (saveDc)): return (0, re); ""]
[h, if (saveDc > 0), code: {
	[re = dnd5e_RollExpression_addType (re, dnd5e_Type_Saveable())]
	[re = json.set (re, "saveDC", saveDc)]	
}; {}]

[h: macro.return = re]
