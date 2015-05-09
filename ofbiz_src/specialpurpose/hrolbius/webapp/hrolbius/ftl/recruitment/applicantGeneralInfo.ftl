<div class="row-fuild">
	<div class="span12 margin-top30" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<table cellspacing="0">
			<tbody>
			   	<tr>
					<td><label class="padding-bottom5 padding-right15 " for="firstName">${uiLabelMap.FirstName}</label> <span style="color:red">(*)</span></td>
					<td>
						<input type="text" name="firstName" id="firstName"/>
					</td>
					<td><label class="padding-bottom5 padding-right15 margin-left30" for="middleName">${uiLabelMap.MiddleName}</label></td>
					<td>
						<input type="text" name="middleName" id="middleName"/>
					</td>
					<td><label class="padding-bottom5 padding-right15 margin-left30" for="lastName">${uiLabelMap.LastName}</label> <span style="color:red">(*)</span></td>
					<td>
						<input type="text" name="lastName" id="lastName"/>
					</td>
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="gender">${uiLabelMap.Gender}</label></td>
					<td>
						<select name="gender" id="gender">
							<option value="M">${uiLabelMap.Male}</option>
							<option value="F">${uiLabelMap.Female}</option>
						</select>
					</td>
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="birthDate">${uiLabelMap.BirthDate}</label></td>
					<td style="padding: 0">
						 <@htmlTemplate.renderDateTimeField name="birthDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd" size="25" maxlength="30" id="birthDay" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</td>
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="form-field-1">${uiLabelMap.HrolbiusNationality}:</label></td>
					<td>
						<select name="nationality">
							<#list nationality as nation>	
								<option value="${nation.nationalityId}" >
									${nation.description}
								</option>
							</#list>
						</select>
					</td>
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="height">${uiLabelMap.Height}</label></td>
					<td>
						 <input type="text" id="height" name="height"/>
					</td>
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="weight">${uiLabelMap.Weight}</label></td>
					<td>
						 <input type="text" id="weight" name="weight"/>
					</td>
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="idNumber">${uiLabelMap.IDNumber}</label> <span style="color:red">(*)</span></td>
					<td>
						 <input type="text" id="idNumber" name="idNumber"/>
					</td>
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="idIssueDate">${uiLabelMap.IDIssueDate}</label></td>
					<td style="padding: 0">
				 		<@htmlTemplate.renderDateTimeField name="idIssueDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="idIssueDate" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</td>
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="idIssuePlace">${uiLabelMap.IDIssuePlace}</label></td>
					<td>
						 <input type="text" id="idIssuePlace" name="idIssuePlace"/>
					</td>
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="passportNumber">${uiLabelMap.PassportNumber}</label></td>
					<td>
				 		<input type="text" id="passportNumber" name="passportNumber"/>
					</td>
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="passportIssuePlace">${uiLabelMap.PassportIssuePlace}</label></td>
					<td>
				 		<input type="text" id="passportIssuePlace" name="passportIssuePlace"/>
					</td>
					
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="passportIssueDate">${uiLabelMap.PassportIssueDate}</label></td>
					<td style="padding: 0">
						 <@htmlTemplate.renderDateTimeField name="passportIssueDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="passportIssueDate" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</td>
					<td><label class=" padding-bottom5 padding-right15  margin-left30" for="passportExpiryDate">${uiLabelMap.PassportExpiryDate}</label></td>
					<td style="padding: 0">
				 		<@htmlTemplate.renderDateTimeField name="passportExpiryDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="passportExpiryDate" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</td>
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="maritalStatus">${uiLabelMap.MaritalStatus}</label></td>
					<td>
						<#assign maritalStatusList = delegator.findList("MaritalStatus", null , null, orderBy,null, false)>
							 <select name = "maritalStatus" id = "maritalStatus">
				 				<option value="">
									&nbsp
				 				</option>
				 				<#list maritalStatusList as maritalStatus>
				 				<option value="${maritalStatus.maritalStatusId}">
				 					${maritalStatus.description?if_exists}
				 				</option>
				 				</#list>
				 			</select>
					</td>
					<td>
						<label class="padding-bottom5 padding-right15  margin-left30" for="numberChildren">${uiLabelMap.NumberChildren} (${uiLabelMap.HRCommonIfHave})</label>
					</td>
					<td>
						<input type="text" id="numberChildren" name="numberChildren"/>
					</td>
				</tr>
				<tr>
					<td><label class="padding-bottom5 padding-right15" for="ethnicOrigin">${uiLabelMap.EthnicOrigin}</label></td>
					<td>
						 <#assign ethnicOriginList = delegator.findList("EthnicOrigin", null , null, orderBy,null, false)>
						 <select name = "ethnicOrigin" id = "ethnicOrigin">
						 	<option value="">
								&nbsp
						 	</option>
						 	<#list ethnicOriginList as ethnicOrigin>
						 		<option value="${ethnicOrigin.ethnicOriginId}">
						 			${ethnicOrigin.description?if_exists}
						 		</option>
						 	</#list>
						 </select>
					</td>			
					<td><label class="padding-bottom5 padding-right15  margin-left30" for="religion">${uiLabelMap.Religion}</label></td>
					<td>
						<#assign religionList = delegator.findList("Religion", null , null, orderBy,null, false)>
						 <select name = "religion" id = "religion">
						 	<option value="">
								&nbsp
						 	</option>
						 	<#list religionList as religion>
						 		<option value="${religion.religionId}">
						 			${religion.description?if_exists}
						 		</option>
						 	</#list>
						 </select>
					</td>
				</tr>
			</tbody>						
		</table>
	</div>
