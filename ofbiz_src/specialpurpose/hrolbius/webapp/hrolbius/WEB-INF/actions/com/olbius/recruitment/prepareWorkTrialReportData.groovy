import org.ofbiz.entity.condition.EntityCondition;

partyId = userLogin.partyId;
context.partyId = partyId;
emplList = delegator.findList("WorkTrialReportView", EntityCondition.makeCondition("partyId",partyId), null, null ,null, false);
context.empl = emplList.get(0);
