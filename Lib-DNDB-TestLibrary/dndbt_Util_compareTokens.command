[h: tokenId1 = arg (0)]
[h: tokenId2 = arg (1)]

[h: token1Label = getName (tokenId1)]
[h: token2Label = getName (tokenId2)]

[h: reportName = "Token compare report for " + token1Label + "::" + token2Label]
[h: reportArry = "[]"]
<!-- Compare properties, stick to Basic -->
[h: properties = getAllPropertyNames ("Basic", "json")]
[h: properties = json.removeAll (properties, "Character ID")]
[h, foreach (property, properties), code: {
	
	[h: prop1 = getProperty (property, tokenId1)]
	[h: prop2 = getProperty (property, tokenId2)]
	[h, if (encode (prop1) != encode (prop2)): reportArry = json.append (reportArry, json.set ("", property, prop1 + "::" + prop2))]
}]
<!-- Compare Bars -->


<!-- Compare States -->
[h: report = json.set ("{}", reportName, reportArry)]
[h: macro.return = report]