	<script>
		<#assign productPriceType = delegator.findList("ProductPriceType", null, null, null, null, false) />
		var pptData = new Array();
		<#if productPriceType?exists>
			<#list productPriceType as item>
				var row = {};
				<#assign description = StringUtil.wrapString(item.description) />
				row['productPriceTypeId'] = '${item.productPriceTypeId?if_exists}';
				row['description'] = "${description}";
				pptData[${item_index}] = row;
			</#list>
		</#if>
		function getProductPriceType(productPriceTypeId) {
			for ( var x in pptData) {
				if (productPriceTypeId == pptData[x].productPriceTypeId) {
					return pptData[x].description;
				}
			}
		}
		$(document).ready(function() {
			var mytab = "<li><span class='divider'><i class='icon-angle-right'></i></span>${uiLabelMap.ListProductPrice}</li>";
			$(".breadcrumb").append(mytab);
		})
		
		function getDateTimeStamp(fromDate) {
			if (fromDate != null) {
				fromDate =  new Date(fromDate);
				var date = fromDate.getDate();
				if (date < 10) {
					date = "0" + date;
				}
		        var month = fromDate.getMonth() + 1;
		        if (month < 10) {
		        	month = "0" + month;
				}
		        var year = fromDate.getFullYear();
		        var fullYear = date + '/' + month + '/' + year;
		        return fullYear;
			} else {
				 return "";
			}
		}
	</script>
	<#assign productId = parameters.productId/>
	<#assign dataField="[{ name: 'productId', type: 'string'},
						   { name: 'productPriceTypeId', type: 'string'},
						   { name: 'productPricePurposeId', type: 'string'},
						   { name: 'currencyUomId', type: 'string'},
						   { name: 'productStoreGroupId', type: 'string'},
						   { name: 'fromDate', type: 'string', other: 'Timestamp'},
						   { name: 'thruDate', type: 'string', other: 'Timestamp'},
						   { name: 'price', type: 'number'},
						   { name: 'termUomId', type: 'string'},
						   { name: 'priceWithoutTax', type: 'number'},
						   { name: 'priceWithTax', type: 'number'},
						   { name: 'taxAmount', type: 'number'},
						   { name: 'createdDate', type: 'string'},
						   { name: 'createdByUserLogin', type: 'string'},
						   { name: 'lastModifiedDate', type: 'date'},
						   { name: 'lastModifiedByUserLogin', type: 'string'},
						   { name: 'taxAuthPartyId', type: 'string'},
						   { name: 'taxAuthGeoId', type: 'string'},
						   ]"/>

	<#assign columnlist="
			   { text: '${uiLabelMap.ProductPriceType}', datafield: 'productPriceTypeId', width: 200, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var productPriceTypeId = data.productPriceTypeId;
			        var productPriceType = getProductPriceType(productPriceTypeId);
			        return '<span>' + productPriceType + '</span>';
		        }},
			   { text: '${uiLabelMap.CommonPurpose}', datafield: 'productPricePurposeId', width: 100, editable: false},
			   { text: '${uiLabelMap.ProductCurrency}', datafield: 'currencyUomId', width: 100, editable: false},
			   { text: '${uiLabelMap.ProductProductStoreGroup}', datafield: 'productStoreGroupId', width: 80, editable: false},
			   { text: '${uiLabelMap.CommonFromDateTime}', datafield: 'fromDate', width: 140, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var fromDate = data.fromDate;
			        var dateShow = getDateTimeStamp(fromDate);
			        return '<span>' + dateShow + '</span>';
		        }},
			   { text: '${uiLabelMap.CommonThruDateTime}',  datafield: 'thruDate', width: 140, editable: true, columntype: 'datetimeinput', cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var thruDate = data.thruDate;
			        var dateShow = getDateTimeStamp(thruDate);
			        return '<span>' + dateShow + '</span>';
		        },validation: function (cell, value) {
		        	
		        	var thisRow = cell.row;
		        	var cellFD = $('#jqxgrid').jqxGrid('getCell', thisRow, 'fromDate');
		        	var thisFD = cellFD.value;
		        	if (value == null){
                    	return true;
                    }
                     if (thisFD > value) {
                         return { result: false, message: 'Thru Date can not before From Date' };
                     }
                     return true;
                 }
               },
			   { text: '${uiLabelMap.ProductCostPrice}',  datafield: 'price', width: 140, editable: true, columntype: 'numberinput'},
			   { text: '${uiLabelMap.FormFieldTitle_termUomId}',  datafield: 'priceWithoutTax', width: 160, editable: true},
			   { text: '${uiLabelMap.FormFieldTitle_customPriceCalcService}',  datafield: 'priceWithTax', width: 170, editable: true},
			   { text: '${uiLabelMap.FormFieldTitle_taxPercentage}',  datafield: 'taxAmount', width: 140, editable: true},
			   { text: '${uiLabelMap.AccountingTaxAuthority}',  datafield: 'taxAuthPartyId', minwidth: 140, editable: true},
			   { text: '${uiLabelMap.AccountingTaxAuthorityGeo}',  datafield: 'taxAuthGeoId', width: 160, editable: true},
			   { text: '${uiLabelMap.ProductLastModifiedBy}',  datafield: 'lastModifiedByUserLogin', width: 140, editable: false},
			   { text: '${uiLabelMap.ProductLastModifiedDate}',  datafield: 'lastModifiedDate', width: 180, editable: false, cellsformat: 'dd/MM/yyyy - hh:mm:ss'},
			   "/>
			   <@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false"
					showtoolbar="true" addrow="true" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true" 
					customcontrol1="icon-tasks@${uiLabelMap.CommonList}@ListProductPrice?productId=${productId}" editmode='click'
					url="jqxGeneralServicer?sname=JQGetListProductPrice&productId=${productId}" updateUrl="jqxGeneralServicer?sname=updateProductPrice&jqaction=U"
					createUrl="jqxGeneralServicer?sname=createProductPrice&jqaction=C"
					editColumns="productId;productPriceTypeId;productPricePurposeId;currencyUomId;productStoreGroupId;taxAuthPartyId;taxAuthGeoId;price(java.math.BigDecimal);thruDate(java.sql.Timestamp);fromDate(java.sql.Timestamp)"
					addColumns="productId;productPriceTypeId;productPricePurposeId;currencyUomId;productStoreGroupId;priceWithoutTax;taxAuthPartyId;taxAuthGeoId;price(java.math.BigDecimal);thruDate(java.sql.Timestamp);fromDate(java.sql.Timestamp)"
				/>
			   
			   <div id="alterpopupWindow" style="display:none;">
		        <div>${uiLabelMap.AddNewProductPrice}</div>
		        <div style="overflow-y: scroll;">
		        	<div class="row-fluid">
		        		<div class="span12">
		    	 			<div class="span3">${uiLabelMap.ProductCostPrice}:</div>
		    	 			<div class="span3"><div id="ProductCostPrice1"></div></div>
		    	 			<div class="span3">${uiLabelMap.FormFieldTitle_taxPercentage}:</div>
		    	 			<div class="span3"><div id="taxPercentage1"></div></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.ProductPriceType}:</div>
		    	 			<div class="span3"><div id="ProductPriceType1"></div></div>
		    	 			<div class="span3">${uiLabelMap.AccountingTaxAuthority}:</div>
		    	 			<div class="span3"><input type='text' id="AccountingTaxAuthority1"/></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.CommonPurpose}:</div>
		        	 		<div class="span3"><div id="CommonPurpose1"></div></div>
		        	 		<div class="span3">${uiLabelMap.AccountingTaxAuthorityGeo}:</div>
		    	 			<div class="span3"><input type='text' id="AccountingTaxAuthorityGeo1"/></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.ProductCurrencyUomId}:</div>
		        	 		<div class="span3"><div id="currencyUomId1"></div></div>
		        	 		<div class="span3">${uiLabelMap.TaxInPrice}:</div>
		        	 		<div class="span3"><div id="TaxInPrice1"></div></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.ProductProductStoreGroup}:</div>
		        	 		<div class="span3"><div id="ProductProductStoreGroup1"></div></div>
		        	 		<div class="span3">${uiLabelMap.CommonFromDateTime}:</div>
		        	 		<div class="span3"><div id="CommonFromDateTime1"></div></div>
	        	 		</div>
	        	 		<div class="span12 no-left-margin">
		    	 			<div class="span3"></div>
		        	 		<div class="span3"></div>
		        	 		<div class="span3">${uiLabelMap.CommonThruDateTime}:</div>
		        	 		<div class="span3"><div id="CommonThruDateTime1"></div></div>
		        	 	</div>
	        	 		<div class="span12 no-left-margin">
		        	 		<div class="span5"></div>
		                    <div class="span7"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div>
		                </div>
		             </div>
		        </div>
		    </div>
		    
		    <script>
			    var listProductPriceType = new Array();
				<#if listProductPriceType?exists>
					<#list listProductPriceType as item>
						var row = {};
						<#assign description = StringUtil.wrapString(item.description) />
						row['productPriceTypeId'] = '${item.productPriceTypeId?if_exists}';
						row['description'] = "${description}";
						listProductPriceType[${item_index}] = row;
					</#list>
				</#if>
				var listProductPricePurpose = new Array();
				<#if listProductPricePurpose?exists>
					<#list listProductPricePurpose as item>
						var row = {};
						<#assign description = StringUtil.wrapString(item.description) />
						row['productPricePurposeId'] = '${item.productPricePurposeId?if_exists}';
						row['description'] = "${description}";
						listProductPricePurpose[${item_index}] = row;
					</#list>
				</#if>
				
				var listUom = new Array();
				<#if listUom?exists>
					<#list listUom as item>
						var row = {};
						<#assign description = StringUtil.wrapString(item.description) />
						row['uomId'] = '${item.uomId?if_exists}';
						row['description'] = "${description}";
						listUom[${item_index}] = row;
					</#list>
				</#if>
				var listProductStoreGroup = new Array();
				<#if listProductStoreGroup?exists>
					<#list listProductStoreGroup as item>
						var row = {};
						<#assign productStoreGroupName = StringUtil.wrapString(item.productStoreGroupName) />
						row['productStoreGroupId'] = '${item.productStoreGroupId?if_exists}';
						row['productStoreGroupName'] = '${productStoreGroupName}';
						listProductStoreGroup[${item_index}] = row;
					</#list>
				</#if>
				var listTaxInPrice = ['Y', 'N'];
				    $("#ProductCostPrice1").jqxNumberInput({inputMode: 'simple', spinButtons: true });
			    	$("#taxPercentage1").jqxNumberInput({inputMode: 'simple', spinButtons: true });
			    	
			    	$("#ProductPriceType1").jqxDropDownList({ source: listProductPriceType,displayMember: "description", valueMember: "productPriceTypeId", selectedIndex: 0});
			    	$("#CommonPurpose1").jqxDropDownList({ source: listProductPricePurpose,displayMember: "description", valueMember: "productPricePurposeId", selectedIndex: 0});
			    	
			    	$("#currencyUomId1").jqxDropDownList({ source: listUom,displayMember: "description", valueMember: "uomId", selectedIndex: 0});
			    	$("#ProductProductStoreGroup1").jqxDropDownList({ source: listProductStoreGroup,displayMember: "productStoreGroupId", valueMember: "productStoreGroupId", selectedIndex: 0});
			    	$("#TaxInPrice1").jqxDropDownList({ source: listTaxInPrice, selectedIndex: 0});
			    	
			    	$("#CommonFromDateTime1").jqxDateTimeInput();
			    	$("#CommonThruDateTime1").jqxDateTimeInput();
			    	$("#alterpopupWindow").jqxWindow({
			            width: 1150, maxWidth: 1000, minHeight: 320, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7
			        });
			        $("#alterCancel").jqxButton();
			        $("#alterSave").jqxButton();
			        
			        $("#alterSave").click(function () {
			        	var row;
			        	var tempFrDate = $('#CommonFromDateTime1').val();
	        			var dateFRM1 = tempFrDate.split('/');
	    		        var frmDate = new Date(dateFRM1[2], dateFRM1[1] - 1, dateFRM1[0], 0, 0, 0, 0);
	    		        var tempThrDate = $('#CommonThruDateTime1').val();
	        			var dateTHR1 = tempThrDate.split('/');
	    		        var thrDate = new Date(dateTHR1[2], dateTHR1[1] - 1, dateTHR1[0], 0, 0, 0, 0);
	    		        var taxPercentage = $('#taxPercentage1').val();
			            row = {
			            		productPriceTypeId:$('#ProductPriceType1').val(),
			            		productPricePurposeId:$('#CommonPurpose1').val(),
			            		currencyUomId:$('#currencyUomId1').val(),
			            		productStoreGroupId:$('#ProductProductStoreGroup1').val(),
			            		taxAuthPartyId:$('#AccountingTaxAuthority1').val(),
			            		taxAuthGeoId:$('#AccountingTaxAuthorityGeo1').val(),
			            		price:$('#ProductCostPrice1').val(),
			            		fromDate: frmDate,
			            		thruDate: thrDate,
			            		productId:'${productId}',
			            		taxPercentage: $('#taxPercentage1').val(),
			            	  };
			            console.log(row);
//			    	   	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
			            $("#jqxgrid").jqxGrid('clearSelection');
			            $("#jqxgrid").jqxGrid('selectRow', 0);
			            $("#alterpopupWindow").jqxWindow('close');
			        });
		    </script>