
[h: line1 = ""]
[h: line2 = ""]
[h: line3 = ""]
[h: line4 = ""]

[h: idx = 1]
[h, if (AC != ""), code: {
	[acString = dnd5e_Property_wrapText ("AC: " + AC)]
	[line1 = acString]
	[idx = idx + 1]
}; {""}]

[h, if (Vulnerabilities != ""), code: {
	[vulnString = dnd5e_Property_wrapText ("Vulnerabilities: " + Vulnerabilities)]
	[evalMacro ("[line" + idx + " = vulnString]")]
	[idx = idx + 1]
}; {""}]

[h, if (Resistances != ""), code: {
	[resString = dnd5e_Property_wrapText ("Resist: " + Resistances)]
	[evalMacro ("[line" + idx + " = resString]")]
	[idx = idx + 1]
};{""}]

[h, if (Immunities != ""), code: {
	[immString = dnd5e_Property_wrapText ("Immune: " + Immunities)]
	[evalMacro ("[line" + idx + " = immString]")]
}]

[r: line1]
[r: line2]
[r: line3]
[r: line4]