[h: ordinal = arg(0)]
[h, if(json.length(macro.args) > 1): zero = arg(1); zero = "0"]
[h: lastDigit = substring(ordinal, length(ordinal) - 1)]
[h: remainder = substring(ordinal, 0, length(ordinal) - 1)]
[h, if(length(remainder) > 0), code: {
	[h: remainderLastDigit = substring(remainder, length(remainder) - 1)]
	[h, if (remainderLastDigit == 1): lastDigit = "1" + lastDigit]
	[h, if (remainderLastDigit == 1): remainder = substring(remainder, 0, length(remainder) - 1)]
}]
[h, switch(lastDigit):
    case "1": level = "st";
    case "2": level = "nd";
    case "3": level = "rd";
    default: level = "th"]
[h: value = if (ordinal == 0, zero, ordinal + level)]
[h, if(json.length(macro.args) > 2): value = strformat(arg(2), value)]
[h: macro.return = value]