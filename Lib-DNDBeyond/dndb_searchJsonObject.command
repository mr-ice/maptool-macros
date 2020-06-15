<!-- Instead of the usual arg array, try a json obj -->

[h: filterObj = arg(0)]
[h: object = json.get (filterObj, "object")]
[h: property = json.get (filterObj, "property")]
[h: searchType = json.get (filterObj, "_searchType")]
[h, if (searchType == ""): searchType = "=="]
[h: even = 1]

[h: filterObj = json.remove (filterObj, "object")]
[h: filterObj = json.remove (filterObj, "property")]
[h: filterObj = json.remove (filterObj, "_searchType")]
<!-- now build the filter -->

[h: rawValues = json.append ("", "true", "false")]

[h: filter = ""]
[h, foreach (field, json.fields (filterObj)), code: {
	<!-- to avoid nesting code, build the filter first, then check if we want it -->
	[h, if (filter == ""): filter = ".[?("; filter = filter + " && "]
	[h: rawValue = json.get (filterObj, field)]
	[h: useRawValue = 0]
	[h, if (json.contains (rawValues, rawValue) > 0 || isNumber (rawValue) || searchType == "=~"): useRawValue = 1]
	<!-- This is fucking stupid. Ask me why, sometime -->
	[h, if (useRawValue > 0): 
		filterToken = "@." + field + " " + searchType + " " + rawValue;
		filterToken = "@." + field + " " + searchType + " " + "'" + rawValue + "'"]

	[h: filter = filter + filterToken]
}]
[h: filter = filter + ")]"]
<!-- close the filter -->
[h, if (property != ""): filter = filter + "['" + property + "']"]
[h: log.debug ("dndb_searchJsonObject: filter = " + filter)]
[h: ret = json.path.read (object, filter)]
[h: macro.return = ret]
