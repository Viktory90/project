<script type="text/javascript" src="/delys/images/js/import/miscUtil.js"></script>
<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>
<script type="text/javascript" src="/delys/images/js/import/notify.js"></script>
<div id="jqxNotificationNested">
	<div id="notificationContentNested">
	</div>
</div>
<script>
$.notify.addStyle('happyblue', {
	  html: "<div>(^.^)<span data-notify-text/>(-.-)</div>",
	  classes: {
	    base: {
	      "white-space": "nowrap",
	      "background-color": "lightblue",
	      "padding": "5px",
	    },
	    superblue: {
	      "color": "white",
	      "background-color": "blue"
	    }
	  }
	});
</script>
<#assign initrowdetailsDetail = "function (index, parentElement, gridElement, datarecord) {
	rowsExpaded = index;
	var billNumberGlobal = datarecord.billNumber;
	var billIdGlobal = datarecord.billId;
	if(datarecord.rowDetail == null || datarecord.rowDetail.length < 1){
		var grid = $($(parentElement).children()[0]);
        $(grid).attr('id','jqxgridDetail'+index);
        if (grid != null) {
            grid.jqxGrid({
                source: new Array(),
                width: '96%', 
                height: 150,
                showtoolbar:false,
		 		editable:true,
		 		editmode:\"click\",
		 		showheader: true,
		 		selectionmode:\"singlecell\",
		 		theme: 'energyblue',
                columns: [
							{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', width: '150px', editable: false},
							{ text: '${uiLabelMap.OrderOrderId}', datafield: 'orderId', width: '150px', editable: false},
							{ text: '${uiLabelMap.AgreementDate}', datafield: 'agreementDate', columntype: 'datetimeinput',width: '150px', editable: false, cellsformat: 'dd/MM/yyyy'},
							{ text: '${uiLabelMap.shippingLineId}', datafield: 'shippingLineId', width: '150px', editable: false},
							{ text: '${uiLabelMap.billNumber}', datafield: 'billNumber', width: '150px', editable: true},
							{ text: '${uiLabelMap.containerNumber}', datafield: 'containerNumber', width: '150px', editable: true},
							{ text: '${uiLabelMap.Status}', datafield: 'statusId', width: '150px', columntype: 'dropdownlist', editable: true},
                ],
                showtoolbar: true,
                rendertoolbar: function (toolbar) {
                	 var gridId = 'jqxgridDetail'+index;
                	 var myToolBar = '<span><button type=\"submit\" class=\"btn btn-mini btn-primary\" onclick=AddToRow(\"' + gridId + '\",\"' + billNumberGlobal + '\",\"' + billIdGlobal + '\") >\' + \'<i class=\"icon-plus\"></i>${uiLabelMap.CommonAdd}\' + \'</button></span>';
                	 toolbar.html(myToolBar);
                }
            });
        }
        return false;
	}
	var dataAdapter = new $.jqx.dataAdapter(datarecord.rowDetail, { autoBind: true });
    var recordData = dataAdapter.records;
		var nestedGrids = new Array();
        var id = datarecord.uid.toString();
        
         var grid = $($(parentElement).children()[0]);
         $(grid).attr('id','jqxgridDetail'+index);
         nestedGrids[index] = grid;
       
         var recordDataById = [];
         for (var ii = 0; ii < recordData.length; ii++) {
             recordDataById.push(recordData[ii]);
         }
         var recordDataSource = { datafields: [	
					{ name: 'agreementId', type: 'string' },
					{ name: 'orderId', type: 'string'},
					{ name: 'agreementDate', type: 'date', other: 'Timestamp'},
					{ name: 'shippingLineId', type: 'string'},
					{ name: 'partyIdFrom', type: 'string'},
					{ name: 'billNumber', type: 'string'},
					{ name: 'billId', type: 'string'},
					{ name: 'containerId', type: 'string'},
					{ name: 'containerNumber', type: 'string'},
					{ name: 'departureDate', type: 'date', other: 'Timestamp'},
					{ name: 'arrivalDate', type: 'date', other: 'Timestamp'},
					{ name: 'partyRentId', type: 'string'},
					{ name: 'statusId', type: 'string'},
         		],
             	localdata: recordDataById
         }
         var nestedGridAdapter = new $.jqx.dataAdapter(recordDataSource);
         setTimeout(function() {
        	 prepareEventDbClick('jqxgridDetail'+index);
		 },0);
         if (grid != null) {
             grid.jqxGrid({
                 source: nestedGridAdapter, 
                 width: '96%',
                 height: '96%',
                 showtoolbar:false,
		 		 editable:true,
		 		 pagesize: 5,
		 		 pageable: true,
		 		 editmode:\"click\",
		 		 showheader: true,
		 		 selectionmode:\"singlerow\",
		 		 theme: 'energyblue',
                 columns: [
							{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', width: '150px', editable: false},
							{ text: '${uiLabelMap.OrderOrderId}', datafield: 'orderId', width: '150px', editable: false},
							{ text: '${uiLabelMap.AgreementDate}', datafield: 'agreementDate', columntype: 'datetimeinput',width: '150px', editable: false, cellsformat: 'dd/MM/yyyy'},
							{ text: '${uiLabelMap.shippingLineId}', datafield: 'shippingLineId', width: '150px', editable: false, 
								createeditor: function (row, column, editor) {
							},
								cellsrenderer: function(){
									return 'HYUNDAI_COMPANY';
								},
							},
							{ text: '${uiLabelMap.billNumber}', datafield: 'billNumber', width: '150px', editable: false},
							{ text: '${uiLabelMap.containerNumber}', datafield: 'containerNumber', width: '150px', editable: true},
							{ text: '${uiLabelMap.Status}', datafield: 'statusId', width: '150px', columntype: 'dropdownlist', editable: true,cellsrenderer:
								function(row, colum, value){
								var data = grid.jqxGrid('getrowdata', row);
								var statusId = data.statusId;
								var status = getStatus(statusId);
								return '<span>' + status + '</span>';
								}, createeditor: 
									function(row, column, editor){
									editor.jqxDropDownList({ autoDropDownHeight: true, source: statusList, displayMember: 'statusId', valueMember: 'statusId' ,
									    renderer: function (index, label, value) {
									    	if (index == 0) {
				                        		return value;
											}
										    return getStatus(value);
									    } });
									}
							},
                 ],
                 showtoolbar: true,
                 rendertoolbar: function (toolbar) {
                	 		 var gridId = 'jqxgridDetail'+index;
                        	 var myToolBar = '<span><button type=\"submit\" class=\"btn btn-mini btn-primary\" onclick=AddToRow(\"' + gridId + '\",\"' + billNumberGlobal + '\",\"' + billIdGlobal + '\") >\' + \'<i class=\"icon-plus\"></i>${uiLabelMap.CommonAdd}\' + \'</button></span>';
                        	 myToolBar += '<span style=\"margin-left: 3px;\"><button type=\"submit\" class=\"btn btn-mini btn-danger\" onclick=DeleteThisRow(\"' + gridId + '\",\"' + billIdGlobal + '\") >\' + \'<i class=\"icon-trash\"></i>${uiLabelMap.CommonDelete}\' + \'</button></span>';
                        	 toolbar.html(myToolBar);
                 }
             });
         }
 }"/>

<#assign dataField="[{ name: 'billId', type: 'string' },
					 { name: 'billNumber', type: 'string'},
					 { name: 'departureDate', type: 'date', other: 'Timestamp'},
					 { name: 'arrivalDate', type: 'date', other: 'Timestamp'},
					 { name: 'rowDetail', type: 'string'},
					 { name: 'partyIdFrom', type: 'string'},
					 { name: 'partyIdTo', type: 'string'},
					 ]"/>
