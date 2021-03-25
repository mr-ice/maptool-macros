[h: title = arg(0)]
[h: rolls = arg(1)]
[h: log.error(getMacroName() + " title=" + title + " roll=" + json.indent(rolls))]
[h: title.text = dnd5e_Util_encodeHtml(json.get(title, "title"))]
[h: out = json.append("[]", "</br><div>")]

<!-- Start tooltip -->
[h, if (json.contains(title, "tooltip")), code: {
	[h: title.tooltip = json.get(title, "tooltip")]
	[h: out = json.append(out, strformat("<span title='%s'>", dnd5e_Util_encodeHtml(title.tooltip)))]
}]

<!-- Output Title end tooltip -->
[h: out = json.append(out, strformat("<font size='5'><b color=black>%{title.text}</b></font>"))]
[h, if (json.contains(title, "tooltip")): out = json.append(out, "</span>")]

<!-- Check for Apply -->
[h, if (json.contains(title, "apply")), code: {
	[h: title.cmd = json.get(title, "apply")]
	[h, if (json.contains(title, "applyArgs")): title.args = json.get(title, "applyArgs"); title.args = ""]
	[h: out = json.append(out, " " + macroLink("Apply", title.cmd, "none", title.args, "selected"))]
}]

<!-- Process the rolls -->
[h, if (!json.isEmpty(rolls)), code: {
	[h, if (json.type(rolls) != "ARRAY"): rolls = json.append("[]", rolls)]
	[h, foreach(roll, rolls, ""), code: {

		<!-- Div indent and tooltip start if needed -->
		[h: out = json.append(out, "  <div style='margin-left:15px;'>")]
        [h, if (json.contains(roll, "tooltip")): out = json.append(out, strformat("    <span title='%s'>", dnd5e_Util_encodeHtml(json.get(roll, "tooltip"))))]

		<!-- Roll or link if needed -->
		[h: total = json.get(roll, "total")]
		[h, if (json.contains(roll, "linkArgs")): linkArgs = json.get(roll, "linkArgs"); linkArgs = ""]
		[h, if (json.contains(roll, "link")): total = macroLink(total, json.get(roll, "link"), "none", linkArgs, "selected")]
		[h: out = json.append(out, strformat(" <b color=black><font size='4'>%{total}</font></b>"))]
		[h: out = json.append(out, " " + json.get(roll, "text"))]

		<!-- End Div indent and tooltip if needed -->
        [h, if (json.contains(roll, "tooltip")): out = json.append(out, "    </span>")]
		[h: out = json.append(out, "  </div>")]
	}]
}]

<!-- End -->
[h: out = json.append(out, "</div>")]
[h: log.debug(getMacroName() + " out=" + json.indent(out))]
[h: log.debug(getMacroName() + " as HTML=" + json.toList(out, ""))]
[h: macro.return = json.toList(out, "")]