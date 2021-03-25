[h: initList = ""]
[h: gmOutput = ""]
[r, foreach(Selected, getSelected("json"), ""), CODE:
{
	[h: switchToken(Selected)]
    <!-- [SelectedGMName = getTokenImage()] use this to group by image-->
	[h: SelectedGMName = getName()]
	[h: arr = json.fromStrProp(initList)]
	[r, if(json.contains(arr, SelectedGMName) != 0), CODE:
	{
		[h: init = json.get(arr, SelectedGMName)]
	};
	{
		[h: re = dnd5e_RollExpression_Initiative (SelectedGMName + " Initiative")]
		[h: rolled = dnd5e_DiceRoller_roll (re)]
		[h: re = json.get (rolled, 0)]
		[h: bonus = dnd5e_RollExpression_getBonus (re)]
		[h: tie = (50 + bonus) / 100]
		[h: total = dnd5e_RollExpression_getTotal (re)]
		[h: init = total + tie]
		[h: owners = getOwners ("json")]
		[if (!json.isEmpty(owners)), w (owners), g, r: dnd5e_RollExpression_getFormattedOutput (rolled);
			gmOutput = gmOutput + dnd5e_RollExpression_getFormattedOutput (rolled)]
		[h: initList = concat(initList, ";", SelectedGMName, "=", init)]
	}]
	[h: addToInitiative()]
	[h: setInitiative(init)]
}]
[g, r: gmOutput]
[h: log.debug (getMacroName() + "## initList = " + initList)]
[h: sortInitiative()]
[h,foreach(Selected, getSelected("json")), CODE:
{
	[switchToken(Selected)]
	[init = getInitiative()]
	[init = floor(init)]
	[setInitiative(init)]
}]
