import java.sql.Timestamp;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;

year = parameters.year;
System.out.println('year' + year);
Calendar cal = Calendar.getInstance();
if(UtilValidate.isEmpty(year)){
	Timestamp nowtimestamp = UtilDateTime.nowTimestamp();
	cal.setTime(nowtimestamp);
	year = cal.get(Calendar.YEAR);
}else{
	year = Integer.parseInt(year);
}
cal.set(Calendar.YEAR, year);
Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
Timestamp fromDate = UtilDateTime.getYearStart(timestamp);
Timestamp thruDate = UtilDateTime.getYearEnd(timestamp, timeZone, locale);
List<GenericValue> listHolidayInYear = delegator.findList("Holidays", EntityCondition.makeCondition(
																		EntityCondition.makeCondition(
																									EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)),
																						EntityOperator.AND,
																						EntityCondition.makeCondition("thruDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate)), null, null, null, false);
context.listIt = listHolidayInYear;		
context.year = String.valueOf(year);																			