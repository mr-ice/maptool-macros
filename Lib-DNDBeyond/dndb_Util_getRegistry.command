[h: DATA_MACRO = arg(0)]
[h, token ("lib:DnDBeyond"): tokenId = currentToken()]
[h: macroIndexes = getMacroIndexes (DATA_MACRO, "json", tokenId)]
<!-- Use the first one, if found -->
[h: registry = "{}"]
[h, if (json.length (macroIndexes) == 0), code: {
	[log.warn (getMacroName() + ": No Data found for " + DATA_MACRO)]
	[return (0, registry)]
}; {}
]
[h, if (json.length (macroIndexes) > 1): log.warn (getMacroName() + ": More than one Data Macro found for " + DATA_MACRO)]
[h: encoded = getMacroCommand (json.get (macroIndexes, 0), tokenId)]
[h, if (encoded != ""): registry = decode (encoded)]
[h: macro.return = registry]