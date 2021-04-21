[h: inputs = macro.args]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## inputs = " + inputs)]
[h, if (json.length (inputs) > 1), code: {
	[isSuccess = json.get (inputs, 0)]
	[savePos = json.get (inputs, 1)]
	[dsProperty = if (isSuccess, "DSPass", "DSFail")]
	[currentDS = getProperty (dsProperty)]
	[log.debug (CATEGORY + "## isSuccess = " + isSuccess + "; savePos = " + savePos +
		"; dsProperty = " + dsProperty + "; currentDS = " + currentDS)]
	[if (savePos <= currentDS):
		newDS = savePos - 1;
		newDS = savePos]
	[setProperty (dsProperty, newDS)]
	[ordinal = dnd5e_Util_ordinalPostfix (savePos)]
	[if (newDS > currentDS): 
		saveText = ordinal + " " + if (isSuccess, "success", "failure");
		saveText = "Resetting " + if (isSuccess, "successes", "failures") + ", now at " + newDS]
	[params = json.set("{}", "id", currentToken(), "current", getProperty ("HP"), "temporary", getProperty("TempHP"), 
		"maximum", getProperty("MaxHP"), "dsPass", getProperty ("dsPass"), "dsFail", getProperty ("dsFail"), 
		"exhaustion6", getState("Exhaustion 6"), "text-type", "deathSave", "text-value", saveText)]
	[dnd5e_applyHealth (params)]
}; {
	[dnd5e_deathSaves ()]
}]
[h: dnd5e_CharSheet_refreshPanel ()]