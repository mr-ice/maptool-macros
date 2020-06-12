[h: initList = "booga=-1"]
[h, foreach(Selected, getSelected("json")), CODE:
{
	[switchToken(Selected)]
	[SelectedGMName = getTokenImage()]
	[arr = json.fromStrProp(initList)]
	[if(json.contains(arr, SelectedGMName) != 0), CODE:
	{
		[init = json.get(arr, SelectedGMName)]
	};
	{
		[result = 1d20]
		[init = result + getProperty("Initiative", Selected)]
		[tie = getProperty("Initiative", Selected) / 100]
		[init = init + tie]
		[initList = concat(initList, ";", SelectedGMName, "=", init)]
	}]
	[switchToken(Selected)]
	[addToInitiative()]
	[setInitiative(init)]
}]
[h: sortInitiative()]
[h,foreach(Selected, getSelected("json")), CODE:
{
	[switchToken(Selected)]
	[init = getInitiative()]
	[init = floor(init)]
	[setInitiative(init)]
}]