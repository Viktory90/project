package com.olbius.datawarehouse.dimensions;

import org.ofbiz.entity.GenericEntityException;

public interface Dimension {
	
	public static final String DIMENSION_ID = "dimensionId";
	public static final String NAME = "name";
	public static final String DESCRIPTION = "description";
	
	String getId();
	
	Object getInfo();
	
	Object getInfo(String text);
	
	void insert() throws GenericEntityException;
	
	void update() throws GenericEntityException;
	
	void load(Object id) throws GenericEntityException;
	
	boolean isInfo();
	
	void addInfo(String key, Object value);
	
}
