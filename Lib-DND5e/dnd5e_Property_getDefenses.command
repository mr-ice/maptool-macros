
[h: line1 = ""]
[h: line2 = ""]
[h: line3 = ""]
[h: line4 = ""]

[h: idx = 1]
[h, if (getProperty ("AC") != ""), code: {
	[acString = dnd5e_Property_wrapText ("AC: " + getProperty ("AC"))]
	[line1 = acString]
	[idx = idx + 1]
}; {""}]

[h, if (getProperty ("Vulnerabilities") != ""), code: {
	[vulnString = dnd5e_Property_wrapText ("Vulnerabilities: " + getProperty ("Vulnerabilities"))]
	[evalMacro ("[line" + idx + " = vulnString]")]
	[idx = idx + 1]
}; {""}]

[h, if (getProperty ("Resistances") != ""), code: {
	[resString = dnd5e_Property_wrapText ("Resist: " + getProperty ("Resistances"))]
	[evalMacro ("[line" + idx + " = resString]")]
	[idx = idx + 1]
};{""}]

[h, if (getProperty ("Immunities") != ""), code: {
	[immString = dnd5e_Property_wrapText ("Immune: " + getProperty ("Immunities"))]
	[evalMacro ("[line" + idx + " = immString]")]
}]

[r: line1]
[r: line2]
[r: line3]
[r: line4]