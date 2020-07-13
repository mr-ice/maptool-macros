[h: rollExpressions = arg (0)]
[h: attackIndex = arg (1)]
[h: extraDamages = "[]"]
[h, foreach (rollExpression, rollExpressions), code: {
	[if (dnd5e_RollExpression_hasType (rollExpression, "damagable")): extraDamages = json.append (extraDamages, rollExpression); ""]
}]
[h: totalDmg = json.length (extraDamages)]
[h: extraDmgIndex = 0]

[r, foreach (extraDamage, extraDamages, ""), code: {
	[h: damageSaveAbilty = dnd5e_RollExpression_getSaveAbility(extraDamage)]
	[h: strSelected = ""]
	[h: dexSelected = ""]
	[h: conSelected = ""]
	[h: intSelected = ""]
	[h: wisSelected = ""]
	[h: chaSelected = ""]
	[h: noneSelected = ""]
	[h, switch (damageSaveAbilty): 
		case "Strength": strSelected = "selected";
		case "Dexterity": dexSelected = "selected";
		case "Constitution": conSelected = "selected";
		case "Intelligence": intSelected = "selected";
		case "Wisdom": wisSelected = "selected";
		case "Charisma": chaSelected = "selected";
		default: noneSelected = "selected"
	]
	[h: damageRollString = dnd5e_RollExpression_getRollString (extraDamage)]
	[h: damageTypes = dnd5e_RollExpression_getDamageTypes (extraDamage)]
	[h: damageSaveDC = dnd5e_RollExpression_getSaveDC (extraDamage)]
	[h: damageSaveEffect = dnd5e_RollExpression_getSaveEffect (extraDamage)]
  <div class="roll-container">
  	<input name="extraDamage-[r: attackIndex]" value="[r: totalDmg]" hidden="true" />
    <div>
      <div>
        <label>Extra Damage Roll<input name="extraDamageRoll-[r: attackIndex]-[r:extraDmgIndex]" value="[r: damageRollString]" title="Full dice expression, ala '1d6+8'"></label>
        <label>Damage Type<input class="long-input" name="extraDamageType-[r: attackIndex]-[r:extraDmgIndex]" value="[r: damageTypes]" title="Comma separated list of damage types"></label>
      </div>
      <div>
        <label>Save DC<input class="short-input" name="extraDamageSaveDC-[r: attackIndex]-[r:extraDmgIndex]" value="[r: damageSaveDC]" title="Difficulty Class of the save against the damage; Leave blank if none is required"></label>
        <label>Save Type
          <select name="extraDamageSaveAbility-[r: attackIndex]-[r: extraDmgIndex]" id="saveSelect-[r: attackIndex]-[r:extraDmgIndex]" title="Save Ability of the save against the damage; Select 'None' when not required">
            <option value="None" [r:noneSelected]>None</option>
            <option value="Strength" [r:strSelected]>Strength</option>
            <option value="Dexterity" [r:dexSelected]>Dexterity</option>
            <option value="Constitution" [r:conSelected]>Constitution</option>
            <option value="Wisdom" [r:wisSelected]>Wisdom</option>
            <option value="Intelligence" [r:intSelected]>Intelligence</option>
            <option value="Charisma" [r:chaSelected]>Charisma</option>
          </select>
        </label>
        </div>
        <div>
        <label>Save Effect<input class="wide-input" name="extraDamageSaveEffect-[r: attackIndex]-[r:extraDmgIndex]" value="[r: damageSaveEffect]"/></label>
        <input name="deleteExtraDamage-[r: attackIndex]-[r:extraDmgIndex]" class="button red-right" value="Delete Damage" type="submit" title="Deletes the extra damage"/>
      </div>
    </div>
  </div>
  [h: extraDmgIndex = extraDmgIndex + 1]
  [r, if (extraDmgIndex < totalDmg): "<hr class='hr-short' />"; ""]
}]
<input name="addExtraDamage-[r: attackIndex]" class="button" value="Add Damage" type="submit" title="Adds a new blank Extra Damage entry"/>