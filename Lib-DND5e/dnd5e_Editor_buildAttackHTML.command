[h: rollExpressions = arg (0)]
[h: attackIndex = arg (1)]
[h: attackExpression = "{}"]
[h: primaryDamageExpression = "{}"]
[h: extraDamageExpressions = "[]"]

[h: foundPrimaryDamage = 0]
[h, foreach (rollExpression, rollExpressions, ""), code: {
	[if (dnd5e_RollExpression_hasType (rollExpression, "Attack")): attackExpression = rollExpression; ""]
	[if (dnd5e_RollExpression_hasType (rollExpression, "Damage") && foundPrimaryDamage): 
			extraDamageExpressions = json.append (extraDamageExpressions, rollExpression); ""]
	[if (dnd5e_RollExpression_hasType (rollExpression, "Damage") && !foundPrimaryDamage), code: {
		[foundPrimaryDamage = 1]
		[primaryDamageExpression = rollExpression]
	}; {""}]
	[if (dnd5e_RollExpression_hasType (rollExpression, "saveable")):
			extraDamageExpressions = json.append (extraDamageExpressions, rollExpression); ""]
}]
[h: attackName = dnd5e_RollExpression_getName (attackExpression)]
<div class="attack-container">
	[r: dnd5e_Editor_getAttackDamageHtml (attackExpression, primaryDamageExpression, attackIndex)]
  <hr />
    [r: dnd5e_Editor_getAdditionalDamageHtml (extraDamageExpressions, attackIndex)]
</div>
<div>
	  <input name="deleteAttack-[r:attackName]" class="button red-right" value="Delete Attack" type="submit"/>
</div>