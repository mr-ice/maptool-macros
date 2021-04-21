[h: damageTypes = json.append("[]", "Acid", "Bludgeoning", "Magical Bludgeoning", "Cold", "Fire", "Force", "Lightning", "Necrotic", "Piercing", 
								"Magical Piercing", "Poison", "Psychic", "Radiant", "Slashing", "Magical Slashing", "Thunder")]
[h: fieldNames = json.append("[]", "bonus", "damageType", "rollString", "DC", "saveAbility", "saveAgainst", "saveEffect", "conditions", "saveResult",
								   "dndbAttack", "name", "onCritical", "dndbSpell", "dndbSpellLevel", "targetCheck", "drainAbility", "proficency",
								   "abilityMod")]
[h: stepTypes = json.append("[]", "Attack", "Damage", "DnDBeyond Attack", "Save", "Save Damage", "Save Effect", "Condition", "DnDBeyond Spell", "Target Check",
							      "Drain", "Save Drain")]
[h: fieldsByType = json.set("{}", json.get(stepTypes, 0), json.append("[]", json.get(fieldNames, 0), json.get(fieldNames, 16), json.get(fieldNames, 17)),
								  json.get(stepTypes, 1), json.append("[]", json.get(fieldNames, 2), json.get(fieldNames, 1), json.get(fieldNames, 16), json.get(fieldNames, 17)),
								  json.get(stepTypes, 2), json.append("[]", json.get(fieldNames, 9)),
								  json.get(stepTypes, 3), json.append("[]", json.get(fieldNames, 3), json.get(fieldNames, 4), json.get(fieldNames, 5)),
								  json.get(stepTypes, 4), json.append("[]", json.get(fieldNames, 2), json.get(fieldNames, 1), json.get(fieldNames, 6)),
								  json.get(stepTypes, 5), json.append("[]", json.get(fieldNames, 8), json.get(fieldNames, 7)),
								  json.get(stepTypes, 6), json.append("[]", json.get(fieldNames, 7)),
								  json.get(stepTypes, 7), json.append("[]", json.get(fieldNames, 12), json.get(fieldNames, 13)),
								  json.get(stepTypes, 8), json.append("[]", json.get(fieldNames, 14)),
								  json.get(stepTypes, 9), json.append("[]", json.get(fieldNames, 2), json.get(fieldNames, 15)),
								  json.get(stepTypes, 10), json.append("[]", json.get(fieldNames, 2), json.get(fieldNames, 15), json.get(fieldNames, 6)))]
[h: stepAttack = json.set("{}", "name", "Attack", "indicators", json.append("[]", "attack", "onCheck"),
					"tooltip", "Roll 1d20 + Bonus compared against target AC. Steps after this attack only apply to target on hit",
					"applyHeader", "Cover for %s Attack")]
[h: stepDamage = json.set("{}", "name", "Damage", "indicators", json.append("[]", "hit", "onCheck"),
					"tooltip", "Roll for damage to be applied to the target.",
					"tooltip-hit", "Roll for damage to be applied to the target on a hit from an attack.",
					"applyHeader", "Modify %s Damage")]
[h: stepDnDbAttack = json.set("{}", "name", "DnDBeyond Attack", "indicators", "[]",
						"tooltip", "Select a weapon attack from those found in DnD Beyond.")]
[h: stepSave = json.set("{}", "name", "Target Save", "indicators", json.append("[]", "save", "hit", "onCheck"),
					"tooltip", "A save that must be made by the target. Save damage and save conditions applied accordingly.",
					"tooltip-hit", "A save that must be made by the target. Save damage and save conditions applied accordingly on a hit from an attack.",
					"applyHeader", "Advantage on %s Save")]
[h: stepSaveDamage = json.set("{}", "name", "Damage", "indicators", json.append("[]", "hit", "onSave", "onCheck"),
						"tooltip", "Apply this damage to the target after they make a save. Damage altered by success or failure",
						"tooltip-hit", "Apply this damage to the target when hit and after they make a save. Damage altered by save's success or failure",
						"applyHeader", "Modify %s Save Damage")]
[h: stepSaveEffect = json.set("{}", "name", "Condition", "indicators", json.append("[]", "hit", "onSave", "onCheck"),
						"tooltip", "Apply conditions to the target depending on earlier Save result.",
						"tooltip-hit", "Apply conditions to target when hit depending on earlier Save result.",
						"applyHeader", "Apply %s Save Conditions")]
