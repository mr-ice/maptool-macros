[h: meters = log_getMeters()]
[h, token (LIB_PROXY): libToken = currentToken()]
[h, foreach (propertyName, json.fields (meters)): 
		setProperty (propertyName, "", libToken)]
[r: "Monitors Cleared"]