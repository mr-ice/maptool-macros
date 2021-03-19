[h: newLoggers = l4m.sanitizeJson (arg(0))]
[h: l4m.Constants()]
<!-- Weve changed logging configuration. So clear the compiled loggers -->
[h: l4m.clearCompiledLoggers()]
<!-- Ensure root is taken care of -->
[h: existingLoggers = l4m.getLoggers()]
[h: rootKey = l4m.getLoggerKey ()]
[h, if (!json.contains (newLoggers, rootKey)):
	newLoggers = json.set (newLoggers, rootKey, "WARN"); ""]
<!-- Clear the existing -->
[h, foreach (libProperty, json.fields (existingLoggers)):
	setLibProperty (libProperty, "")]
<!-- Set the new hotness -->
[h: invalid = "[]"]
[h, foreach (libProperty, json.fields (newLoggers)), code: {
	[propLength = listCount (libProperty, ".") ]
	[logger = listGet (libProperty, 0, ".")]
	[loggerDot = logger + "."]
	[suffix = listGet (libProperty, propLength - 1, ".")]
	[dotSuffix = "." + suffix]
	[category = replace (libProperty, logger + "\\.", "")]
	[category = replace (category, "\\." + suffix, "")]
	[if (propLength != 3 || 
		loggerDot != LOGGER_PREFIX || 
		!json.contains (LOGGER_VALID_SUFFIXES, dotSuffix)), code: {
			[invalid = json.append (invalid, "<b>" + category + "</b> :: " + libProperty +"<br>")]
	}; {
		[setLibProperty (libProperty, json.get (newLoggers, libProperty))]
	}]
}]

[r, if (json.length (invalid) > 0), code: {
	[invalidMsg = ""]
	[foreach (invalidItem, invalid): invalidMsg = invalidMsg + invalidItem]

	[input ("junk | <html>Excluding invalid loggers: <br><br>" + invalidMsg + "<br>Categories (<b>bolded items</b>) may not include Periods or be blank.<br>Loggers should be prefixed with 'logger' and end with a valid suffix ('.level', '.break', '.entryexit', '.lineparser')</html>| | label | span=true")]
}]
