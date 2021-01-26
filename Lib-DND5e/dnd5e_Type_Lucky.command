<!-- For the sake of demonstation, heres how you ensure your priority is properly related
		to another interested party. Eg. Lucky should re-roll right after the basic roll and before
		any other re-rools... -->
[h: basic = dnd5e_Type_Basic()]
[h: priority = dnd5e_Type_getPriority (basic) + 1]
[h: type = json.set ("",
	"type", "lucky",
	"roller",  "dnd5e_DiceRoller_luckyRoll:" + priority
)]
[h: macro.return = type]