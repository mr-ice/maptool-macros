[h: toon = arg (0)]
[h: spell = arg (1)]
[h: modifiers = arg (2)]

<!-- No idea what to do here yet. So just look for type == bonus and add the values -->
[h: searchArg = json.set ("", "object", modifiers, "type", "bonus", "property", "value")]
[h: values = dndb_searchJsonObject (searchArg)]
[h: bonusValue = 0]
[h, foreach (value, values): bonusValue = bonusValue + value]

[h: macro.return = bonusValue]