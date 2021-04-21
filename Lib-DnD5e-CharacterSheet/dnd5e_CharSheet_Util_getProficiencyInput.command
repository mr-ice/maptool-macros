[h: currentValue = arg (0)]
[h: varName = arg (1)]
[h, if (argCount() > 2): prompt = arg (2); prompt = varName]
[h, if (argCount() > 3): isList = arg (3); isList = 0]
[h, if (argCount() > 4): additionalOptions = arg (4); additionalOptions = ""]
[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: selectedProf = json.indexOf (ARRY_PROF_VALUES, currentValue)]
[h, if (selectedProf < 0): selectedProf = 0]
[h: log.debug (CATEGORY + "## currentValue = " + currentValue + 
		"; selectedProf = " + selectedProf)]
[h: type = if (isList, "LIST", "RADIO")]
[h: inputStr = varName + " | " + ARRY_PROF_NAMES + " | " + prompt + " | " +
		type + " | delimiter=json select=" + selectedProf + " " + additionalOptions]
[h: log.trace (CATEGORY + "## inputStr = " + inputStr)]
[h: macro.return = inputStr]