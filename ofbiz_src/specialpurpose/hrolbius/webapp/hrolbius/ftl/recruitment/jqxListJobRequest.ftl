<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxmaskedinput.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxeditor.js"></script>

<script>
	//Prepare data for Employee Position Type 
	<#assign currentDept = Static["com.olbius.util.PartyUtil"].getOrgByManager(userLogin, delegator)>
	<#assign listEmplPositionTypes = delegator.findList("DepPositionTypeView", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("deptId", currentDept), null, null, null, false) >
	var positionTypeData = new Array();
	<#list listEmplPositionTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['emplPositionTypeId'] = '${item.emplPositionTypeId}';
		row['description'] = '${description}';
		positionTypeData[${item_index}] = row;
	</#list>
	
	//Prepare data for Employee Position Type 
	<#assign listAllEmplPositionTypes = delegator.findList("EmplPositionType", null, null, null, null, false) >
	var allPositionTypeData = new Array();
	<#list listAllEmplPositionTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['emplPositionTypeId'] = '${item.emplPositionTypeId}';
		row['description'] = '${description}';
		allPositionTypeData[${item_index}] = row;
	</#list>
	
	//Prepare data for Recruitment Type 
	<#assign listRecruitmentTypes = delegator.findList("RecruitmentType", null, null, null, null, false) >
	var recruitmentTypeData = new Array();
	<#list listRecruitmentTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['recruitmentTypeId'] = '${item.recruitmentTypeId}';
		row['description'] = '${description}';
		recruitmentTypeData[${item_index}] = row;
	</#list>
	
	//Prepare data for Recruitment Form 
	<#assign listRecruitmentForms = delegator.findList("RecruitmentForm", null, null, null, null, false) >
	var recruitmentFormData = new Array();
	<#list listRecruitmentForms as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['recruitmentFormId'] = '${item.recruitmentFormId}';
		row['description'] = '${description}';
		recruitmentFormData[${item_index}] = row;
	</#list>
	
	//Prepare data for Recruitment Criteria 
	<#assign listRecruitmentCriterias = delegator.findList("EmplPositionTypeCriteriaView", null, null, null, null, false) >
	var recruitmentCriteriaData = new Array();
	<#list listRecruitmentCriterias as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['recruitmentCriteriaId'] = '${item.recruitmentCriteriaId}';
		row['emplPositionTypeId'] = '${item.emplPositionTypeId}';
		row['description'] = '${description}';
		recruitmentCriteriaData[${item_index}] = row;
	</#list>
	
	//Prepare for party data
	<#assign listParties = delegator.findList("PartyNameView", null, null, null, null, false) />
	var partyData = new Array();
	<#list listParties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.groupName?if_exists) + " " + StringUtil.wrapString(item.firstName?if_exists) + " " + StringUtil.wrapString(item.middleName?if_exists) + " " + StringUtil.wrapString(item.lastName?if_exists)>
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description}';
		partyData[${item_index}] = row;
	</#list>
	
	//Prepare for party data
	<#assign listStatus = delegator.findList("StatusItem", null, null, null, null, false) />
	var statusData = new Array();
	<#list listStatus as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists)>
		row['statusId'] = '${item.statusId}';
		row['description'] = '${description}';
		statusData[${item_index}] = row;
	</#list>
	
	 var idColumnFilter = function () {
         var filtergroup = new $.jqx.filter();
         var filter_or_operator = 1;
         var filtervalue = '${parameters.jobRequestId?if_exists}';
         var filtercondition = 'contains';
         var filter = filtergroup.createfilter('stringfilter', filtervalue, filtercondition);
         filtergroup.addfilter(filter_or_operator, filter);
         return filtergroup;
     }();
	
    var isHeadOfDept = false;
    var isAdmin = false;
    var isCeo = false;
 	<#if Static['com.olbius.util.PartyUtil'].isAdmin(userLogin.partyId, delegator)>
 		isAdmin = true;
 		var tmpStatusData = new Array();
 		var index = 0;
 		for(var i = 0; i < statusData.length; i++){
 			if('JR_ACCEPTED' == statusData[i].statusId || 'JR_REJECTED' == statusData[i].statusId || 'JR_PROPOSED' == statusData[i].statusId){
 				tmpStatusData[index] = statusData[i];
 				index++;
 			}
 		}
 	<#elseif Static['com.olbius.util.PartyUtil'].isCEO(delegator, userLogin)>
 		isCeo = true;
 		var tmpStatusData = new Array();
 		var index = 0;
 		for(var i = 0; i < statusData.length; i++){
 			if('JR_APPROVED' == statusData[i].statusId || 'JR_REJECTED' == statusData[i].statusId){
 				tmpStatusData[index] = statusData[i];
 				index++;
 			}
 		}
 	<#elseif !Static['com.olbius.util.PartyUtil'].isCEO(delegator, userLogin) && !Static['com.olbius.util.PartyUtil'].isAdmin(userLogin.partyId, delegator)>
 		isHeadOfDept = true;
 		var tmpStatusData = new Array();
 		var index = 0;
 		for(var i = 0; i < statusData.length; i++){
 			if('JR_PROPOSED' == statusData[i].statusId || 'JR_SCHEDULED' == statusData[i].statusId || 'JR_CANCELED' == statusData[i].statusId || 'JR_INIT' == statusData[i].statusId){
 				tmpStatusData[index] = statusData[i];
 				index++;
 			}
 		}
 	</#if>
