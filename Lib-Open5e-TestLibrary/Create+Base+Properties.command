[h: o5et_Constants (getMacroName())]
[h: macroOptions = json.set ("", "group", "Data Macros")]
[h: tokenId = o5et_Util_createTestToken ("Test Token")]
[h, foreach (slug, STATIC_SLUGS), code: {
	[o5et_Util_cleanTokenProperties (tokenId)]
	<!-- use live JSON -->
	[monsterJson = o5e_Open5e_get ("monsters/" + slug)]
	[o5e_Token_applyMonsterToon (monsterJson, tokenId)]
	[allPropertyValues = "{}"]
	[foreach (testProperty, TEST_PROPERTIES), code: {
		[propertyValue = getProperty (testProperty, tokenId)]
		[allPropertyValues = json.set (allPropertyValues, testProperty, propertyValue)]
	}]
	[dnd5e_Macro_createDataMacro ("o5et_Data_Properties_" + slug, allPropertyValues, 
		LIB_TOKEN, macroOptions)]
}]
[h: removeToken (tokenId)]
[r: "Created Base Properties"]