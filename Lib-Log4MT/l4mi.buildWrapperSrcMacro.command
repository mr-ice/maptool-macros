[h: functionName = arg(0)]
[h: libToken = arg(1)]
[h: maxArgs = arg(2)]
[h: new = decode ("%0A")]
[h: tab = decode ("%09")]
[h: macroCommand = "[h: args = macro.args]" + new +
"[h: currentLevel = l4m.getCurrentMacroLogger()]" + new +
"[h: numArgs = json.length (args)]" + new +
"[h: useClassicMacro = 0]" + new +
"[r, switch (numArgs):" + new]
[h: paramSrc = ""]
[h: firstParam = 1]
[h, for (i, 0, maxArgs), code: {
	[macroCommand = macroCommand + tab + "case " + i + ": oldFunction (" + paramSrc + ");" + new]
	[if (!firstParam): paramSrc = paramSrc + "," + new]
	[firstParam = 0]
	[if (i != 0): paramSrc = paramSrc + tab + tab; ""]
	[paramSrc = paramSrc + "json.get (args, " + i + ")"]
}]
[h: macroCommand = macroCommand + tab + "default: useClassicMacro = 1;]" + new +
"[h, if (useClassicMacro), code: {" + new +
"[r, macro ('" + functionName + "@" + libToken + "'): args]" + new +
"}; {}]"]
[h: taco = encode ("[h: taco seasoning]" + new)]
[h: macro.return = encode (macroCommand)]