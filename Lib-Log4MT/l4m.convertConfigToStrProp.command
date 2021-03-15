[h: cfgObj = arg (0)]
[h: formattedWrapperCfgs = "{}"]
[h: sortedFields = json.sort (json.fields (cfgObj, "json"))]
[h, foreach (field, sortedFields), code: {
	[strPropValues = json.toStrProp (json.get (cfgObj, field))]
	[formattedWrapperCfgs = json.set (formattedWrapperCfgs, field, strPropValues)]
}]
[h: macro.return = formattedWrapperCfgs]