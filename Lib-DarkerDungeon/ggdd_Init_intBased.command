[h: ids = getSelected("json")]
[h: gmOutput = ""]
[r, foreach(id, ids, ""), code: {
	[h: switchToken (id)]
	[h: SelectedGMName = getName()]

	[h: re = dnd5e_RollExpression_Initiative (SelectedGMName + " Initiative")]
	<!-- This macro must always roll Intelligecnce so hamstring the RE -->
	[h: re = json.set (re, "propertyModifiers", "")]
	[h: re = dnd5e_RollExpression_setBonus (re, getProperty ("IntelligenceBonus", id))]
	[h: rolled = dnd5e_DiceRoller_roll (re)]
	[h: re = json.get (rolled, 0)]
	[h: bonus = dnd5e_RollExpression_getBonus (re)]
	[h: init = dnd5e_RollExpression_getTotal (re)]
	[h: owners = getOwners ("json")]
	[if (!json.isEmpty(owners)), w (owners), r: dnd5e_RollExpression_getFormattedOutput (rolled);
			gmOutput = gmOutput + dnd5e_RollExpression_getFormattedOutput (rolled)]
	[h: addToInitiative(0, init, id)]
}]
[g, r: gmOutput]
[h: sortInitiative()]
[h: setInitiativeRound(1)]
[h: setCurrentInitiative(0)]