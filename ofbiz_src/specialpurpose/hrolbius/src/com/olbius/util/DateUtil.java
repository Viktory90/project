package com.olbius.util;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javolution.util.FastList;

import org.joda.time.DateTime;
import org.joda.time.Months;
import org.joda.time.Weeks;
import org.joda.time.Years;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.service.ServiceUtil;

public class DateUtil {
	public static String STARTMODE = "START";
	public static String ENDMODE = "END";
	public static boolean checkMonthPeriod(Timestamp fromDate, Timestamp thruDate){
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		int fromHour = cal.get(Calendar.HOUR);
		int fromDay = cal.get(Calendar.DAY_OF_MONTH);
		
		cal.setTime(thruDate);
		int thruHour = cal.get(Calendar.HOUR);
		int thruDay = cal.get(Calendar.DAY_OF_MONTH);
		
		if(fromHour == thruHour && fromDay == thruDay){
			return true;
		}else {
			return false;
		}
	}
	
	public static boolean checkDailyPeriod(Timestamp fromDate, Timestamp thruDate){
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		int fromHour = cal.get(Calendar.HOUR);
		
		cal.setTime(thruDate);
		int thruHour = cal.get(Calendar.HOUR);
		
		if(fromHour == thruHour){
			return true;
		}else {
			return false;
		}
	}
	
	public static boolean checkWeekPeriod(Timestamp fromDate, Timestamp thruDate){
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		int fromHour = cal.get(Calendar.HOUR);
		int fromDay = cal.get(Calendar.DAY_OF_WEEK);
		
		cal.setTime(thruDate);
		int thruHour = cal.get(Calendar.HOUR);
		int thruDay = cal.get(Calendar.DAY_OF_WEEK);
		
		if(fromHour == thruHour && fromDay == thruDay){
			return true;
		}else {
			return false;
		}
	}
	
	public static boolean checkQuarterPeriod(Timestamp fromDate, Timestamp thruDate){
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		int fromHour = cal.get(Calendar.HOUR);
		int fromDay = cal.get(Calendar.DAY_OF_MONTH);
		int fromMonth = cal.get(Calendar.MONTH);
		
		cal.setTime(thruDate);
		int thruHour = cal.get(Calendar.HOUR);
		int thruDay = cal.get(Calendar.DAY_OF_MONTH);
		int thruMonth = cal.get(Calendar.MONTH);
		
		if(fromHour == thruHour && fromDay == thruDay && (thruMonth % fromMonth) == 0 && (thruMonth / fromMonth ) % 3 == 0){
			return true;
		}else {
			return false;
		}
	}
	public static boolean checkYearPeriod(Timestamp fromDate, Timestamp thruDate){
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		int fromHour = cal.get(Calendar.HOUR);
		int fromDay = cal.get(Calendar.DAY_OF_MONTH);
		int fromMonth = cal.get(Calendar.MONTH);
		
		cal.setTime(thruDate);
		int thruHour = cal.get(Calendar.HOUR);
		int thruDay = cal.get(Calendar.DAY_OF_MONTH);
		int thruMonth = cal.get(Calendar.MONTH);
		if(fromHour == thruHour && fromDay == thruDay && fromMonth == thruMonth){
			return true;
		}else {
			return false;
		}
	}
	
	public static boolean checkDateTime(Timestamp fromDate, Timestamp thruDate){
		Calendar calFrom = Calendar.getInstance();
		Calendar calThru = Calendar.getInstance();
		calFrom.setTime(fromDate);
		calThru.setTime(thruDate);
		
		if (calFrom.after(calThru)||calFrom.equals(calThru))
			return false;
		else return true; 
	}
	
	public static int getWeekPeriodNumber(Timestamp fromDate, Timestamp thruDate){
		DateTime dateTime1 = new DateTime(fromDate.getTime());
		DateTime dateTime2 = new DateTime(thruDate.getTime());
		return Weeks.weeksBetween(dateTime1, dateTime2).getWeeks();
	}
	
	public static int getMonthPeriodNumber(Timestamp fromDate, Timestamp thruDate){
		DateTime dateTime1 = new DateTime(fromDate.getTime());
		DateTime dateTime2 = new DateTime(thruDate.getTime());
		return Months.monthsBetween(dateTime1, dateTime2).getMonths();
	}
	
	public static int getQuarterPeriodNumber(Timestamp fromDate, Timestamp thruDate){
		return getMonthPeriodNumber(fromDate, thruDate)/3;
	}
	
	public static int getYearPeriodNumber(Timestamp fromDate, Timestamp thruDate){
		DateTime dateTime1 = new DateTime(fromDate.getTime());
		DateTime dateTime2 = new DateTime(thruDate.getTime());
		return Years.yearsBetween(dateTime1, dateTime2).getYears();
	}
	
