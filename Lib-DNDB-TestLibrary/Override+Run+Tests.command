<!-- Set this to 0 to disable override -->
[h: DO_OVERRIDE = 0]

[h: macros = json.append ("", "dndbt_Test_ApplyTokenProperties")]
[h: macro.return = json.set ("", "doOverride", DO_OVERRIDE, "macros", macros)]