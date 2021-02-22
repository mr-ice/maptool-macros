<!-- Populate our constants -->
[h: setLibProperty ("LIB_PROXY", "Lib:ProfilerProxy")]
[h: setLibProperty ("CALL_STACK", "profiler.callStack")]
[h: LIB_LOG4MT = json.get (getMacroContext(), "source")]
[h: setLibProperty ("LIB_LOG4MT", LIB_LOG4MT)]
[h: setLibProperty ("PROFILER_START_MACRO", "monitorStart@" + LIB_LOG4MT)]
[h: setLibProperty ("PROFILER_STOP_MACRO", "monitorStop@" + LIB_LOG4MT)]
[h: setLibProperty ("ROOT_LOGGER_CATEGORY", "root")]
[h: setLibProperty ("LOGGER_LEVEL_MAP", json.set ("",
				"TRACE", 5,
				"DEBUG", 4,
				"INFO", 3,
				"WARN", 2,
				"ERROR", 1))]
<!-- This array should define each level in the corresponding array element. Ex. if
		"INFO" is mapped to value '3', then element '3' must be "INFO" -->
[h: setLibProperty ("LOGGER_LEVEL_ARRAY", json.append ("[]",
		"UNDEFINED", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"))]
<!-- Define prefix with trailing preiod -->
[h: setLibProperty ("LOGGER_PREFIX", "logger.")]
[h: setLibProperty ("GENERATED_LOG_EVENT", "INFO")]
<!-- Define prefix with trailing preiod -->
[h: setLibProperty ("COMPILED_LOGGER_PREFIX", "compiled.logger.")]

<!-- Entry/Exit logging will be generated at this level. To filter what
     categories log entry/exit events, configure .entryExit loggers
     accordingly -->
[h: setLibProperty ("ENTRY_EXIT_LOG_LEVEL", "INFO")]


<!-- Special UDFs; I should really get that UDF registry working -->
[h: defineFunction ("l4m.Constants", "Constants@this", 0, 0)]

<!-- Regular UDF chumps -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (indexOf (macroName, "l4m.") > -1 || indexOf (macroName, "l4mi.") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]

<!-- All our good stuff happens on log.info, so enable INFO -->
[h: log.setLevel ("macro-logger", "INFO")]
