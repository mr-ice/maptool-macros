[h: bonus = getProperty ("Insight")]
[h, if (bonus == ""): return (0, "")]
[h,if (bonus > -1): value = "+"; value = ""]
Psv: [r: bonus + 10] ( [r: value + bonus])]