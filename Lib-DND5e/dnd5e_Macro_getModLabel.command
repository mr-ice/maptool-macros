[h: forMod = arg (0)]
[h, if (argCount() > 1): wrap = arg(1); wrap = 1]
[h: modPreference = dnd5e_Preferences_getPreference ("privateMacroModLabel")]
[h: modMap = json.set ("",
	"Double-Triangle", 
		json.set ("", "advantage", "&#x23eb;", "disadvantage", "&#x23ec;", "both", "&#x23eb;&#x23ec;", "normal", "&#x23e9;"),
	"Single-Triangle",
		json.set ("", "advantage", "&#x25B2;", "disadvantage", "&#x25BC;", "both", "&#x25B2;&#x25BC;", "normal", "&#x25B6;"),
	"Small-Triangle",
		json.set ("", "advantage", "&#9652;", "disadvantage", "&#9662;", "both", "&#9652;&#9662;", "normal", "&#x25B8;"),
	"Chevron",
		json.set ("", "advantage", "<b>&and;</b>", "disadvantage", "<b>&or;</b>", "both", "&and;&or;", "normal", "<b>&lg;</b>"),
	"Arithmetic",
		json.set ("", "advantage", "<b>+</b>", "disadvantage", "<b>-</b>", "both", "<b>+</b><b>-</b>", "normal", "<b>=<b>"),
	"Letters",
		json.set ("", "advantage", "<b>A</b>", "disadvantage", "<b>D</b>", "both", "<b>B</b>", "normal", "<b>N<b>")
)]
[h: modObject = json.get (modMap, modPreference)]
[h, if (encode (modObject) == ""): modObject = json.get (modMap, "Double-Triangle")]
[h: label = json.get (modObject, forMod)]
[h, if (label == ""): label = forMod]
[h, if (wrap): label = strformat("<html>%s<html>", label)]
[h: macro.return = label]