</div>
<style>
.custom-modal{
	position: fixed;
	left: 50%;
	margin-left: -300px;
	width: 600px;
}
</style>

<div class="row-fluid">
	<div class="span12 margin-top30" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<div class="title-border">
			<span>${uiLabelMap.HRCommonEducation}</span>
		</div>
		<div id="tableContainEducation">
		
		</div>
		<h5 class="pink">
			<i class="icon-hand-right icon-animated-hand-pointer blue"></i>
			<a href="#AddPersonEducation" role="button" class="blue" data-toggle="modal">${uiLabelMap.AddPersonEducation}</a>
		</h5>
	</div>	
</div>

<div class="row-fluid">
	<div class="span12 margin-top30" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<div class="title-border">
			<span>${uiLabelMap.HRWorkingProcess}</span>
		</div>
		<div id="tableContainWork">
		
		</div>
		<h5 class="pink">
			<i class="icon-hand-right icon-animated-hand-pointer blue"></i>
			<a href="#AddWorkingProcess" role="button" class="blue" data-toggle="modal">${uiLabelMap.AddWorkingProcess}</a>
		</h5>	
	</div>
</div>

<div class="row-fluid">
	<div class="span12 margin-top30" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<div class="title-border">
			<span>${uiLabelMap.HRFamilyBackground}</span>
		</div>
		<div id="tableContain">
		
		</div>
		<h5 class="pink">
			<i class="icon-hand-right icon-animated-hand-pointer blue"></i>
			<a href="#FamilyBackground" role="button" class="blue" data-toggle="modal">${uiLabelMap.HRFamilyBackground}</a>
		</h5>	
	</div>
</div>

	
<div class="row-fluid">
	<div class="span12 margin-top30 form-horizontal" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<div class="title-border">
			<span>${uiLabelMap.HRCommonPartySkill}</span>
		</div>
		<div id="skillTypeTableContain">
		
		</div>
		<#assign SkillTypeList = delegator.findByAnd("SkillType", Static["org.ofbiz.base.util.UtilMisc"].toMap("parentTypeId", null), null, false)>
		<div class="control-group">
			<label>
				<label for="SkillTypeList" id="SkillTypeList_title">${uiLabelMap.SkillType}</label>  
			</label>
			<div class="controls">
				<select name="SkillTypeList" id="SkillTypeList">
					<option value=""></option>
				 	<#list SkillTypeList as skillType>
				 		<option value="${skillType.skillTypeId}">
				 			${skillType.description?if_exists}
				 		</option>
				 	</#list>
				</select>
			</div>
		</div>
		<div id="skillTypeId">
			
		</div>
		<div class="control-group">
			<label>
				<label>&nbsp;</label>  
			</label>
			<div class="controls">
				<button class="btn btn-small btn-primary" type="button" data-dismiss="modal" id="skillTypeBtn">
					<i class="icon-ok"></i>
					${uiLabelMap.CommonAdd}
				</button>
			</div>
		</div>
	</div>
