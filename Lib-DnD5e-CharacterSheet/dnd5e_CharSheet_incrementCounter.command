[h: counterField = arg (0)]
[h: increment = arg (1)]
[h, if (argCount() > 2): propertyName = arg(2); propertyName = ""]
[H, if (argCount() > 3): noDelete = arg(3); noDelete = 0]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h, if (propertyName == ""): propertyName = PROP_COUNTERS]
[h: counterObj = getProperty (propertyName)]
[h, if (json.type (counterObj) != "OBJECT"): counterObj = "{}"]
[h: counterStrProp = json.get (counterObj, counterField)]
[h: log.debug (CATEGORY + "## counterField = " + counterField + "; counterStrProp = " + counterStrProp)]
[h, if (counterStrProp == ""), code: {
	[log.warn (CATEGORY + "## No strProp found for " + counterField + " in: " + counterObj)]
	[return (0, "")]
}]

[h: currentCount = getStrProp (counterStrProp, "current", 0, "##")]
[h: newCurrentCount = currentCount + increment]
[h: counterStrProp = setStrProp (counterStrProp, "current", newCurrentCount, "##")]
<!-- Delete when it hits zero -->
[h, if (newCurrentCount == 0 && !noDelete):
	counterObj = json.remove (counterObj, counterField);
	counterObj = json.set (counterObj, counterField, counterStrProp)]
[h: setProperty (propertyName, counterObj)]
[h: dnd5e_CharSheet_refreshPanel ()]