<#assign prHeaderId2 = parameters.productPlanHeader2 !>
<#if prHeaderId2?exists>
<script>
	<#assign quantityUomList = delegator.findList("Uom", null, null, null, null, false) />
	var quData = new Array();
	<#list quantityUomList as itemUom >
		var row = {};
		row['quantityUomId'] = '${itemUom.uomId?if_exists}';
		row['weightUomId'] = '${itemUom.uomId?if_exists}';
		row['description'] = '${itemUom.description?if_exists}';
		quData[${itemUom_index}] = row;
	</#list>
	
	<#assign facilityList = delegator.findList("Facility", null, null, null, null, false) />
	var fData = new Array();
	<#list facilityList as itemFac >
		var row = {};
		row['facilityId'] = '${itemFac.facilityId?if_exists}';
		row['facilityName'] = '${itemFac.facilityName?if_exists}';
		fData[${itemFac_index}] = row;
	</#list>
	
	<#assign productTypeList = delegator.findList("ProductType", null, null, null, null, false) />
	var productTypeData = new Array();
	<#list productTypeList as productType>
		<#assign description = StringUtil.wrapString(productType.description) />
		var row = {};
		row['description'] = "${description}";
		row['productTypeId'] = '${productType.productTypeId}';
		productTypeData[${productType_index}] = row;
	</#list>
	var product = new Array();
	<#if listProducts?exists>
		<#list listProducts as product>
			<#assign description = StringUtil.wrapString(product.internalName) />
			var row = {};
			row['productId'] = "${product.productId}";
			row['description'] = "${description}";
			product[${product_index}] = row;
		</#list>
	</#if>
	var listStatus1 = new Array();
	<#list listStatus as stt>
		<#assign description = StringUtil.wrapString(stt.description) />
		var row = {};
		row['statusId'] = "${stt.statusId}";
		row['description'] = "${stt.description}";
		listStatus1[${stt_index}] = row;
	</#list>
	$(document).ready(function(){
		//console.log(listStatus1);
    	$("#jqxNotificationNested").jqxNotification({ width: "1358px", appendContainer: "#container", opacity: 0.9, autoClose: false, template: "info" });
	});
	
</script>

