[h: LIB_TOKEN = "Lib:DnD5e"]
[h, if (argCount() > 0): CATEGORY = LIB_TOKEN + "." + arg(0); CATEGORY = LIB_TOKEN]
[h: CATEGORY = CATEGORY]
[h: PROP_DRAW_ORDER = "dnd5e.token.drawOrder"]