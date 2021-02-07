[h: type = json.set ("",
	"type", "saveable",
	"roller",  json.append ("[]", 
			"dnd5e_DiceRoller_saveDamageRoll:100",
			"dnd5e_DiceRoller_saveEffectRoll:100")
)]
[h: macro.return = type]