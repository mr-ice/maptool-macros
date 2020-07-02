<!-- Fetch the current registry -->
[h: registry = dndb_Preferences_getRegistry (0)]

<!-- determine if this is create, edit, delete -->
[h: crudInput = " action | Create,Edit,Remove,Print,DELETE | Action | List | value=string"]
[h: abort (input (crudInput))]

<!-- Build an input to configure each... input (meta) -->
[h, switch (action):
	case "Create": registry = dnd5e_Preferences_createPreference (registry);
	case "Edit": registry = dnd5e_Preferences_editPreference (registry);
	case "Remove": registry = dnd5e_Preferences_deletePreference (registry);
	case "DELETE": registry = "{}";
	case "Print": ""
]

<!-- Save the registry -->
[h: dndb_Preferences_setRegistry (registry)]
[r: "Current registry"]
<pre>[r: json.indent (registry)]</pre>