[h: l4m.enableLineParser("root")]
[h: selectedLibToken = arg (0)]
[h: l4m.Constants()]
[h: configuration = l4m.convertConfigToStrProp (l4m.getWrapperConfig (selectedLibToken))]

[h: processorLink = macroLinkText ("l4m.bulkConfigureWrappersProcessor@this", 
			"all", "", currentToken())]
[dialog5 ("Wrapper Configuration", "title=Wrapper Configuration; input=1; width=783; height=535; closebutton=1"): {
<html>
    <head>
      <link rel="stylesheet" type="text/css" href="l4m_CSS@Lib:Log4MT"></link>
    </head>
	<body>
    	<label for="mtWrappers">Current Wrappers:</label>
		<form action="[r: processorLink]" method="json">
		    <input name="mtLibToken" value="[r: selectedLibToken]" hidden="true"/>
    		<textarea id="mtWrappers" name="mtWrappers" rows="20" cols="80">[r: json.indent (configuration)]</textarea>
    		<input name="actionButton" class="button" value="Save Configuration" type="submit" />
		</form>
	</body>
</html>
}]
[h: helpText = '
		UDF configuration is a JSON entry the form of:<br>
		<pre>&quot;udf_name&quot; : &quot;ignoreOutput=[0|1] ; newScope=[0|1]&quot;</pre><br>
		The configuration provided here is merged with a default configuration of<br><pre>' + 
		DEFAULT_UDF_CONFIG + '</pre> Any defined UDFs that are not configured via this interface will have the default<br>
		configuration applied to them.<br><br>
		Bulk configured wrappers are not automatically enabled. Please use <pre>' + 
		MACRO_OVERWRITE_UDF_NAME + '@' + selectedLibToken + '</pre> to enable wrappers.
']
[h: displayedHelp = getLibProperty (PROPERTY_DISPLAYED_WRAPPER_CONFIG_HELP, LIB_LOG4MT)]
[h, if (displayedHelp == "" || !isNumber (displayedHelp)): displayedHelp = 0]
[h: setLibProperty (PROPERTY_DISPLAYED_WRAPPER_CONFIG_HELP, 1, LIB_LOG4MT)]
[if (!displayedHelp), code: {
	[dialog5 ("Wrapper Configuration Help", "title=Wrapper Configuration Help; input=0; width=783; height=362; closebutton=1"): {
<html>
    <head>
      <link rel="stylesheet" type="text/css" href="l4m_CSS@Lib:Log4MT"></link>
    </head>
	<body>
		[r: helpText]
	</body>
</html>
	}]
}]
