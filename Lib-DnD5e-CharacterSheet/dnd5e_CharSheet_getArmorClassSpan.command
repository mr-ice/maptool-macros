[h: displayText = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h, if (displayText != ""): totalAC = displayText; totalAC = getProperty ("AC")]

[h: armorBonus = dnd5e_CharSheet_formatNumber (getProperty ("armor.ac"), 10)]
[h, if (armorBonus == ""): armorBonus = 0]
[h: shieldBonus = getProperty ("shield.ac")]
[h, if (shieldBonus == ""): shieldBonus = 0]
[h: bonusAC = getProperty ("bonus.ac")]
[h, if (bonusAC == ""): bonusAC = 0]
[h: armorDexBonus = getProperty ("armor.dexBonus")]
[h, if (!isNumber (armorDexBonus)): armorDexBonus = 0]
[h: armorType = getProperty ("armor.type")]
[h, if (armorType == ""): armorType = "No"]
[h: log.debug (CATEGORY	+ "## armorBonus = " + armorBonus +
	";shieldBonus = " + shieldBonus + 
	";bonusAC = " + bonusAC +
	";armorDexBonus = " + armorDexBonus +
	";armorType = " + armorType)]
[h: title = armorDexBonus + " (Dex Bonus; " + armorType + " armor)"]
[h, if (armorBonus > 0): title = concat (title, " + " + armorBonus + " (Armor)")]
[h, if (shieldBonus > 0): title = concat (title, " + " + shieldBonus + " (Shield)")]
[h, if (bonusAC > 0): title = concat (title, " + " + bonusAC + " (Bonus)")]

[h: html = '<span title="' + title + '">' + totalAC + '</span>']
[h: macro.return = html]