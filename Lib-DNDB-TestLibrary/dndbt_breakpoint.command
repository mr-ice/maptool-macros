[h: levels = log.getLoggers()]
[h: log.setLevel("net.rptools.maptool.client.MapToolLineParser", "INFO")]
[h: log.setLevel("macro-logger", "TRACE")]
[h, if (argCount() > 0): macroName = arg(0); macroName = "breakpoint"]
[h, if (argCount() > 1): location = arg(1); location = "unknown"]
[h: log.trace(macroName + " @ " + location)]
[h, for(i, 2, argCount()): log.trace(i + ": " + if(json.type(arg(i)) == "UNKNOWN", arg(i), json.indent(arg(i))))]
[h: template ="i%{i}|<html><b><font size='3'><b color=blue>Argument %{i} %{name} ------------------------------------------------------------------------------------------------</b></font>" 
			  + "<pre>%s</pre><html>||LABEL|SPAN=TRUE"]
[h: inputText = json.append("[]", "ignore|<html><font size='6' color=blue><b>" + macroname + "</b> at " + location + "</font></html>||LABEL|SPAN=TRUE")]
[h, for(i, 2, argCount()), code: {
	[h: parm = arg(i)]
	[h, if (json.type(parm) == "UNKNOWN"), code: {

		<!-- Can we treat the passed string as a varuabke? -->
		[h: parm = string(parm)]
		[h: name = if(endsWith(parm, "="), substring(parm, 0, length(parm) - 1), "")]
		[h: value = parm]
		[h, if(endsWith(parm, "=")): value = eval(name)]
	};{
		<!-- it is JSON, need to actually do the indent in the strformat call below -->
		<!-- Why? What do you mean why? You just have to fucking do it that way -->
		[h: name = ""]
		[h: value = parm]
	}]
	[h: inputText = json.append(inputText, strformat(template, if(json.type(value) == "UNKNOWN", value, json.indent(value))))]
}]
[h: abort(input(json.toList(inputText, "##")))]
[h: level = json.path.read(levels, '.[?(@.name == "macro-logger")].level')]
[h: log.setLevel("macro-logger", json.get(level, 0))]
[h: level = json.path.read(levels, '.[?(@.name == "net.rptools.maptool.client.MapToolLineParser")].level')]
[h: log.setLevel("net.rptools.maptool.client.MapToolLineParser", json.get(level, 0))]