</div>

<div id="FamilyBackground" class="modal hide fade" tabindex="-1">
	<div class="modal-header no-padding">
		<div class="table-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			${uiLabelMap.FamilyBackground}
		</div>
	</div>
	<div class="modal-body no-padding">
		<div class="row-fluid form-horizontal">
			<form name="familyForm" id="familyForm">
			
			<div class="control-group">
				<label class="control-label">
					<label for="firstNameFamily" class="asterisk" id="_title">${uiLabelMap.FirstName}</label>  
				</label>
				<div class="controls">
					<input type="text" name="firstNameFamily" id="firstNameFamily">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="middleNameFamily" class="asterisk" id="_title">${uiLabelMap.MiddleName}</label>  
				</label>
				<div class="controls">
					<input type="text" name="middleNameFamily" id="middleNameFamily">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="lastNameFamily" class="asterisk" id="_title">${uiLabelMap.LastName}</label>  
				</label>
				<div class="controls">
					<input type="text" name="lastNameFamily" id="lastNameFamily">
				</div>
			</div>
			<div class="control-group">
				<#assign partyRelationshipType = delegator.findByAnd("PartyRelationshipType", Static["org.ofbiz.base.util.UtilMisc"].toMap("parentTypeId", "FAMILY"), null, false)>
				<label class="control-label">
					<label for="relationship" class="asterisk" id="_title">${uiLabelMap.HRRelationship}</label>  
				</label>
				<div class="controls">
					<select name="partyRelationshipTypeId" id="relationship">
						<#list partyRelationshipType as partyRel>
							<option value="${partyRel.partyRelationshipTypeId}">${partyRel.partyRelationshipName}</option>
						</#list>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="personAge" class="asterisk" id="personAge_title">${uiLabelMap.HRCommonAge}</label>   
				</label>
				<div class="controls">
					<input type="text" name="age" id="personAge">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="occupation" class="asterisk" id="occupation_title">${uiLabelMap.HROccupation}</label>   
				</label>
				<div class="controls">
					<input type="text" name="occupation" id="occupation">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="placeWork" class="asterisk" id="placeWork_title">${uiLabelMap.HRPlaceWork}</label>   
				</label>
				<div class="controls">
					<textarea name="placeWork" id="placeWork"></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="phoneNumber" class="asterisk" id="placeWork_title">${uiLabelMap.PhoneNumber}</label>   
				</label>
				<div class="controls">
					<input type="text" name="phoneNumber" id="phoneNumber">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label>&nbsp;</label>  
				</label>
				<div class="controls">
					<button class="btn btn-small btn-primary" data-dismiss="modal" id="FamilyBackgroundBtn">
						<i class="icon-ok"></i>
						${uiLabelMap.CommonSubmit}
					</button>
				</div>
			</div>
			</form>
		</div>
	</div>			
</div>

