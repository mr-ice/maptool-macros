[h: registry = arg (0)]
[h, if (argCount() > 1): targetMacro = arg (1); targetMacro = ""]
[h, if (argCount() > 2): suppressBackup = arg (2); suppressBackup = 0]
[h: o5e_ExtDB_Constants(getMacroName())]
[h, if (targetMacro == ""): targetMacro = DATA_MACRO]
[h, token (PROXY_TOKEN_NAME): tokenId = currentToken()]
[h: assert (tokenId != "", "<font color='red'><b>Cannot edit the database from a map without " + PROXY_TOKEN_NAME +"</b></font>")]
[h, if (!suppressBackup), code: {
	[h: lastBackupIdx = getLibProperty (PROP_BACKUP_IDX)]
	[h, if (!isNumber (lastBackupIdx)): lastBackupIdx = 0]
	[h: lastBackupIdx = lastBackupIdx + 1]
	[h, if (lastBackupIdx > MAX_BACKUPS): lastBackupIdx = 1]
	[h: backupLabel = strformat (targetMacro + LABEL_TOKEN_BACKUP, lastBackupIdx)]
	[h: backupIndexes = getMacroIndexes (backupLabel, "json", tokenId)]
	[h, if (json.length (backupIndexes) > 0), code: {
		[o5e_ExtDB_setDB (o5e_ExtDB_getDB(), backupLabel, 1)]
	}; {
		[broadcast ("WARNING: Could not find backup macro " + backupLabel, "gm")]
	}]
	[h: setLibProperty (PROP_BACKUP_IDX, lastBackupIdx)]
};{}]

<!-- Could be a big data line, so break up the text -->

[h: strShift = 80]
[h: encodedRegistry = encode (registry)]
[h: lastIndex = length (encodedRegistry)]
[h: formattedReg = decode ("%22")]
[h: formattedReg = ""]

[h, for (strIndex, 0, lastIndex, strShift), code: {
	[endIndex = strIndex + strShift]
	[if (endIndex > lastIndex): endIndex = lastIndex]
	[formattedReg = formattedReg + substring (encodedRegistry, strIndex, endIndex) + decode ("%22+%2B+%0A+%22")]
}]
[h: formattedReg = decode ("%22") + formattedReg + decode ("%22")]
[h: command = "[h: macro.return = " + formattedReg + "]"]
[h: macroIndex = json.get (getMacroIndexes (targetMacro, "json", tokenId), 0)]
[h: setMacroCommand (macroIndex, command, tokenId)]