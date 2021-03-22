[h: rollExpression = arg (0)]
[h: description = ""]
<!-- assume DR_applyConditions has already confirmed we are running against a token -->
[h: currentStates = getTokenStates ("json", "*", currentToken())]

[h: propertyModifiers = dnd5e_RollExpression_getPropertyModifiers (rollExpression)]
<!-- virtually every Ability roll will have only one propertyModifier, but 
	we can support more. So act like it! -->
[h: abilityList = "[]"]
[h: skillList = "[]"]
[h, foreach (propertyModifier, propertyModifiers), code: {
	[skillList = json.append (skillList, propertyModifier)]
	[abilityIndex = indexOf (propertyModifier, "Ability")]
	[if (abilityIndex >= 0): abilityName = substring (propertyModifier, 0, abilityIndex); abilityName = evalMacro ("[r: ability." + propertyModifier + "]")]
	[abilityList = json.append (abilityList, abilityName)]
}]
[h: disadvantageConditions = "[]"]
[h: advantageConditions = "[]"]
[h: description = "[]"]
[h, foreach (currentState, currentStates), code: {
	<!-- strip the spaces so we can handle skill names like 'HandleAnimal' and 'SleightOfHand' -->
	[switchState = replace (currentState, " ", "")]
	<!-- explicitly setting out a case for each skill pair is tedious, but it should perform better -->
	[switch (switchState), code:
		case "AdvantageonAllAbilities": {
			[advantageConditions = json.append (advantageConditions, currentState)]
		};

		case "DisadavantageonAllAbilities": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};

		case "AdvantageonStrength": {
			[if (json.contains (abilityList, "Strength")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonDexterity": {
			[if (json.contains (abilityList, "Dexterity")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonConstitution": {
			[if (json.contains (abilityList, "Constitution")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonIntelligence": {
			[if (json.contains (abilityList, "Intelligence")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonWisdom": {
			[if (json.contains (abilityList, "Wisdom")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonCharisma": {
			[if (json.contains (abilityList, "Charisma")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "DisadvantageonStrength": {
			[if (json.contains (abilityList, "Strength")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonDexterity": {
			[if (json.contains (abilityList, "Dexterity")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonConstitution": {
			[if (json.contains (abilityList, "Constitution")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonIntelligence": {
			[if (json.contains (abilityList, "Intelligence")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonWisdom": {
			[if (json.contains (abilityList, "Wisdom")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonCharisma": {
			[if (json.contains (abilityList, "Charisma")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};

		case "AdvantageonAcrobatics": {
			[if (json.contains (skillList, "Acrobatics")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonAnimalHandling": {
			[if (json.contains (skillList, "AnimalHandling")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonArcana": {
			[if (json.contains (skillList, "Arcana")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonAthletics": {
			[if (json.contains (skillList, "Athletics")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonDeception": {
			[if (json.contains (skillList, "Deception")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonHistory": {
			[if (json.contains (skillList, "History")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonInsight": {
			[if (json.contains (skillList, "Insight")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonIntimidation": {
			[if (json.contains (skillList, "Intimidation")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonInvestigation": {
			[if (json.contains (skillList, "Investigation")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonMedicine": {
			[if (json.contains (skillList, "Medicine")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonNature": {
			[if (json.contains (skillList, "Nature")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonPerception": {
			[if (json.contains (skillList, "Perception")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonPerformance": {
			[if (json.contains (skillList, "Performance")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonPersuasion": {
			[if (json.contains (skillList, "Persuasion")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonReligion": {
			[if (json.contains (skillList, "Religion")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonSleightofHand": {
			[if (json.contains (skillList, "SleightofHand")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonStealth": {
			[if (json.contains (skillList, "Stealth")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "AdvantageonSurvival": {
			[if (json.contains (skillList, "Survival")): advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "DisadvantageonAcrobatics": {
			[if (json.contains (skillList, "Acrobatics")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonAnimalHandling": {
			[if (json.contains (skillList, "AnimalHandling")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonArcana": {
			[if (json.contains (skillList, "Arcana")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonAthletics": {
			[if (json.contains (skillList, "Athletics")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonDeception": {
			[if (json.contains (skillList, "Deception")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonHistory": {
			[if (json.contains (skillList, "History")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonInsight": {
			[if (json.contains (skillList, "Insight")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonIntimidation": {
			[if (json.contains (skillList, "Intimidation")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonInvestigation": {
			[if (json.contains (skillList, "Investigation")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonMedicine": {
			[if (json.contains (skillList, "Medicine")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonNature": {
			[if (json.contains (skillList, "Nature")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonPerception": {
			[if (json.contains (skillList, "Perception")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonPerformance": {
			[if (json.contains (skillList, "Performance")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonPersuasion": {
			[if (json.contains (skillList, "Persuasion")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonReligion": {
			[if (json.contains (skillList, "Religion")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonSleightofHand": {
			[if (json.contains (skillList, "SleightofHand")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonStealth": {
			[if (json.contains (skillList, "Stealth")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "DisadvantageonSurvival": {
			[if (json.contains (skillList, "Survival")): disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};


		
		case "Dead": {
			[description = json.append (description, "You're <font color='red'><b>DEAD!</b> You just... fail.</font>")]
			[rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
		};

		case "Poisoned": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Exhaustion1": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Blinded": {
			[description = json.append (description, "You're <font color='red'><b>Blind</b></font>! You fail if check requires sight.")]
		};
		case "Deafened": {
			[description = json.append (description,  "You're <font color='red'><b>Deaf</b></font>! You fail if check requires hearing.")]
		};
		case "Frightened": {
			[description = json.append (description,
				"You're <font color='red'><b>Frightened</b></font>! You have disadvantage while the source of the fear is within line of sight.")]
		};
		default: {""};
	]
}]

[h, if (json.length (advantageConditions) > 0), code: {
	[description = json.append (description, "Applying Advantage due to the condition" +
		if (json.length (advantageConditions) > 1, "s: ", ": ") +
		"<span style='color: blue; font-weight: bold;'>" + json.toList (advantageConditions, ", ") + "</span>")]
	[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]
}]

[h, if (json.length (disadvantageConditions) > 0), code: {
	[description = json.append (description, "Applying Disadvantage due to the condition" +
		if (json.length (disadvantageConditions) > 1, "s: ", ": ") +
		"<span style='color: red; font-weight: bold;'>" + json.toList (disadvantageConditions, ", ") + "</span>")]
		[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}]
<!-- Save the descriptions and the condition descriptors -->
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "condition", description)]
[h, foreach(desc, description): rollExpression = dnd5e_RollExpression_addDescription (rollExpression, desc)]
[h: macro.return = rollExpression]