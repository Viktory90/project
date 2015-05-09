<#assign id1="personContacts"/>
<#assign id2="groupContacts"/>
<script>
	var uiLabelMap = {
		sender : '${uiLabelMap.sender}',
		receiver: '${uiLabelMap.receiver}',
		InTime : '${uiLabelMap.InTime}',
		communicationType : '${uiLabelMap.communicationType}'
	};
	var locale = "${locale}";
</script>
<div id="listContact" class="cooler-tabs">
	<!-- <div id="loading-mk" style="display: block"><div class="loading-img">&nbsp;</div></div> -->
	<ul>
		<li><a href="#group">${uiLabelMap.delysStore}</a></li>
		<li><a href="#person">${uiLabelMap.listContact}</a></li>
	</ul>
	<div id="person">
		<#assign dataField="[{ name: 'partyId', type: 'string' },
					 { name: 'firstName', type: 'string'},
					 { name: 'middleName', type: 'string'},
					 { name: 'lastName', type: 'string'},
					 { name: 'birthDate', type: 'string'},
					 { name: 'infoString', type: 'string'},
					 { name: 'contactNumber', type: 'string'},
					 { name: 'address1', type: 'string'},
					 { name: 'city', type: 'string'},
					 { name: 'assign', type: 'string'},
					 ]"/>

		<#assign columnlist="{ text: '${uiLabelMap.partyID}', filtertype: 'input', datafield: 'partyId', editable: false },
						   	 { text: '${uiLabelMap.firstName}', filtertype: 'input', datafield: 'firstName',editable: false},
		                     { text: '${uiLabelMap.middleName}', filtertype: 'input', datafield: 'middleName',editable: false, hidden: true },
		                     { text: '${uiLabelMap.lastName}', filtertype: 'input', datafield: 'lastName',editable: false, hidden: true },
		                     { text: '${uiLabelMap.birthday}', filtertype: 'input', datafield: 'birthDate',editable: false, hidden: true },
							 { text: '${uiLabelMap.emailAddr}', filtertype: 'input', datafield: 'infoString', columntype:'custom', editable: false, width: '250',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                      }},
		                      { text: '${uiLabelMap.phoneNumber}', filtertype: 'input', datafield: 'contactNumber', columntype:'custom', editable: false, width: '150',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                     }},
		                     { text: '${uiLabelMap.address}', filtertype: 'input', datafield: 'address1', columntype:'custom', editable: false, width: '200',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                     }},
		                     { text: '${uiLabelMap.city}', filtertype: 'input', datafield: 'city', columntype:'custom', editable: false, width: '100',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                     }},
		                     { text: '', datafield: 'assign', width: '60',  columntype: 'custom', filterable: false, 
		                       cellsrenderer: function (row, column, value) {
		                        var id = \"${id1}\";
		                      	return '<a href=\"javascript:void(0)\" onclick=\"editPopup('+id+','+row+')\"><span class=\"icon-edit\"></span></a>'
										+'<a href=\"javascript:void(0)\" onclick=\"moreDetail('+id+','+row+')\"><span class=\"icon-eye-open\"></span></a>'
										+'<a href=\"javascript:void(0)\" onclick=\"raiseIssue('+id+','+row+')\"><span class=\"icon-comment\"></span></a>'; 
		                      }}"/>
		                      
		<@jqGrid id="${id1}" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" 
				showtoolbar="true" addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow" editable="true"
				selectionmode="checkbox"  altrows='true' rowselectfunction="rowselectfunction(event);" rowunselectfunction="rowunselectfunction(event);" 
				addrow="true" deleterow="true"	url="jqxGeneralServicer?sname=getListContacts" sendEmail="true"/>

	</div>
	<div id="group">
		<#assign dataField="[{ name: 'firstName', type: 'string' },
					 { name: 'groupName', type: 'string' },
					 { name: 'partyIdFrom', type: 'string' },
					 { name: 'partyIdTo', type: 'string' },
					 { name: 'infoString', type: 'string'},
					 { name: 'contactNumber', type: 'string'},
					 { name: 'address1', type: 'string'},
					 { name: 'city', type: 'string'},
					 { name: 'assign', type: 'string'}]"/>
		<#assign columnlist="{ text: '${uiLabelMap.customerName}', filtertype: 'input', datafield: 'firstName', editable: false},
							 { text: '${uiLabelMap.storeName}', filtertype: 'input', datafield: 'groupName', editable: false},
							 { text: '${uiLabelMap.partyIdFrom}', filtertype: 'input', datafield: 'partyIdFrom', editable: false, hidden: true},
							 { text: '${uiLabelMap.partyIdTo}', filtertype: 'input', datafield: 'partyIdTo', editable: false, hidden: true},
							 { text: '${uiLabelMap.emailAddr}', filtertype: 'input', datafield: 'infoString', columntype:'custom', editable: false, width: '250',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                      }},
		                      { text: '${uiLabelMap.phoneNumber}', filtertype: 'input', datafield: 'contactNumber', columntype:'custom', editable: false, width: '150',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                     }},
		                     { text: '${uiLabelMap.address}', filtertype: 'input', datafield: 'address1', columntype:'custom', editable: false, width: '200',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                     }},
		                     { text: '${uiLabelMap.city}', filtertype: 'input', datafield: 'city', columntype:'custom', editable: false, width: '100',  
							    cellsrenderer: function (row, column, value) {
							    	var select = \"<select style='width: 100%'>\";
							    	if(value.length > 1){
							    		for(var x in value){
							    			var option = \"\";	
							    			option = \"<option>\";
							    			option += value[x];
							    			option += \"</option>\";
							    			select += option;
							    		}
										select += \"</select>\";
							    		return select;
							    	}else if(value.length){
							    		return \"<div style='overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;'>\"+value[0]+\"</div>\";
							    	}
		                      		 
		                     }},
		                     { text: '', datafield: 'assign', width: '60',  columntype: 'custom', filterable: false, 
		                       cellsrenderer: function (row, column, value) {
		                        var id = \"${id1}\";
		                      	return '<a href=\"javascript:void(0)\" onclick=\"moreDetail('+id+','+row+')\"><span class=\"icon-eye-open\"></span></a>'
										+'<a href=\"javascript:void(0)\" onclick=\"raiseIssue('+id+','+row+')\"><span class=\"icon-comment\"></span></a>'; 
		                      }}"/>
		<@jqGrid id="${id2}" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" 
				showtoolbar="true" addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow" editable="true"
				selectionmode="checkbox"  altrows='true' rowselectfunction="rowselectfunction(event);" rowunselectfunction="rowunselectfunction(event);" 
				addrow="true" deleterow="true"	url="jqxGeneralServicer?sname=getListGroupContacts" sendEmail="true"/>
						
	</div>