<div id="AddPersonEducation" class="modal hide fade" tabindex="-1">
	<div class="modal-header no-padding">
		<div class="table-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			${uiLabelMap.AddPersonEducation}
		</div>
	</div>

	<div class="modal-body no-padding">
		<div class="row-fluid form-horizontal">
			<div class="control-group">
				<label class="control-label">
					<label for="school" class="asterisk" id="CollegeName_title">${uiLabelMap.HRCollegeName}</label>  
				</label>
				<div class="controls">
					<span class="ui-widget">
						<#assign schoolList = delegator.findByAnd("EducationSchool", null, null, false)>
						<select name="schoolId" id="school">
						 	<#list schoolList as school>
						 		<option value="${school.schoolId}">
						 			${school.schoolName?if_exists}
						 		</option>
						 	</#list>
					 	</select>
					</span>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="educationFromDate" class="asterisk" id="educationFromDate_title">${uiLabelMap.CommonFromDate}</label>  
				</label>
				<div class="controls">
					<@htmlTemplate.renderDateTimeField name="educationFromDate" id="educationFromDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd" size="25" maxlength="30"  dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="educationFromDate" class="asterisk" id="CollegeName_title">${uiLabelMap.CommonThruDate}</label>  
				</label>
				<div class="controls">
					<@htmlTemplate.renderDateTimeField name="educationThruDate" id="educationThruDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd" size="25" maxlength="30" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="major" class="asterisk" id="major_title">${uiLabelMap.HRSpecialization}</label>  
				</label>
				<div class="controls">
					<#assign majorList = delegator.findList("Major", null , null, orderBy,null, false)>
					 <select name = "majorId" id = "major">
					 	<#list majorList as major>
					 		<option value="${major.majorId}">
					 			${major.description?if_exists}
					 		</option>
					 	</#list>
					 </select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="studyModeType" class="asterisk" id="studyMode_title">${uiLabelMap.HROlbiusTrainingType}</label>  
				</label>
				<div class="controls">
					<#assign studyModeType = delegator.findByAnd("StudyModeType", null ,null , false)>
					 <select name="studyModeTypeId" id="studyModeType">
					 	<#list studyModeType as type>
					 		<option value="${type.studyModeTypeId}">
					 			${type.description?if_exists}
					 		</option>
					 	</#list>
					 </select>	
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="degreeClassificationType" class="asterisk" id="degreeClassificationType_title">${uiLabelMap.HRCommonClassification}</label>  
				</label>
				<div class="controls">
					<#assign degreeClassificationType = delegator.findByAnd("DegreeClassificationType", null, null, false)>
					<select name="degreeClassificationTypeId" id="degreeClassificationType">
					 	<#list degreeClassificationType as classification>
					 		<option value="${classification.classificationTypeId}">
					 			${classification.description?if_exists}
					 		</option>
					 	</#list>
					</select>	
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="educationSystemType" class="asterisk" id="educationSystemType_title">${uiLabelMap.HRCommonSystemEducation}</label>  
				</label>
				<div class="controls">
					<#assign educationSystemType = delegator.findByAnd("EducationSystemType", null, null, false)>
					<select name="educationSystemTypeId" id="educationSystemType">
					 	<#list educationSystemType as systemType>
					 		<option value="${systemType.educationSystemTypeId}">
					 			${systemType.description?if_exists}
					 		</option>
					 	</#list>
					</select>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label>&nbsp;</label>  
				</label>
				<div class="controls">
					<button class="btn btn-small btn-primary" data-dismiss="modal" id="PersonEducationBtn">
						<i class="icon-ok"></i>
						${uiLabelMap.CommonSubmit}
					</button>
				</div>
			</div>
		</div>
	</div>
</div>
	
