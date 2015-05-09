package com.olbius.recruitment.services;


import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

import org.joda.time.DateTime;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GeneralServiceException;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

import com.olbius.employee.services.EmployeeServices;
import com.olbius.recruitment.RecruitmentDataPreparation;
import com.olbius.recruitment.helper.ApplicantServiceHelper;
import com.olbius.recruitment.helper.JobRequestHelper;
import com.olbius.recruitment.helper.RecruitmentPlanServiceHelper;
import com.olbius.recruitment.helper.RecruitmentTestPlanHelper;
import com.olbius.recruitment.helper.WorkTrialHelper;
import com.olbius.recruitment.helper.WorkTrialReportHelper;
import com.olbius.util.PartyUtil;

public class RecruitmentServices {
	
	public static final String module = EmployeeServices.class.getName();
	public static final String resource = "hrolbiusUiLabels";
	public static final String resourceNoti = "NotificationUiLabels";

	public static Map<String, Object> createApplicant(DispatchContext dpctx,
			Map<String, Object> context) {
		//Delegator delegator = dpctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String partyId = null;
		//context.put("partyId", partyId);
		Map<String, Object> retMap = FastMap.newInstance();
		try {
			partyId = ApplicantServiceHelper.insertApplicant(dpctx, context);
			ApplicantServiceHelper.insertEmplApplication(dpctx, context);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(
					resourceNoti, "createError",
					new Object[] { e.getMessage() }, locale));
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		retMap.put("partyId", partyId);
		return retMap;
	}

	/**
	 * Create Recruitment Plan Header
	 * Init status is RPH_INIT
	 */

