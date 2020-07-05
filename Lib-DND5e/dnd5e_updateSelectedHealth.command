<!-- Read parameters -->
[h: task = json.get(macro.args, "task")]
[h: label = json.get(macro.args, "label")]
[h: header = json.get(macro.args, "header")]
[h: apply = json.get(macro.args, "apply")]

<!-- Create the list of token names to show to the user -->
[h: sNames = getSelectedNames()]
[h, if (sNames == ""): names = "No tokens selected!"; names = ""]
[h, forEach(name, sNames): names = names + "<li>" + name]
[h: header = "junk|<html><b>" + header + "</b><ul>" + names + "</ul></html>|-|LABEL|SPAN=TRUE"]

<!-- Read the value from the user --> 
[h: abort(input(header, "value|0|" + label + "|TEXT|WIDTH=4"))]
[h, if (!isNumber(value) || value < 0): value = 0; '']

<!-- Process each selected token -->
[h: sIds = getSelected()]
[h: log.info("IDs:'" + sIds + "' Names:" + sNames)]
[h, foreach(id, sIds), code: {
	[h: log.info("ID: " + id + " " + task +"=" + value)]
	[h: params = json.set("{}", "id", id, "current", getProperty("HP", id), "maximum", getProperty("MaxHP", id), 
		"temporary", getProperty("TempHP", id), task, value)]
	[h, macro(apply): params]
}]
