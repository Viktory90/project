package com.olbius.olap;

import java.util.Calendar;
import java.util.Date;

import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.jdbc.SQLProcessor;

public abstract class AbtractOlap implements OlapInterface {

	private SQLProcessor processor;

	protected Date fromDate;

	protected Date thruDate;

	public AbtractOlap() {
	}
	
	@Override
	public void setFromDate(Date date) {
		this.fromDate = date;
	}

	@Override
	public void setThruDate(Date date) {
		this.thruDate = date;
	}

	@Override
	public void SQLProcessor(SQLProcessor processor) {
		this.processor = processor;
	}
	
	@Override
	public void close() throws GenericDataSourceException {
		processor.close();
	}
	
	@Override
	public org.ofbiz.entity.jdbc.SQLProcessor getSQLProcessor() {
		return this.processor;
	}

	public static java.sql.Date getSqlDate(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		java.sql.Date sqlDate = new java.sql.Date(calendar.getTimeInMillis());
		return sqlDate;
	}
	
	public String dateType(String dateType) {
		if(dateType == null || dateType.isEmpty() || dateType.equals(DAY)) {
			dateType = "year_month_day";
		}
		if(dateType.equals(MONTH)) {
			dateType = "year_and_month";
		}
		if(dateType.equals(YEAR)) {
			dateType = "year_name";
		}
		if(dateType.equals(WEEK)) {
			dateType = "week_and_year";
		}
		if(dateType.equals(QUARTER)) {
			dateType = "quarter_and_year";
		}
		return dateType;
	}
	
}
