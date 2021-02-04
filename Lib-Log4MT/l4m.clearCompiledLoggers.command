[h: l4m.Constants()]
[h: libProperties = getMatchingLibProperties ("compiled\\..*", LIB_LOG4MT, "json")]
[h, foreach (libProperty, libProperties): setLibProperty (libProperty, "")]