<div class="row-fuild">
	<div class="span12 margin-top30" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<table cellspacing="0">
			<tbody>
				<tr>
					<td>
						<label class="padding-bottom5 padding-right15 " for="emplPositionTypeId">${uiLabelMap.EmplPositionTypeId}</label> 
						<span style="color:red">(*)</span>
					</td>
					<td>
						<select id="emplPositionTypeId" name="emplPositionTypeId">
							<#list emplPositionTypeList as emplPositionType>
								<option value="${emplPositionType.emplPositionTypeId}">
									${emplPositionType.description?if_exists}
								</option>
							</#list>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<label class="padding-bottom5 padding-right15 " for="RecruitmentType">${uiLabelMap.RecruitmentType}</label> 
						<span style="color:red">(*)</span>
					</td>
					<td>
						<select id="RecruitmentType" name="recruitmentTypeId">
							<#list recruitmentTypeList as recruitmentType>
								<option value="${recruitmentType.recruitmentTypeId}">
									${recruitmentType.description?if_exists}
								</option>
							</#list>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<label class="padding-bottom5 padding-right15 " for="recruitment_fromDate">${uiLabelMap.CommonFromDate}</label> 
						<span style="color:red">(*)</span>
					</td>
					<td>
						<@htmlTemplate.renderDateTimeField name="recruitment_fromDate" id="recruitment_fromDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd" size="25" maxlength="30"  dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</td>	
				</tr>
				<tr>
					<td>
						<label class="padding-bottom5 padding-right15 " for="expectedSalary">${uiLabelMap.ExpectedSalary}</label> 
						<span style="color:red">(*)</span>
					</td>
					<td>
						<input type="text" name="expectedSalary" id="expectedSalary">
					</td>
				</tr>
				<tr>
					<td>
						<label class="padding-bottom5 padding-right15 " for="employmentAppSourceType">${uiLabelMap.EmploymentAppSourceType}</label> 
					</td>
					<td>
						<select name="employmentAppSourceTypeId" id="employmentAppSourceType">
							<#list employmentAppSourceType as empAppSourceType>
								<option value="${empAppSourceType.employmentAppSourceTypeId}">
									${empAppSourceType.description?if_exists}
								</option>
							</#list>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<label class="padding-bottom5 padding-right15 " for="referredByParty">${uiLabelMap.ReferredByParty}</label> 
					</td>
					<td>
						<input type="text" name="referredByPartyId" id="referredByParty">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>