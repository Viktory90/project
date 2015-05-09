import org.ofbiz.entity.condition.EntityCondition;

workTrialReportId = parameters.workTrialReportId;

workTrialReportList = delegator.findList("ReportRatingSelfRating", EntityCondition.makeCondition("workTrialReportId",workTrialReportId), null, null, null, false);
workTrialReport = workTrialReportList.get(0);
partyId = workTrialReport.getString("partyId");
context.partyId = partyId;

emplList = delegator.findList("WorkTrialReportView", EntityCondition.makeCondition("partyId",partyId), null, null ,null, false);
context.empl = emplList.get(0);
context.workTrialReport = workTrialReport;