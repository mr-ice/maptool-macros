[h, if(isGM()), code: {
	[h: nextInitiative()]
}; {	
	[h: iTok = getInitiativeToken()]
	[h: owners = getOwners("json", iTok)]
	[h: player = getPlayerName()]
	[h: log.debug("token=" + getName(iTok) + " id=" + iTok + " me=" + player + " owners=" + owners)]
	[h, if (json.contains(owners, player)), code: {
		[h: broadcast(getName(iTok) + " is done.", "self")]
		[h: nextInitiative()]
	};{
		[h: broadcast(getName(iTok) + " is not your token.", "self")]
	}]
}]