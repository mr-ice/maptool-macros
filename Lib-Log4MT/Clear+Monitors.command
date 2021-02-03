[h, macro ("getMeters@this"): ""]
[h: meters = macro.return]
[h, token ("Lib:ProfilerProxy"): libToken = currentToken()]
[h, foreach (propertyName, json.fields (meters)): 
		setProperty (propertyName, "", libToken)]