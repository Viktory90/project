package com.olbius.recruitment.helper;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;

import com.olbius.util.PartyUtil;

public class WorkTrialHelper {
	
	@SuppressWarnings("unchecked")
	public static String createWorkTrialProposal(DispatchContext dpctx, Map<String, ? extends Object> context) throws Exception{
		//Get Delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get parameters
		String workingPartyId = (String)context.get("workingPartyId");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		Double salary = (Double)context.get("salary");
		String allowance = (String)context.get("allowance");
		Double trialSalaryRate = (Double)context.get("trialSalaryRate");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		Long trialTime = (Long)context.get("trialTime");
		String description = (String)context.get("description");
		List<String> applicantIdList = FastList.newInstance();
		if(context.get("applicantIdList") instanceof List<?>){
			applicantIdList = (List<String>)context.get("applicantIdList");
		}else {
			throw new Exception("applicantIdList is not a List");
		}
		
		//Create Seq
		String workTrialProposalId = (String)delegator.getNextSeqId("WorkTrialProposal");
		
		//Create WorkTrialProposal
		GenericValue workTrial = delegator.makeValue("WorkTrialProposal");
		workTrial.set("workTrialProposalId", workTrialProposalId);
		workTrial.set("workingPartyId", workingPartyId);
		workTrial.set("emplPositionTypeId", emplPositionTypeId);
		workTrial.set("salary", salary);
		workTrial.set("allowance", allowance);
		workTrial.set("trialSalaryRate", trialSalaryRate);
		workTrial.set("fromDate", fromDate);
		workTrial.set("trialTime", trialTime);
		workTrial.set("description", description);
		workTrial.set("statusId", "IWT_INIT");
		
		workTrial.create();
		
		//Create Applicant for Proposal
		for(String el : applicantIdList){
			GenericValue workTrialApplicant = delegator.makeValue("WorkTrialApplicant");
			workTrialApplicant.set("workTrialProposalId", workTrialProposalId);
			workTrialApplicant.set("applicantId", el);
			workTrialApplicant.create();
		}
		return workTrialProposalId;
	}
	
	@SuppressWarnings("unchecked")
	public static String approveWorkTrialProposal(DispatchContext dpctx, Map<String, ? extends Object> context) throws Exception{
		//Get Email Account
		String authUser = UtilProperties.getPropertyValue("general", "mail.smtp.auth.user");
		String authPass = UtilProperties.getPropertyValue("general", "mail.smtp.auth.password");
		
		//Get Delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get LocalDis
		LocalDispatcher dispatcher = dpctx.getDispatcher();
		
		//Get parameters
		String workTrialProposalId = (String)context.get("workTrialProposalId");
		String statusId = (String)context.get("statusId");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		
		//Turn off Approval Notification 
		String ntfId = (String)context.get("ntfId");
		Map<String, Object> updateNotifyCtx = FastMap.newInstance();
		updateNotifyCtx.put("ntfId", ntfId);
		updateNotifyCtx.put("userLogin", context.get("userLogin"));
		dispatcher.runSync("updateNotification", updateNotifyCtx);
		
		//Update work trial proposal
		GenericValue workTrial = delegator.findOne("WorkTrialProposal", false, UtilMisc.toMap("workTrialProposalId", workTrialProposalId));
		workTrial.put("statusId", statusId);
		workTrial.store();
		//send Notification
		String targetLink = "workTrialProposalId="+workTrialProposalId;
		String header = "Đã phê duyệt đề xuất thử việc mã [" + workTrialProposalId + "]";
		String action = "FindWorkTrialProposal";
		String notiToId = PartyUtil.getHrmAdmin(delegator);
		String state = "open";
		Timestamp dateTime = new Timestamp(new Date().getTime());
		
		Map<String, Object> notiCtx = FastMap.newInstance();
		notiCtx.put("targetLink", targetLink);
		notiCtx.put("partyId", notiToId);
		notiCtx.put("header", header);
		notiCtx.put("state", state);
		notiCtx.put("dateTime", dateTime);
		notiCtx.put("action", action);
		notiCtx.put("userLogin", userLogin);
		dispatcher.runAsync("createNotification", notiCtx);
		
		if("AWT_APPROVED".equals(statusId)){
			//Send email to invite work trial
			List<String> applicantList = (List<String>)context.get("applicantList");
			for(String item: applicantList){
				Map<String, Object> emailCtx = FastMap.newInstance();
				Map<String, Object> email = dispatcher.runSync("getPartyEmail", UtilMisc.toMap("partyId", item, "userLogin", context.get("userLogin")));
			
				emailCtx.put("sendTo", email.get("emailAddress"));
				emailCtx.put("partyIdTo", item);
				emailCtx.put("emailTemplateSettingId", "TRIAL_INVIT");
				Map<String, Object> bodyParameters = FastMap.newInstance();
				bodyParameters.put("partyId", item);
				bodyParameters.put("workingPartyId", context.get("workingPartyId"));
				bodyParameters.put("emplPositionTypeId", context.get("emplPositionTypeId"));
				bodyParameters.put("salary", context.get("salary"));
				bodyParameters.put("allowance", context.get("allowance"));
				bodyParameters.put("trialSalaryRate", context.get("trialSalaryRate"));
				bodyParameters.put("fromDate", context.get("fromDate"));
				bodyParameters.put("trialTime", context.get("trialTime"));
				emailCtx.put("bodyParameters", bodyParameters);
				//FIXME FIX EMAIL
				emailCtx.put("subject", "Thư mời thử việc");
				emailCtx.put("sendFrom", authUser);
				emailCtx.put("authPass", authPass);
				emailCtx.put("authUser", authUser);
				emailCtx.put("userLogin", context.get("userLogin"));
				dispatcher.runAsync("sendMailFromTemplateSetting", emailCtx);
				
				//Create Full Employment
				Map<String, Object> fullEmploymentCtx = FastMap.newInstance();
				fullEmploymentCtx.put("partyIdFrom", context.get("workingPartyId"));
				fullEmploymentCtx.put("partyIdTo", item);
				fullEmploymentCtx.put("fromDate", context.get("fromDate"));
				fullEmploymentCtx.put("salary", context.get("salary"));
				fullEmploymentCtx.put("allowance", context.get("allowance"));
				fullEmploymentCtx.put("trialSalaryRate", context.get("trialSalaryRate"));
				Timestamp fromDate = (Timestamp)context.get("fromDate");
				Calendar cal = Calendar.getInstance();
				cal.setTime(fromDate);
				cal.add(Calendar.MONTH, ((Long)context.get("trialTime")).intValue());
				Timestamp thruDate = new Timestamp(cal.getTimeInMillis());
				fullEmploymentCtx.put("thruDate", thruDate);
				fullEmploymentCtx.put("emplPositionTypeId", context.get("emplPositionTypeId"));
				fullEmploymentCtx.put("userLogin", userLogin);
				dispatcher.runAsync("createFullEmployment", fullEmploymentCtx);
				
			}
		}
		return workTrialProposalId;
	}
}
