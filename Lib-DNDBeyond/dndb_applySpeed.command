[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=fals"))]
	[h: return (0, error)]
}]

[h: speeds = json.get (basicToon, "speeds")]
<!-- blank them out first -->
[h, foreach (speed, "['Walk', 'Swim', 'Fly', 'Climb', 'Burrow']"): setProperty (speed, "")]

[h: noMove = getState ("Paralyzed") + getState ("Grappled") + getState ("Petrified") + getState ("Restrained") + getState ("Stunned") + getState ("Unconscious") + getState ("Exhaustion 5") + getState ("Exhaustion 6")]
[h: onlyCrawl = getState ("Prone")]
[h: halfSpeed = getState ("Exhaustion 3")]
<!-- someday we might want to distinguish between crawl and no speed, but for now they -->
<!-- end up working the same -->
[h, foreach (speed, speeds), code: {
	[h: speedName = json.get (speed, "name")]
	[h: speedValue = round (json.get (speed, "speed"))]
	[h, if (halfSpeed > 0): speedValue = round (math.floor (speedValue / 2))]
	[h, if (noMove + onlyCrawl > 0): speedValue = 0]
	[h: setProperty (speedName, speedValue)]
}]