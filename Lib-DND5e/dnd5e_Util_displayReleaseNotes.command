<!-- Never do this for players. They DGAF -->
[h, if (!isGM()): return (0); ""]

<!-- Assert the Campaign Preferences library exists, or create it -->
[h, macro ("dnd5e_Preferences_createCampaignPrefToken@this"): ""]
[h: libTokenName = arg (0)]
[h: libKey = encode (libTokenName)]
[h: versionPrefObject = getLibProperty ("dev.versionMap", "Lib:CampaignPreferences")]
<!-- This will be a proper JSON object that evolves over time -->
[h, if (encode (versionPrefObject) == ""): versionPrefObject = "{}"; ""]
[h: versionObject = json.get (versionPrefObject, libKey)]
[h, if (encode (versionObject) == ""): versionObject = "{}"; ""]
<!-- For a given key there is a simple JSON map of values -->
<!-- hasPrompted value marks if weve already prompted the user -->
[h: hasPrompted = json.get (versionObject, "hasPrompted")]
[h, if (hasPrompted == ""): hasPrompted = 0; ""]
[h, if (hasPrompted): return (0); ""]

<!-- With the previousVersion, we grab all release notes for new versions -->
[h: previousVersion = json.get (versionObject, "previousVersion")]
[h, if (previousVersion == ""): previousVersion = "0.0"; ""]

<!-- Use a marker to note that weve found the current version. Once found, -->
<!-- we capture the release notes for following versions. When the previousVersion -->
<!-- is 0.0, the marker is immediately enabled -->
[h, if (previousVersion == "0.0"): markVersion = 1; markVersion = 0]
[h: log.debug (getMacroName() + ": previousVersion = " + previousVersion + "; markVersion = " + markVersion)]
[h: releaseNotesMap = "{}"]
[h: releaseNoteProperty = getLibProperty ("lib.releaseNotesObj", libTokenName)]
[h: log.debug (getMacroName() + ": releaseNoteProperty = " + releaseNoteProperty)]
[h, foreach (versionKey, releaseNoteProperty), code: {
	[rnValue = json.get (releaseNoteProperty, versionKey)]
	[log.debug (getMacroName() + ": versionKey = " + versionKey + "; rnValue = " + rnValue)]
	[if (markVersion): releaseNotesMap = json.set (releaseNotesMap, versionKey, rnValue)]
	[if (!markVersion && versionKey == previousVersion): markVersion = 1; ""]
}]
[h: log.debug ("releaseNotesMap: " + json.indent (releaseNotesMap))]
[h, if (json.isEmpty(releaseNotesMap)): return (0); ""]

[dialog (libTokenName + " Release Notes", "width=400; height=450"): {
	<html>
		<head>
			<title>[r: libTokenName] Release Notes</title>
		</head>
		<body>
		    <p style='font-size:10px;color:blue; text-align:center'>[r: libTokenName] Release Notes</p>
			<table style='border:1px solid black;margin-left:auto;margin-right:auto;padding:4px;'>
			[r, foreach (versionKey, json.fields (releaseNotesMap), ""), code: {
				[h: rNote = decode (json.get (releaseNotesMap, versionKey))]
				<tr><td style='text-align:left'>[r: versionKey]</td><td style='text-align:left'>[r: rNote]</td></tr>
			}]
			</table>
		</body>
	</html>
}]
[h: versionObject = json.set (versionObject, "previousVersion", getLibProperty ("libversion", libTokenName))]
[h: versionPrefObject = json.set (versionPrefObject, libKey, versionObject)]
[h: log.debug (getMacroName() + ": versionPrefObject = " + json.indent (versionPrefObject))]
[h: setLibProperty ("dev.versionMap", versionPrefObject, "Lib:CampaignPreferences")]
