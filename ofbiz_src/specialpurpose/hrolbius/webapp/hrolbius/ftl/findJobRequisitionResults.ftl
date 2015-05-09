<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<div class="widget-body">
	<#if context.listIt?has_content>
	<table class="table table-hover table-striped table-bordered dataTable" cellspacing="0">
		<tr class="header-row">
			<td class="header-table">${uiLabelMap.JobRequisitionId}</td>
			<td class="header-table" style = "width: 150px;">${uiLabelMap.SkillTypeIds}</td>
			<td class="header-table">${uiLabelMap.JobPostingType}</td>
			<td class="header-table">${uiLabelMap.ExamTypeEnumId}</td>
			<td class="header-table" style = "width: 150px;">${uiLabelMap.Qualifications}</td>
			<td class="header-table">${uiLabelMap.ExperienceInYears}</td>
			<td class="header-table">${uiLabelMap.ExperienceInMonths}</td>
			<td class="header-table">${uiLabelMap.fromDate}</td>
			<td class="header-table">${uiLabelMap.thruDate}</td>
			<td class="header-table">${uiLabelMap.CommonStatus}</td>
			<td class="header-table">${uiLabelMap.JobRequestId}</td>
			<td class="header-table" style = "width: 100px;">${uiLabelMap.Approve}</td>
		</tr>
		<#list listIt as requisition>
			<tr>
				<td>
					${requisition.jobRequisitionId?if_exists}
				</td>
				<td>
					<#assign i = 1>
					<#list requisition.skillTypeIds?if_exists as skillType>
						${i}. &nbsp ${skillType.description}
						<#assign i = i+1>
						</br>
					</#list>
				</td>
				<td>
					${requisition.jobPostingType?if_exists}
				</td>
				<td>
					${requisition.examTypeEnumId?if_exists}
				</td>
				<td>
					<#assign i = 1>
					<#list requisition.qualifications?if_exists as qualification>
						${i}. &nbsp ${qualification.description}
						<#assign i = i + 1>
						</br>
					</#list>
				</td>
				<td>
					${requisition.experienceYears?if_exists}
				</td>
				<td>
					${requisition.experienceMonths?if_exists}
				</td>
				<td>
					${requisition.fromDate?if_exists}
				</td>
				<td>
					${requisition.thruDate?if_exists}
				</td>
				<td>
					${requisition.statusId?if_exists}
				</td>
				<td>
					${requisition.jobRequestId?if_exists}
				</td>
				<td>
					<a class="btn btn-mini btn-info icon-ok open-sans" href="/hrolbius/control/EditJobRequisitionApproval?jobRequisitionId=${requisition.jobRequisitionId}">
						${uiLabelMap.Approve}
					</a>
				</td>
			</tr>
		</#list>
	</table>
	<#else>
		<p class="alert alert-info">${uiLabelMap.NoRecordFoud}</p>
	</#if>
</div>