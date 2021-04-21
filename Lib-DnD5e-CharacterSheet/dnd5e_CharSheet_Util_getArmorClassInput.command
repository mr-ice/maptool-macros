[h: tokenId = arg(0)]

[h: dnd5e_CharSheet_Constants (getMacroName())]
<!-- Armor type, AC provided, Shield, and any spurrious bonus -->
<!--
armor.type
armor.ac
shield.ac
bonus.ac
-->
[h: currentArmorType = getProperty ("armor.type", tokenId)]
[h: currentAC = getProperty ("armor.ac", tokenId)]
[h: currentShield = getProperty ("shield.ac", tokenId)]
[h: currentBonus = getProperty ("bonus.ac", tokenId)]

[h: log.debug (CATEGORY + "## currentArmorType = " + currentArmorType + 
	"; currentAC = " + currentAC +
	"; currentShield = " + currentShield +
	"; currentBonus = " + currentBonus)]
[h, token (tokenId): inputString = "junk |<html><font style='font-size: 15px'>" + getProperty ("AC") +
	" |<html>" + dnd5e_CharSheet_getArmorClassSpan("Current Armor Class") + "</span></html>| Label | span=false"]
[h: inputString = listAppend (inputString, "junk |_____________________________________________||label|span=true", "##")]

[h: acType = "armor.type | " + ARRY_ARMOR_TYPES + " | Equipped Armor Type | LIST | "+
	+" value=string delimiter=json select=" + 
	json.indexOf (ARRY_ARMOR_TYPES, currentArmorType)]
[h: inputString = listAppend (inputString, acType, "##")]

[h: acValue = "armor.ac | " + currentAC + " | Armor AC Bonus | TEXT"]
[h: inputString = listAppend (inputString, acValue, "##")]

[h: shieldAc = "shield.ac | " + currentShield + " | Shield AC Bous | TEXT"]
[h: inputString = listAppend (inputString, shieldAc, "##")]

[h: bonusAc = "bonus.ac | " + currentBonus + " | Additional AC Bonus | TEXT"]
[h: inputString = listAppend (inputString, bonusAc, "##")]

[h: log.debug (CATEGORY + "## inputString = " + inputString)]
[h: macro.return = inputString]