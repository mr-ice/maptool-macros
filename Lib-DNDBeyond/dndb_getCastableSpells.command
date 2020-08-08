
[h: basicToon = dndb_getBasicToon ()]

[h: spells = json.get (basicToon, "spells")]

[h: macro.return = spells]