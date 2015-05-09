package com.olbius.olap.party;

public class PartyOlapFactory {
	
	public PartyOlap newInstance() {
		return new PartyOlapImpl();
	}
	
}
