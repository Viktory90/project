package com.olbius.payroll.services;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityFunction;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.party.party.PartyHelper;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

import com.olbius.payroll.util.TimekeepingUtils;
import com.olbius.util.Organization;
import com.olbius.util.PartyUtil;

public class TimekeepingServices {
	public static Map<String, Object> getPartyAttendance(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		String dateKeeping = (String)context.get("dateKeeping");
		java.sql.Date date = new java.sql.Date(Long.parseLong(dateKeeping));
		String retValue = "";
		Map<String, Object> retMap = FastMap.newInstance();
		try {
			List<GenericValue> emplDateAttendance = delegator.findByAnd("EmplAttendanceTracker", UtilMisc.toMap("partyId", partyId, "dateAttendance", date), UtilMisc.toList("startTime"), false);
			Calendar cal = Calendar.getInstance();
			
			if(UtilValidate.isNotEmpty(emplDateAttendance)){
				GenericValue empldateAtt = EntityUtil.getFirst(emplDateAttendance);
				GenericValue emplDateAttLast = emplDateAttendance.get(emplDateAttendance.size() - 1);
				Time startTime = empldateAtt.getTime("startTime");
				Time endTime = emplDateAttLast.getTime("endTime");
				cal.setTime(startTime);
				retValue += cal.get(Calendar.HOUR) + ":";
				retValue += cal.get(Calendar.MINUTE) + "-";
				cal.setTime(endTime);
				retValue += cal.get(Calendar.HOUR) + ":";
				retValue += cal.get(Calendar.MINUTE);
				retMap.put("startTime", startTime.toString());
				retMap.put("endTime", endTime.toString());
			}else{
				retValue += "00:00-00:00";
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ServiceUtil.returnError("not found record");
		}
		
		retMap.put(ModelService.SUCCESS_MESSAGE, ModelService.RESPOND_SUCCESS);
		retMap.put("partyDateKeepingInfo", retValue);
		
		return retMap;
	}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getEmplListTimekeeping(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Locale locale = (Locale)context.get("locale");
		HttpServletRequest request = (HttpServletRequest)context.get("request");
		//Map parameters = (Map)context.get("parameters");
		TimeZone timeZone = UtilHttp.getTimeZone(request);
		//List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	//List<String> listSortFields = (List<String>) context.get("listSortFields");
    	//EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	List<Map<String, Object>> listReturn = FastList.newInstance();
    	Map<String, Object> retMap = FastMap.newInstance();
    	int month = Integer.parseInt((String)parameters.get("month")[0]);
    	int year = Integer.parseInt((String)parameters.get("year")[0]);
    	String partyIdParam = (String[])parameters.get("partyId") != null? ((String[])parameters.get("partyId"))[0] : null;
    	String partyNameParam = (String[])parameters.get("partyName") != null? ((String[])parameters.get("partyName"))[0]: null;
    	
    	Map<String, Object> resultService = FastMap.newInstance();
    	Calendar cal = Calendar.getInstance();
    	cal.set(Calendar.YEAR, year);
    	cal.set(Calendar.MONTH, month);
    	Timestamp timestamp = new Timestamp(cal.getTimeInMillis()); 
    	Timestamp fromDate = UtilDateTime.getMonthStart(timestamp);
    	Timestamp thruDate = UtilDateTime.getMonthEnd(timestamp, timeZone, locale);
    	int size = Integer.parseInt(parameters.get("pagesize")[0]);
		int page = Integer.parseInt(parameters.get("pagenum")[0]);
		int start = size * page;
		int end = start + size;
		List<GenericValue> emplList = PartyUtil.getEmployeeInOrg(delegator);
		
		//List<EntityCondition> conditions = FastList.newInstance();
		
		if(partyIdParam != null){
			emplList = EntityUtil.filterByCondition(emplList, EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("partyId"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyIdParam + "%")));
			//conditions.add(EntityCondition.makeCondition("partyId", EntityOperator.LIKE, "%" + partyIdParam + "%"));
		}
		if(partyNameParam != null){
			partyNameParam = partyNameParam.replaceAll("\\s", "");
			List<EntityCondition> tempConds = FastList.newInstance();
			tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("fullNameFirstNameFirst"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam.toUpperCase() + "%")));
			tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("fullNameLastNameFirst"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam .toUpperCase() + "%")));
			tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("lastNameFirstName"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam .toUpperCase() + "%")));
			tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("firstNameLastName"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam .toUpperCase() + "%")));
			//conditions.add(EntityCondition.makeCondition(tempConds,EntityOperator.AND));
			emplList = EntityUtil.filterByOr(emplList, tempConds);
			/*emplList = EntityUtil.filterByCondition(emplList, EntityCondition.makeCondition(
																	EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("fullNameFirstNameFirst"), EntityOperator.LIKE, EntityFunction.UPPER_FIELD("%" + partyNameParam.toUpperCase() + "%")),
																	EntityOperator.OR, 
																	EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("fullNameLastNameFirst"), EntityOperator.LIKE, EntityFunction.UPPER_FIELD("%" + partyNameParam .toUpperCase() + "%"))));*/
		}
		/*if(conditions.size() > 0){
			
		}*/
		
		
		List<GenericValue> allEmplPositionType;
		int totalRows = 0;
		try {
			allEmplPositionType = delegator.findByAnd("EmplPositionType", null, null, false);
			Map<String, Object> timeKeepingByPosType = FastMap.newInstance();
			for(GenericValue posType: allEmplPositionType){
				resultService = dispatcher.runSync("getDayWorkEmplPosTypeInPeriod", UtilMisc.toMap("emplPositionTypeId", posType.getString("emplPositionTypeId"), "fromDate", fromDate, "thruDate", thruDate, "timeZone", timeZone));
				timeKeepingByPosType.put(posType.getString("emplPositionTypeId"), (Float)resultService.get("dayWork"));
			}
			Timestamp tmpTimestime = fromDate;
			List<java.sql.Date> dateOfMonth = FastList.newInstance();
			int index = 0;
			while(tmpTimestime.before(thruDate)){
				//filter by time go to work
				java.sql.Date tempDate = new java.sql.Date(tmpTimestime.getTime()); 
				String[] date_value = (String[])parameters.get("date_" + index);
				if(date_value != null){
					List<String> allStatusParam = FastList.newInstance();
					allStatusParam.addAll(Arrays.asList(date_value));
					List<String> allStatus = FastList.newInstance();
					allStatus.add("V");
					allStatus.add("M");
					allStatus.add("S");
					allStatus.add("X");
					
					if(!allStatusParam.containsAll(allStatus)){
						//if all status not checked, filter by checked status
						List<String> allPartyId = FastList.newInstance();
						if(allStatusParam.contains("V")){
							List<GenericValue> availableEmplListInDate = delegator.findByAnd("EmplAttendanceTracker", UtilMisc.toMap("dateAttendance", tempDate), null, false);
							List<String> tempList = EntityUtil.getFieldListFromEntityList(availableEmplListInDate, "partyId", true);
							List<GenericValue> absenceEmplList = EntityUtil.filterByCondition(emplList, EntityCondition.makeCondition("partyId", EntityOperator.NOT_IN, tempList));
							List<String> absenceList = EntityUtil.getFieldListFromEntityList(absenceEmplList, "partyId", true);
							allPartyId.addAll(absenceList);
						}
						if(allStatusParam.contains("M")){
							List<GenericValue> workingShiftList = delegator.findList("WorkingShift", EntityUtil.getFilterByDateExpr(), null, UtilMisc.toList("startTime"), null, false);
							Time startTime = workingShiftList.get(0).getTime("startTime");
							List<GenericValue> lateEmplListInDate = delegator.findList("EmplAttendanceTracker", EntityCondition.makeCondition(EntityCondition.makeCondition("dateAttendance", tempDate), 
																																				EntityOperator.AND,
																																				EntityCondition.makeCondition("startTime", EntityOperator.GREATER_THAN, startTime)), null, null, null, false);
							List<String> tempList = EntityUtil.getFieldListFromEntityList(lateEmplListInDate, "partyId", true);
							allPartyId.addAll(tempList);
						}
						if(allStatusParam.contains("S")){
							List<GenericValue> workingShiftList = delegator.findList("WorkingShift", EntityUtil.getFilterByDateExpr(), null, UtilMisc.toList("startTime"), null, false);
							Time startTime = workingShiftList.get(0).getTime("startTime");
							List<GenericValue> earlyEmplListInDate = delegator.findList("EmplAttendanceTracker", EntityCondition.makeCondition(EntityCondition.makeCondition("dateAttendance", tempDate), 
																																				EntityOperator.AND,
																																				EntityCondition.makeCondition("startTime", EntityOperator.LESS_THAN, startTime)), null, null, null, false);
							List<String> tempList = EntityUtil.getFieldListFromEntityList(earlyEmplListInDate, "partyId", true);
							allPartyId.addAll(tempList);
						}
						if(allStatusParam.contains("X")){
							List<GenericValue> workingShiftList = delegator.findList("WorkingShift", EntityUtil.getFilterByDateExpr(), null, UtilMisc.toList("startTime"), null, false);
							Time startTime = workingShiftList.get(0).getTime("startTime");
							List<GenericValue> onTimeEmplListInDate = delegator.findList("EmplAttendanceTracker", EntityCondition.makeCondition(EntityCondition.makeCondition("dateAttendance", tempDate), 
																																				EntityOperator.AND,
																																				EntityCondition.makeCondition("startTime", EntityOperator.EQUALS, startTime)), null, null, null, false);
							List<String> tempList = EntityUtil.getFieldListFromEntityList(onTimeEmplListInDate, "partyId", true);
							allPartyId.addAll(tempList);
						}
						emplList = EntityUtil.filterByCondition(emplList, EntityCondition.makeCondition("partyId", EntityOperator.IN, allPartyId));
					}
				}
				// ./end
				dateOfMonth.add(tempDate);
				tmpTimestime = UtilDateTime.getNextDayStart(tmpTimestime);
				index++;
			}
			if(end > emplList.size()){
				end = emplList.size();
			}
			totalRows = emplList.size();
			emplList = emplList.subList(start, end);
			List<GenericValue> workingShift = delegator.findList("WorkingShift", EntityCondition.makeCondition(
					EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr()),
					EntityOperator.AND,
					EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_")),null, null, null, false);
			Map<String, Object> mapEmplDayLeave = FastMap.newInstance();
			for(GenericValue empl: emplList){
				Map<String, Object> tempMap = FastMap.newInstance();
				String partyId = empl.getString("partyId");
				tempMap.put("partyId", partyId);
				tempMap.put("partyName", PartyHelper.getPartyName(delegator, partyId, false));
				for(int i = 0; i < dateOfMonth.size(); i++){
					resultService = dispatcher.runSync("getEmplTimeKeepingInDate", UtilMisc.toMap("partyId", partyId, "dateKeeping", dateOfMonth.get(i)));
					tempMap.put("date_" + i, resultService.get("statusAttendance"));
					tempMap.put("dateValue_" + i, dateOfMonth.get(i));
				}
				/*List<GenericValue> emplPosType = PartyUtil.getCurrPositionTypeOfEmpl(delegator, partyId);
				float dayWork = 0f;
				for(GenericValue type: emplPosType){
					float tempDayWork = (Float)timeKeepingByPosType.get(type.getString("emplPositionTypeId"));
					if(tempDayWork > dayWork){
						dayWork = tempDayWork;
					}
				}*/
				float dayWork = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, fromDate, thruDate, locale, timeZone);
				tempMap.put("TotalTimeKeeping", dayWork);
				mapEmplDayLeave = TimekeepingUtils.getEmplDayLeaveByTimekeeper(dctx, fromDate, thruDate, partyId, workingShift);
				float totalDayEmplLeave = (Float)mapEmplDayLeave.get("totalDayLeave");
				float countTimekeeping = dayWork - totalDayEmplLeave;
				tempMap.put("TotalDayWorking", countTimekeeping);
				listReturn.add(tempMap);
			}
			
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		retMap.put("listIterator", listReturn);
		retMap.put("TotalRows", String.valueOf(totalRows));
		return retMap;
	}
	
	public static Map<String, Object> updateEmplAttendanceTracker(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> retMap = FastMap.newInstance();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Map<String, Object> resultService = FastMap.newInstance();
		String partyId = (String)context.get("partyId");
		String startTimeStr = (String)context.get("startTime");
		String endTimeStr = (String)context.get("endTime");
		String dateAttendance = (String)context.get("dateAttendance");
		java.sql.Date dateAtt = new java.sql.Date(Long.parseLong(dateAttendance));
		Time startTime = new Time(Long.parseLong(startTimeStr));
		Time endTime = new Time(Long.parseLong(endTimeStr));
		Locale locale = (Locale)context.get("locale");
		if(!startTime.before(endTime)){
			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "TimeEnterNotValid", locale));
		}
		retMap.put(ModelService.SUCCESS_MESSAGE, ModelService.RESPOND_SUCCESS);
		try {
			List<GenericValue> emplAttendanceTracker = delegator.findByAnd("EmplAttendanceTracker", UtilMisc.toMap("partyId", partyId, "dateAttendance", dateAtt), null, false);
			if(UtilValidate.isEmpty(emplAttendanceTracker)){
				GenericValue tempEmplAttendance = delegator.makeValue("EmplAttendanceTracker");
				tempEmplAttendance.set("partyId", partyId);
				tempEmplAttendance.set("dateAttendance", dateAtt);
				tempEmplAttendance.set("startTime", startTime);
				tempEmplAttendance.set("endTime", endTime);
				tempEmplAttendance.create();
				resultService = dispatcher.runSync("getEmplTimeKeepingInDate", UtilMisc.toMap("partyId", partyId, "dateKeeping", dateAtt));
				retMap.put("newStatus", resultService.get("statusAttendance"));
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getEmplTimekeepingGeneral(DispatchContext dctx, Map<String, Object> context){
		HttpServletRequest request = (HttpServletRequest)context.get("request");
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Locale locale = (Locale)context.get("locale");
		TimeZone timeZone = UtilHttp.getTimeZone(request);
		Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	List<Map<String, Object>> listReturn = FastList.newInstance();
		int size = Integer.parseInt(parameters.get("pagesize")[0]);
		int page = Integer.parseInt(parameters.get("pagenum")[0]);
		int start = size * page;
		int end = start + size;
		String partyGroupId = request.getParameter("partyGroupId");
		int month = Integer.parseInt((String)parameters.get("month")[0]);
    	int year = Integer.parseInt((String)parameters.get("year")[0]);
    	Calendar cal = Calendar.getInstance();
    	cal.set(Calendar.YEAR, year);
    	cal.set(Calendar.MONTH, month);
    	Timestamp timestamp = new Timestamp(cal.getTimeInMillis()); 
    	Timestamp fromDate = UtilDateTime.getMonthStart(timestamp);
    	Timestamp thruDate = UtilDateTime.getMonthEnd(timestamp, timeZone, locale);
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
		int totalRows = 0;
		Map<String, Object> retMap = FastMap.newInstance();
		retMap.put("listIterator", listReturn);
		Map<String, Object> resultService = FastMap.newInstance(); 
		try {
			//Map<EmplPositionTypeWorkDay, Float> emplPositionTypeWorkWeek = FastMap.newInstance();
			Organization orgParty = PartyUtil.buildOrg(delegator, partyGroupId);
			List<GenericValue> emplList = orgParty.getEmployeeInOrg(delegator);
			if(end > emplList.size()){
				end = emplList.size();
			}
			totalRows = emplList.size();
			emplList = emplList.subList(start, end);
			retMap.put("TotalRows", String.valueOf(totalRows));
			List<GenericValue> workShift = delegator.findList("WorkingShift", EntityCondition.makeCondition(
													EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_"),
													EntityOperator.AND,
													EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr())), 
												null, UtilMisc.toList("startTime"), null, false);
			Map<String, Object> mapEmpDayLeave = FastMap.newInstance();
			for(GenericValue tempGv: emplList){
				Map<String, Object> tempMap = FastMap.newInstance();
				String tempPartyId = tempGv.getString("partyId");
				List<GenericValue> emplPositionTypes = PartyUtil.getCurrPositionTypeOfEmpl(delegator, tempPartyId);
				String emplPositionTypeId = "";
				if(UtilValidate.isNotEmpty(emplPositionTypes)){
					emplPositionTypeId = emplPositionTypes.get(0).getString("emplPositionTypeId");					
				}
				Float totalDayWork = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, tempPartyId, fromDate, thruDate, locale, timeZone);
				//resultService = dispatcher.runSync("getNbrDayLeaveEmp", UtilMisc.toMap("partyId", tempPartyId, "fromDate", fromDate, "thruDate", thruDate, "userLogin", userLogin));
				//Float totalDayLeaveApprove = (Float)resultService.get("nbrDayLeave");
				mapEmpDayLeave = TimekeepingUtils.getEmplDayLeaveByTimekeeper(dctx, fromDate, thruDate, tempPartyId, workShift);
				Float totalDayLeave = (Float)mapEmpDayLeave.get("totalDayLeave");
				List<Map<String, Object>> listDayLeaveAndWorkShift = (List<Map<String, Object>>)mapEmpDayLeave.get("listDayLeaveAndWorkShift");
				Map<String, Float> emplLeaveApprovedMap = TimekeepingUtils.getDateLeaveApproved(dctx, listDayLeaveAndWorkShift, tempPartyId, workShift.size()); 
				Float totalDayLeaveApprove = emplLeaveApprovedMap.get("totalLeaveApproved");
				Float totalDayLeavePaidApproved = emplLeaveApprovedMap.get("totalLeavePaid");
				resultService = dispatcher.runSync("getNbrHourWorkOvertime", UtilMisc.toMap("partyId", tempPartyId, "fromDate", fromDate, "thruDate", thruDate, "userLogin", userLogin));
				Float hoursActualWorkOvertime = (Float)resultService.get("hoursActualWorkOvertime");
				Float hoursRegisWorkOvertime = (Float)resultService.get("hoursRegisWorkOvertime");
				tempMap.put("dayLeaveApprove", totalDayLeaveApprove );
				tempMap.put("totalDayLeave", totalDayLeave);
				tempMap.put("totalDayLeavePaidApproved", totalDayLeavePaidApproved);
				tempMap.put("overtimeRegister", hoursRegisWorkOvertime);
				tempMap.put("overtimeActual", hoursActualWorkOvertime);
				tempMap.put("partyId", tempPartyId);
				tempMap.put("partyName", PartyHelper.getPartyName(delegator, tempPartyId, false));
				tempMap.put("emplPositionTypeId", emplPositionTypeId);
				tempMap.put("totalDayWork", totalDayWork);
				listReturn.add(tempMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	
	/**
	 * check whether date is dayoff of position type
	 * @param dctx
	 * @param context
	 * @return
	 */
	public static Map<String, Object> checkDayIsDayLeaveOfPositionType(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> retMap = FastMap.newInstance();
		Timestamp dateCheck = (Timestamp)context.get("dateCheck");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(dateCheck.getTime());
		Timestamp dayEnd = UtilDateTime.getDayEnd(dateCheck);
		boolean isDayLeave = true;
		
		List<String> workingShiftList = FastList.newInstance();
		try {
			//check whether dateCheck in holiday or not
			List<GenericValue> dateCheckInHoliday = delegator.findList("Holidays", EntityCondition.makeCondition(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, dateCheck),
																													EntityOperator.AND,
																													EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, dayEnd)), null, null, null, false);
			
			if(UtilValidate.isNotEmpty(dateCheckInHoliday)){
				retMap.put("isDayLeave", true);
				retMap.put("isHoliday", true);
				return retMap;
			}
			String dayOfWeek = getDayName(cal.get(Calendar.DAY_OF_WEEK));
			List<GenericValue> emplPosTypeDayWeek = delegator.findByAnd("EmplPositionTypeWorkWeek", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "dayOfWeek", dayOfWeek), null, false);
			
			for(GenericValue tempWorkWeek: emplPosTypeDayWeek){
				String workingShiftId = tempWorkWeek.getString("workingShiftId");
				if(workingShiftId!= null && !workingShiftId.equals("_NA_")){
					isDayLeave = false;
					break;
				}
			}
			if(!isDayLeave){
				workingShiftList = EntityUtil.getFieldListFromEntityList(emplPosTypeDayWeek, "workingShiftId", true);
			}
			retMap.put("isDayLeave", isDayLeave);
			retMap.put("workingShiftList", workingShiftList);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> getEmplTimeKeepingInDate(DispatchContext dctx, Map<String, Object> context){
    	//LocalDispatcher dispatcher = dctx.getDispatcher();
    	Delegator delegator = dctx.getDelegator();
    	String partyId = (String)context.get("partyId");
    	Map<String, Object> retMap = FastMap.newInstance();
    	java.sql.Date dateKeeping = (java.sql.Date)context.get("dateKeeping");
    	try {
			List<GenericValue> emplAttendance = delegator.findByAnd("EmplAttendanceTracker", UtilMisc.toMap("partyId", partyId, "dateAttendance", dateKeeping), UtilMisc.toList("startTime"), false);
			if(UtilValidate.isNotEmpty(emplAttendance)){
				GenericValue empAtt = EntityUtil.getFirst(emplAttendance);				
				Time startTimeAttendance = empAtt.getTime("startTime");
				List<GenericValue> workShift = delegator.findList("WorkingShift", EntityUtil.getFilterByDateExpr(), null, UtilMisc.toList("startTime"), null, false);
				if(UtilValidate.isNotEmpty(workShift)){
					GenericValue workS = EntityUtil.getFirst(workShift);
					Time startTimeShift = workS.getTime("startTime");
					if(startTimeAttendance.after(startTimeShift)){
						retMap.put("statusAttendance", "M");// M is late
					}else if(startTimeAttendance.before(startTimeShift)){
						retMap.put("statusAttendance", "S");// S is early
					}else{
						retMap.put("statusAttendance", "X");// X is normal
					}
				}
			}else{
				retMap.put("statusAttendance", "V");
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ServiceUtil.returnError("error in get status of employee keeping");
		}
    	return retMap;
    }
	public static Map<String, Object> getDayWorkEmplPosTypeInPeriod(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	Locale locale = (Locale)context.get("locale");
    	TimeZone timeZone = (TimeZone)context.get("timeZone");
    	String emplPositionTypeId = (String)context.get("emplPositionTypeId");
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	Timestamp thruDate = (Timestamp)context.get("thruDate");
    	Map<String, Object> retMap = FastMap.newInstance();
    	Boolean notIncludeHoliday = (Boolean)context.get("notIncludeHoliday");
    	float dayWork = 0;//total working day in period (fromDate -> thruDate)
    	Calendar cal = Calendar.getInstance();
    	try {			
			List<GenericValue> workShift = delegator.findList("WorkingShift", EntityCondition.makeCondition(
																						EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_"),
																						EntityOperator.AND,
																						EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr())), 
																					null, null, null, false);
			int nbrWorkShift = workShift.size();
			List<EntityCondition> holidaysCond = FastList.newInstance();
			holidaysCond.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
			holidaysCond.add(EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
			List<GenericValue> holidays = delegator.findList("Holidays", EntityCondition.makeCondition(holidaysCond), null, null, null, false);
			Timestamp tempDate = fromDate;
			List<EntityCondition> conditions = FastList.newInstance();
			conditions.add(EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_"));
			conditions.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
			conditions.add(EntityUtil.getFilterByDateExpr());
			while(tempDate.before(thruDate)){
				cal.setTime(tempDate);
				int dayOfWeekInt = cal.get(Calendar.DAY_OF_WEEK);
				String dayOfWeek = getDayName(dayOfWeekInt);
				
				List<GenericValue> emplPosTypeWorkWeek = delegator.findList("EmplPositionTypeWorkWeek", EntityCondition.makeCondition(
																								EntityCondition.makeCondition(
																											EntityCondition.makeCondition("dayOfWeek", dayOfWeek)),
																								EntityOperator.AND,
																								EntityCondition.makeCondition(conditions, EntityOperator.AND)), 
																			null, null, null, false);
				if(UtilValidate.isNotEmpty(emplPosTypeWorkWeek)){
					//work shifts in day divide total work shift
					dayWork += (float)emplPosTypeWorkWeek.size()/nbrWorkShift;
				}				
				tempDate = UtilDateTime.getDayStart(tempDate, 1, timeZone, locale);
			}
			if(notIncludeHoliday == null || !notIncludeHoliday){
				for(GenericValue tempHolidays: holidays){
					Timestamp holidayFromDate = tempHolidays.getTimestamp("fromDate");
					Timestamp holidayThruDate = tempHolidays.getTimestamp("thruDate");
					if(holidayFromDate.before(fromDate)){
						holidayFromDate = fromDate;
					}
					if(holidayThruDate.after(thruDate)){
						holidayThruDate = thruDate;
					}
					Timestamp tempHolidayDate = holidayFromDate;
					while(tempHolidayDate.before(holidayThruDate)){
						cal.setTime(tempHolidayDate);
						int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
						String dayOfWeekStr = getDayName(dayOfWeek);
						/* check whether dayOfWeek is dayoff of emplPosType,
						 * dayOfweek is dayoff if WorkingShift for dayOfWeek is not set, or workingShiftId of dayOfWeek is set to "_NA_" and not expired  
						*/
						//List<GenericValue> emplPosTypeWorkWeek = delegator.findByAnd("EmplPositionTypeWorkWeek", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "dayOfWeek", dayOfWeekStr), null, false);
						//List<GenericValue> eptwDayOff = delegator.findOne("EmplPositionTypeWorkWeek", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "dayOfWeek", dayOfWeekStr, "WorkingShift", "_NA_"), false);
						List<GenericValue> eptwDayOff = delegator.findList("EmplPositionTypeWorkWeek", EntityCondition.makeCondition(
																								EntityCondition.makeCondition(
																										EntityCondition.makeCondition("dayOfWeek", dayOfWeekStr)),
																							EntityOperator.AND,
																							EntityCondition.makeCondition(conditions, EntityOperator.AND)), 
																			null, null, null, false);	
						/*reduce dayWork in period (fromDate -> thruDate) if holiday isn't same dayoff */
						if(UtilValidate.isNotEmpty(eptwDayOff)){
							dayWork--;
						}
						tempHolidayDate = UtilDateTime.getDayStart(tempHolidayDate, 1, timeZone, locale);
					}
				}
			}
			retMap.put("dayWork", dayWork);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return retMap;
    }
    
	 public static Map<String, Object> getTimeKeepingEmplInPeriod(DispatchContext dctx, Map<String, Object> context){
	    	Delegator delegator = dctx.getDelegator();
	    	String partyId = (String)context.get("partyId");
	    	//List<String> attendanceTypeIds = (List<String>) context.get("attendanceTypeIds"); 
	    	Timestamp fromDate = (Timestamp)context.get("fromDate");
	    	Timestamp thruDate = (Timestamp)context.get("thruDate");
	    	//List<EntityCondition> conditions = FastList.newInstance();
	    	Map<String, Object> retMap = FastMap.newInstance();
	    	Locale locale = (Locale)context.get("locale");
	    	TimeZone timeZone = (TimeZone)context.get("timeZone");
	    	float countTimekeeping = 0;
	    	/*conditions.add(EntityCondition.makeCondition("dateAttendance", EntityOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(fromDate.getTime())));
	    	conditions.add(EntityCondition.makeCondition("dateAttendance", EntityOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(thruDate.getTime())));
	    	conditions.add(EntityCondition.makeCondition("partyId", partyId));*/
	    	
	    	try {
	    		List<GenericValue> workingShift = delegator.findList("WorkingShift", EntityCondition.makeCondition(
						EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr()),
						EntityOperator.AND,
						EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_")),null, null, null, false);
	    		float totalDayWork = TimekeepingUtils.getDayWorkOfPartyInPeriod(dctx, partyId, fromDate, thruDate, locale, timeZone);
	    		Map<String, Object> mapEmplDayLeave = TimekeepingUtils.getEmplDayLeaveByTimekeeper(dctx, fromDate, thruDate, partyId, workingShift); 
	    		float totalDayLeave = (Float)mapEmplDayLeave.get("totalDayLeave");
	    		countTimekeeping = totalDayWork - totalDayLeave;
	    			
				/*List<GenericValue> emplAttTrack = delegator.findList("EmplAttendanceTracker", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
				float timekeepingPerShift = 1.0f/(workingShift.size());
				for(GenericValue tempEmplAttTrack: emplAttTrack){
					Time startTime = tempEmplAttTrack.getTime("startTime");
					Time endTime = tempEmplAttTrack.getTime("endTime");
					for(GenericValue tempShift: workingShift){
						Time startShift = tempShift.getTime("startTime");
						Time endShift = tempShift.getTime("endTime");
						if(startTime.before(endShift) && endTime.after(startShift)){
							countTimekeeping += timekeepingPerShift;
						}
					}
				}*/
				retMap.put("countTimekeeping", countTimekeeping);
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (GenericServiceException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    	return retMap;
	    }
	 
	 /*get  work overtime registration of partyid */
	public static Map<String, Object> getWorkOvertimeRegistration(DispatchContext dctx, Map<String, Object> context) {
		Delegator delegator = dctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		TimeZone timeZone = (TimeZone)context.get("timeZone");
		String partyId = (String) context.get("partyId");
		String monthStr = (String)context.get("month");
		String yearStr = (String)context.get("year");
		Calendar cal = Calendar.getInstance();
		int month = Integer.parseInt(monthStr);
		int year = Integer.parseInt(yearStr);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.YEAR, year);
		Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
		Timestamp timestampFrom = UtilDateTime.getMonthStart(timestamp);
		Date startMonthDate = new Date(timestampFrom.getTime());
		Timestamp timestampThru = UtilDateTime.getMonthEnd(timestamp, timeZone, locale);
		if(timestampThru.after(UtilDateTime.nowTimestamp())){
			timestampThru = UtilDateTime.nowTimestamp();
		}
		Date endMonthDate = new Date(timestampThru.getTime());
		Map<String, Object> res = FastMap.newInstance();
		try {
			EntityCondition commonConds = EntityCondition.makeCondition("partyId", partyId);
			EntityCondition dateWorkRegisConds;
			List<Map<String, Object>> listReturn = FastList.newInstance();
			
			dateWorkRegisConds = EntityCondition.makeCondition(EntityCondition.makeCondition("dateRegistration", EntityOperator.LESS_THAN_EQUAL_TO, endMonthDate),
																EntityOperator.AND,
																EntityCondition.makeCondition("dateRegistration", EntityOperator.GREATER_THAN_EQUAL_TO, startMonthDate));
			
			List<GenericValue> emplWorkOvertimeRegis = delegator.findList("WorkOvertimeRegistration", EntityCondition.makeCondition(commonConds, 
																				EntityOperator.AND, dateWorkRegisConds), 
																			null, UtilMisc.toList("overTimeFromDate"), null, false);
			
			for(GenericValue tempGv: emplWorkOvertimeRegis){
				Map<String, Object> tempMap = FastMap.newInstance();
				Time overTimeFromDate = tempGv.getTime("overTimeFromDate");
				Time overTimeThruDate = tempGv.getTime("overTimeThruDate");
				Date dateRegistration = tempGv.getDate("dateRegistration");
				Time actualStartTime = tempGv.getTime("actualStartTime");
				Time actualEndTime = tempGv.getTime("actualEndTime");
				tempMap.put("workOvertimeRegisId", tempGv.getString("workOvertimeRegisId"));
				tempMap.put("dateRegistration", dateRegistration != null? dateRegistration.getTime(): null);
				tempMap.put("overTimeFromDate", overTimeFromDate != null? overTimeFromDate.getTime(): null);
				tempMap.put("overTimeThruDate", overTimeThruDate != null? overTimeThruDate.getTime(): null);
				tempMap.put("actualStartTime", actualStartTime != null? actualStartTime.getTime(): null);
				tempMap.put("actualEndTime", actualEndTime != null? actualEndTime.getTime(): null);
				tempMap.put("statusId", tempGv.getString("statusId"));
				listReturn.add(tempMap);
			}
			res.put("data", listReturn);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> updateActualEmplOvertimeWorking(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		TimeZone timeZone = (TimeZone)context.get("timeZone");
		String partyId = (String) context.get("partyId");
		String monthStr = (String)context.get("month");
		String yearStr = (String)context.get("year");
		Calendar cal = Calendar.getInstance();
		int month = Integer.parseInt(monthStr);
		int year = Integer.parseInt(yearStr);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.YEAR, year);
		Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
		Timestamp timestampFrom = UtilDateTime.getMonthStart(timestamp);
		Date startMonthDate = new Date(timestampFrom.getTime());
		Timestamp timestampThru = UtilDateTime.getMonthEnd(timestamp, timeZone, locale);
		if(timestampThru.after(UtilDateTime.nowTimestamp())){
			timestampThru = UtilDateTime.nowTimestamp();
		}
		Date endMonthDate = new Date(timestampThru.getTime());
		//Map<String, Object> res = FastMap.newInstance();
		EntityCondition workOvertimeRegis;
		try {
			EntityCondition commonConds = EntityCondition.makeCondition("partyId", partyId);
			Date tmpDate = startMonthDate;
			EntityCondition dateAttendanceConds;
			List<GenericValue> workingShift = delegator.findList("WorkingShift", EntityCondition.makeCondition(EntityCondition.makeCondition("workingShiftId", EntityOperator.NOT_EQUAL, "_NA_"),
																												EntityOperator.AND,
																												EntityUtil.getFilterByDateExpr()), null, 
																												UtilMisc.toList("-endTime"), null, false);
			
			if(UtilValidate.isNotEmpty(workingShift)){
				Map<String, Object> tempMap = FastMap.newInstance();
				while(tmpDate.before(endMonthDate)){
					dateAttendanceConds = EntityCondition.makeCondition("dateAttendance", tmpDate);					
					List<GenericValue> emplAttendance = delegator.findList("EmplAttendanceTracker", EntityCondition.makeCondition(commonConds, 
																									EntityOperator.AND, dateAttendanceConds), 
																									null, UtilMisc.toList("-endTime"), null, false);
					cal.setTime(tmpDate);
					if(UtilValidate.isNotEmpty(emplAttendance)){
						tempMap = TimekeepingUtils.getWorkingShiftDayOfParty(dctx, context, tmpDate);
						Boolean tempIsDayLeave = (Boolean)tempMap.get("isDayLeave");
						Time endTime;
						if(tempIsDayLeave){
							//if day is day leave, working overtime calculate from startTime
							endTime = emplAttendance.get(emplAttendance.size() - 1).getTime("startTime");
						}else{
							List<String> tempListWorkShift = (List<String>)tempMap.get("workingShiftList");
							endTime = workingShift.get(0).getTime("endTime"); 
							if(UtilValidate.isNotEmpty(tempListWorkShift)){
								List<GenericValue> tempWorkShift = EntityUtil.filterByCondition(workingShift, EntityCondition.makeCondition("workingShiftId", EntityOperator.IN, tempListWorkShift));
								endTime = tempWorkShift.get(0).getTime("endTime");
							}
						}
					
						Time endTimeAttendace = emplAttendance.get(0).getTime("endTime");
						if(endTimeAttendace.after(endTime)){
							//check if employee register overtime
							workOvertimeRegis = EntityCondition.makeCondition("dateRegistration", tmpDate);
							List<GenericValue> updateWorkOverRegisList = delegator.findList("WorkOvertimeRegistration", EntityCondition.makeCondition(workOvertimeRegis, EntityOperator.AND, commonConds), null, null, null, false);
							if(UtilValidate.isNotEmpty(updateWorkOverRegisList)){
								for(GenericValue updateTemp: updateWorkOverRegisList){
									updateTemp.set("actualStartTime", endTime);
									updateTemp.set("actualEndTime", endTimeAttendace);
									updateTemp.set("actualDateWorkOvertime", tmpDate);
									updateTemp.store();
								}
							}else{
								GenericValue newEntity = delegator.makeValue("WorkOvertimeRegistration");
								newEntity.set("partyId", partyId);
								newEntity.set("dateRegistration", tmpDate);
								newEntity.set("actualStartTime", endTime);
								newEntity.set("actualEndTime", endTimeAttendace);
								String workOvertimeRegisId = delegator.getNextSeqId("WorkOvertimeRegistration");
								newEntity.set("workOvertimeRegisId", workOvertimeRegisId);
								newEntity.create();
							}
						}
					}
					cal.add(Calendar.DATE, 1);
					tmpDate = new Date(cal.getTimeInMillis());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError(e.getLocalizedMessage());
		}
		
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
	}
	
	public static Map<String, Object> updateEmplWorkovertime(DispatchContext dctx, Map<String, Object> context){
		Locale locale = (Locale)context.get("locale");
		Delegator delegator = dctx.getDelegator();
		String workOvertimeRegisId = (String)context.get("workOvertimeRegisId");
		String actualStartTime = (String)context.get("actualStartTime");
		String actualEndTime = (String)context.get("actualEndTime");
		Time startTime = null;
		Time endTime = null;
		try {
			GenericValue emplWorkOvertime = delegator.findOne("WorkOvertimeRegistration", UtilMisc.toMap("workOvertimeRegisId", workOvertimeRegisId), false);
			if(emplWorkOvertime == null){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToUpdate", locale)); 
			}
			if(actualStartTime != null){
				startTime = new Time(Long.parseLong(actualStartTime));
			}
			if(actualEndTime != null){
				endTime = new Time(Long.parseLong(actualEndTime));
			}
			if(startTime != null && endTime != null){
				if(startTime.after(endTime)){
					return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "TimeEnterNotValid", locale));
				}
			}
			emplWorkOvertime.set("actualStartTime", startTime);
			emplWorkOvertime.set("actualEndTime", endTime);
			emplWorkOvertime.set("statusId", context.get("statusId"));
			emplWorkOvertime.store();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
	}
	
	public static String getDayName(int dayWeekId) {
		// TODO Auto-generated method stub
		switch (dayWeekId) {
		case 1:
			return "SUNDAY";
		case 2:
			return "MONDAY";
		case 3:
			return "TUESDAY";
		case 4:
			return "WEDNESDAY";
		case 5:
			return "THURSDAY";
		case 6:
			return "FRIDAY";
		case 7:
			return "SATURDAY";
		default:
			return null;			
		}
	}
}
