[h: inputStr = ""]
[h: speedList = json.append ("", "Walk", "Swim", "Burrow", "Climb", "Fly")]
[h, foreach (speedItem, speedList), code: {
	[speedInput = speedItem + " | " + getProperty (speedItem) + " | " + speedItem + " ft. | TEXT"]
	[inputStr = listAppend (inputStr, speedInput, "##")]
}]
[h: macro.return = inputStr]