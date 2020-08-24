[h: diceRolled = json.get (arg (0), "diceRolled")]
[h, if (!isNumber (diceRolled)): diceRolled = 0; ""]
[h: macro.return = diceRolled]