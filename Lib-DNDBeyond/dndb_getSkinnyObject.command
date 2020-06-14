[h: object = arg(0)]
[h: retains = arg(1)]

[h: skinnyObj = "{}"]
[h, foreach (field, json.fields (object)), code: {
	[h, if (json.contains (retains, field)): skinnyObj = json.set (skinnyObj, field, json.get (object, field))]
}]
[h: macro.return = skinnyObj]