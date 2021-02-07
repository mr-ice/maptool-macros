[h: re = arg (0)]
[h: ability = json.get (re, "spellcastingAbility")]
[h, if (ability == ""): ability = -1; ""]
[h: macro.return = ability]