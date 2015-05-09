package com.olbius.payroll.util;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;

import com.olbius.util.PartyUtil;

public class TimekeepingUtils {
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getEmplDayLeaveByTimekeeper(DispatchContext dctx, Timestamp fromDate, Timestamp thruDate, String partyId, 
			 List<GenericValue> workingShift) throws GenericEntityException, GenericServiceException{
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		List<Map<String, Object>> listDayLeaveAndWorkShift = FastList.newInstance();
		Map<String, Object> retMap = FastMap.newInstance();
		if(fromDate == null){
			retMap.put("totalDayLeave", 0f);
			return retMap;
		}
		if(UtilValidate.isNotEmpty(workingShift)){
			int shiftTotal = workingShift.size();
			Timestamp tmpTimestamp = fromDate;			
			Map<String, Object> resultService = FastMap.newInstance();
			Float retValue = 0f;
			while (tmpTimestamp.before(thruDate)) {
				Date dateKeeping = new Date(tmpTimestamp.getTime());
				EntityCondition conds = EntityCondition.makeCondition(EntityCondition.makeCondition("partyId", partyId), 
										EntityOperator.AND, 
										EntityCondition.makeCondition("dateAttendance", dateKeeping));
				List<GenericValue> tmpEmplPosType = PartyUtil.getPositionTypeOfEmplAtTime(delegator, partyId, tmpTimestamp);
				boolean isDayLeave = true;
				//check whether tmpTimestamp is dayLeave of party
				Set<String> workingShiftSet = FastSet.newInstance();
				for(GenericValue tmpGv: tmpEmplPosType){
					resultService = dispatcher.runSync("checkDayIsDayLeaveOfPositionType", UtilMisc.toMap("emplPositionTypeId", tmpGv.getString("emplPositionTypeId"), "dateCheck", tmpTimestamp));
					if(!(Boolean)resultService.get("isDayLeave")){
						isDayLeave = false;
						if(resultService.get("workingShiftList") != null){
							// add workingShift that positionType must work 
							workingShiftSet.addAll((List<String>)resultService.get("workingShiftList"));
						}
						break;
					}
				}
				List<GenericValue> emplAttWorkingshift = delegator.findList("EmplAttendanceTracker", EntityCondition.makeCondition(conds), null, UtilMisc.toList("startTime"), null, false);
				
				if(!isDayLeave){
					Map<String, Object> tempMap = FastMap.newInstance();
					tempMap.put("dateLeave", tmpTimestamp);
					listDayLeaveAndWorkShift.add(tempMap);
					
					if(UtilValidate.isEmpty(emplAttWorkingshift)){
						retValue += ((float)workingShiftSet.size())/shiftTotal;
						tempMap.put("workingShiftLeave", workingShiftSet);
					}else{
						Time timeStartIn = EntityUtil.getFirst(emplAttWorkingshift).getTime("startTime");
						Time timeEndOut = emplAttWorkingshift.get(emplAttWorkingshift.size()-1).getTime("endTime");
						Set<String> workingShiftLeave = FastSet.newInstance();
						tempMap.put("workingShiftLeave", workingShiftLeave);
						for(String tempWorkingShiftId: workingShiftSet){
							GenericValue tempWorkingShift = delegator.findOne("WorkingShift", UtilMisc.toMap("workingShiftId", tempWorkingShiftId), false);
							Time tempStart = tempWorkingShift.getTime("startTime");
							Time tempEnd = tempWorkingShift.getTime("endTime");
							if(timeStartIn.after(tempEnd) || timeEndOut.before(tempStart)){
								retValue += 1f/shiftTotal;
								workingShiftSet.add(tempWorkingShiftId);
							}
						}
					}
				}
				tmpTimestamp = UtilDateTime.getDayStart(tmpTimestamp, 1);
			}
			retMap.put("totalDayLeave", retValue);
			retMap.put("listDayLeaveAndWorkShift", listDayLeaveAndWorkShift);
			
		}else{
			retMap.put("totalDayLeave", 0f);
		}
		return retMap;
	} 

