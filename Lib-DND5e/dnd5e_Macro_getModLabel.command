[h: forMod = arg (0)]
[h: modPreference = dnd5e_Preferences_getPreference ("privateMacroModLabel")]
[h: defaultMap = json.set ("", "advantage", "<html>&#x23eb;</html>", "disadvantage", "<html>&#x23ec;</html>", "both", "<html>&#x23eb;&#x23ec;</html>")]
[h: modMap = json.set ("",
	"Double-Triangle", 
		json.set ("", "advantage", "<html>&#x23eb;</html>", "disadvantage", "<html>&#x23ec;</html>", "both", "<html>&#x23eb;&#x23ec;</html>"),
	"Single-Triangle",
		json.set ("", "advantage", "<html>&#x25B2;</html>", "disadvantage", "<html>&#x25BC;</html>", "both", "<html>&#x25B2;&#x25BC;</html>"),
	"Small-Triangle",
		json.set ("", "advantage", "<html>&#9652;</html>", "disadvantage", "<html>&#9662;</html>", "both", "<html>&#9652;&#9662;</html>"),
	"Chevron",
		json.set ("", "advantage", "<html><b>&and;</b></html>", "disadvantage", "<html><b>&or;</b></html>", "both", "<html>&and;&or;</html>"),
	"Arithmetic",
		json.set ("", "advantage", "<html><b>+</b></html>", "disadvantage", "<html><b>-</b></html>", "both", "<html><b>+</b><b>-</b></html>")
)]
[h: modObject = json.get (modMap, modPreference)]
[h, if (encode (modObject) == ""): modObject = defaultMap; ""]
[h: label = json.get (modObject, forMod)]
[h, if (label == ""): label = json.get (defaultMap, forMod); ""]
[h: macro.return = label]	