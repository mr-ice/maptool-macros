<!-- We have a habit of leaving this at times -->
[h: log.setLevel ("net.rptools.maptool.client.MapToolLineParser", "WARN")]
<!-- Populate our complicated constants -->
[h: LIB_LOG4MT = json.get (getMacroContext(), "source")]
[h: setLibProperty ("LIB_LOG4MT", LIB_LOG4MT)]
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


<!-- Special UDFs; I should really get that UDF registry working -->
[h: defineFunction ("l4m.Constants", "Constants@this", 0, 0)]
[h: defineFunction ("l4m.break", "break@this", 0, 0)]

<!-- Regular UDF chumps -->
[h: macros = getMacros()]
[h, foreach (macroName, macros), code: {
	[h, if (indexOf (macroName, "l4m.") > -1 || indexOf (macroName, "l4mi.") > -1), code: {
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]

<!-- All our good stuff happens on log.info, so enable INFO -->
[h: log.setLevel ("macro-logger", "INFO")]

<!-- and the fancy stuff -->
[h: defineFunction ("log.trace", "l4m.trace@this")]
[h: defineFunction ("log.debug", "l4m.debug@this")]
[h: defineFunction ("log.info", "l4m.info@this")]
[h: defineFunction ("log.warn", "l4m.warn@this")]
[h: defineFunction ("log.error", "l4m.error@this")]
[h: defineFunction ("abort", "l4m.abort@this")]