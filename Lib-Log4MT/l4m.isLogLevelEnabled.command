[h: logLevel = upper (arg(0))]
[h, if (argCount() > 1): category = arg(1); category = ""]
[h, if (argCount() > 2): suffix = arg(2); suffix = ""]
[h: l4m.Constants()]
<!-- Dont let the native category be part of this calculation -->
[h, if (category == NATIVE_CATEGORY): category = ""]
[h: logLevelVal = json.get (LOGGER_LEVEL_MAP, logLevel)]

<!-- Assuming log configuration doesnt change much, compile the levels we 
     caculate so we save a ton of time in not calculating this for every log- call -->
[h: compiledLoggerVal = getLibProperty (COMPILED_LOGGER_PREFIX + category + suffix + ".value")]
[h, if (compiledLoggerVal != ""), code: {
	[if (compiledLoggerVal >= logLevelVal): enabled = 1; enabled = 0]
	[return (0, enabled)]
}]

[h: effectiveLevel = l4m.getEffectiveLogLevel (category, 1, suffix)]
[h: effectiveVal = json.get (LOGGER_LEVEL_MAP, effectiveLevel)]

[h: setLibProperty (COMPILED_LOGGER_PREFIX + category + suffix + ".value", effectiveVal)]
[h, if (logLevelVal == ""): logLevelVal = 0; ""]
[h, if (effectiveVal >= logLevelVal): enabled = 1; enabled = 0]
[h: macro.return = enabled]
