[h: monsterDb = o5e_ExtDB_getDB()]
[h: processorLink = macroLinkText ("o5e_ExtDB_JSON_processor@this", 
			"all", "", currentToken())]

[r, if (isFunctionDefined ("jse.mainDialog.editJSON")), code: {
	[h: params = json.set ("", "object", monsterDb, "macroLinkText", processorLink)]
	[h: jse.mainDialog.editJSON (params)]
}; {
	[dialog5 ("Monster Ext DB JSON", 	"title=Monster Ext DB JSON; input=1; width=800; height=800; closebutton=1"): {
	<html>
    	<head>
	      <link rel="stylesheet" type="text/css" href="o5e_ExtDB_CSS@Lib:Log4MT"></link>
    	</head>
		<body>
    		<label for="monsterDb_field">Current Loggers:</label>
			<form action="[r: processorLink]" method="json">
    			<textarea id="monsterDb_field" name="object" rows="40" cols="120">[r: json.indent (monsterDb)]</textarea>
	    		<input name="action" class="button" value="save" title="Save Database" type="submit" />
			</form>
		</body>
	</html>
	}]
}]