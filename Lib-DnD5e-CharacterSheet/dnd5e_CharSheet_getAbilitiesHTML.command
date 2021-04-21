[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: html = '

<table>
    <tr>
        <td width="0" class="offwhite" align="center" valign="middle"
            style="border-style: double solid; border-width:3px; border-color:white">
            <!-- ATTRIBUTES -->
            <!-- Strength Table -->
'
]

[h, foreach (ability, ARRY_ABILITIES_NAMES), code: {
	[upperAbility = upper (ability)]
	[abbrevAbility = substring (upperAbility, 0, 3)]
	[abilityValue = getProperty (ability)]
	[abilityBonus = getProperty (ability + "Bonus")]
	[abilityCheckBonus = getProperty (ability + "Ability")]
	[abilityCheckBonusStr = dnd5e_CharSheet_formatBonus (abilityCheckBonus)]
	<!-- Abilities column -->
	[html = html + 
'            <table class="ability">
                <tr>
                    <td class="ability-title"><span title="Edit Abilities">' +
                    	macroLink (abbrevAbility, 
                    		"dnd5e_CharSheet_changeAbilities@" + LIB_TOKEN,
                    		"", "", currentToken())
                    	+'</span>
                    
                    </td>
                </tr>
                <tr>
                    <td class="ability-value">
                        <span title="Roll ' + ability + ' Ability Check (' + 
                        	abilityCheckBonusStr + ')">' +
                        	macroLink (dnd5e_CharSheet_formatBonus (abilityBonus),
                        		"dnd5e_CharSheet_rollAbility@" + LIB_TOKEN,
                        		"all", ability + "Ability", currentToken())
                        + '</span>
                    </td>
                </tr>
                <tr>
                    <td class="ability-subvalue">
                    	<!-- future use of the span may be value breakdown -->
                        <span>' + abilityValue + '</span>
                    </td>
                </tr>
            </table>'
	]	
}]
        
[h: html = html + '
        </td>
		<!-- Inspiration / Proficiency -->
        <td>
            <table>
                <tr>
                    <td class="inspiration-toggle">' +
                    	macroLink (dnd5e_CharSheet_formatBoolean (PROP_INSPIRATION),
                    		"dnd5e_CharSheet_toggleProperty@" + LIB_TOKEN,
                    		"", PROP_INSPIRATION, currentToken()) + '
                    </td>
                    <td class="inspiration-label double-outline">INSPIRATION</td>
                </tr>
            </table>
            <table style=" margin-top:5">
                <tr>
                    <td class="inspiration-toggle">' +getProperty ("Proficiency")+ '</td>
                    <td class="inspiration-label double-outline">PROFICIENCY BONUS</td>
                </tr>
            </table>
            <table class="single-outline" style="margin-top:5;">'
]
            <!-- SAVES -->
