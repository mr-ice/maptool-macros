[h:theList = getTokenStates()]
[h: states = ""]
[h, foreach (item, theList, ""), code: {
	[if(getState(item)): states = states + item + ", "; ""]
}]
[h: wrappedStates = dnd5e_Property_wrapText (states)]
[h: macro.return = wrappedStates]