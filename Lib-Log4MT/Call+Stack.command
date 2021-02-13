<!-- Print or Clear the current call stack -->
[h: l4m.Constants()]
[h: callStack = getLibProperty (CALL_STACK, LIB_PROXY)]
[h: processorLink = macroLinkText ("l4m.clearCallStack@this")]

[dialog("Current Call Stack", "title=Call Stack; input=1; width=580; height=550; closebutton=0"): {
	<html><body>
		<form action="[r: processorLink]">
			<pre>[r: json.indent (callStack)]</pre>

			<input name="actionButton" class="button" value="Clear Call Stack" type="submit" />

		</form>
		</body>
	</html>
}]