	@SuppressWarnings("unchecked")
	public static Map<String, Float> getDateLeaveApproved(DispatchContext dctx, List<Map<String, Object>> listDayLeaveAndWorkShift, String partyId, int totalWorkingShift) throws GenericEntityException{
		float totalLeaveApproved = 0f;
		float totalLeavePaid = 0f;
		Map<String, Float> retMap = FastMap.newInstance();
		Delegator delegator = dctx.getDelegator();
		if(listDayLeaveAndWorkShift == null){
			retMap.put("totalLeaveApproved", totalLeaveApproved);
			retMap.put("totalLeavePaid", totalLeavePaid);
			return retMap;
		}
		Timestamp timestampDateLeave;
		Set<String> workingShiftSet = FastSet.newInstance();
		Timestamp dayStart;
		Timestamp dayEnd;
		EntityCondition commonConds = EntityCondition.makeCondition("leaveStatus", "LEAVE_APPROVED");
		commonConds = EntityCondition.makeCondition(commonConds, EntityOperator.AND, EntityCondition.makeCondition("partyId", partyId)); 
		List<EntityCondition> conditions = FastList.newInstance();
		Time timepoint = Time.valueOf("12:00:00");
		for(Map<String, Object> tempMap: listDayLeaveAndWorkShift){
			conditions.clear();
			timestampDateLeave = (Timestamp)tempMap.get("dateLeave");
			dayStart = UtilDateTime.getDayStart(timestampDateLeave);
			dayEnd = UtilDateTime.getDayEnd(timestampDateLeave);
			conditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, dayStart));
			conditions.add(EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, dayEnd));
			workingShiftSet = (Set<String>)tempMap.get("workingShiftLeave");
			List<GenericValue> emplLeave = delegator.findList("EmplLeave", EntityCondition.makeCondition(commonConds, EntityOperator.AND, EntityCondition.makeCondition(conditions)), null, null, null, false);
			for(GenericValue tempGv: emplLeave){
				String leaveUnpaid = tempGv.getString("leaveUnpaid");
				String emplLeaveTypeId = tempGv.getString("leaveTypeId");
				if("FULL_DAY".equals(emplLeaveTypeId)){
					totalLeaveApproved += 1f;
				}else {
					for(String workingShiftId: workingShiftSet){
						GenericValue workingShift = delegator.findOne("WorkingShift", UtilMisc.toMap("workingShiftId", workingShiftId), false);
						Time startTime = workingShift.getTime("startTime");
						//Time endTime = workingShift.getTime("endTime");
						if("FIRST_HAFT_DAY".equals(emplLeaveTypeId)){
							if(startTime.before(timepoint)){
								totalLeaveApproved += 1f/totalWorkingShift;
								if(!"Y".equals(leaveUnpaid)){
									totalLeavePaid += 1f/totalWorkingShift;
								}
							}
						}else if("SECOND_HAFT_DAY".equals(emplLeaveTypeId)){
							if(startTime.after(timepoint)){
								totalLeaveApproved += 1f/totalWorkingShift;
								if(!"Y".equals(leaveUnpaid)){
									totalLeavePaid += 1f/totalWorkingShift;
								}
							}
						}
					}
				}
			}
		}
		retMap.put("totalLeaveApproved", totalLeaveApproved);
		retMap.put("totalLeavePaid", totalLeavePaid);
		return retMap;
	}
	
	
	public static Float getDayWorkOfPartyInPeriod(DispatchContext dctx,
			String partyId, Timestamp fromDate, Timestamp thruDate, Locale locale, TimeZone timeZone) throws GenericEntityException, GenericServiceException {
		// TODO Auto-generated method stub
		return getDayWorkOfPartyInPeriod(dctx, partyId, fromDate, thruDate, locale, timeZone, false);
	}
	
	public static Float getDayWorkOfPartyInPeriod(DispatchContext dctx,
			String partyId, Timestamp fromDate, Timestamp thruDate, Locale locale, TimeZone timeZone, boolean notIncludeHoliday) throws GenericEntityException, GenericServiceException{
		Delegator delegator = dctx.getDelegator();
		List<EntityCondition> conditions = FastList.newInstance();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		conditions.add(EntityCondition.makeCondition("employeePartyId", partyId));
		conditions.add(EntityCondition.makeCondition(
						EntityCondition.makeCondition("fromDate", EntityOperator.EQUALS, null),
						EntityOperator.OR,
						EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate)));
		conditions.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
						EntityOperator.OR,
						EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)));
		List<GenericValue> emplPosList = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition(conditions), null, null, null, false);
		Map<String, Object> resultService;
		if(UtilValidate.isNotEmpty(emplPosList)){
			if(emplPosList.size() == 1){
				GenericValue emplPos = emplPosList.get(0);
				Timestamp tempFromDate = emplPos.getTimestamp("fromDate");
				Timestamp tempThruDate = emplPos.getTimestamp("thruDate");
				if(tempFromDate == null || tempFromDate.before(fromDate)){
					tempFromDate = fromDate;
				}
				if(tempThruDate == null || tempFromDate.after(thruDate)){
					tempThruDate = thruDate;
				}
				resultService = dispatcher.runSync("getDayWorkEmplPosTypeInPeriod", UtilMisc.toMap("fromDate", tempFromDate, "thruDate", tempThruDate, 
																									"emplPositionTypeId", emplPos.getString("emplPositionTypeId"),
																									"notIncludeHoliday", notIncludeHoliday,
																									"locale", locale, "timeZone", timeZone));
				return (Float)resultService.get("dayWork");
			}else{
				List<Timestamp> listTimestamp = FastList.newInstance();
				for(GenericValue tempGv: emplPosList){
					Timestamp tmpFromDate = tempGv.getTimestamp("fromDate");
					Timestamp tmpThruDate = tempGv.getTimestamp("thruDate");
					if(tmpFromDate == null || tmpFromDate.before(fromDate)){
						tmpFromDate = fromDate;
					}
					if(tmpThruDate == null || tmpThruDate.after(thruDate)){
						tmpThruDate = thruDate;
					}
					if(!listTimestamp.contains(tmpFromDate)){
						listTimestamp.add(tmpFromDate);
					}
					if(!listTimestamp.contains(tmpThruDate)){
						listTimestamp.add(tmpThruDate);
					}
				}
				Collections.sort(listTimestamp);
				Float totalDayWork = 0f;
				for(int i = 0; i < listTimestamp.size() - 1; i++){
					Timestamp tempFromDate = listTimestamp.get(i);
					Timestamp tempThruDate = listTimestamp.get(i + 1);
					EntityCondition tmpConditions = EntityCondition.makeCondition(
											EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, tempFromDate),
											EntityOperator.AND,
											EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null), 
																		EntityOperator.OR,
																		EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, tempThruDate)));
					List<GenericValue> tempEmplPosList = EntityUtil.filterByCondition(emplPosList, tmpConditions);
					List<String> emplPositionTypeList = EntityUtil.getFieldListFromEntityList(tempEmplPosList, "emplPositionTypeId", true);
					Float maxDayWorkInListEmplPosType = 0f;
					for(String emplPosType: emplPositionTypeList){
						resultService = dispatcher.runSync("getDayWorkEmplPosTypeInPeriod", UtilMisc.toMap("fromDate", tempFromDate, "thruDate", tempThruDate, 
																									"emplPositionTypeId", emplPosType,
																									"notIncludeHoliday", notIncludeHoliday,
																									"locale", locale, "timeZone", timeZone));
						Float tempDayWork = (Float)resultService.get("dayWork");
						if(tempDayWork > maxDayWorkInListEmplPosType){
							maxDayWorkInListEmplPosType = tempDayWork;
						}
					}
					totalDayWork += maxDayWorkInListEmplPosType;
				}
				return totalDayWork;
			}
		}else{
			return 0f;
		}
	}

	@SuppressWarnings("unchecked")
	public static Map<String, Object> getWorkingShiftDayOfParty(DispatchContext dctx, Map<String, Object> context, Date date) throws GenericEntityException, GenericServiceException {
		// TODO Auto-generated method stub
		String partyId = (String)context.get("partyId");
		Timestamp timestamp = new Timestamp(date.getTime());
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		Map<String, Object> retMap = FastMap.newInstance();
		boolean isDayLeave = true;
		Timestamp fromDate = UtilDateTime.getDayStart(timestamp);
		Timestamp thruDate = UtilDateTime.getDayEnd(timestamp);
		//int dayWeek = cal.get(Calendar.DAY_OF_WEEK);
		Set<String> workingShiftSet = FastSet.newInstance();
		List<String> retList = FastList.newInstance();
		//String dayOfWeek = TimekeepingServices.getDayName(dayWeek);
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("employeePartyId", partyId));
		conditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		conditions.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
													 EntityOperator.OR,
													 EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)));
		List<GenericValue> emplPositionFul = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition(conditions), null, null, null, false);
		Map<String, Object> resultService;
		for(GenericValue tempGv: emplPositionFul){
			String emplPositionTypeId = tempGv.getString("emplPositionTypeId");
			resultService = dispatcher.runSync("checkDayIsDayLeaveOfPositionType", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "dateCheck", timestamp));
			Boolean tempIsDayLeave = (Boolean)resultService.get("isDayLeave");
			//EmplPosTypeDayWorkShift key = new EmplPosTypeDayWorkShift(emplPositionTypeId, dayWeek);
			if(isDayLeave){
				isDayLeave = tempIsDayLeave;
			}
			List<String> workingShiftListStr = (List<String>)resultService.get("workingShiftList");
			if(UtilValidate.isNotEmpty(workingShiftListStr)){
				workingShiftSet.addAll(workingShiftListStr);
			}
			/*if(!tempIsDayLeave){
				List<String> workingShiftListStr;
				if(cacheMap.get(key) != null){
					workingShiftListStr = (List<String>)cacheMap.get(key);
				}else{
					List<GenericValue> workingShiftList = delegator.findByAnd("EmplPositionTypeWorkWeek", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "dayOfWeek", dayOfWeek), null, false);
					workingShiftListStr = EntityUtil.getFieldListFromEntityList(workingShiftList, "workingShiftId", true);
					cacheMap.put(key, workingShiftListStr);
				}
				workingShiftSet.addAll(workingShiftListStr);
			}*/
			
		}
		retList.addAll(workingShiftSet);
		retMap.put("workingShiftList", retList);
		retMap.put("isDayLeave", isDayLeave);
		return retMap; 
	}

	public static float getTotalHoursWorkOvertime(DispatchContext dctx,
			String partyId, Timestamp fromDate, Timestamp thruDate, String code) throws GenericEntityException, GenericServiceException {
		// TODO Auto-generated method stub
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Date beginDate = new Date(fromDate.getTime());
		Date endDate = new Date(thruDate.getTime());
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyId", partyId));
		conditions.add(EntityCondition.makeCondition("statusId", "WOTR_ACCEPTED"));
		conditions.add(EntityCondition.makeCondition("dateRegistration", EntityOperator.GREATER_THAN_EQUAL_TO, beginDate));
		conditions.add(EntityCondition.makeCondition("dateRegistration", EntityOperator.LESS_THAN_EQUAL_TO, endDate));
		conditions.add(EntityCondition.makeCondition("actualStartTime", EntityOperator.NOT_EQUAL, null));
		conditions.add(EntityCondition.makeCondition("actualEndTime", EntityOperator.NOT_EQUAL, null));
		List<GenericValue> listWorkOverTime = delegator.findList("WorkOvertimeRegistration", EntityCondition.makeCondition(conditions), null, null, null, false);
		Map<String, Object> resultService;
		float retValue = 0f;
		for(GenericValue tempGv: listWorkOverTime){
			Date tempDate = tempGv.getDate("dateRegistration");
			List<GenericValue> tempList = PartyUtil.getPositionOfEmplInDate(delegator, partyId, tempDate);
			boolean isDayLeave = true;
			Boolean isHoliday = null;
			Time startTime = tempGv.getTime("actualStartTime");
			Time endTime = tempGv.getTime("actualEndTime");
			for(GenericValue tempPosition: tempList){
				String emplPositionTypeId = tempPosition.getString("emplPositionTypeId");
				resultService = dispatcher.runSync("checkDayIsDayLeaveOfPositionType", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, 
																					  "dateCheck", new Timestamp(tempDate.getTime())));
				isDayLeave = (Boolean)resultService.get("isDayLeave");
				isHoliday = (Boolean)resultService.get("isHoliday");
				if(!isDayLeave){
					break;
				}
			}
			if("LAM_THEM_NGAY_THUONG".equals(code)){
				if(!isDayLeave){
					retValue += (float)(endTime.getTime() - startTime.getTime())/(1000*3600);
				}
			}else if("LAM_THEM_NGAY_NGHI".equals(code)){
				if(isDayLeave && (isHoliday == null || !isHoliday)){
					retValue += (float)(endTime.getTime() - startTime.getTime())/(1000*3600);
				}
			}else if("LAM_THEM_NGAY_LE".equals(code)){
				if(isDayLeave && isHoliday != null && isHoliday){
					retValue += (float)(endTime.getTime() - startTime.getTime())/(1000*3600);
				}
			}
		}
		return retValue;
	}
}
