[h: slug = arg (0)]
[h: o5e_Constants(getMacroName())]
[h: log.debug (CATEGORY + "## slug = " + slug)]
[h, if (startsWith (slug, "o5et_Data")), code: {
	[macro (slug + "@Lib:Open5e-TestLibrary"):""]
	[response = decode (macro.return)]
}; {
	[h: url = "https://api.open5e.com/" + slug]
	[h: log.debug (CATEGORY + "## url = " + url)]
	[h: response = REST.get (url)]
	[h: searchToken = indexOf (slug, "?")]
	[h: useExtDb = getLibProperty (PROP_USE_EXT_DB)]
	[h, if (useExtDb && searchToken >= 0): response = o5e_ExtDB_merge (response, slug)]
}]

[h: macro.return = response]