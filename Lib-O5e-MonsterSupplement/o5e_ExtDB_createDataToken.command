[h: o5e_ExtDB_Constants(getMacroName())]
[h, token (LIB_TOKEN_NAME): libTokenId = currentToken()]
[h, token (PROXY_TOKEN_NAME): tokenId = currentToken()]
[h: assert (tokenId != "", "This function must be executed from the same map as " + LIB_TOKEN_NAME)]

[h, if (tokenId == libTokenId), code: {
	[updates = json.set ("{}", "name", PROXY_TOKEN_NAME,
			"x", -2, "delta", 1)]
	[tokenId = copyToken (libTokenId, 1, "", updates)]
	[setName (PROXY_TOKEN_NAME, tokenId)]
	[macros = getMacros ("json")]
	[deleteIndexes = "[]"]
	[foreach (macroName, macros), code: {
		[macroIndexes = getMacroIndexes (macroName, "json", tokenId)]
		[if (!startsWith (macroName, DATA_MACRO)): 
			deleteIndexes = json.merge (deleteIndexes, macroIndexes)]
	}]
	[foreach (deleteIndex, deleteIndexes): removeMacro (deleteIndex, tokenId)]
}; {
	[log.debug (CATEGORY + PROXY_TOKEN_NAME + " already exists")]
}]