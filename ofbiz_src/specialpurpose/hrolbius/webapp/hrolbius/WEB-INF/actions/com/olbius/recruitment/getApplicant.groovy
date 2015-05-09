import org.ofbiz.entity.condition.EntityCondition;

applicantList = delegator.findList("PartyPersonPartyRole", EntityCondition.makeCondition("roleTypeId", "APPLICANT"), null ,null, null, false);
context.applicantList = applicantList;