package com.olbius.olap.facility;

public class FacilityOlapFactory{
	
	public FacilityOlap newInstance() {
		
		return new FacilityOlapImpl();
	
	}
	
}
