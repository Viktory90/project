package com.olbius.recruitment.helper;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Map;

import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;

public class SecondIntvRating extends Observable{
	public  void rateSecondInterview(DispatchContext dpctx,
			Map<String, ? extends Object> context) throws Exception{
		
		//Delegator
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
		String face = (String)context.get("face");
		String figure = (String)context.get("figure");
		String voice = (String)context.get("voice");
		String communication = (String)context.get("communication");
		String confidence = (String)context.get("confidence");
		String circumstance = (String)context.get("circumstance");
		String agility = (String)context.get("agility");
		String logic = (String)context.get("logic");
		String answer = (String)context.get("answer");
		String honest = (String)context.get("honest");
		String experience = (String)context.get("experience");
		String expertise = (String)context.get("expertise");
		String workChangeId = (String)context.get("workChangeId");
		String parentBackgroundId = (String)context.get("parentBackgroundId");
		String siblingBackgroundId = (String)context.get("siblingBackgroundId");
		String spousesBackgroundId = (String)context.get("spousesBackgroundId");
		String childBackgroundId = (String)context.get("childBackgroundId");
		String uniCertificateId = (String)context.get("uniCertificateId");
		String itCertificateId = (String)context.get("itCertificateId");
		String engCertificateId = (String)context.get("engCertificateId");
		String teamWorkId = (String)context.get("teamWorkId");
		String aloneWorkId = (String)context.get("aloneWorkId");
		String currentSal = (String)context.get("currentSal");
		String proposeSal = (String)context.get("proposeSal");
		String genaralRate = (String)context.get("genaralRate");
		String propose = (String)context.get("propose");
		
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
		recruitmentTestResult.set("recruitmentTestResultTypeId", "RESULT_INTERVIEW");
		recruitmentTestResult.set("resultId", resultId);
		recruitmentTestResult.create();
		
		//Create RecruitmentInterviewResult
		GenericValue recruitmentInterviewResult = delegator.makeValue("RecruitmentInterviewResult");
		recruitmentInterviewResult.set("recruitmentTestResultId", recruitmentTestResultId);
		recruitmentInterviewResult.set("face", face);
		recruitmentInterviewResult.set("figure", figure);
		recruitmentInterviewResult.set("voice", voice);
		recruitmentInterviewResult.set("communication", communication);
		recruitmentInterviewResult.set("confidence", confidence);
		recruitmentInterviewResult.set("circumstance", circumstance);
		recruitmentInterviewResult.set("agility", agility);
		recruitmentInterviewResult.set("logic", logic);
		recruitmentInterviewResult.set("answer", answer);
		recruitmentInterviewResult.set("honest", honest);
		recruitmentInterviewResult.set("experience", experience);
		recruitmentInterviewResult.set("expertise", expertise);
		recruitmentInterviewResult.set("workChangeId", workChangeId);
		recruitmentInterviewResult.set("parentBackgroundId", parentBackgroundId);
		recruitmentInterviewResult.set("siblingBackgroundId", siblingBackgroundId);
		recruitmentInterviewResult.set("spousesBackgroundId", spousesBackgroundId);
		recruitmentInterviewResult.set("childBackgroundId", childBackgroundId);
		recruitmentInterviewResult.set("uniCertificateId", uniCertificateId);
		recruitmentInterviewResult.set("itCertificateId", itCertificateId);
		recruitmentInterviewResult.set("engCertificateId", engCertificateId);
		recruitmentInterviewResult.set("teamWorkId", teamWorkId);
		recruitmentInterviewResult.set("aloneWorkId", aloneWorkId);
		recruitmentInterviewResult.set("currentSal", currentSal);
		recruitmentInterviewResult.set("proposeSal", proposeSal);
		recruitmentInterviewResult.set("genaralRate", genaralRate);
		recruitmentInterviewResult.set("propose", propose);
		recruitmentInterviewResult.create();
		
		//Create ApplicantTestResult
		GenericValue applicantTestResult = delegator.makeValue("ApplicantTestResult");
		applicantTestResult.set("recruitmentTestResultId", recruitmentTestResultId);
		applicantTestResult.set("partyId", partyId);
		applicantTestResult.set("workEffortId", workEffortId);
		applicantTestResult.create();
		
		GenericValue workEffortPartyAss = delegator.findOne("WorkEffortPartyAssignment", false, UtilMisc.toMap("workEffortId", workEffortId, "partyId", partyId, "fromDate", fromDate, "roleTypeId", roleTypeId));
		
		GenericValue parentWorkEffortPartyAss = delegator.findOne("WorkEffortPartyAssignment", false, UtilMisc.toMap("workEffortId", parentWorkEffortId, "partyId", partyId, "fromDate", parentFromDate, "roleTypeId", roleTypeId));
		if("PASS".equals(resultId)){
			//Update WorkEffortPartyAssignment
			workEffortPartyAss.put("statusId", "PA_PASS");
			workEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			workEffortPartyAss.store();
			//Update All Plan
			parentWorkEffortPartyAss.put("statusId", "PA_PASS");
			parentWorkEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			parentWorkEffortPartyAss.store();
			
			//update email body
			bodyParameters.put("result", "Chúng tôi xin vui mừng thông báo bạn đã qua đợt " + workEffort.getString("description").toLowerCase() + "Và mời bạn sớm đến nhận thử việc");
		}else{
			//Update WorkEffortPartyAssignment
			workEffortPartyAss.put("statusId", "PA_FAIL");
			workEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			workEffortPartyAss.store();
			
			//Update All Plan
			parentWorkEffortPartyAss.put("statusId", "PA_FAIL");
			parentWorkEffortPartyAss.put("thruDate", new Timestamp(new Date().getTime()));
			parentWorkEffortPartyAss.store();
			
			//update email body
			bodyParameters.put("result", "Chúng tôi rất lấy làm tiếc thông báo bạn đã không qua đợt " + workEffort.getString("description").toLowerCase());
			
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
