[h: propertyName = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]
[h: currentValue = getProperty (propertyName)]
[h: newValue = if (currentValue != "" && currentValue, 0, 1)]
[h: setProperty (propertyName, newValue)]
[h: dnd5e_CharSheet_refreshPanel ()]