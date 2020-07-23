[h: prefEntry = arg (0)]
[h: prefObj = arg (1)]
[h: arg_gmOnly = arg (2)]

[h: log.debug ("dnd5e_Preferences_convertPrefEntryToInput: prefEntry = " + prefEntry + "; prefObj = " + prefObj)]
[h: key = json.get (prefEntry, "key")]
[h: prefValue = json.get (prefObj, key)]
[h: entryValue = json.get (prefEntry, "value")]
[h, if (encode (prefValue) == ""): inputValue = entryValue ; inputValue = prefValue]
[h: entryType = json.get (prefEntry, "type")]
[h: opts = json.get (prefEntry, "opts")]
[h: gmOnly = json.get (prefEntry, "gmOnly")]

[h: log.info ("gmOnly: " + gmOnly + "; isGm = " + isGm() + "; currentToken = " + currentToken())]
<!-- If the entry is marked gmOnly, only the GM can set it -->
[h, if (gmOnly && !isGM()): return (0, ""); ""]
<!-- If the entry is marked gmOnly, there may not be a token selected; if the entry is not
     marked gmOnly, there must be a token selected -->
[h, if (gmOnly && currentToken() != "" || !gmOnly && currentToken() == ""): return (0, ""); ""]

[h: log.debug (getMacroName() + ": building input for " + prefEntry)]

[h, if (opts == "GM_ONLY"): opts = ""; ""]

[h, if (entryType == "LIST"), code: {
	[h: inputValue = entryValue]
	[h: index = listFind (entryValue, prefValue)]
	[h, if (index == -1): index = 0; ""]
	[h: opts = opts + " " + "select=" + index]
}; {""}]
<!-- heres the rub... if its a text or a check, just insert the value. If its a list, sigh... -->
[h: inputString = key + " | " + inputValue + " | " + json.get (prefEntry, "prompt") + " | " + 
				json.get (prefEntry, "type") + " | " + opts]
[h: log.debug (getMacroName() + ": inputString = " + inputString)]
[h: macro.return = inputString]