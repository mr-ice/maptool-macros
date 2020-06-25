[h: allProperties = getAllPropertyNames ("Basic", "json")]
[h, foreach (property, allProperties), code: {
	[h, if (property != "Character ID"): setProperty (property, "");""]
}]
