<!-- Get the selected tokens -->
[h: allSelected = json.sort(getSelected("json"))]
[h: log.debug(getMacroName() + ": allSelected" + allSelected)] 

<!-- Find any other tokens in the same area as the selected tokens -->
[h: areaSelected = "[]"]
[h: areaOffsets = getLibProperty("areaOffsets", "Lib:MultiSelect")]
[h, foreach(id, allSelected, "<br><br>"), code: {
	[h: area = json.set("{}", "token", id, "offsets", json.get(areaOffsets, getSize(id)))]
	[h: selected = getTokens("json", json.set("{}", "layer", "TOKEN", "area", area))]
	[h, foreach(selectedId, selected), code: {
		[h, if (!json.contains(areaSelected, selectedId)): areaSelected = json.append(areaSelected, selectedId)]
	}]
}]
[h: log.debug(getMacroName() + ": areaSelected before sorting=" + json.indent(areaSelected))]

<!-- Only show tokens in the frame if the lists are different -->
[h: areaSelected = json.sort(areaSelected)]
[h, if (json.toList(allSelected) == json.toList(areaSelected)), code: {
	[h: areaSelected = "[]"]
};{
	<!-- Sort tokens by name -->
	[h: nameMap = "{}"]
	[h, foreach(id, areaSelected, ""): nameMap = json.set(nameMap, getName(id), id)]
	[h: log.debug(getMacroName() + ": nameMap=" + json.indent(nameMap))]
	[h: orderedNames = json.sort(json.fields(nameMap, "json"))]
	[h: log.debug(getMacroName() + ": orderedNames=" + json.indent(orderedNames))]
	[h: areaSelected = "[]"]
	[h, foreach(name, orderedNames, ""): areaSelected = json.append(areaSelected, json.get(nameMap, name))]
	[h: log.debug(getMacroName() + ": areaSelected after sorting=" + json.indent(areaSelected))]
}]
[h: ms_frame(areaSelected)]