<div id="AddWorkingProcess" class="modal hide fade" tabindex="-1">
	<div class="modal-header no-padding">
		<div class="table-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			${uiLabelMap.AddWorkingProcess}
		</div>
	</div>
	<div class="modal-body no-padding">
		<div class="row-fluid form-horizontal">
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_fromDate" class="asterisk" id="workProcess_fromDate_title">${uiLabelMap.CommonFromDate}</label>  
				</label>
				
					<div class="controls">
						<@htmlTemplate.renderDateTimeField name="workProcess_fromDate" id="workProcess_fromDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd" size="25" maxlength="30" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</div>
				
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_thruDate" class="asterisk" id="workProcess_thruDate_title">${uiLabelMap.CommonThruDate}</label>  
				</label>
				
					<div class="controls">
						<@htmlTemplate.renderDateTimeField name="workProcess_thruDate" id="workProcess_thruDate" value="" event="" action="" className="" alert="" title="Format: yyyy-MM-dd" size="25" maxlength="30" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</div>
				
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_companyName" class="asterisk" id="workProcess_companyName_title">${uiLabelMap.CompanyName}</label>  
				</label>
				<div class="controls">
					<input type="text" name="companyName" id="workProcess_companyName">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_EmplPositionType" class="asterisk" id="workProcess_companyName_title">${uiLabelMap.EmplPositionTypeId}</label>  
				</label>
				<div class="controls">
					<input type="text" name="emplPositionTypeIdWorkProcess" id="workProcess_EmplPositionType">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_JobDescription" class="asterisk" id="workProcess_JobDescription_title">${uiLabelMap.JobDescription}</label>  
				</label>
				<div class="controls">
						<textarea name="jobDescription" id="workProcess_JobDescription"></textarea>
				
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_Payroll" class="asterisk" id="workProcess_Payroll_title">${uiLabelMap.HRSalary}</label>  
				</label>
				<div class="controls">
						<input type="text" name="payroll" id="workProcess_Payroll">
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_TerminationReason" class="asterisk" id="workProcess_TerminationReason_title">${uiLabelMap.TerminationReason}</label>  
				</label>
				<div class="controls">
						<textarea name="terminationReasonId" id="workProcess_TerminationReason"></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label for="workProcess_rewardDiscrip" class="asterisk" id="workProcess_rewardDiscrip_title">${uiLabelMap.HRRewardAndDisciplining}</label>  
				</label>
				<div class="controls">
					<textarea name="rewardDiscrip" id="workProcess_rewardDiscrip"></textarea>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					<label>&nbsp;</label>  
				</label>
				<div class="controls">
					<button class="btn btn-small btn-primary" data-dismiss="modal" id="WorkingProcessBtn">
						<i class="icon-ok"></i>
						${uiLabelMap.CommonSubmit}
					</button>
				</div>
			</div>
		</div>
	</div>		
</div>

<script type="text/javascript">
var eduProcessIndex = 0;
var workingProcessIndex = 0;
var familyBackgroudIndex = 0;
var skillTypeIndex = 0;

