[h: type = json.set ("",
	"type", "saveable",
	"roller",  json.append ("[]", 
			"dnd5e_DiceRoller_saveDamageRoll:150",
			"dnd5e_DiceRoller_saveEffectRoll:150")
)]
[h: macro.return = type]