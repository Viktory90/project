<div class="widget-body">
	<#if recruitmentTestPlanList?has_content>
	<table class="table table-hover table-striped table-bordered dataTable" cellspacing="0">
		<thead>
			<tr class="header-row">
				<td class="header-table">${uiLabelMap.RecruitmentTestPlanId}</td>
				<td class="header-table">${uiLabelMap.Round1}</td>
				<td class="header-table">${uiLabelMap.Round2}</td>
				<td class="header-table">${uiLabelMap.Round3}</td>
			</tr>
		</thead>
		<tbody>
		<#list recruitmentTestPlanList as recruitmentTestPlan>
			<tr>
				<td>	
					<#-- <#assign conditions = []/>
					<#assign conditions = conditions + [Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("workEffortId", recruitmentTestPlan.workEffortId)]/>
					<#assign conditions = conditions />
					<#assign applicant = delegator.findList("workEffortPartyAssignment", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(), null, null, null, false)/> -->
					<span class="bold-label">${uiLabelMap.CommonId}: </span>
					<span class="green-label">${recruitmentTestPlan.getRecruitmentTestPlan().workEffortId?if_exists}</span>
					<br/>
					<span class="bold-label">${uiLabelMap.CommonDescription}: </span>
					<span class="green-label">${recruitmentTestPlan.getRecruitmentTestPlan().description?if_exists}</span>
					<br/>
					<span class="bold-label">${uiLabelMap.CommonFromDate}: </span>
					<#if recruitmentTestPlan.getRecruitmentTestPlan().estimatedStartDate?exists>
						<#assign estimatedStartDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTestPlan.getRecruitmentTestPlan().estimatedStartDate) />
						<span class="green-label">${estimatedStartDate?if_exists}</span>
					<#else>
						<span class="green-label"></span>
					</#if>
					<br/>
					<span class="bold-label">${uiLabelMap.CommonThruDate}: </span>
					<#if recruitmentTestPlan.getRecruitmentTestPlan().estimatedCompletionDate?exists>
						<#assign estimatedStartDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTestPlan.getRecruitmentTestPlan().estimatedCompletionDate) />
						<span class="green-label">${estimatedCompletionDate?if_exists}</span>
					<#else>
						<span class="green-label"></span>
					</#if>
					</br>
					<#assign status =delegator.findOne("StatusItem", {"statusId" : recruitmentTestPlan.getRecruitmentTestPlan().currentStatusId?if_exists}, true)>
					<span class="bold-label">${uiLabelMap.CommonStatus}: </span>
					<span class="green-label">${status.description?if_exists}</span>
				</td>
				<td>
					<#list recruitmentTestPlan.getRecruitmentTestList() as recruitmentTest>
						<#if recruitmentTest.workEffortTypeId?if_exists = 'RECR_EXAM'>
							<span class="bold-label">${uiLabelMap.CommonId}: </span>
							<span class="green-label">${recruitmentTest.workEffortId?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonDescription}: </span>
							<span class="green-label">${recruitmentTest.description?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonFromDate}: </span>
							<#assign estimatedStartDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTest.estimatedStartDate) />
							<span class="green-label">${estimatedStartDate?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonThruDate}: </span>
							<#assign estimatedCompletionDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTest.estimatedCompletionDate) />
							<span class="green-label">${estimatedCompletionDate?if_exists}</span>
							<br/>
							<#assign status =delegator.findOne("StatusItem", {"statusId" : recruitmentTest.currentStatusId?if_exists}, true)>
							<span class="bold-label">${uiLabelMap.CommonStatus}: </span>
							<span class="green-label">${status.description?if_exists}</span>
							
							</br>
							<#assign condition1 = Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("workEffortId", recruitmentTest.workEffortId) />
							<#assign condition2 = Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("roleTypeId", "TESTER") />
							<#assign testerList = delegator.findList("WorkEffortPartyAssignment", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(Static["org.ofbiz.entity.condition.EntityJoinOperator"].AND, condition1, condition2), null, ["partyId"], null, false) />
							<span class="bold-label">${uiLabelMap.RecruitmentTester}: </span>
							<#list testerList as item>
								<#assign tester =delegator.findOne("Person", {"partyId": item.partyId}, false)/>
								<span class="green-label">${tester.firstName?if_exists} ${tester.middleName?if_exists} ${tester.lastName?if_exists}</span>
							</#list>
						</#if>
					</#list>
				</td>
				<td>
					<#list recruitmentTestPlan.getRecruitmentTestList() as recruitmentTest>
						<#if recruitmentTest.workEffortTypeId?if_exists = 'RECR_REVIEW1'>
							<span class="bold-label">${uiLabelMap.CommonId}: </span>
							<span class="green-label">${recruitmentTest.workEffortId?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonDescription}: </span>
							<span class="green-label">${recruitmentTest.description?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonFromDate}: </span>
							<#assign estimatedStartDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTest.estimatedStartDate) />
							<span class="green-label">${estimatedStartDate?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonThruDate}: </span>
							<#assign estimatedCompletionDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTest.estimatedCompletionDate) />
							<span class="green-label">${estimatedCompletionDate?if_exists}</span>
							<br/>
							<#assign status =delegator.findOne("StatusItem", {"statusId" : recruitmentTest.currentStatusId?if_exists}, true)>
							<span class="bold-label">${uiLabelMap.CommonStatus}: </span>
							<span class="green-label">${status.description?if_exists}</span>
							</br>
							<#assign condition1 = Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("workEffortId", recruitmentTest.workEffortId) />
							<#assign condition2 = Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("roleTypeId", "TESTER") />
							
							<#assign interviewerList = delegator.findList("WorkEffortPartyAssignment", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(Static["org.ofbiz.entity.condition.EntityJoinOperator"].AND, condition1, condition2), null, ["partyId"], null, false) />
							<span class="bold-label">${uiLabelMap.RecruitmentInterviewer}: </span>
							<#list interviewerList as item>
								<#assign interviewer =delegator.findOne("Person", {"partyId": item.partyId}, false)>
								<span class="green-label">${interviewer.firstName?if_exists} ${interviewer.middleName?if_exists} ${interviewer.lastName?if_exists}</span>
							</#list>
						</#if>
					</#list>
				</td>
				<td>
					<#list recruitmentTestPlan.getRecruitmentTestList() as recruitmentTest>
						<#if recruitmentTest.workEffortTypeId?if_exists = 'RECR_REVIEW2'>
							<span class="bold-label">${uiLabelMap.CommonId}: </span>
							<span class="green-label">${recruitmentTest.workEffortId?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonDescription}: </span>
							<span class="green-label">${recruitmentTest.description?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonFromDate}: </span>
							<#assign estimatedStartDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTest.estimatedStartDate) />
							<span class="green-label">${estimatedStartDate?if_exists}</span>
							<br/>
							<span class="bold-label">${uiLabelMap.CommonThruDate}: </span>
							<#assign estimatedCompletionDate = Static["com.olbius.util.DateUtil"].convertDate(recruitmentTest.estimatedCompletionDate) />
							<span class="green-label">${estimatedCompletionDate?if_exists}</span>
							<br/>
							<#assign status =delegator.findOne("StatusItem", {"statusId" : recruitmentTest.currentStatusId?if_exists}, true)>
							<span class="bold-label">${uiLabelMap.CommonStatus}: </span>
							<span class="green-label">${status.description?if_exists}</span>
							</br>
							<#assign condition1 = Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("workEffortId", recruitmentTest.workEffortId) />
							<#assign condition2 = Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("roleTypeId", "TESTER") />
							<#assign interviewerList = delegator.findList("WorkEffortPartyAssignment", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition(Static["org.ofbiz.entity.condition.EntityJoinOperator"].AND, condition1, condition2), null, ["partyId"], null, false) />
							<span class="bold-label">${uiLabelMap.RecruitmentInterviewer}: </span>
							<#list interviewerList as item>
								<#assign interviewer =delegator.findOne("Person", {"partyId": item.partyId}, false)>
								<span class="green-label">${interviewer.firstName?if_exists} ${interviewer.middleName?if_exists} ${interviewer.lastName?if_exists}</span>
							</#list>
						</#if>
					</#list>
				</td>
			</tr>
		</#list>
		</tbody>
	</table>
	<#else>
		<p class="alert alert-info">${uiLabelMap.NoRecordFoud}</p>
	</#if>
</div>