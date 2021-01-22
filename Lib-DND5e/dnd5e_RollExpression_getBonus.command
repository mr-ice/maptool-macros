[h: bonus = json.get (arg (0), "bonus")]
[h: bonus = dnd5e_Util_Parser_expandProperties (bonus, 0)]
<!-- This will convert a string like 5 + %7BAnimal Handling%7D to 5 + 2.
	We still need to do the math, after that -->
[h: bonus = evalMacro ("[r: " + bonus + "]")]
[h, if (!isNumber(bonus)): bonus = 0; ""]
[h: macro.return = bonus]