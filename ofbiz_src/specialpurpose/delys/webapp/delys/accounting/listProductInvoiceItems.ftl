<script>
	//item type
	<#assign litt="var litt = ['" + StringUtil.wrapString(invoiceItemTypes.get(0).description) + "'"/>
	<#assign littValue="var littValue = ['" + StringUtil.wrapString(invoiceItemTypes.get(0).invoiceItemTypeId) + "'"/>
	<#assign itlength = invoiceItemTypes.size()/>
	<#if invoiceItemTypes?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign litt=litt + ",'" +StringUtil.wrapString(invoiceItemTypes.get(i).description) + "'"/>
			<#assign littValue=littValue + ",'" +StringUtil.wrapString(invoiceItemTypes.get(i).invoiceItemTypeId) + "'"/>
		</#list>
	</#if>
	<#assign litt=litt + "];"/>
	<#assign littValue=littValue +"];"/>
	${litt}
	${littValue}
	var dataItt = new Array();	
	for (var i = 0; i < ${itlength}; i++) {
	    var row = {};
	    row["invoiceItemTypeId"] = littValue[i];
	    row["description"] = litt[i];
	    dataItt[i] = row;
	}
	// override gl account
	<#if glAccountOrganizationAndClassList?size gt 0>
	<#assign lgla="var lgla = [\"" + StringUtil.wrapString(glAccountOrganizationAndClassList.get(0).accountName?if_exists) + "\""/>
	<#assign lglaValue="var lglaValue = [\"" + StringUtil.wrapString(glAccountOrganizationAndClassList.get(0).glAccountId?if_exists) + "\""/>
	<#assign itlength = glAccountOrganizationAndClassList.size()/>
	<#if glAccountOrganizationAndClassList?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lgla=lgla + ",\"" +StringUtil.wrapString(glAccountOrganizationAndClassList.get(i).accountName?if_exists) + "\""/>
			<#assign lglaValue=lglaValue + ",\"" +StringUtil.wrapString(glAccountOrganizationAndClassList.get(i).glAccountId?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lgla=lgla + "];"/>
	<#assign lglaValue=lglaValue +"];"/>
	${lgla}
	${lglaValue}
	var dataGla = new Array();
	var row = {};
	row["overrideGlAccountId"] = "";
    row["accountName"] = "";
    dataGla[0] = row;
	for (var i = 0; i < ${itlength}; i++) {
	    var row = {};
	    row["overrideGlAccountId"] = lglaValue[i];
	    row["accountName"] = lgla[i];
	    dataGla[i+1] = row;
	}
	</#if>
	
</script>
<#assign dataField="[{ name: 'invoiceId', type: 'string' },
					{ name: 'quantity', type: 'number' },
					{ name: 'invoiceItemSeqId', type: 'string' },
					{ name: 'invoiceItemTypeId', type: 'string' },
					{ name: 'productId', type: 'string' },
					{ name: 'description', type: 'string' },
					{ name: 'overrideGlAccountId', type: 'string' },
					{ name: 'amount', type: 'number' },
					{ name: 'total', type: 'number' }]
					"/>
<#assign columnlist="
					 { text: '${uiLabelMap.invoiceItemSeqId}', datafield: 'invoiceItemSeqId', width: 150,editable:false },
					 { text: '${uiLabelMap.quantity}', datafield: 'quantity', width: 150 },
					 { text: '${uiLabelMap.invoiceItemTypeId}', datafield: 'invoiceItemTypeId', columntype: 'template', width: 180,
	                      cellsrenderer: function(row, colum, value){
						 		for(i = 0; i < dataItt.length; i++){
						 			if(value == dataItt[i].invoiceItemTypeId){
						 				return \"<span>\" + dataItt[i].description + \"</span>\";
						 			}
						 		}
						 		return \"<span>\" + value + \"</span>\";
						 	},
						 	createeditor: function (row, column, editor) {
					            editor.jqxDropDownList({width: 150, source: iitData, displayMember:\"description\", valueMember: \"invoiceItemTypeId\",
					            renderer: function (index, label, value) {
					                var datarecord = iitData[index];
					                return datarecord.description;
					              }
					        });
					        }},
					    { text: '${uiLabelMap.accProductName}', datafield: 'productId', width: '30%', editable: false, 
							cellsrenderer: function (row, column, value) {
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								return \"<span>\" + data.productId + \"</span>\";
							}										 		
						 },
					 { text: '${uiLabelMap.description}', datafield: 'description', width: 250 },
					 { text: '${uiLabelMap.accOverrideGlAccountId}', columntype: 'dropdownlist', datafield: 'overrideGlAccountId', width: 250,
					 	createeditor: function (row, column, editor) {
					        var sourceGla =
					        {
					            localdata: dataGla,
					            datatype: \"array\"
					        };
					        var dataAdapterGla = new $.jqx.dataAdapter(sourceGla);
					        editor.jqxDropDownList({source: dataAdapterGla, valueMember: \"overrideGlAccountId\",
					        renderer: function (index, label, value) {
					            var datarecord = dataGla[index];
					            return datarecord.accountName + \"-\" + datarecord.overrideGlAccountId;
					        } 
					        });
					    }},
					 { text: '${uiLabelMap.unitPrice}', datafield: 'amount', width: 250, cellsformat: 'c2'  },
					 { text: '${uiLabelMap.ApTotal}', dataField: 'total', width: 200, cellsformat: 'c2'  ,cellsrenderer:
					     	function(row, colum, value)
					        {
					        	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
					        	if(data.quantity != null && data.amount!=null){
					        		var total = parseFloat(data.quantity) * parseFloat(data.amount);
					        		return \"<span>\" + formatcurrency(total, 'đ') + \"</span>\";	
					        		
					    		}else{
					    			return null;
					    		}
					        }} 
					 "/>   
