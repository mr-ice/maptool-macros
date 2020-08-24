
[h: processorLink = macroLinkText ("dnd5e_Preferences_setupCampaignPreferenceToken@Lib:DnD5e", "all")]
[dialog5 ("Setup Campaign Preferences Token", "title=Setup Campaign Preferences Token; input=1; width=380; height=250; closebutton=0"): {
<html>
    <head/>
    <body><form action="[r:processorLink]" method="json">
    <div>
    	Drag a brand new token to the map. Select it and then hit OK
    </div>
    <input name="action" class="button" value="OK" type="submit"/>
    <input name="action" class="button" value="Cancel" type="submit"/>
    </form></body>
</html>
}]