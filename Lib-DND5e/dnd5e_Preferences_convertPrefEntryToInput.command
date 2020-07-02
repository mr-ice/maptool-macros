[h: prefEntry = arg (0)]
[h: prefObj = arg (1)]

[h: log.debug ("dnd5e_Preferences_convertPrefEntryToInput: prefEntry = " + prefEntry + "; prefObj = " + prefObj)]
[h: key = json.get (prefEntry, "key")]
[h: prefValue = json.get (prefObj, key)]
[h: inputValue = prefValue]
[h: entryValue = json.get (prefEntry, "value")]
[h: entryType = json.get (prefEntry, "type")]
[h: opts = json.get (prefEntry, "opts")]

[h, if (entryType == "LIST"), code: {
	[h: inputValue = entryValue]
	[h: index = listFind (entryValue, prefValue)]
	[h, if (index == -1): index = 0; ""]
	[h: opts = opts + " " + "select=" + index]
}; {""}]
<!-- heres the rub... if its a text or a check, just insert the value. If its a list, sigh... -->
[h: inputString = key + " | " + inputValue + " | " + json.get (prefEntry, "prompt") + " | " + 
				json.get (prefEntry, "type") + " | " + opts]
[h: macro.return = inputString]