<div class="widget-body">
	<#if recruitmentTestPlanList?has_content>
	<table class="table table-hover table-striped table-bordered dataTable" cellspacing="0">
		<tr class="header-row">
			<td class="header-table">${uiLabelMap.jobTestPlanId}</td>
			<td class="header-table">${uiLabelMap.Round1}</td>
			<td class="header-table">${uiLabelMap.Round2}</td>
			<td class="header-table">${uiLabelMap.Round3}</td>
		</tr>
		<#list recruitmentTestPlanList as recruitmentTestPlan>
			<tr>
				<td>
					${recruitmentTestPlan.getRecruitmentTestPlanId()?if_exists}
				</td>
				<td>
					<#list recruitmentTestPlan.getRecruitmentTestList() as recruitmentTest>
						<#if recruitmentTest.workEffortTypeId?if_exists = 'RECR_EXAM'>
							<a class="btn btn-info btn-mini" href="/hrolbius/control/ListExamApplicant?workEffortId=${recruitmentTest.workEffortId?if_exists}">[${recruitmentTest.workEffortId?if_exists}]</a>
							${recruitmentTest.description?if_exists}
						</#if>
					</#list>
				</td>
				<td>
					<#list recruitmentTestPlan.getRecruitmentTestList() as recruitmentTest>
						<#if recruitmentTest.workEffortTypeId?if_exists = 'RECR_REVIEW1'>
							<a class="btn btn-info btn-mini" href="/hrolbius/control/ListInterviewApplicant?workEffortId=${recruitmentTest.workEffortId?if_exists}">[${recruitmentTest.workEffortId?if_exists}]</a>
							${recruitmentTest.description?if_exists}
						</#if>
					</#list>
				</td>
				<td>
					<#list recruitmentTestPlan.getRecruitmentTestList() as recruitmentTest>
						<#if recruitmentTest.workEffortTypeId?if_exists = 'RECR_REVIEW2'>
							<a class="btn btn-info btn-mini" href="/hrolbius/control/ListInterviewApplicant?workEffortId=${recruitmentTest.workEffortId?if_exists}">[${recruitmentTest.workEffortId?if_exists}]</a>
							${recruitmentTest.description?if_exists}
						</#if>
					</#list>
				</td>
			</tr>
		</#list>
	</table>
	<#else>
		<p class="alert alert-info">${uiLabelMap.NoRecordFoud}</p>
	</#if>
</div>