[h: slug = arg (0)]
[h: url = "https://api.open5e.com/" + slug]
[h: log.debug (getMacroName() + ": url = " + url)]
[h: response = REST.get (url)]
[h: o5e_Constants()]
[h: useExtDb = getLibProperty (PROP_USE_EXT_DB)]
[h, if (useExtDb): response = o5e_ExtDB_merge (response, slug)]

[h: macro.return = response]
