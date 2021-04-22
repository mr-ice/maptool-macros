[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: classArry = dnd5e_CharSheet_Util_getClassArray ()]
[h: newClassName = "**New Class**"]
[h: classArry = json.append (classArry, json.set ("", "class", newClassName, "level", "1", "hitDie", "d8"))]
[h: log.debug (CATEGORY + "## classArry = " + classArry)]
[h: inputStr = ""]
[h: tabVars = "[]"]
[h, foreach (classObj, classArry), code: {
	[className = json.get (classObj, "class")]
	[classLevel = json.get (classObj, "level")]
	[hitDie = json.get (classObj, "hitDie")]
	[log.debug (CATEGORY + "## classObj = " + classObj + "; className = " + className +
		"; classLevel = " + classLevel + "; hitDie = " + hitDie)]
	[if (className != "" && dnd5e_CharSheet_formatNumber (classLevel) > 0), code: {
		[tabVar = dnd5e_CharSheet_Util_getTabSafeVar (className)]
		[tabVars = json.append (tabVars, tabVar)]
		[tabStr = tabVar + " | " + className + " | | TAB"]
		[classNameStr = "className | " + className + " | Class Name | TEXT"]
		[classLevelStr = "classLevel | " + classLevel + " | Class Level (0 to delete) | TEXT"]
		[hitDieStr = "hitDie | " + hitDie + " | Hit Die (ex. 'd8') | TEXT"]
		[inputStr = listAppend (inputStr, tabStr, "##")]
		[inputStr = listAppend (inputStr, classNameStr, "##")]
		[inputStr = listAppend (inputStr, classLevelStr, "##")]
		[inputStr = listAppend (inputStr, hitDieStr, "##")]
	}]
}]
[h: log.debug (CATEGORY + "## inputStr = " + inputStr)]
[h: newClassesArry = "[]"]
[h: isValid = 0]
[h, while (!isValid), code: {
	[abort( input( inputStr))]
	[isValid = 1]
	[errStr = "<html>"]
	[foreach (tabVar, tabVars), code: {
		[tabData = eval (tabVar)]
		[log.debug (CATEGORY + "## tabData = " + tabData)]
		[className = getStrProp (tabData, "className", "", "##")]
		[classLevel = getStrProp (tabData, "classLevel", "", "##")]
		[hitDie = getStrProp (tabData, "hitDie", 0, "##")]
		[log.debug (CATEGORY + "## className = " + className + "; classLevel = " + 
			classLevel + "; hitDie = " + hitDie)]
		[if (hitDie == 0): isValid = 0]
		[if (hitDie == 0): errStr = listAppend (errStr, className + " has an invalid hitdie: " + hitDie, "<br>")]
		[if (className != newClassName && classLevel > 0): 
			newClassesArry = json.append (newClassesArry,
				json.set ("", "class", className, "level", classLevel, "hitDie", hitDie))]
	}]
	[if (!isValid):
		input ("junk | " + errStr + " | | LABEL | span=true")]
}]
[h: log.debug (CATEGORY + "## newClassesArry = " + newClassesArry)]
[h: dnd5e_CharSheet_Util_setClassArry (newClassesArry)]

[h: dnd5e_CharSheet_refreshPanel ()]