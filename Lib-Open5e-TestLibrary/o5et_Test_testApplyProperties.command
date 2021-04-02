[h: o5et_Constants(getMacroName())]
[h: tokenId = o5et_Util_createTestToken ("Ever seen a grown man naked?")]
[h: report = "{}"]
[h, foreach (slug, STATIC_SLUGS), code: {
	[monsterJson = o5e_Open5e_get ("o5et_Data_" + slug)]
	[o5e_Token_applyMonsterToon (monsterJson, tokenId)]
	[macro ("o5et_Data_Properties_" + slug + "@this"): ""]
	[expectedProperties = decode (macro.return)]
	[foreach (testProperty, TEST_PROPERTIES), code: {
		[expectedProperty = json.get (expectedProperties, testProperty)]
		[actualProperty = getProperty (testProperty, tokenId)]
		[report = json.merge (report, o5et_Util_assertEqual (expectedProperty, actualProperty,
			"Property test - " + slug + " - " + testProperty))]
	}]
}]
[h: removeToken (tokenId)]
[h: log.debug (CATEGORY + "## report = " + report)]
[h: macro.return = report]