<!-- Make Attack will call us to configure an attack. If so, we should ensure
	we call Make Attack after the config -->


[h: ATTACK_EXPRESSION_JSON = "attackExpressionJSON"]
[h: NEW_ATTACK = "New Attack"]

<!-- Read attack JSON and prompt for selection -->
[h: attackJson = json.set ("", NEW_ATTACK, "[]")]
[h, if (isPropertyEmpty (ATTACK_EXPRESSION_JSON)), code: {
	<!-- Property is empty, use blank object -->
	<!-- nothing to do now -->
	""
}; {
	<!-- Property is populated. Fetch JSON data -->
    [h: propAttackJson = getProperty(ATTACK_EXPRESSION_JSON)]
    [h: attackJson = json.merge (attackJson, propAttackJson)]
}]



[h: arrLen = json.length(attackJson)]
[h, if (arrLen < 1), code: {
	[h: selectedAttack = NEW_ATTACK]
}; {
	[h: attackList = "[]"]
    [h, foreach (attackName, json.fields (attackJson)): attackList = json.append (attackList, attackName)]
    [h: abort( input( "selectedAttack | " + json.toList(attackList) + " | Select Attack | list | value=string"))]
}]

<!-- Attack selected! Fetch the JSON for the selected roll expression. If "new" was selected, nothing will be found -->
[h: cfgAttackExpression = json.get (attackJson, selectedAttack)]

[h: dnd5e_RollExpression_AttackEditor (macroLinkText ("dndb_AttackConfig_storeAttackExpression@Lib:DnDBeyond", "all", "", currentToken()), cfgAttackExpression)]