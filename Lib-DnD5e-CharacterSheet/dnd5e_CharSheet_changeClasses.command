[h: validInput =  0]
[h, while (!validInput), code: {
	[abort(input ("classes | " + classes + " | Classes | TEXT"))]
	[validInput = dnd5e_CharSheet_Util_calculateProficiency ()]
	[if (!validInput): input ("junk | " + classes + " is an invalid selection | | LABEL | span=true")]
}]
[h: dnd5e_CharSheet_refreshPanel ()]