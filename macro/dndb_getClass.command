[h: toon = arg (0)]
[h: className = arg (1)]

[h: classObj = json.path.read (toon, "data.classes[*].[?(@.definition.name == '" + className + "')]")]

[h: macro.return = classObj]
