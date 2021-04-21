<!--
<tr>
	<td>Slap</td>
	<td>+88</td>
	<td>2d8 + 16 Bulging</td>
</tr>
-->

[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: attackJson = getProperty ("attackExpressionJSON")]
[h: html = ""]
[h, foreach (attackKey, json.fields (attackJson, "json")), code: {
	[attackName = decode (attackKey)]
	[rollExpression = json.get (attackJson, attackKey)]
	[rollExpression = dnd5e_CharSheet_Util_adornRollExpressions (rollExpression)]
	[attackExpression = dnd5e_RollExpression_findExpressionByType (rollExpression, "Attack")]
	[damageExpression = dnd5e_RollExpression_findExpressionByType (rollExpression, "Damage")]
	[atkBonus = dnd5e_RollExpression_getBonus (attackExpression)]
	[dmgRollString = dnd5e_RollExpression_getRollString (damageExpression)]
	[dmgType = dnd5e_RollExpression_getDamageTypes (damageExpression)]

	<!-- stuff damage type into a span; hide from view -->
	<!-- Right align damage dice -->
	[damageTypeSpan = '<span title="' + dmgType + '"/>']
	[html = html + '<tr><td class="attack-detail-attack">' + 
		macroLink (attackName, "dnd5e_CharSheet_rollAttack@" + LIB_TOKEN, "all", attackKey, currentToken()) +
		'</td><td class="attack-detail-bonus">' + 
		macroLink (dnd5e_CharSheet_formatBonus (atkBonus),
			"dnd5e_CharSheet_rollAttackOnly@" + LIB_TOKEN, "all", attackKey, currentToken()) +
		'</td><td class="attack-detail-damage"><span title="' + dmgType + '">' +
		macroLink (dmgRollString, "dnd5e_CharSheet_rollDamageOnly@" + LIB_TOKEN, 
			"all", attackKey, currentToken()) +
		'</span></td></tr>']
}]
[h: macro.return = html]