	public static Map<String, Object> createRecruitmentPlanHeader(DispatchContext dpctx, Map<String, Object> context) {
		//Get delegator
		Delegator delegator = dpctx.getDelegator();

		//Get parameters
		String partyId = (String)context.get("partyId");
		String year = (String)context.get("year");
		String reason = (String)context.get("reason");
		Timestamp scheduleDate = (Timestamp)context.get("scheduleDate");
		Locale locale = (Locale)context.get("locale");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String statusId = "RPH_INIT";
		if(PartyUtil.isAdmin(userLogin.getString("partyId"), delegator)){
			//If userLogin is HRM Admin
			statusId = "RPH_ACCEPTED";
		}
		
		//Create entity
		GenericValue recruitmentPlanHeader = delegator.makeValue("RecruitmentPlanHeader");
		recruitmentPlanHeader.put("partyId", partyId);
		recruitmentPlanHeader.put("year", year);
		recruitmentPlanHeader.put("scheduleDate", scheduleDate);
		recruitmentPlanHeader.put("reason", reason);
		recruitmentPlanHeader.put("statusId", statusId);
		try {
			recruitmentPlanHeader.create();
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[] { e.getMessage() }, locale));
		}

		//Create Status
		GenericValue rphStatus = delegator.makeValue("RecruitmentPlanStatus");
		String seqId = delegator.getNextSeqId("RecruitmentPlanStatus");
		rphStatus.put("recruitmentPlanStatusId", seqId);
		rphStatus.put("reason", reason);
		rphStatus.put("partyId", partyId);
		rphStatus.put("year", year);
		rphStatus.put("statusId", statusId);
		rphStatus.put("createDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
		rphStatus.put("statusUserLogin", userLogin.getString("partyId"));

		try {
			rphStatus.create();
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[] { e.getMessage() }, locale));
		}

		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("partyId", partyId);
		result.put("year", year);
		return result;
	}
	
	public static Map<String, Object> rateExam(DispatchContext dpctx, Map<String, ? extends Object> context){
		
		//Get locale
		Locale locale = (Locale)context.get("locale");
		
		try {
			RecruitmentTestPlanHelper.rateExam(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
		}
		
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "rateSuccessfully", locale));
	}
	
	public static Map<String, Object> rateFirstInterview(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		try {
			RecruitmentTestPlanHelper.rateFirstInterview(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "rateSuccessfully", locale));
	}
	
	public static Map<String, Object> rateSecondInterview(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		try {
			RecruitmentTestPlanHelper.rateSecondInterview(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "rateSuccessfully", locale));
	}
	
	public static Map<String, Object> createWorkTrialProposal(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		
		//Get Delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Create Result Map
		Map<String, Object> result = FastMap.newInstance();
		String workTrialProposalId = null;
		String targetLink = null;
		String header = null;
		String action = "ApproveWorkTrialProposal";
		String notiToId = null;
		String state = "open";
		Timestamp dateTime = new Timestamp(new Date().getTime());
		try {
			workTrialProposalId = WorkTrialHelper.createWorkTrialProposal(dpctx, context);
			GenericValue workEffort = delegator.findOne("WorkEffort", UtilMisc.toMap("workEffortId", context.get("workEffortId")), false);
			workEffort.put("currentStatusId", "RTP_CLOSED");
			workEffort.store();
			targetLink = "workTrialProposalId="+workTrialProposalId;
			header = UtilProperties.getMessage(resourceNoti, "ApproveProposeWorkTrialNtfHeader", locale) + "[" + workTrialProposalId + "]";
			notiToId = PartyUtil.getCEO(delegator);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
		result.put("targetLink", targetLink);
		result.put("header", header);
		result.put("action", action);
		result.put("notiToId", notiToId);
		result.put("state", state);
		result.put("dateTime",dateTime);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> approveWorkTrialProposal(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		
		//Get Delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Create Result Map
		Map<String, Object> result = FastMap.newInstance();
		
		try {
			WorkTrialHelper.approveWorkTrialProposal(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "updateError", new Object[]{e.getMessage()}, locale));
		}
		
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "updateSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> createWorkTrialReport(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		String workTrialReportId = null;
		
		//Get delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get parameters
		String employeeId = (String)context.get("partyId");
		try {
			workTrialReportId = WorkTrialReportHelper.createWorkTrialReport(dpctx, context);
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
		Map<String, Object> result = FastMap.newInstance();
		result.put("header", UtilProperties.getMessage(resourceNoti, "RateWorkTrialReportNtfHeader", locale) + " [" + workTrialReportId +"]");
		result.put("action", "RateLeaderWorkTrial");
		result.put("targetLink", "workTrialReportId=" + workTrialReportId);
		result.put("dateTime", new Timestamp(new Date().getTime()));
		result.put("state", "open");
		try {
			result.put("notiToId", PartyUtil.getManagerOfEmpl(delegator, employeeId));
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> rateLeaderWorkTrial(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		
		//Get delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get localdispatcher
		LocalDispatcher localDispatcher = dpctx.getDispatcher();
		
		//Get parameters
		String hrmId;
		String resultId = (String)context.get("resultId");
		try {
			hrmId = PartyUtil.getHrmAdmin(delegator);
		} catch (Exception e1) {
			Debug.log(e1.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e1.getMessage()}, locale));
		}
		String workTrialReportId = (String)context.get("workTrialReportId");
		try {
			WorkTrialReportHelper.rateLeaderWorkTrial(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
		}
		if(!resultId.equals("WTR_ACCEPTED")){
			Map<String, Object> notiHrmCtx = FastMap.newInstance();
		
			//Send Notification for Employee Trial
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "ResultRateWorkTrialReportNtfHeader", locale) + "[" + workTrialReportId + "]");
			GenericValue workTrialReport = null;
			try {
				workTrialReport = delegator.findOne("WorkTrialReport", false, UtilMisc.toMap("workTrialReportId", context.get("workTrialReportId")));
			} catch (GenericEntityException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.put("partyId", workTrialReport.get("partyId"));
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			notiHrmCtx.put("action", "WorkTrialLeaderRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.clear();
		
			//Send Notification for HRM 
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "ResultRateWorkTrialReportNtfHeader", locale) + "[" + workTrialReportId + "]");
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			notiHrmCtx.put("partyId", hrmId);
			notiHrmCtx.put("action", "WorkTrialLeaderRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
		}
		Map<String, Object> result = FastMap.newInstance();
		result.put("header", UtilProperties.getMessage(resourceNoti, "RateWorkTrialReportNtfHeader", locale) + "[" + workTrialReportId + "]");
		result.put("action", "RateHRMWorkTrial");
		result.put("targetLink", "workTrialReportId=" + workTrialReportId);
		result.put("dateTime", new Timestamp(new Date().getTime()));
		result.put("state", "open");
		result.put("notiToId", hrmId);
		result.put("resultId", resultId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "rateSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> rateHRMWorkTrial(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		
		//Get delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get LocalDispatcher
		LocalDispatcher localDispatcher = dpctx.getDispatcher();
		
		//Get parameters
		String ceoId;
		String resultId = (String)context.get("resultId");
		try {
			ceoId = PartyUtil.getCEO(delegator);
		} catch (Exception e1) {
			Debug.log(e1.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e1.getMessage()}, locale));
		}
		String workTrialReportId = (String)context.get("workTrialReportId");
		try {
			WorkTrialReportHelper.rateHRMWorkTrial(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
		}
		
		if(!resultId.equals("WTR_ACCEPTED")){
			Map<String, Object> notiHrmCtx = FastMap.newInstance();
		
			//Send Notification for Employee Trial
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "ResultRateWorkTrialReportNtfHeader", locale) + "[" + workTrialReportId + "]");
			GenericValue workTrialReport = null;
			try {
				workTrialReport = delegator.findOne("WorkTrialReport", false, UtilMisc.toMap("workTrialReportId", context.get("workTrialReportId")));
			} catch (GenericEntityException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.put("partyId", workTrialReport.get("partyId"));
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			notiHrmCtx.put("action", "WorkTrialHRMRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.clear();
		
			//Send Notification for Leader 
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "ResultRateWorkTrialReportNtfHeader", locale) + "[" + workTrialReportId + "]");
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			try {
				notiHrmCtx.put("partyId", PartyUtil.getManagerbyOrg((String)context.get("partyIdFrom"), delegator));
			} catch (Exception e1) {
				Debug.log(e1.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e1.getMessage()}, locale));
			}
			notiHrmCtx.put("action", "WorkTrialHRMRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("header", UtilProperties.getMessage(resourceNoti, "RateWorkTrialReportNtfHeader", locale) + "[" + workTrialReportId + "]");
		result.put("action", "RateCEOWorkTrial");
		result.put("targetLink", "workTrialReportId=" + workTrialReportId);
		result.put("dateTime", new Timestamp(new Date().getTime()));
		result.put("state", "open");
		result.put("notiToId", ceoId);
		result.put("resultId", resultId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "rateSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> rateCEOWorkTrial(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get locale
		Locale locale = (Locale)context.get("locale");
		
		//Get delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get LocalDispatcher
		LocalDispatcher localDispatcher = dpctx.getDispatcher();
		//Get parameters
		String hrmId;
		String resultId = (String)context.get("resultId");
		try {
			hrmId = PartyUtil.getHrmAdmin(delegator);
		} catch (Exception e1) {
			Debug.log(e1.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e1.getMessage()}, locale));
		}
		String workTrialReportId = (String)context.get("workTrialReportId");
		try {
			WorkTrialReportHelper.rateCEOWorkTrial(dpctx, context);
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
		}
			
			Map<String, Object> notiHrmCtx = FastMap.newInstance();
		
			//Send Notification for Employee Trial 
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "RateWorkTrialReportNtfHeader", locale));
			GenericValue workTrialReport = null;
			try {
				workTrialReport = delegator.findOne("WorkTrialReport", false, UtilMisc.toMap("workTrialReportId", context.get("workTrialReportId")));
			} catch (GenericEntityException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.put("partyId", workTrialReport.get("partyId"));
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			notiHrmCtx.put("action", "WorkTrialCeoRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.clear();
		
			//Send Notification for leader 
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "RateWorkTrialReportNtfHeader", locale));
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			try {
				notiHrmCtx.put("partyId", PartyUtil.getManagerbyOrg((String)context.get("partyIdFrom"), delegator));
			} catch (Exception e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.put("action", "WorkTrialCeoRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
		
			//Send Notification for hrm 
			notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "RateWorkTrialReportNtfHeader", locale));
			notiHrmCtx.put("userLogin", context.get("userLogin"));
			try {
				notiHrmCtx.put("partyId", PartyUtil.getHrmAdmin(delegator));
			} catch (Exception e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			notiHrmCtx.put("action", "WorkTrialCeoRateResult");
			notiHrmCtx.put("targetLink", "workTrialReportId=" + workTrialReportId);
			notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
			notiHrmCtx.put("state", "open");
			try {
				localDispatcher.runSync("createNotification", notiHrmCtx);
			} catch (GenericServiceException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "rateError", new Object[]{e.getMessage()}, locale));
			}
			
		Map<String, Object> result = FastMap.newInstance();
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "rateSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> createNtfToApprover(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Long year = (Long) context.get("year");
		//String statusId = (String) context.get("statusId");
		String ntfClose = (String) context.get("ntfIdClose");
		Locale locale = (Locale) context.get("locale");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Set<String> partyIdSet = FastSet.newInstance();
		try {
			if(UtilValidate.isNotEmpty(ntfClose)){
				dispatcher.runSync("updateNotification", UtilMisc.toMap("ntfId", ntfClose, "userLogin", context.get("userLogin")));
			}
			List<EntityCondition> conditions = FastList.newInstance();
			conditions.add(EntityCondition.makeCondition("year", year));
			conditions.add(EntityCondition.makeCondition("statusId", EntityOperator.IN, UtilMisc.toList("ARP_APPROVED", "ARP_CANCELED")));
			List<GenericValue> recruitmentPlan = delegator.findList("RecruitmentPlan", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
			for(GenericValue tempGv: recruitmentPlan){
				String mgrId = PartyUtil.getManagerbyOrg(tempGv.getString("partyId"), delegator);
				partyIdSet.add(mgrId);
			}
			String headOfHr = PartyUtil.getHrmAdmin(delegator); 
			partyIdSet.add(headOfHr);
			Map<String, Object> ntfMap = FastMap.newInstance();
			String header = UtilProperties.getMessage("RecruitmentUiLabels", "RecruitmentPlanResult", locale);
			ntfMap.put("header", header);
			ntfMap.put("state", "open");
			ntfMap.put("dateTime", UtilDateTime.nowTimestamp());
			ntfMap.put("action", "RecruitmentPlanApprovalResult");
			ntfMap.put("userLogin", context.get("userLogin"));
			for(String tempPartyId: partyIdSet){
				ntfMap.put("partyId", tempPartyId);
				if(!tempPartyId.equals(headOfHr)){
					ntfMap.put("targetLink", "partyId=" + PartyUtil.getOrgByManager(tempPartyId, delegator) + ";year=" + year);
				}else{
					ntfMap.put("targetLink", "year=" + year);
				}
				
				dispatcher.runSync("createNotification", ntfMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> confirmExtTime(DispatchContext dpctx, Map<String, ? extends Object> context){
		//Get Delegator
		Delegator delegator = dpctx.getDelegator();
		
		//Get LocalDispatcher
		LocalDispatcher localDispatcher = dpctx.getDispatcher();
		
		//Get parameters
		String extTimeConfirm = (String) context.get("extTimeConfirm");
		Locale locale = (Locale)context.get("locale");
		Long extTime = (Long) context.get("extTime");
		String partyId = (String) context.get("partyId");
		String partyIdFrom = (String) context.get("partyIdFrom");
		String workTrialReportId = (String)context.get("workTrialReportId");
		Timestamp fromDate = (Timestamp) context.get("fromDate");
		String resultMess = "";
		if("DONGY".equals(extTimeConfirm)){
			resultMess = UtilProperties.getMessage(resourceNoti, "CommonOk", locale);
			//Get employment
			try {
				GenericValue employment = delegator.findOne("Employment", UtilMisc.toMap("roleTypeIdFrom", "INTERNAL_ORGANIZATIO", "roleTypeIdTo", "EMPLOYEE", "partyIdFrom", partyIdFrom, "partyIdTo", partyId, "fromDate", fromDate), false);
				DateTime tmpTime = new DateTime(fromDate.getTime()).plusMonths(extTime.intValue());
				Timestamp thruDate = new Timestamp(tmpTime.toDate().getTime());
				employment.set("thruDate", thruDate);
				employment.store();
			} catch (GenericEntityException e) {
				Debug.log(e.getMessage(), module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "confirmExtTimeError", new Object[]{e.getMessage()}, locale));
			}
		}else {
			//FIXME Send Email Thank you 
			resultMess = UtilProperties.getMessage(resourceNoti, "CommonNoOk", locale);
		}
		
		//Send Notification for leader
		Map<String, Object> notiLeaderCtx = FastMap.newInstance();
		try {
			notiLeaderCtx.put("partyId", PartyUtil.getManagerbyOrg(partyIdFrom, delegator));
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "confirmExtTimeError", new Object[]{e.getMessage()}, locale));
		}
		notiLeaderCtx.put("header", UtilProperties.getMessage(resourceNoti, "ResultConfirmExtTimeNtfHeader", locale));
		notiLeaderCtx.put("action", "ConfirmExtTimeResult");
		notiLeaderCtx.put("targetLink", "workTrialReportId="+workTrialReportId+";"+"result="+resultMess);
		notiLeaderCtx.put("dateTime", new Timestamp(new Date().getTime()));
		notiLeaderCtx.put("state", "open");
		notiLeaderCtx.put("userLogin", context.get("userLogin"));
		try {
			localDispatcher.runSync("createNotification", notiLeaderCtx);
		} catch (GenericServiceException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "confirmExtTimeError", new Object[]{e.getMessage()}, locale));
		}
		
		//Send notification for Hrm
		
		Map<String, Object> notiHrmCtx = FastMap.newInstance();
		try {
			notiHrmCtx.put("partyId", PartyUtil.getHrmAdmin(delegator));
		} catch (Exception e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "confirmExtTimeError", new Object[]{e.getMessage()}, locale));
		}
		notiHrmCtx.put("header", UtilProperties.getMessage(resourceNoti, "ResultConfirmExtTimeNtfHeader", locale));
		notiHrmCtx.put("action", "ConfirmExtTimeResult");
		notiHrmCtx.put("targetLink", "workTrialReportId="+workTrialReportId+";"+"result="+resultMess);
		notiHrmCtx.put("dateTime", new Timestamp(new Date().getTime()));
		notiHrmCtx.put("state", "open");
		notiHrmCtx.put("userLogin", context.get("userLogin"));
		try {
			localDispatcher.runSync("createNotification", notiHrmCtx);
		} catch (GenericServiceException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "confirmExtTimeError", new Object[]{e.getMessage()}, locale));
		}
		
		//Turn off service
		Map<String, Object> turnOffNtfCtx = FastMap.newInstance();
		turnOffNtfCtx.put("ntfId", context.get("ntfId"));
		turnOffNtfCtx.put("userLogin", context.get("userLogin"));
		try {
			localDispatcher.runSync("updateNotification", turnOffNtfCtx);
		} catch (GenericServiceException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "confirmExtTimeError", new Object[]{e.getMessage()}, locale));
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("workTrialReportId", workTrialReportId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "confirmExtTimeSuccessfully", locale));
		return result;
	}
	
	public static Map<String, Object> createPersonEducation(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		String schoolId = (String)context.get("schoolId");
		Timestamp educationFromDate = (Timestamp) context.get("educationFromDate");
		Timestamp educationThruDate = (Timestamp) context.get("educationThruDate");
		String majorId = (String)context.get("majorId");
		String studyModeTypeId = (String)context.get("studyModeTypeId");
		String degreeClassificationTypeId = (String)context.get("degreeClassificationTypeId");
		String educationSystemTypeId = (String)context.get("educationSystemTypeId");
		GenericValue personEducation = delegator.makeValue("PersonEducation");
		Map<String,Object> result= ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "Successful", (Locale)context.get("locale")));
		personEducation.set("fromDate", educationFromDate);
		personEducation.set("thruDate", educationThruDate);
		personEducation.set("partyId", partyId);
		personEducation.set("schoolId", schoolId);
		personEducation.set("majorId", majorId);
		personEducation.set("studyModeTypeId", studyModeTypeId);
		personEducation.set("classificationTypeId", degreeClassificationTypeId);
		personEducation.set("educationSystemTypeId", educationSystemTypeId);
		try {
			delegator.create(personEducation);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		result.put("partyId", partyId);
		result.put("educationFromDate", educationFromDate);
		result.put("partyId", partyId);
		result.put("schoolId", schoolId);
		result.put("majorId", majorId);
		result.put("studyModeTypeId", studyModeTypeId);
		result.put("educationSystemTypeId", educationSystemTypeId);
		return result;
	}
	
	public static Map<String,Object> deletePersonEducation(DispatchContext dpct, Map<String,?extends Object>context) throws GenericEntityException{
		//schoolId, partyId,majorId,studyModeTypeId,educationSystemTypeId,fromDate,id
		String schoolId=(String)context.get("schoolId");
		String partyId=(String)context.get("partyId");
		String majorId=(String)context.get("majorId");
		String studyModeTypeId=(String)context.get("studyModeTypeId");
		String educationSystemTypeId= (String)context.get("educationSystemTypeId");
		String idTr=(String)context.get("idTr");
		Timestamp fromDate=(Timestamp)context.get("fromDate");
		Map<String,Object> result= ServiceUtil.returnSuccess();
		
		Delegator delegator= dpct.getDelegator();
		GenericValue edu= delegator.findOne("PersonEducation", UtilMisc.toMap("schoolId",schoolId,"partyId",partyId,"studyModeTypeId",studyModeTypeId,"educationSystemTypeId",educationSystemTypeId,"fromDate",fromDate,"majorId",majorId), false);
		if(UtilValidate.isNotEmpty(edu)){
			
			edu.remove();
		}
		
		result.put("idTr", idTr);
		return result;
	}
	
	public static Map<String, Object> createPersonWorkingProcess(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		//LocalDispatcher dispatcher = dctx.getDispatcher();
		//Locale locale = (Locale)context.get("locale");
		//TimeZone timeZone = (TimeZone) context.get("timeZone");
		//GenericValue userLogin = (GenericValue)context.get("userLogin");
		String partyId = (String)context.get("partyId");
		Timestamp fromDate = (Timestamp)context.get("workProcess_fromDate");
		Timestamp thruDate = (Timestamp)context.get("workProcess_thruDate");
		//String orgId = (String)context.get("orgId");
		//String isCreateNewOrg = (String)context.get("isCreateNewOrg");
		String companyName = (String)context.get("companyName");
		String emplPositionTypeId = (String) context.get("emplPositionTypeIdWorkProcess");
		String jobDescription = (String)context.get("jobDescription");
		String payroll = (String)context.get("payroll");
		String terminationReasonId = (String)context.get("terminationReasonId");
		String rewardDiscrip = (String)context.get("rewardDiscrip");
		//String partyGroupId = null;
		GenericValue personWorkingProcess = delegator.makeValue("PersonWorkingProcess");
		String personWorkingProcessId=delegator.getNextSeqId("PersonWorkingProcess");
		personWorkingProcess.set("personWorkingProcessId",personWorkingProcessId );
		personWorkingProcess.set("fromDate", fromDate);
		personWorkingProcess.set("thruDate", thruDate);
		personWorkingProcess.set("companyName", companyName);
		personWorkingProcess.set("emplPositionTypeId", emplPositionTypeId);
		personWorkingProcess.set("jobDescription", jobDescription);
		personWorkingProcess.set("payroll", payroll);
		personWorkingProcess.set("terminationReasonId", terminationReasonId);
		personWorkingProcess.set("rewardDiscrip", rewardDiscrip);
		personWorkingProcess.set("partyId", partyId);
		try {
			personWorkingProcess.create();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, Object> result= ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "Successful", (Locale)context.get("locale")));
		result.put("personWorkingProcessId", personWorkingProcessId);
		return result;
	}
	
	public static Map<String,Object> deleteWorkingProcess(DispatchContext dpct,Map<String,Object> context) throws GenericEntityException{
		Delegator delegator= dpct.getDelegator();
		
		String personWorkingProcessId=(String)context.get("personWorkingProcessId");
		
		GenericValue working= delegator.findOne("PersonWorkingProcess", UtilMisc.toMap("personWorkingProcessId",personWorkingProcessId), false);
		if(UtilValidate.isNotEmpty(working)){
			working.remove();
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> editPersonWorkingProcess(DispatchContext dcpt, Map<String,Object> context) throws GenericEntityException{
		Delegator delegator= dcpt.getDelegator();
		
		Timestamp fromDate=(Timestamp)context.get("xworkProcess_fromDate");
		Timestamp thruDate=(Timestamp)context.get("xworkProcess_thruDate");
		String companyName=(String)context.get("xcompanyName");
		String emplPositionTypeId=(String)context.get("xemplPositionTypeIdWorkProcess");
		String jobDescription=(String)context.get("xjobDescription");
		String payroll=(String)context.get("xpayroll");
		String terminationReasonId=(String)context.get("xterminationReasonId");
		String rewardDiscrip= (String)context.get("xrewardDiscrip");
		String personWorkingProcessId=(String)context.get("personWorkingProcessId");
		String processIdTr=(String)context.get("processIdTr");
		
		GenericValue working=delegator.findOne("PersonWorkingProcess", UtilMisc.toMap("personWorkingProcessId",personWorkingProcessId), false);
		
		if(UtilValidate.isNotEmpty(working)){
			
			working.set("fromDate", fromDate);
			working.set("thruDate", thruDate);
			working.set("companyName", companyName);
			working.set("emplPositionTypeId", emplPositionTypeId);
			working.set("jobDescription", jobDescription);
			working.set("payroll", payroll);
			working.set("terminationReasonId", terminationReasonId);
			working.set("rewardDiscrip", rewardDiscrip);
			working.store();
		}
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("xFromDate", fromDate.getTime());
		result.put("xThruDate", thruDate.getTime());
		result.put("xcompanyName", companyName);
		result.put("xemplPositionTypeIdWorkProcess", emplPositionTypeId);
		result.put("xjobDescription", jobDescription);
		result.put("xpayroll", payroll);
		result.put("xterminationReasonId", terminationReasonId);
		result.put("xrewardDiscrip", rewardDiscrip);
		result.put("processIdTr", processIdTr);
		return result;
	}
	
	public static Map<String, Object> createPersonFamilyBackground(DispatchContext dctx, Map<String, Object> context){
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String partyId = (String)context.get("partyId");
		String firstNameFamily = (String)context.get("firstNameFamily");
		String middleNameFamily = (String)context.get("middleNameFamily");
		String lastNameFamily = (String)context.get("lastNameFamily");
		String partyRelationshipTypeId = (String)context.get("partyRelationshipTypeId");
		Date birthDate = (Date)context.get("birthDate");
		String occupation = (String)context.get("occupation");
		String placeWork = (String)context.get("placeWork");
		String phoneNumber = (String)context.get("phoneNumber");
		String emergencyContact=(String)context.get("emergencyContact");
		Map<String, Object> successResult = ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "Successful", (Locale)context.get("locale")));
		String personFamilyId=null;
		try {
			Map<String, Object> familyPerson = dispatcher.runSync("createPerson", UtilMisc.toMap("firstName", firstNameFamily, "middleName", middleNameFamily, "lastName", lastNameFamily, "birthDate", birthDate));
			String familyPersonId = (String)familyPerson.get("partyId");
			GenericValue personFamilyBackground = delegator.makeValue("PersonFamilyBackground");
			personFamilyId=delegator.getNextSeqId("PersonFamilyBackground");
			personFamilyBackground.set("personFamilyBackgroundId", personFamilyId);
			personFamilyBackground.set("partyId", partyId);
			personFamilyBackground.set("partyFamilyId", familyPersonId);
			personFamilyBackground.set("partyRelationshipTypeId", partyRelationshipTypeId);
			personFamilyBackground.set("occupation", occupation);
			personFamilyBackground.set("placeWork", placeWork);
			if(UtilValidate.isNotEmpty(emergencyContact)){
				if(emergencyContact.equals("Y")){
					personFamilyBackground.set("emergencyContact", "Y");
				}else{
					personFamilyBackground.set("emergencyContact", "N");
				}
			}else{
				personFamilyBackground.set("emergencyContact", "N");
			}
			personFamilyBackground.create();
			dispatcher.runSync("createPartyTelecomNumber", UtilMisc.toMap("contactMechPurposeTypeId", "PHONE_MOBILE", "partyId", familyPersonId, "contactNumber", phoneNumber, "userLogin", userLogin));
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		successResult.put("personFamilyId", personFamilyId);
		return successResult;
	}
	
	public static String deletePersonFamilyBackground(HttpServletRequest request, HttpServletResponse response) throws GenericEntityException, GenericServiceException{
		Delegator delegator=(Delegator)request.getAttribute("delegator");
		LocalDispatcher disp= (LocalDispatcher)request.getAttribute("dispatcher");
		Locale locale=UtilHttp.getLocale(request);
		GenericValue userLogin = (GenericValue)request.getSession().getAttribute("userLogin");
		String personFamilyBackgroundId= (String)request.getParameter("personFamilyBackgroundId");
		if(UtilValidate.isNotEmpty(personFamilyBackgroundId)){
			GenericValue pfbg=delegator.findOne("PersonFamilyBackground", UtilMisc.toMap("personFamilyBackgroundId",personFamilyBackgroundId), false);
			if(UtilValidate.isNotEmpty(pfbg)){
				String partyId= pfbg.getString("partyFamilyId");
				if(UtilValidate.isNotEmpty(partyId)){
					List<GenericValue> ctm= EntityUtil.filterByDate(delegator.findList("PartyContactMech", EntityCondition.makeCondition("partyId",partyId), null, null, null, false));
					for(GenericValue entry:ctm){
						String contactMechId= entry.getString("contactMechId");
						disp.runSync("deletePartyContactMech", UtilMisc.toMap("partyId",partyId,"contactMechId",contactMechId,"userLogin", userLogin));
					}
				}
				pfbg.remove();
			}
			
		}
		return "success";
		
	}
	
	public static Map<String, Object> getInfoPersonFamily(DispatchContext dctx, Map<String, ?extends Object> context) throws GenericEntityException{
		Delegator delegator= dctx.getDelegator();
		String personFamilyBackgroundId= (String)context.get("personFamilyBackgroundId");
		List<Map<String,Object>> peso= FastList.newInstance();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		if(UtilValidate.isNotEmpty(personFamilyBackgroundId)){
			
			GenericValue family= delegator.findOne("PersonFamilyBackground", UtilMisc.toMap("personFamilyBackgroundId",personFamilyBackgroundId), false);
			if(UtilValidate.isNotEmpty(family)){
				Map<String, Object> map= new HashMap<String, Object>();
				String partyFamilyId= family.getString("partyFamilyId");
				GenericValue person= delegator.findOne("Person", UtilMisc.toMap("partyId",partyFamilyId), false);
				String firstNameFamily= person.getString("firstName");
				String middleNameFamily= person.getString("middleName");
				String lastNameFamily=person.getString("lastName");
				Date birthDate= (Date)person.get("birthDate");
				String partyRelationshipTypeId=family.getString("partyRelationshipTypeId");
				String occupation= family.getString("occupation");
				String placeWork= family.getString("placeWork");
				String emergencyContact=family.getString("emergencyContact");
				map.put("emergencyContact", emergencyContact);
				map.put("firstNameFamily", firstNameFamily);
				map.put("middleNameFamily", middleNameFamily);
				map.put("lastNameFamily", lastNameFamily);
				if(UtilValidate.isNotEmpty(birthDate)){
//					SimpleDateFormat di= new SimpleDateFormat("dd-MM-yyyy");
					map.put("birthDate", birthDate.getTime());
				}else{
					map.put("birthDate","");
					
				}
				map.put("partyRelationshipTypeId", partyRelationshipTypeId);
				map.put("occupation", occupation);
				map.put("placeWork", placeWork);
				String contactNumber="";
				String contactMechId="";
				if(UtilValidate.isNotEmpty(partyFamilyId)){
					EntityCondition condi1= EntityCondition.makeCondition("partyId",partyFamilyId);
					EntityCondition condi2= EntityCondition.makeCondition("contactMechPurposeTypeId","PHONE_MOBILE");
					EntityCondition condi3= EntityCondition.makeCondition("contactMechTypeId","TELECOM_NUMBER");
					
					GenericValue contact= EntityUtil.getFirst(EntityUtil.filterByDate(delegator.findList("PartyContactDetailByPurpose", EntityCondition.makeCondition(EntityJoinOperator.AND,condi1,condi2,condi3), null,null, null, false)));
					if(UtilValidate.isNotEmpty(contact)){
						contactNumber= contact.getString("contactNumber");
						contactMechId=contact.getString("contactMechId");
					}
				}
				map.put("contactNumber", contactNumber);
				map.put("contactMechId", contactMechId);
				peso.add(map);
			}
		}
		result.put("listperson", peso);
		
		
		return result;
	}
	
	public static Map<String,Object> EditFamilyBackground(DispatchContext dcpx, Map<String, ?extends Object> context) throws GenericEntityException, GenericServiceException, ParseException{
		Delegator delegator= dcpx.getDelegator();
		Map<String,Object> add= ServiceUtil.returnSuccess();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		List<Map<String,Object>> infolist= FastList.newInstance();
		
		String idTr= (String)context.get("idTr");
		GenericValue userLogin= (GenericValue)context.get("userLogin");
		String contactMechId= (String)context.get("contactMechId");
		String personFamilyBackgroundId=(String)context.get("personFamilyBackgroundId");
		String xfirstNameFamily= (String)context.get("xfirstNameFamily");
		String xmiddleNameFamily=(String)context.get("xmiddleNameFamily");
		String xlastNameFamily=(String)context.get("xlastNameFamily");
		String xpartyRelationshipTypeId=(String)context.get("xpartyRelationshipTypeId");
		Date xbirthDate=(Date)context.get("xbirthDate");
		String xoccupation=(String)context.get("xoccupation");
		String xplaceWork=(String)context.get("xplaceWork");
		String xphoneNumber= (String)context.get("xphoneNumber");
		String xemergencyContact=(String)context.get("xemergencyContact");
		String resulEmer="N";
		String resulType="";
		String partyId="";
		//update PersonFamilyBackground
		if(UtilValidate.isNotEmpty(personFamilyBackgroundId)){
			GenericValue fami= delegator.findOne("PersonFamilyBackground", UtilMisc.toMap("personFamilyBackgroundId",personFamilyBackgroundId), false);
			partyId=fami.getString("partyFamilyId");
			fami.set("partyRelationshipTypeId", xpartyRelationshipTypeId);
			fami.set("occupation", xoccupation);
			fami.set("placeWork", xplaceWork);
			
			if(UtilValidate.isNotEmpty(xemergencyContact)){
				if(xemergencyContact.equals("Y")){
					fami.set("emergencyContact", "Y");
					resulEmer="Y";
				}else{
					fami.set("emergencyContact", "N");
				}
			}else{
				fami.set("emergencyContact", "N");
			}
			fami.store();
		}
		//update Person
		if(UtilValidate.isNotEmpty(partyId)){
			GenericValue person= delegator.findOne("Person", UtilMisc.toMap("partyId",partyId), false);
			if(UtilValidate.isNotEmpty(person)){
				person.set("firstName", xfirstNameFamily);
				person.set("middleName",xmiddleNameFamily);
				person.set("lastName", xlastNameFamily);
				if(UtilValidate.isNotEmpty(xbirthDate)){
//					SimpleDateFormat di= new SimpleDateFormat("dd/MM/yyyy");
//					Date birthDate= di.parse(xbirthDate);
					person.set("birthDate", xbirthDate);
				}
				person.store();
			}
		}
			
			//update Contact
		if(UtilValidate.isNotEmpty(contactMechId)){
			if(UtilValidate.isNotEmpty(xphoneNumber)){
				GenericValue contact= delegator.findOne("TelecomNumber", UtilMisc.toMap("contactMechId",contactMechId), false);
				if(UtilValidate.isNotEmpty(contact)){
					
					contact.set("contactNumber", xphoneNumber);
					contact.store();
				}
			}
			
		}else{
			if(UtilValidate.isNotEmpty(xphoneNumber)&&UtilValidate.isNotEmpty(partyId)){
				dcpx.getDispatcher().runSync("createPartyTelecomNumber", UtilMisc.toMap("contactMechPurposeTypeId", "PHONE_MOBILE", "partyId", partyId, "contactNumber", xphoneNumber, "userLogin", userLogin));
			}
			
		}
		
		if(UtilValidate.isNotEmpty(xbirthDate)){
			add.put("birthDate", xbirthDate.getTime());
			
		}else{
			
			add.put("birthDate", "");
		}
		
		if(UtilValidate.isNotEmpty(xpartyRelationshipTypeId)){
			
			GenericValue type= delegator.findOne("PartyRelationshipType", UtilMisc.toMap("partyRelationshipTypeId",xpartyRelationshipTypeId), false);
			if(UtilValidate.isNotEmpty(type)){
				
				resulType=type.getString("partyRelationshipName");
			}
		}
		add.put("emergencyContact", resulEmer);
		add.put("phoneNumber", xphoneNumber);
		add.put("partyRelationshipTypeId", resulType);
		add.put("firstName", xfirstNameFamily);
		add.put("middleName", xmiddleNameFamily);
		add.put("lastName", xlastNameFamily);
		add.put("idTr", idTr);
		add.put("occupation",xoccupation);
		infolist.add(add);
		result.put("result", infolist);
		return result;
	}
	public static Map<String, Object> createPartySkill(DispatchContext dctx, Map<String, Object> context){
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		String skillTypeId = (String)context.get("skillTypeId");
		String skillLevelId = (String)context.get("skillLevelId");
		try {
			GenericValue skillLevelType = delegator.findOne("SkillLevelType", UtilMisc.toMap("levelTypeId", skillLevelId), false);
			dispatcher.runSync("createPartySkill", UtilMisc.toMap("partyId", partyId, "skillTypeId", skillTypeId, "skillLevel", skillLevelType.getLong("value"), "userLogin", context.get("userLogin")));
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> createRecruitmentInfo(DispatchContext dctx, Map<String, Object> context){
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		//String partyId = (String)context.get("partyId");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String recruitmentTypeId = (String) context.get("recruitmentTypeId");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String jobRequestId = (String) context.get("jobRequestId");
		String expectedSalary = (String)context.get("expectedSalary");
		String employmentAppSourceTypeId = (String)context.get("employmentAppSourceTypeId");
		String referredByPartyId = (String)context.get("referredByPartyId");
		Timestamp recruitment_fromDate = (Timestamp)context.get("recruitment_fromDate");
		String partyId = null;
		Map<String, Object> retMap = FastMap.newInstance();
		Locale locale = (Locale)context.get("locale");
		TimeZone timeZone = (TimeZone)context.get("timeZone");
		retMap.put("partyId", partyId);
		Map<String, Object> resultsService = null;
		try {
			if(UtilValidate.isNotEmpty(jobRequestId)){
				Map<String, Object> createApplicantMap = ServiceUtil.setServiceFields(dispatcher, "createApplicant", context, userLogin, timeZone, locale);
				resultsService = dispatcher.runSync("createApplicant", createApplicantMap);
				if(ServiceUtil.isSuccess(resultsService)){
					partyId = (String)resultsService.get("partyId");
					retMap.put("partyId", partyId);
				}
			}else if(UtilValidate.isNotEmpty(emplPositionTypeId) && emplPositionTypeId.equals("SALESMAN") || emplPositionTypeId.equals("PROMOTION_GIRL")){
				if(UtilValidate.isEmpty(recruitmentTypeId) || UtilValidate.isEmpty(expectedSalary) || UtilValidate.isEmpty(recruitment_fromDate)){
					ServiceUtil.returnError(UtilProperties.getMessage("RecruitmentUiLabels", "RecruitmentInfoIsInsufficient", locale));
				}
				GenericValue org = PartyUtil.getDepartmentOfEmployee(delegator, userLogin.getString("partyId"));
				Map<String, Object> createSalesmanPGMap = ServiceUtil.setServiceFields(dispatcher, "createSalesmanPG", context, userLogin, timeZone, locale);
				createSalesmanPGMap.put("fromDate", recruitment_fromDate);
				createSalesmanPGMap.put("orgId", org.getString("partyIdFrom"));
				resultsService = dispatcher.runSync("createSalesmanPG", createSalesmanPGMap);
				if(ServiceUtil.isSuccess(resultsService)){
					partyId = (String)resultsService.get("partyId");
					retMap.put("partyId", partyId);
				}else{
					ServiceUtil.returnError((String)resultsService.get(ModelService.ERROR_MESSAGE));
				}
				//TODO need store information about expectedSalary, employmentAppSourceTypeId, referredByPartyId   
			}else{
				ServiceUtil.returnError(UtilProperties.getMessage("RecruitmentUiLabels", "RecruitmentInfoIsNotValid", locale));
			}
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}

	/*HUNGNC START EDIT*/
	public static Map<String, Object> updateRequirementInHR(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException{
		Map<String, Object> result = new FastMap<String, Object>();
		
		Delegator delegator = ctx.getDelegator();
		String requestor = (String)context.get("requestor");
		String requirementTypeId = (String)context.get("requirementTypeId");
		String requirementId = (String)context.get("requirementId");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = (String)userLogin.get("partyId");
		Timestamp requiredByDate = (Timestamp)context.get("requiredByDate");
		Timestamp requirementStartDate = (Timestamp)context.get("requirementStartDate"); 
		String productStoreId = (String)context.get("productStoreId");
		String currencyUomId = (String)context.get("currencyUomId");
		String facilityId = (String)context.get("facilityId");
		String originContactMechId = (String)context.get("originContactMechId");
		String destContactMechId = (String)context.get("destContactMechId");
		Locale locale = (Locale)context.get("locale");
		if (originContactMechId != null){
			if (requiredByDate == null){                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
				requiredByDate = UtilDateTime.nowTimestamp();
			}
			if (context.get("requirementId") == null){
				requirementId = delegator.getNextSeqId("Requirement");
				context.put("requirementId", requirementId);
			}
			
			GenericValue requirement = delegator.makeValue("Requirement");
			requirement.setNonPKFields(context);
			requirement.setPKFields(context);
			requirement.put("productStoreId", productStoreId);
			requirement.put("currencyUomId", currencyUomId);
			requirement.put("facilityId", facilityId);
			requirement.put("contactMechId", originContactMechId);
			requirement.put("requirementStartDate", requirementStartDate);
			requirement.put("requiredByDate", requiredByDate);
			delegator.createOrStore(requirement);
			requirementId = (String)requirementId;
			
			List<String> listOrderBy = new ArrayList<String>();
			listOrderBy.add("-fromDate");
			try {
				List<GenericValue> requirementRoles = delegator.findList("RequirementRole", EntityCondition.makeCondition(UtilMisc.toMap("partyId", requestor, "requirementId", requirementId, "roleTypeId", "OWNER")), null, listOrderBy, null, false);
				requirementRoles = EntityUtil.filterByDate(requirementRoles);
				if (requirementRoles.isEmpty()){
					GenericValue requirementRole = delegator.makeValue("RequirementRole");
					requirementRole.put("requirementId", requirementId);
					requirementRole.put("roleTypeId", "OWNER");
					requirementRole.put("fromDate", requiredByDate);
					GenericValue partyRole = delegator.makeValue("PartyRole");
					partyRole.put("roleTypeId", "OWNER");
					if (requestor != null){
						requirementRole.put("partyId", requestor);
						partyRole.put("partyId", requestor);
					} else {
						requirementRole.put("partyId", partyId);
						partyRole.put("partyId", partyId);
					}
					delegator.createOrStore(partyRole);
					delegator.createOrStore(requirementRole);
				}
			} catch (GenericEntityException e1) {
				Debug.logError(e1, module);
				return ServiceUtil.returnError(e1.getMessage());
			}
			
			if ("INTERNAL_SALES_REQ".equals(requirementTypeId)){
				List<GenericValue> requirementRoles = delegator.findList("RequirementRole", EntityCondition.makeCondition(UtilMisc.toMap("partyId", requestor, "requirementId", requirementId, "roleTypeId", "CUSTOMER")), null, listOrderBy, null, false);
				List<GenericValue> findAmountLimit = delegator.findList("FindAmountLimitIntenalPurchaseLimit", EntityCondition.makeCondition(UtilMisc.toMap("PartyID", requestor)), null, null, null, false);
				if(findAmountLimit.isEmpty() == true){
					return ServiceUtil.returnError(UtilProperties.getMessage("InternalPurchaseUiLables", "checkIntenalPurchaseLimitIsExits", locale));
					
				}
				for (GenericValue listAmount : findAmountLimit) {
					String amountLimitRemain = (String) listAmount.get("AmountLimitRemain");
					if(Integer.parseInt(amountLimitRemain) == 0){
						return ServiceUtil.returnError(UtilProperties.getMessage("InternalPurchaseUiLables", "checkAmountLimitRemain", locale));
					}
				}
				requirementRoles = EntityUtil.filterByDate(requirementRoles);
				if (requirementRoles.isEmpty()){
					GenericValue reqCustomerRole = delegator.makeValue("RequirementRole");
					GenericValue custPartyRole = delegator.makeValue("PartyRole");
					custPartyRole.put("partyId", requestor);
					custPartyRole.put("roleTypeId", "CUSTOMER");
					delegator.createOrStore(custPartyRole);
					reqCustomerRole.put("partyId", requestor);
					reqCustomerRole.put("requirementId", requirementId);
					reqCustomerRole.put("roleTypeId", "CUSTOMER");
					reqCustomerRole.put("fromDate", requiredByDate);
					delegator.createOrStore(reqCustomerRole);
				}
			}
			
			if ("SALES_REQ".equals(requirementTypeId) || "CHANGE_DATE_REQ".equals(requirementTypeId)){
				List<GenericValue> requirementRoles = delegator.findList("RequirementRole", EntityCondition.makeCondition(UtilMisc.toMap("partyId", requestor, "requirementId", requirementId, "roleTypeId", "CUSTOMER")), null, listOrderBy, null, false);
				requirementRoles = EntityUtil.filterByDate(requirementRoles);
				if (requirementRoles.isEmpty()){
					String customerParty = (String)context.get("customerParty");
					GenericValue reqCustomerRole = delegator.makeValue("RequirementRole");
					GenericValue custPartyRole = delegator.makeValue("PartyRole");
					custPartyRole.put("partyId", customerParty);
					custPartyRole.put("roleTypeId", "CUSTOMER");
					delegator.createOrStore(custPartyRole);
					reqCustomerRole.put("partyId", customerParty);
					reqCustomerRole.put("requirementId", requirementId);
					reqCustomerRole.put("roleTypeId", "CUSTOMER");
					reqCustomerRole.put("fromDate", requiredByDate);
					delegator.createOrStore(reqCustomerRole);
				}
			}
			if ("GIFT_REQ".equals(requirementTypeId)){
				String receiverParty = (String)context.get("receiverParty");
				if (receiverParty != null){
					List<GenericValue> requirementRoles = delegator.findList("RequirementRole", EntityCondition.makeCondition(UtilMisc.toMap("partyId", requestor, "requirementId", requirementId, "roleTypeId", "RECEIVER")), null, listOrderBy, null, false);
					requirementRoles = EntityUtil.filterByDate(requirementRoles);
					if (requirementRoles.isEmpty()){
						GenericValue reqReceiveGiftRole = delegator.makeValue("RequirementRole");
						GenericValue receiverPartyRole = delegator.makeValue("PartyRole");
						receiverPartyRole.put("partyId", receiverParty);
						receiverPartyRole.put("roleTypeId", "RECEIVER");
						delegator.createOrStore(receiverPartyRole);
						reqReceiveGiftRole.put("partyId", receiverParty);
						reqReceiveGiftRole.put("requirementId", requirementId);
						reqReceiveGiftRole.put("roleTypeId", "RECEIVER");
						reqReceiveGiftRole.put("fromDate", requiredByDate);
						delegator.createOrStore(reqReceiveGiftRole);
					}
				}
			}
			if ("TRANSFER_REQ".equals(requirementTypeId)){
				String facilityTo = (String)context.get("facilityTo");
				String productStoreIdTo = (String)context.get("productStoreIdTo");
				GenericValue reqFacility = delegator.makeValue("RequirementFacility");
				reqFacility.put("facilityIdTo", facilityTo);
				reqFacility.put("originContactMechId", originContactMechId);
				reqFacility.put("destContactMechId", destContactMechId);
				reqFacility.put("facilityIdFrom", facilityId);
				reqFacility.put("productStoreIdFrom", productStoreId);
				reqFacility.put("productStoreIdTo", productStoreIdTo);
				reqFacility.put("requirementId", requirementId);
				reqFacility.put("description", context.get("description"));
				delegator.createOrStore(reqFacility);
			}
			if ("RECEIVE_ORDER_REQ".equals(requirementTypeId)){
				String purchaseOrderId = (String)context.get("orderId");
				List<GenericValue> listOrderItems = delegator.findList("OrderItem", EntityCondition.makeCondition(UtilMisc.toMap("orderId", purchaseOrderId)), null, null, null, false);
	    		if (!listOrderItems.isEmpty()){
	    			for (GenericValue item : listOrderItems){
	    				GenericValue orderReqCommitment = delegator.makeValue("OrderRequirementCommitment");
	    				BigDecimal quantity = item.getBigDecimal("quantity");
	    				orderReqCommitment.put("requirementId", requirementId);
	    				orderReqCommitment.put("orderItemSeqId", item.get("orderItemSeqId"));
	    				orderReqCommitment.put("orderId", purchaseOrderId);
	    				orderReqCommitment.put("quantity", quantity);
	    				delegator.createOrStore(orderReqCommitment);
	    			}
	    		}
	    		result.put("selectedSubMenuItem", "ReceiveFromOrder");
			}
			if ("RECEIVE_PRODUCT_REQ".equals(requirementTypeId)){
				String statusId = (String)context.get("statusId");
				List<GenericValue> listReqItems = delegator.findList("RequirementItem", EntityCondition.makeCondition(UtilMisc.toMap("requirementId", requirementId)), null, null, null, false);
				if (listReqItems.isEmpty() && ("REQ_APPROVED".equals(statusId) || "REQ_COMPLETED".equals(statusId))){
					return ServiceUtil.returnError(UtilProperties.getMessage(resource,
		                    "CannotApproveWithNoProduct", (Locale)context.get("locale")));
				} else {
					result.put("selectedSubMenuItem", "ReceiveByProduct");
				}
			}
		} else {
			Map<String, Object> mapError = ServiceUtil.returnError(UtilProperties.getMessage(resource,
                    "FacilityNotHaveContactMech", locale));
			mapError.put("requirementId", requirementId);
			return mapError;
		}
		result.put("requirementId", requirementId);
		return result;
	}
	
	
	public static Map<String, Object> getFacilities (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productStoreId = (String)context.get("productStoreId");
		String productStoreIdTo = (String)context.get("productStoreIdTo");
		String facilityId = (String)context.get("facilityId");
		String facilityIdTo = (String)context.get("facilityIdTo");
		String contactMechPurposeTypeIdFrom = (String)context.get("contactMechPurposeTypeIdFrom");
		String contactMechPurposeTypeIdTo = (String)context.get("contactMechPurposeTypeIdTo");
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listProdStoreFacilites = delegator.findList("ProductStoreFacility", EntityCondition.makeCondition(UtilMisc.toMap("productStoreId", productStoreId)), null, null, null, false);
		List<GenericValue> listFacilities = new ArrayList<GenericValue>();
		List<GenericValue> listFacilitiesTo = new ArrayList<GenericValue>();
		List<GenericValue> listProdStoreFacilitesTo = new ArrayList<GenericValue>();
		listProdStoreFacilites = EntityUtil.filterByDate(listProdStoreFacilites);
		if (!listProdStoreFacilites.isEmpty()){
			for (GenericValue item : listProdStoreFacilites){
				GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", (String)item.get("facilityId")));
				if (facility != null){
					listFacilities.add(facility);
				}
			}
		}
		if (productStoreIdTo != null){
			listProdStoreFacilitesTo = delegator.findList("ProductStoreFacility", EntityCondition.makeCondition(UtilMisc.toMap("productStoreId", productStoreIdTo)), null, null, null, false);
			if (!listProdStoreFacilitesTo.isEmpty()){
				for (GenericValue item : listProdStoreFacilitesTo){
					GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", (String)item.get("facilityId")));
					if (facility != null){
						listFacilitiesTo.add(facility);
					}
				}
			}
			if (productStoreIdTo.equals(productStoreId)){
				if (!listFacilities.isEmpty()){
					if (facilityId != null){
						GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", facilityId));
						if (facility != null && listFacilities.contains(facility)){
							if (facilityIdTo != null){
								if (((String)listFacilities.get(0).get("facilityId")).equals(facilityIdTo)){
									listFacilities.remove(facility);
									listFacilities.add(facility);
								} else {
									if (listFacilitiesTo.size() > 1){
										listFacilitiesTo.remove(facility);
										listFacilitiesTo.add(facility);
									} else {
										listFacilitiesTo.remove(facility);
									}
								}
							} else {
								listFacilitiesTo.remove(facility);
							}
						} else {
							if (facilityIdTo != null){
								if (((String)listFacilities.get(0).get("facilityId")).equals(facilityIdTo)){
									if (listFacilities.size() > 1){
										GenericValue facilityTmp = listFacilities.get(0); 
										listFacilities.remove(facilityTmp);
										listFacilities.add(facilityTmp);
									} else {
										listFacilities.remove(listFacilities.get(0));
									}
								} else {
									if (listFacilitiesTo.size() > 1){
										GenericValue facilityTmp = listFacilities.get(0); 
										listFacilitiesTo.remove(facilityTmp);
										listFacilitiesTo.add(facilityTmp);
									} else {
										listFacilitiesTo.remove(listFacilities.get(0));
									}
								}
							} else {
								if (listFacilitiesTo.size() > 1){
									GenericValue facilityTmp = listFacilities.get(0); 
									listFacilitiesTo.remove(facilityTmp);
									listFacilitiesTo.add(facilityTmp);
								} else {
									listFacilitiesTo.remove(listFacilities.get(0));
								}
							}
						}
					} else {
						if (listFacilitiesTo.size() > 1){
							GenericValue facilityTmp = listFacilities.get(0); 
							listFacilitiesTo.remove(facilityTmp);
							listFacilitiesTo.add(facilityTmp);
						} else {
							listFacilitiesTo.remove(listFacilities.get(0));
						}
					}
				}
			} else {
				GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", facilityIdTo));
				if (facility != null && listFacilitiesTo.contains(facility)){
					listFacilitiesTo.remove(facility);
					listFacilitiesTo.add(0, facility);
				}
			}
		}
		
		result.put("listFacilities", listFacilities);
		result.put("listFacilitiesTo", listFacilitiesTo);
		result.put("productStoreId", productStoreId);
		result.put("productStoreIdTo", productStoreIdTo);
		List<GenericValue> listContactMechsFrom = new ArrayList<GenericValue>();
		List<GenericValue> listContactMechsTo = new ArrayList<GenericValue>();
		if (!listFacilitiesTo.isEmpty()){
			try {
				List<GenericValue> listContactMechPurpose = delegator.findList("FacilityContactMechPurpose", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", listFacilitiesTo.get(0).get("facilityId"), "contactMechPurposeTypeId", contactMechPurposeTypeIdTo)), null, null, null, false);
				listContactMechPurpose = EntityUtil.filterByDate(listContactMechPurpose);
				if (!listContactMechPurpose.isEmpty()){
					for (GenericValue contact : listContactMechPurpose){
						List<GenericValue> listPostalAddress = delegator.findList("PostalAddress", EntityCondition.makeCondition(UtilMisc.toMap("contactMechId", contact.get("contactMechId"))), null, null, null, false);
						for (GenericValue pa : listPostalAddress){
							if (!listContactMechsTo.contains(pa)){
								listContactMechsTo.add(pa);
							}
						}
					}
				}
			} catch (GenericEntityException e) {
				Debug.logError(e, module);
				return ServiceUtil.returnError(e.getMessage());
			}
		}
		if (!listFacilities.isEmpty()){
			try {
				List<GenericValue> listContactMechPurpose = delegator.findList("FacilityContactMechPurpose", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", listFacilities.get(0).get("facilityId"), "contactMechPurposeTypeId", contactMechPurposeTypeIdFrom)), null, null, null, false);
				listContactMechPurpose = EntityUtil.filterByDate(listContactMechPurpose);
				if (!listContactMechPurpose.isEmpty()){
					for (GenericValue contact : listContactMechPurpose){
						List<GenericValue> listPostalAddress = delegator.findList("PostalAddress", EntityCondition.makeCondition(UtilMisc.toMap("contactMechId", contact.get("contactMechId"))), null, null, null, false);
						for (GenericValue pa : listPostalAddress){
							if (!listContactMechsFrom.contains(pa)){
								listContactMechsFrom.add(pa);
							}
						}
					}
				}
			} catch (GenericEntityException e) {
				Debug.logError(e, module);
				return ServiceUtil.returnError(e.getMessage());
			}
		}
		result.put("listContactMechsFrom", listContactMechsFrom);
		result.put("listContactMechsTo", listContactMechsTo);
		return result;
	}
	
	public static Map<String, Object> getFacilitiesByStore (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productStoreId = (String)context.get("productStoreId");
		String facilityId = (String)context.get("facilityId");
		Delegator delegator = ctx.getDelegator();
		
		List<GenericValue> listProdStoreFacilites = delegator.findList("ProductStoreFacility", EntityCondition.makeCondition(UtilMisc.toMap("productStoreId", productStoreId)), null, null, null, false);
		List<GenericValue> listFacilities = new ArrayList<GenericValue>();
		if (!listProdStoreFacilites.isEmpty()){
			for (GenericValue item : listProdStoreFacilites){
				GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", (String)item.get("facilityId")));
				if (facility != null){
					listFacilities.add(facility);
				}
			}
		}
		if (facilityId != null){
			GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", facilityId));
			if (listFacilities.size() >= 1){
				listFacilities.remove(facility);
				listFacilities.add(0, facility);
			}
		}
		
		result.put("listFacilities", listFacilities);
		result.put("productStoreId", productStoreId);
		return result;
	}

	public static Map<String, Object> getRecruitmentPlanDetail(DispatchContext ctx, Map<String, Object> context){
		//Get parameters
		String partyId = (String)context.get("partyId");
		String year = (String)context.get("year");

		//Get delegator
		Delegator delegator = ctx.getDelegator();

		//Get List
		Map<String, Object> conditionMap = FastMap.newInstance();
		conditionMap.put("partyId", partyId);
		conditionMap.put("year", year);
		List<GenericValue> listGenericValue = null;
		try {
			listGenericValue = delegator.findList("RecruitmentPlan", EntityCondition.makeCondition(conditionMap, EntityJoinOperator.AND), null, UtilMisc.toList("-emplPositionTypeId"), null, false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}

		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("listGenericValue", listGenericValue);
		return result;
	}

	public static Map<String, Object> createOrUpdateRecruitmentPlan(DispatchContext ctx, Map<String, Object> context){
		//Get Parameters
		Locale locale = (Locale) context.get("locale");
		try {
			return RecruitmentPlanServiceHelper.createOrUpdateRecruitmentPlan(ctx, context);
		} catch (Exception e) {
			Debug.log(e.getStackTrace().toString(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
	}

	public static Map<String, Object> updateRecruitmentPlanHeader(DispatchContext ctx, Map<String, Object> context){
		//Get Parameters
		Locale locale = (Locale) context.get("locale");
		try {
			return RecruitmentPlanServiceHelper.updateRecruitmentPlanHeader(ctx, context);
		} catch (Exception e) {
			Debug.log(e.getStackTrace().toString(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "updateError", new Object[]{e.getMessage()}, locale));
		}
	}
}
