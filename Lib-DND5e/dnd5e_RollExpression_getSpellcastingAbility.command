[h: re = arg (0)]
[h: ability = json.get (re, "spellcastingAbility")]
[h, if (!isNumber(ability)): ability = -1]
[h: macro.return = ability]