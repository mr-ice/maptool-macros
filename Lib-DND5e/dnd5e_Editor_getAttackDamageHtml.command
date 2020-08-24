[h: attackExpression = arg (0)]
[h: damageExpression = arg (1)]
[h: attackIndex = arg (2)]
[h: attackName = dnd5e_RollExpression_getName (attackExpression)]
[h: attackBonus = dnd5e_RollExpression_getBonus (attackExpression)]
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
      <label>Damage Roll<input name="damageRoll-[r: attackIndex]" value="[r: damageRollString]" title="Full dice expression, ala '1d6+8'"></label>
      <label>Damage Type<input class="long-input" name="damageType-[r: attackIndex]" value="[r: damageTypes]" title="Comma separated list of damage types"></label>
    </div>
  </div>