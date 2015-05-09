package com.olbius.recruitment.helper;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;

public class ExamRating extends Observable{
	
	public void rateExam(DispatchContext dpctx,
			Map<String, ? extends Object> context) throws Exception{
		//Context
		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher localDispt = dpctx.getDispatcher();
		//Get parameters
		String workEffortId = (String)context.get("workEffortId");
		String partyId = (String)context.get("partyId");
		String roleTypeId = (String)context.get("roleTypeId");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		String parentWorkEffortId = (String)context.get("parentWorkEffortId");
		String parentRoleTypeId = (String)context.get("parentRoleTypeId");
		Timestamp parentFromDate = (Timestamp)context.get("parentFromDate");
		String resultId = (String)context.get("resultId");
		Long score = (Long)context.get("score");
		
		GenericValue workEffort = delegator.findOne("WorkEffort", false, UtilMisc.toMap("workEffortId", workEffortId));
		
		//Set context for send notification email
		Map<String, Object> emailCtx = FastMap.newInstance();
		Map<String, Object> emailAddress = localDispt.runSync("getPartyEmail", UtilMisc.toMap("partyId", partyId, "userLogin", context.get("userLogin"), "locale",context.get("userLogin") ));
		Map<String, Object> bodyParameters = FastMap.newInstance();
		bodyParameters.put("description", workEffort.getString("description").toLowerCase());
		bodyParameters.put("partyId", partyId);
		String sendTo = (String)emailAddress.get("emailAddress");
		String authUser = "thiep.levan@olbius.vn";
		String authPass = "thieplv1211";
		String sendFrom = "thiep.levan@olbius.vn";
		String subject = "Thư thông báo";
		//Create RecruitmentTestResult
		String recruitmentTestResultId = delegator.getNextSeqId("RecruitmentTestResult");
		GenericValue recruitmentTestResult = delegator.makeValue("RecruitmentTestResult");
		recruitmentTestResult.set("recruitmentTestResultId", recruitmentTestResultId);
		recruitmentTestResult.set("recruitmentTestResultTypeId", "RESULT_EXAM");
		recruitmentTestResult.set("resultId", resultId);
		recruitmentTestResult.create();
		
		//Create RecruitmentExamResult
		GenericValue recruitmentExamResult = delegator.makeValue("RecruitmentExamResult");
		recruitmentExamResult.set("recruitmentTestResultId", recruitmentTestResultId);
		recruitmentExamResult.set("score", score);
		recruitmentExamResult.create();
		
		//Create ApplicantTestResult
		GenericValue applicantTestResult = delegator.makeValue("ApplicantTestResult");
		applicantTestResult.set("recruitmentTestResultId", recruitmentTestResultId);
		applicantTestResult.set("partyId", partyId);
		applicantTestResult.set("workEffortId", workEffortId);
		
		applicantTestResult.create();
		
		
		GenericValue workEffortPartyAss = delegator.findOne("WorkEffortPartyAssignment", false, UtilMisc.toMap("workEffortId", workEffortId, "partyId", partyId, "fromDate", fromDate, "roleTypeId", roleTypeId));
		
		
		if("PASS".equals(resultId)){
			//Update WorkEffortPartyAssignment
			workEffortPartyAss.put("statusId", "PA_PASS");
			workEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			workEffortPartyAss.store();
			
			//Move Applicant to following step
			EntityCondition condition1 = EntityCondition.makeCondition("workEffortParentId", parentWorkEffortId);
			EntityCondition condition2 = EntityCondition.makeCondition("workEffortTypeId", "RECR_REVIEW1");
			List<GenericValue> workEffortList = delegator.findList("WorkEffort", EntityCondition.makeCondition(condition1, condition2), UtilMisc.toSet("workEffortId"), null, null, false);
			Map<String, Object> ctx = FastMap.newInstance();
			ctx.put("userLogin", context.get("userLogin"));
			ctx.put("locale", context.get("locale"));
			ctx.put("partyId", partyId);
			if(workEffortList != null && !workEffortList.isEmpty()){
				if(workEffortList.size() == 1){
					String workEffortIdTemp = workEffortList.get(0).getString("workEffortId");
					ctx.put("workEffortId", workEffortIdTemp);
				}else {
					throw new Exception("More than one first interview step");
				}
			}else{
				throw new Exception("First Interview is not exist in this plan");
			}
			ctx.put("roleTypeId", "APPLICANT");
			ctx.put("assignedByUserLoginId", ((GenericValue)ctx.get("userLogin")).getString("partyId"));
			ctx.put("statusId", "PA_ASSIGNED");
			ctx.put("fromDate", new Timestamp(new Date().getTime()));
			
			localDispt.runSync("assignApplicantToRecruitmentTest", ctx);
			//update email body
			bodyParameters.put("result", "Chúng tôi xin vui mừng thông báo bạn đã qua đợt " + workEffort.getString("description").toLowerCase());
		}else{
			//Update WorkEffortPartyAssignment
			workEffortPartyAss.put("statusId", "PA_FAIL");
			workEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			workEffortPartyAss.store();
			
			//update email body
			bodyParameters.put("result", "Chúng tôi rất lấy làm tiếc thông báo bạn đã không qua đợt " + workEffort.getString("description").toLowerCase());
			
			GenericValue parentWorkEffortPartyAss = delegator.findOne("WorkEffortPartyAssignment", false, UtilMisc.toMap("workEffortId", parentWorkEffortId, "partyId", partyId, "fromDate", parentFromDate, "roleTypeId", parentRoleTypeId));
			parentWorkEffortPartyAss.put("statusId", "PA_FAIL");
			parentWorkEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			parentWorkEffortPartyAss.store();
			mapTmp.put("delegator", delegator);
			mapTmp.put("workEffortId", workEffortId);
		}
		emailCtx.put("userLogin", context.get("userLogin"));
		emailCtx.put("locale", context.get("locale"));
		emailCtx.put("sendTo", sendTo);
		emailCtx.put("partyIdTo", partyId);
		emailCtx.put("bodyParameters", bodyParameters);
		emailCtx.put("authUser", authUser);
		emailCtx.put("authPass", authPass);
		emailCtx.put("sendFrom", sendFrom);
		emailCtx.put("subject", subject);
		emailCtx.put("emailTemplateSettingId", "APP_NOTI");
		localDispt.runAsync("sendMailFromTemplateSetting", emailCtx);
		
		mapTmp.put("delegator", delegator);
		mapTmp.put("workEffortId", workEffortId);
		notifyObserver();
	}

}
