[h: isHealing = arg(0)]
[h, if (!isHealing), code: {
	[h: dnd5e_takeDamage()]
}; {
	[h: dnd5e_takeHealing()]
}]
[h: dnd5e_CharSheet_refreshPanel ()]