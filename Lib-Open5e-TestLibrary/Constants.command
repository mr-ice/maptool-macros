[h: LIB_TOKEN = "Lib:Open5e-TestLibrary"]
[h: CATEGORY = LIB_TOKEN + "." + arg(0)]
[h: STATIC_SLUGS = json.append ("[]", "elvish-veteran-archer", "deathsworn-elf",
	"ancient-mithral-dragon", "pact-lich",
	"stone-giant", "stryx", "adult-rime-worm", "fire-elemental", 
	"flame-scourged-scion", "ghoul-imperial", "roper")]
<!-- Cant call constants from another library, lames -->
[h: TEST_PROPERTIES = json.append ("[]", "_o5e_monsteractions", "o5e.monsterToon.version",
	"o5e.monsterToon.json", "o5e.monsterToon.spellCasting", "o5e.monsterToon.slug")]