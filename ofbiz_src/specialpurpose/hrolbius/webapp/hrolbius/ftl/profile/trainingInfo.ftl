<script>
	//Prepare for school data
	<#assign listSchools = delegator.findList("EducationSchool", null, null, null, null, false) >
	var schoolData = new Array();
	<#list listSchools as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.schoolName?if_exists) />
		row['schoolId'] = '${item.schoolId}';
		row['description'] = '${description}';
		schoolData[${item_index}] = row;
	</#list>

	//Prepare for major data
	<#assign listMajors = delegator.findList("Major", null, null, null, null, false) >
	var majorData = new Array();
	<#list listMajors as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['majorId'] = '${item.majorId}';
		row['description'] = '${description}';
		majorData[${item_index}] = row;
	</#list>

	//Prepare for study mode data
	<#assign listStudyModes = delegator.findList("StudyModeType", null, null, null, null, false) >
	var studyModeData = new Array();
	<#list listStudyModes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['studyModeTypeId'] = '${item.studyModeTypeId}';
		row['description'] = '${description}';
		studyModeData[${item_index}] = row;
	</#list>

	//Prepare for Degree Classification Type data
	<#assign listDegree = delegator.findList("DegreeClassificationType", null, null, null, null, false) >
	var degreeData = new Array();
	<#list listDegree as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['classificationTypeId'] = '${item.classificationTypeId}';
		row['description'] = '${description}';
		degreeData[${item_index}] = row;
	</#list>

	//Prepare for education system type data
	<#assign listEducationSys = delegator.findList("EducationSystemType", null, null, null, null, false) >
	var eduSystemData = new Array();
	<#list listEducationSys as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['educationSystemTypeId'] = '${item.educationSystemTypeId}';
		row['description'] = '${description}';
		eduSystemData[${item_index}] = row;
	</#list>
</script>
<div class="tab-pane" id="trainingInfoTab">
	<#assign dataField="[{ name: 'partyId', type: 'string' },
						{ name: 'schoolId', type: 'string' },
						{ name: 'majorId', type: 'string' },
						{ name: 'studyModeTypeId', type: 'string' },
						{ name: 'classificationTypeId', type: 'string' },
						{ name: 'educationSystemTypeId', type: 'string'},
						{ name: 'fromDate', type: 'date', other: 'Timestamp'},
						{ name: 'thruDate', type: 'date', other: 'Timestamp'},
						]"/>

	<#assign columnlist="{ text: '${uiLabelMap.HRCollegeName}', datafield: 'schoolId', width: 200,
							cellsrenderer: function(column, row, value){
								for(var i = 0;  i < schoolData.length; i++){
									if(schoolData[i].schoolId == value){
										return '<span title=' + value + '>' + schoolData[i].description + '</span>'
									}
								}
								return '<span>' + value + '</span>'
							}
						 },
						 { text: '${uiLabelMap.CommonFromDate}', datafield: 'fromDate', width: 200, cellsformat: 'd', filtertype:'range'},
						 { text: '${uiLabelMap.CommonThruDate}', datafield: 'thruDate', width: 200, cellsformat: 'd', filtertype:'range'},
						 { text: '${uiLabelMap.HRSpecialization}', datafield: 'majorId',
								cellsrenderer: function(column, row, value){
									for(var i = 0;  i < majorData.length; i++){
										if(majorData[i].majorId == value){
											return '<span title=' + value + '>' + majorData[i].description + '</span>'
										}
									}
									return '<span>' + value + '</span>'
								}
						 },
						 { text: '${uiLabelMap.HROlbiusTrainingType}', datafield: 'studyModeTypeId',
								cellsrenderer: function(column, row, value){
									for(var i = 0;  i < studyModeData.length; i++){
										if(studyModeData[i].studyModeTypeId == value){
											return '<span title=' + value + '>' + studyModeData[i].description + '</span>'
										}
									}
									return '<span>' + value + '</span>'
								}
						 },
						 { text: '${uiLabelMap.HRCommonClassification}', datafield: 'classificationTypeId',
								cellsrenderer: function(column, row, value){
									for(var i = 0;  i < degreeData.length; i++){
										if(degreeData[i].classificationTypeId == value){
											return '<span title=' + value + '>' + degreeData[i].description + '</span>'
										}
									}
									return '<span>' + value + '</span>'
								}
						 },
						 { text: '${uiLabelMap.educationSystemTypeId}', datafield: 'educationSystemTypeId',
								cellsrenderer: function(column, row, value){
									for(var i = 0;  i < eduSystemData.length; i++){
										if(eduSystemData[i].educationSystemTypeId == value){
											return '<span title=' + value + '>' + eduSystemData[i].description + '</span>'
										}
									}
									return '<span>' + value + '</span>'
								}
						 }
					 "/>

	<@jqGrid addrow="false" addType="popup" isShowTitleProperty="false" id="jqxgridTrainingInfo" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true"
	url="jqxGeneralServicer?sname=JQGetListEmplEducation&partyId=${parameters.partyId}" dataField=dataField columnlist=columnlist
	/>
</div>