<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow" editable="true"
		url="jqxGeneralServicer?invoiceId=${parameters.invoiceId}&sname=JQGetListInvoiceItemsInPayment"
		updateUrl="jqxGeneralServicer?invoiceId=${parameters.invoiceId}&jqaction=U&sname=updateInvoiceItemJQ"
		createUrl="jqxGeneralServicer?invoiceId=${parameters.invoiceId}&jqaction=C&sname=createInvoiceItem"
		removeUrl="jqxGeneralServicer?invoiceId=${parameters.invoiceId}&jqaction=D&sname=removeInvoiceItem"
		editColumns="invoiceId${parameters.invoiceId};invoiceItemSeqId;invoiceItemTypeId;productId;description;overrideGlAccountId;quantity(java.math.BigDecimal);amount(java.math.BigDecimal)"	 
		addColumns="invoiceId[${parameters.invoiceId}];invoiceItemTypeId;productId;description;overrideGlAccountId;quantity(java.math.BigDecimal);amount(java.math.BigDecimal)"
		deleteColumn="invoiceId[${parameters.invoiceId}];invoiceItemSeqId" addrefresh="true"
 />

<div id="alterpopupWindow" style="display:none;">
	<div>${uiLabelMap.accCreateNew}</div>
	<div style="overflow: hidden;">
	    <table>
		 	<tr>
		 		<td align="right">${uiLabelMap.quantity}:</td>
	 			<td align="left">
					<input id="quantityAdd">
	 				</input>
	 			</td>
		 	</tr>
		 	<tr>
		 		<td align="right">${uiLabelMap.invoiceItemTypeId}:</td>
	 			<td align="left">
	 				<div id="invoiceItemTypeIdAdd">
	 				</div>
	 			</td>
		 	</tr>
		 	<tr>
	 		<td align="right">${uiLabelMap.accProductName}:</td>
				<td align="left">
					<div id="productIdAdd">
						<div id="jqxProductGrid" />
					</div>
				</td>
			</tr>	 		 
		 	<tr>
	 		<td align="right">${uiLabelMap.description}:</td>
				<td align="left">
					<input id="descriptionAdd">
	 				</input>
				</td>
			</tr>	 	
		 	<tr>
	 			<td align="right">${uiLabelMap.accOverrideGlAccountId}:</td>
	 			<td align="left">
						<div id="overrideGlAccountIdAdd">
						</div>
					</td>
				</tr>
		 	<tr>
		 		<td align="right">${uiLabelMap.unitPrice}:</td>
	 			<td align="left">
	 				<input id="amountAdd">
	 				</input>
	 			</td>
		 	</tr>
	        <tr>
	            <td align="right"></td>
	            <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
	        </tr>
	    </table>
	</div>
