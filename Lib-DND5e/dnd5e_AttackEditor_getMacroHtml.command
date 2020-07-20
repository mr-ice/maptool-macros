<!-- see if we have a button color preference, and if not, set it to the 
     old-man-friendly white on red. -->
[h: macroFontColor = dnd5e_Preferences_getPreference ("attackEditor_macroFontColor")]
[h, if (!macroFontColor): macroFontColor = "white"; ""]
[h: macroButtonColor = dnd5e_Preferences_getPreference ("attackEditor_macroButtonColor")]
[h, if (!macroButtonColor): macroButtonColor = "red"; ""]


<div class="roll-container">
  <label><input class="big-checkbox" name="saveAttack" type="checkbox" />Create New Macro of Selected Attack</label>
</div>
<div>
  <label>Macro Font Color<select name="attackEditorMacroFontColor" id="attackEditorMacroFontColor">
  <option value="aqua" [r,if (macroFontColor == "aqua"): "selected";""] >Aqua</option>
  <option value="black" [r, if (macroFontColor == "black"): "selected";""]>Black</option>
  <option value="blue" [r, if (macroFontColor == "blue"): "selected";""]>Blue</option>
  <option value="cyan" [r, if (macroFontColor == "cyan"): "selected";""]>Cyan</option>
  <option value="darkgray" [r, if (macroFontColor == "darkgray"): "selected";""]>Dark Gray</option>
  <option value="fuchsia" [r, if (macroFontColor == "fuchsia"): "selected";""]>Fuchsia</option>
  <option value="gray" [r, if (macroFontColor == "gray"): "selected";""]>Gray</option>
  <option value="gray25" [r, if (macroFontColor == "gray25"): "selected";""]>25% Gray</option>
  <option value="gray50" [r, if (macroFontColor == "gray50"): "selected";""]>50% Gray</option>
  <option value="gray75" [r, if (macroFontColor == "gray75"): "selected";""]>75% Gray</option>
  <option value="green" [r, if (macroFontColor == "green"): "selected";""]>Green</option>
  <option value="lightgray" [r, if (macroFontColor == "lightgray"): "selected";""]>Light Gray</option>
  <option value="lime" [r, if (macroFontColor == "lime"): "selected";""]>Lime</option>
  <option value="magenta" [r, if (macroFontColor == "magenta"): "selected";""]>Magenta</option>
  <option value="maroon" [r, if (macroFontColor == "maroon"): "selected";""]>Maroon</option>
  <option value="navy" [r, if (macroFontColor == "navy"): "selected";""]>Navy</option>
  <option value="olive" [r, if (macroFontColor == "olive"): "selected";""]>Olive</option>
  <option value="orange" [r, if (macroFontColor == "orange"): "selected";""]>Orange</option>
  <option value="pink" [r, if (macroFontColor == "pink"): "selected";""]>Pink</option>
  <option value="purple" [r, if (macroFontColor == "purple"): "selected";""]>Purple</option>
  <option value="red" [r, if (macroFontColor == "red"): "selected";""]>Red</option>
  <option value="silver" [r, if (macroFontColor == "silver"): "selected";""]>Silver</option>
  <option value="teal" [r, if (macroFontColor == "teal"): "selected";""]>Teal</option>
  <option value="white" [r, if (macroFontColor == "white"): "selected";""]>White</option>
  <option value="yellow" [r, if (macroFontColor == "yellow"): "selected";""]>Yellow</option>


</select></label>
  <label>Macro Button Color<select name="attackEditorMacroButtonColor" id="attackEditorMacroButtonColor">
  <option value="aqua" [r,if (macroButtonColor == "aqua"): "selected";""]>Aqua</option>
  <option value="black" [r, if (macroButtonColor == "black"): "selected";""]>Black</option>
  <option value="blue" [r, if (macroButtonColor == "blue"): "selected";""]>Blue</option>
  <option value="cyan" [r, if (macroButtonColor == "cyan"): "selected";""]>Cyan</option>
  <option value="darkgray" [r, if (macroButtonColor == "darkgray"): "selected";""]>Dark Gray</option>
  <option value="fuchsia" [r, if (macroButtonColor == "fuchsia"): "selected";""]>Fuchsia</option>
  <option value="gray" [r, if (macroButtonColor == "gray"): "selected";""]>Gray</option>
  <option value="gray25" [r, if (macroButtonColor == "gray25"): "selected";""]>25% Gray</option>
  <option value="gray50" [r, if (macroButtonColor == "gray50"): "selected";""]>50% Gray</option>
  <option value="gray75" [r, if (macroButtonColor == "gray75"): "selected";""]>75% Gray</option>
  <option value="green" [r, if (macroButtonColor == "green"): "selected";""]>Green</option>
  <option value="lightgray" [r, if (macroButtonColor == "lightgray"): "selected";""]>Light Gray</option>
  <option value="lime" [r, if (macroButtonColor == "lime"): "selected";""]>Lime</option>
  <option value="magenta" [r, if (macroButtonColor == "magenta"): "selected";""]>Magenta</option>
  <option value="maroon" [r, if (macroButtonColor == "maroon"): "selected";""]>Maroon</option>
  <option value="navy" [r, if (macroButtonColor == "navy"): "selected";""]>Navy</option>
  <option value="olive" [r, if (macroButtonColor == "olive"): "selected";""]>Olive</option>
  <option value="orange" [r, if (macroButtonColor == "orange"): "selected";""]>Orange</option>
  <option value="pink" [r, if (macroButtonColor == "pink"): "selected";""]>Pink</option>
  <option value="purple" [r, if (macroButtonColor == "purple"): "selected";""]>Purple</option>
  <option value="red" [r, if (macroButtonColor == "red"): "selected";""]>Red</option>
  <option value="silver" [r, if (macroButtonColor == "silver"): "selected";""]>Silver</option>
  <option value="teal" [r, if (macroButtonColor == "teal"): "selected";""]>Teal</option>
  <option value="white" [r, if (macroButtonColor == "white"): "selected";""]>White</option>
  <option value="yellow" [r, if (macroButtonColor == "yellow"): "selected";""]>Yellow</option>

</select></label>
</div>