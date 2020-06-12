<!-- Instead of the usual arg array, try a json obj -->
[h: filterObj = arg(0)]
[h: toon = json.get (filterObj, "object")]
[h: property = json.get (filterObj, "property")]

<!-- filterObj is only filter terms. Well provide our own object and stuff property back in as needed -->
[h: filterObj = json.remove (filterObj, "object")]
[h: filterObj = json.remove (filterObj, "property")]

[h: resultArry = ""]

<!-- Anything that is: -->
	<!-- granted by a class feature with availableToMultiClass = true -->
	<!-- or granted by a class feature from the starting class -->
	<!-- Each modifier references a componentId. That correlates to data.classes.classFeature.id -->
[h: log.debug ("Searching class")]
[h: searchObject = json.path.read (toon, "data.modifiers.class")]
<!-- property-less search. I need the objecct for reference -->
[h: subSearchConfig = json.set (filterObj, "object", searchObject)]
[h: modifiers = dndb_searchJsonObject (subSearchConfig)]
[h: startingClassDefinition = json.get (json.path.read (toon, "data.classes[*].[?(@.isStartingClass == true)]['definition']"), 0)]
[h: log.debug ("startingClass: " + json.get(startingClassDefinition, "id"))]
[h, foreach (modifier, modifiers), code: {
	[h: qualified = 0]
	[h: multiClassAllowed = json.get (modifier, "availableToMulticlass")]
	[h, if (multiClassAllowed == "true"): qualified = 1]
	[h: componentId = json.get (modifier, "componentId")]
	[h: isGrantedByClass = json.path.read (startingClassDefinition, "classFeatures[*].[?(@.id == " + componentId + ")]['name']")]
	[h: log.debug ("isGrantedByClass: " + isGrantedByClass)]
	[h, if (json.length (isGrantedByClass) > 0): qualified = 1]
	<!-- before appending, apply the result property -->
	[h, if (property != ""): modifier = json.get (modifier, property)]
	[h, if (qualified > 0): resultArry = json.append (resultArry, modifier)]
}]

[h: macro.return = resultArry]