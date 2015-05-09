package com.olbius.olap;

import java.util.Date;

import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.jdbc.SQLProcessor;

public interface OlapInterface {
	
	public final static String DAY = "DAY";
	public final static String MONTH = "MONTH";
	public final static String WEEK = "WEEK";
	public final static String QUARTER = "QUARTER";
	public final static String YEAR = "YEAR";
	
	void SQLProcessor(SQLProcessor processor);
	
	void setFromDate(Date date);
	
	void setThruDate(Date date);
	
	void close() throws GenericDataSourceException;
	
	SQLProcessor getSQLProcessor();
	
}
