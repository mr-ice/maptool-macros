[h: slug = arg(0)]
[h, if (argCount() > 1): isLive = arg(1); isLive = 0]

[h: o5et_Constants (getMacroName())]
[h, if (!isLive): getSlug = "o5et_Data_" + slug; getSlug = "monsters/" + slug]
[h: log.debug (CATEGORY + "## getSlug = " + getSlug)]
[h: monsterToon = o5e_Open5e_get (getSlug)]
[h: tokenId = o5et_Util_createTestToken(slug)]
[h: o5e_Token_applyMonsterToon (monsterToon, tokenId)]
[h: macro.return = tokenId]