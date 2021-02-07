<!-- Removes basicRoll from the stack -->
[h: re = arg(0)]
[h: log.debug (getMacroName() + ": rolling " + re)]
[h: rollers = json.get (re, "remainingRollers")]
[h: index = json.indexOf (rollers, "dnd5e_DiceRoller_basicRoll")]
[h, while (index >= 0), code: {
	[rollers = json.remove (rollers, index)]
	[index = json.indexOf (rollers, "dnd5e_DiceRoller_basicRoll")]
}]
[h: re = json.set (re, "remainingRollers", rollers)]
[h: log.debug (getMacroName() + " returning " + re)]
[h: macro.return = re]