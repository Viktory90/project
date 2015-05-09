package com.olbius.recruitment.helper;

import java.util.Map;

import javolution.util.FastMap;

import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;

public class WorkTrialReportHelper {
	public static String createWorkTrialReport(DispatchContext dpctx, Map<String, ? extends Object> context) throws GenericEntityException{
		//Get delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get parameters
		String partyId = (String)context.get("partyId");
		String eduProcess = (String)context.get("eduProcess");
		String workResult = (String)context.get("workResult");
		String advAndDis = (String)context.get("advAndDis");
		String workOrientation =(String)context.get("workOrientation");
		String workProposal = (String)context.get("workProposal");
		String policyProposal = (String)context.get("policyProposal");
		String eduProposal = (String)context.get("eduProposal");
		String ruleComplianceSeft = (String)context.get("ruleComplianceSeft");
		String complWorkRateSeft = (String)context.get("complWorkRateSeft");
		String interCommunicationSeft = (String)context.get("interCommunicationSeft");
		String learningCapabilitySeft = (String) context.get("learningCapabilitySeft");
		String exterCommunicationSeft = (String)context.get("exterCommunicationSeft");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		
		//Create WorkTrialReport
		String workTrialReportId = delegator.getNextSeqId("WorkTrialReport");
		GenericValue workTrialReport = delegator.makeValue("WorkTrialReport");
		workTrialReport.set("workTrialReportId", workTrialReportId);
		workTrialReport.set("partyId", partyId);
		workTrialReport.set("eduProcess", eduProcess);
		workTrialReport.set("workResult", workResult);
		workTrialReport.set("advAndDis", advAndDis);
		workTrialReport.set("workOrientation", workOrientation);
		workTrialReport.set("policyProposal", policyProposal);
		workTrialReport.set("workProposal", workProposal);
		workTrialReport.set("eduProposal", eduProposal);
		workTrialReport.create();
		
		//Create WorkTrialRating
		GenericValue workTrialRating = delegator.makeValue("WorkTrialRating");
		String workTrialRatingId = delegator.getNextSeqId("WorkTrialRating");
		workTrialRating.put("workTrialRatingId", workTrialRatingId);
		workTrialRating.put("workTrialReportId", workTrialReportId);
		workTrialRating.put("partyId", userLogin.getString("partyId"));
		workTrialRating.put("workTrialRatingTypeId", "SELF_RATING");
		workTrialRating.create();
		
		//Create WorkTrialSelfRating
		GenericValue workTrialSelfRating = delegator.makeValue("WorkTrialSelfRating");
		workTrialSelfRating.set("workTrialRatingId", workTrialRatingId);
		workTrialSelfRating.set("ruleCompliance", ruleComplianceSeft);
		workTrialSelfRating.set("complWorkRate", complWorkRateSeft);
		workTrialSelfRating.set("interCommunication", interCommunicationSeft);
		workTrialSelfRating.set("learningCapability", learningCapabilitySeft);
		workTrialSelfRating.set("exterCommunication", exterCommunicationSeft);
		workTrialSelfRating.create();
		
		return workTrialReportId;
	}
	
	public static void rateLeaderWorkTrial(DispatchContext dpctx, Map<String, ? extends Object> context) throws GenericEntityException, GenericServiceException{
		//Get context
		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher dispatcher = dpctx.getDispatcher();
		//Get parameters
		String ruleComplianceLeader = (String)context.get("ruleComplianceLeader");
		String complWorkRateLeader = (String)context.get("complWorkRateLeader");
		String interCommunicationLeader = (String)context.get("interCommunicationLeader");
		String learningCapabilityLeader = (String) context.get("learningCapabilityLeader");
		String exterCommunicationLeader = (String)context.get("exterCommunicationLeader");
		String workTrialReportId = (String)context.get("workTrialReportId");
		String assignedTask = (String)context.get("assignedTask");
		String futureEdu = (String)context.get("futureEdu");
		String requiredOther = (String)context.get("requiredOther");
		String resultId = (String) context.get("resultId");
		Long extTime = (Long)context.get("extTime");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		
		//Create WorkTrialRating
		GenericValue workTrialRating = delegator.makeValue("WorkTrialRating");
		String workTrialRatingId = delegator.getNextSeqId("WorkTrialRating");
		workTrialRating.put("workTrialRatingId", workTrialRatingId);
		workTrialRating.put("workTrialReportId", workTrialReportId);
		workTrialRating.put("partyId", userLogin.getString("partyId"));
		workTrialRating.put("workTrialRatingTypeId", "LEADER_RATING");
		workTrialRating.create();
		
		//Create WorkTrialLeaderRating
		GenericValue workTrialLeaderRating = delegator.makeValue("WorkTrialLeaderRating");
		workTrialLeaderRating.set("workTrialRatingId", workTrialRatingId);
		workTrialLeaderRating.set("ruleCompliance", ruleComplianceLeader);
		workTrialLeaderRating.set("complWorkRate", complWorkRateLeader);
		workTrialLeaderRating.set("interCommunication", interCommunicationLeader);
		workTrialLeaderRating.set("learningCapability", learningCapabilityLeader);
		workTrialLeaderRating.set("exterCommunication", exterCommunicationLeader);
		workTrialLeaderRating.set("assignedTask", assignedTask);
		workTrialLeaderRating.set("requiredOther", requiredOther);
		workTrialLeaderRating.set("futureEdu", futureEdu);
		workTrialLeaderRating.set("resultId", resultId);
		workTrialLeaderRating.set("extTime", extTime);
		workTrialLeaderRating.create();
		
		//Turn off noti
		String ntfId = (String)context.get("ntfId");
		Map<String, Object> updateNotifyCtx = FastMap.newInstance();
		updateNotifyCtx.put("ntfId", ntfId);
		updateNotifyCtx.put("userLogin", context.get("userLogin"));
		dispatcher.runSync("updateNotification", updateNotifyCtx);
	}
	
