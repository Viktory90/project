<script>
	<#assign agreementItemTypeList = delegator.findList("AgreementItemType", null, null, null, null, false)/>
	var aITData = new Array();
	<#list agreementItemTypeList as item>
		<#assign description = StringUtil.wrapString(item.description)/>
		var row = {};
		row['agreementItemTypeId'] = '${item.agreementItemTypeId}';
		row['description'] = '${description}';
		aITData[${item_index}] = row;
	</#list>
	<#assign uomList = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "CURRENCY_MEASURE"), null, null, null, false)/>
	var uomData = new Array();
	<#list uomList as item>
		<#assign description = StringUtil.wrapString(item.description) + "-" + StringUtil.wrapString(item.abbreviation)/>
		var row = {};
		row['uomId'] = '${item.uomId}';
		row['description'] = "${description}";
		uomData[${item_index}] = row;
	</#list>
</script>


<#assign dataField="[{ name: 'agreementId', type: 'string' },
					 { name: 'agreementItemSeqId', type: 'string'},
					 { name: 'agreementItemTypeId', type: 'string'},
					 { name: 'currencyUomId', type: 'string'},
					 { name: 'agreementText', type: 'string'},
					 { name: 'agreementImage', type: 'string'},
					 ]"/>
<#assign columnlist="{ text: '${uiLabelMap.SequenceId}', datafield: 'agreementItemSeqId', editable: false, width: '10%',
					 	cellsrenderer: function(row, colum, value){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
        					return '<a style = \"margin-left: 10px\" href=' + 'accArEditAgreementItem?agreementId=' + data.agreementId + '&agreementItemSeqId=' + data.agreementItemSeqId +  '>' +  data.agreementItemSeqId + '</a>'
					 	}
					 },
					 { text: '${uiLabelMap.FormFieldTitle_agreementItemType}',  width: '20%', datafield: 'agreementItemTypeId', columntype: 'dropdownlist',
					   cellsrenderer: function(row, colum, value){
					 		for(i = 0; i < aITData.length; i++){
					 			if(value == aITData[i].agreementItemTypeId){
					 				return \"<span>\" + aITData[i].description + \"</span>\";
					 			}
					 		}
					 		return \"<span>\" + value + \"</span>\";
					 	},
					 	
					 	createeditor: function (row, column, editor) {
                            editor.jqxDropDownList({source: aITData, displayMember:\"description\", valueMember: \"agreementItemTypeId\",
                            renderer: function (index, label, value) {
			                    var datarecord = aITData[index];
			                    return datarecord.description;
			                  }
                        });
                        }
					 },
					 { text: '${uiLabelMap.currencyUomId}',  width: '20%', datafield: 'currencyUomId', columntype: 'dropdownlist',
					   cellsrenderer: function(row, colum, value){
					 		for(i = 0; i < uomData.length; i++){
					 			if(value == uomData[i].uomId){
					 				return \"<span>\" + uomData[i].description + \"</span>\";
					 			}
					 		}
					 		return \"<span>\" + value + \"</span>\";
					 	},
					 	
					 	createeditor: function (row, column, editor) {
                            editor.jqxDropDownList({source: uomData, displayMember:\"description\", valueMember: \"uomId\",
                            renderer: function (index, label, value) {
			                    var datarecord = uomData[index];
			                    return datarecord.description;
			                  }
                        });
                        }
					 },
					 { text: '${uiLabelMap.FormFieldTitle_agreementText}', width: '30%', datafield: 'agreementText'},
					 { text: '${uiLabelMap.FormFieldTitle_agreementImage}', width: '20%',datafield: 'agreementImage'},
					 "/>
<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow" editable="true"
		 url="jqxGeneralServicer?sname=JQListAgreementItems&agreementId=${parameters.agreementId}"
		 createUrl="jqxGeneralServicer?sname=createAgreementItem&jqaction=C&agreementId=${parameters.agreementId}"
		 removeUrl="jqxGeneralServicer?sname=removeAgreementItem&jqaction=D&agreementId=${parameters.agreementId}"
		 updateUrl="jqxGeneralServicer?sname=updateAgreementItem&jqaction=U&agreementId=${parameters.agreementId}"
		 deleteColumn="agreementId[${parameters.agreementId}];agreementItemSeqId"
		 addColumns="agreementId[${parameters.agreementId}];agreementItemTypeId;currencyUomId;agreementText;agreementImage(java.nio.ByteBuffer)"
		 editColumns="agreementId[${parameters.agreementId}];agreementItemSeqId;agreementItemTypeId;currencyUomId;agreementText;agreementImage(java.nio.ByteBuffer)"
		 />
		 
<div id="alterpopupWindow" style="display:none;">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.FormFieldTitle_agreementItemType}:</td>
	 			<td align="left">
	 				<div id="agreementItemTypeIdAdd">
	 				</div>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.currencyUomId}:</td>
	 			<td align="left">
	 				<div id="currencyUomIdAdd">
	 				</div>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.FormFieldTitle_agreementText}:</td>
	 			<td align="left">
	 				<input id="agreementTextAdd">
	 				</input>
	 			</td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.FormFieldTitle_agreementImage}:</td>
	 			<td align="left">
	 				<input id="agreementImageAdd">
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
	
	$('#agreementItemTypeIdAdd').jqxDropDownList({ selectedIndex: 0, width:215,  source: aITData, displayMember: "description", valueMember: "agreementItemTypeId"});
	$('#currencyUomIdAdd').jqxDropDownList({ selectedIndex: 0, width:215,  source: uomData, displayMember: "description", valueMember: "uomId"});
	$('#agreementTextAdd').jqxInput({width:210});
	$('#agreementImageAdd').jqxInput({width:210});
    
    $('#alterpopupWindow').on('open', function (event) {
		$("#agreementTextAdd").jqxInput('val', null);	
		$("#agreementImageAdd").jqxInput('val', null);		  	
	});
		
	//Create Popup Add
	$("#alterpopupWindow").jqxWindow({
        width: 600, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7          
    });
    $("#alterCancel").jqxButton();
    $("#alterSave").jqxButton();

    // update the edited row when the user clicks the 'Save' button.
    $("#alterSave").click(function () {
    	var row;
        row = { 
        		agreementItemTypeId:$('#agreementItemTypeIdAdd').val(), 
        		currencyUomId:$('#currencyUomIdAdd').val(),
        		agreementText:$('#agreementTextAdd').val(),
        		agreementImage:$('#agreementImageAdd').val(),
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
        // select the first row and clear the selection.
        $("#jqxgrid").jqxGrid('clearSelection');                        
        $("#jqxgrid").jqxGrid('selectRow', 0);  
        $("#alterpopupWindow").jqxWindow('close');
    });
</script>