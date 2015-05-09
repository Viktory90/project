package com.olbius.recruitment;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;

public class RecruitmentDataPreparation {
	/**
	 * Job request is plan?
	 * @param dpct
	 * @param partyId
	 * @param emplPositionTypeId
	 * @param fromDate
	 * @return
	 * @throws Exception 
	 */
	
	public static boolean checkInPlan(DispatchContext dpct,long resourceNumber, String partyId, String emplPositionTypeId, Timestamp fromDate) throws Exception{
		Calendar cal = Calendar.getInstance();
		cal.setTime(fromDate);
		int requestingMonth = cal.get(Calendar.MONTH);
		String requestingYear = new Integer(cal.get(Calendar.YEAR)).toString();
		Delegator delegator = dpct.getDelegator();
		
		EntityCondition condition1 = EntityCondition.makeCondition("partyId", partyId);
		EntityCondition condition2 = EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId);
		EntityCondition condition3 = EntityCondition.makeCondition("year", requestingYear);
		EntityCondition condition4 = EntityCondition.makeCondition("statusId", "RPH_APPROVED");
		EntityCondition conditionList = EntityCondition.makeCondition(EntityJoinOperator.AND, condition1, condition2, condition3, condition4);
		List<GenericValue> tmpList = delegator.findList("RecruitmentPlanAndJobRequest", conditionList, null, null, null, false);
		GenericValue recruitmentPlan = delegator.findOne("RecruitmentPlan", false, UtilMisc.toMap("partyId", partyId, "emplPositionTypeId", emplPositionTypeId, "year", requestingYear));
		if(tmpList == null || recruitmentPlan == null){ //Job Request is not plan
			//throw new NullPointerException();
			return false;
		}
		
		//Calculate total resource number in plan in requesting month
		long count = resourceNumber;
		for(GenericValue item : tmpList){
			Timestamp tmpFromDate =  item.getTimestamp("fromDate");
			cal.setTime(tmpFromDate);
			int requestedMonth = cal.get(Calendar.MONTH);
			if(requestingMonth == requestedMonth){
				count += item.getLong("resourceNumber");
			}
		}
		
