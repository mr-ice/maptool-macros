[h: dnd5e_CharSheet_Constants (getMacroName())]
<!-- Proper parsing means the number of found tokens will equal the 
		number of parsed tokens and both values are positive -->
[h: classesArry = dnd5e_CharSheet_Util_getClassArray()]
[h: totalLevels = 0]
[h, foreach (classObj, classesArry), code: {
	[classLevel = json.get (classObj, "level")]
	[totalLevels = totalLevels + classLevel]
}]
[h: log.debug (CATEGORY + "## totalLevels = " + totalLevels)]
[h: profValue = floor ((totalLevels - 1) / 4) + 2]
[h: setProperty ("Proficiency", profValue)]
[h: macro.return = profValue]