</div>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script>
//Create theme
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	var sourceP = { datafields: [
						      { name: 'productId', type: 'string' },
						      { name: 'productName', type: 'string' }
						    ],
				cache: false,
				root: 'results',
				datatype: "json",
				updaterow: function (rowid, rowdata) {
					// synchronize with the server - send update command   
				},
				beforeprocessing: function (data) {
				    sourceP.totalrecords = data.TotalRows;
				},
				filter: function () {
				   // update the grid and send a request to the server.
				   $("#jqxProductGrid").jqxGrid('updatebounddata');
				},
				pager: function (pagenum, pagesize, oldpagenum) {
				  // callback called when a page or page size is changed.
				},
				sort: function () {
				  $("#jqxProductGrid").jqxGrid('updatebounddata');
				},
				sortcolumn: 'productId',
	           	sortdirection: 'asc',
				type: 'POST',
				data: {
					noConditionFind: 'Y',
					conditionsFind: 'N',
				},
				pagesize:5,
				contentType: 'application/x-www-form-urlencoded',
				url: 'jqxGeneralServicer?sname=JQGetListProducts',
			};
		    var dataAdapterP = new $.jqx.dataAdapter(sourceP,
		    {
		    	autoBind: true,
		    	formatData: function (data) {		    		
		    		if (data.filterscount) {
		                var filterListFields = "";
		                for (var i = 0; i < data.filterscount; i++) {
		                    var filterValue = data["filtervalue" + i];
		                    var filterCondition = data["filtercondition" + i];
		                    var filterDataField = data["filterdatafield" + i];
		                    console.log(filterValue);
		                    var filterOperator = data["filteroperator" + i];
		                    filterListFields += "|OLBIUS|" + filterDataField;
		                    filterListFields += "|SUIBLO|" + filterValue;
		                    filterListFields += "|SUIBLO|" + filterCondition;
		                    filterListFields += "|SUIBLO|" + filterOperator;
		                }
		                data.filterListFields = filterListFields;
		            }
		            return data;
		        },
		        loadError: function (xhr, status, error) {
		            alert(error);
		        },
		        downloadComplete: function (data, status, xhr) {
		                if (!sourceP.totalRecords) {
		                    sourceP.totalRecords = parseInt(data['odata.count']);
		                }
		        }
		    });	
	
	// Create productId
	$('#productIdAdd').jqxDropDownButton({ width: 230 });
	$("#jqxProductGrid").jqxGrid({
		width:400,
		source: dataAdapterP,
		filterable: true,
		showfilterrow : true,
		virtualmode: true, 
		sortable:true,
		editable: false,
		autoheight:true,
		pageable: true,
		ready:function(){
	    },
		rendergridrows: function(obj)
		{	
			return obj.data;
		},
		columns: 
			[
				{ text: '${uiLabelMap.accProductId}', datafield: 'productId', width: '50%'},
				{ text: '${uiLabelMap.accProductName}', datafield: 'productName'},
			]
		});
	
	$("#jqxProductGrid").on('rowselect', function (event) {
	            var args = event.args;
	            var row = $("#jqxProductGrid").jqxGrid('getrowdata', args.rowindex);
	            var dropDownContent = '<div style="position: relative; margin-left: 3px; margin-top: 5px;">' + row['productId'] + '</div>';
	            $("#productIdAdd").jqxDropDownButton('setContent', dropDownContent);
	        });
	$("#quantityAdd").jqxInput({width: 225});
	$("#amountAdd").jqxInput({width: 225});
	$("#invoiceItemTypeIdAdd").jqxDropDownList({ selectedIndex: 0,  source: dataItt, displayMember: "description", valueMember: "invoiceItemTypeId", width: 230 });

  var sourceGla2 =
  {
      localdata: dataGla,
      datatype: "array"
  };
  
  var dataAdapterGla2 = new $.jqx.dataAdapter(sourceGla2);
     
  $('#overrideGlAccountIdAdd').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGla2, displayMember: "description", valueMember: "overrideGlAccountId", width: 230});
	//Create description
	$("#descriptionAdd").jqxInput({width: 225});
	
	$("#alterpopupWindow").jqxWindow({
	    width: 550, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7          
	});
	$("#alterCancel").jqxButton();
	$("#alterSave").jqxButton();
	
	$('#alterpopupWindow').on('open', function (event) {
		$("#descriptionAdd").jqxInput('val', null);  
		$("#amountAdd").jqxInput('val', null); 
	});
	
	// update the edited row when the user clicks the 'Save' button.
	$("#alterSave").click(function () {
		var row;
		var checkNull = $('#amountAdd').val();
		if (checkNull != '')
    	{
    		checkNull = $('#amountAdd').val();
    	}
		else checkNull = null;
		console.log($('#quantityAdd').val());
		var checkQuanNull = $('#quantityAdd').val();
		if (checkQuanNull != '')
    	{
			checkQuanNull = $('#quantityAdd').val();
			
    	}
		else checkQuanNull = null;
	    row = { 
	    		description:$('#descriptionAdd').val(),         		  	
	    		invoiceItemTypeId:$('#invoiceItemTypeIdAdd').val(),
	    		overrideGlAccountId:$('#overrideGlAccountIdAdd').val(),
	    		quantity:checkQuanNull,
	    		amount:checkNull,
	    		productId:$('#productIdAdd').val(),
	    	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	    // select the first row and clear the selection.
	    $("#jqxgrid").jqxGrid('clearSelection');                        
	    $("#jqxgrid").jqxGrid('selectRow', 0);  
	    $("#alterpopupWindow").jqxWindow('close');
	});
</script>