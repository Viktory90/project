import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;

import com.olbius.recruitment.entity.RecruitmentTestPlan;

recruitmentTestPlanList = new ArrayList<RecruitmentTestPlan>();
EntityCondition condition1 = EntityCondition.makeCondition("workEffortTypeId", "RECR_TEST_PLAN");
recruitmentTestPlanListTmp = delegator.findList("WorkEffort", condition1, null, null, null, false);
for(GenericValue item : recruitmentTestPlanListTmp){
	RecruitmentTestPlan recrTestPlan = new RecruitmentTestPlan();
	//Get all test in plan
	EntityCondition condition2 = EntityCondition.makeCondition("workEffortParentId", item.getString("workEffortId"));
	recruitmentTestList = delegator.findList("WorkEffort", condition2, null, null, null, false);
	recrTestPlan.setRecruitmentTestPlan(item);
	recrTestPlan.setRecruitmentTestList(recruitmentTestList);
	recruitmentTestPlanList.add(recrTestPlan);
}


context.recruitmentTestPlanList = recruitmentTestPlanList;
