import org.ofbiz.entity.condition.EntityCondition;

workEffortId = parameters.workEffortId;

emplPosTypeList = delegator.findList("WorkEffortRequest", EntityCondition.makeCondition("workEffortId", workEffortId), null, null, null, false);
emplPositionTypeId = emplPosTypeList.get(0).getString("emplPositionTypeId");

context.emplPositionTypeId = emplPositionTypeId