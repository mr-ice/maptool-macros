[h: bonus = json.get (arg (0), "bonus")]
[h, if (bonus == ""): bonus = 0; ""]
[h: macro.return = bonus]