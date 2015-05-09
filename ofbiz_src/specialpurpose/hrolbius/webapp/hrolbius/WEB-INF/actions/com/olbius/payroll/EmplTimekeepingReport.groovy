import java.sql.Date;
import java.sql.Timestamp;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;

import com.olbius.util.PartyUtil;

year = parameters.year;
month = parameters.month;
Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
Calendar cal = Calendar.getInstance();
cal.setTime(nowTimestamp);
String paramList = "";
if(UtilValidate.isEmpty(year)){
	year = cal.get(Calendar.YEAR);
}else{
	year = Integer.parseInt(year);
	paramList = paramList + "year=" + year + "&";
}
if(UtilValidate.isEmpty(month)){
	month = cal.get(Calendar.MONTH);
}else{
	month = Integer.parseInt(month) - 1;
	paramList = paramList + "month=" + month + "&";
}
cal.set(Calendar.YEAR, year);
cal.set(Calendar.MONTH, month);
Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
Timestamp startMonth = UtilDateTime.getMonthStart(timestamp);
Timestamp endMonth = UtilDateTime.getMonthEnd(timestamp, timeZone, locale);
Timestamp tmpTimestime = startMonth;
List<Date> dateOfMonth = FastList.newInstance();
context.startMonth = startMonth;
context.endMonth = endMonth;

int viewIndex = 0;
try {
	viewIndex = Integer.parseInt((String) parameters.get("VIEW_INDEX"));
} catch (Exception e) {
	viewIndex = 0;
}
int viewSize = 10;
try {
	viewSize = Integer.parseInt((String) parameters.get("VIEW_SIZE"));
} catch (Exception e) {
	viewSize = 10;
}

	int listSize = 0;
int lowIndex = 0;
int highIndex = 0;

lowIndex = viewIndex * viewSize + 1;
highIndex = (viewIndex + 1) * viewSize;

while(tmpTimestime.before(endMonth)){
	dateOfMonth.add(new Date(tmpTimestime.getTime()));
	tmpTimestime = UtilDateTime.getNextDayStart(tmpTimestime);
}
//FIXME current is get all list employee, need fix this
//List<GenericValue> emplList = PartyUtil.getEmployeeInOrg(delegator);
List<GenericValue> emplList = FastList.newInstance();
listSize = emplList.size();
if (highIndex > listSize) {
	highIndex = listSize;
}
//context.emplList = emplList.subList(lowIndex, highIndex);
context.listSize = listSize;
context.highIndex = highIndex;
context.lowIndex = lowIndex;
context.viewSize = viewSize;
context.viewIndex = viewIndex;
context.paramList = paramList;
context.dateOfMonth = dateOfMonth;

List<GenericValue> allEmplPositionType = delegator.findByAnd("EmplPositionType", null, null, false);
Map<String, Object> timeKeepingByPosType = FastMap.newInstance();
for(GenericValue posType: allEmplPositionType){
	result = dispatcher.runSync("getDayWorkEmplPosTypeInPeriod", UtilMisc.toMap("emplPositionTypeId", posType.getString("emplPositionTypeId"), "fromDate", startMonth, "thruDate", endMonth, "timeZone", timeZone));
	timeKeepingByPosType.put(posType.getString("emplPositionTypeId"), result.dayWork);
}
context.timeKeepingByPosType = timeKeepingByPosType;
context.month = String.valueOf(month);
context.year = String.valueOf(year) ;
context.monthDisplay = String.valueOf(month + 1);