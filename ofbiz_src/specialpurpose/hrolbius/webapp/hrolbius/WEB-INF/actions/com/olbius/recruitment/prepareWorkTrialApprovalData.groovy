import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.base.util.UtilMisc;

workTrialProposalId = parameters.workTrialProposalId;
workTrial = delegator.findOne("WorkTrialProposal",UtilMisc.toMap("workTrialProposalId", workTrialProposalId),false);

List<GenericValue> trialEmplList = delegator.findList("WorkTrialApplicantPerson", EntityCondition.makeCondition("workTrialProposalId",workTrialProposalId), null, null ,null, false);
List<GenericValue> approvalStatusList = delegator.findList("StatusItem", EntityCondition.makeCondition("statusTypeId","APPR_WT_STATUS"), null, null ,null, false);

context.workTrial = workTrial;
context.trialEmplList = trialEmplList;
context.approvalStatusList = approvalStatusList;