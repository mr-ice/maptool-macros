[h: l4m.Constants()]
[h: meters = l4m.getMeters()]
[h, foreach (propertyName, json.fields (meters)): 
		setLibProperty (propertyName, "", LIB_LOG4MT)]
[r: "Meters Cleared"]