[h: l4m.Constants()]
[h, token (LIB_LOG4MT): libToken = currentToken()]

[h: libProperties = json.fromList (getPropertyNames ("json", libToken))]
[h: pattern = "meter."]
[h: meters = "{}"]
[h, foreach (libProperty, libProperties, ""), code: {
	[index = indexOf (libProperty, pattern)]
	[if (index >= 0), code: { 
		[meter = getProperty (libProperty, libToken)]
		[meters = json.set (meters, libProperty, meter)]
	}; {}]
}]

[h: macro.return = meters]