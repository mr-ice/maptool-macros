[h: value = arg(0)]
[h: value = replace(value, '&', "&amp;")]
[h: value = replace(value, '"', "&quot;")]
[h: value = replace(value, "'", "&#39;")]
[h: value = replace(value, '<', "&lt;")]
[h: value = replace(value, '>', "&gt;")]
[h: macro.return = value]