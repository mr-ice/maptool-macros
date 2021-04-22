[h: macroName = arg(0)]
[h: dnd5e_Constants (macroName)]
[h: LIB_TOKEN = "Lib:DnD5e-CharacterSheet"]
[h: CATEGORY = LIB_TOKEN + "." + macroName]
[h: PANEL_CHARACTER_SHEET_NAME = "%{token.name} - Character Sheet"]
[h: ATTR_CHAR_SHEET_PANEL_WIDTH = 845]
[h: ATTR_CHAR_SHEET_PANEL_HEIGHT = 760]
[h: ATTR_CHAR_SHEET_FONT_SIZE = "16px"]
[h: PROP_BACKGROUND = "dnd5e.token.background"]
[h: PROP_SUBCLASS = "dnd5e.token.subclass"]
[h: PROP_ALIGNMENT = "dnd5e.token.alignment"]
[h: PROP_EXPERIENCE_POINTS = "dnd5e.token.experiencePoints"]
[h: PROP_INSPIRATION = "dnd5e.token.inspiration"]
[h: PROP_ARMOR_PROF = "dnd5e.token.armorProficiencies"]
[h: PROP_WEAPON_PROF = "dnd5e.token.weaponProficiencies"]
[h: PROP_TOOL_PROF = "dnd5e.token.toolProficiencies"]
[h: PROP_EQUIPMENT = "dnd5e.token.equipment"]
[h: PROP_CURRENCY = "dnd5e.token.currency"]
[h: PROP_TRAITS = "dnd5e.token.traits"]
[h: PROP_IDEALS = "dnd5e.token.ideals"]
[h: PROP_BONDS = "dnd5e.token.bonds"]
[h: PROP_FLAWS = "dnd5e.token.flaws"]
[h: PROP_BUFFS = "dnd5e.token.buffs"]
[h: PROP_REACTION = "dnd5e.token.reaction"]
[h: PROP_CONCENTRATING = "dnd5e.token.concentrating"]
[h: PROP_COUNTERS = "dnd5e.token.counters"]
[h: PROP_RESOURCES = "dnd5e.token.resources"]
[h: PROP_CLASS_OBJ = "dnd5e.token.classObj"]
[h: ARRY_ABILITIES_NAMES = 
	"['Strength','Dexterity','Constitution','Intelligence','Wisdom','Charisma']"]
[h: ARRY_PROF_NAMES	= 
	"['None', 'Half Proficient', 'Proficient', 'Expert']")]
[h: ARRY_PROF_VALUES =
	"[0, 0.5, 1, 2]"]
[h: ARRY_SKILLS_NAMES = 
	"['Acrobatics','Animal Handling','Arcana','Athletics','Deception'," + 
	"'History','Insight','Intimidation','Investigation','Medicine','Nature'," +
	"'Perception','Performance','Persuasion','Religion','Sleight of Hand'," +
	"'Stealth','Survival']"]
[h: ARRY_OTHER_PROPERTIES = "['" + PROP_ARMOR_PROF + "','" + PROP_WEAPON_PROF + "','" + 
	PROP_TOOL_PROF + "','Languages']"]
[h: ARRY_OTHER_PROP_NAMES = "['Armor', 'Weapons', 'Tools', 'Languages']"]
[h: ARRY_ARMOR_TYPES = "['Heavy', 'Medium', 'Light', 'Natural', 'None']"]