$(document).ready(function() {
	
	var suffix = "_o_";
	var familyBackgroundId = "familyBackCommonId";
	var educationId = "educationCommonId";
	var workingProcessId = "workProcessCommonId";
	var skillTypeCommonId = "skillTypeCommonId";
	
	jQuery("#SkillTypeList").change(function(){
		skillTypeChange("SkillTypeList", true);
	});
	
	jQuery("#FamilyBackgroundBtn").click(function(){
		alert(1);
		if(!jQuery("#familyBackgroundTable").length){
			var tempTable =  jQuery("<table class=\"table table-hover table-striped table-bordered dataTable\" id=\"familyBackgroundTable\"/>");
			jQuery("#tableContain").append(tempTable);
			var tableHeader = jQuery("<thead/>");
			tableHeader.append(jQuery("<th>${uiLabelMap.FirstName}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.MiddleName}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.LastName}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HRRelationship}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HRCommonAge}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HROccupation}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HRPlaceWork}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.PhoneNumber}</th>"));
			tableHeader.append(jQuery("<th></th>"));
			tempTable.append(tableHeader);
			tempTable.append(jQuery("<tbody/>"));
		}
		var tr = jQuery("<tr id='"+ familyBackgroundId + suffix + familyBackgroudIndex +"'/>");
		tr.append("<td>"+ jQuery("#firstNameFamily").val() +" <input type='hidden' name='"+ jQuery("#firstNameFamily").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#firstNameFamily").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#middleNameFamily").val() +" <input type='hidden' name='"+ jQuery("#middleNameFamily").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#middleNameFamily").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#lastNameFamily").val() +" <input type='hidden' name='"+ jQuery("#lastNameFamily").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#lastNameFamily").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#relationship option:selected").text() +" <input type='hidden' name='"+ jQuery("#relationship").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#relationship").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#personAge").val() +" <input type='hidden' name='"+ jQuery("#personAge").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#personAge").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#occupation").val() +" <input type='hidden' name='"+ jQuery("#occupation").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#occupation").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#placeWork").val() + " <input type='hidden' name='"+ jQuery("#placeWork").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#placeWork").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#phoneNumber").val() + " <input type='hidden' name='"+ jQuery("#phoneNumber").attr("name") + suffix + familyBackgroudIndex +"' value='"+ jQuery("#phoneNumber").val() +"'/></td>");
		var btnDel = jQuery("<button class='btn-mini btn-danger btn' onclick=\"deleteRow('"+ familyBackgroundId + suffix + familyBackgroudIndex + "', 'familyBackgroudIndex')\"/>");
		btnDel.append("<i class='icon-trash icon-only'/>");
		tr.append(jQuery("<td/>").append(btnDel));
		$('#familyBackgroundTable > tbody:last').append(tr);
		familyBackgroudIndex++;
		
	});
	jQuery("#PersonEducationBtn").click(function(){
		if(!jQuery("#PersonEducationTable").length){
			var tempTable =  jQuery("<table class=\"table table-hover table-striped table-bordered dataTable\" id=\"PersonEducationTable\"/>");
			jQuery("#tableContainEducation").append(tempTable);
			var tableHeader = jQuery("<thead/>");
			tableHeader.append(jQuery("<th>${uiLabelMap.HRCollegeName}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.CommonFromDate}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.CommonThruDate}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HRSpecialization}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HROlbiusTrainingType}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HRCommonClassification}</th>"));
			tableHeader.append(jQuery("<th>${uiLabelMap.HRCommonSystemEducation}</th>"));
			tableHeader.append(jQuery("<th></th>"));
			tempTable.append(tableHeader);
			tempTable.append(jQuery("<tbody/>"));
		}
		var tr = jQuery("<tr id='" + educationId + suffix + eduProcessIndex + "'/>");
		tr.append("<td>"+ jQuery("#school option:selected").text() +" <input type='hidden' name='"+ jQuery("#school").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#school").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#educationFromDate").val() +" <input type='hidden' name='"+ jQuery("#educationFromDate").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#educationFromDate").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#educationThruDate").val() +" <input type='hidden' name='"+ jQuery("#educationThruDate").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#educationThruDate").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#major option:selected").text() +" <input type='hidden' name='"+ jQuery("#major").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#major").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#studyModeType option:selected").text() +" <input type='hidden' name='"+ jQuery("#studyModeType").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#studyModeType").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#degreeClassificationType option:selected").text() +" <input type='hidden' name='"+ jQuery("#degreeClassificationType").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#degreeClassificationType").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#educationSystemType option:selected").text() + " <input type='hidden' name='"+ jQuery("#educationSystemType").attr("name") + suffix + eduProcessIndex +"' value='"+ jQuery("#educationSystemType").val() +"'/></td>");
		var btnDel = jQuery("<button class='btn-mini btn-danger btn' onclick=\"deleteRow('"+ educationId + suffix + eduProcessIndex + "', 'eduProcessIndex')\"/>");
		btnDel.append("<i class='icon-trash icon-only'/>");
		tr.append(jQuery("<td/>").append(btnDel));
		$('#PersonEducationTable > tbody:last').append(tr);
		eduProcessIndex++;
	});
	jQuery("#WorkingProcessBtn").click(function(){
		if(!jQuery("#WorkingProcessTable").length){
			var tempTable =  jQuery("<table class=\"table table-hover table-striped table-bordered dataTable\" id=\"WorkingProcessTable\"/>");
			jQuery("#tableContainWork").append(tempTable);
			var tableHeader = jQuery("<thead/>");
			var trHeader = jQuery("<tr/>");
			trHeader.append(jQuery("<th>${uiLabelMap.CommonFromDate}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.CommonThruDate}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.CompanyName}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.EmplPositionTypeId}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.JobDescription}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.HRSalary}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.TerminationReason}</th>"));
			trHeader.append(jQuery("<th>${uiLabelMap.HRRewardAndDisciplining}</th>"));	
			trHeader.append(jQuery("<th></th>"));
			tableHeader.append(trHeader);
			tempTable.append(tableHeader);
			tempTable.append(jQuery("<tbody/>"));
		}
		var tr = jQuery("<tr id='"+ workingProcessId + suffix + workingProcessIndex +"'/>");
		tr.append("<td>"+ jQuery("#workProcess_fromDate").val() +" <input type='hidden' name='"+ jQuery("#workProcess_fromDate").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_fromDate").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_thruDate").val() +" <input type='hidden' name='"+ jQuery("#workProcess_thruDate").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_thruDate").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_companyName").val() +" <input type='hidden' name='"+ jQuery("#workProcess_companyName").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_companyName").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_EmplPositionType").val() +" <input type='hidden' name='"+ jQuery("#workProcess_EmplPositionType").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_EmplPositionType").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_JobDescription").val() +" <input type='hidden' name='"+ jQuery("#workProcess_JobDescription").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_JobDescription").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_Payroll").val() +" <input type='hidden' name='"+ jQuery("#workProcess_Payroll").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_Payroll").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_TerminationReason").val() +" <input type='hidden' name='"+ jQuery("#workProcess_TerminationReason").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_TerminationReason").val() +"'/></td>");
		tr.append("<td>"+ jQuery("#workProcess_rewardDiscrip").val() +" <input type='hidden' name='"+ jQuery("#workProcess_rewardDiscrip").attr("name") + suffix + workingProcessIndex +"' value='"+ jQuery("#workProcess_rewardDiscrip").val() +"'/></td>");
		var btnDel = jQuery("<button class='btn-mini btn-danger btn' onclick=\"deleteRow('"+ workingProcessId + suffix + workingProcessIndex +  "', 'workingProcessIndex')\"/>");
		btnDel.append("<i class='icon-trash icon-only'/>");
		tr.append(jQuery("<td/>").append(btnDel));
		$('#WorkingProcessTable > tbody:last').append(tr);
		workingProcessIndex++;
	});
	
	jQuery("#skillTypeBtn").click(function(){
		var skillType = $("#SkillTypeList").val();
		if (skillType != ''){
			if(!jQuery("#skillTypeTable").length){
				var tempTable =  jQuery("<table class=\"table table-hover table-striped table-bordered dataTable\" id=\"skillTypeTable\"/>");
				jQuery("#skillTypeTableContain").append(tempTable);
				var tableHeader = jQuery("<thead/>");
				var trHeader = jQuery("<tr/>");
				trHeader.append(jQuery("<th>${uiLabelMap.SkillType}</th>"));
				trHeader.append(jQuery("<th>${uiLabelMap.HRSkillLever}</th>"));
				trHeader.append(jQuery("<th></th>"));
				tableHeader.append(trHeader);
				tempTable.append(tableHeader);
				tempTable.append(jQuery("<tbody/>"));
			}
			var tr = jQuery("<tr id='" + skillTypeCommonId + suffix + skillTypeIndex + "'/>");
			var ratingEle = jQuery("input[name='skillRating']");
			var ratingValue;
			var ratingDesc;
			if(ratingEle.attr("type") == "radio"){
				console.log("radio");
				ratingValue = ratingEle.filter(':checked').val();
				ratingDesc = ratingEle.filter(':checked').attr("description");
			}else{
				ratingValue = ratingEle.val();
				ratingDesc = ratingValue;
			}
			var selectedId = jQuery("input[name='skillRating']").attr("selectedid");
			var selectedValue = jQuery("#" + selectedId).val();
			var selectedText = jQuery("#" + selectedId).find(":selected").text();
			
			tr.append("<td>" + selectedText + " <input type='hidden' name=\"skillTypeId" + suffix + skillTypeIndex + "\" value=\"" + selectedValue + "\"/></td>");
			tr.append("<td>" + ratingDesc +"<input type='hidden' name=\"skillLevelId" + suffix + skillTypeIndex + "\" value=\"" + ratingValue + "\"/></td>");
			var btnDel = jQuery("<button class='btn-mini btn-danger btn' onclick=\"deleteRow('"+ skillTypeCommonId + suffix + skillTypeIndex + "', 'skillTypeIndex')\"/>");
			btnDel.append("<i class='icon-trash icon-only'/>");
			tr.append(jQuery("<td/>").append(btnDel));
			$('#skillTypeTable > tbody:last').append(tr);
			skillTypeIndex++;
			}
	});
	
});

