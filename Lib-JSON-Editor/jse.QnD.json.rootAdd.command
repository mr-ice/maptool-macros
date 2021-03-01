[h: json = arg (0)]
[h, if (json.type (json) == "ARRAY"), code: {
	[abort (input (strformat(
	"newElement | %s | %s ", "", "Enter the value for the new array element"
	)))]
	[json = json.append (json, newElement)]
}; {
	[abort (input (
		".| Enter the new object element: || LABEL | SPAN=TRUE",
		"newKey | key | Key",
		"newValue || Value"
	))]
	[json = json.set (json, newKey, newValue)]
}]
[h: macro.return = json]