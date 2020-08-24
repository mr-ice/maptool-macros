[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=false"))]
	[h: abort (0)]
}; {}]

[h: overrideSubObj = getProperty ("_dndb_OverrideBasicToon")]
[h: log.debug ("overrideSubObj: " + overrideSubObj)]
[h, if (json.length (overrideSubObj) > 0), code: {
	[h: basicToon = json.merge (basicToon, overrideSubObj)]
	<!-- Do not save basicToon back to token. This should be a -->
	<!-- transient override -->
	[h: log.warn (json.get (basicToon, "name") + " has had override values applied")]
}; {}]
[h: macro.return = basicToon]