[h: initList = "booga=-1"]
[h, foreach(Selected, getSelected("json")), CODE:
{
	[switchToken(Selected)]
    <!-- [SelectedGMName = getTokenImage()] use this to group by image-->
	[SelectedGMName = getName()]
	[arr = json.fromStrProp(initList)]
	[if(json.contains(arr, SelectedGMName) != 0), CODE:
	{
		[init = json.get(arr, SelectedGMName)]
	};
	{
		[init=if(isNumber(getProperty("Initiative", Selected)),getProperty("Initiative", Selected),0)]
		[tie = init / 100]
		[init = 1d20 + init + tie]
		[initList = concat(initList, ";", SelectedGMName, "=", init)]
	}]
	[addToInitiative()]
	[setInitiative(init)]
}]
[h: log.debug (getMacroName() + "## initList = " + initList)]
[h: sortInitiative()]
[h,foreach(Selected, getSelected("json")), CODE:
{
	[switchToken(Selected)]
	[init = getInitiative()]
	[init = floor(init)]
	[setInitiative(init)]
}]