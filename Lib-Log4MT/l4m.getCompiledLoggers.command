[h: l4m.Constants()]
[h: escapedPrefix = replace (COMPILED_LOGGER_PREFIX, "\\.", "\\\\.")]
[h: libProperties = getMatchingLibProperties (escapedPrefix + ".*", LIB_LOG4MT, "json")]
[h: propertyObj = "{}"]
[h, foreach (libProperty, libProperties): 
		propertyObj = json.set (propertyObj, libProperty, getLibProperty (libProperty))]
[dialog("Current Compiled Loggers", "title=Call Stack; input=1; width=580; height=550; closebutton=0"): {
	<html><body>

			<pre>[r: json.indent (propertyObj)]</pre>

		</body>
	</html>
}]
