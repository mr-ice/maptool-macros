<!-- Constants -->

[h: INPUT_JSON = "multiWeaponAttackInputJson"]
[h: ATK_BONUS = "atkBonus"]
[h: DMG_BONUS = "dmgBonus"]
[h: DMG_DIE = "dmgDie"]
[h: DMG_DICE = "dmgDice"]
[h: CRIT_BONUS_DICE = "critBonusDice"]
[h: NAME = "name"]
[h: DMG_TYPE = "dmgType"]
[h: RAGE_BONUS = "rageBonus"]
[h: IS_RAGING = "isRaging"]
[h: ADV_DISADV = "advDisad"]
[h: DMG_BONUS_EXPR = "dmgBonusExpr"]
[h: WEAPON_LIST = "multiWeaponAttackWeaponList"]
[h: NEW_WEAPON = "NewWeapon"]

<!-- need the weapon list, it's a separate property -->
[h, if (!isPropertyEmpty(WEAPON_LIST)): weaponListStr = getProperty(WEAPON_LIST); weaponListStr = NEW_WEAPON]
[r: "weaponListStr: " + weaponListStr + "<br>"]

<!-- Default Input String -->
[h: defInputString = "tabWeaponChoice | Weapon Selection | true | TAB"]
[h: defInputString = defInputString + "## selectedWeapon | " + NEW_WEAPON + " | Select weapon | LIST | value=string"] 
[h: defInputString = defInputString + "## tab" + NEW_WEAPON + " | " + NEW_WEAPON + " | | TAB"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + NAME + " | "+ NEW_WEAPON + " | Weapon Name | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + ATK_BONUS + " | 0 | Attack Bonus | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + DMG_BONUS + " | 0 | Damage Bonus | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + DMG_DIE + " | 0 | Damge Die | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + DMG_DICE + " | 0 | Damge Dice | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + CRIT_BONUS_DICE + " | 0 | Bonus Critical Dice (extras only) | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + DMG_TYPE + " | Slashing/Piercing/Bludgeoning | Damage Type | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + DMG_BONUS_EXPR + " |  | Bonus Damage Roll Expression | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + RAGE_BONUS + " | 0 | Rage Bonus | text"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + IS_RAGING + " | Raging | check"]
[h: defInputString = defInputString + "## " + NEW_WEAPON + "." + ADV_DISADV + " | None,Advantage,Disadvantage | Advantage/Disadvantage | list | value=string"]

<!-- Get the input string from the token -->
[h, if (isPropertyEmpty(INPUT_JSON)): inputString = defInputString; inputString = getProperty(INPUT_JSON)]

<!-- Prompt the user -->
[h: abort(input(inputString))]

<!-- The user has selected a weapon to attack with and may have input new values for that weapon, or even defined a new weapon -->
<!-- If the user selected the new weapon, take all the values for the New Weapon and create a new input string for that weapon -->
<!-- Easiest way to determine if a new weapon was selected, see if the new wepon name var has a different name -->
<!-- Instead of trying to dereference the variable name for a variable name, Just gonna use the literal, because effort -->
[h, if (NewWeapon.name != NEW_WEAPON), code:
{
    <!-- Add the new weapon to the existing list -->
	[h: weaponListStr = weaponListStr + "," + NewWeapon.name]

    <!-- Transfer the new weapon stats to the other weapon's stats -->
    [h: attributeList = json.fromList("%{selectedWeapon}." + NAME)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + ATK_BONUS)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + DMG_BONUS)] 
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + DMG_DIE)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + DMG_DICE)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + CRIT_BONUS_DICE)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + DMG_TYPE)] 
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + DMG_BONUS_EXPR)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + RAGE_BONUS)]
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + IS_RAGING)] 
    [h: attributeList = json.append(attributeList, "%{selectedWeapon}." + ADV_DISADV)] 

    <!-- Iterate through the attribute list and use the template to dereference the New Weapon attribute and the newly created weapon -->
    [h, foreach (templateString, attributeList), code: {
        [h: selectedWeapon = NEW_WEAPON]
        [h: newWeaponVar = strformat(templateString)]
        [h: selectedWeapn = NewWeapon.name]
        [h: createdWeaponVar = strformat(templateString)]
        [h: expressionString = createdWeaponVar + "=" + newWeaponVar]
        [r: expressionString + "<br>"]
        [h: eval(expressionString)]
    };]
};{
	<!-- you didn't create a new weapon -->
};]

<!-- Rebuild the wepon JSON string and stuff it onto the token -->
[h: template = "tabWeaponChoice | Weapon Selection | true | TAB"]
[h: template = template + "## selectedWeapon | %{selectedWeapon} | Select weapon | LIST | value=string"] 
[h: template = template + "## tab%{selectedWeapon} | %{selectedWeapon} | | TAB"]
[h: template = template + "## %{selectedWeapon}." + NAME + " | %{selectedWeapon} | Weapon Name | text"]
[h: template = template + "## %{selectedWeapon}." + ATK_BONUS + " | 0 | Attack Bonus | text"]
[h: template = template + "## %{selectedWeapon}." + DMG_BONUS + " | 0 | Damage Bonus | text"]
[h: template = template + "## %{selectedWeapon}." + DMG_DIE + " | 0 | Damge Die | text"]
[h: template = template + "## %{selectedWeapon}." + DMG_DICE + " | 0 | Damge Dice | text"]
[h: template = template + "## %{selectedWeapon}." + CRIT_BONUS_DICE + " | 0 | Bonus Critical Dice (extras only) | text"]
[h: template = template + "## %{selectedWeapon}." + DMG_TYPE + " | Slashing/Piercing/Bludgeoning | Damage Type | text"]
[h: template = template + "## %{selectedWeapon}." + DMG_BONUS_EXPR + " |  | Bonus Damage Roll Expression | text"]
[h: template = template + "## %{selectedWeapon}." + RAGE_BONUS + " | 0 | Rage Bonus | text"]
[h: template = template + "## %{selectedWeapon}." + IS_RAGING + " | Raging | check"]
[h: template = template + "## %{selectedWeapon}." + ADV_DISADV + " | None,Advantage,Disadvantage | Advantage/Disadvantage | list | value=string"]


[r: "weaponListStr: " + weaponListStr + "<br>"]
<!-- If the user selected an exsting weapon, use that weapon's attacks stuff -->

[h: weaponList = json.append("", weaponListStr)]
[h: newInputStr = ""]
[h, foreach(selectedWeapon, weaponList): newInputStr = newInputStr + strformat(newInputStr) + "##")]
<!-- Trim the trailing '##' -->
[h: newInputStr = substring(newInputStr, 0, length(newInputStr) - 2)]
[r: newInputStr]





<!-- Build a new input string and store it -->


