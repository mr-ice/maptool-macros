[h: dnd5e_CharSheet_Constants (getMacroName())]

<!-- Dont do ANYTHING until youve confirmed the abilities are numbers -->
[h, foreach (abilityName, ARRY_ABILITIES_NAMES), code: {
	[abilityValue = getProperty (abilityName)]
	[if (!isNumber (abilityValue)): setProperty (abilityName, 10)]
}]

[h: html = '
<html>
	<head>
	<link rel="stylesheet" type="text/css" 
			href="CharSheet_CSS@Lib:DnD5e-CharacterSheet">
	</head>
	<body>
		' + dnd5e_CharSheet_getInfoHTML() + '
		<table>
			<tr>
				<td class="sheet-column-static">
					' + dnd5e_CharSheet_getAbilitiesHTML() + '
				</td>
				<td class="sheet-column-static">
					' + dnd5e_CharSheet_getTacticalAndEquipmentHTML() + '
				</td>
				<td class="sheet-column">
					' + dnd5e_CharSheet_getBackgroundAndResourcesHTML() + '
				</td>
			</tr>
		</table>
	</body>
</html>
']

[h: log.trace (CATEGORY + "## html = " + html)]
[dialog5 (strformat (PANEL_CHARACTER_SHEET_NAME), 
		"width=" + ATTR_CHAR_SHEET_PANEL_WIDTH + "; height=" +
		ATTR_CHAR_SHEET_PANEL_HEIGHT): {
	[r: html]
}]