</script>

<#assign rowdetailstemplateAdvance = "<ul style='margin-left: 30px;'><li class='title'>${uiLabelMap.Criteria}</li><li>${uiLabelMap.JobDescription}</li></ul><div class='criteria'></div><div class='description'></div>" />

<#assign dataField="[{ name: 'jobRequestId', type: 'string'},
					 { name: 'partyId', type: 'string' },
					 { name: 'fromDate', type: 'date', other: 'Timestamp' },
					 { name: 'thruDate', type: 'date', other: 'Timestamp' },
					 { name: 'emplPositionTypeId', type: 'string' },
					 { name: 'resourceNumber', type: 'number' },
					 { name: 'recruitmentTypeId', type: 'string' },
					 { name: 'recruitmentFormId', type: 'string' },
					 { name: 'jobDescription', type: 'string' },
					 { name: 'isInPlan', type: 'string' },
					 { name: 'statusId', type: 'string' },
					 { name: 'reason', type: 'string' }
					 ]"/>

<#assign columnlist="{ text: '${uiLabelMap.CommonId}', datafield: 'jobRequestId', width: 100, filter: idColumnFilter, editable: false},
                     { text: '${uiLabelMap.Department}', datafield: 'partyId', width: 250, editable: false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < partyData.length; i++){
								if(value == partyData[i].partyId){
									return '<span title=' + value + '>' + partyData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						}
                     },
                     { text: '${uiLabelMap.FromDate}', datafield: 'fromDate', width: 150, cellsformat: 'd', filtertype: 'range', editable: false},
                     { text: '${uiLabelMap.ThruDate}', datafield: 'thruDate', width: 150, cellsformat: 'd', filtertype: 'range', editable: false},
                     { text: '${uiLabelMap.Position}', datafield: 'emplPositionTypeId', width: 250, editable: false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < allPositionTypeData.length; i++){
								if(value == allPositionTypeData[i].emplPositionTypeId){
									return '<span title=' + value + '>' + allPositionTypeData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						}
                     },
                     { text: '${uiLabelMap.ResourceNumber}', datafield: 'resourceNumber', width: 150, editable: false},
                     { text: '${uiLabelMap.RecruitmentType}', datafield: 'recruitmentTypeId', width: 250, editable: false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < recruitmentTypeData.length; i++){
								if(value == recruitmentTypeData[i].recruitmentTypeId){
									return '<span title=' + value + '>' + recruitmentTypeData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						}
                     },
                     { text: '${uiLabelMap.RecruitmentForm}', datafield: 'recruitmentFormId', width: 250, editable: false,
						cellsrenderer: function(row, column, value){
							for(var i = 0; i < recruitmentFormData.length; i++){
								if(value == recruitmentFormData[i].recruitmentFormId){
									return '<span title=' + value + '>' + recruitmentFormData[i].description + '</span>'
								}
							}
							return '<span>' + value + '</span>';
						}
                     },
                     { text: '${uiLabelMap.InPlan}', datafield: 'isInPlan', width: 150, editable: false, 
                    	 cellsrenderer: function(row, column, value){
 							for(var i = 0; i < statusData.length; i++){
 								if(value == statusData[i].statusId){
 									return '<span title=' + value + '>' + statusData[i].description + '</span>'
 								}
 							}
 							return '<span>' + value + '</span>';
 						}
                     },
                     { text: '${uiLabelMap.Status}', datafield: 'statusId', width: 150, editable: true, columntype: 'dropdownlist',
                    	 cellsrenderer: function(row, column, value){
  							for(var i = 0; i < statusData.length; i++){
  								if(value == statusData[i].statusId){
  									return '<span title=' + value + '>' + statusData[i].description + '</span>'
  								}
  							}
  							return '<span>' + value + '</span>';
  						},
						createeditor: function (row, cellvalue, editor, celltext, cellwidth, cellheight) {
							var rowData = $('#jqxgrid').jqxGrid('getrowdata', row);
							var inPlan = rowData.isInPlan;
						    
							if(isHeadOfDept && inPlan == 'IJR_INPLAN'){
						    	/*if in plan*/
								for(var i = 0; i < tmpStatusData.length; i++){
						    		if(tmpStatusData[i].statusId == 'JR_PROPOSED'){
						    			tmpStatusData.splice(i, 1);
						    		}
						    	}
						    }else if(isHeadOfDept && inPlan == 'IJR_NINPLAN'){
						    	/*if not in plan*/
						    	for(var i = 0; i < tmpStatusData.length; i++){
						    		if(tmpStatusData[i].statusId == 'JR_SCHEDULED'){
						    			tmpStatusData.splice(i, 1);
						    		}
						    	}
						    }
							editor.jqxDropDownList({source: tmpStatusData, valueMember: 'statusId', displayMember:'statusId',
					        	selectionRenderer: function () {
					                var item = editor.jqxDropDownList('getSelectedItem');
					                if (item) {
					                	for(var i = 0; i < statusData.length; i++){
			  								if(item.value == statusData[i].statusId){
			  									return '<span title=' + item.value + '>' + statusData[i].description + '</span>'
			  								}
			  							}
					                }
					                return '<span>Please Choose:</span>';
					            },
					            renderer: function (index, label, value) {
					            	for(var i = 0; i < statusData.length; i++){
		  								if(value == statusData[i].statusId){
		  									return '<span title=' + value + '>' + statusData[i].description + '</span>'
		  								}
		  							}
		  							return '<span>' + value + '</span>';
					            }
					        });
					    },
					    cellbeginedit: function (row, datafield, columntype) {
					    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					    	if (isHeadOfDept && (data.statusId == 'JR_REJECTED' || data.statusId == 'JR_PROPOSED' || data.statusId == 'JR_ACCEPTED' || data.statusId == 'JR_APPROVED')) return false;
					    	if (isAdmin && (data.statusId == 'JR_APPROVED' || data.statusId == 'JR_PROPOSED')) return false;
					    }
                     },
                     { text: '${uiLabelMap.reason}', datafield: 'reason', width: 150, editable: true,
					    cellbeginedit: function (row, datafield, columntype) {
					    	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					    	if (isHeadOfDept && (data.statusId == 'JR_REJECTED' || data.statusId == 'JR_PROPOSED' || data.statusId == 'JR_ACCEPTED' || data.statusId == 'JR_APPROVED')) return false;
					    	if (isAdmin && (data.statusId == 'JR_APPROVED' || data.statusId == 'JR_PROPOSED')) return false;
					    }
                     }
					 "/>

