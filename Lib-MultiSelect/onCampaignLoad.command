<!-- Make my macros UDFs -->
[h: macros = getMacros()]
[h: log.info(getMacroName() + ": macros=" + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (indexOf (macroName, "ms_") > -1): defineFunction (macroName, macroName + "@this", 0)]
	[h, if (indexOf (macroName, "msH_") > -1): defineFunction (macroName, macroName + "@this", 1)]
}]

<!-- Save the token sizes -->
[h: areaSizes = json.set("{}", "Fine", 1, "Diminutive", 1, "Tiny", 1, "Small", 1, "Medium", 1, "Large", 2, "Huge", 3, "Gargantuan", 4, "Colossal", 5)]
[h: areaFields = json.fields(areaSizes)]
[h: areaOffsets = "{}"]
[h, for(size, 1, 6, 1, ""), code: {
    [h: squares = "[]"]
	[h, for(x, 0, size, 1, ""), code: {
		[h, for(y, 0, size, 1, ""): squares = json.append(squares, json.set("{}", "x", x, "y", y))]
	}]
	[h: log.debug(getMacroName() + " ## size=" + size + " ## squares=" + json.indent(squares))]
	[h, foreach(tokenSize, areaFields, ""), code: {
		[h, if (size == json.get(areaSizes, tokenSize)): areaOffsets = json.set(areaOffsets, tokenSize, squares)]
	}]
}]
[h: setLibProperty("areaOfffsets", areaOffsets, "Lib:MultiSelect")]

<!-- Show the frame -->
[h: ms_frame("[]")]