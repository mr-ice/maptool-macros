[h: o5et_Constants (getMacroName())]

[h: macroOptions = json.set ("", "group", "Data Macros")]
[h, foreach (slug, STATIC_SLUGS), code: {
	[urlPart = "monsters/" + slug]
	[toon = o5e_Open5e_get (urlPart)]
	[dnd5e_Macro_createDataMacro ("o5et_Data_" + slug, toon, LIB_TOKEN, 
		macroOptions)]
}]
[r: "Static toons created"]