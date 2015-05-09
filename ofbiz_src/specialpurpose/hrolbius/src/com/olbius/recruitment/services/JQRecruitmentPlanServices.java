package com.olbius.recruitment.services;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

import com.olbius.util.PartyUtil;

public class JQRecruitmentPlanServices {
	public static final String module = JQRecruitmentPlanServices.class.getName();

	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListRecruitmentPlan(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		Map<String, String> mapCondition = new HashMap<String, String>();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String partyId = null;
		try {
			partyId = PartyUtil.getOrgByManager(userLogin.getString("partyId"), delegator);
		} catch (Exception e1) {
			String errMsg = "Fatal error calling jqGetListEmplWorkProcess service: " + e1.toString();
			Debug.logError(e1, errMsg, module);
		}
		mapCondition.put("partyId", partyId);
		EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
		listAllConditions.add(tmpConditon);
		try {
			tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			listIterator = delegator.find("PersonWorkingProcess", tmpConditon, null, null, listSortFields, opts);
			} catch (Exception e) {
				String errMsg = "Fatal error calling jqGetListEmplWorkProcess service: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
		successResult.put("listIterator", listIterator);
		return successResult;
    }

	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListRecruitmentPlanHeader(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		Map<String, String> mapCondition = new HashMap<String, String>();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		try {
			if(!PartyUtil.isAdmin(userLogin.getString("partyId"), delegator) && !PartyUtil.isCEO(delegator, userLogin)){
				//Handle if userLogin is not hrmadmin and ceo
				String partyId = null;
				try {
					partyId = PartyUtil.getOrgByManager(userLogin.getString("partyId"), delegator);
				} catch (Exception e1) {
					String errMsg = "Fatal error calling jqGetListRecruitmentPlanHeader service: " + e1.toString();
					Debug.logError(e1, errMsg, module);
				}
				mapCondition.put("partyId", partyId);
			}else if (PartyUtil.isAdmin(userLogin.getString("partyId"), delegator)){
				//Handle if userLogin is hrmadmin
				EntityCondition statusCon = EntityCondition.makeCondition("statusId",EntityJoinOperator.IN, UtilMisc.toSet("RPH_SCHEDULED", "RPH_ACCEPTED", "RPH_APPROVED", "RPH_PROPOSED", "RPH_REJECTED"));
				listAllConditions.add(statusCon);
			}else if(PartyUtil.isCEO(delegator, userLogin)){
				//Handle if userLogin is ceo
				EntityCondition statusCon = EntityCondition.makeCondition("statusId",EntityJoinOperator.IN, UtilMisc.toSet("RPH_APPROVED", "RPH_PROPOSED"));
				listAllConditions.add(statusCon);
			}
		} catch (Exception e1) {
			String errMsg = "Fatal error calling jqGetListRecruitmentPlanHeader service: " + e1.toString();
			Debug.logError(e1, errMsg, module);
		}
		EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
		listAllConditions.add(tmpConditon);
		try {
			tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			listIterator = delegator.find("RecruitmentPlanHeader", tmpConditon, null, null, listSortFields, opts);
			} catch (Exception e) {
				String errMsg = "Fatal error calling jqGetListRecruitmentPlanHeader service: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListRecruitmentPlanProposal(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		Map<String, String> mapCondition = new HashMap<String, String>();
		mapCondition.put("statusId", "RPH_ACCEPTED");
		EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
		listAllConditions.add(tmpConditon);
		try {
			tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			listIterator = delegator.find("RecruitmentPlanHeader", tmpConditon, null, null, listSortFields, opts);
			} catch (Exception e) {
				String errMsg = "Fatal error calling jqGetListRecruitmentPlanHeader service: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
}
