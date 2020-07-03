[h, if (json.length (macro.args) > 0): skipMacro = arg (0); skipMacro = 0]
<!-- Attack needs to prompt for attack bonus and advantage/disadvantage -->
[h: abort (input ("name | Scimitar | Attack name | text",
				"bonus | 0 | Attack bonus | text",
				"hasAdvantage | 0 | Has Advantage | check",
				"hasDisadvantage | 0 | Has Disadvantage | check"))]

[h: attackExpression = json.set ("", "name", name, 
									"expressionTypes", "Attack",
									"bonus", bonus,
									"hasAdvantage", hasAdvantage,
									"hasDisadvantage", hasDisadvantage,
									"diceSize", 20,
									"diceRolled", 1)]

[h, macro ("Create Damage Roll Macro@Campaign"): "1"]
[h: damageExpressions = macro.return]
[h: rollExpressions = json.merge (json.append ("", attackExpression), damageExpressions)]
[h: log.info ("rollExpressions: " + json.indent (rollExpressions))]
[h, if (!skipMacro): dnd5e_DiceRoller_createMacro (rollExpressions)]
[h: macro.return = rollExpressions]