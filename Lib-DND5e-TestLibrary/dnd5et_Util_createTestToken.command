[h: testTokenName = arg(0)]
[h: dnd5et_Constants(getMacroName())]
[h, token (testTokenName): existingTokenId = currentToken()]
[h, if (existingTokenId != currentToken()): return (0, existingTokenId)]
[h: updates = json.set ("", "name", testTokenName, "x", -3, "delta", 1)]
[h: newTokenId = copyToken (LIB_TOKEN, 1, "", updates)]
[h: setPropertyType ("Basic", newTokenId)]
[h: macro.return = newTokenId]