</div>
<div class="modal fade modal-email" id="emailForm" tabindex="-1" role="dialog" aria-hidden="true" style="display: none">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">${uiLabelMap.composeEmail}</h4>
      </div>
      <div class="modal-body modal-email-body">
		<div class="row-fluid">
			<select class="span12" id="currentEmail">
				<option>cuongbt91@gmail.com</option>
				<option>cuongbt91@gmail.com</option>
			</select>
		</div>
		<div class="row-fluid">
			<select multiple="" class="chzn-select email-op-select" id="outputEmails" data-placeholder="${uiLabelMap.receiver}" >
				
			</select>
		</div>
		<div class="row-fluid margin-top">
			<input id="emailSubject" placeholder="${uiLabelMap.subject}" class="span12" style="padding-left: 5px; padding-right: 5px;"/>
		</div>
		<div class="row-fluid margin-top">
			<textarea id="mailContent" class="span12 resize-none"></textarea>
		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">${uiLabelMap.close}</button>
        <button type="button" class="btn btn-primary" id="sendEmailBt">${uiLabelMap.send}</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="editContactForm" tabindex="-1" role="dialog" aria-hidden="true" style="display: none">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">
        	<span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">${uiLabelMap.editContactForm}</h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">${uiLabelMap.close}</button>
        <button type="button" class="btn btn-primary">${uiLabelMap.save}</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade detail-modal" id="detail" tabindex="-1" role="dialog" aria-hidden="true"  style="display: none">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">${uiLabelMap.contactDetail}</h4>
      </div>
      <div class="modal-body" id="detail-activity">
      	  	
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">${uiLabelMap.close}</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade modal-email" id="issueForm" tabindex="-1" role="dialog" aria-hidden="true"  style="display: none">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
      	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">${uiLabelMap.createIssue}</h4>
      </div>
      <div class="modal-body modal-email-body">
      	<form class="form-horizontal">
      		<div class="control-group">
      			<label class="control-label">
					Tên khách hàng
				</label>
				<div class="controls">
					<span id="customer"></span>
				</div>
      		</div>
      		<div class="control-group">
				<label class="control-label">Chọn loại:</label>
				<div class="controls">
					<select id="support">
						<#if communicationEventTypes?exists>
							<#list communicationEventTypes as type>
	
								<option value="${type.communicationEventTypeId}">${type.description}</option>
							</#list>
						</#if>
					</select>
				</div>
			</div>
			<div class="control-group margin-top">
				<textarea id="issueContent" class="span12 resize-none"></textarea>
			</div>
      	</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="clearIssueForm()">${uiLabelMap.close}</button>
        <button type="button" class="btn btn-primary" id="createIssue">${uiLabelMap.save}</button>
      </div>
    </div>
  </div>
