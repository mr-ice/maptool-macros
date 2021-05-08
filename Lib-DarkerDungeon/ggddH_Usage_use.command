<!-- Get the useable -->
[h: name = arg(0)]
[h: assert(!json.isEmpty(name), "No useable name passed")]
[h: useableData = getProperty("ggdd_useables")]
[h: assert(!json.isEmpty(useableData), "No useables defined")]
[h: assert(json.contains(useableData, name), "No useable named '" + name + "'")]
[h: die = json.get(useableData, name)]
[h: assert(isNumber(die), "Die size for " + name + " is invalid")]
[h: assert(die, name + " is Empty", 0)]

<!-- Check the uses -->
[h: useRoll = roll(1, die)]
[h, if (useRoll < 3), code: {
	[h, switch(die):
		case 20: newDie = 12;
		case 4: newDie = 0;
		default: newDie = die - 2
	]
	[h: useableData = json.set(useableData, name, newDie)]
	[h: setProperty("ggdd_useables", useableData)]
	[h: drained = if(newDie == 0, "is <b color=red>Empty</b>", "is Reduced to <b color=red>1d" + newDie + "</b>")]
	[h: useColor = "red"]
	[h: ggddH_Usage_updateMacros(name, newDie, currentToken())]
};{
	[h: drained = "remains at 1d" + die]
	[h: useColor = "black"]
}]

<!-- Output -->
[h: out = json.append("[]", strformat("<br><font size='4'><b>Using %{name}</b></font> @1d%{die}"))]
[h: out = json.append(out, "<div style='margin-left: 15px;'>")]
[h: out = json.append(out, strformat("Use roll is <b color=%{useColor}>%{useRoll}</b><br>"))]
[h: out = json.append(out, strformat("%{name} %{drained}"))]
[h: log.debug(getMacroName() + " macro.retur=" + json.indent(out))]
[h: macro.return = json.toList(out, "")]
