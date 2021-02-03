[h: setLibProperty ("LIB_PROXY", "Lib:ProfilerProxy")]
[h: setLibProperty ("CALL_STACK", "profiler.callStack")]
[h: LIB_LOG4MT = json.get (getMacroContext(), "source")]
[h: setLibProperty ("LIB_LOG4MT", LIB_LOG4MT)]
[h: setLibProperty ("PROFILER_START_MACRO", "monitorStart@this")]
[h: setLibProperty ("PROFILER_STOP_MACRO", "monitorStop@this")]

[h: defineFunction ("log_Constants", "Constants@this", 0, 0)]

[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "log_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]