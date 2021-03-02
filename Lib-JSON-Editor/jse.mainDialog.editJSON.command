[h: params = arg (0)]
[h: jsonVal = json.get (params, "object")]
[h: linkText = json.get (params, "macroLinkText")]
[h, if (json.type (jsonVal) == "ARRAY"): isArray = 1; isArray = 0]
[h: log.debug (getMacroName() + "; jsonVal = " + jsonVal)]

[ dialog5( "JSON Editor", "title=JSON Editor; input=1; closebutton=0" ): {
<html>
<head>
<title>JSON Editor</title>
<link rel='stylesheet' type='text/css' href='jse.CSS@Lib:JSON-Editor'>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">

</head>
<body>

<div class='container-fluid'>
<table class='oddRow'>
	[r: jse.json.layoutEditable( jsonVal, params )]
	<tr>[r: macroLink( "add to root", "jse.json.dispatcher@this", "none", 
			json.set ("", "json", jsonVal, "operation", "rootAdd", 
					"objIsArray", isArray, "keyIsArray", isArray,
					"params", params))]</tr>
</table>
</div>

<form action="[r: linkText]" method="json">
 <input hidden="true" name="object" value="[r: encode (jsonVal)]"/>
 <div class="btn-group offset-2 col-8">
      <button class="btn btn-primary" type="submit" name="action", value="save" title="Save">Save</button>      
      <button class="btn btn-secondary" hidden="true" type="submit" name="jsonEdit", value="jsonEdit" title="Free Form Editor">JSON Editor</button>
      <button class="btn btn-danger" type="submit" name="action", value="cancel" title="Cancel">Cancel</button>
</div>
</form>

</body>
</html>
}]