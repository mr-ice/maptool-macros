[h, if (json.length (macro.args) > 0): skipMacro = arg (0); skipMacro = 0]
<!-- Attack needs to prompt for attack bonus and advantage/disadvantage -->
[h: abort (input ("name |  Acrobatics, Animal Handling, Arcana, Athletics, Deception," +
					"History, Insight, Medicine, Perception, Performance, Persuasion," +
					"Religion, Sleight of Hand, Stealth, Survival, Strength, Dexterity," +
					"Constitution, Intelligence, Wisdom, Charisma" + 
					"| Save name | List | value=string",
				"bonus | 0 | Save bonus | text",
				"calculateBonus | 0 | Calculate bonus from token | check",
				"hasAdvantage | 0 | Has Advantage | check",
				"hasDisadvantage | 0 | Has Disadvantage | check"))]

[h: checkExpression = json.set ("", "name", name, 
									"expressionTypes", "Check",
									"bonus", bonus,
									"hasAdvantage", hasAdvantage,
									"hasDisadvantage", hasDisadvantage,
									"diceSize", 20,
									"diceRolled", 1)]

[h: log.info ("checkExpression: " + json.indent (checkExpression))]
[h, if (calculateBonus): bonusProperty  = name; bonusProperty = ""]
[h, if (!skipMacro): dnd5e_DiceRoller_createMacro (checkExpression, bonusProperty)]
[h: macro.return = checkExpression]