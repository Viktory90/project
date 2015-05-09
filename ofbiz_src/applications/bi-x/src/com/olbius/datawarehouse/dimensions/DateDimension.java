package com.olbius.datawarehouse.dimensions;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.util.EntityUtil;

public class DateDimension extends AbstractDimension {

	public static final String DATE_DIMENSION = "DateDimension";
	public static final String DATE_VALUE = "dateValue";
	public static final String DAY_NAME = "dayName";
	public static final String DAY_OF_MONTH = "dayOfMonth";
	public static final String DAY_OF_YEAR = "dayOfYear";
	public static final String DAY_OF_WEEK = "dayOfWeek";
	public static final String MONTH_NAME = "monthName";
	public static final String MONTH_OF_YEAR = "monthOfYear";
	public static final String YEAR_NAME = "yearName";
	public static final String WEEK_OF_MONTH = "weekOfMonth";
	public static final String WEEK_OF_YEAR = "weekOfYear";
	public static final String QUARTER_OF_YEAR = "quarterOfYear";
	public static final String QUARTER_AND_YEAR = "quarterAndYear";
	public static final String YEAR_MONTH_DAY = "yearMonthDay";
	public static final String YEAR_MONTH = "yearAndMonth";
	public static final String WEEKDAY_TYPE = "weekdayType";
	public static final String WEEK_AND_YEAR = "weekAndYear";

	public static final SimpleDateFormat monthNameFormat = new SimpleDateFormat("MMMM");
	public static final SimpleDateFormat dayNameFormat = new SimpleDateFormat("EEEE");
	public static final SimpleDateFormat dayDescriptionFormat = new SimpleDateFormat("MMMM d, yyyy");
	public static final SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("yyyy-MM-dd");
	public static final SimpleDateFormat yearMonthFormat = new SimpleDateFormat("yyyy-MM");

	private Date date;

	private Long id;
	
	public DateDimension(Delegator delegator) {
		super(delegator);
		id = null;
	}

	@Override
	public void insert() throws GenericEntityException {
		GenericValue value = delegator.makeValue(DATE_DIMENSION);
		if(id == null) {
			id = getMax(delegator, DATE_DIMENSION) + 1;
		} else {
			id = id + 1;
		}
		info.put(DIMENSION_ID, id);
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}
		try {
			value.create();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
	}

	@Override
	public void update() throws GenericEntityException {
		GenericValue value = delegator.makeValue(DATE_DIMENSION);
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}
		try {
			value.store();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
	}

	@Override
	public void load(Object id) throws GenericEntityException {
		Date date = (Date) id;

		if(date != null) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.set(Calendar.HOUR, 0);
			calendar.set(Calendar.MINUTE, 0);
			calendar.set(Calendar.SECOND, 0);
			calendar.set(Calendar.MILLISECOND, 0);
			java.sql.Date currentDate = new java.sql.Date(calendar.getTimeInMillis());
			while (currentDate.compareTo(this.date) <= 0) {
	            GenericValue dateValue = null;
	            try {
	                dateValue = EntityUtil.getFirst(delegator.findByAnd(DATE_DIMENSION, UtilMisc.toMap(DATE_VALUE, currentDate), null, false));
	            } catch (GenericEntityException gee) {
	                throw new GenericEntityException(gee);
	            }
	            boolean newValue = (dateValue == null);
	            
	            addInfo(DESCRIPTION, dayDescriptionFormat.format(currentDate));
	            
	            int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
	            
	            addInfo(DATE_VALUE, new java.sql.Date(currentDate.getTime()));
	            addInfo(DAY_NAME, dayNameFormat.format(currentDate));
	            addInfo(DAY_OF_MONTH, new Long(calendar.get(Calendar.DAY_OF_MONTH)));
	            addInfo(DAY_OF_YEAR, new Long(calendar.get(Calendar.DAY_OF_YEAR)));
	            addInfo(DAY_OF_WEEK, new Long(dayOfWeek));
	            addInfo(MONTH_NAME, monthNameFormat.format(currentDate));

	            Long quarter = new Long(calendar.get(Calendar.MONTH)/3 + 1);
	            Long year = new Long(calendar.get(Calendar.YEAR));
	            Long week = new Long(calendar.get(Calendar.WEEK_OF_YEAR));
	            addInfo(MONTH_OF_YEAR, new Long(calendar.get(Calendar.MONTH) + 1));
	            addInfo(YEAR_NAME, year);
	            addInfo(WEEK_OF_MONTH, new Long(calendar.get(Calendar.WEEK_OF_MONTH)));
	            addInfo(WEEK_OF_YEAR, week);
	            
	            addInfo(QUARTER_OF_YEAR, quarter);
	            addInfo(QUARTER_AND_YEAR, Long.toString(quarter)+"-"+Long.toString(year));
	            addInfo(WEEKDAY_TYPE, (dayOfWeek == 1 || dayOfWeek == 7? "Weekend": "Weekday"));
	            addInfo(YEAR_MONTH_DAY, yearMonthDayFormat.format(currentDate));
	            addInfo(YEAR_MONTH, yearMonthFormat.format(currentDate));
	            if(week < 10) {
	            	if(week == 1 && quarter == 4) {
	            		addInfo(WEEK_AND_YEAR, "0"+Long.toString(week)+"-"+Long.toString(year+1));
	            	} else {
	            		addInfo(WEEK_AND_YEAR, "0"+Long.toString(week)+"-"+Long.toString(year));
	            	}
	            } else {
	            	if(week == 1 && quarter == 4) {
	            		addInfo(WEEK_AND_YEAR, Long.toString(week)+"-"+Long.toString(year+1));
	            	} else {
	            		addInfo(WEEK_AND_YEAR, Long.toString(week)+"-"+Long.toString(year));
	            	}
	            }
	            
	            try {
	                if (newValue) {
	                    insert();
	                } else {
	                    addInfo(DIMENSION_ID, dateValue.get(DIMENSION_ID));
	                    update();
	                }
	            } catch (GenericEntityException gee) {
	            	throw new GenericEntityException(gee);
	            }
	            calendar.add(Calendar.DATE, 1);
	            currentDate = new java.sql.Date(calendar.getTimeInMillis());
	        }
		}
		
	}

	public void setDate(Date date) {
		this.date = date;
	}
	
}
