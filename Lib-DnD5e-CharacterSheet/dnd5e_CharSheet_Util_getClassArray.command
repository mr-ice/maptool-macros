[h: dnd5e_CharSheet_Constants (getMacroName())]
<!-- first, just see if we have an object. If so, its authorative -->
[h: classArry = getProperty (PROP_CLASS_OBJ)]
[h, if (encode (classArry) == ""), code: {
	[classesValue = getProperty ("classes")]
	[log.debug (CATEGORY + "## No classObj, using property and found: " + 
		classesValue)]
	[classLevelPattern = "(\\w*)\\s+(\\d+)"]
	[foreach (classValue, classesValue, "", "/"), code: {
		[log.debug (CATEGORY + "## classValue = " + classValue)]
		[classValue = trim (classValue)]
		[findId = strfind (classValue, classLevelPattern)]
		[findCount = getFindCount (findId)]
		[classLevel = if (findCount, getGroup (findId, 1, 2), 0)]
		[className = if (findCount, getGroup (findId, 1, 1), "")]
		[if (classLevel > 0): classArry = json.append (classArry, 
			json.set ("", "class", className, "level", classLevel))]
		[log.debug (CATEGORY + "## parsed " + className + " " + classLevel)]
	}]
}]
[h: log.debug (CATEGORY + "## classArry = " + classArry)]
[h: macro.return = classArry]