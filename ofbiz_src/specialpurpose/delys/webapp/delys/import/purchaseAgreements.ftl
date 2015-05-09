<script type="text/javascript" src="/delys/images/js/import/miscUtil.js"></script>
<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>

<#assign dataField="[{ name: 'agreementId', type: 'string'},
						   { name: 'attrValue', type: 'string'},
						   { name: 'agreementDate', type: 'date', other: 'Timestamp'},
						   { name: 'partyIdFrom', type: 'string'},
						   { name: 'partyIdTo', type: 'string'},
						   { name: 'description', type: 'string'},
						   { name: 'statusId', type: 'string'},
						   ]"/>
<#assign columnlist="
					{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', width: 120, editable: false, cellsrenderer:
					       function(row, colum, value){
						        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
						        var agreementId = data.agreementId;
						        var link = 'detailPurchaseAgreement?agreementId=' + agreementId;
						        return '<span><a href=\"' + link + '\">' + agreementId + '</a></span>';
			        }},
			        { text: '${uiLabelMap.AgreementName}' ,filterable: true, sortable: true, datafield: 'attrValue', minwidth: 200, editable: false},
					{ text: '${uiLabelMap.AgreementDate}', datafield: 'agreementDate', width: 150, editable: false, filtertype: 'range', cellsformat: 'dd/MM/yyyy'},
					{ text: '${uiLabelMap.SlideA}', datafield: 'partyIdFrom', width: 150, filtertype: 'olbiusdropgrid', editable: false, cellsrenderer:
     			       function(row, colum, value){
    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    			        var partyIdFrom = data.partyIdFrom;
    			        var partyFrom = getPartyNameView(partyIdFrom);
    			        return '<span>' + partyFrom + '</span>';
    		        },createfilterwidget: function (column, columnElement, widget) {
		   				widget.width(140);
		   			}},
					{ text: '${uiLabelMap.SlideB}', datafield: 'partyIdTo', width: 150, filtertype: 'olbiusdropgrid', editable: false, cellsrenderer:
     			       function(row, colum, value){
    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    			        var partyIdTo = data.partyIdTo;
    			        var partyTo = getPartyNameView(partyIdTo);
    			        return '<span>' + partyTo + '</span>';
    		        },createfilterwidget: function (column, columnElement, widget) {
		   				widget.width(140);
		   			}},
					{ text: '${uiLabelMap.description}', datafield: 'description', minWidth: 150, editable: false, cellsrenderer:
					       function(row, colum, value){
				        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
				        var dataShow = data.description;
				        var dataShort = executeMyData(dataShow);
				        var id = data.agreementId;
				        id = 'description' + id;
				        return '<span id=\"' + id + '\" onmouseenter=\"showMore(' + \"'\" + dataShow + \"'\" + ',' + \"'\" + id  + \"'\" + ')\" >' + dataShort + '</span>';
			        }},
					{ text: '${uiLabelMap.Status}', datafield: 'statusId', width: 150, editable: true, columntype: 'dropdownlist', filtertype: 'checkedlist', createeditor: 
					function(row, column, editor){
						editor.jqxDropDownList({ autoDropDownHeight: true, source: listStatus, displayMember: 'statusId', valueMember: 'statusId' ,
                            renderer: function (index, label, value) {
			                    var datarecord = listStatus[index];
			                    return datarecord.description;
			                },selectionRenderer: function () {
				                var item = editor.jqxDropDownList('getSelectedItem');
				                if (item) {
		  							return '<span title=' + item.value +'>' + getStatus(item.value) + '</span>';
				                }
				                return '<span>Please Choose:</span>';
				            }});
					}, cellvaluechanging: function (row, column, columntype, oldvalue, newvalue) {
                        if (newvalue == '') return oldvalue;
                    },cellsrenderer:
     			       function(row, colum, value){
    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    			        var statusId = data.statusId;
    			        var status = getStatus(statusId);
    			        return '<span>' + status + '</span>';
    		        },createfilterwidget: function (column, htmlElement, editor) {
    		        	editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(listStatus), displayMember: 'statusId', valueMember: 'statusId' ,
                            renderer: function (index, label, value) {
                            	if (index == 0) {
                            		return value;
								}
							    return getStatus(value);
			                } });
    		        	editor.jqxDropDownList('checkAll');
                    }},
					{ text: \'${uiLabelMap.SaveFileScan}\',columntype: \'button\', align: 'center', editable: false, width: 170, filterable: false,
		                	   cellsrenderer: function(){
		                		return '${StringUtil.wrapString(uiLabelMap.CommonAdd)}';
		                	   }, buttonclick: function(row){
		                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		                		   saveFileScan(data.agreementId);
		                	   }
		                   },
		             { text: \'${uiLabelMap.ViewFileScan}\',columntype: \'button\', editable: false, width: 150, filterable: false,
		                	   cellsrenderer: function(row, column, value){
		                		   return '${StringUtil.wrapString(uiLabelMap.CommonView)}';
		                	   }, buttonclick: function(row){
		                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		                		   viewFileScan(data.agreementId);
		                	   }
		                   },
					"/>
					
    <@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" editmode="dblclick"
						showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true" 
						customcontrol1="icon-plus-sign open-sans@${uiLabelMap.CommonCreateNew}@getImportPlanToCreateAgreement"
						url="jqxGeneralServicer?sname=JQGetListPurchaseAgreements" updateUrl="jqxGeneralServicer?sname=updateAgreementStatus&jqaction=U"
						createUrl="jqxGeneralServicer?sname=createPurchaseAgreements&jqaction=C"
						addColumns="agreementId;agreementDate(java.sql.Timestamp);partyIdFrom;partyIdTo;description;statusId"
						editColumns="agreementId;agreementDate(java.sql.Timestamp);partyIdFrom;partyIdTo;description;statusId"
					/>
    		        
    		        <div id = "myEditor"></div>
    		        <div id = "myImage"></div>
    		        
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
	    			// FromParty
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
	    		  
	    		    
  <script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>
  <script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
  <script type="text/javascript" src="/delys/images/js/ckeditor/ckeditor.js"></script>
    <script>
    var ck = CKEDITOR.instances;
    
    			var listStatus = new Array();
    			<#if listStatus?exists>
    			<#list listStatus as item>
    				var row = {};
    				row['description'] = '${item.description?if_exists}';
    				row['statusId'] = '${item.statusId?if_exists}';
    				listStatus[${item_index}] = row;
    			</#list>
    			</#if>
    			
    			function getStatus(statusId) {
    				if (statusId != null) {
    					for ( var x in listStatus) {
        					if (statusId == listStatus[x].statusId) {
        						return listStatus[x].description;
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
    			var sizeSub = 40;
				function showMore(data, id) {
						$("#" + id).jqxTooltip('destroy');
						data = data.trim();
						var dataPart = data.replace("<p>", "");
						dataPart = dataPart.replace("</p>", "");
					    data = "<i onmouseenter='notDestroy()' onmouseleave='destroy(\"" + id + "\")'>" + dataPart + "</i>";
					    $("#" + id).jqxTooltip({ content: data, position: 'right', autoHideDelay: 3000, closeOnClick: false, autoHide: false});
					    myVar = setTimeout(function(){ 
							$("#" + id).jqxTooltip('destroy');
					    }, 2000);
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
				        if (datalength > sizeSub) {
				        	dataShowShort = dataShow.substr(0, sizeSub) + "...";
						}else {
							dataShowShort = dataShow;
						}
					   return dataShowShort;
					} else {
						 return '';
					}
			   }
			   $("#jqxgrid").on("columnResized", function (event) 
						{
						    var args = event.args;
						    var dataField = args.datafield;
						    if (dataField == "description1" ||dataField == "description") {
						    	var newWidth = args.newwidth;
						    	sizeSub = 0;
						    	while (newWidth > 10) {
						    		sizeSub += 2;
						    		newWidth -= 7;
							}
						    	$('#jqxgrid').jqxGrid('refreshData');
						}
				});
			   $("#jqxgrid").on("cellDoubleClick", function (event)
		        		{
		        		    var args = event.args;
		        		    var rowBoundIndex = args.rowindex;
		        		    var rowVisibleIndex = args.visibleindex;
		        		    var rightclick = args.rightclick;
		        		    var ev = args.originalEvent;
		        		    var columnindex = args.columnindex;
		        		    var dataField = args.datafield;
		        		    var value = args.value;
		        		    var data = $('#jqxgrid').jqxGrid('getrowdata', rowBoundIndex);
					        var agreementId = data.agreementId;
		        		    if (dataField == 'description') {
		        		    	$("#description" + agreementId).jqxTooltip('destroy'); 
		        		    	editDescription(value, rowBoundIndex);
							}
		        });
		        function editDescription(Value, rowBoundIndex) {
		        	var wd = "";
		        	wd += "<div id='window01'><div>Edit Description</div><div>";
		        	wd += "<textarea  class='note-area no-resize' id='myEDT' autocomplete='off'></textarea>";
		        	wd += "<input style='margin-right: 5px;' type='button' id='alterSave11' value='${uiLabelMap.CommonSave}' /><input id='alterCancel11' type='button' value='${uiLabelMap.CommonCancel}' />"
		        	wd += "</div></div>";
		        	$("#myEditor").html(wd);
		        	$("#alterCancel11").jqxButton();
			        $("#alterSave11").jqxButton();
			        $("#alterSave11").click(function () {
			        	var data = getDataEditor("myEDT");
	        			var dataPart = data.replace("<em>", "<i>");
	        			dataPart = dataPart.replace("</em>", "</i>");
	        			dataPart = dataPart.trim();
	        			$("#jqxgrid").jqxGrid('setCellValue', rowBoundIndex, "description", dataPart);
			            $("#jqxgrid").jqxGrid('clearSelection');
			            $("#jqxgrid").jqxGrid('selectRow', 0);
			            $("#window01").jqxWindow('destroy');
			        });
			        $("#alterCancel11").click(function () {
			            $("#window01").jqxWindow('destroy');
			        });
		        	CKEDITOR.replace('myEDT', {height: '100px', width: '440px', skin: 'office2013'});
		        	if (Value == null) {
		        		Value = "";
					}
		        	if (Value != "") {
		        		var dataPart = Value.replace("<i>", "<em>");
	        			dataPart = dataPart.replace("</i>", "</em>");
			        	setDataEditor("myEDT", dataPart);
					}
		        	$('#window01').jqxWindow({ height: 350, width: 450, isModal:true, modalOpacity: 0.7});
		        }
		        function setDataEditor(key, content) {
		        	if (ck[key]) {
		        		return ck[key].setData(content);
		        	}
		        }
		        function getDataEditor(key) {
		        	if (ck[key]) {
		        		return ck[key].getData();
		        	}
		        	return "";
		        }
		        function viewFileScan(agreementId) {
		        	var path = '/DELYS/delys/agreementFile_' + agreementId;
//		        	webdav/repository/default/DELYS/delys/agreementFile_1280/Town-Hall-Level-7-3.jpg(2)
		        	getFileScan(path);
				}
		        function getFileScan(path) {
		        	var jsonObject = {nodePath : path,}
		        	var fileUrl = [];
		        	jQuery.ajax({
		                url: "getFileScanAjax",
		                type: "POST",
		                data: jsonObject,
		                success: function(res) {
		                	fileUrl = res["childNodes"];
		                }
		            }).done(function() {
						viewImage(fileUrl, path);
		        	});
		        }
		        function viewImage(fileUrl, path) {
		        	var height = 0;
		        	var wd = "";
		        	wd += "<div id='window01'><div>${uiLabelMap.AgreementScanFile}</div><div>";
		        	if (fileUrl == undefined) {
		        		wd += "<h1><p style='color: #999999'>${uiLabelMap.FileNotFound}!</p></h1>";
		        		height = 300;
					} else {
			        	for ( var er in fileUrl) {
			        		var link = "/webdav/repository/default" + path + "/" + fileUrl[er];
			        		wd += "<img src='" + link + "'><br/>";
			        		height = 650;
			        	}
					}
		        	wd += "</div></div>";
		        	$("#myImage").html(wd);
		        	$('#window01').jqxWindow({ height: height, width: 700, maxWidth: 1200, isModal: true, modalOpacity: 0.7 });
		        	$('#window01').on('close', function (event) {
		            	 listImage = [];
		            	 $('#window01').jqxWindow('destroy');
		             }); 
		        }
		        var listImage = [];
		        function saveFileScan(agreementId) {
		        	var wd = "";
		        	wd += "<div id='window01'><div>${uiLabelMap.SaveFileScan}</div><div>";
		        	wd += "<h3>${uiLabelMap.FileScan}</h3><input multiple type='file' id='id-input-file-3'/>";
		        	wd += "<div class='row-fluid'>" +
							"<div class='span12 no-left-margin'>" +
								"<div class='span4'></div>" +
								"<div class='span8'><input style='margin-right: 5px;' type='button' id='alterSave5' value='${uiLabelMap.CommonSave}' /><input id='alterCancel5' type='button' value='${uiLabelMap.CommonCancel}' /></div>" +
							"</div>";
		        	wd += "</div></div>";
		        	$("#myImage").html(wd);
		        	$('#window01').jqxWindow({ height: 350, width: 450, isModal: true, modalOpacity: 0.7 });
		        	$("#alterCancel5").jqxButton();
		            $("#alterSave5").jqxButton();
		        	$('#id-input-file-3').ace_file_input({
		        		style:'well',
		        		btn_choose:'Drop files here or click to choose',
		        		btn_change:null,
		        		no_icon:'icon-cloud-upload',
		        		droppable:true,
		        		onchange:null,
		        		thumbnail:'small',
		        		before_change:function(files, dropped) {
		        			var count = files.length;
		        			for (var int = 0; int < files.length; int++) {
		        				var imageName = files[int].name;
		        				var hashName = imageName.split(".");
		        				var extended = hashName.pop();
		        				if (extended == "jpg" || extended == "jpeg" || extended == "gif" || extended == "png") {
		        					listImage.push(files[int]);
		        				}
		        			}
		        			return true;
		        		},
		        		before_remove : function() {
		        			listImage = [];
		        			return true;
		        		}

		        	}).on('change', function(){
//		        		listImage = [];
		        	});
		        	 $("#alterSave5").click(function () {
		        		 var newFolder = "/delys/" + 'agreementFile_' + agreementId;
		        			for ( var d in listImage) {
		        				var file = listImage[d];
		        				var dataResourceName = file.name;
		        				var path = "";
		        				var form_data= new FormData();
		        				form_data.append("uploadedFile", file);
		        				form_data.append("folder", newFolder);
		        				jQuery.ajax({
		        					url: "uploadDemo",
		        					type: "POST",
		        					data: form_data,
		        					cache : false,
		        					contentType : false,
		        					processData : false,
		        					success: function(res) {
		        						path = res.path;
		        			        }
		        				}).done(function() {
		        				});
		        			}
		        			$('#window01').jqxWindow('destroy');
    						var message = "<div id='contentMessages' class='alert alert-success' onclick='hiddenClick()'>" +
    						"<p id='thisP'>" + '${uiLabelMap.DAUpdateSuccessful}' + "</p></div>";
    				    	$("#myAlert").html(message);
		             });
		             $("#alterCancel5").click(function () {
		            	 listImage = [];
		            	 $('#window01').jqxWindow('destroy');
		             });
		             $('#window01').on('close', function () {
		            	 listImage = [];
		            	 $('#window01').jqxWindow('destroy');
		             });
		        }
		        function hiddenClick() {
		        	$('#contentMessages').css('display','none');
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
    <style type="text/css">
	#addrowbutton{
		margin:0 !important;
		border-radius:0 !important;
	}
	.jqx-grid-cell-olbius input.jqx-button-olbius {
		width: 60px!important;
	  text-align: center!important;
	  margin: 0 auto!important;
	  display: block!important;
	  position: relative!important;
	}
	</style>