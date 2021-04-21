[h: profValue = arg (0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: log.debug (CATEGORY + "## profValue = " + profValue)]
[h, if (!isNumber (profValue)): profValue = 0]
[h, switch (profValue):
	case "0.5": profStr = "&#189;";
	case 1: profStr = "&check;";
	case 2: profStr = "&check;&check;";
	default: profStr = "O";
]
[h: log.debug (CATEGORY + "## profStr = " + profStr)]
[h: macro.return = profStr]