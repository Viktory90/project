import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.base.util.UtilMisc;
import com.olbius.util.PartyUtil;


jobRequestId = parameters.jobRequestId;
jobRequestConditionMap = UtilMisc.toMap("jobRequestId", jobRequestId);
jobRequest = delegator.findOne("JobRequest", jobRequestConditionMap, false);

emplPostionTypeConditionMap = UtilMisc.toMap("emplPositionTypeId", (String)jobRequest.get("emplPositionTypeId"));
recruitmentTypeConditionMap = UtilMisc.toMap("recruitmentTypeId", (String)jobRequest.get("recruitmentTypeId"));
recruitmentFormConditionMap = UtilMisc.toMap("recruitmentFormId", (String)jobRequest.get("recruitmentFormId"));
partyGroupConditionMap  = UtilMisc.toMap("partyId", (String)jobRequest.get("partyId"));
emplPositionType = delegator.findOne("EmplPositionType", emplPostionTypeConditionMap, false);
recruitmentType = delegator.findOne("RecruitmentType", recruitmentTypeConditionMap, false);
recruitmentForm = delegator.findOne("RecruitmentForm", recruitmentFormConditionMap, false);
partyGroup = delegator.findOne("PartyGroup", partyGroupConditionMap, false);
checkStatusList = delegator.findList("StatusItem",EntityCondition.makeCondition("statusTypeId","CHK_JR_STATUS"), null, null ,null, false);
approvalStatusList = delegator.findList("StatusItem",EntityCondition.makeCondition("statusTypeId","APPR_JR_STATUS"), null, null ,null, false);
criteriaIdList = delegator.findList("JobRequestCriteria",EntityCondition.makeCondition("jobRequestId",jobRequestId), null, null ,null, false);
criteriaList = new ArrayList<String>();
if(criteriaIdList != null && !criteriaIdList.isEmpty()){
	for(GenericValue criteria: criteriaIdList){
		criteriaConditionMap = UtilMisc.toMap("recruitmentCriteriaId", (String)criteria.get("recruitmentCriteriaId"));
		criteriaType = delegator.findOne("RecruitmentCriteria", criteriaConditionMap, false);
		System.out.println("viet" +criteriaType);
		criteriaList.add(criteriaType.getString("description"))
	}
}

managerId = PartyUtil.getManagerbyOrg((String)jobRequest.get("partyId"), delegator);
context.managerId = managerId;
context.deptName = partyGroup.getString("groupName");
context.checkStatusList = checkStatusList;
context.approvalStatusList = approvalStatusList;
context.recruitmentType = recruitmentType;
context.emplPositionType = emplPositionType;
context.recruitmentForm = recruitmentForm;
context.jobRequest = jobRequest;
context.criteriaList =criteriaList;