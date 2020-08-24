[h: diceSize = json.get (arg (0), "diceSize")]
[h, if (!isNumber (diceSize)): diceSize = 0; ""]
[h: macro.return = diceSize]