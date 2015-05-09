import org.ofbiz.entity.condition.EntityCondition;

workTrialReportId = parameters.workTrialReportId;

partyId = workTrialReport.getString("partyId");

workTrialLeaderRatingList = delegator.findList("ReportRatingLeaderRating", EntityCondition.makeCondition("workTrialReportId",workTrialReportId), null, null, null, false);

workTrialHrmRatingList = delegator.findList("ReportRatingHrmRating", EntityCondition.makeCondition("workTrialReportId",workTrialReportId), null, null, null, false);

workTrialHrmRatingList = delegator.findList("ReportRatingCeoRating", EntityCondition.makeCondition("workTrialReportId",workTrialReportId), null, null, null, false);

workTrialReportList = delegator.findList("ReportRatingSelfRating", EntityCondition.makeCondition("workTrialReportId",workTrialReportId), null, null, null, false);


emplList = delegator.findList("WorkTrialReportView", EntityCondition.makeCondition("partyId",partyId), null, null ,null, false);

context.empl = emplList.get(0);
context.workTrialLeaderRating = workTrialLeaderRatingList.get(0);
context.workTrialHrmRating = workTrialHrmRatingList.get(0);
context.workTrialReport = workTrialReportList.get(0);
context.partyId = partyId;

