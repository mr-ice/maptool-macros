[h: newLoggers = arg(0)]
<!-- Ensure root is taken care of -->
[h: existingLoggers = l4m.getLoggers()]
[h: rootKey = l4m.getLoggerKey ()]
[h, if (!json.contains (newLoggers, rootKey)):
	newLoggers = json.set (newLoggers, rootKey, "WARN"); ""]
<!-- Clear the existing -->
[h, foreach (libProperty, json.fields (existingLoggers)):
	setLibProperty (libProperty, "")]
<!-- Set the new hotness -->
[h, foreach (libProperty, json.fields (newLoggers)):
	setLibProperty (libProperty, json.get (newLoggers, libProperty))]