function deleteRow(rowId, type){
	$('#' + rowId).remove();
	//console.log(type);
	if(type === "skillTypeIndex"){
		skillTypeIndex--;
		//console.log(skillTypeIndex);
	}else if(type === "workingProcessIndex"){
		workingProcessIndex--;
		//console.log(workingProcessIndex);
	}else if(type === "eduProcessIndex"){
		eduProcessIndex--;
		//console.log(eduProcessIndex);
	}else if(type === "familyBackgroudIndex"){
		familyBackgroudIndex--;
		//console.log(familyBackgroudIndex);
	}
} 

function skillTypeChange(selectedId, emptyDiv){	 
	var skillTypeId = jQuery("#" + selectedId).val();
	jQuery.ajax({
		url: "<@ofbizUrl>getChildrenSkillType</@ofbizUrl>",
		type: "POST",
		data: {skillTypeId: skillTypeId},
		dataType  : 'json',
		success: function(data){
			if(emptyDiv){
				jQuery("#skillTypeId").empty();	
			}
			if(data.hasChildren === "Y"){
				jQuery("#" + selectedId).closest("div.control-group").nextAll("#skillTypeId .control-group").remove();
				var children = data.childrenList;
				var selectDiv = jQuery("<div class=\"control-group\"/>");
				var selectDivControl = jQuery("<div class=\"controls\"/>");
				var selectEleChildId = skillTypeId + "_Child"; 
				var tempSelect = jQuery("<select id=\""+ selectEleChildId +"\" onchange=\"skillTypeChange('"+ selectEleChildId + "', false)\"/>");
				jQuery("<option/>").appendTo(tempSelect);
				for(var index in children){
					jQuery("<option/>", {value: children[index].skillTypeId, text: children[index].description}).appendTo(tempSelect);	
				}
				tempSelect.appendTo(selectDivControl);
				jQuery("<label>&nbsp;</label>").appendTo(selectDiv);
				selectDiv.append(selectDivControl);
				jQuery("#skillTypeId").append(selectDiv);				
			}else if(data.hasChildren === "N"){
				jQuery("#rating").remove();
				var tempDiv = jQuery("<div class=\"control-group\" id=\"rating\"/>");
				jQuery("<label for=\"rating\" id=\"rating_title\">${uiLabelMap.HRSkillLever}</label>").appendTo(tempDiv);
				var divControl = jQuery("<div class=\"controls\"/>");
				tempDiv.append(divControl);
				if(data.hasSkillTypeLevel === "Y"){
					var levelType = data.skillTypeLevel;
					for(var index in levelType){
						var radio = jQuery("<input name=\"skillRating\" value=\""+ levelType[index].levelTypeId +"\" type=\"radio\" description=\"" + levelType[index].description + "\" selectedid=\"" + selectedId + "\"/>");
						var labelRadio = jQuery("<span class=\"lbl\" style=\"margin-top: 10px!important\">"+ levelType[index].description + "</span>");
						var label = jQuery("<label/>");
						label.append(radio);
						label.append(labelRadio);
						divControl.append(label);						
					}
				}else{
					jQuery("<input type=\"text\" name=\"skillRating\" selectedid=\"" + selectedId + "\" id=\"rating\"/>").appendTo(divControl);
				}
				jQuery("#skillTypeId").append(tempDiv);
			}			
		}
		
	});
}
</script>
