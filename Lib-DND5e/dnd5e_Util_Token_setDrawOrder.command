[h, if (argCount() == 0): tokens = "[]"; tokens = arg(0)]
[h: dnd5e_Constants(getMacroName())]
[h: log.debug (CATEGORY + "##tokens = " + tokens)]
[h, if (json.type (tokens) != "ARRAY"): tokens = json.append ("[]", tokens)]

[h: PROF_SELECT_ALL_TOKENS = "dnd5e.setDrawOrder.noPromptSelectAll"]

[h, if (json.length (tokens) == 0), code: {
	<!-- do everything in the damn map -->
	[tokens = getTokens("json")]
	[assert (json.length(tokens) != 0, "No tokens to redraw")]
	[doNotPrompt = dnd5e_Preferences_getPreference (PROF_SELECT_ALL_TOKENS)]
	[log.debug (CATEGORY + "## map tokens = " + tokens + "; doNotPrompt = " + 0)]
	[if (!doNotPrompt), code: {
		[abort (input ("junk | Warning: Re-drawing " + json.length (tokens) + " tokens| | Label | span=true","doNotPrompt | 0 | Don't ask again | CHECK"))]
	}]
	[dnd5e_Preferences_setPreference (PROF_SELECT_ALL_TOKENS, doNotPrompt, 1)]
}]
[h: incr = 500]
[h: index = 0]
[h: sizeArry = json.append ("", "Colossal", "Gargantuan", "Huge", "Large",
		"Medium", "Small", "Tiny", "Diminutive", "Fine")]
[h: drawNPCOverPC = dnd5e_Preferences_getPreference ("drawNpcOverPc")]
[h: sizeMap = "{}"]
[h, foreach (sizeEl, sizeArry, "json"), code: {
	[sizeMap = json.set (sizeMap, sizeEl, index)]
	[index = index + incr]
}]
[h: log.debug (CATEGORY + "##sizeMap = " + sizeMap + "; sizeArry = " + sizeArry)]
[h: counter = 1]
[h, foreach (selectedToken, tokens), code: {
	[log.debug (CATEGORY + "##token: " + selectedToken)]
	[tokenSize = getSize(selectedToken)]
	[baseDraw = json.get (sizeMap, tokenSize)]
	[log.debug (CATEGORY + "## name = " + getName(selectedToken) + "; tokenSize = " + tokenSize + "; baseDraw = " + baseDraw)]
	[if (isNPC(selectedToken)), code: {
		[if (drawNPCOverPC): baseDraw = baseDraw + incr / 2]
	}; {
		[if (!drawNPCOverPC): baseDraw = baseDraw + incr / 2]
	}]
	[baseDraw = baseDraw + counter]
	[log.debug (CATEGORY + "## Final draw order: " + baseDraw)]
	[setTokenDrawOrder (baseDraw, selectedToken)]
	[setProperty (PROP_DRAW_ORDER, baseDraw, selectedToken)]
	[counter = counter + 1]
}]