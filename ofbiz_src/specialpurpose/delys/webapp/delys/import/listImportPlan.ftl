<script type="text/javascript" src="/delys/images/js/import/miscUtil.js"></script>
<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>

<#assign dataField="[{ name: 'productPlanId', type: 'string'},
					{ name: 'createByUserLoginId', type: 'string'},
					{ name: 'productPlanName', type: 'string'},
					{ name: 'organizationPartyId', type: 'string'},
					{ name: 'internalPartyId', type: 'string'},
					{ name: 'statusId', type: 'string'},
					]"/>
<#assign columnlist="
					{ text: '${uiLabelMap.PlanId}' , datafield: 'productPlanId', width: 150, cellsrenderer:
					       function(row, colum, value){
				        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
				        var productPlanId = data.productPlanId;
				        return '<span><a href=\"javascript:productPlanIdClick(&#39;' + productPlanId + '&#39;)\">' + productPlanId + '</a></span>';
					}},
					{ text: '${uiLabelMap.accGeoName}' , datafield: 'internalPartyId', width: 200},
					{ text: '${uiLabelMap.PlanName}' , datafield: 'productPlanName', width: 200},
					{ text: '${uiLabelMap.organizationPartyId}' , datafield: 'organizationPartyId', width: 200},
					{ text: '${uiLabelMap.createByUserLoginId}' , datafield: 'createByUserLoginId', width: 200},
					{ text: '${uiLabelMap.Status}' , datafield: 'statusId', minwidth: 150, columntype: 'dropdownlist', filtertype: 'checkedlist', cellsrenderer:
						function(row, colum, value){
						var data = $('#jqxgrid').jqxGrid('getrowdata', row);
						var statusId = data.statusId;
						var status = getStatus(statusId);
						return '<span>' + status + '</span>';
					}, createfilterwidget: 
					function(row, column, editor){
					editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(statusList), displayMember: 'statusId', valueMember: 'statusId' ,
					    renderer: function (index, label, value) {
					    	if (index == 0) {
                        		return value;
							}
						    return getStatus(value);
					    } });
					editor.jqxDropDownList('checkAll');
					}},
					"/>

<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
					showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false"
					customcontrol1="icon-plus-sign open-sans@${uiLabelMap.createImportPlan}@createImportPlanNewDat"
					url="jqxGeneralServicer?sname=JQGetListImportPlan"
					/>
					<div id="myForm"></div>
	<#assign status = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "PLAN_STATUS"), null, null, null, false) />
	<script>
			function productPlanIdClick(productPlanId) {
				var form = document.createElement("form");
				form.setAttribute('method', "post");
				form.setAttribute('action', "resultPlanOfYear");
				var input = document.createElement("input");
				input.setAttribute('name', "productPlanHeaderId");
				input.setAttribute('value', productPlanId);
				input.setAttribute('type', "hidden");
				form.appendChild(input);
				document.getElementsByTagName('body')[0].appendChild(form);
				form.submit();
			}
			var statusList = new Array();
			<#if status?exists>
				<#list status as item>
					var row = {};
					row['description'] = '${item.get("description", locale)?if_exists}';
					row['statusId'] = '${item.statusId?if_exists}';
					statusList[${item_index}] = row;
				</#list>
			</#if>
			function getStatus(statusId) {
				if (statusId != null) {
					for ( var x in statusList) {
						if (statusId == statusList[x].statusId) {
							return statusList[x].description;
						}
					}
				} else {
					return "";
				}
			}
			function fixSelectAll(dataList) {
		    	var sourceST = {
				        localdata: dataList,
				        datatype: "array"
				    };
				var filterBoxAdapter2 = new $.jqx.dataAdapter(sourceST, {autoBind: true});
				var uniqueRecords2 = filterBoxAdapter2.records;
				uniqueRecords2.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
				return uniqueRecords2;
			}
	</script>