[h, foreach (abilityName, json.append (ARRY_ABILITIES_NAMES, "Death")), CODE: {
	[upperAbility = upper (abilityName)]
	[if (abilityName == "Death"): 
			abbrevAbility = abilityName;
			abbrevAbility = substring (abilityName, 0, 3)]
	[saveValue = getProperty (abilityName + "Save")]
	[saveValueStr = dnd5e_CharSheet_formatBonus (saveValue)]
	[saveProficiencyProperty = "proficiency." + abbrevAbility + "Save"]
	[saveProficiency = getProperty (saveProficiencyProperty)]
	[saveProficiencyStr = dnd5e_CharSheet_formatProficiency (saveProficiency)]

	[html = html + '
                <tr>
                    <td class="save-proficient">
                        <!-- Proficiency marker ex. proficiency.chaSave-->
                        <span>' +
				macroLink (saveProficiencyStr, 
					"dnd5e_CharSheet_changeProficiency@" + LIB_TOKEN,
					"",
					json.append ("", saveProficiencyProperty, 
						abilityName + " Save Proficiency"),
					currentToken())
                        + '</span>
                    </td>

                    <td class="save-bonus">
                        <!-- Save Bonus -->
                        <span title= "Roll ' + abilityName + ' Saving Throw">' +
                 macroLink (saveValueStr,
                 	 "dnd5e_CharSheet_rollSave@" + LIB_TOKEN,
                 	 "all",
                 	 abilityName,
                 	 currentToken())
                        + '</span>
                    </td>
                    <td class="save-label">' + abilityName + '</td>
                </tr>'
      ]
}]
[h: html = html + '
                <tr>
                    <td align="center" colspan="3"
                        class="subtext">
                        <b>' +
                 macroLink ("SAVES", 
                 	"dnd5e_CharSheet_changeSaves@" + LIB_TOKEN,
                 	"",
                 	"",
                 	currentToken())     	
                        + '</b>
                    </td>
                </tr>
            </table>
            <!-- SKILLS -->
            <table class="single-outline" style="margin-top:5">']

[h, foreach (skillName, ARRY_SKILLS_NAMEs), code: {
	[log.debug (CATEGORY + "## skillName = " + skillName)]
	[skillPropertyName = replace (skillName, " ", "")]
	[skillBonus = getProperty (skillPropertyName)]
	[skillNonBreakingName = replace (skillName, " ", "&nbsp")]
	[skillProficiencyPropertyName = "proficiency." + skillPropertyName]
	[skillProficiencyValue = getProperty (skillProficiencyPropertyName)]
	[skillProficiencyStr = dnd5e_CharSheet_formatProficiency (skillProficiencyValue)]
	[skillAbility = getProperty ("ability." + skillPropertyName)]
	[skillAbilityAbbrev = substring (skillAbility, 0, 3)]

	[html = html + '
				<tr>
                    <td class="save-proficient">' +
			macroLink (skillProficiencyStr, 
				"dnd5e_CharSheet_changeProficiency@" + LIB_TOKEN,
				"",
				json.append ("", skillProficiencyPropertyName, skillName),
				currentToken())
                    + '</td>
                    <td class="save-bonus">
                        <span title="Roll '+skillName+'">' +
			macroLink (skillBonus,
				"dnd5e_CharSheet_rollAbility@" + LIB_TOKEN,
				"all",
				json.append ("", skillPropertyName, skillName),
				currentToken())
                        + '</span>
                    </td>
                    <td class="save-label">'+skillNonBreakingName+'&nbsp(<span
                    	title="Edit ' + skillName + '">'+ 
			macroLink (skillAbilityAbbrev,
				"dnd5e_CharSheet_changeSkills@" + LIB_TOKEN,
				"",
				json.append ("", skillName),
				currentToken()) + '</span>)</td>
                </tr>

	']
}]

[h: html = html + '            
                <tr>
                    <td colspan="3" align="center"
                        class="subtext">
                        <b>' +
			macroLink ("SKILLS",
				"dnd5e_CharSheet_changeSkills@" + LIB_TOKEN,
				"", "", currentToken())
                        + '</b>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
   <!-- Passive Perception (Wis) -->
    <tr>
        <td colspan="2">
            <table>
                <tr>
                    <td class="inspiration-toggle">' +
		add (getProperty ("Perception"), 10)
                    + '</td>
                    <td class="inspiration-label">PASSIVE WISDOM (PERCEPTION)</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <table class="double-outline">
                <tr>
                    <td class="detail">']
[h, for (index, 0, json.length (ARRY_OTHER_PROPERTIES)), code: {
	[propertyName = json.get (ARRY_OTHER_PROPERTIES, index)]
	[propertyDisplayName = json.get (ARRY_OTHER_PROP_NAMES, index)]
	[html = html + '<span title="Edit Proficiency">' + macroLink (propertyDisplayName,
			"dnd5e_CharSheet_changeProperty@" + LIB_TOKEN,
			"", json.append ("", propertyName, propertyDisplayName), currentToken())
			+ '</span>: ' + getProperty (propertyName) + '<br/>']
}]
[h: html = html + '</td>
                </tr>
                <tr>
                    <td class="subtext" align="center">
                        <b>OTHER PROFICIENCIES &amp; LANGUAGES</b>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
']
[h: log.trace (CATEGORY + "## html = " + html)]
[r: html]