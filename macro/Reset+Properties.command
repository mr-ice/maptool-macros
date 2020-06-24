[h: basicToon = dndb_getBasicToon ()]

[h, if (json.length (macro.args) > 0): noConfirm = arg(0); noConfirm = 0]
[h: confirm = 1]
[h, if (!noConfirm): input ("ignored | WARNING! This will reset any custom values. | All properties will be overwritten! | Label | SPAN=TRUE",
	"confirm | No, Yes | Are you sure you want to do this? | LIST | SELECT=0");""]
[h: abort (confirm)]

<!-- do this first! -->
[h: dndb_applyConditions (basicToon)]

[h: setProperty ("Age", json.get (basicToon, "age"))]
[h: setProperty ("Faith", json.get (basicToon, "faith"))]
[h: setProperty ("Hair", json.get (basicToon, "hair"))]
[h: setProperty ("Eyes", json.get (basicToon, "eyes"))]
[h: setProperty ("Skin", json.get (basicToon, "skin"))]
[h: setProperty ("Height", json.get (basicToon, "height"))]
[h: setProperty ("Weight", json.get (basicToon, "weight"))]
[h: setProperty ("XP", json.get (basicToon, "xp"))]
[h: setProperty ("Gender", json.get (basicToon, "gender"))]
[h: setProperty ("Alignment", json.get (basicToon, "alignment"))]
[h: setProperty ("AvatarUrl", json.get (basicToon, "avatarUrl"))]
[h: setProperty ("Initiative", json.get (basicToon, "init"))]

[h: abilities = json.get (basicToon, "abilities")]
[h: setProperty ("Strength", json.get (abilities, "str"))]
[h: setProperty ("Strength Bonus", json.get (abilities, "strBonus"))]
[h: setProperty ("Dexterity", json.get (abilities, "dex"))]
[h: setProperty ("Dexterity Bonus", json.get (abilities, "dexBonus"))]
[h: setProperty ("Constitution", json.get (abilities, "con"))]
[h: setProperty ("Constitution Bonus", json.get (abilities, "conBonus"))]
[h: setProperty ("Intelligence", json.get (abilities, "int"))]
[h: setProperty ("Intelligence Bonus", json.get (abilities, "intBonus"))]
[h: setProperty ("Wisdom", json.get (abilities, "wis"))]
[h: setProperty ("Wisdom Bonus", json.get (abilities, "wisBonus"))]
[h: setProperty ("Charisma", json.get (abilities, "cha"))]
[h: setProperty ("Charisma Bonus", json.get (abilities, "chaBonus"))]

<!-- Senses -->
[h: dndb_applyVision (basicToon)]

<!-- Health -->
[h: dndb_applyHealth ()]

[h: armorClass = json.get (basicToon, "armorClass")]
[h: setProperty ("AC", json.get (armorClass, "total"))]
[h: setProperty ("AC Dexterity", json.get (armorClass, "Dexterity"))]
[h: setProperty ("AC Armor", json.get (armorClass, "Armor"))]
[h: setProperty ("AC Shield", json.get (armorClass, "Shield"))]

<!-- Speeds -->
[h: dndb_applySpeed ()]

[h: saves = json.get (basicToon, "savingThrows")]
[h, foreach (save, saves), code: {
	[h: saveName = json.get (save, "name") + " Save"]
	[h: saveBonus = json.get (save, "totalBonus")]
	[h: setProperty (saveName, saveBonus)]
}]

[h: skills = json.get (basicToon, "skills")]
[h, foreach (skill, skills): setProperty (json.get (skill, "name"), json.get (skill, "totalBonus"))]



[h: dndb_mergeAttackJson ()]
[h: dndb_createPlayerMacros()]
