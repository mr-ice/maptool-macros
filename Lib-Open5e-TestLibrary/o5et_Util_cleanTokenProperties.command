[h: tokenId = arg(0)]
[h: o5et_Constants(getMacroName())]
[h, foreach (testProperty, TEST_PROPERTIES), code: {
	[setProperty (testProperty, "", tokenID)]
}]