	public static void rateHRMWorkTrial(DispatchContext dpctx, Map<String, ? extends Object> context) throws GenericEntityException, GenericServiceException{
		//Get context
		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher dispatcher = dpctx.getDispatcher();
		//Get parameters
		String workTrialReportId = (String)context.get("workTrialReportId");
		String resultId = (String) context.get("resultId");
		Long extTime = (Long)context.get("extTime");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		
		//Create WorkTrialRating
		GenericValue workTrialRating = delegator.makeValue("WorkTrialRating");
		String workTrialRatingId = delegator.getNextSeqId("WorkTrialRating");
		workTrialRating.put("workTrialRatingId", workTrialRatingId);
		workTrialRating.put("workTrialReportId", workTrialReportId);
		workTrialRating.put("partyId", userLogin.getString("partyId"));
		workTrialRating.put("workTrialRatingTypeId", "HRM_RATING");
		workTrialRating.create();
		
		//Create WorkTrialLeaderRating
		GenericValue workTrialHrmRating = delegator.makeValue("WorkTrialHrmRating");
		workTrialHrmRating.set("workTrialRatingId", workTrialRatingId);
		workTrialHrmRating.set("resultId", resultId);
		workTrialHrmRating.set("extTime", extTime);
		workTrialHrmRating.create();
		
		//Turn off noti
		String ntfId = (String)context.get("ntfId");
		Map<String, Object> updateNotifyCtx = FastMap.newInstance();
		updateNotifyCtx.put("ntfId", ntfId);
		updateNotifyCtx.put("userLogin", context.get("userLogin"));
		dispatcher.runSync("updateNotification", updateNotifyCtx);
	}
	
	public static void rateCEOWorkTrial(DispatchContext dpctx, Map<String, ? extends Object> context) throws GenericEntityException, GenericServiceException{
		//Get context
		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher dispatcher = dpctx.getDispatcher();
		//Get parameters
		String workTrialReportId = (String)context.get("workTrialReportId");
		String resultId = (String) context.get("resultId");
		Long extTime = (Long)context.get("extTime");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		
		//Create WorkTrialRating
		GenericValue workTrialRating = delegator.makeValue("WorkTrialRating");
		String workTrialRatingId = delegator.getNextSeqId("WorkTrialRating");
		workTrialRating.put("workTrialRatingId", workTrialRatingId);
		workTrialRating.put("workTrialReportId", workTrialReportId);
		workTrialRating.put("partyId", userLogin.getString("partyId"));
		workTrialRating.put("workTrialRatingTypeId", "CEO_RATING");
		workTrialRating.create();
		
		//Create WorkTrialLeaderRating
		GenericValue workTrialCeoRating = delegator.makeValue("WorkTrialCeoRating");
		workTrialCeoRating.set("workTrialRatingId", workTrialRatingId);
		workTrialCeoRating.set("resultId", resultId);
		workTrialCeoRating.set("extTime", extTime);
		workTrialCeoRating.create();
		
		//Turn off noti
		String ntfId = (String)context.get("ntfId");
		Map<String, Object> updateNotifyCtx = FastMap.newInstance();
		updateNotifyCtx.put("ntfId", ntfId);
		updateNotifyCtx.put("userLogin", context.get("userLogin"));
		dispatcher.runSync("updateNotification", updateNotifyCtx);
	}
}
