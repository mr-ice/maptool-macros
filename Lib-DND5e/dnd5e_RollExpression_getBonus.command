[h: bonus = json.get (arg (0), "bonus")]
[h, if (!isNumber(bonus)): bonus = 0; ""]
[h: macro.return = bonus]