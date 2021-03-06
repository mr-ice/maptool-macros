[h: l4m.Constants()]
[h: processorLink = macroLinkText ("l4m.configureLoggerProcessor@this", 
			"all", "", currentToken())]
[dialog5 ("Logging Configuration", "title=Logging Configuration; input=1; width=600; height=540; closebutton=1"): {
<html>
    <head>
      <link rel="stylesheet" type="text/css" href="l4m_CSS@Lib:Log4MT"></link>
    </head>
	<body>
    	<label for="mtLoggers">Current Loggers:</label>
		<form action="[r: processorLink]" method="json">
    		<textarea id="mtLoggers" name="mtLoggers" rows="20" cols="60">[r: json.indent (l4m.getLoggers())]</textarea>
    		<a style="color:green" href="[r: macroLinkText ('l4m.helpConfigureLoggers@' + LIB_LOG4MT)]">Additional Information</a>
    		<input name="actionButton" class="button" value="Save Configuration" type="submit" />
		</form>
	</body>
</html>
}]