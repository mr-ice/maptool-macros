<!-- Constants for a little initial help -->
[h: ATK_BONUS = 10]
[h: DMG_BONUS = 8]
[h: RAGE_BONUS = 3]
[h: DMG_DIE = "6"]

<!-- fetch values from properties -->
[h: isRage = getProperty("isRaging")]
[h,if (isPropertyEmpty("attackBonus")): attackBonus = ATK_BONUS; attackBonus = getProperty("attackBonus")]
[h,if (isPropertyEmpty("dmgNumDice")): dmgNumDice = 1; dmgNumDice = getProperty("dmgNumDice")]
[h,if (isPropertyEmpty("dmgDie")): dmgDie = DMG_DIE; dmgDie = getProperty("dmgDie")]
[h,if (isPropertyEmpty("dmgBonus")): dmgBonus = DMG_BONUS; dmgBonus = getProperty("dmgBonus")]
[h,if (isPropertyEmpty("rageBonus")): rageBonus = RAGE_BONUS; rageBonus = getProperty("rageBonus")]
[h,if (isPropertyEmpty("critBonus")): critBonus = 1; critBonus = getProperty("critBonus")]
[h,if (isPropertyEmpty("isBlessed")): isBlessed = 0; isBlessed = getProperty("isBlessed")]
[h,if (isPropertyEmpty("blessBonus")): blessBonus=4; blessBonus = getProperty("blessBonus")]

<!-- Prompt user -->
[h: abort(input("attackBonus|" + attackBonus + "|Attack bonus|text",
    "dmgNumDice|" + dmgNumDice + "|Number of Damage Dice|text",
    "dmgDie|" + dmgDie + "|Damage Die|text",
    "dmgBonus|" + dmgBonus + "|Damage bonus|text",
    "critBonus|" + critBonus + "|Number of extra crit dice|text",
    "rageBonus|" + rageBonus + "|Rage bonus|text",
	"isRage|" + isRage + "|Raging|check",
	"blessBonus|" + blessBonus + "|Bless Bonus Die|text",
	"isBlessed|" + isBlessed + "|Blessed|check",
	"advantageDisadvantage|None,Advantage,Disadvantage|Advantage/Disadvantage|list|value=string",
	"damageType|Bludgeoning,Piercing,Slashing|Damage Type|list|value=string"))]

<!-- Preserve the interesting choices so they default for the next prompt -->
[h: setProperty("isRaging", isRage)]
[h: setProperty("attackBonus", attackBonus)]
[h: setProperty("dmgBonus", dmgBonus)]
[h: setProperty("rageBonus", rageBonus)]
[h: setProperty("dmgNumDice", dmgNumDice)]
[h: setProperty("dmgDie", dmgDie)]
[h: setProperty("critBonus", critBonus)]
[h: setProperty("isBlessed", isBlessed)]
[h: setProperty("blessBonus", blessBonus)]
[h: setProperty("damageType", damageType)]

<!-- Roll attack dice (always roll two, determine if advantage or disadvantage applies after -->
[h: attack = 1d20]
[h: attack2 = 1d20]

<!-- Roll damage, apply rage -->

[h,if(isRage > 0): dmgBonus = dmgBonus + rageBonus]

<!-- Roll Blessed, apply to total bonus -->

[h,if(isBlessed > 0): blessAttackBonus = roll( 1, blessBonus )]

<!-- Calculate the correct dmg roll -->
[h: realAttack = attack]
[h,if (advantageDisadvantage == "Advantage"): realAttack = max(attack, attack2)]
[h,if (advantageDisadvantage == "Disadvantage"): realAttack = min(attack, attack2)]

<!-- Apply critical -->
[h,if (realAttack == 20): dmgNumDice = dmgNumDice + critBonus]
<!-- Roll damage -->
[h: dmg = roll(dmgNumDice,dmgDie) + dmgBonus]
<!-- Build the message -->
[h: atkString = "<b>"]
[h: atk2String = "<b>"]
[h,if(attack == 20): atkString = atkString + "<font color='red'><i>CRITICAL</i></font> "]
[h,if(attack2 == 20): atk2String = atk2String + "<font color='red'><i>CRITICAL</i></font> "]
[h: attack = attack + attackBonus]
[h: attack2 = attack2 + attackBonus]
[h,if(isBlessed > 0),CODE:
{
	[h:attack = attack + blessAttackBonus]
	[h:atkString = atkString + "<font color='green'>Blessed <<d"+blessBonus+"="+blessAttackBonus+"</font> "]
	[h:atk2String = atk2String + "<font color='green'>Blessed <<d"+blessBonus+"="+blessAttackBonus+"</font> "]
};
{
    This may be the fallthrough (false isBlessed)
}]
[h: realAttack = realAttack + attackBonus]
[h,if(advantageDisadvantage != "None"): realAtkString = "<b>" + realAttack + "</b>"]
[h: atkString = atkString + attack + "</b>"]
[h: atk2String = atk2String + attack2 + "</b>"]


[h: nameStr = getName() + "<br><br>"]
[h: atkStr = "Attack (1d20 + " + attackBonus + "): " + atkString + "<br>"]
[h,if(advantageDisadvantage != "None"): atkStr = atkStr + advantageDisadvantage + ": " + atk2String + "<br>" + "Actual Attack: " + realAtkString + "<br>"]
[h: dmgStr = "Damage (" + dmgNumDice + "d" + dmgDie + " + " + dmgBonus]

[h: dmgStr = dmgStr + "): " + dmg + " " + damageType ]

[r: atkStr]
[r: dmgStr]