[h: id = macro.args]
[h, if (json.type(id) == "ARRAY"): id = json.get(macro.args, id)]
[h: bringToFront(id)]
[h: selectTokens(id)]