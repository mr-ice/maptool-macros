[h, if (json.length (macro.args) > 0): skipMacro = arg (0); skipMacro = 0]
<!-- Attack needs to prompt for attack bonus and advantage/disadvantage -->
[h: abort (input ("name | Strength, Dexterity, Constitution, Intelligence, Wisdom, Charisma, Death " + 
					"| Save name | List | value=string",
				"bonus | 0 | Save bonus | text",
				"hasAdvantage | 0 | Has Advantage | check",
				"hasDisadvantage | 0 | Has Disadvantage | check",
				"calculateBonus | 0 | Calculate bonus from token | check"))]

[h: saveExpression = json.set ("", "name", name, 
									"expressionTypes", "Save",
									"bonus", bonus,
									"hasAdvantage", hasAdvantage,
									"hasDisadvantage", hasDisadvantage,
									"diceSize", 20,
									"diceRolled", 1)]

[h: log.info ("saveExpression: " + json.indent (saveExpression))]
[h, if (calculateBonus): bonusProperty  = name + " Save"; bonusProperty = ""]
[h, if (!skipMacro): dnd5e_DiceRoller_createMacro (saveExpression, bonusProperty)]
[h: macro.return = saveExpression]