		//Check condition to job request is in plan
		long planResourceNumber = 0;
		switch (requestingMonth) {
		case 0:
			if(recruitmentPlan.getLong("firstMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("firstMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 1:
			if(recruitmentPlan.getLong("secondMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("secondMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 2:
			if(recruitmentPlan.getLong("thirdMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("thirdMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 3:
			if(recruitmentPlan.getLong("fourthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("fourthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 4:
			if(recruitmentPlan.getLong("fifthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("fifthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 5:
			if(recruitmentPlan.getLong("sixthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("sixthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 6:
			if(recruitmentPlan.getLong("seventhMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("seventhMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 7:
			if(recruitmentPlan.getLong("eighthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("eighthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 8:
			if(recruitmentPlan.getLong("ninthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("ninthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 9:
			if(recruitmentPlan.getLong("tenthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("tenthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 10:
			if(recruitmentPlan.getLong("eleventhMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("eleventhMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		case 11:
			if(recruitmentPlan.getLong("twelfthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("twelfthMonth");
			}
			if(count > planResourceNumber){
				return false;
			}
			break;
		default:
			throw new Exception("Month is not valid");
		}
		return true;
	}

	public static Map<String, Object> checkRecuitmentPlan(DispatchContext dctx,
			String orgId, String emplPositionTypeId, Locale locale,
			Timestamp fromDate, String recruitmentTypeId, TimeZone timeZone) throws Exception {
		//TODO need check time period not recruit
		
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> retMap = FastMap.newInstance();
		boolean isAllowCreated = false;

		//check if recruit is disabled 
		Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
		List<EntityCondition> recruitmentDisableCondition = FastList.newInstance();
		recruitmentDisableCondition.add(EntityUtil.getFilterByDateExpr(nowTimestamp));
		recruitmentDisableCondition.add(EntityCondition.makeCondition("partyId", orgId));
		recruitmentDisableCondition.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
		recruitmentDisableCondition.add(EntityCondition.makeCondition("recruitmentTypeId", recruitmentTypeId));
		List<GenericValue> recruitmentDisable = delegator.findList("RecruitmentDisableAndParty", EntityCondition.makeCondition(recruitmentDisableCondition, EntityOperator.AND), null, null, null, false);
		if(UtilValidate.isNotEmpty(recruitmentDisable)){
			Timestamp disableFromDate = EntityUtil.getFirst(recruitmentDisable).getTimestamp("fromDate");
			Timestamp disableThruDate = EntityUtil.getFirst(recruitmentDisable).getTimestamp("thruDate");
			GenericValue emplPositionType = delegator.findOne("EmplPositionType", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId), false);
			retMap.put("isAllowCreated", isAllowCreated);
			retMap.put("errorMessage", UtilProperties.getMessage("RecruitmentUiLabels", "RecruitmentDisable", UtilMisc.toMap("emplPositionType", emplPositionType.getString("description"), "fromDate", disableFromDate, "thruDate", disableThruDate, "reason", EntityUtil.getFirst(recruitmentDisable).getString("reasons")), locale));
			return retMap;
		}
		
		Timestamp monthBegin = UtilDateTime.getMonthStart(fromDate);
		Timestamp monthEnd = UtilDateTime.getMonthEnd(fromDate, timeZone, locale);
		
		List<EntityCondition> jobReqConditions = FastList.newInstance();
		jobReqConditions.add(EntityCondition.makeCondition("partyId", orgId));
		jobReqConditions.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
		jobReqConditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN_EQUAL_TO, monthBegin));
		jobReqConditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, monthEnd));
		jobReqConditions.add(EntityCondition.makeCondition("isInPlan", "IJR_INPLAN"));
		jobReqConditions.add(EntityCondition.makeCondition("recruitmentTypeId", recruitmentTypeId));
		List<GenericValue> jobReq = delegator.findList("JobRequest", EntityCondition.makeCondition(jobReqConditions, EntityOperator.AND), null, null, null, false);
		
		Map<String, Object> jobReqMap = FastMap.newInstance();
		jobReqMap.put("emplPositionTypeId", emplPositionTypeId);
		jobReqMap.put("partyId", orgId);
		jobReqMap.put("isInPlan", "IJR_INPLAN");
		jobReqMap.put("fromDate", monthBegin);
		jobReqMap.put("thruDate", monthEnd);
		jobReqMap.put("recruitmentFormId", "TOANTHOIGIAN");
		jobReqMap.put("isInPlan", "IJR_INPLAN");
		jobReqMap.put("recruitmentTypeId", recruitmentTypeId);
		jobReqMap.put("statusId", "JR_APPROVED");
		
		String jobRequestId = null;
		if(recruitmentTypeId.equals("TUYENMOI")){
			Calendar cal = Calendar.getInstance();
			cal.setTime(fromDate);
			int month = cal.get(Calendar.MONTH);
			GenericValue recruitmentPlan = delegator.findOne("RecruitmentPlan", UtilMisc.toMap("partyId", orgId, "year", Long.valueOf(cal.get(Calendar.YEAR)), "emplPositionTypeId", emplPositionTypeId), false);
			Long planResourceNumber = getPlanResourceNumberInMonth(recruitmentPlan, month);	
			if(planResourceNumber > 0){
				//check whether jobRequest in month exists or not				
				//if jobReq is empty, then no any salesman/PG recruit, so createJobRequest
				if(UtilValidate.isEmpty(jobReq)){
					jobReqMap.put("resourceNumber", planResourceNumber);
					/*Map<String, Object> results = dispatcher.runSync("createJobRequest", jobReqMap);
					jobRequestId = (String)results.get("jobRequestId");*/
					GenericValue jobRequest = delegator.makeValidValue("JobRequest", jobReqMap);
					jobRequestId = delegator.getNextSeqId("JobRequest");
					jobRequest.set("jobRequestId", jobRequestId);
					jobRequest.create();
				}else{
					GenericValue jobRequest = EntityUtil.getFirst(jobReq); 
					jobRequestId = jobRequest.getString("jobRequestId");
					Long resourceNumber = jobRequest.getLong("resourceNumber");
					if(resourceNumber != planResourceNumber){
						jobRequest.set("resourceNumber", planResourceNumber);
						jobRequest.store();
					}
				}
				//get number of salesman/PG recruit in month
				List<GenericValue> partyJobRequest = delegator.findByAnd("PartyJobRequest", UtilMisc.toMap("jobRequestId", jobRequestId), null, false);
				if(partyJobRequest.size() < planResourceNumber){
					isAllowCreated = true;
					retMap.put("jobRequestId", jobRequestId);	
				}
			}
			if(!isAllowCreated){
				retMap.put("errorMessage", UtilProperties.getMessage("RecruitmentUiLabels", "RecruitmentNotInPlan", locale));
			}
		}else if(recruitmentTypeId.equals("TUYENTHAYTHE")){
			List<EntityCondition> conditions = FastList.newInstance();
			conditions.add(EntityCondition.makeCondition("partyId", orgId));
			conditions.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
			conditions.add(EntityCondition.makeCondition(
						EntityCondition.makeCondition("actualFromDate", EntityOperator.LESS_THAN_EQUAL_TO, fromDate),
						EntityOperator.OR,
						EntityCondition.makeCondition("actualFromDate", EntityOperator.EQUALS, null)));
			conditions.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "EMPL_POS_INACTIVE"));
			conditions.add(EntityCondition.makeCondition(
							EntityCondition.makeCondition("actualThruDate", null), 
							EntityOperator.OR, 
							EntityCondition.makeCondition("actualThruDate", EntityOperator.GREATER_THAN, fromDate)));
			List<GenericValue> emplPos = delegator.findList("EmplPosition", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
			EntityCondition thruDateCons = EntityCondition.makeCondition(
					EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null),
					EntityOperator.OR,
					EntityCondition.makeCondition("thruDate",EntityOperator.GREATER_THAN, fromDate)); 
			for(GenericValue pos: emplPos){
				String emplPositionId = pos.getString("emplPositionId");
				List<EntityCondition> tempConds = FastList.newInstance();
				tempConds.add(EntityCondition.makeCondition("emplPositionId", emplPositionId));
				tempConds.add(thruDateCons);
				List<GenericValue> emplPosFul = delegator.findList("EmplPositionFulfillment", EntityCondition.makeCondition(tempConds, EntityOperator.AND), null, null, null, false);
				if(UtilValidate.isEmpty(emplPosFul)){
					isAllowCreated = true;
					retMap.put("emplPositionId", emplPositionId);
					break;
				}
			}
			if(isAllowCreated){
				if(UtilValidate.isEmpty(jobReq)){
					jobReqMap.put("resourceNumber", 1L);					
					GenericValue jobRequest = delegator.makeValidValue("JobRequest", jobReqMap);
					jobRequestId = delegator.getNextSeqId("JobRequest");
					jobRequest.set("jobRequestId", jobRequestId);
					jobRequest.create();
				}else{
					GenericValue jobRequest = EntityUtil.getFirst(jobReq);
					Long resourceNumber = jobRequest.getLong("resourceNumber");
					jobRequest.set("resourceNumber", (resourceNumber + 1L));
					jobRequest.store();
					jobRequestId = jobRequest.getString("jobRequestId");
				}	
				retMap.put("jobRequestId", jobRequestId);
			}else{
				retMap.put("errorMessage", UtilProperties.getMessage("RecruitmentUiLabels", "UnableRecruitmentReplaceEmpl", locale));
			}
		}
		retMap.put("isAllowCreated", isAllowCreated);
		return retMap;
	}
	
	private static Long getPlanResourceNumberInMonth(GenericValue recruitmentPlan, int month){
		long planResourceNumber = 0;
		if(UtilValidate.isEmpty(recruitmentPlan)){
			return -1L;
		}
		switch (month) {
		case 0:
			if(recruitmentPlan.getLong("firstMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("firstMonth");
			}
			break;
		case 1:
			if(recruitmentPlan.getLong("secondMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("secondMonth");
			}
			break;
		case 2:
			if(recruitmentPlan.getLong("thirdMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("thirdMonth");
			}
			break;
		case 3:
			if(recruitmentPlan.getLong("fourthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("fourthMonth");
			}
			break;
		case 4:
			if(recruitmentPlan.getLong("fifthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("fifthMonth");
			}
			break;
		case 5:
			if(recruitmentPlan.getLong("sixthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("sixthMonth");
			}
			break;
		case 6:
			if(recruitmentPlan.getLong("seventhMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("seventhMonth");
			}
			break;
		case 7:
			if(recruitmentPlan.getLong("eighthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("eighthMonth");
			}
			break;
		case 8:
			if(recruitmentPlan.getLong("ninthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("ninthMonth");
			}
			break;
		case 9:
			if(recruitmentPlan.getLong("tenthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("tenthMonth");
			}
			break;
		case 10:
			if(recruitmentPlan.getLong("eleventhMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("eleventhMonth");
			}
			break;
		case 11:
			if(recruitmentPlan.getLong("twelfthMonth") != null) {
				planResourceNumber = recruitmentPlan.getLong("twelfthMonth");
			}
			break;
		default:
			planResourceNumber = 0;
		}
		return planResourceNumber;
	}
}
