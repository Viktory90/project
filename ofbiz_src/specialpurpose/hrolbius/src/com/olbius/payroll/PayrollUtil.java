package com.olbius.payroll;

import java.sql.Timestamp;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;

import javolution.util.FastMap;
import javolution.util.FastSet;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityComparisonOperator;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityExpr;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;

import com.olbius.payroll.util.TimekeepingUtils;
import com.olbius.util.DateUtil;
import com.olbius.util.PartyUtil;

public class PayrollUtil {
	
	public static Map<String, String> specialChar = FastMap.newInstance();	
	static{
		specialChar.put("lt", "<");
		specialChar.put("gt", ">");
		specialChar.put("AND", "&&");
		specialChar.put("OR", "||");
		specialChar.put("=", "==");
	}
	
	/* Input: input string to calculate
	 * Output: value after process.
	 * Description: calculate string value by using Javascript engine
	 */
	// TODO thought Exception
	public static String evaluateStringExpression(String strFunction) throws ScriptException{
		return evaluateStringExpression(strFunction,true);
	}
	/* Input: input string to calculate, boolean value to use round or not
	 * Output: value after process.
	 * Description: calculate string value by using Javascript engine
	 */
	public static String evaluateStringExpression(String strFunction, Boolean useRound) throws ScriptException{
		ScriptEngineManager manager = new ScriptEngineManager();
		ScriptEngine engine = manager.getEngineByName("JavaScript");    
		String str = "";
		try{ // use try catch for debugging
			String strParseString = null;
			if(useRound){
				strParseString = "parseFloat(" + evaluateStringExpression(strFunction,false) + ").toFixed(3)";
			}else{
				strParseString = strFunction;
			}
			str = engine.eval(strParseString).toString();
		}catch(Exception ex){
			System.out.print(ex);
		}
		return str;
	}
	
