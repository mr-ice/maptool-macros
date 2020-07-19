[h: text = arg (0)]
[h: wrapLength = 30]
[h, if (wrapLength < 1), code: {
	[return (0, text)]
}; {""}]
[h: wrappedText = ""]
<!-- break at desirable characters. That might normally be commas, hyphens
    and spaces.  But text parsing is akward in this language. So well
    tokenize at spaces and deal with words-->

[h: words = json.fromList (text, " ")]
[h: index = 0]
[h, foreach (word, words), code: {
	[wordLength = length (word)]
	[if (index + wordLength > wrapLength), code: {
		<!-- weve exceeded our wrap mandate. start a new line -->
		[wrappedText = wrappedText + decode ("%0A")]
		[index = 0]
	}]
	[wrappedText = wrappedText + word + " "]
	[index = index + wordLength]
}]
[h: macro.return = wrappedText]