[h: propertyNames = getAllPropertyNames ("DNDebug")]
[h: currentVersion = "0.0"]
[h, foreach (propertyName, propertyNames), code: {
	<!-- The campaign property version is embedded within -->
	<!-- the property name to avoid modification and create -->
	<!-- a single source for the property value: -->
	<!-- ex. campaignPropertiesVersion{0.15} -->
	[strFindId = strfind (propertyName, "campaignPropertiesVersion\\{(.*)\\}")]
	[findCount = getFindCount (strFindId)]
	[if (findCount > 0): currentVersion = getGroup (strFindId, 1, 1); ""]
}]
[h: macro.return = currentVersion]