[h: type = json.set ("",
	"type", "basic",
	"roller",  json.append ("[]", 
				"dnd5e_DiceRoller_applyConditions:2",
				"dnd5e_DiceRoller_basicRoll:50",
				"dnd5e_DiceRoller_finalize:100")
)]
[h: macro.return = type]