
<#assign dataField="[{ name: 'requirementId', type: 'string'},
					   { name: 'agreementId', type: 'string'},
					   { name: 'orderId', type: 'string'},
					   { name: 'agreementDate', type: 'date', other: 'Timestamp'},
					   { name: 'partyIdFrom', type: 'string'},
					   { name: 'partyIdTo', type: 'string'},
					   { name: 'description', type: 'string'},
					   { name: 'productStoreId', type: 'string'},
					   { name: 'facilityId', type: 'string'},
					   { name: 'requirementDate',type: 'date', other: 'Timestamp'},
					   { name: 'task', type: 'string'},
					   ]"/>
					   
					   <#assign columnlist="
 						{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', width: 120, editable: false, cellsrenderer:
							   function(row, colum, value){
							        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
							        var agreementId = data.agreementId;
							        var link = 'detailPurchaseAgreement?agreementId=' + agreementId;
							return '<span><a href=\"' + link + '\">' + agreementId + '</a></span>';
 						}},
 						{ text: '${uiLabelMap.OrderId}', datafield: 'orderId', width: 120, editable: false},
 						{ text: '${uiLabelMap.AgreementDate}', datafield: 'agreementDate', width: 200, editable: false, filtertype: 'range', cellsformat: 'dd/MM/yyyy'},
 						{ text: '${uiLabelMap.SlideA}', datafield: 'partyIdFrom', width: 150, filtertype: 'olbiusdropgrid', editable: false, cellsrenderer:
 	     			       function(row, colum, value){
 	    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
 	    			        var partyIdFrom = data.partyIdFrom;
 	    			        var partyFrom = getPartyNameView(partyIdFrom);
 	    			        return '<span>' + partyFrom + '</span>';
 	    		        },createfilterwidget: function (column, columnElement, widget) {
 			   				widget.width(140);
 			   			}},
 						{ text: '${uiLabelMap.SlideB}', datafield: 'partyIdTo', width: 150, filtertype: 'olbiusdropgrid',editable: false, cellsrenderer:
 	     			       function(row, colum, value){
 	    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
 	    			        var partyIdTo = data.partyIdTo;
 	    			        var partyTo = getPartyNameView(partyIdTo);
 	    			        return '<span>' + partyTo + '</span>';
 	    		        },createfilterwidget: function (column, columnElement, widget) {
 			   				widget.width(140);
 			   			}},
 						{ text: '${uiLabelMap.description}', datafield: 'description', minWidth: 180, editable: false, cellsrenderer:
 					       function(row, colum, value){
 					        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
 					        var dataShow = data.description;
 					        var dataShort = executeMyData(dataShow);
 					        var id = data.agreementId;
 					        id = 'description' + id;
 					        return '<span id=\"' + id + '\" onmouseenter=\"showMore(' + \"'\" + dataShow + \"'\" + ',' + \"'\" + id  + \"'\" + ')\" >' + dataShort + '</span>';
 				        }},
 				       { text: '${uiLabelMap.productStore}', datafield: 'productStoreId', width: 120, editable: false, filtertype: 'checkedlist', cellsrenderer:
							function(row, colum, value){
								var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								var productStoreId = data.productStoreId;
								var productStore = getProductStore(productStoreId);
								return '<span>' + productStore + '</span>';
						}, createfilterwidget: 
							function(row, column, editor){
							editor.jqxDropDownList({ autoDropDownHeight: true, source: productStore, displayMember: 'productStoreId', valueMember: 'productStoreId' ,
							    renderer: function (index, label, value) {
							        var datarecord = productStore[index];
							        return datarecord.storeName;
							    } });
							editor.jqxDropDownList('checkAll');
						}},
						{ text: '${uiLabelMap.Task}', datafield: 'task', align: 'center', filterable: false, editable: false, width: 170,
			                	   cellsrenderer: function(row, colum, value){
			                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			                		   data.description = '';
			                		   data = toString(data);
			                		   return '<span><button type=\"submit\" class=\"btn btn-small btn-primary\" onclick=createClick(\"' + data + '\") >\' + \'<i class=\"icon-ok\"></i>${uiLabelMap.CommonCreate}\' + \'</button></span>';
			                	   }
			                },
						"/>
			                
			   <@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
								showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false"
									customcontrol1="icon-tasks@${uiLabelMap.ListReceiveRequirement}@getListReceiptRequirements"
								url="jqxGeneralServicer?sname=JQGetListEditReceiptRequirement" updateUrl="jqxGeneralServicer?sname=updateAgreementStatus&jqaction=U"
								editColumns="agreementId;agreementDate(java.sql.Timestamp);partyIdFrom;partyIdTo;description;statusId"
								otherParams="productStoreId:S-getProductStoreID(orderId)<productStoreId>"
							/>
			                
		<div id="myDiv"></div>
	<#assign partyNameView = delegator.findList("PartyNameView", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("partyTypeId", "PARTY_GROUP"), null, null, null, false) />
	<#assign productStore = delegator.findList("ProductStore", null, null, null, null, false) />    
	<#assign facility = delegator.findList("Facility", null, null, null, null, false) />
	<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>
	<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
	<script type="text/javascript" src="/delys/images/js/ckeditor/ckeditor.js"></script>
	<script>
		function toString(myJSObject) {
	    	myJSObject = JSON.stringify(myJSObject);
	    	myJSObject = myJSObject.replace(/"/g, "'");
	    	return myJSObject;
		}
		
		var facilityList = new Array();
		<#if facility?exists>
			<#list facility as item>
				var row = {};
				row['facilityName'] = '${item.facilityName?if_exists}';
				row['facilityId'] = '${item.facilityId?if_exists}';
				facilityList[${item_index}+1] = row;
			</#list>
		</#if>
		
		var productStore = new Array();
		var row1 = {};
		row1['storeName'] = '';
		row1['productStoreId'] = '';
		productStore[0] = row1;
		<#if productStore?exists>
			<#list productStore as item>
				var row = {};
				row['storeName'] = '${item.storeName?if_exists}';
				row['productStoreId'] = '${item.productStoreId?if_exists}';
				productStore[${item_index}+1] = row;
			</#list>
		</#if>
		function getProductStore(productStoreId) {
			if (productStoreId != null) {
				for ( var x in productStore) {
					if (productStoreId == productStore[x].productStoreId) {
						return productStore[x].storeName;
					}
				}
			} else {
				return "";
			}
		}
		
		var partyNameView = new Array();
		<#if partyNameView?exists>
		<#list partyNameView as item>
			var row = {};
			row['description'] = '${item.firstName?if_exists} ' + '${item.middleName?if_exists}' + '${item.lastName?if_exists}' + '${item.groupName?if_exists}';
			row['partyId'] = '${item.partyId?if_exists}';
			partyNameView[${item_index}] = row;
		</#list>
		</#if>
		function getPartyNameView(partyId) {
			if (partyId != null) {
				for ( var x in partyNameView) {
					if (partyId == partyNameView[x].partyId) {
						return partyNameView[x].description;
					}
				}
			} else {
				return "";
			}
		}
		
		var myVar;
		function showMore(data, id) {
				$("#" + id).jqxTooltip('destroy');
				data = data.trim();
				var dataPart = data.replace("<p>", "");
				dataPart = dataPart.replace("</p>", "");
			    data = "<i onmouseenter='notDestroy()' onmouseleave='destroy(\"" + id + "\")'>" + dataPart + "</i>";
			    $("#" + id).jqxTooltip({ content: data, position: 'right', autoHideDelay: 3000, closeOnClick: false, autoHide: false});
			    myVar = setTimeout(function(){ 
					$("#" + id).jqxTooltip('destroy');
			    }, 1000);
		}
		function notDestroy() {
			clearTimeout(myVar);
		}
		function destroy(id) {
			clearTimeout(myVar);
			myVar = setTimeout(function(){
				$("#" + id).jqxTooltip('destroy');
			}, 2000);
		}
	   function executeMyData(dataShow) {
		   if (dataShow != null) {
			   var datalength = dataShow.length;
		        var dataShowShort = "";
		        if (datalength > 40) {
		        	dataShowShort = dataShow.substr(0, 40) + "...";
				}else {
					dataShowShort = dataShow;
				}
			   return dataShowShort;
			} else {
				 return '';
			}
	   }
	   function createClick(data) {
		    data = data.replace(/'/g, '"');
	    	data = JSON.parse(data);
	       	var wd = "";
	       	wd += "<div id='window01'><div>${uiLabelMap.SaveFileScan}</div><div>";
	       	wd += "<div class='row-fluid'>" +
					    "<div class='span12 no-left-margin'>" +
							"<div class='span5'>${uiLabelMap.FacilityToReceive}:</div>" +
							"<div class='span7'><div id='facilityId'></div>" +
						"</div>" +
						"<div class='span12 no-left-margin'>" +
							"<div class='span5'>${uiLabelMap.ReceiveDate}:</div>" +
							"<div class='span7'><div id='requirementDate'></div>" +
						"</div>" +
	       	   			"<div class='span12 no-left-margin'>" +
							"<div class='span8'></div>" +
							"<div class='span4'><input style='margin-right: 5px;' type='button' id='alterSave5' value='${uiLabelMap.CommonSave}' /><input id='alterCancel5' type='button' value='${uiLabelMap.CommonCancel}' /></div>" +
						"</div>" +
					"</div>";
	       	wd += "</div></div>";
	       	$("#myDiv").html(wd);
	       	$('#window01').jqxWindow({ height: 150, width: 400, isModal: true, modalOpacity: 0.7 });
	       	$("#requirementDate").jqxDateTimeInput();
	       	$("#facilityId").jqxDropDownList({ autoDropDownHeight: true, source: facilityList, displayMember: 'facilityName', valueMember: 'facilityId' });
	       	$('#requirementDate').val(null);
	       	$("#alterCancel5").jqxButton();
	        $("#alterSave5").jqxButton();
	        $("#alterSave5").click(function () {
	        	var getDate = $('#requirementDate').val();
	        	var value = $("#facilityId").jqxDropDownList('val');
	        	getDate = toTimeStamp(getDate);
	        	data.requirementDate = getDate;
	        	data.facilityId = value;
	        	executeTask(data, "updateReceiptRequirement");
       			$('#window01').jqxWindow('destroy');
            });
            $("#alterCancel5").click(function () {
           	 $('#window01').jqxWindow('destroy');
            });
       }
	   function executeTask(data, url) {
	    	var requirementId;
	    	jQuery.ajax({
				url: url,
				type: "POST",
				data: data,
				success: function(res) {
					requirementId = res["requirementId"];
		        }
			}).done(function() {
				if (requirementId != undefined || requirementId != "") {
					var message = "<div id='contentMessages' class='alert alert-success' onclick='hiddenClick()'>" +
					"<p id='thisP'>" + '${uiLabelMap.DAUpdateSuccessful}' + "</p></div>";
			    	$("#myAlert").html(message);
				}else {
					message = "<div id='contentMessages' class='alert alert-error' onclick='hiddenClick()'>" +
	    			"<p id='thisP'>" + '${uiLabelMap.DAUpdateError}' + "</p></div>";
	    	    	$("#myAlert").html(message);
				}
				$("#clearfilteringbuttonjqxgrid").click();
			});
		}
	    function hiddenClick() {
	    	$('#contentMessages').css('display','none');
	    }
	    function toTimeStamp(date) {
	    	if (date == "") {
	    		return "";
	    	} else {
	    		var splDate = date.split('/');
	    		var timeStamp = splDate[2] + '-' + splDate[1] + '-' + splDate[0];
	    		return timeStamp;
	    	}
	    }
	</script>
	<div id="jqxwindowpartyIdTo">
	<div>${uiLabelMap.SelectPartyId}</div>
	<div style="overflow: hidden;">
		<table id="PartyId">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdTokey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdTovalue" value=""/>
					<div id="jqxgridpartyid"></div>
				</td>
			</tr>
		    <tr>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave2" value="${uiLabelMap.CommonSave}" /><input id="alterCancel2" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
    	</table>
    </div>
    </div>
    
  <div id="jqxwindowpartyIdFrom">
	<div>${uiLabelMap.SelectPartyIdFrom}</div>
	<div style="overflow: hidden;">
		<table id="PartyIdFrom">
			<tr>
				<td>
					<input type="hidden" id="jqxwindowpartyIdFromkey" value=""/>
					<input type="hidden" id="jqxwindowpartyIdFromvalue" value=""/>
					<div id="jqxgridpartyidfrom"></div>
				</td>
			</tr>
		    <tr>
		        <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave3" value="${uiLabelMap.CommonSave}" /><input id="alterCancel3" type="button" value="${uiLabelMap.CommonCancel}" /></td>
		    </tr>
		</table>
	</div>
</div>

<script type="text/javascript">
$.jqx.theme = 'olbius';  
theme = $.jqx.theme;  
$("#jqxwindowpartyIdFrom").jqxWindow({
    theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel3"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
});
$('#jqxwindowpartyIdFrom').on('open', function (event) {
	var offset = $("#jqxgrid").offset();
		$("#jqxwindowpartyIdFrom").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
});
$("#alterSave3").jqxButton({theme: theme});
$("#alterCancel3").jqxButton({theme: theme});
$("#alterSave3").click(function () {
	var tIndex = $('#jqxgridpartyidfrom').jqxGrid('selectedrowindex');
	var data = $('#jqxgridpartyidfrom').jqxGrid('getrowdata', tIndex);
	$('#' + $('#jqxwindowpartyIdFromkey').val()).val(data.partyId);
	$("#jqxwindowpartyIdFrom").jqxWindow('close');
	var e = jQuery.Event("keydown");
	e.which = 50; // # Some key code value
	$('#' + $('#jqxwindowpartyIdFromkey').val()).trigger(e);
});
// From party
var sourceF =
{
    datafields:
    [
        { name: 'partyId', type: 'string' },
        { name: 'partyTypeId', type: 'string' },
        { name: 'firstName', type: 'string' },
        { name: 'lastName', type: 'string' },
        { name: 'groupName', type: 'string' }
    ],
    cache: false,
    root: 'results',
    datatype: "json",
    updaterow: function (rowid, rowdata) {
        // synchronize with the server - send update command   
    },
    beforeprocessing: function (data) {
        sourceF.totalrecords = data.TotalRows;
    },
    filter: function () {
        // update the grid and send a request to the server.
        $("#jqxgridpartyidfrom").jqxGrid('updatebounddata');
    },
    pager: function (pagenum, pagesize, oldpagenum) {
        // callback called when a page or page size is changed.
    },
    sort: function () {
        $("#jqxgridpartyidfrom").jqxGrid('updatebounddata');
    },
    sortcolumn: 'partyId',
	sortdirection: 'asc',
    type: 'POST',
    data: {
        noConditionFind: 'Y',
        conditionsFind: 'N',
    },
    pagesize:5,
    contentType: 'application/x-www-form-urlencoded',
    url: 'jqxGeneralServicer?sname=getFromParty',
};
var dataAdapterF = new $.jqx.dataAdapter(sourceF,
{
	autoBind: true,
	formatData: function (data) {
		if (data.filterscount) {
            var filterListFields = "";
            for (var i = 0; i < data.filterscount; i++) {
                var filterValue = data["filtervalue" + i];
                var filterCondition = data["filtercondition" + i];
                var filterDataField = data["filterdatafield" + i];
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
            if (!sourceF.totalRecords) {
                sourceF.totalRecords = parseInt(data['odata.count']);
            }
    }
});
$('#jqxgridpartyidfrom').jqxGrid(
{
    width:800,
    source: dataAdapterF,
    filterable: true,
    virtualmode: true, 
    sortable:true,
    editable: false,
    showfilterrow: false,
    theme: theme, 
    autoheight:true,
    pageable: true,
    pagesizeoptions: ['5', '10', '15'],
    ready:function(){
    },
    rendergridrows: function(obj)
	{
		return obj.data;
	},
     columns: [
      { text: '${uiLabelMap.accApInvoice_ToPartyId}', datafield: 'partyId', width:150},
      { text: '${uiLabelMap.accApInvoice_ToPartyTypeId}', datafield: 'partyTypeId', width:200},
      { text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'firstName', width:150},
      { text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName', width:150},
      { text: '${uiLabelMap.accAccountingToParty}', datafield: 'groupName', width:150}
    ]
});
</script>
<script type="text/javascript">
	$("#jqxwindowpartyIdTo").jqxWindow({
        theme: theme, isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, minWidth: 820, maxWidth: 1200, height: 'auto', minHeight: 515        
    });
    $('#jqxWindow').on('open', function (event) {
    	var offset = $("#jqxgrid").offset();
   		$("#jqxwindowpartyIdTo").jqxWindow({ position: { x: parseInt(offset.left) + 60, y: parseInt(offset.top) + 60 } });
	});
	$("#alterSave2").jqxButton({theme: theme});
	$("#alterCancel2").jqxButton({theme: theme});
	$("#alterSave2").click(function () {
		var tIndex = $('#jqxgridpartyid').jqxGrid('selectedrowindex');
		var data = $('#jqxgridpartyid').jqxGrid('getrowdata', tIndex);
		$('#' + $('#jqxwindowpartyIdTokey').val()).val(data.partyId);
		$("#jqxwindowpartyIdTo").jqxWindow('close');
		var e = jQuery.Event("keydown");
		e.which = 50; // # Some key code value
		$('#' + $('#jqxwindowpartyIdTokey').val()).trigger(e);
	});
	$("#alterCancel2").click(function () {
		$("#jqxwindowpartyIdTo").jqxWindow('close');
	});
    var sourceP =
    {
        datafields:
        [
            { name: 'partyId', type: 'string' },
            { name: 'partyTypeId', type: 'string' },
            { name: 'firstName', type: 'string' },
            { name: 'lastName', type: 'string' },
            { name: 'groupName', type: 'string' }
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
            $("#jqxgridpartyid").jqxGrid('updatebounddata');
        },
        pager: function (pagenum, pagesize, oldpagenum) {
            // callback called when a page or page size is changed.
        },
        sort: function () {
            $("#jqxgridpartyid").jqxGrid('updatebounddata');
        },
        sortcolumn: 'partyId',
		sortdirection: 'asc',
        type: 'POST',
        data: {
	        noConditionFind: 'Y',
	        conditionsFind: 'N',
	    },
	    pagesize:5,
        contentType: 'application/x-www-form-urlencoded',
        url: 'jqxGeneralServicer?sname=getFromParty',
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
    $('#jqxgridpartyid').jqxGrid(
    {
        width:800,
        source: dataAdapterP,
        filterable: true,
        virtualmode: true, 
        sortable:true,
        theme: theme, 
        editable: false,
        autoheight:true,
        pageable: true,
        pagesizeoptions: ['5', '10', '15'],
        ready:function(){
        },
        rendergridrows: function(obj)
		{
			return obj.data;
		},
         columns: [
			  { text: '${uiLabelMap.accApInvoice_ToPartyId}', datafield: 'partyId', width:150},
	          { text: '${uiLabelMap.accApInvoice_ToPartyTypeId}', datafield: 'partyTypeId', width:200},
	          { text: '${uiLabelMap.FormFieldTitle_firstName}', datafield: 'firstName', width:150},
	          { text: '${uiLabelMap.FormFieldTitle_lastName}', datafield: 'lastName', width:150},
	          { text: '${uiLabelMap.accAccountingToParty}', datafield: 'groupName', width:150}
			]
    });
    
    $(document).keydown(function(event){
	    if(event.ctrlKey)
	        cntrlIsPressed = true;
	});
	
	$(document).keyup(function(event){
		if(event.which=='17')
	    	cntrlIsPressed = false;
	});
	var cntrlIsPressed = false;
</script>