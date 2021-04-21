[h: FRAME_NAME = "Multiple Select"]
[h: areaSelected = macro.args]
[h, if (json.type(areaSelected) == "ARRAY"): areaSelected = json.get(macro.args, 0)]
[h: log.debug(getMacroName() + ": areaSelected" + areaSelected)] 
[h: refreshLink = macroLinkText("ms_tokenCollector@Lib:MultiSelect", "none")]
[frame5(FRAME_NAME, "title=Select a Token; input=1; width=250; height=360"): {
<html>
  <head>
    <link rel='onChangeSelection' type='macro' href='[r: refreshLink]'>
  </head>
  <body>
	<table style="border-spacing:1pt;border-width:0px;border-style:solid;padding:0px;">
	  [r, foreach(id, areaSelected, ""): ms_generateRow(id)]
	</table>
  </body>
</html>
}]