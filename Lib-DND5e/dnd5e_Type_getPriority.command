[h: type = arg (0)]
[h, if (argCount() > 1): rollerName = arg(1); rollerName = ""]

[h: rollers = json.get (type, "roller")]
[h: log.debug (getMacroName() + ": rollers = " + rollers)]
[h, if (rollerName == "" && json.length (rollers) > 0): rollers = json.append ("[]", json.get (rollers, 0)); ""]
[h: log.debug (getMacroName() + ": rollers = " + rollers)]
[h: priority = -1]
[h, foreach (roller, rollers), code: {
	[rollerMacro = listGet (roller, 0, ":")]
	[rollerPriority = listGet (roller, 1, ":")]
	[if (rollerMacro == rollerName || rollerName == ""): priority = rollerPriority; ""]
}]
[h: macro.return = priority]