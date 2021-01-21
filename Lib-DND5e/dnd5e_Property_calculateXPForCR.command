[h: challengeRating = getProperty ("CR")]
[h, if (challengeRating == ""): challengeRating = 0; ""]
<!-- I need to test if its outside of bounds, but its dicey -->
<!-- when the value can be a string or a number -->
[h, if (isNumber(challengeRating)), code: {
	[if (challengeRating > 30): challengeRating = 30; ""]
	[if (challengeRating < 0): challengeRating = 0; ""]
}]
[h: crXpMap = json.set ("", 0, 0,
		"1/8", 25,
		"1/4", 50,
		"1/2", 100,
		1, 200,
		2, 450,
		3, 700,
		4, 1100,
		5, 1800,
		6, 2300,
		7, 2900,
		8, 3900,
		9, 5000,
	   10, 5900,
	   11, 7200,
	   12, 8400,
	   13, 10000,
	   14, 11500,
	   15, 13000,
	   16, 15000,
	   17, 18000,
	   18, 20000,
	   19, 22000,
	   20, 25000,
	   21, 33000,
	   22, 41000,
	   23, 50000,
	   24, 62000,
	   25, 75000,
	   26, 90000,
	   27, 105000,
	   28, 120000,
	   29, 135000,
	   30, 155000)
]
[h: macro.return = json.get (crXpMap, challengeRating)]