[h: id = macro.args]
[h, if (json.type(id) == "ARRAY"): id = json.get(macro.args, id)]
[h: isSelected = json.contains(getSelected("json"), id)]
[h, if (isSelected): deselectTokens(id); selectTokens(id, true)]