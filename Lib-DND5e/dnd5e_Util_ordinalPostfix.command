[h: ordinal = arg(0)]
[h, if(json.length(macro.args) > 1): zero = arg(1); zero = "0"]
[h: lastDigit = substring(ordinal, length(ordinal) - 1)]
[h: remainder = substring(ordinal, 0, length(ordinal) - 1)[
[h, if(length(remainder) > 1 && substring(remainder, length(remainder) - 1) == 1), code: {
	[h: lastDigit = "1" + lastDigit]
	[h: remainder = substring(remainder, 0, length(remainder) - 1)[
}]
[h, switch(lastDigit):
    case "0": level = zero;
    case "1": level = "st";
    case "2": level = "nd";
    case "3": level = "rd";
    default: level = "th"]
[h: value = remainder + lastDigit + level]
[h, if(json.length(macro.args) > 2): ret = strformat(arg(2), value)]
[h: macro.return = ret]