package com.olbius.recruitment.helper;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.olbius.recruitment.RecruitmentDataPreparation;
import com.olbius.util.PartyUtil;

public class JobRequestHelper {
	
	public static final String module = JobRequestHelper.class.getName();
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> createJobRequest(DispatchContext dpctx, Map<String, Object> context) throws Exception{
		Delegator delegator = dpctx.getDelegator();
		// Get parameters
		String emplPositionTypeId = (String) context.get("emplPositionTypeId");
		Timestamp fromDate = (Timestamp) context.get("fromDate");
		Timestamp thruDate = (Timestamp) context.get("thruDate");
		String recruitmentTypeId = (String) context.get("recruitmentTypeId");
		String recruitmentFormId = (String) context.get("recruitmentFormId");
		String reason = (String)context.get("reason");
		Long resourceNumber = (Long) context.get("resourceNumber");
		String jobDescription = (String) context.get("jobDescription");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = (String)context.get("partyId");
		String workLocation = (String)context.get("workLocation");
		List<Map<String, String>> listCriteria = FastList.newInstance();
		if (context.get("listCriteria") instanceof List) {
			listCriteria = (List<Map<String, String>>) context.get("listCriteria");
		}

		// Create auto increase id
		String jobRequestId = (String) delegator.getNextSeqId("JobRequest");
		
		// Initial status
		String statusId = "JR_INIT";
		if (PartyUtil.isAdmin(userLogin.getString("partyId"), delegator)) {
			statusId = "JR_ACCEPTED";
		}
		// Check in plan
		String isInPlan = "IJR_NINPLAN";
		if (RecruitmentDataPreparation.checkInPlan(dpctx, resourceNumber, partyId, emplPositionTypeId, fromDate)) {
			isInPlan = "IJR_INPLAN";
		}
		// Set data for Job request
		GenericValue jobRequest = delegator.makeValue("JobRequest");
		jobRequest.set("jobRequestId", jobRequestId);
		jobRequest.set("emplPositionTypeId", emplPositionTypeId);
		jobRequest.set("fromDate", fromDate);
		jobRequest.set("thruDate", thruDate);
		jobRequest.set("recruitmentTypeId", recruitmentTypeId);
		jobRequest.set("recruitmentFormId", recruitmentFormId);
		jobRequest.set("resourceNumber", resourceNumber);
		jobRequest.set("jobDescription", jobDescription);
		jobRequest.set("partyId", partyId);
		jobRequest.set("statusId", statusId);
		jobRequest.put("reason", reason);
		jobRequest.set("isInPlan", isInPlan);
		jobRequest.put("workLocation", workLocation);
		// Set data for Job Request Criteria
		// Create
		jobRequest.create();
		if (listCriteria != null) {
			GenericValue jobRequestCriteria = delegator.makeValue("JobRequestCriteria");
			for (Map<String, String> item : listCriteria) {
				jobRequestCriteria.set("jobRequestId", jobRequestId);
				jobRequestCriteria.set("recruitmentCriteriaId", item.get("recruitmentCriteriaId"));
				jobRequestCriteria.create();
			}
		}
		
		//Create JobRequest Status
		GenericValue jrStatus = delegator.makeValue("JobRequestStatus");
		String seq = delegator.getNextSeqId("JobRequestStatus");
		jrStatus.put("jobRequestStatusId", seq);
		jrStatus.put("jobRequestId", jobRequestId);
		jrStatus.put("createDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
		jrStatus.put("statusUserLogin", userLogin.getString("partyId"));
		jrStatus.put("statusId", statusId);
		jrStatus.create();
		
		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("jobRequestId", jobRequestId);
		return result;
	}
	
	public static Map<String, Object> updateJobRequest(DispatchContext dpctx, Map<String, Object> context) throws Exception{
		//Get parameters
		String jobRequestId = (String)context.get("jobRequestId");
		String partyId = (String) context.get("partyId");
		String isInPlan = (String) context.get("isInPlan");
		String statusId = (String)context.get("statusId");
		String reason = (String)context.get("reason");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher dispatcher = dpctx.getDispatcher();

		//Update RecruitmentPlanHeader
		GenericValue oldValue = delegator.findOne("JobRequest", UtilMisc.toMap("jobRequestId", jobRequestId), false);
		oldValue.put("statusId", statusId);
		oldValue.put("reason", reason);
		oldValue.store();

		//Create RecruitmentPlanHeader Status
		GenericValue jrStatus = delegator.makeValue("JobRequestStatus");
		String seq = delegator.getNextSeqId("JobRequestStatus");
		jrStatus.put("jobRequestStatusId", seq);
		jrStatus.put("jobRequestId", jobRequestId);
		jrStatus.put("createDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
		jrStatus.put("statusUserLogin", userLogin.getString("partyId"));
		jrStatus.put("statusId", statusId);
		jrStatus.put("reason", reason);
		jrStatus.create();

		//Send a notification to headofdept
		if("JR_REJECTED".equals(statusId) && PartyUtil.isAdmin(userLogin.getString("partyId"), delegator)){
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			createNotiCtx.put("partyId", PartyUtil.getManagerbyOrg(partyId, delegator));
			createNotiCtx.put("header", "Kết quả kiểm tra yêu cầu tuyển dụng " + jobRequestId);
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindJobRequestApproval");
			createNotiCtx.put("targetLink", "jobRequestId=" + jobRequestId);
			createNotiCtx.put("state", "open");
			dispatcher.runSync("createNotification", createNotiCtx);
		}else if("JR_PROPOSED".equals(statusId) && PartyUtil.isAdmin(userLogin.getString("partyId"), delegator)) {
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			createNotiCtx.put("partyId", PartyUtil.getCEO(delegator));
			createNotiCtx.put("header", "Phê duyệt yêu cầu tuyển dụng " + jobRequestId);
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindJobRequestApproval");
			createNotiCtx.put("targetLink", "jobRequestId=" + jobRequestId);
			createNotiCtx.put("state", "open");
			dispatcher.runSync("createNotification", createNotiCtx);
		}else if(PartyUtil.isCEO(delegator, userLogin)) {
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			List<String> partiesList = new ArrayList<String>();
			partiesList.add(PartyUtil.getManagerbyOrg(partyId, delegator));
			partiesList.add(PartyUtil.getHrmAdmin(delegator));
			createNotiCtx.put("partiesList", partiesList);
			createNotiCtx.put("header", "Kết quả xét duyệt yêu cầu tuyển dụng " + jobRequestId);
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindJobRequestApproval");
			createNotiCtx.put("targetLink", "jobRequestId=" + jobRequestId);
			createNotiCtx.put("state", "open");
			dispatcher.runSync("createNotification", createNotiCtx);
		}else if (!PartyUtil.isCEO(delegator, userLogin) && !PartyUtil.isAdmin(userLogin.getString("partyId"), delegator) && "JR_SCHEDULED".equals(statusId)) {
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindJobRequestApproval");
			createNotiCtx.put("targetLink", "jobRequestId=" + jobRequestId);
			createNotiCtx.put("state", "open");
			if ("IJR_NINPLAN".equals(isInPlan)) {
				createNotiCtx.put("header", "Phê duyệt yêu cầu tuyển dụng " + jobRequestId);
				createNotiCtx.put("partyId", PartyUtil.getCEO(delegator));
			}else {
				createNotiCtx.put("header", "Kiểm tra yêu cầu tuyển dụng " + jobRequestId);
				createNotiCtx.put("partyId", PartyUtil.getHrmAdmin(delegator));
			}
			dispatcher.runSync("createNotification", createNotiCtx);
		}
		return ServiceUtil.returnSuccess();
	}
}