[h: stepCondition = json.set("{}", "name", "Condition", "indicators", json.append("[]", "hit", "onCheck"),
						"tooltip", "Apply these states to the target.",
						"tooltip-hit", "Apply these states to the target when they are hit.",
						"applyHeader", "Apply %s Conditions")]
[h: stepDnDbSpell = json.set("{}", "name", "DnDBeyond Spell", "indicators", "[]",
						"tooltip", "Select an attack spell from those found in DnD Beyond to use against the target")]
[h: stepTargetCheck = json.set("{}", "name", "Target Check", "indicators", json.append("[]", "hit", "check"),
						"tooltip", "Check the target for properties, states, and bars by creating a boolean expression",
						"tooltip-hit", "Check the target for properties, states, and bars by creating a boolean expression on a hit")]
[h: stepDrain = json.set("{}", "name", "Drain Ability", "indicators", json.append("[]", "hit", "onCheck"),
					"tooltip", "Drain an ability score.", "tooltip-hit", "Drain an ability score on a hit.")]
[h: stepSaveDrain = json.set("{}", "name", "Drain Ability", "indicators", json.append("[]", "hit", "onSave", "onCheck"),
					"tooltip", "Drain an ability score on a failed save.", "tooltip-hit", "Drain an ability score on a faild save after a hit.")]
[h: stepNamesByType = json.set("{}", json.get(stepTypes, 0), stepAttack, json.get(stepTypes, 1), stepDamage, json.get(stepTypes, 2), stepDnDbAttack,
									 json.get(stepTypes, 3), stepSave, json.get(stepTypes, 4), stepSaveDamage, json.get(stepTypes, 5), stepSaveEffect,
									 json.get(stepTypes, 6), stepCondition, json.get(stepTypes, 7), stepDnDbSpell, json.get(stepTypes, 8), stepTargetCheck,
									 json.get(stepTypes, 9), stepDrain, json.get(stepTypes, 10), stepSaveDrain)]
[h: actionTypes = json.append("[]", "DnD Beyond Weapon", "DnD Beyond Spell", "Generic Attack", "Damage with save", "Damage only",
							"Condition with save", "Condition only", "Free Form")]
[h: abilities = json.append("[]", "Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma")]
[h: stateGroups = json.append("[]", "02. Conditions", "03. Game States", "04. Fatigued", "05. Crosses", "06. Hexes", "07. Targets", "08. Wheels")]
[h: macroColors = json.set("{}", "aqua", "Aqua", "black", "Black", "blue", "Blue", "cyan", "Cyan", "darkgray", "Dark Gray", "fuchsia", "Fuchsia",
					"gray", "Gray", "gray25", "25% Gray", "gray50", "50% Gray", "gray75", "75% Gray", "green", "Green", "lightgray", "Light Gray",
					"lime", "Lime", "magenta", "Magenta", "maroon", "Maroon", "navy", "Navy", "olive", "Olive", "orange", "Orange", "pink", "Pink",
					"purple", "Purple", "red", "Red", "silver", "Silver", "teal", "Teal", "white", "White", "yellow", "Yellow")]
[h: typedDescriptorKeys = json.append("[]", "condition", "tooltipRoll", "tooltipDetail", "advantageable", "lucky", "critable", "saveable", "actionName",
											"actionDesc", "actionType", "rowId", "extendedValues", "save-effect-damage", "action-execution-key")]
[h: weaponTypes = json.append("[]", json.set("{}", "type", "Melee", "ability", "ability.melee", "bonus", "bonus.attack.melee"),
							        json.set("{}", "type", "Ranged", "ability", "ability.ranged", "bonus", "bonus.attack.ranged"),
							        json.set("{}", "type", "Finesse", "ability", "ability.finisse", "bonus", "bonus.attack.finisse"))]
[h: c = json.set("{}", "FIELDS_BY_STEP_TYPE", fieldsByType, "NAMES_OF_STEP_TYPES", stepNamesByType, "DAMAGE_TYPES", damageTypes, "CHAR_ABILITIES", abilities,
		"STATE_GROUPS", stateGroups, "MACRO_COLORS", macroColors, "TARGET_ROLL_TYPE", dnd5e_Type_Targeted(), "UNROLLABLE_ROLL_TYPE", dnd5e_Type_Unrollable(),
		"VERSION_PROPERTY", "_ae2_actions.version", "AE2_CURRENT_VERSION", "0.15", "AE_VERSION_PROPERTY", "attackExpressionJSON.version", "AE_CURRENT_VERSION", "0.15",
		"WEAPON_TYPES", weaponTypes)]