	public static String evaluateFunctionExpression(String functionExpr, ScriptContext context){
		ScriptEngineManager manager = new ScriptEngineManager();		
		ScriptEngine engine = manager.getEngineByName("groovy");
		String str = "";
		String function = escapeSpecialChar(functionExpr);
		try {
			str = engine.eval(function, context).toString();
		} catch (ScriptException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return str;
	}
	
	private static String escapeSpecialChar(String functionExpr) {
		// TODO Auto-generated method stub
		for(Map.Entry<String, String> entry: specialChar.entrySet()){
			functionExpr = functionExpr.replace(entry.getKey(), entry.getValue());
		}
		return functionExpr;
	}
	/*
	 *
	 * Description: make (greater than and equal) or (less than and equal) condition
	 * */
	public static EntityCondition makeGreaterOrLessTEcondition(String strField, Object value,EntityComparisonOperator<?,?> operator){
		// check for other condition
		if(operator != EntityOperator.GREATER_THAN_EQUAL_TO && operator != EntityOperator.LESS_THAN_EQUAL_TO){
			return null;
		}
		EntityExpr expr1 = EntityCondition.makeCondition(strField, operator, value);
		EntityExpr expr2 = EntityCondition.makeCondition(strField, EntityOperator.EQUALS, null);
		return EntityCondition.makeCondition(UtilMisc.toList(expr1,expr2),EntityJoinOperator.OR);
	}
	/*
	 *
	 * Description: make (greater than and equal) condition
	 * */
	public static EntityCondition makeGTEcondition(String strField, Object value){
		return makeGreaterOrLessTEcondition(strField,value,EntityOperator.GREATER_THAN_EQUAL_TO);
	}
	/*
	 *
	 * Description: make (less than and equal) condition
	 * */
	public static EntityCondition makeLTEcondition(String strField, Object value){
		return makeGreaterOrLessTEcondition(strField,value,EntityOperator.LESS_THAN_EQUAL_TO);
	}
	/*
	 *
	 * Description: define formula type
	 * */
	public enum CallBuildFormulaType{
		NATIVE,
		PRIMITIVE
	}	
	//FIXME Ignore time, Need work time configuration
	public static int daysBetween(Timestamp start, Timestamp end){
		DateTime startTmp = new DateTime(start.getTime());
		DateTime endTmp = new DateTime(end.getTime());
		return Days.daysBetween(startTmp, endTmp).getDays();
	}
	
	//FIXME maybe deleted
	public static Map<Enum<PeriodEnum>, Long> getPeriodLength(Delegator delegator) throws GenericEntityException{
		GenericValue yearlyGv = delegator.findOne("PeriodType", UtilMisc.toMap("periodTypeId", "YEARLY"), false);
		GenericValue quarterlyGv = delegator.findOne("PeriodType", UtilMisc.toMap("periodTypeId", "QUARTERLY"), false);
		GenericValue monthlyGv = delegator.findOne("PeriodType", UtilMisc.toMap("periodTypeId", "MONTHLY"), false);
		GenericValue weeklyGv = delegator.findOne("PeriodType", UtilMisc.toMap("periodTypeId", "WEEKLY"), false);
		GenericValue dailyGv = delegator.findOne("PeriodType", UtilMisc.toMap("periodTypeId", "DAILY"), false);
		GenericValue hourlyGv = delegator.findOne("PeriodType", UtilMisc.toMap("periodTypeId", "HOURLY"), false);
		Map<Enum<PeriodEnum>, Long> retMap = FastMap.newInstance();
		retMap.put(PeriodEnum.YEARLY, yearlyGv.getLong("periodLength"));
		retMap.put(PeriodEnum.QUARTERLY, quarterlyGv.getLong("periodLength"));
		retMap.put(PeriodEnum.MONTHLY, monthlyGv.getLong("periodLength"));
		retMap.put(PeriodEnum.WEEKLY, weeklyGv.getLong("periodLength"));
		retMap.put(PeriodEnum.DAILY, dailyGv.getLong("periodLength"));
		retMap.put(PeriodEnum.HOURLY, hourlyGv.getLong("periodLength"));
		return retMap;
	}
	
	//FIXME maybe deleted
	public static String convertValueCorrespondingPerHour(Map<Enum<PeriodEnum>, Long> periodLength, String value, String periodTypeId) throws ScriptException{
		String convertValue = value;
		if("YEARLY".equals(periodTypeId)){
			convertValue = PayrollUtil.evaluateStringExpression(value + "/" + periodLength.get(PeriodEnum.YEARLY));
		}else if("QUARTERLY".equals(periodTypeId)){
			convertValue = PayrollUtil.evaluateStringExpression(value + "/" + periodLength.get(PeriodEnum.QUARTERLY));
		}else if("MONTHLY".equals(periodTypeId)){
			convertValue = PayrollUtil.evaluateStringExpression(value + "/" + periodLength.get(PeriodEnum.MONTHLY));
		}else if("WEEKLY".equals(periodTypeId)){
			convertValue = PayrollUtil.evaluateStringExpression(value + "/" + periodLength.get(PeriodEnum.WEEKLY));
		}else if("DAILY".equals(periodTypeId)){
			convertValue = PayrollUtil.evaluateStringExpression(value + "/" + periodLength.get(PeriodEnum.DAILY));
		}else if("HOURLY".equals(periodTypeId)){
			convertValue = PayrollUtil.evaluateStringExpression(value + "/" + periodLength.get(PeriodEnum.HOURLY));
		}
		return convertValue;
	}
	
	@SuppressWarnings("unchecked")
	public static String getActualValueByPeriod(DispatchContext dctx, String partyId, Timestamp fromDate,
			Timestamp thruDate, Timestamp startCycle, Timestamp endCycle,
			String value, PeriodEnum period, Locale locale, TimeZone timeZone) throws GenericServiceException, Exception {
		// TODO Auto-generated method stub		
		//LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		//Map<String,Object> resultsMap = FastMap.newInstance();
		//List<GenericValue> emplPosTypes = PartyUtil.getCurrPositionTypeOfEmpl(delegator, partyId);
		Map<String, Object> dayLeaveMap;
		
		List<GenericValue> workingShift = delegator.findList("WorkingShift", EntityCondition.makeCondition(
				EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr()),
				EntityOperator.AND,
				EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_")),null, null, null, false);
		Float totalDayWorkInCycle = 0f;
		Float countTimekeeping = 0f;
		String retValue = "0";
		if(thruDate.after(endCycle)){
			Timestamp tempFromDate = fromDate;
			Timestamp tempThrudate = endCycle;
			Timestamp tempStartCycle = startCycle;
			Timestamp tempEndCycle = endCycle;	
			
			while(tempStartCycle.before(thruDate)){
				Float dayWorkInCycle = 0f;
				/*resultsMap = dispatcher.runSync("getTimeKeepingEmplInPeriod", UtilMisc.toMap("partyId", partyId, "fromDate", tempFromDate, "thruDate", tempThrudate, "timeZone", timeZone, "locale", locale));
				Float tempCountTimekeeping = (Float)resultsMap.get("countTimekeeping");*/
				dayLeaveMap = TimekeepingUtils.getEmplDayLeaveByTimekeeper(dctx, tempFromDate, tempThrudate, partyId, workingShift);
				float tempDayEmplLeave = (Float)dayLeaveMap.get("totalDayLeave");
				List<Map<String, Object>> listDayLeaveAndWorkShift = (List<Map<String, Object>>)dayLeaveMap.get("listDayLeaveAndWorkShift");
				Map<String, Float> emplLeaveApprovedMap = TimekeepingUtils.getDateLeaveApproved(dctx, listDayLeaveAndWorkShift, partyId, workingShift.size()); 
				float tempDayEmplLeaveApproved = emplLeaveApprovedMap.get("totalLeavePaid");
				
				dayWorkInCycle = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, tempStartCycle, tempEndCycle, locale, timeZone);
				float dayWorkInFromThruDate = dayWorkInCycle;
				if(!tempFromDate.equals(tempStartCycle) || !tempThrudate.equals(tempEndCycle)){
					dayWorkInFromThruDate = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, tempFromDate, tempThrudate, locale, timeZone);
				}
				float tempCountTimekeeping = dayWorkInFromThruDate - tempDayEmplLeave + tempDayEmplLeaveApproved;
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + tempCountTimekeeping + "/" + dayWorkInCycle);
				
				switch(period) {
					case YEARLY:
						tempStartCycle = UtilDateTime.getYearStart(tempStartCycle, 0, 1);
						tempEndCycle = UtilDateTime.getYearEnd(tempStartCycle, timeZone, locale);
						break;
					case QUARTERLY:
						tempStartCycle = DateUtil.getQuarterStart(tempStartCycle,locale, timeZone, 1);
						tempEndCycle = UtilDateTime.getMonthEnd(UtilDateTime.getMonthStart(tempStartCycle, 0, 3), timeZone, locale);
						break;
					case MONTHLY:
						tempStartCycle = UtilDateTime.getMonthStart(tempStartCycle, 0, 1);
						tempEndCycle = UtilDateTime.getMonthEnd(tempStartCycle, timeZone, locale);
						break;
					case WEEKLY:
						tempStartCycle = UtilDateTime.getWeekStart(tempStartCycle, 0, 1);
						tempEndCycle = UtilDateTime.getWeekEnd(tempStartCycle, timeZone, locale);
						break;
					case DAILY: 
						tempStartCycle = UtilDateTime.getDayStart(tempStartCycle, 1);
						tempEndCycle = UtilDateTime.getDayEnd(tempStartCycle, timeZone, locale);
						break;					
					default:
						break;
				}
				tempFromDate = tempStartCycle;
				if(tempEndCycle.after(thruDate)){
					tempThrudate = thruDate;
				}else{
					tempThrudate = tempEndCycle;
				}
			}
		}else{			
			//totalDayWork = getTotalDayWorkByEmplPosType(emplPosTypes, startCycle, endCycle, dispatcher, timeZone, locale);
			totalDayWorkInCycle = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, startCycle, endCycle, locale, timeZone);
			float totalDayWorkInFromThruDate = totalDayWorkInCycle;
			if(!startCycle.equals(fromDate) || !endCycle.equals(thruDate)){
				totalDayWorkInFromThruDate = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, fromDate, thruDate, locale, timeZone);
			}
			/*resultsMap = dispatcher.runSync("getTimeKeepingEmplInPeriod", UtilMisc.toMap("partyId", partyId, "fromDate", fromDate, "thruDate", thruDate));*/
			dayLeaveMap = TimekeepingUtils.getEmplDayLeaveByTimekeeper(dctx, fromDate, thruDate, partyId, workingShift); 
			float tempDayEmplLeave = (Float)dayLeaveMap.get("totalDayLeave");
			//TODO if dayLeave is approved and dayLeave is still paid salary, reduce tempDayEmplLeave
			List<Map<String, Object>> listDayLeaveAndWorkShift = (List<Map<String, Object>>)dayLeaveMap.get("listDayLeaveAndWorkShift");
			Map<String, Float> leaveApprovedMap = TimekeepingUtils.getDateLeaveApproved(dctx, listDayLeaveAndWorkShift, partyId, workingShift.size()); 
			float tempDayEmplLeaveApproved = leaveApprovedMap.get("totalLeavePaid");
			
			countTimekeeping += totalDayWorkInFromThruDate - tempDayEmplLeave + tempDayEmplLeaveApproved; 
			retValue = PayrollUtil.evaluateStringExpression(value + "*" + countTimekeeping + "/" + totalDayWorkInCycle); 
		}
		return retValue;
	}
	
	public static String getQuotaParametersValue(DispatchContext dctx, String partyId, PeriodEnum periodEnum, PeriodEnum periodCalcSalaryEnum,
			Timestamp fromDate, Timestamp thruDate, Timestamp dateParamEffective, Timestamp dateParamExpire,  String value, Locale locale, TimeZone timeZone) throws GenericEntityException, GenericServiceException, ScriptException{
		//LocalDispatcher dispatcher = dctx.getDispatcher();
		//Delegator delegator = dctx.getDelegator();
		//List<GenericValue> emplPos = PartyUtil.getCurrPositionTypeOfEmpl(delegator, partyId);
		String retValue = "0";
		// ngay bat dau cua chu ky tinh luong, vd: chu ky la tuan thi ngay bat dau la thu 2, chu ky la thang thi ngay bat dau la ngay mung 1
		Timestamp dateStartSalaryPeriod = getStartEndTimestampPeriod(fromDate, locale, timeZone, periodCalcSalaryEnum, DateUtil.STARTMODE, 0);
		// ngay ket thuc cua chu ky tinh luong
		Timestamp dateEndSalaryPeriod = getStartEndTimestampPeriod(thruDate, locale, timeZone, periodCalcSalaryEnum, DateUtil.ENDMODE, 0);
		if(dateParamEffective != null && dateParamEffective.after(dateStartSalaryPeriod)){
			dateStartSalaryPeriod = dateParamEffective;
		}
		if(dateParamExpire != null && dateParamExpire.before(dateEndSalaryPeriod)){
			dateEndSalaryPeriod = dateParamExpire;
		}
		Timestamp dateStartParamByEffectiveDate = getStartEndTimestampPeriod(dateStartSalaryPeriod, locale, timeZone, periodEnum, DateUtil.STARTMODE, 0);
		Timestamp dateEndParamByEffictivedate = getStartEndTimestampPeriod(dateStartSalaryPeriod, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);
		//Timestamp dateStartParamByExpireDate = getStartEndTimestampPeriod(dateEndSalaryPeriod, locale, timeZone, periodEnum, DateUtil.STARTMODE, 0);
		//Timestamp dateEndParamByExpireDate = getStartEndTimestampPeriod(dateEndSalaryPeriod, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);
		while(dateStartParamByEffectiveDate.before(dateEndSalaryPeriod)){
			Float totalDayWork1 = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, dateStartParamByEffectiveDate, dateEndParamByEffictivedate, locale, timeZone); 
			//getTotalDayWorkByEmplPosType(emplPos, dateStartParamByEffectiveDate, dateEndParamByEffictivedate, dispatcher, timeZone, locale);			
			if(DateUtil.beforeOrEquals(dateEndParamByEffictivedate, dateEndSalaryPeriod) && dateStartSalaryPeriod.after(dateStartParamByEffectiveDate)){
				Float totalDayWork2 = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, dateStartSalaryPeriod, dateEndParamByEffictivedate, locale, timeZone);
				//getTotalDayWorkByEmplPosType(emplPos, dateStartSalaryPeriod, dateEndParamByEffictivedate, dispatcher, timeZone, locale);
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + totalDayWork2 + "/" + totalDayWork1);
			}else if(DateUtil.beforeOrEquals(dateEndParamByEffictivedate, dateEndSalaryPeriod) && DateUtil.beforeOrEquals(dateStartSalaryPeriod, dateStartParamByEffectiveDate)){
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value);
			}else if(DateUtil.afterOrEquals(dateStartSalaryPeriod,dateStartParamByEffectiveDate) && dateEndParamByEffictivedate.after(dateEndSalaryPeriod)){
				Float totalDayWork2 = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, dateStartSalaryPeriod, dateEndSalaryPeriod, locale, timeZone); 
				//getTotalDayWorkByEmplPosType(emplPos, dateStartSalaryPeriod, dateEndSalaryPeriod, dispatcher, timeZone, locale);
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + totalDayWork2 + "/" + totalDayWork1);
			}else if(dateEndParamByEffictivedate.after(dateEndSalaryPeriod)){
				Float totalDayWork2 = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, dateStartParamByEffectiveDate, dateEndSalaryPeriod, locale, timeZone);
				//getTotalDayWorkByEmplPosType(emplPos, dateStartParamByEffectiveDate, dateEndSalaryPeriod, dispatcher, timeZone, locale);
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + totalDayWork2 + "/" + totalDayWork1);
			}
			dateStartParamByEffectiveDate = getStartEndTimestampPeriod(dateStartParamByEffectiveDate, locale, timeZone, periodEnum, DateUtil.STARTMODE, 1);
			dateEndParamByEffictivedate = getStartEndTimestampPeriod(dateEndParamByEffictivedate, locale, timeZone, periodEnum, DateUtil.ENDMODE, 1);
		}
		
		return retValue;
	}
	//FIXME need process case that dateEffective and dateExpire of parameters in period fromDate -> thruDate
	/*public static String getQuotaParametersValue(DispatchContext dctx, String partyId, PeriodEnum periodEnum, PeriodEnum periodCalcSalaryEnum,
			Timestamp fromDate, Timestamp thruDate, Timestamp dateParamEffective, Timestamp dateParamExpire,  String value, Locale locale, TimeZone timeZone) throws GenericEntityException, GenericServiceException, ScriptException {
		// TODO Auto-generated method stub
		if(periodEnum.compareTo(periodCalcSalaryEnum) == 0){			
			return value;
		}
		String retValue = "0";
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();		
		List<GenericValue> emplPosTypes = PartyUtil.getCurrPositionTypeOfEmpl(delegator, partyId);
		
		Timestamp periodParamFromDate = getStartEndTimestampPeriod(fromDate, locale, timeZone, periodEnum, DateUtil.STARTMODE, 0); //fromDate of period-parameters-payroll
		Timestamp periodCalcSalFromDate = getStartEndTimestampPeriod(fromDate, locale, timeZone, periodCalcSalaryEnum, DateUtil.STARTMODE, 0);//fromDate of period-salary-calculate
		Timestamp periodParamThruDate = getStartEndTimestampPeriod(fromDate, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);//thruDate of period-parameters-payroll
		Timestamp periodCalcSalThruDate = getStartEndTimestampPeriod(fromDate, locale, timeZone, periodCalcSalaryEnum, DateUtil.ENDMODE, 0);//thruDate of period-salary-calculate
		//Timestamp tempFromDate = null;
		if(periodEnum.compareTo(periodCalcSalaryEnum) > 0){
				//fromDate = periodCalcSalFromDate;
				//maybe occur when periodEnum is Monthly or greater and periodCalcSalaryEnum is weekly, and startDay of week is previous month/quarter/year
			
			if(periodCalcSalFromDate.before(periodParamFromDate)){
				 
				 * fromDate of period-salary-calculate before fromDate of period-parameters-payroll, 
				 * so break periodCalcSalFromDate->periodCalcSalThruDate to 2 period: 
				 *  + first period: periodCalcSalFromDate -> previousPeriodThru
				 *  + second period : periodParamFromDate -> periodCalcSalThruDate 
				   
				Timestamp previousPeriodFrom = getStartEndTimestampPeriod(periodCalcSalFromDate, locale, timeZone, periodEnum, DateUtil.STARTMODE, 0);
				Timestamp previousPeriodThru = getStartEndTimestampPeriod(periodCalcSalFromDate, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);				
				//total day work in previous period that calculate by payrollParameters
				Float previousDayWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, previousPeriodFrom, previousPeriodThru, dispatcher, timeZone, locale);
				//total day work in current period that calculate by payrollParameters
				Float dayCurrWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, periodParamFromDate, periodParamThruDate, dispatcher, timeZone, locale);
				//total day work between periodCalcSalFromDate and  previousPeriodThru (first period)
				Float dayWorkPrevPeriodSalCalc = getTotalDayWorkByEmplPosType(emplPosTypes, periodCalcSalFromDate, previousPeriodThru, dispatcher, timeZone, locale);
				//total day work between periodParamFromDate and periodCalcSalThruDate
				Float dayWorkCurrPeriodSalCalc = getTotalDayWorkByEmplPosType(emplPosTypes, periodParamFromDate, periodCalcSalThruDate, dispatcher, timeZone, locale);
				//calclate value in first period
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + dayWorkPrevPeriodSalCalc + "/" + previousDayWorkParam);
				//calclate value in second period
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + dayWorkCurrPeriodSalCalc + "/" + dayCurrWorkParam);
			}else if(periodCalcSalThruDate.after(periodParamThruDate)){
				
				 * same as case fromDate of period-salary-calculate before fromDate of period-parameters-payroll,
				 * do similar thing when thruDate of period-salary-calculate after thruDate of period-parameters-payroll - break 2 period
				 * 
				Timestamp nextPeriodFrom = getStartEndTimestampPeriod(periodCalcSalThruDate, locale, timeZone, periodEnum, DateUtil.STARTMODE, 0);
				Timestamp nextPeriodThru = getStartEndTimestampPeriod(periodCalcSalThruDate, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);
				Float dayCurrWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, periodParamFromDate, periodParamThruDate, dispatcher, timeZone, locale);
				Float nextDayWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, nextPeriodFrom, nextPeriodThru, dispatcher, timeZone, locale);
				
				Float dayWorkNextPeriodSalCalc = getTotalDayWorkByEmplPosType(emplPosTypes, periodCalcSalThruDate, nextPeriodThru, dispatcher, timeZone, locale);
				Float dayWorkCurrPeriodSalCalc = getTotalDayWorkByEmplPosType(emplPosTypes, periodParamThruDate, periodCalcSalThruDate, dispatcher, timeZone, locale);
				//calclate value in first period
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + dayWorkCurrPeriodSalCalc + "/" + dayCurrWorkParam);
				//calclate value in second period
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + dayWorkNextPeriodSalCalc + "/" + nextDayWorkParam);
			}else{
				Float totalDayWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, periodParamFromDate, periodParamThruDate, dispatcher, timeZone, locale);
				Float totalDayWorkCalcSal = getTotalDayWorkByEmplPosType(emplPosTypes, periodCalcSalFromDate, periodCalcSalThruDate, dispatcher, timeZone, locale);
				retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + totalDayWorkCalcSal + "/" + totalDayWorkParam);
			}
		}else if(periodEnum.compareTo(periodCalcSalaryEnum) < 0){
			Timestamp tempFromDate = periodParamFromDate; //getStartEndTimestampPeriod(periodCalcSalFromDate, locale, timeZone, periodEnum, DateUtil.STARTMODE, 0);
			Timestamp tempThruDate = periodParamThruDate; //getStartEndTimestampPeriod(tempFromDate, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);
			while(tempFromDate.before(periodCalcSalThruDate)){
				if(tempFromDate.before(periodCalcSalFromDate)){
					Float dayWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, tempFromDate, tempThruDate, dispatcher, timeZone, locale);
					Float dayWorkCalcSal = getTotalDayWorkByEmplPosType(emplPosTypes, periodCalcSalFromDate, tempThruDate, dispatcher, timeZone, locale);
					retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + dayWorkCalcSal + "/" + dayWorkParam);
				}else if(tempThruDate.after(periodCalcSalThruDate)){
					Float dayWorkParam = getTotalDayWorkByEmplPosType(emplPosTypes, tempFromDate, tempThruDate, dispatcher, timeZone, locale);
					Float dayWorkCalcSal = getTotalDayWorkByEmplPosType(emplPosTypes, tempFromDate, periodCalcSalThruDate, dispatcher, timeZone, locale);
					retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value + "*" + dayWorkCalcSal + "/" + dayWorkParam);
				}else{
					retValue = PayrollUtil.evaluateStringExpression(retValue + "+" + value);
				}
				tempFromDate = getStartEndTimestampPeriod(tempFromDate, locale, timeZone, periodEnum, DateUtil.STARTMODE, 1);
				tempThruDate = getStartEndTimestampPeriod(tempFromDate, locale, timeZone, periodEnum, DateUtil.ENDMODE, 0);
			}
		}
		return retValue;
	}*/
	public static Float getTotalDayWorkByEmplPosType(
			List<GenericValue> emplPosTypes, Timestamp fromDate,
			Timestamp thruDate, LocalDispatcher dispatcher, TimeZone timeZone, Locale locale) throws GenericServiceException {
		// TODO Auto-generated method stub
		Float totalDayWork = 0f;
		Map<String, Object> resultService; 
		for(GenericValue tempEmplPosType: emplPosTypes){
			resultService = dispatcher.runSync("getDayWorkEmplPosTypeInPeriod", UtilMisc.toMap("emplPositionTypeId", tempEmplPosType.getString("emplPositionTypeId"), "fromDate", fromDate, "thruDate", thruDate, "timeZone", timeZone, "locale", locale));
			Float tempDayWork = (Float)resultService.get("dayWork");
			if(tempDayWork > totalDayWork){
				totalDayWork = tempDayWork;
			}
		}
		return totalDayWork;
	}
	public static Timestamp getStartEndTimestampPeriod(Timestamp timestamp,
			Locale locale, TimeZone timeZone, PeriodEnum period,
			String mode, int later) {
		// TODO Auto-generated method stub
		Timestamp retValue = timestamp;
		switch (period) {
			case YEARLY:
				retValue = UtilDateTime.getYearStart(timestamp, 0, later);
				if(mode.equals(DateUtil.ENDMODE)){
					retValue = UtilDateTime.getYearEnd(retValue, timeZone, locale);
				}
				break;
			case QUARTERLY:
				retValue = DateUtil.getQuarterStart(timestamp, locale, timeZone, later);
				if(mode.equals(DateUtil.ENDMODE)){
					retValue = DateUtil.getQuarterEnd(retValue, locale, timeZone);
				}
				break;
			case MONTHLY:
				retValue = UtilDateTime.getMonthStart(timestamp, 0, later);
				if(mode.equals(DateUtil.ENDMODE)){
					retValue = UtilDateTime.getMonthEnd(retValue, timeZone, locale);
				}
				break;
			case WEEKLY:
				retValue = UtilDateTime.getWeekStart(timestamp, 0, later);
				if(mode.equals(DateUtil.ENDMODE)){
					retValue = UtilDateTime.getWeekEnd(retValue, timeZone, locale);
				}
				break;
			case DAILY:
				retValue = UtilDateTime.getDayStart(timestamp, later);
				if(mode.equals(DateUtil.ENDMODE)){
					retValue = UtilDateTime.getDayEnd(retValue, timeZone, locale);
				}
				break;
			default:
				break;
		}				
		return retValue;
	}	
	
	public static Set<String> getAllRelatedFunction(Delegator delegator, GenericValue payrollFormula) throws GenericEntityException{
		Set<String> retSet = FastSet.newInstance();
		String function = payrollFormula.getString("function");
		String[] functionArr = function.split("[\\+\\-\\*\\/\\%]");
		for(String tempFunc: functionArr){
			if(tempFunc.contains("()") && !tempFunc.contains("if")){
				tempFunc = tempFunc.trim();
				tempFunc = tempFunc.replace("(","");
				tempFunc = tempFunc.replace(")","");
				retSet.add(tempFunc);
				retSet.addAll(getAllRelatedFunction(delegator, delegator.findOne("PayrollFormula", UtilMisc.toMap("code", tempFunc), false)));
			}
		}
		return retSet;
	}
}
