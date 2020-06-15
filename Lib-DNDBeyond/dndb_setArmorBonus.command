[h: armor = arg(0)]
[h: log.debug ("Getting AC for " + json.path.read (armor, "definition.name"))]
[h: baseAC = json.path.read (armor, "definition.armorClass")]
[h: log.debug ("baseAC: " + baseAc)]

[h: bonuses = json.path.read (armor, "definition.grantedModifiers.[?(@.subType == 'armor-class')]['value']", "SUPPRESS_EXCEPTIONS,ALWAYS_RETURN_LIST")]
[h: totalBonus = 0]
[h, foreach (bonus, bonuses): totalBonus = totalBonus + bonus]
[h: log.debug ("bonuses: " + bonuses)]
[h: armor = json.set (armor, "bonus", totalBonus, "baseArmorClass", baseAC)]

[h: macro.return = armor]