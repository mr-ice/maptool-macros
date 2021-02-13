[h: type = arg(0)]
[h: rollers = "[]"]
[h: rollerVals = json.get (type, "roller")]
[h, if (encode (rollerVals) == ""): rollerVals = "[]"; ""]
[h, foreach (rollerVal, rollerVals), code: {
	[rollerMacro = listGet (rollerVal, 0, ":")]
	[rollers = json.append (rollers, rollerMacro)]
}]
[h: macro.return = rollers]