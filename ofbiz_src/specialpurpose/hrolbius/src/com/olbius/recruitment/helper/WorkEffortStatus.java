package com.olbius.recruitment.helper;

import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;

public class WorkEffortStatus extends Observable  implements Observer{

	@Override
	public void updateStatus(Map<String, Object> context)
			throws GenericEntityException {
		String workEffortId = (String)context.get("workEffortId");
		Delegator delegator = (Delegator)context.get("delegator");
		EntityCondition condition1 = EntityCondition.makeCondition("workEffortId", workEffortId);
		EntityCondition condition2 = EntityCondition.makeCondition("roleTypeId", "APPLICANT");
		EntityCondition condition = EntityCondition.makeCondition(condition1, condition2);
		List<GenericValue> workEffortPartyAssList = delegator.findList("WorkEffortPartyAssignment", condition, null, null, null, false);
		boolean isCompleted = true;
		boolean isAllFail = true;
		for(GenericValue item : workEffortPartyAssList){
			if(item.getString("statusId").equals("PA_ASSIGNED")){
				isCompleted =false;
				break;
			}else if(item.getString("statusId").equals("PA_PASS")){
				isAllFail = false;
			}
		}
		if(isCompleted){
			GenericValue workEffort = delegator.findOne("WorkEffort", false, UtilMisc.toMap("workEffortId", workEffortId));
			String workEffortParentId = workEffort.getString("workEffortParentId");
			workEffort.put("currentStatusId", "RTP_COMPLETED");
			workEffort.store();
			if(isAllFail){
				EntityCondition condition3 = EntityCondition.makeCondition("workEffortIdFrom", workEffortParentId);
				List<GenericValue> workEffortAssocList = delegator.findList("WorkEffortAssoc",condition3, null, null, null, false);
					for(GenericValue item: workEffortAssocList){
						List<GenericValue> workEffortAndAssocList = delegator.findList("WorkEffortAndAssoc", EntityCondition.makeCondition("workEffortId", workEffortId), null, null, null, false);
						if(item.getLong("sequenceNum") > workEffortAndAssocList.get(0).getLong("sequenceNum")){
							GenericValue nextWorkEffort = delegator.findOne("WorkEffort", false, UtilMisc.toMap("workEffortId", item.getString("workEffortIdTo")));
							nextWorkEffort.put("currentStatusId", "RTP_CLOSED");
							nextWorkEffort.store();
					}
				}
			}
			//Set map 
			mapTmp.put("delegator", delegator);
			mapTmp.put("workEffortId", workEffortParentId);
			notifyObserver();
		}
	}
}
