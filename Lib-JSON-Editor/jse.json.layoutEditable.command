[h: json = arg(0)]
[h: params = arg(1)]
[h, if( argCount() > 2 ): encodedPath = arg(2) ; encodedPath = "" ]
[h, if( argCount() > 3 ): fullJson = arg(3); fullJson = json]
[h, if (argCount() > 4 ): evenOdd = arg(4); evenOdd = 0]

[h, if (evenOdd): rowStyle = "evenRow"; rowStyle = "oddRow"]

[h: log.debug (getMacroName() + ": encodedPath = " + encodedPath)]

[h: fields = json.fields( json )]

[h: '<!-- Use the variable "json" to access the sub-object.
	Use the variable "path" to access the location of the sub-object. -->']

[h, if (json.type (json) == "ARRAY"), code: {
	[apos = ""]
	[objIsArray = 1]
}; {
	[apos = "'"]
	[objIsArray = 0]
}]

[ foreach( field, fields, "" ), code: {
	[h: piece = json.get( json, field )]
	[h, if (json.type (piece) == "ARRAY"): isArrayKey = 1; isArrayKey = 0]
	
	[h: pathPiece = encodedPath + encode ("[" + apos + field + apos + "]")]
		[h: linkArg = json.set ("", "field", field, "json", fullJson,
					"encodedPath", encodedPath, "objIsArray", objIsArray,
					"keyIsArray", isArrayKey, "params", params)]	
	[h: log.debug (getMacroName() + ": pathPiece = " + pathPiece)]

	<tr class=[r: rowStyle]>
	[ if( json.type( piece ) == "UNKNOWN" ), code: {
		<td><b>[r: field]</b></td>
		<td>[r: macroLink( piece, "jse.json.dispatcher@this", "self", 
				json.set (linkArg, "operation", "replace"))]
		[r, if( objIsArray ): "&nbsp;" ]
		[r, if( objIsArray ): macroLink( "<small>^</small>", "jse.json.dispatcher@this", "self", 
				json.set (linkArg, "operation", "reOrderUp"))]
		[r, if( objIsArray ): macroLink( "<small>v</small>", "jse.json.dispatcher@this", "self",
				json.set (linkArg, "operation", "reOrderDown"))]
	}; {
		<td><b>[r: field]</b></td>
		<td>[r: macroLink( "delete", "jse.json.dispatcher@this", "self",
				json.set (linkArg, "operation", "remove"))]</td>
	</tr>
	<tr class=[r: rowStyle]>
		<td colspan='2'>
		            <table><tr>
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td><table>
				[r: jse.json.layoutEditable( piece, params, pathPiece, fullJson, !evenOdd)]
			</table></td>
		            </tr>
		            <tr>
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td>[r: macroLink( "add to " + field + "", "jse.json.dispatcher@this",
				"self", json.set (linkArg, "operation", "append"))]</td>
		            </tr></table>
		</td>
	}]
	</tr>
}]
