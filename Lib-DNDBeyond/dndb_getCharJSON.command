
[h: BASE_URL = "https://character-service.dndbeyond.com/character/v3/character/"]
[h: charId = json.get( macro.args, 0 )]


[h: charAt = lastIndexOf (charId, "/")]


[h, if (charAt > -1): charId = substring (charId, charAt + 1)]

[h: url = BASE_URL + charId]
[h: log.info ("char url: " + url)]
[h: character = REST.get(url)]
[h: macro.return = character]