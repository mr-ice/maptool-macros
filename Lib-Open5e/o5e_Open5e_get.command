[h: slug = arg (0)]
[h: url = "https://api.open5e.com/monsters" + slug]
[h: response = REST.get (url)]
[h: macro.return = response]