[h: functionName = arg(0)]
[h: libToken = arg(1)]
[h: maxArgs = arg(2)]
[h: l4m.Constants()]

[h: macroCommand = 
"[h: currentLineParserLevel = l4m.getCurrentLoggerLevel ('net.rptools.maptool.client.MapToolLineParser'))]" + NEW_LINE +
"[h: log.setLevel ('net.rptools.maptool.client.MapToolLineParser', 'WARN')]" + NEW_LINE +
"[h: args = macro.args]" + NEW_LINE +
"[h: l4m.Constants()]" + NEW_LINE +

"[h: WRAPPER_CATEGORY = getMacroName()]" + NEW_LINE +
"[h: previousRootLevel = getLibProperty ( LOGGER_PREFIX + ROOT_LOGGER_CATEGORY + '.level', LIB_LOG4MT)]" + NEW_LINE +
"[h, macro ('" + PROFILER_START_MACRO + "'): " + 
	"json.set ('', 'name', getMacroName(), 'args', args, 'token', '"+ libToken + "')]" + NEW_LINE +
"[h: numArgs = json.length (args)]" + NEW_LINE +
"[h: useClassicMacro = 0]" + NEW_LINE +
"[h: macro.catchAbort = 1]" + NEW_LINE +
"[h, if (l4m.isDebugEnabled (WRAPPER_CATEGORY, '.lineParser')): log.setLevel (LINE_PARSER, 'DEBUG')]" + NEW_LINE+
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
"[h: log.setLevel (LINE_PARSER, 'WARN')]" + NEW_LINE +
"[h: macro.catchAbort = 0]" + NEW_LINE +
"[h, macro ('" + PROFILER_STOP_MACRO + "'): json.set ('', 'name', getMacroName(), 'token', '" + 
		libToken + "', 'return', data, 'previousRootLevel', previousRootLevel)]" + NEW_LINE +
"[h: log.setLevel (LINE_PARSER, currentLineParserLevel)]" + NEW_LINE +
"[h: macro.return = data]"]

[h: macro.return = encode (macroCommand)]