	public static int getWorkingDaysBetweenTwoDates(Timestamp startDate, Timestamp endDate) {
	    Calendar startCal = Calendar.getInstance();
	    startCal.setTime(startDate);        

	    Calendar endCal = Calendar.getInstance();
	    endCal.setTime(endDate);

	    int workDays = 0;

	    //Return 0 if start and end are the same
	    if (startCal.getTimeInMillis() == endCal.getTimeInMillis()) {
	        return 0;
	    }

	    if (startCal.getTimeInMillis() > endCal.getTimeInMillis()) {
	        startCal.setTime(endDate);
	        endCal.setTime(startDate);
	    }
	    
	    do {
	       //excluding start date
	        startCal.add(Calendar.DAY_OF_MONTH, 1);
	        if (startCal.get(Calendar.DAY_OF_WEEK) != Calendar.SATURDAY && startCal.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
	            ++workDays;
	        }
	    } while (startCal.getTimeInMillis() < endCal.getTimeInMillis()); //excluding end date

	    return workDays;
	}
	
	//FIXME Need executing hour
	//FIXME Need configure hour, start working time, end working time, break time
	public static int getWorkingHourBetweenTwoDates(Timestamp startDate, Timestamp endDate) {

	    return getWorkingDaysBetweenTwoDates(startDate, endDate)*8;
	}
	
	public static boolean beforeOrEquals(Date date1, Date date2){
		return date1.before(date2) || date1.equals(date2);
	}
	
	public static boolean afterOrEquals(Date date1, Date date2){
		return date1.after(date2) || date1.equals(date2);
	}
	
	//Convert date
	public static String convertDate(Timestamp datetime){
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
		return format.format(datetime);
		
	}
	
	//Convert date
	public static String parseAndConvertDate(String datetime){
			SimpleDateFormat format = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
			try {
				return convertDate(new Timestamp(format.parse(datetime).getTime()));
			} catch (ParseException e) {
				Debug.log(e.getMessage());
				return null;
			}
			
	}
	public static Timestamp getHourStart(Timestamp timestamp, Locale locale, TimeZone timeZone, int hourLater){
		Calendar cal = Calendar.getInstance();
		cal.setTime(timestamp);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.add(Calendar.HOUR, hourLater);
		Timestamp retTimestamp = new Timestamp(cal.getTimeInMillis());
		return retTimestamp;
	}
	public static Timestamp getHourEnd(Timestamp timestamp, Locale locale, TimeZone timeZone){
		Calendar cal = Calendar.getInstance();
		cal.setTime(timestamp);
		cal.set(Calendar.MINUTE, 59);
		cal.set(Calendar.SECOND, 59);
		//cal.add(Calendar.HOUR, hourLater);
		Timestamp retTimestamp = new Timestamp(cal.getTimeInMillis());
		return retTimestamp;
	}
	
	public static Timestamp getQuarterStart(Timestamp timestamp, Locale locale, TimeZone timeZone, int quarterLater){
		Calendar cal = Calendar.getInstance();
		cal.setTime(timestamp);
		int quarter = cal.get(Calendar.MONTH / 3) + 1 + quarterLater % 4;
		switch (quarter) {
		case 1:
			cal.set(cal.get(Calendar.YEAR), Calendar.JANUARY, 1, 0, 0, 0);
			break;
		case 2:
			cal.set(cal.get(Calendar.YEAR), Calendar.APRIL, 1, 0, 0, 0);
			break;
		case 3:
			cal.set(cal.get(Calendar.YEAR), Calendar.JULY, 1, 0, 0, 0);
			break;
		case 4:	
			cal.set(cal.get(Calendar.YEAR), Calendar.OCTOBER, 1, 0, 0, 0);
			break;
		default:
			break;
		}		
		//cal.add(Calendar.MONTH, quarterLater + 3);
		Timestamp retTimestamp = new Timestamp(cal.getTimeInMillis());
		return retTimestamp;
	}
	public static Timestamp getQuarterEnd(Timestamp timestamp, Locale locale, TimeZone timeZone){
		Calendar cal = Calendar.getInstance();
		cal.setTime(timestamp);
		int quarter = cal.get(Calendar.MONTH / 3) + 1;
		switch (quarter) {
		case 1:
			cal.set(cal.get(Calendar.YEAR), Calendar.MARCH, 31, 23, 59, 59);
			break;
		case 2:
			cal.set(cal.get(Calendar.YEAR), Calendar.JUNE, 30, 23, 59, 59);
			break;
		case 3:
			cal.set(cal.get(Calendar.YEAR), Calendar.SEPTEMBER, 31, 23, 59, 59);
			break;
		case 4:	
			cal.set(cal.get(Calendar.YEAR), Calendar.DECEMBER, 31, 23, 59, 59);
			break;
		default:
			break;
		}		
		Timestamp retTimestamp = new Timestamp(cal.getTimeInMillis());
		return retTimestamp;
	}
	
	public static EntityCondition getDateValidConds(Timestamp fromDate, Timestamp thruDate){
		List<EntityCondition> dateConds = FastList.newInstance();
		if(thruDate == null){    		
			dateConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
    	}else{
    		EntityCondition condition1 = EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.NOT_EQUAL, null),
					EntityOperator.AND,
					EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
			condition1 = EntityCondition.makeCondition(condition1, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
			
			EntityCondition condition2 = EntityCondition.makeCondition("thruDate", null);
			condition2 = EntityCondition.makeCondition(condition2, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
			
			dateConds.add(EntityCondition.makeCondition(condition1, EntityOperator.OR, condition2));
    	}
		return EntityCondition.makeCondition(dateConds);
	}
	public static String getCurrentYear(){
		Calendar cal = Calendar.getInstance();
		return Integer.toString(cal.get(Calendar.YEAR));
	}
}
