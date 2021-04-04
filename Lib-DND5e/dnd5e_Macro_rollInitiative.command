[h: dnd5e_Constants (getMacroName())]
[h: initList = ""]
[h: gmOutput = ""]
[r, foreach(Selected, getSelected("json"), ""), CODE:
{
	[h: log.trace (CATEGORY + "## Selected = " + Selected)]
	[h: switchToken(Selected)]
	[h: SelectedGMName = dnd5e_Util_Initiative_getGroupByValue (Selected)]
	[h: log.debug (CATEGORY + "## SelectedGMName = " + SelectedGMName)]
	[h, if (initList == ""): arr = "[]"; arr = json.fromStrProp(initList)]
	[h: log.trace (CATEGORY + "## arr = " + arr)]
	[r, if(json.contains(arr, SelectedGMName) != 0), CODE:
	{
		[h: log.trace (CATEGORY + "## " + SelectedGMName + " is grouped")]
		[h: init = json.get(arr, SelectedGMName)]
	};
	{
		[h: re = dnd5e_RollExpression_Initiative (getName() + " Initiative")]
		[h: rolled = dnd5e_DiceRoller_roll (re)]
		[h: re = json.get (rolled, 0)]
		[h: bonus = dnd5e_RollExpression_getBonus (re)]
		[h: tie = (50 + bonus) / 100]
		[h: total = dnd5e_RollExpression_getTotal (re)]
		[h: init = total + tie]
		[h: owners = getOwners ("json")]
		[h: log.debug (CATEGORY + "## " + SelectedGMName + " initiative: " + init + "; reporting to owners = " + owners]
		[h: reportOwners = if (!json.isEmpty (owners), 1, 0)]
		[if (reportOwners), w (owners), g, r: dnd5e_RollExpression_getFormattedOutput (rolled)]
		[h, if (!reportOwners): gmOutput = gmOutput + dnd5e_RollExpression_getFormattedOutput (rolled)]
		[h: initList = concat(initList, ";", SelectedGMName, "=", init)]
	}]
	[h: addToInitiative()]
	[h: setInitiative(init)]
}]
[h: log.trace (CATEGORY + "## gmOutput = " + gmOutput)]
[g, r: gmOutput]
[h: log.debug (CATEGORY + "## initList = " + initList)]
[h: sortInitiative()]
[h,foreach(Selected, getSelected("json")), CODE:
{
	[switchToken(Selected)]
	[init = getInitiative()]
	[init = floor(init)]
	[setInitiative(init)]
}]