<#assign columnlist="					 
						{ text: '${uiLabelMap.billId}', datafield: 'billId', width: '200px', editable: true, filterable: false, cellsrenderer:
						       function(row, colum, value){
					        return '<span onclick=\"showMenu(event,&#39;' + value + '&#39;)\"><a href=\"javascript:void(0)\">' + value + '</span>';
				        }},
						{ text: '${uiLabelMap.billNumber}', datafield: 'billNumber', editable: false, filterable: true},
						{ text: '${uiLabelMap.departureDate}', datafield: 'departureDate', editable: false, columntype: 'datetimeinput', filtertype: 'range', width: '250px', cellsformat: 'dd/MM/yyyy'},
						{ text: '${uiLabelMap.arrivalDate}', datafield: 'arrivalDate', editable: false,  columntype: 'datetimeinput', filtertype: 'range', width: '250px', cellsformat: 'dd/MM/yyyy'},
					 "/>

						
		<@jqGrid filtersimplemode="true" alternativeAddPopup="alterpopupWindow" addType="popup" initrowdetails = "true" dataField=dataField initrowdetailsDetail=initrowdetailsDetail editmode="selectedrow"
			editable="false" columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="true"
		 	url="jqxGeneralServicer?sname=JQGetListReceiveAgreement" updateUrl="jqxGeneralServicer?sname=updateBillOfLading&jqaction=U"
			createUrl="jqxGeneralServicer?sname=createBillOfLading&jqaction=C" rowdetailsheight="247" 
		 	addColumns="billNumber;departureDate(java.sql.Timestamp);arrivalDate(java.sql.Timestamp);partyIdFrom;partyIdTo"
		 	editColumns="billId;billNumber;departureDate(java.sql.Timestamp);arrivalDate(java.sql.Timestamp);partyIdFrom;partyIdTo"
		 		/>
			<div id="myMenuPlace"></div>
						
						<div id="alterpopupWindow" style="display:none;">
				        <div>${uiLabelMap.AddNewProductPrice}</div>
				        <div style="overflow-y: scroll;">
				        	<div class="row-fluid">
				        		<div class="span12">
				    	 			<div class="span5">${uiLabelMap.BillNumber}:</div>
				    	 			<div class="span7"><input type='text' id="txtBillNumber"/></div>
			    	 			</div>
			    	 			<div class="span12 no-left-margin">
				    	 			<div class="span5">${uiLabelMap.FormFieldTitle_partyIdTo}:</div>
				    	 			<div class="span7"><div type='text' id="txtpartyIdTo"></div></div>
			    	 			</div>
			    	 			<div class="span12 no-left-margin">
				    	 			<div class="span5">${uiLabelMap.FormFieldTitle_partyIdFrom}:</div>
				    	 			<div class="span7"><div type='text' id="txtpartyIdFrom"></div></div>
			    	 			</div>
			    	 			<div class="span12 no-left-margin">
				    	 			<div class="span5">${uiLabelMap.departureDate}:</div>
				        	 		<div class="span7"><div type='text' id="txtdepartureDate"></div></div>
			    	 			</div>
			    	 			<div class="span12 no-left-margin">
			    	 			<div class="span5">${uiLabelMap.arrivalDate}:</div>
			    	 			<div class="span7"><div type='text' id="txtarrivalDate"></div></div>
			    	 			</div>
			        	 		<div class="span12 no-left-margin">
			        	 			<div class="span5"></div>
				                    <div class="span7"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div>
				                </div>
				             </div>
				        </div>
				    </div>
				    
				    <div id="jqxwindowPopupAdder1">
			    	<div>${uiLabelMap.SelectAgreements}</div>
			    	<div style="overflow-x: hidden;">
		        		<div class="row-fluid">
			        		<div class="span12 no-left-margin">
			                	<button id="clearfilteringPopupAdder" style="float: right; cursor: default;" title="(Ctrl+F)" role="button" class="jqx-rc-all jqx-rc-all-olbius jqx-button jqx-button-olbius jqx-widget jqx-widget-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius" aria-disabled="false"><span style="color:red;font-size:80%;left:5px;position:relative;">x</span><i class="fa-filter"></i> ${uiLabelMap.accRemoveFilter}</button>
			                </div>
				 			<div class="span12 no-left-margin" id="jqxgridPopupAdder"></div>
			                <div class="span12 no-left-margin">
			                	<div class="span5"></div>
			                	<div class="span7"><input style="margin-right: 5px;" type="button" id="alterSaveAdder" value="${uiLabelMap.CommonSave}" /><input id="alterCancelAdder" type="button" value="${uiLabelMap.CommonCancel}" /></div>
			                </div>
		                </div>
				    </div>
			    </div>
			    
			    <div id="jqxwindowOrderViewer">
		    	<div>${uiLabelMap.ListOrders}</div>
		    	<div style="overflow: hidden;">
	        		<div class="row-fluid">
	        		
	        			<div id="containerOrderViewer" style="width: 100%"></div>
	        		
		        		<div class="span12 no-left-margin">
		                	<button id="clearfilteringOrderViewer" style="float: right; cursor: default;" title="(Ctrl+F)" role="button" class="jqx-rc-all jqx-rc-all-olbius jqx-button jqx-button-olbius jqx-widget jqx-widget-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius" aria-disabled="false"><span style="color:red;font-size:80%;left:5px;position:relative;">x</span><i class="fa-filter"></i> ${uiLabelMap.accRemoveFilter}</button>
		                </div>
			 			<div class="span12 no-left-margin" id="jqxgridOrderViewer"></div>
		                <div class="span12 no-left-margin">
		                	<div class="span5"></div>
		                	<div class="span7"><input id="alterCancelOrderViewer" type="button" value="${uiLabelMap.CommonCancel}" /></div>
		                </div>
	                </div>
			    </div>
		    </div>
			    
			    <div id="containerPopupAdder" style="width: 100%"></div>
		        <div id="jqxNotificationPopupAdder">
			        <div id="notificationContentAdder">
			        </div>
		        </div>
		        
		        <div id="jqxNotificationOrderViewer">
			        <div id="notificationOrderViewer">
			        </div>
		        </div>
			<style>
			</style>
			<#assign status = delegator.findList("StatusItem", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("statusTypeId", "AGREEMENT_STATUS"), null, null, null, false) />
			<#assign listProducts = delegator.findList("Product", null, null, null, null, false) />
			<script>
			var product = new Array();
			<#list listProducts as product>
				<#assign description = StringUtil.wrapString(product.internalName) />
				var row = {};
				row['productId'] = "${product.productId}";
				row['description'] = "${description}";
				product[${product_index}] = row;
			</#list>
				function showMenu(event, billId) {
		  			var scrollTop = $(window).scrollTop();
	                var scrollLeft = $(window).scrollLeft();
	                var myMenu = "<div id='jqxMenu'><ul>" +
	                				"<li><a href='CreateInvoiceTotal?billId=" + billId + "''>${uiLabelMap.CreateInvoiceTotal}</a></li>" +
	                				"<li><a href='CreateListAttachments?billId=" + billId + "''>${uiLabelMap.CreateListAttachments}</a></li>" +
	                				"<li><a href='billOfLadingCost?party=IMPORT_ADMIN'>${uiLabelMap.Advances}</a></li>" +
	                			"<ul></div>";
	                $("#myMenuPlace").html(myMenu);
	                $("#jqxMenu").jqxMenu({ width: '220px', height: '90px', autoOpenPopup: false, mode: 'popup'});
		  			$("#jqxMenu").jqxMenu('open', parseInt(event.clientX) + 10 + scrollLeft, parseInt(event.clientY) + 2 + scrollTop);
		  			$('#jqxMenu').on('closed', function () {
		  				$('#jqxMenu').jqxMenu('destroy');
		  			});
				}
				$("#alterpopupWindow").jqxWindow({
		            width: 500, height: 270, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7
		        });
				var first = false;
				$("#jqxgrid").on("bindingComplete", function (event) {
					if (first) {
						setTimeout(function(){
							$("#jqxgrid").jqxGrid('showrowdetails', rowsExpaded);
						}, 100);
				        loadAgreementNotHasBill();
					}
					first = true;
				});
		        $("#alterCancel").jqxButton();
		        $("#alterSave").jqxButton();
		        $("#txtdepartureDate").jqxDateTimeInput();
		    	$("#txtarrivalDate").jqxDateTimeInput();
		    	$("#txtarrivalDate").jqxDateTimeInput('val', null);
		    	
		    	var checkFromDate = $('#txtdepartureDate').val();
		        var dateFRM = checkFromDate.split('/');
		        checkFromDate = new Date(dateFRM[2], dateFRM[1] - 1, dateFRM[0], 0, 0, 0, 0);
		    	$('#txtdepartureDate').on('close', function (event)
		        		{
		        		    var jsDate = event.args.date;
		        		    checkFromDate = jsDate;
		        		});
		        $('#txtarrivalDate').on('close', function (event)
		        		{
		        		    var jsDate = event.args.date;
		        		    if (checkFromDate < jsDate) {
							} else {
								$("#txtarrivalDate").jqxDateTimeInput('val', null);
							}
		        		});
			
		        $("#alterSave").click(function () {
		        	var billNumber = $('#txtBillNumber').val();
		        	if (billNumber == "") {
		        		$('#txtBillNumber').focus();
					} else {
						var row;
			            row = {
			            		billNumber: billNumber,
			            		departureDate: $('#txtdepartureDate').val().toMilliseconds(),
			            		arrivalDate: $('#txtarrivalDate').val().toMilliseconds(),
			            	  };
			    	   	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
			            $("#jqxgrid").jqxGrid('clearSelection');
			            $("#jqxgrid").jqxGrid('selectRow', 0);
			            $("#alterpopupWindow").jqxWindow('close');
					}
		        });
		        
		        
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
					function toString(myJSObject) {
				    	myJSObject = JSON.stringify(myJSObject);
				    	myJSObject = myJSObject.replaceAll('"', "'");
				    	return myJSObject;
					}
					var billIdStoreVarible = "";
					var billNumberStoreVarible = "";
					var gridStoreVarible = "";
					function AddToRow(grid, billNumber, billId) {
						billIdStoreVarible = billId;
						billNumberStoreVarible = billNumber;
						gridStoreVarible = grid;
						$("#jqxwindowPopupAdder1").jqxWindow('open');
					}
					$("#alterSaveAdder").click(function () {
			        	var rowindex = $("#jqxgridPopupAdder").jqxGrid('getselectedrowindexes');
			        	var oneTurn = true;
						for ( var r in rowindex) {
							var thisRowData = $('#jqxgridPopupAdder').jqxGrid('getrowdata', rowindex[r]);
							var thiscontainerId = thisRowData.containerId;
							var thisorderId = thisRowData.orderId;
							thisRowData.billNumber = billNumberStoreVarible;
							var obj = {orderId: thisorderId, billId: billIdStoreVarible};
							saveAgreementToBill(obj ,
												"saveAgreementToBillAjax", gridStoreVarible, thisRowData, '', false, oneTurn);
							oneTurn = false;
						}
						$("#jqxwindowPopupAdder1").jqxWindow('close');
						setTimeout(function(){
							refresh();
						}, 0);
			        });
					function bindPopup(data) {
//						$('#jqxgridPopupAdder').jqxGrid('clearSelection');
						$('#jqxgridPopupAdder').jqxGrid('clear');
						for ( var d in data) {
							data[d].agreementDate == undefined?data[d].agreementDate = null : data[d].agreementDate = data[d].agreementDate['time'];
							data[d].departureDate == undefined?data[d].departureDate = null : data[d].departureDate = data[d].departureDate['time'];
							data[d].arrivalDate == undefined?data[d].arrivalDate = null : data[d].arrivalDate = data[d].arrivalDate['time'];
						}
						var recordPopupDataSource = { 
											localdata: data,
											id : 'agreementId',
											datafields: [	
						                  					{ name: 'agreementId', type: 'string' },
						                  					{ name: 'orderId', type: 'string'},
						                  					{ name: 'agreementDate', type: 'date', other: 'Timestamp'},
						                  					{ name: 'shippingLineId', type: 'string'},
						                  					{ name: 'partyIdFrom', type: 'string'},
						                  					{ name: 'billNumber', type: 'string'},
						                  					{ name: 'billId', type: 'string'},
						                  					{ name: 'containerId', type: 'string'},
						                  					{ name: 'containerNumber', type: 'string'},
						                  					{ name: 'departureDate', type: 'date', other: 'Timestamp'},
						                  					{ name: 'arrivalDate', type: 'date', other: 'Timestamp'},
						                  					{ name: 'partyRentId', type: 'string'},
						                  					{ name: 'statusId', type: 'string'},
						                           		]
						                           }
						var PopupAdderGridAdapter = new $.jqx.dataAdapter(recordPopupDataSource);
						$("#jqxgridPopupAdder").jqxGrid({
			                 source: PopupAdderGridAdapter,
			                 showfilterrow: true,
			 		 		 filterable: true,
			 		 		 handlekeyboardnavigation: function (event) {
			                    var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;
			                    $('body').css('overflow', 'hidden');
			                    if (key == 70 && event.ctrlKey) {
			                    	$('#clearfilteringPopupAdder').click();
			                    	return true;
			                    }    
			 		 		 }
			             });
					}
					var rowsExpaded;
					function refresh() {
						$('#clearfilteringbuttonjqxgrid').click();
					}
					function loadAgreementNotHasBill() {
						var agreementNotHasBill = [];
						jQuery.ajax({
					        url: "loadAgreementNotHasBillAjax",
					        type: "POST",
					        async: true,
					        data: {},
					        dataType: 'json',
					        success: function(res) {
					        	agreementNotHasBill = res["agreementNotHasBill"];
					        }
					    }).done(function() {
					    	bindPopup(agreementNotHasBill);
						});
					}
					$( "#clearfilteringPopupAdder" ).click(function() {
						$('#jqxgridPopupAdder').jqxGrid('clearfilters');
					});
					$("#jqxwindowPopupAdder1").jqxWindow({
			            width: 880, maxWidth: 1845, minHeight: 420, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancelAdder"), modalOpacity: 0.7
			        });
					$('#jqxwindowPopupAdder1').on('close', function (event) {
						
					}); 
					$("#alterCancelAdder").jqxButton();
			        $("#alterSaveAdder").jqxButton();
			        function saveAgreementToBill(data, url, grid, thisRowData, rowId, isDelete, oneTurn) {
			        	var saveSuccess = true;
			        	jQuery.ajax({
					        url: url,
					        type: "POST",
					        async: false,
					        data: data,
					        dataType: 'json',
					        success: function(res) {
					        	res["_ERROR_MESSAGE_"] == undefined?saveSuccess=true:saveSuccess=false;
					        }
					    }).done(function() {
					    	if (saveSuccess) {
					    		if (oneTurn) {
					    			$("#notificationContentAdder").html('${StringUtil.wrapString(uiLabelMap.DAUpdateSuccessful)}');
					                $("#jqxNotificationPopupAdder").jqxNotification("open");
								}
					    		return true;
				                if (isDelete) {
				                	$('#' + grid).jqxGrid('deleterow', rowId);
								} else {
									$('#' + grid).jqxGrid('addrow', null, thisRowData);
								}
							}else {
								$("#jqxNotificationPopupAdder").jqxNotification({template: 'error'});
					        	$("#notificationContentAdder").html('${StringUtil.wrapString(uiLabelMap.DAUpdateError)}');
				                $("#jqxNotificationPopupAdder").jqxNotification("open");
							}
						});
					}
			        $("#jqxNotificationPopupAdder").jqxNotification({ width: "100%", appendContainer: "#container", opacity: 0.9, autoClose: true, template: 'info'});
			        $("#jqxNotificationOrderViewer").jqxNotification({ width: "100%", appendContainer: "#containerOrderViewer", opacity: 0.9, autoClose: true, template: 'info'});
					$("#jqxgridPopupAdder").jqxGrid({
		                source: null, 
		                width: 870, 
		                height: 312,
		                selectionmode: 'checkbox',
				 		theme: 'olbius',
				 		pageable: true,
				 		pagesize: 9,
				 		sortable: true,
				 		editable: false,
		                columns: [
									{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', width: '150px', filtertype: 'input'},
									{ text: '${uiLabelMap.OrderOrderId}', datafield: 'orderId', width: '150px', filtertype: 'input'},
									{ text: '${uiLabelMap.AgreementDate}', datafield: 'agreementDate', columntype: 'datetimeinput',width: '200px', filtertype: 'range', cellsformat: 'dd/MM/yyyy'},
									{ text: '${uiLabelMap.shippingLineId}', datafield: 'shippingLineId', width: '190px', 
										createeditor: function (row, column, editor) {
									},
										cellsrenderer: function(){
											return 'HYUNDAI_COMPANY';
										},
									},
									{ text: '${uiLabelMap.Status}', datafield: 'statusId', columntype: 'dropdownlist', filtertype: 'checkedlist', cellsrenderer:
										function(row, colum, value){
										var data = $("#jqxgridPopupAdder").jqxGrid('getrowdata', row);
										var statusId = data.statusId;
										var status = getStatus(statusId);
										return '<span>' + status + '</span>';
										},createfilterwidget: function (column, htmlElement, editor) {
					    		        	editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(statusList), displayMember: 'statusId', valueMember: 'statusId' ,
					                            renderer: function (index, label, value) {
					                            	if (index == 0) {
					                            		return value;
													}
												    return getStatus(value);
								                } });
					    		        	editor.jqxDropDownList('checkAll');
					                    }}
		                ]
		            });
					function DeleteThisRow(gridId, billId) {
						var indexSelected = $('#' + gridId).jqxGrid('getselectedrowindex');
						var rowId = $('#' + gridId).jqxGrid('getrowid', indexSelected);
						if (indexSelected < 0) {
							$("#" + gridId.replaceAll("jqxgridDetail", "contentjqxgridDetail")).notify("${StringUtil.wrapString(uiLabelMap.SelectAgreementToDelete)}", {className: 'info', elementPosition: 'top right'});
							return false;
						}
						var thisRowData = $('#' + gridId).jqxGrid('getrowdata', indexSelected);
						var obj = {orderId: thisRowData.orderId, billId: billId};
						saveAgreementToBill(obj ,
								"deleteAgreementFromBillAjax", gridId, thisRowData, rowId, true, true);
						setTimeout(function(){
							refresh();
						}, 0);
					}
					function prepareEventDbClick(gridId) {
						$("#" + gridId).on("celldoubleclick", function (event)
								{
								    var args = event.args;
								    var dataField = args.datafield;
								    if (dataField == 'orderId') {
								    	 var value = args.value;
								    	 setTimeout(function(){
								    		 getListOrderItems(value);
								    	 }, 0);
								    	 $("#jqxwindowOrderViewer").jqxWindow('open');
									}
						});
					}
					function getListOrderItems(orderId) {
						var listOrderItems = [];
						jQuery.ajax({
					        url: "getListOrderItemsAjax",
					        type: "POST",
					        async: true,
					        data: {orderId: orderId},
					        dataType: 'json',
					        success: function(res) {
					        	listOrderItems = res["listOrderItems"];
					        }
					    }).done(function() {
					    	bindOrderItemsPopup(listOrderItems);
						});
					}
					
					function bindOrderItemsPopup(listOrderItems) {
						$('#jqxgridOrderViewer').jqxGrid('clear');
						for ( var d in listOrderItems) {
							listOrderItems[d].datetimeManufactured == undefined?listOrderItems[d].datetimeManufactured = null : listOrderItems[d].datetimeManufactured = listOrderItems[d].datetimeManufactured['time'];
							listOrderItems[d].expireDate == undefined?listOrderItems[d].expireDate = null : listOrderItems[d].expireDate = listOrderItems[d].expireDate['time'];
						}
						var orderssource = { datafields: [
						                              	 { name: 'orderId', type:'string' },
						                                  { name: 'orderItemSeqId', type: 'string' },
						                                  { name: 'productId', type: 'string' },
						                                  { name: 'quantity', type: 'string' },
						                                  { name: 'datetimeManufactured', type: 'date', other: 'Timestamp'},
						                                  { name: 'expireDate', type: 'date', other: 'Timestamp'},
						                                 	 
						                              ],
						                                
	                          localdata: listOrderItems,
	                          updaterow: function (rowid, newdata, commit) {
	                         	 commit(true);
	                         	 var orderId = newdata.orderId;
	                         	 var orderItemSeqId = newdata.orderItemSeqId;
	                         	 var quantity = newdata.quantity;
	                         	 var productId = newdata.productId;
	                         	 var datetimeManufacturedStr = newdata.datetimeManufactured;
	                         	 var datetimeManufactured = new Date(datetimeManufacturedStr);
	                         	 var expireDateStr = newdata.expireDate;
	                         	 var expireDate = new Date(expireDateStr);
	                         	 if(typeof expireDateStr != 'undefined' || typeof datetimeManufacturedStr != 'undefined'){
	                         		 $.ajax({
	                                      type: "POST",                        
	                                      url: 'updateOrderItemWhenReceiveDoc',
	                                      data: {orderId: orderId, orderItemSeqId: orderItemSeqId, quantity: quantity, productId: productId, datetimeManufactured: datetimeManufactured.getTime(), expireDate: expireDate.getTime()},
	                                      success: function (data, status, xhr) {
	                                          if(data.responseMessage == "error")
	                                          {
	                                          	commit(false);
	                                          	$("#jqxNotificationOrderViewer").jqxNotification({ template: 'error'});
	                                          	$("#notificationOrderViewer").text(data.errorMessage);
	                                          	$("#jqxNotificationOrderViewer").jqxNotification("open");
	                                      			if(orderItemSeqId == null){
	                                      				$("#jqxgridOrderViewer").jqxGrid('setcellvaluebyid', rowid, 'orderItemSeqId', 'error');
	                                      			}
	                                          }else{
	                                          	commit(true);
	                                          	$("#container").empty();
	                                          	$("#jqxNotificationOrderViewer").jqxNotification({ template: 'info'});
	                                          	$("#notificationOrderViewer").text("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
	                                          	$("#jqxNotificationOrderViewer").jqxNotification("open");
	             	                 			 if(orderItemSeqId == null){
	             	                 				$("#jqxgridOrderViewer").jqxGrid('setcellvaluebyid', rowid, 'orderItemSeqId', data.orderItemSeqId);
	             	                        	 }
	                                          }
	                                      },
	                                      error: function () {
	                                          commit(false);
	                                      }
	                                  });
	                         	 }
	                         	}
	                      }
	                      var OrderViewerGridAdapter = new $.jqx.dataAdapter(orderssource);
	                      $("#jqxgridOrderViewer").jqxGrid({
				                 source: OrderViewerGridAdapter,
				                 showfilterrow: true,
				 		 		 filterable: true,
				 		 		 handlekeyboardnavigation: function (event) {
				                    var key = event.charCode ? event.charCode : event.keyCode ? event.keyCode : 0;
				                    $('body').css('overflow', 'hidden');
				                    if (key == 70 && event.ctrlKey) {
				                    	$('#clearfilteringOrderViewer').click();
				                    	return true;
				                    }    
				 		 		 }
				             });
					}
					$("#jqxwindowOrderViewer").jqxWindow({theme: 'olbius',
			            width: 920, maxWidth: 1845, minHeight: 420, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancelOrderViewer"), modalOpacity: 0.7
			        });
					$("#alterCancelOrderViewer").jqxButton();
			        $( "#clearfilteringOrderViewer" ).click(function() {
						$('#jqxgridOrderViewer').jqxGrid('clearfilters');
			        });
			        $('#jqxgridOrderViewer').jqxGrid({
		                 source: new Array(),
		                 width: '100%',
		                 height: 312,
		                 showtoolbar:false,
				 		 editable: true,
				 		 editmode:"selectedrow",
				 		 showheader: true,
				 		 selectionmode:"singlerow",
				 		theme: 'olbius',
				 		pageable: true,
				 		pagesize: 9,
		                 columns: [
		                   { text: "${uiLabelMap.OrderOrderId}", datafield: "orderId", editable: false, width: 140},
		                   { text: "${uiLabelMap.ProductName}", datafield: "productId", columntype:"dropdownlist", editable: true, minwidth: 200, cellsrenderer:
		     			       function(row, colum, value){
		    			        var data = $('#jqxgridOrderViewer').jqxGrid('getrowdata', row);
		    			        var productId = data.productId;
		    			        var product = getProductName(productId);
		    			        return '<span>' + product + '</span>';
		    		        }},
		                   { text: "${uiLabelMap.OrderQuantity}", datafield: "quantity", editable: true, width: 150, cellsalign: 'right'},
		                   { text: "${uiLabelMap.dateOfManufacture}", datafield: "datetimeManufactured", columntype: "datetimeinput", filtertype: 'range', width: "190", editable: true, cellsformat: 'dd/MM/yyyy',
		                	   validation: function (cell, value) {
		                		   lastTimeChoice = value;
		                		   var thisRow = cell.row;
		                		   var data = $('#jqxgridOrderViewer').jqxGrid('getrowdata', thisRow);
		            		       var expireDate = data.expireDate;
		            		       if (expireDate == null) {
		            		    	   return true;
		            		       }
		                           if (expireDate < value) {
		                        	   $("#inputdatetimeeditorjqxgridOrderViewerexpireDate").val('');
		                            }
		                	       return true;
		                	    }},
		                   { text: "${uiLabelMap.ProductExpireDate}", datafield: "expireDate", columntype: "datetimeinput", filtertype: 'range', width: "190", editable: true, cellsformat: 'dd/MM/yyyy',
		                	   validation: function (cell, value) {
		                		   if (lastTimeChoice == null) {
		                			   return { result: false, message: '${uiLabelMap.ChoicedatetimeManufacturedFirst}' };
		                		   }
		                		   var thisRow = cell.row;
		                		   var data = $('#jqxgridOrderViewer').jqxGrid('getrowdata', thisRow);
		            		       var datetimeManufactured = 0;
		            		       lastTimeChoice==0?datetimeManufactured=data.datetimeManufactured:datetimeManufactured=lastTimeChoice;
		                           if (datetimeManufactured > value) {
		                        	   return { result: false, message: '${uiLabelMap.DateExpirecannotbeforeDateManufactured}' };
		                            }
		                	       return executeQualityPublication(data, value);
		                	    },
		                   }
		                ]
		             });
			        var lastTimeChoice = 0;
			        function executeQualityPublication(data, value) {
			    		var productId = data.productId;
			    		var datetimeManufactured = 0;
			    		lastTimeChoice==0?datetimeManufactured=data.datetimeManufactured:datetimeManufactured=lastTimeChoice;
			    		var expireDate = value;
			    		var validateDate = expireDate.getTime() - datetimeManufactured.getTime();
			    		validateDate = Math.ceil(validateDate/86400000);
			    		var qualityPublication = [];
			    		qualityPublication = hasQualityPublication(productId);
			    		if (qualityPublication == "null") {
			    			var header = "Tao cong bo chat luong cho " + getProductName(productId) + " [" + productId + "]";
			    			var message = "<h4>${uiLabelMap.QualityPublicationNotFound} <b>" + getProductName(productId) + " [<i>" + productId + "</i>]</b> ${uiLabelMap.confirmQAInsertQualityPublication}</h4>";
			    			confirmInsertQualityPublication(productId, message, header, "");
			    		}else {
			    			var thruDate = qualityPublication.thruDate;
			    			var timeNow = new Date();
			    			thruDate = thruDate.time;
			    			timeNow = timeNow.getTime();
			    			var leftTime = thruDate - timeNow;
			    			leftTime = Math.ceil(leftTime/86400000);
			    			if (0 < leftTime && leftTime < 10) {
			    					var header = "Cong bo chat luong san pham " + getProductName(productId) + " [" + productId + "] sap het han";
			    					var message = "<h4>${uiLabelMap.QualityPublicationPreExpire} <b>" + getProductName(productId) + " [<i>" + productId + "</i>]</b> ${uiLabelMap.confirmQualityPublicationPreExpire}</h4>";
			    					confirmInsertQualityPublication(productId, message, header, "");
			    			} 
			    			if(leftTime < 0){
			    				var header = "Cong bo chat luong san pham " + getProductName(productId) + " [" + productId + "] da het han";
			    				var message = "<h4>${uiLabelMap.QualityPublicationPreExpire} <b>" + getProductName(productId) + " [<i>" + productId + "</i>]</b> ${uiLabelMap.confirmQualityPublicationExpire}</h4>";
			    				confirmInsertQualityPublication(productId, message, header, "");
			    			}
			    			var expireDateProduct = qualityPublication.expireDate;
			    			if (validateDate != expireDateProduct) {
			    				var header = "Cong bo chat luong san pham " + getProductName(productId) + " [" + productId + "] co thay doi";
			    				var message = "<h4>${uiLabelMap.QualityPublicationNotFound} <b>" + getProductName(productId) + " [<i>" + productId + "</i>]</b> ${uiLabelMap.hasChangeProductShelfLife}</h4>";
			    				confirmInsertQualityPublication(productId, message, header, validateDate);
			    			}
			    		}
			    		lastTimeChoice = 0;
			    		return true;
			    	}
			        function getProductName(productId) {
			    		if (productId != null) {
			    			for ( var x in product) {
			    				if (productId == product[x].productId) {
			    					return product[x].description;
			    				}
			    			}
			    		} else {
			    			return "";
			    		}
			    	}
			        function confirmInsertQualityPublication(productId, message, header, expireDateProduct) {
			    		var wd = "";
			        	wd += "<div id='window01'><div>${uiLabelMap.AgreementScanFile}</div><div>";
			        	wd += message;
			        	wd += "<div class='row-fluid'>" +
			    			"<div class='span12 no-left-margin'>" +
			    				"<div class='span4'></div>" +
			    				"<div class='span8'><input style='margin-right: 5px;' type='button' id='alterSave5' value='${uiLabelMap.SentNotify}' /><input id='alterCancel5' type='button' value='${uiLabelMap.CommonCancel}' /></div>" +
			    			"</div>";
			        	wd += "</div></div>";
			        	$("#myImage").html(wd);
			        	$("#alterCancel5").jqxButton();
			            $("#alterSave5").jqxButton();
			            $("#alterCancel5").click(function () {
			           	 	$('#window01').jqxWindow('close');
//			           	 	$("#myImage").html();
			            });
			            $("#alterSave5").click(function () {
			            	createQuotaNotification(productId, "qaadmin", header, expireDateProduct);
			            	$('#window01').jqxWindow('close');
//			            	$("#myImage").html();
			            });
			           
			        	$('#window01').jqxWindow({ height: 160, width: 700, maxWidth: 1200, isModal: true, modalOpacity: 0.7 });
			        	$('#window01').on('close', function (event) {
			            	 $('#window01').jqxWindow('destroy');
//			            	 $("#myImage").html();
			             });
			    	}
			    	function createQuotaNotification(productId, partyId, messages, expireDateProduct) {
			    			var targetLink = "productId=" + productId + ";expireDateProduct=" + expireDateProduct;
			    			if (expireDateProduct == "") {
			    				targetLink = "productId=" + productId;
			    			}
			    			var action = "CreateProductQuality";
			    			var header = messages;
			    			var d = new Date();
			    			var newDate = d.getTime() - (0*86400000);
			    			var dateNotify = new Date(newDate);
			    			var getFullYear = dateNotify.getFullYear();
			    			var getDate = dateNotify.getDate();
			    			var getMonth = dateNotify.getMonth() + 1;
			    			dateNotify = getFullYear + "-" + getMonth + "-" + getDate;
			    			var jsonObject = {partyId: partyId,
			    								header: header,
			    								openTime: dateNotify,
			    								action: action,
			    								targetLink: targetLink,};
			    			jQuery.ajax({
			    		        url: "createQuotaNotification",
			    		        type: "POST",
			    		        data: jsonObject,
			    		        success: function(res) {
			    		        	
			    		        }
			    		    }).done(function() {
			    		    	
			    			});
			    		}
			    	function hasQualityPublication(productId) {
			    		var result = "null";
			    		if (productId != null) {
			    			for ( var x in listProductShelfLife) {
			    				if (productId == listProductShelfLife[x].productId) {
			    					result = listProductShelfLife[x];
			    					return result;
			    				}
			    			}
			    		} else {
			    			result = "productIdnull";
			    		}
			    		return result;
			    	}
			    	var listProductShelfLife = [];
			    	function getProductShelfLife() {
			    		$.ajax({
			                url: "getProductShelfLifeAjax",
			                type: "POST",
			                data: {},
			                success: function(res) {
			                	listProductShelfLife = res["listProductShelfLife"];
			                }
			            }).done(function() {
			            	
			            });
			    	}
			    	$(document).ready(function(){
			        	$("#jqxNotificationNested").jqxNotification({ width: "1358px", appendContainer: "#container", opacity: 0.9, autoClose: false, template: "info" });
			        	getProductShelfLife();
			    	});
			</script>
			<style>
			</style><div id="myImage"></div>