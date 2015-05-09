package com.olbius.recruitment.helper;

import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;

public class RecruitmentPlanStatus implements Observer{
	
	@Override
	public void updateStatus(Map<String, Object> context)
			throws GenericEntityException {
		String workEffortId = (String)context.get("workEffortId");
		Delegator delegator = (Delegator)context.get("delegator");
		EntityCondition condition1 = EntityCondition.makeCondition("workEffortParentId", workEffortId);
		List<GenericValue> workEffortList = delegator.findList("WorkEffort", condition1, null, null, null, false);
		boolean isCompleted = true;
		for(GenericValue item : workEffortList){
			if(item.getString("currentStatusId").equals("RTP_IN_PROGRESS")){
				isCompleted = false;
				break;
			};
		}
		if(isCompleted){
			GenericValue workEffort = delegator.findOne("WorkEffort", false, UtilMisc.toMap("workEffortId", workEffortId));
			workEffort.put("currentStatusId", "RTP_COMPLETED");
			workEffort.store();
		}
	}
}
