[h: TOKEN_PREFIX = "token_"]
[h: RELEASE_NOTES_JSON = "lib.releaseNotesObj"]
[h: RL_NONE = "---- None ----"]
[h: tokenIds = getSelected()]
[h: log.debug (getMacroName() + ": tokenIds = " + tokenIds)]
[h: versionObj = "{}"]
[h: assert (!json.isEmpty (tokenIds), "No tokens selected!")]
[h: inputMsg = " junk | Input new version values for the following Library Tokens |   | LABEL | SPAN=TRUE"]
[h, foreach(tokenId, tokenIds, ""), code: {
	[log.debug (getMacroName() + ": tokenId = " + tokenId)]
	[currentVersionObj = json.get (versionObj, tokenId)]
	[if (!json.isEmpty (currentVersionObj)), code: {
		[msg = "Alert! Modifying existing version object for token " + tokenId]
		[broadcast (msg, "self")]
		[log.error (msg)]
	}; {}]
	[token (tokenId), code: {
		[currentLibVersion = getLibProperty ("libversion", token.name)]
		[currentVersionObj = json.set (currentVersionObj, "name", token.name,
						"tokenId", tokenId,
						"current.libVersion", currentLibVersion)]
	}]
	[versionObj = json.set (versionObj, tokenId, currentVersionObj)]
	[tokenName = json.get (currentVersionObj, "name")]
	[currentVersion = json.get (currentVersionObj, "current.libVersion")]
	[inputMsg = inputMsg + "## " + TOKEN_PREFIX + tokenId + " | New Version=" +
			json.get (currentVersionObj, "current.libVersion") + "; Release Notes=" + RL_NONE +
			" | " + tokenName + " (" + currentVersion + ") | PROPS | TYPE=JSON"] 
}]
[h: log.debug (getMacroName() + ": versionObj = " + json.indent (versionObj))]
[h: log.debug (getMacroName() + ": inputMsg = " + inputMsg)]

[h: abort (input (inputMsg))]

[h, foreach (tokenId, tokenIds, ""), code: {
	[h: currentVersionObj = json.get (versionObj, tokenId)]
	[h: log.debug (getMacroName() + ": currentVersionObj=" + currentVersionObj)]
	[h: libTokenName = json.get (currentVersionObj, "name")]
	[h: varName = TOKEN_PREFIX + tokenId]
	[h: evalMacro ("[h: newVersionObj = " + varName + "]")]
	[h: newVersion = json.get (newVersionObj, "New Version")]
	[h: curentVersion = json.get (currentVersionObj, "current.libVersion")]
	[h, if (newVersion != currentVersion), code: {
		[h: releaseNotes = encode (json.get (newVersionObj, "Notes"))]
		[h, if (releaseNotes == encode (RL_NONE)): releaseNotes = ""; ""]
		[h: releaseNotesObj = getLibProperty (RELEASE_NOTES_JSON, libTokenName)]
		[h: releaseNotesObj = json.set (releaseNotesObj, newVersion, releaseNotes)]
		[h: setLibProperty ("libversion", newVersion, libTokenName)]
		[h: setLibProperty (RELEASE_NOTES_JSON, json.indent (releaseNotesObj), libTokenName)]
	}; {}]
}]