[h: l4m.Constants()]
[h: compiledPrefix = replace (COMPILED_PREFIX, "\\.", "\\\\.")]
[h: libProperties = getMatchingLibProperties (compiledPrefix + ".*", LIB_LOG4MT, "json")]
[h, foreach (libProperty, libProperties): setLibProperty (libProperty, "")]