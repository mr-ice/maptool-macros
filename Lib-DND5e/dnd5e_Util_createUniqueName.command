[h: baseName = arg(0)]
[h: existingNames = arg(1)]
[h: index = "1"]
[h: name = baseName]
[h, while(json.contains(existingNames, name)), code: {
	[h: name = baseName + " (" + index + ")"]
	[h: index = index + 1]
}]
[h: macro.return = name]