<#assign initrowdetailsDetail = "function (index, parentElement, gridElement, datarecord) {
	 	var ordersDataAdapter = new $.jqx.dataAdapter(datarecord.rowDetail, { autoBind: true });
        orders = ordersDataAdapter.records;
		
		 var nestedGrids = new Array();
         var id = datarecord.uid.toString();
        
         var grid = $($(parentElement).children()[0]);
         $(grid).attr(\"id\",\"jqxgridDetail\");
         nestedGrids[index] = grid;
       
         var ordersbyid = [];
        
        
         for (var m = 0; m < orders.length; m++) {
            
                 ordersbyid.push(orders[m]);
         }
         var orderssource = { datafields: [
         	 { name: \'orderId\', type:\'string\' },
             { name: \'orderItemSeqId\', type: \'string\' },
             { name: \'productId\', type: \'string\' },
             { name: \'quantity\', type: \'number\' },
             { name: \'datetimeManufactured\', type: \'string\' },
             { name: \'expireDate\', type: \'string\' },
            	 
         ],
           
             localdata: ordersbyid,
             updaterow: function (rowid, newdata, commit) {
// alert(newdata.datetimeManufactured);
            	 commit(true);
            	 var orderId = newdata.orderId;
            	 var orderItemSeqId = newdata.orderItemSeqId;
            	 var quantity = newdata.quantity;
            	 var productId = newdata.productId;
            	 var datetimeManufacturedStr = newdata.datetimeManufactured;
            	 var datetimeManufactured = new Date(datetimeManufacturedStr);
            	 var expireDateStr = newdata.expireDate;
            	 var expireDate = new Date(expireDateStr);
            	 console.log(expireDate.getTime());
            	 if(typeof expireDateStr != 'undefined' || typeof datetimeManufacturedStr != 'undefined'){
            		 $.ajax({
                         type: \"POST\",                        
                         url: 'updateOrderItemWhenReceiveDoc',
                         data: {orderId: orderId, orderItemSeqId: orderItemSeqId, quantity: quantity, productId: productId, datetimeManufactured: datetimeManufactured.getTime(), expireDate: expireDate.getTime()},
                         success: function (data, status, xhr) {
                             // update command is executed.
                             if(data.responseMessage == \"error\"){
                             	commit(false);
                             	$(\"#jqxNotification\").jqxNotification({ template: 'info'});
                             	$(\"#jqxNotification\").text(data.errorMessage);
                             	$(\"#jqxNotification\").jqxNotification(\"open\");
                             	if(orderItemSeqId == null){
	                        		 grid.jqxGrid('setcellvaluebyid', rowid, 'orderItemSeqId', 'error');
	                        	 }
                             }else{
                             	commit(true);
//                             	grid.jqxGrid('updatebounddata');
                             	$(\"#container\").empty();
                             	$(\"#notificationContent\").jqxNotification({ template: 'info'});
                             	$(\"#notificationContent\").text(\"${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}\");
                             	$(\"#notificationContent\").jqxNotification(\"open\");
                             	if(orderItemSeqId == null){
	                        		 grid.jqxGrid('setcellvaluebyid', rowid, 'orderItemSeqId', data.orderItemSeqId);
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
         var nestedGridAdapter = new $.jqx.dataAdapter(orderssource);
        
         if (grid != null) {
        	 var a ;
             grid.jqxGrid({
                 source: nestedGridAdapter, width: '95%', height: 200,
                 showtoolbar:false,
		 		 editable: true,
		 		 editmode:\'selectedrow\',
		 		 showheader: true,
		 		 selectionmode:\'singlerow\',
		 		 theme: 'energyblue',
                 columns: [
                   { text: \'${uiLabelMap.OrderOrderId}\', datafield: \'orderId\', editable: false, hidden: true},
                   { text: \'orderItemSeqId\', datafield: \'orderItemSeqId\', editable: false, hidden: true},
                   { text: \'${uiLabelMap.ProductName}\', datafield: \'productId\', columntype:\'dropdownlist\', editable: true,
                	   initeditor: function (row, cellvalue, editor, celltext, pressedChar) {
                	   var data = grid.jqxGrid('getrowdata', row);
                	   var selectedIndex = 0;
                	   for(var j = 0; j < product.length; j++){
                		   if(product[j].productId == data.productId){
                			   selectedIndex = j;
                			   break;
                		   }
                	   }
//                	   console.log(selectedIndex);
                	   var sourcePro = {
                			   localdata: product,
                			   datatype: \'array\'
                	   };
                	   var dataAdapterPro = new $.jqx.dataAdapter(sourcePro);
			            editor.jqxDropDownList({source: dataAdapterPro, selectedIndex: selectedIndex, displayMember:\"productId\", valueMember: \"productId\",
                           renderer: function (index, label, value) {
			                    var datarecord = product[index];
			                    return datarecord.description;
			                } ,
                       });
			            var aa = editor.jqxDropDownList('selectIndex', selectedIndex);
			            editor.on('open', function (event) {
// editor.jqxDropDownList('selectIndex', selectedIndex);
			            	aa;
                	   	});
                	},

                	cellsrenderer: function (row, columnfield, value, defaulthtml, columnproperties) {
                		var vlreturn = value;
                		for(var i = 0; i < product.length; i++){
                    	   var pro = product[i];
                    	   if(value == pro.productId){
                    		   vlreturn = pro.description;
                    	   }
                       }
// console.log(vlreturn);
                		return vlreturn;
                    },
                   },
                   { text: \'${uiLabelMap.OrderQuantity}\', datafield: \'quantity\',editable: true, width: 100, columntype: \'numberinput\', cellsalign :'right' },
                   { text: \'${uiLabelMap.dateOfManufacture}\', datafield: \'datetimeManufactured\', columntype: \'datetimeinput\',width: \'150px\', editable: true,cellsformat: \'dd-MM-yyyy\',
                	   validation: function (cell, value) {
               	        if (typeof value == null) {
               	            return { result: false, message: \"not have date\" };
               	        }
               	        return true;
               	    },   
                   },
                   { text: \'${uiLabelMap.ProductExpireDate}\', datafield: \'expireDate\', columntype: \'datetimeinput\',width: \'150px\', editable: true,cellsformat: \'dd-MM-yyyy\',
                	   validation: function (cell, value) {
                	        if (typeof value == null) {
                	            return { result: false, message: \"not have date\" };
                	        }else{return true;}
                	    },
                   },
                   { text: \'${uiLabelMap.CommonAdd}\', width: 50,columntype: \'button\', editable: false,
                	   cellsrenderer: function(){
                		return 'add';
                	   }, buttonclick: function(row){
                		   
                		   var dataRecordOfRow = grid.jqxGrid('getrowdata', row);
                		   
                		   var row1 = {orderId: dataRecordOfRow.orderId, productId: dataRecordOfRow.productId, datetimeManufactured: dataRecordOfRow.datetimeManufactured, expireDate: dataRecordOfRow.expireDate}; 
                		   grid.jqxGrid('addrow', null, row1, 'first');
                		   grid.jqxGrid('clearSelection');
                		   grid.jqxGrid('selectRow',0);
                  		   grid.jqxGrid('beginrowedit', 0);
// grid.jqxGrid('beginrowedit', 0, 'productId');
                		   grid.jqxGrid('begincelledit', 0, 'datetimeManufactured');
// alert();
                	   }
                   
                   },
                   { text: \'${uiLabelMap.CommonDelete}\', width: 50,columntype: \'button\', editable: false,
                	   cellsrenderer: function(row, column, value){
                		return 'delete';
                	   }, buttonclick: function(row){
// var rowdata = {orderId: '', orderItemSeqId: '', };
// grid.jqxGrid('addrow', null, {}, 'first');
// grid.jqxGrid('clearSelection');
// grid.jqxGrid('selectRow',0);
// grid.jqxGrid('begincelledit', 1, 'productId');
                		  var idrow = grid.jqxGrid('getrowid', row);
// var value = grid.jqxGrid('deleterow', idrow);
                		  var datarecord1 = grid.jqxGrid('getrowdata', row);
                		  alert(datarecord1.datetimeManufactured);
// var pro = datarecord.datetimeManufactured;
// alert(pro);
                		   
// alert();
                	   }
                   
                   },
                ]
             });
            
         }
         
 }"/>


<#assign dataField="[{ name: 'agreementId', type: 'string' },
					 { name: 'orderId', type: 'string'},
					 { name: 'agreementDate', type: 'string'},
					 { name: 'shippingLineId', type: 'string'},
					 { name: 'partyIdFrom', type: 'string'},
					 { name: 'billNumber', type: 'string'},
					 { name: 'billId', type: 'string'},
					 { name: 'containerId', type: 'string'},
					 { name: 'containerNumber', type: 'string'},
					 { name: 'departureDate', type: 'string'},
					 { name: 'arrivalDate', type: 'string'},
					 { name: 'partyRentId', type: 'string'},
					 { name: 'statusId', type: 'string'},
					 { name: 'rowDetail', type: 'string'},
					 ]"/>
<#--{ name: 'facilityId', type: 'string'}, { name: 'quantityOnHandTotal', type: 'string'},-->
<#assign columnlist="					 
						{ text: '${uiLabelMap.AgreementId}', datafield: 'agreementId', editable: false},
						{ text: '${uiLabelMap.OrderOrderId}', datafield: 'orderId', width: '100px', editable: false, hidden: true},
						{ text: '${uiLabelMap.AgreementDate}', datafield: 'agreementDate', columntype: 'datetimeinput',width: '110px', editable: false,cellsformat: 'd'},
						{ text: '${uiLabelMap.shippingLineId}', datafield: 'shippingLineId', width: '150px', editable: false, 
							createeditor: function (row, column, editor) {
                            // assign a new data source to the dropdownlist.
// var list = ['Germany', 'Brazil', 'France'];
// editor.jqxDropDownList({ autoDropDownHeight: true, source: list });
                        },
                        	cellsrenderer: function(){
                        		return 'HYUNDAI_COMPANY';
                        	},
                        // update the editor's value before saving it.
                        
						},
						{ text: '${uiLabelMap.billNumber}', datafield: 'billNumber', width: '100px', editable: true},
						{ text: '${uiLabelMap.containerNumber}', datafield: 'containerNumber', editable: true, width: '100px'},
						{ text: '${uiLabelMap.departureDate}', datafield: 'departureDate', editable: true, columntype: 'datetimeinput', width: '100px', cellsformat: 'd'},
						{ text: '${uiLabelMap.arrivalDate}', datafield: 'arrivalDate', editable: true,  columntype: 'datetimeinput', width: '100px', cellsformat: 'd'},
						{ text: '${uiLabelMap.Status}', datafield: 'statusId', columntype: 'dropdownlist', editable: true, width: '120px',
							initeditor: function (row, cellvalue, editor, celltext, pressedChar) {
			                	   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			                	   var selectedIndex = 0;
			                	   for(var j = 0; j < listStatus1.length; j++){
			                		   if(listStatus1[j].statusId == data.statusId){
			                			   selectedIndex = j;
			                			   break;
			                		   }
			                	   }
//			                	   console.log(selectedIndex);
			                	   var sourcePro = {
			                			   localdata: listStatus1,
			                			   datatype: \'array\'
			                	   };
			                	   var dataAdapterPro = new $.jqx.dataAdapter(sourcePro);
						            editor.jqxDropDownList({source: dataAdapterPro, selectedIndex: selectedIndex, displayMember:\"statusId\", valueMember: \"statusId\",
			                           renderer: function (index, label, value) {
						                    var datarecord = listStatus1[index];
						                    return datarecord.description;
						                } ,
			                       });
						            var aa = editor.jqxDropDownList('selectIndex', selectedIndex);
						            editor.on('open', function (event) {
			// editor.jqxDropDownList('selectIndex', selectedIndex);
						            	aa;
			                	   	});
			                	},
			                	cellsrenderer: function (row, columnfield, value, defaulthtml, columnproperties) {
			                		var vlreturn = value;
			                		for(var i = 0; i < listStatus1.length; i++){
			                    	   var stts = listStatus1[i];
			                    	   if(value == stts.statusId){
			                    		   vlreturn = stts.description;
			                    	   }
			                       }
			// console.log(vlreturn);
			                		return vlreturn;
			                    }
						}
					 "/>
<@jqGrid filtersimplemode="false" addType="popup" initrowdetails = "true" dataField=dataField bindresize="false" width = "1050"
			initrowdetailsDetail=initrowdetailsDetail editmode="selectedrow" editable="true" columnlist=columnlist clearfilteringbutton="false" showtoolbar="true" addrow="false" deleterow="true"
		 	url="jqxGeneralServicer?prHeaderId=${prHeaderId2}&sname=JQGetAgreementFollowTime" showtoolbar="false"
		 	removeUrl="jqxGeneralServicer?sname=removeOrderItem&jqaction=D" deleteColumn="orderId;" viewSize="10"
		 	updateUrl="jqxGeneralServicer?sname=updateAgreemenReceive&jqaction=U" editColumns="agreementId;partyRentId;containerId;billId;orderId;agreementDate;shippingLineId;partyIdFrom;billNumber;containerNumber;arrivalDate(java.sql.Timestamp);departureDate(java.sql.Timestamp);statusId;"
		 />
</#if>