</div>
<div class="modal fade modal-email" id="changeStateForm" tabindex="-1" role="dialog" aria-hidden="true"  style="display: none">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
      	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">${uiLabelMap.changeState}</h4>
      </div>
      <div class="modal-body modal-email-body">
      	<form class="form-horizontal">
      		<div class="control-group">
				<label class="control-label">Chọn trạng thái</label>
				<div class="controls">
					<select id="states">
						<option value="CONTACT">${uiLabelMap.contactOption}</option>
						<option value="ACCOUNT">${uiLabelMap.accountOption}</option>
						<option value="LEAD">${uiLabelMap.leadOption}</option>
					</select>
				</div>
			</div>
      	</form>
      	<div class="row-fluid">
				<select multiple="" class="chzn-select email-op-select" id="stateCustomerId" data-placeholder="${uiLabelMap.customer}" >
					
				</select>
			</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="clearState()">${uiLabelMap.close}</button>
        <button type="button" class="btn btn-primary" id="changeStateBt">${uiLabelMap.save}</button>
      </div>
    </div>
  </div>
</div>
<script>
	$(document).ready(function(){
		issueForm = $("#issueForm");
		changeStateForm = $("#changeStateForm");
		emailForm = $("#emailForm");
	    emailForm.on('shown.bs.modal', function () {
	        $('.chzn-select', this).chosen();
	    });
	    changeStateForm.on('shown.bs.modal', function () {
	        $('.chzn-select', this).chosen();
	    });
	    CKEDITOR.replace( 'mailContent', {enableTabKeyToolsv: true, skin: 'office2013'});
		CKEDITOR.replace( 'issueContent', {enableTabKeyToolsv: true, skin: 'office2013'});
		ck = CKEDITOR.instances;
		
		$("#createIssue").click(function(){
			var partyId = $("#createIssue").attr("data-id");
			var content = getDataEditor("issueContent");
			var support = $("#support").val();
			$.ajax({
				url: "raiseCustomerIssue",
				type: "POST",
				data: {
					partyId : partyId,
					content: content,
					support: support
				},
				success: function(res){
					issueForm.modal("hide");
					setDataEditor("issueContent", " ");
				}
			});
		});
		$("#sendEmailBt").click(function(){
			//var from = $("#currentEmail").val();
			var to = $("#outputEmails").val();
			var subject = $("#emailSubject").val();
			var content = getDataEditor("mailContent");
			$.ajax({
				url: "sendEmailSupport",
				type: "POST",
				data: {
					listEmail : JSON.stringify(to),
					subject: subject,
					content: content
				},
				success: function(res){
					emailForm.modal("hide");
					setDataEditor("mailContent", " ");
				}
			});
		});
		$("#changeStateBt").click(function(){	
			var ids = $("#stateCustomerId").val();
			var data = [];
			for(var x in ids){
				var id = ids[x].match(/\(([^)]+)\)/)[1];
				data.push(id);
			}
			var state = $("#states").val();
			if(data){
				$.ajax({
					url: "changeCustomerState",
					type: "POST",
					data: {
						listParty : JSON.stringify(data),
						state: state,
						previous: previous
					},
					success: function(res){
						reloadGrid();
						changeStateForm.modal("hide");
					}
				});
			}
		});
	});
</script>