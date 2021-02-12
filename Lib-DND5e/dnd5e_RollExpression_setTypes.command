[h: rollExpression = arg (0)]
[h: inputTypes = arg (1)]
[h: rollExpression = json.remove (rollExpression, "types")]
<!-- addType has some extra work to do, so no just setting the field -->
<!-- If an Object is passed, assum its <String, Object>, in which case just iterate over the values -->
[h: supportedType = 0]
[h, if (json.type (inputTypes) == "OBJECT"), code: {
	[foreach (field, json.fields (inputTypes)), code: {
		[typeVal = json.get (inputTypes, field)]
		[rollExpression = dnd5e_RollExpression_addType (rollExpression, typeVal)]
	}]
	[supportedType = 1]
}; {}]
[h, if (json.type (inputTypes) == "ARRAY"), code: {
	[foreach (type, inputTypes): rollExpression = dnd5e_RollExpression_addType (rollExpression, type)]
	[supportedType = 1]
}; {}]
[h, if (!supportedType), code: {
	<!-- If its an empty string, ignore -->
	[if (encode (inputTypes) != ""): 
		log.error (getMacroName() + ": an invalid inputTypes was provided : " + inputTypes);
		""]
}; {}]
[h: macro.return = rollExpression]