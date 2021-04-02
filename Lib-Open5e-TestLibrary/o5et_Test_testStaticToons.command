[h: o5et_Constants(getMacroName())]
[h: report = "{}"]
[h, foreach (slug, STATIC_SLUGS), code: {
	[liveToon = o5e_Open5e_get ("monsters/" + slug)]
	[staticToon = o5e_Open5e_get ("o5et_Data_" + slug)]
	[report = json.merge (report, 
		o5et_Util_assertEqual (liveToon, staticToon, "Static - slug: " + slug))]
}]
[h: log.debug (CATEGORY + "## report = " + report)]
[h: macro.return = report]
