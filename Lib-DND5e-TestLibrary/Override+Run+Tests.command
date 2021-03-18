<!-- Set this to 0 to disable override -->
[h: DO_OVERRIDE = 0]

[h: macros = json.append ("", "dnd5et_Test_Conditions")]
[h: macro.return = json.set ("", "doOverride", DO_OVERRIDE, "macros", macros)]