<!-- Break this statement up. May be too many characters -->
[h: c = json.set (c, 
	"ACTION_TYPES", actionTypes, "STATE_GROUPS", stateGroups,
		"DNDB_ATTACK_TYPE", json.get(actionTypes, 0), "DNDB_SPELL_TYPE", json.get(actionTypes, 1), "ATTACK_TYPE", json.get(actionTypes, 2),
		"SAVE_DAMAGE_TYPE", json.get(actionTypes, 3), "DAMAGE_TYPE", json.get(actionTypes, 4), "SAVE_COND_TYPE", json.get(actionTypes, 5), 
		"COND_TYPE", json.get(actionTypes, 6), "FREE_FORM_TYPE", json.get(actionTypes, 7),
	"STEP_TYPES", stepTypes, 
		"ATTACK_STEP_TYPE", json.get(stepTypes, 0), "DAMAGE_STEP_TYPE", json.get(stepTypes, 1), "DNDB_ATTACK_STEP_TYPE", json.get(stepTypes, 2),
		"SAVE_STEP_TYPE", json.get(stepTypes, 3), "SAVE_DAMAGE_STEP_TYPE", json.get(stepTypes, 4), "SAVE_CONDITION_STEP_TYPE", json.get(stepTypes, 5),
		"CONDITION_STEP_TYPE", json.get(stepTypes, 6), "DNDB_SPELL_STEP_TYPE", json.get(stepTypes, 7), "TARGET_CHECK_STEP_TYPE", json.get(stepTypes, 8),
		"DRAIN_STEP_TYPE", json.get(stepTypes, 9), "SAVE_DRAIN_STEP_TYPE", json.get(stepTypes, 10),
	"STEP_FIELDS", fieldNames, 
		"BONUS_FIELD", json.get(fieldNames, 0), "DAMAGE_TYPE_FIELD", json.get(fieldNames, 1), "ROLL_STRING_FIELD", json.get(fieldNames, 2),
		"DC_FIELD", json.get(fieldNames, 3), "SAVE_ABILITY_FIELD", json.get(fieldNames, 4), "SAVE_AGAINST_FIELD", json.get(fieldNames, 5),
		"SAVE_EFFECT_FIELD", json.get(fieldNames, 6), "SAVE_CONDITION_FIELD", json.get(fieldNames, 7), "SAVE_RESULT_FIELD", json.get(fieldNames, 8),
		"DNDB_ATTACK_FIELD", json.get(fieldNames, 9), "NAME_FIELD", json.get(fieldNames, 10), "ON_CRITICAL_FIELD", json.get(fieldNames, 11),
		"DNDB_SPELL_FIELD", json.get(fieldNames, 12), "DNDB_SPELL_LEVEL_FIELD", json.get(fieldNames, 13), "TARGET_CHECK_FIELD", json.get(fieldNames, 14),
		"DRAIN_ABILITY_FIELD", json.get(fieldNames, 15), "PROFICENCY_FIELD", json.get(fieldNames, 16), "ABILITY_MOD_FIELD", json.get(fieldNames, 17),
	"TYPED_DESCRIPTOR_KEYS", typedDescriptorKeys,
		"CONDITION_TD", json.get(typedDescriptorKeys, 0), "TOOLTIP_ROLL_TD", json.get(typedDescriptorKeys, 1), "TOOLTIP_DETAIL_TD", json.get(typedDescriptorKeys, 2),
		"ADVANTAGEABLE_TD", json.get(typedDescriptorKeys, 3), "LUCKY_TD", json.get(typedDescriptorKeys, 4), "CRITABLE_TD", json.get(typedDescriptorKeys, 5),
		"SAVEABLE_TD", json.get(typedDescriptorKeys, 6), "ACTION_NAME_TD", json.get(typedDescriptorKeys, 7), "ACTION_DESC_TD", json.get(typedDescriptorKeys, 8),
		"ACTION_TYPE_TD", json.get(typedDescriptorKeys, 9), "ROW_ID_TD", json.get(typedDescriptorKeys, 10), "EXTENDED_VALUES_TD", json.get(typedDescriptorKeys, 11),
		"SAVE_EFFECT_DAMAGE_TD", json.get(typedDescriptorKeys, 12), "ACTION_EXECUTION_KEY", json.get(typedDescriptorKeys, 13)
)]
[h: json.toVars(c)]
[h: return(0, c)]