<!-- Constants for a little initial help -->
[h,CODE:
{
    [BLESSED_DIE = 4]
    [critstrbegin = "<font color='red'><b>CRITICAL! "]
    [critstrend = "</b></font>"]
    [blessstrbegin = "<font color='green'> + Blessed "]
    [blessstrend = "</font>"]
    [missstrbegin = "<b><font color='red'><i>NAT "]
    [missstrend = "</i></font>"]
}]

<!-- Prompt user -->
[h: abort(input("saveName|Str,Con,Dex,Int,Wis,Cha,Death|Save|list|value=string"))]

[h,if(saveName == "Str"),CODE:
{
    [propertyName="strength"]
    [attributeName="Strength"]
};
{
    ["Not Str"]
}]
[h,if(saveName == "Dex"),CODE:
{
    [propertyName="dexterity"]
    [attributeName="Dexterity"]
};
{
    ["Not Dex"]
}]
[h,if(saveName == "Con"),CODE:
{
    [propertyName="constitution"]
    [attributeName="Constitution"]
};
{
    ["Not Con"]
}]
[h,if(saveName == "Int"),CODE:
{
    [propertyName="intelligence"]
    [attributeName="Intelligence"]
};
{
    ["Not Int"]
}]
[h,if(saveName == "Wis"),CODE:
{
    [propertyName="wisdom"]
    [attributeName="Wisdom"]
};
{
    ["Not Wis"]
}]
[h,if(saveName == "Cha"),CODE:
{
    [propertyName="charisma"]
    [attributeName="Charisma"]
};
{
    ["Not Cha"]
}]
[h,if(saveName == "Death"),CODE:
{
	[propertyName="death"]
	[attributeName="<font color='red'><b>Death</b></font>"]
};
{
	["Not Death"]
}]
<!-- fetch values from properties -->
[h,CODE:
{
    [saveBonusName = "save" + attributeName]
    [if (isPropertyEmpty(propertyName)): attrBonus = 0; attrBonus = getProperty(propertyName)]
    [if (isPropertyEmpty(saveBonusName)): saveBonus = attrBonus; saveBonus = getProperty(propertyName)]
    [if (isPropertyEmpty("isBlessed")): isBlessed = 0; isBlessed = getProperty("isBlessed")]
    [if (isPropertyEmpty("blessDie")): blessDie=BLESSED_DIE; blessDie = getProperty("blessDie")]

}]

<!-- Prompt user -->
[h: abort(input(
    "attrBonus|" + attrBonus + "|+ for " + attributeName + " attribute|text",
    "saveBonus|" + saveBonus + "|+ for " + attributeName + " saves|text",
    "blessDie|" + blessDie + "|Bless Bonus Die|text",
    "isBlessed|" + isBlessed + "|Blessed|check",
    "advantageDisadvantage|None,Advantage,Disadvantage|Advantage/Disadvantage|list|value=string"))]

<!-- Preserve the interesting choices so they default for the next prompt -->
[h,CODE:
{
    [setProperty(propertyName, attrBonus)]
    [setProperty(saveBonusName, saveBonus)]
    [setProperty("isBlessed", isBlessed)]
    [setProperty("blessDie", blessDie)]
}]

<!-- roll d20 twice, figure out if we're advantaged later -->
[h,CODE:
{
    [roll1 = 1d20]
    [roll2 = 1d20]
    [blessRoll = roll(1,blessDie)]
}]
[h,if(isBlessed),CODE:
{
	[saveBonusStr = saveBonus + blessstrbegin + blessRoll + blessstrend ]
	[saveBonusActual = saveBonus + blessRoll ]
};
{
	[saveBonusStr = abs(saveBonus)]
	[saveBonusActual = saveBonus]
}]
[h,if(saveBonus < 0): plus = "-" ; plus = "+"]

<b>[r:attributeName] save:</b> 1d20 [r:plus] [r:saveBonusStr] = [r:roll1] [r:plus] [r:saveBonusStr] = 
[if(advantageDisadvantage != "None"),CODE:
{
	[r:roll1+saveBonus]<br><b>[r:advantageDisadvantage]</b> 1d20 [r:plus] [r:saveBonusStr] = [r:roll2] [r:plus] [r:abs(saveBonus)] = [r:roll2+saveBonus]<br>Total <b>
	[h,if(advantageDisadvantage == "Advantage"),CODE:
	{
		[roll = max(roll1,roll2)]
	};
	{
		[roll = min(roll1,roll2)]
	}]
	[if(roll == 20),CODE:
	{
		[r:critstrbegin]
		[r:roll + saveBonusActual]
		[r:critstrend]
	};
	{
		[r:roll + saveBonusActual]
	}]
	</b>
};{
	<b>[r:roll1+saveBonusActual]</b>
}]