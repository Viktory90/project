package com.olbius.recruitment.helper;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.party.party.PartyHelper;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.olbius.util.PartyUtil;

public class RecruitmentPlanServiceHelper {
	
	public static final String module = RecruitmentPlanServiceHelper.class.getName();
	public static final String resource = "hrolbiusUiLabels";
	public static final String resourceNoti = "NotificationUiLabels";
	
	public static Map<String, Object> createOrUpdateRecruitmentPlan(DispatchContext dpctx, Map<String, Object> context) throws Exception {

		Delegator delegator = dpctx.getDelegator();

		// Get parameters
		String emplPositionTypeId = (String) context.get("emplPositionTypeId");
		String partyId = (String)context.get("partyId");
		String year = (String)context.get("year");
		Long firstMonth = (Long) context.get("firstMonth");
		Long secondMonth = (Long) context.get("secondMonth");
		Long thirdMonth = (Long) context.get("thirdMonth");
		Long fourthMonth = (Long) context.get("fourthMonth");
		Long fifthMonth = (Long) context.get("fifthMonth");
		Long sixthMonth = (Long) context.get("sixthMonth");
		Long seventhMonth = (Long) context.get("seventhMonth");
		Long eighthMonth = (Long) context.get("eighthMonth");
		Long ninthMonth = (Long) context.get("ninthMonth");
		Long tenthMonth = (Long) context.get("tenthMonth");
		Long eleventhMonth = (Long) context.get("eleventhMonth");
		Long twelfthMonth = (Long) context.get("twelfthMonth");
		
		GenericValue recruitmentPlan = delegator.findOne("RecruitmentPlan", UtilMisc.toMap("partyId", partyId, "year", year, "emplPositionTypeId", emplPositionTypeId), false);
		if(UtilValidate.isEmpty(recruitmentPlan)){
			//If Recruitment Plan is not exists, CREATE

			GenericValue newEntity = delegator.makeValue("RecruitmentPlan");
			newEntity.set("emplPositionTypeId", emplPositionTypeId);
			newEntity.set("partyId", partyId);
			newEntity.set("year", year);
			newEntity.set("firstMonth", firstMonth);
			newEntity.set("secondMonth", secondMonth);
			newEntity.set("thirdMonth", thirdMonth);
			newEntity.set("fourthMonth", fourthMonth);
			newEntity.set("fifthMonth", fifthMonth);
			newEntity.set("sixthMonth", sixthMonth);
			newEntity.set("seventhMonth", seventhMonth);
			newEntity.set("eighthMonth", eighthMonth);
			newEntity.set("ninthMonth", ninthMonth);
			newEntity.set("tenthMonth", tenthMonth);
			newEntity.set("eleventhMonth", eleventhMonth);
			newEntity.set("twelfthMonth", twelfthMonth);
			newEntity.create();
		}else{
			//If Recruitment Plan is exists, UPDATE
			recruitmentPlan.put("firstMonth", firstMonth);
			recruitmentPlan.put("secondMonth", secondMonth);
			recruitmentPlan.put("thirdMonth", thirdMonth);
			recruitmentPlan.put("fourthMonth", fourthMonth);
			recruitmentPlan.put("fifthMonth", fifthMonth);
			recruitmentPlan.put("sixthMonth", sixthMonth);
			recruitmentPlan.put("seventhMonth", seventhMonth);
			recruitmentPlan.put("eighthMonth", eighthMonth);
			recruitmentPlan.put("ninthMonth", ninthMonth);
			recruitmentPlan.put("tenthMonth", tenthMonth);
			recruitmentPlan.put("eleventhMonth", eleventhMonth);
			recruitmentPlan.put("twelfthMonth", twelfthMonth);
			recruitmentPlan.store();
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("emplPositionTypeId", emplPositionTypeId);
		result.put("partyId", partyId);
		result.put("year", year);
		return result;
	}
	
	public static Map<String, Object> updateRecruitmentPlanHeader(DispatchContext dpctx, Map<String, Object> context) throws Exception{
		//Get parameters
		String partyId = (String)context.get("partyId");
		String year = (String)context.get("year");
		String statusId = (String)context.get("statusId");
		String reason = (String)context.get("reason");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher dispatcher = dpctx.getDispatcher();

		//Update RecruitmentPlanHeader
		GenericValue oldValue = delegator.findOne("RecruitmentPlanHeader", UtilMisc.toMap("partyId", partyId, "year", year), false);
		oldValue.put("statusId", statusId);
		oldValue.put("reason", reason);
		oldValue.store();

		//Create RecruitmentPlanHeader Status
		GenericValue rphStatus = delegator.makeValue("RecruitmentPlanStatus");
		String seq = delegator.getNextSeqId("RecruitmentPlanHeader");
		rphStatus.put("recruitmentPlanStatusId", seq);
		rphStatus.put("partyId", partyId);
		rphStatus.put("year", year);
		rphStatus.put("createDate", new Timestamp(Calendar.getInstance().getTimeInMillis()));
		rphStatus.put("statusUserLogin", userLogin.getString("partyId"));
		rphStatus.put("statusId", statusId);
		rphStatus.put("reason", reason);
		rphStatus.create();

		//Send a notification to hrmadmin
		if("RPH_SCHEDULED".equals(statusId)){
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			createNotiCtx.put("partyId", PartyUtil.getHrmAdmin(delegator));
			createNotiCtx.put("header", "Kiểm tra kế hoạch tuyển dụng phòng " + PartyHelper.getPartyName(delegator, partyId, false) + " năm " + year);
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindRecruitmentPlan");
			createNotiCtx.put("targetLink", "partyId=" + partyId + ";year=" + year);
			createNotiCtx.put("state", "open");
			dispatcher.runSync("createNotification", createNotiCtx);
		}
		
		//Send a notification to hrmadmin and headofdept
		if("RPH_REJECTED".equals(statusId) && PartyUtil.isCEO(delegator, userLogin)){
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			List<String> partiesList = new ArrayList<String>();
			partiesList.add(PartyUtil.getHrmAdmin(delegator));
			partiesList.add(PartyUtil.getManagerbyOrg(partyId, delegator));
			createNotiCtx.put("partiesList", partiesList);
			createNotiCtx.put("header", "Kết quả xét duyệt kế hoạch tuyển dụng phòng " + PartyHelper.getPartyName(delegator, partyId, false) + " năm " + year);
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindRecruitmentPlan");
			createNotiCtx.put("state", "open");
			createNotiCtx.put("targetLink", "partyId=" + partyId + ";year=" + year);
			dispatcher.runSync("createNotification", createNotiCtx);
		}
		
		//Send a notification to headofdept
		if(PartyUtil.isAdmin(userLogin.getString("partyId"), delegator)){
			Map<String, Object> createNotiCtx = FastMap.newInstance();
			List<String> partiesList = new ArrayList<String>();
			partiesList.add(PartyUtil.getManagerbyOrg(partyId, delegator));
			createNotiCtx.put("partiesList", partiesList);
			createNotiCtx.put("header", "Kết quả xét duyệt kế hoạch tuyển dụng phòng " + PartyHelper.getPartyName(delegator, partyId, false) + " năm " + year);
			createNotiCtx.put("dateTime", new Timestamp(Calendar.getInstance().getTimeInMillis()));
			createNotiCtx.put("userLogin", userLogin);
			createNotiCtx.put("action", "FindRecruitmentPlan");
			createNotiCtx.put("state", "open");
			createNotiCtx.put("targetLink", "partyId=" + partyId + ";year=" + year);
			dispatcher.runSync("createNotification", createNotiCtx);
		}
		
		return ServiceUtil.returnSuccess();
	}
}