<@jqGrid id="jqxgrid" filtersimplemode="true" addrefresh="true" rowdetailstemplateAdvance=rowdetailstemplateAdvance addType="popup" alternativeAddPopup="alterpopupNewJobRequest" addrow="true" showtoolbar="true" clearfilteringbutton="true"
		 url="jqxGeneralServicer?sname=JQGetListJobRequest" dataField=dataField columnlist=columnlist initrowdetailsDetail="initrowdetails" initrowdetails="true" editable="true"
		 createUrl="jqxGeneralServicer?sname=createJobRequest&jqaction=C" addColumns="workLocation;partyId;emplPositionTypeId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);resourceNumber(java.lang.Long);recruitmentTypeId;recruitmentFormId;listCriteria(java.util.List);jobDescription"
		 updateUrl="jqxGeneralServicer?sname=updateJobRequest&jqaction=U" editColumns="jobRequestId;partyId;statusId;reason;isInPlan"
		/>
<#--====================================================Create new popup window==========================================================-->
<div class="row-fluid">
	<div class="span12">
		<div id="alterpopupNewJobRequest">
			<div id="windowHeaderNewJobRequest">
	            <span>
	               ${uiLabelMap.NewJobRequest}
	            </span>
	        </div>
	        <div style="overflow: hidden; padding: 15px" id="windowContentNewPlan">
				<div class="basic-form form-horizontal" style="margin-top: 10px">
					<form name="createNewJobRequest" id="createNewJobRequest">
						<div class="row-fluid" >
							<div class="span12">
								<div class="span6">
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.Department}:</label>
										<div class="controls">
											<div id="partyIdLabel" style="height: 25px;"></div>
											<input id="partyIdAdd" type="hidden">
										</div>
									</div>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.Position}:</label>
										<div class="controls">
											<div id="emplPositionTypeId" ></div>
										</div>
									</div>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.workLocation}:</label>
										<div class="controls">
											<input id="workLocation"></input>
										</div>
									</div>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.FromDate}:</label>
										<div class="controls">
											<div id="fromDate"></div>
										</div>
									</div>
								</div>
								
								<div class="span6">
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.ThruDate}:</label>
										<div class="controls">
											<div id="thruDate" ></div>
										</div>
									</div>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.ResourceNumber}:</label>
										<div class="controls">
											<input id="resourceNumber"></input>
										</div>
									</div>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.RecruitmentType}:</label>
										<div class="controls">
											<div id="recruitmentTypeId" ></div>
										</div>
									</div>
									<div class="control-group no-left-margin">
										<label class="control-label">${uiLabelMap.RecruitmentForm}:</label>
										<div class="controls">
											<div id="recruitmentFormId" ></div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row-fluid" >
							<div class="span12">
								<div class="control-group no-left-margin">
									<label class="control-label">${uiLabelMap.Criteria}:</label>
									<div class="controls">
										<div id="listCriteria" ></div>
									</div>
								</div>
								<div class="control-group no-left-margin">
									<label class="control-label">${uiLabelMap.JobDescription}:</label>
									<div class="controls">
										<textarea id="jobDescription" ></textarea>
									</div>
								</div>
								<div class="control-group no-left-margin">
									<label class="control-label">&nbsp</label>
									<div class="controls">
										<button type="button" class="btn btn-mini btn-success" id="alterSave"><i class="icon-ok"></i>${uiLabelMap.CommonSubmit}</button>
										<button type="button" class="btn btn-mini btn-danger" id="alterCancel">${uiLabelMap.CommonCancel}&nbsp;<i class="icon-remove"></i></button>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
	        </div>
		</div>
	</div>
