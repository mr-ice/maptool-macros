[h: functionName = arg(0)]
[h: libToken = arg(1)]
[h: maxArgs = arg(2)]
[h: l4m.Constants()]

[h: macroCommand = 
"[h: args = macro.args]" + NEW_LINE +
"[h: currentLevel = l4m.getCurrentMacroLogger()]" + NEW_LINE +
"[h, macro ('" + PROFILER_START_MACRO + "'): " + 
	"json.set ('', 'name', getMacroName(), 'args', macro.args, 'token', '"+ libToken + "')]" + NEW_LINE +
"[h: numArgs = json.length (args)]" + NEW_LINE +
"[h: useClassicMacro = 0]" + NEW_LINE +
"[r, switch (numArgs):" + NEW_LINE]
[h: paramSrc = ""]
[h: firstParam = 1]
[h, for (i, 0, maxArgs), code: {
	[macroCommand = macroCommand + tab + "case " + i + ": oldFunction (" + paramSrc + ");" + NEW_LINE]
	[if (!firstParam): paramSrc = paramSrc + "," + NEW_LINE]
	[firstParam = 0]
	[if (i != 0): paramSrc = paramSrc + TAB + TAB; ""]
	[paramSrc = paramSrc + "json.get (args, " + i + ")"]
}]
[h: macroCommand = macroCommand + TAB + "default: useClassicMacro = 1;]" + NEW_LINE +
"[r, if (useClassicMacro), code: {" + NEW_LINE +
TAB + "[r, macro ('" + functionName + "@" + libToken + "'): args]" + NEW_LINE +
"}; {}]" + NEW_LINE +
"[h: data = macro.return]" + NEW_LINE +
"[h, macro ('" + PROFILER_STOP_MACRO + "'): json.set ('', 'name', getMacroName(), 'token', '" + 
		libToken + "', 'return', data, 'macro-logger', currentLevel)]" + NEW_LINE +
"[h: macro.return = data]"]

[h: macro.return = encode (macroCommand)]