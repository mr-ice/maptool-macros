[h: rawValue = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: encoded = base64.encode (rawValue)]
[h: encoded = replace (encoded, "=", "")]
[h: macro.return = encoded]