</div>
<#--====================================================/Create new popup window==========================================================-->
<script>
	/*
	 * Prepare data for popup window
	 * */
	$(document).ready(function(){
		
		//Create partyId
		<#assign partyId = Static["com.olbius.util.PartyUtil"].getOrgByManager(userLogin, delegator) >
		<#assign partyName = Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, partyId, false)>
		jQuery("#partyIdLabel").text('${StringUtil.wrapString(partyName)}');
		$("#partyIdAdd").val('${partyId}');
		
		//Create workLocation
		$("#workLocation").jqxInput({width: 195, height: 21});
		
		//Create emplPositionTypeId
		$("#emplPositionTypeId").jqxDropDownList({selectedIndex: 0, source: positionTypeData, valueMember: 'emplPositionTypeId', displayMember: 'description'});
		$("#emplPositionTypeId").on('change', function (event){
			var args = event.args;
		    if (args) {
			    var item = args.item;
			    var value = item.value;
			    var rcData = new Array();
				var index = 0;
				for(var i = 0; i < recruitmentCriteriaData.length; i++){
					if(recruitmentCriteriaData[i].emplPositionTypeId == value){
						rcData[index] = recruitmentCriteriaData[i];
						index++
						}
					}
		    }
		    $("#listCriteria").jqxDropDownList({source: rcData});
		});
		
		//Create fromDate
		$("#fromDate").jqxDateTimeInput({});
		
		//Create thruDate
		$("#thruDate").jqxDateTimeInput({});
		
		//Create resourceNumber
		$("#resourceNumber").jqxInput({width: 195, height: 21});
		
		//Create recruitmentTypeId
		$("#recruitmentTypeId").jqxDropDownList({selectedIndex: 0,source: recruitmentTypeData, valueMember: 'recruitmentTypeId', displayMember: 'description'});
		
		//Create recruitmentFormId
		$("#recruitmentFormId").jqxDropDownList({selectedIndex: 0,source: recruitmentFormData, valueMember: 'recruitmentFormId', displayMember: 'description'});
		
		//Create listCriteria
		var rcData = new Array();
		var index = 0;
		if(recruitmentCriteriaData.length && positionTypeData.length){
			for(var i = 0; i < recruitmentCriteriaData.length; i++){
				if(recruitmentCriteriaData[i].emplPositionTypeId == positionTypeData[0].emplPositionTypeId){
					rcData[index] = recruitmentCriteriaData[i];
					index++
				}
			}
		}
		
		$("#listCriteria").jqxDropDownList({source: rcData, width: '95%', checkboxes: true, valueMember: 'recruitmentCriteriaId', displayMember: 'description'});
		
		//Create window
		$("#alterpopupNewJobRequest").jqxWindow({
	        showCollapseButton: false, maxHeight: 1000, autoOpen: false, maxWidth: "80%", height: 650, minWidth: '40%', width: "80%", isModal: true,
	        theme:theme, collapsed:false, initContent: function () {
	        	$('#jobDescription').jqxEditor({
	                height: 300,
	                width: '95%',
	                tools: "bold italic underline | format font size | color background | left center right | outdent indent | ul ol | image | link | clean | html"
	    		});	
            }
	    });

		//update the edited row when the user clicks the 'Save' button.
	    $("#alterSave").click(function () {
	    	$('#createNewJobRequest').jqxValidator('validate');
	    });
	    
	    //update the edited row when the user clicks the 'Save' button.
	    //Handle if validation is success
	    $('#createNewJobRequest').on('validationSuccess', function (event) {
	    	var selectedItems = $("#listCriteria").jqxDropDownList('getCheckedItems');
	    	var selCriteriaItems = new Array();
	    	for(var i = 0; i < selectedItems.length; i++){
	    		dataItem = {};
	    		dataItem['recruitmentCriteriaId'] = selectedItems[i].value;
	    		selCriteriaItems[i] = dataItem;
	    	}
	    	var selJsonCriteriaItems = JSON.stringify(selCriteriaItems);
	    	var row;
	        row = {
	        		partyId: $('#partyIdAdd').val(),
	        		workLocation: $('#workLocation').val(),
	        		emplPositionTypeId:$('#emplPositionTypeId').val(),
	        		fromDate:$("#fromDate").jqxDateTimeInput('getDate').getTime(),
	        		thruDate:$("#thruDate").jqxDateTimeInput('getDate').getTime(),
	        		resourceNumber:$('#resourceNumber').val(),
	        		recruitmentTypeId:$('#recruitmentTypeId').val(),
	        		recruitmentFormId:$('#recruitmentFormId').val(),
	        		listCriteria:selJsonCriteriaItems,
	        		jobDescription:$("#jobDescription").val()
			  };
		   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	        // select the first row and clear the selection.
	        $("#jqxgrid").jqxGrid('clearSelection');
	        $("#jqxgrid").jqxGrid('selectRow', 0);
	        $("#alterpopupNewJobRequest").jqxWindow('close');
	    });
	    
	    // initialize validator.
        $('#createNewJobRequest').jqxValidator({
            rules: [{ input: '#resourceNumber', message: '${uiLabelMap.NumberFieldRequired}', action: 'blur',
            			rule: function (input, commit) {
                            if (isFinite(input.val())) {
                                return true;
                            }
                            return false;
                        }
           			},
           			{ input: '#resourceNumber', message: '${uiLabelMap.FieldRequired}', action: 'blur', rule: 'required'}
                   ]
        });
	});
	
	var initrowdetails = function (index, parentElement, gridElement, datarecord) {
        var tabsdiv = $($(parentElement).children()[0]);
        var jqxgridCriteriaId = "jqxgridCriteria_" + datarecord.uid;
        var jobRequestId = datarecord.jobRequestId;
        var jobDescription = datarecord.jobDescription;
        if(tabsdiv.length){
        	 var criteriaContainer = $('<div style="margin: 5px;" id="' + jqxgridCriteriaId + '"></div>');
        	 var descriptionContainer = $('<div style="margin: 15px;" ></div>');
        	 var criteria = tabsdiv.find('.criteria');
        	 var description = tabsdiv.find('.description');
        	 descriptionContainer.append(jobDescription);
        	 description.append(descriptionContainer);
        	 criteria.append(criteriaContainer);
        	 var dataSource = {
        				datafields: [
        								{name: 'recruitmentCriteriaId', type: 'string'},
        						        {name: 'description', type: 'number'},
        							],
        					cache: false,
        					datatype: 'json',
        					type: 'POST',
        					data: {jobRequestId: jobRequestId},
        					url: "getRecruitmentCriteria"
        				};
        	 
        	 criteriaContainer.jqxGrid({
	                width: 850,
	                source: dataSource,                
	                pageable: true,
	                autoheight: true,
	                editable: false,
	                columns: [
	                  { text: '${uiLabelMap.CommonId}', datafield: 'recruitmentCriteriaId', width: 250 },
	                  { text: '${uiLabelMap.CommonDescription}', datafield: 'description'}
	                ]
	            });
        	 tabsdiv.jqxTabs({ width: '90%', height: 200, position: 'top'});
        }
    }
	
</script>