[h: attackExpression = arg (0)]
[h: damageExpression = arg (1)]
[h: attackIndex = arg (2)]
[h: attackName = dnd5e_RollExpression_getName (attackExpression)]
[h: attackBonus = dnd5e_RollExpression_getBonus (attackExpression)]
[h: isWeapon = dnd5e_RollExpression_hasType (attackExpression, "weapon")]
[h: isSpell = dnd5e_RollExpression_hasType (attackExpression, "spellcastingAbility")]
[h, if (!isWeapon && !isSpell): isGeneric = 1; isGeneric = 0]
[h: weaponType = dnd5e_RollExpression_getWeaponType (attackExpression)]
[h, if (weaponType == ""): weaponType = "melee";""]
[h: abilityVal = dnd5e_RollExpression_getSpellcastingAbility (attackExpression)]
[h, if (abilityVal == ""): abilityVal = "3"; ""]
<!-- always returns 0 if unset -->
[h: proficiencyVal = dnd5e_RollExpression_getProficiency (attackExpression)]
[h: weaponTypeDisplay = "none"]
[h: abilityDisplay = "none"]
[h: proficiencyDisplay = "none"]
[h, if (isWeapon), code: {
	[selectedType = "weapon"]
	[weaponTypeDisplay = "initial"]
	[proficiencyDisplay = "initial"]
}; {}]
[h, if (isSpell), code: {
	[selectedType = "ability"]
	[abilityDisplay = "initial"]
	[proficiencyDisplay = "initial"]
}; {}]
[h, if (isGeneric), code: {
	[selectedType = "generic"]
}; {}]
[h: dnd5e_Util_HTML_defineSelectVars (
		json.append ("[]", "weapon", "ability", "generic"),
		selectedType,
		"attackType")]

[h: dnd5e_Util_HTML_defineSelectVars (
		json.append ("[]", "0", "1", "2"),
		weaponType,
		"weaponType")]

[h: dnd5e_Util_HTML_defineSelectVars (
		json.append ("[]", "0", "1", "2", "3", "4", "5"),
		abilityVal,
		"ability")]

[h: dnd5e_Util_HTML_defineSelectVars (
		json.append ("[]", "0", "0.5", "1", "2"),
		proficiencyVal,
		"proficiency")]

[h: onCritAdd = dnd5e_RollExpression_getOnCritAdd (damageExpression)]
<!-- for new attacks, dont show 0d0. just slap in something -->
[h, if (attackName == "New Attack"): damageRollString = "1d6"; damageRollString = dnd5e_RollExpression_getRollString (damageExpression)]
[h: damageRollString = dnd5e_RollExpression_getRollString (damageExpression)]
[h: damageTypes = dnd5e_RollExpression_getDamageTypes (damageExpression)]
  <div class="roll-container">
    <div>
      <label>Name<input class="long-input" name="attackName-[r: attackIndex]" value="[r: attackName]" title="Name of the attack"></label>
      <label>Bonus<input class="short-input" name="attackBonus-[r: attackIndex]" value="[r: attackBonus]" title="Total bonus for the attack"></label>
      <label>Critical Adds<input class="short-input" name="damageCritical-[r: attackIndex]" value="[r: onCritAdd]" title="Number of dice to add for a critical hit. Leave blank for normal critical damage."></label>
    </div>

    <div>
      <label for="attackType-[r: attackIndex]">Attack Type </label>
      <select name="attackType-[r: attackIndex]" onchange="toggleAttackType(this.value, '[r: attackIndex]')" id="attackTypeId">
        <option value="weapon" [r: attackType.weapon.selected]>Weapon</option>
        <option value="ability" [r: attackType.ability.selected]>Spell / Ability</option>
        <option value="generic" [r: attackType.generic.selected]>Generic</option>
      </select>

      <label style="display : [r:weaponTypeDisplay]" for="weaponType-[r: attackIndex]" id="weaponTypeLabelId-[r: attackIndex]">Weapon Type
        <select name="weaponType-[r: attackIndex]" id="weaponTypeId-[r: attackIndex]">
          <option value="0" [r: weaponType.0.selected]>Melee</option>
          <option value="1" [r: weaponType.1.selected]>Ranged</option>
          <option value="2" [r: weaponType.2.selected]>Finesse</option>
        </select></label>

      <label style="display : [r:abilityDisplay]" for="ability-[r: attackIndex]" id="abilityLabelId-[r: attackIndex]">Ability
        <select name="ability-[r: attackIndex]" id="abilityId-[r: attackIndex]">
          <option value="0" [r: ability.0.selected]>Strength</option>
          <option value="1" [r: ability.1.selected]>Dexterity</option>
          <option value="2" [r: ability.2.selected]>Constitution</option>
          <option value="3" [r: ability.3.selected]>Intelligence</option>
          <option value="4" [r: ability.4.selected]>Wisdom</option>
          <option value="5" [r: ability.5.selected]>Charisma</option>
        </select></label>


      <label style="display : [r:proficiencyDisplay]" for="proficiency-[r: attackIndex]" id="proficiencyLabelId-[r: attackIndex]">Proficiency
        <select name="proficiency-[r: attackIndex]" id="proficiencyId-[r: attackIndex]">
          <option value="0" [r: proficiency.0.selected]>None</option>
          <option value="0.5" [r: proficiency.0.5.selected]>Half</option>
          <option value="1" [r: proficiency.1.selected]>Proficient</option>
          <option value="2" [r: proficiency.2.selected]>Expert</option>
        </select></label>

    </div>

    
    <div>
      <label>Damage Roll<input name="damageRoll-[r: attackIndex]" value="[r: damageRollString]" title="Full dice expression, ala '1d6+8'"></label>
      <label>Damage Type<input class="long-input" name="damageType-[r: attackIndex]" value="[r: damageTypes]" title="Comma separated list of damage types"></label>
    </div>
  </div>