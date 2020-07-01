[h: registry = arg (0)]

<!-- Delete -->
[h: prefEntriesKeys = json.toList (json.fields (registry))]
[h: abort (input ( "prefEntryKey | " + prefEntriesKeys + " | Select registry entry | LIST | value=string"))]
[h: registry = json.remove (registry, prefEntryKey)]
[h: macro.return = registry]