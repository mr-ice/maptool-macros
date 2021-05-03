[h, if (json.length (macro.args) > 0): libToken = arg(0); libToken = "Lib:DnD5e"]
[h: dnd5et_Constants(getMacroName())]
[h, token (libToken): tokenId = currentToken()]
[h: log.debug (CATEGORY + "## Testing " + libToken + "; " + tokenId)]
[h: macroNames = getMacros("json", tokenId)]
[h: log.trace (CATEGORY + "## macroNames = " + macroNames)]
[h: VAR_DECLARE_PATTERN = ".*[:;\\[]\\s*([A-Za-z0-9._]+)\\s*=[\\s\\w]"]
[h: allProps = getAllPropertyNames("", "json")]
[h: log.trace (CATEGORY + "## allProps = " + allProps)]
[h: reportResult = "{}"]
[h, foreach (macroName, macroNames), code: {
	[log.debug (CATEGORY + "## testing " + macroName)]
	[macroIndexes = getMacroIndexes(macroName, "json", tokenId)]
	<!-- first failure is if there are more than 1 -->
	[if (json.length(macroIndexes) > 1):
		reportResult = json.set(reportResult, macroName + ":index", "FAILED! " + 
			macroIndexes + " indexes")]
	[macroIndex = json.get(macroIndexes, 0)]
	[macroCommand = getMacroCommand(macroIndex, tokenId)]
	[macroMatches = strfind (macroCommand, VAR_DECLARE_PATTERN)]
	[findCount = getFindCount (macroMatches)]
	[log.debug (CATEGORY + "##" + macroName + ": " + findCount)]
	[for (i, 0, findCount), code: {
		[varDeclaration = getGroup(macroMatches, i + 1, 1)]
		[log.trace (CATEGORY + "## varDeclaration = " + varDeclaration)]
		[if (json.contains (allProps, varDeclaration)):
			reportResult = json.set (reportResult, libToken + ":" + macroName + ":" + 
				varDeclaration, "FAILED! Matches campaign property")]
	}]
}]
[h, if (json.isEmpty (reportResult)): reportResult = json.set ("", getMacroName(), 
		libToken + ": Passed")]
[h: log.info (CATEGORY + "##" + reportResult)]
[h: macro.return = reportResult]