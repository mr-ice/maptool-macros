[h: dnd5e_CharSheet_Constants (getMacroName())]
<!-- Proper parsing means the number of found tokens will equal the 
		number of parsed tokens and both values are positive -->
[h: parsed = 0]
[h: tokens = 0]
[h: totalLevel = 0]
[h: classesProperty = getProperty ("classes")]
[h: log.debug (CATEGORY + "## classesProperty = " + classesProperty)]
[h: classLevelPattern = "(\\w*)\\s+(\\d+)"]
[h, foreach (classesValue, classesProperty, "", "/"), code: {
	[log.debug (CATEGORY + "## classesValue = " + classesValue)]
	[tokens = tokens + 1]
	[classesValue = trim (classesValue)]
	[findId = strfind (classesValue, classLevelPattern)]
	[if (getFindCount (findId) > 0), code: {

		[classLevel = getGroup (findId, 1, 2)]
		[totalLevel = totalLevel + classLevel]
		<!-- Only count it as parsed if classLevel was positive -->
		[if (classLevel > 0): parsed = parsed + 1]
		[log.debug (CATEGORY + "## classLevel = " + classLevel + 
				"; totalLevel = " + totalLevel)]
	}]
}]
[h: valid = 0]
<!-- dont change the Proficiency value if we didnt fully parse -->
[h, if (parsed == tokens && parsed > 0 && totalLevel > 0), code: {
	[valid = 1]
	[setProperty ("Proficiency", floor ((totalLevel - 1) / 4) + 2)]
	[log.debug (CATEGORY + "## Valid!")]
}; {
	[log.info (CATEGORY + "## Invalid: classes = " + classesProperty)]
}]
[h: macro.return = valid]