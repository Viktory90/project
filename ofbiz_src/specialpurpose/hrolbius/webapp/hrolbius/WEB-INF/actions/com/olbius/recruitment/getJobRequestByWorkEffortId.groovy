import org.ofbiz.entity.condition.EntityCondition;
workEffortId = parameters.workEffortId;

workEffortRequest = delegator.findList("WorkEffortRequest", EntityCondition.makeCondition("workEffortId", workEffortId), null, null, null, false);
workEffortRequest = workEffortRequest.get(0);

context.workEffortRequest = workEffortRequest