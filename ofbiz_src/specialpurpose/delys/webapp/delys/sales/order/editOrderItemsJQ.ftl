<script language="JavaScript" type="text/javascript">
  	function quicklookup(element) {
    	window.location='<@ofbizUrl>LookupBulkAddSupplierProductsInApprovedOrder</@ofbizUrl>?orderId='+element.value;
  	}
</script>
<script type="text/javascript">
	var productQuantities = new Array();
	var rowChangeArr = new Array();
	<#if orderItemSGList?exists && orderItemSGList?has_content>
		<#assign defaultItemDeliveryDate = ""/>
		<#list orderItemSGList as orderItem>
			<#if (orderItem.productId?exists)>
				var objNew = {};
	   			objNew["productId"] = "${orderItem.productId}";
	   			<#if orderItem.quantityUomId?exists>
	   				objNew["quantityUomId"] = "${orderItem.quantityUomId}";
	   			</#if>
	   			<#if orderItem.alternativeQuantity?exists>
	   				objNew["quantity"] = "${orderItem.alternativeQuantity}";
	   			</#if>
	   			<#if orderItem.expireDate?exists>
	   				objNew["expireDate"] = "${orderItem.expireDate}";
	   			</#if>
	   			<#if orderItem.orderItemSeqId?exists>
	   				objNew["orderItemSeqId"] = "${orderItem.orderItemSeqId}";
	   			</#if>
	   			<#if orderItem.shipGroupSeqId?exists>
	   				objNew["shipGroupSeqId"] = "${orderItem.shipGroupSeqId}";
	   			</#if>
	   			productQuantities.push(objNew);
				rowChangeArr.push("${orderItem.productId}");
			</#if>
		</#list>
		<#assign prodCatalogId = orderItemSGList[0].prodCatalogId?default("")/>
		<#assign defaultItemDeliveryDate = orderItemSGList[0].estimatedDeliveryDate?default("")/>
	</#if>
</script>
<#if orderHeader?has_content>
	<#-- price change rules -->
	<#assign allowPriceChange = false/>
	<#if (orderHeader.orderTypeId == 'PURCHASE_ORDER' || security.hasEntityPermission("ORDERMGR", "_SALES_PRICEMOD", session))>
	    <#assign allowPriceChange = true/>
	</#if>
	
<div class="row-fluid">
	<div class="span12">
		<div class="widget-box transparent" id="recent-box">
			<div class="widget-header">
				<h4 class="lighter smaller">
					<#assign orderType = orderHeader.getRelatedOne("OrderType", false)/>
					${orderType?if_exists.get("description", locale)?default(uiLabelMap.OrderOrder)} <i class="fa-angle-right"></i> 
					${uiLabelMap.DAId}: <a href="<@ofbizUrl>orderView?orderId=${orderHeader.orderId}</@ofbizUrl>" title="<#if orderHeader.orderName?has_content>${orderHeader.orderName?if_exists}</#if>">${orderHeader.orderId}</a> 
            		${externalOrder?if_exists} &nbsp;<a href="<@ofbizUrl>order.pdf?orderId=${orderHeader.orderId}</@ofbizUrl>" target="_blank" data-rel="tooltip" title="${uiLabelMap.DAExportToPDF}" data-placement="bottom"><i class="fa-file-pdf-o"></i></a> 
            		&nbsp;<i class="fa-angle-right"></i> ${uiLabelMap.DAEditOrderItems}
				</h4>
				<span class="widget-toolbar none-content">
					<#if security.hasEntityPermission("ORDERMGR", "_UPDATE", session)>
						<#if orderHeader?has_content && orderHeader.statusId != "ORDER_CANCELLED" && orderHeader.statusId != "ORDER_COMPLETED">
							<#-- not yet run
							<a href="javascript:document.updateItemInfo.action='<@ofbizUrl>cancelSelectedOrderItems</@ofbizUrl>';document.updateItemInfo.submit()">
								<i class="icon-remove open-sans">${uiLabelMap.OrderCancelSelectedItems}</i>
							</a>
							-->
							<a href="javascript:document.updateItemInfo.action='<@ofbizUrl>cancelOrderItem</@ofbizUrl>';document.updateItemInfo.submit()" data-rel="tooltip" title="${uiLabelMap.DACancelOrder}" data-placement="bottom">
								<i class="icon-remove open-sans">${uiLabelMap.OrderCancelAllItems}</i>
							</a>
							<#--
							<a href="<@ofbizUrl>orderView?${paramString}</@ofbizUrl>">
								<i class="icon-reply open-sans">${uiLabelMap.CommonBack}</i>
							</a>
							-->
						</#if>
					</#if>
				</span>
				<script type="text/javascript">
					$('[data-rel=tooltip]').tooltip();
				</script>
			</div>

			<div class="widget-body">
				<div class="widget-main padding-4">
					<div class="tab-content padding-8 overflow-visible">
						<#if !orderItemList?has_content>
				            <span class="alert">${uiLabelMap.checkhelper_sales_order_lines_lookup_failed}</span>
				        <#else>
					        <form name="updateItemInfo" id="updateItemInfo" class="form-horizontal basic-custom-form" method="post" action="<@ofbizUrl>updateOrderItemsSales</@ofbizUrl>">
					            <input type="hidden" name="orderId" value="${orderId}"/>
					            <input type="hidden" name="orderItemSeqId" value=""/>
					            <input type="hidden" name="shipGroupSeqId" value=""/>
				            	<#if (orderHeader.orderTypeId == 'PURCHASE_ORDER')>
					              	<input type="hidden" name="supplierPartyId" value="${partyId}"/>
					              	<input type="hidden" name="orderTypeId" value="PURCHASE_ORDER"/>
				            	</#if>
				            </form>
				            <div style="margin-bottom:10px">
				            <div class="row-fluid">
								<div class="span12">
									<div id="jqxPanel" style="width:400px;">
										<button type="button" id="jqxButtonAddNewRow">${uiLabelMap.DAAddNewRow}</button>
										<!--<input type="button" value="${uiLabelMap.newInPayment}" id='jqxButton1' />-->
									</div>
					            	<#assign dataField="[{ name: 'orderItemSeqId', type: 'string' },
					            						{ name: 'shipGroupSeqId', type: 'string' },
					            						{ name: 'productId', type: 'string' },
									               		{ name: 'productName', type: 'string' },
									               		{ name: 'quantityUomId', type: 'string'},
									               		{ name: 'productPackingUomId', type: 'string'},
									               		{ name: 'quantity', type: 'number', formatter: 'integer'},
									               		{ name: 'packingUomId', type: 'string'},
									               		{ name: 'expireDate', type: 'string'}, 
									               		{ name: 'expireDateList', type: 'string'},
									               		{ name: 'atpTotal', type: 'string'},
									               		{ name: 'qohTotal', type: 'string'}
									                	]"/>
									<#assign columnlist="{ text: '${uiLabelMap.DAOrderItemSeqId}', dataField: 'orderItemSeqId', width: '80px', editable:false},
														 { text: '${uiLabelMap.DAShipGroupSeqId}', dataField: 'shipGroupSeqId', width: '80px', editable:false},
														 { text: '${uiLabelMap.DAProductId}', dataField: 'productId', width: '180px', editable:false},
														 { text: '${uiLabelMap.DAProductName}', dataField: 'productName', editable:false},
														 { text: '${uiLabelMap.DAUom}', dataField: 'quantityUomId', width: '120px', columntype: 'dropdownlist',
														 	initeditor: function (row, cellvalue, editor) {
														 		var packingUomData = new Array();
																var data = $('#jqxgridSO').jqxGrid('getrowdata', row);
																
																var itemSelected = data['quantityUomId'];
																var packingUomIdArray = data['packingUomId'];
																for (var i = 0; i < packingUomIdArray.length; i++) {
																	var packingUomIdItem = packingUomIdArray[i];
																	var row = {};
																	//if (packingUomIdItem.description == undefined || packingUomIdItem.description == '') {
																	//	row['description'] = '' + packingUomIdItem.uomId;
																	//} else {
																	//	row['description'] = '' + packingUomIdItem.description;
																	//}
																	row['uomId'] = '' + packingUomIdItem.uomId;
																	packingUomData[i] = row;
																}
														 		var sourceDataPacking =
													            {
													                localdata: packingUomData,
													                datatype: \"array\"
													            };
													            var dataAdapterPacking = new $.jqx.dataAdapter(sourceDataPacking);
													            editor.jqxDropDownList({ source: dataAdapterPacking, displayMember: 'uomId', valueMember: 'uomId'
													            	//renderer: function (index, label, value) {
													            	//	console.log(index, label, value);
															        //	return '[' + value + '] ' + label;
															        //}
													            });
													            
									                          	//editor.jqxDropDownList({source: dataAdapterPacking, displayMember:'description', valueMember: 'uomId'});
													            editor.jqxDropDownList('selectItem', itemSelected);
									                      	}
									                     },
									                     { text: '${uiLabelMap.DAExpireDate}', dataField: 'expireDate', width: '180px', columntype: 'dropdownlist', filterable:false, sortable:false,  
													 		initeditor: function (row, cellvalue, editor) {
														 		var expireDateData = new Array();
																var data = $('#jqxgridSO').jqxGrid('getrowdata', row);
																var rowindex = row;
																var itemSelected = data['expireDate'];
																console.log(itemSelected);
																var expireDateArray = data['expireDateList'];
																var rowNull = {};
																rowNull['expireDate'] = '';
																rowNull['qohTotal'] = '';
																rowNull['atpTotal'] = '';
																expireDateData[0] = rowNull;
																for (var i = 0; i < expireDateArray.length; i++) {
																	var expireDateItem = expireDateArray[i];
																	var row = {};
																	row['expireDate'] = '' + expireDateItem.expireDate;
																	row['qohTotal'] = '' + expireDateItem.qohTotal;
																	row['atpTotal'] = '' + expireDateItem.atpTotal;
																	expireDateData[i+1] = row;
																}
														 		var sourceDataPacking = {
													                localdata: expireDateData,
													                datatype: \"array\"
													            };
													            var dataAdapterPacking = new $.jqx.dataAdapter(sourceDataPacking);
													            editor.jqxDropDownList({ source: dataAdapterPacking, displayMember: 'expireDate', valueMember: 'expireDate'});
													            editor.jqxDropDownList('selectItem', itemSelected);
									                      	},
									                      	//createeditor: function (row, cellvalue, editor) {
									                      	//	editor.on('select', function (event){
															//	    var args = event.args;
															//	    if (args) {
																	    // index represents the item's index.                
															//		    var index = args.index;
															//		    var item = args.item;
																	    // get item's label and value.
																	    //var label = item.label;
																	    //var value = item.value;
															//		    console.log(index, item);
															//		}
															//	});
									                      	//}
									                 	},
									                 	{ text: '${uiLabelMap.DAQOHTotal}', dataField: 'qohTotal', width: '100px', editable:false, filterable:false, sortable:false},
									                 	{ text: '${uiLabelMap.DAATPTotal}', dataField: 'atpTotal', width: '100px', editable:false, filterable:false, sortable:false},
													 	{ text: '${uiLabelMap.DAQuantity}', dataField: 'quantity', cellsalign: 'right', filterable:false, sortable:false, 
														 	cellsrenderer: function(row, column, value){
														 		var data = $('#jqxgridSO').jqxGrid('getrowdata', row);
									    						var indexFinded = rowChangeArr.indexOf(data.productId);
									    						var productId = data.productId;
									    						var returnVal = '<div style=\"overflow: hidden; text-overflow: ellipsis; padding-bottom: 2px; text-align: left; margin-right: 2px; margin-left: 4px; margin-top: 4px;\">';
									    						if (indexFinded > -1) {
														   			var objSelected = productQuantities[indexFinded];
														   			if (productId == objSelected.productId) {
														   				data.quantity = productQuantities[indexFinded].quantity;
														   				returnVal += productQuantities[indexFinded].quantity + '</div>';
														   				return returnVal;
														   			} else {
														   				for(i = 0 ; i < productQuantities.length; i++){
											    							if (productId == productQuantities[i].productId){
											    								data.quantity = productQuantities[i].quantity;
											    								returnVal += productQuantities[i].quantity + '</div>';
														   						return returnVal;
											    							}
											    						}
														   			}
													   			}
													   			returnVal += value + '</div>';
												   				return returnVal;
														 	}
														 }
									              		"/>
									<#-- defaultSortColumn="productId" statusbarjqxgridSO -->
									<@jqGrid id="jqxgridSO" clearfilteringbutton="false" editable="true" alternativeAddPopup="alterpopupWindow" columnlist=columnlist dataField=dataField
											viewSize="15" showtoolbar="false" editmode="click" selectionmode="multiplecellsadvanced" 
											createUrl="jqxGeneralServicer?jqaction=C&sname=appendOrderItemSales" addrefresh="true" addrow="true" 
											addColumns="orderId;shipGroupSeqId;quantity(java.math.BigDecimal);productId;prodCatalogId;shipGroupSeqId;itemDesiredDeliveryDate(java.sql.Timestamp);basePrice(java.math.BigDecimal);overridePrice;reasonEnumId;orderItemTypeId;changeComments;quantityUomId;expireDate(java.sql.Timestamp)"
											url="jqxGeneralServicer?sname=JQGetListOrderItem&catalogId=${currentCatalogId?if_exists}&orderId=${orderHeader.orderId?if_exists}"/>
											<#--JQGetListProductByCategoryCatalogByOrder-->
								</div>
							</div>
				            </div>
				            <div class="row-fluid wizard-actions">
								<a href="javascript: updateCartItems();" class="btn btn-small btn-primary">
		                    		<i class="icon-ok open-sans">${uiLabelMap.DAUpdate}</i>
		                    	</a>
							</div>
				            <div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;" class="jqx-rc-all jqx-rc-all-olbius">
								<div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
									<div style="float: left;">
										<div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
										<span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
									</div>
								</div>
							</div>
				            <#--
				            Thay mo ta: 
				            	<input type="text" size="20" name="idm_${orderItem.orderItemSeqId}" value="${orderItem.itemDescription?if_exists}"/>
				            Thay doi gia: 
				            	<input type="text" size="8" name="ipm_${orderItem.orderItemSeqId}" value="<@ofbizAmount amount=orderItem.unitPrice/>" class="width-cell-100px"/>
					        	&nbsp;<input type="checkbox" name="opm_${orderItem.orderItemSeqId}" value="Y"/>
					        
					        Thay doi so luong theo ship group: 
					        	<input type="text" name="iqm_${shipGroupAssoc.orderItemSeqId}:${shipGroupAssoc.shipGroupSeqId}" size="6" value="${shipGroupAssoc.quantity?string.number}" class="width-cell-100px no-bottom-margin"/>
					        
					        Check thay doi:
					        	<input type="checkbox" name="selectedItem" value="${orderItem.orderItemSeqId}" />
				                <span class="lbl"></span>
				            Ly do:
				            	<select name="irm_${orderItem.orderItemSeqId}" class="no-bottom-margin">
							                              		<option value="">&nbsp;</option>
							                              		<#list orderItemChangeReasons as reason>
							                                		<option value="${reason.enumId}">${reason.get("description",locale)?default(reason.enumId)}</option>
							                              		</#list>
						                            		</select>
						        <input type="text" name="icm_${orderItem.orderItemSeqId}" value="" size="30" maxlength="60" class="no-bottom-margin"/>
						    
				            -->
				            
				            <div class="form-legend" style="margin-top:20px">
								<div class="contain-legend"><span class="content-legend text-uppercase">${uiLabelMap.DAAdjustmentAmount}</span></div>
								<div class="control-group">
									<#list orderHeaderAdjustments as orderHeaderAdjustment>
							            <#assign adjustmentType = orderHeaderAdjustment.getRelatedOne("OrderAdjustmentType", false)>
							            <#assign adjustmentAmount = Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(orderHeaderAdjustment, orderSubTotal)>
							            <#assign orderAdjustmentId = orderHeaderAdjustment.get("orderAdjustmentId")>
							            <#assign productPromoCodeId = ''>
							            <#if adjustmentType.get("orderAdjustmentTypeId") == "PROMOTION_ADJUSTMENT" && orderHeaderAdjustment.get("productPromoId")?has_content>
							                <#assign productPromo = orderHeaderAdjustment.getRelatedOne("ProductPromo", false)>
							                <#assign productPromoCodes = delegator.findByAnd("ProductPromoCode", {"productPromoId":productPromo.productPromoId}, null, false)>
							                <#assign orderProductPromoCode = ''>
							                <#list productPromoCodes as productPromoCode>
							                    <#if !(orderProductPromoCode?has_content)>
							                        <#assign orderProductPromoCode = delegator.findOne("OrderProductPromoCode", {"productPromoCodeId":productPromoCode.productPromoCodeId, "orderId":orderHeaderAdjustment.orderId}, false)?if_exists>
							                    </#if>
							                </#list>
							                <#if orderProductPromoCode?has_content>
							                    <#assign productPromoCodeId = orderProductPromoCode.get("productPromoCodeId")>
							                </#if>
							            </#if>
							            <#if adjustmentAmount != 0>
							                <form name="updateOrderAdjustmentForm${orderAdjustmentId}" method="post" action="<@ofbizUrl>updateOrderAdjustment</@ofbizUrl>" class="">
							                    <input type="hidden" name="orderAdjustmentId" value="${orderAdjustmentId?if_exists}"/>
							                    <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                    <table class="basic-table" cellspacing="0" width="100%">
							                        <tr>
							                            <td class="align-text" width="52%">
							                                <span class="label">${adjustmentType.get("description",locale)}:&nbsp;${orderHeaderAdjustment.comments?if_exists}&nbsp;&nbsp;</span>
							                            </td>
							                            <td nowrap="nowrap" width="28%">
							                            	${uiLabelMap.DADescription}: 
							                                <#if (allowPriceChange)>
							                                    <input type="text" name="description" value="${orderHeaderAdjustment.get("description")?if_exists}" size="30" maxlength="60"/>
							                                <#else>
							                                    ${orderHeaderAdjustment.get("description")?if_exists}
							                                </#if>
							                            </td>
							                            <td width="12%">
							                            	<input type="text" name="amount" size="6" value="<@ofbizAmount amount=adjustmentAmount/>" class="width-cell-100px"/>
							                            </td>
							                            <td nowrap="nowrap" width="8%">
							                                <#if (allowPriceChange)>
						                                  	 	<#--
						                                  	 	<button type="submit" class="btn btn-small btn-primary">
						                                  	 		<i class="icon-ok open-sans">${uiLabelMap.CommonUpdate}</i>
						                                  	 	</button>
						                                  	 	<a href="javascript:document.deleteOrderAdjustment${orderAdjustmentId}.submit();" class="btn btn-small btn-primary">
							                                    	<i class="icon-trash open-sans">${uiLabelMap.CommonDelete}</i></a>
						                                  	 	-->
						                                  	 	<button type="submit" class="btn btn-mini btn-primary">
																	<i class="icon-ok bigger-120"></i>
																</button>
																<button type="button" class="btn btn-mini btn-danger" onclick="javascript:document.deleteOrderAdjustment${orderAdjustmentId}.submit();">
																	<i class="icon-trash bigger-120"></i>
																</button>
							                                <#else>
							                                    <@ofbizAmount amount=adjustmentAmount/>
							                                </#if>
							                            </td>
							                        </tr>
							                    </table>
							                </form>
							                <form name="deleteOrderAdjustment${orderAdjustmentId}" method="post" action="<@ofbizUrl>deleteOrderAdjustment</@ofbizUrl>">
							                    <input type="hidden" name="orderAdjustmentId" value="${orderAdjustmentId?if_exists}"/>
							                    <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                    <#if adjustmentType.get("orderAdjustmentTypeId") == "PROMOTION_ADJUSTMENT">
							                        <input type="hidden" name="productPromoCodeId" value="${productPromoCodeId?if_exists}"/>
							                    </#if>
							                </form>
							            </#if>
							        </#list>
									
									<#-- add new adjustment -->
							        <#if security.hasEntityPermission("ORDERMGR", "_UPDATE", session) && orderHeader.statusId != "ORDER_COMPLETED" && orderHeader.statusId != "ORDER_CANCELLED" && orderHeader.statusId != "ORDER_REJECTED">
							            <form name="addAdjustmentForm" method="post" action="<@ofbizUrl>createOrderAdjustment</@ofbizUrl>">
							                <input type="hidden" name="comments" value="Added manually by [${userLogin.userLoginId}]"/>
							                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                <table class="basic-table" cellspacing="0" style="width:100%">
							                    <tr><td colspan="5"><hr /></td></tr>
							                    <tr>
							                        <td class="align-text">
							                            <span class="label">${uiLabelMap.OrderAdjustment}</span>&nbsp;
							                        </td>
							                        <td>
							                        	<select name="orderAdjustmentTypeId">
							                                <#list orderAdjustmentTypes as type>
							                                <option value="${type.orderAdjustmentTypeId}">${type.get("description",locale)?default(type.orderAdjustmentTypeId)}</option>
							                                </#list>
							                            </select>
							                            <select name="shipGroupSeqId" style="margin-right:5px">
							                                <option value="_NA_"></option>
							                                <#list shipGroups as shipGroup>
							                                <option value="${shipGroup.shipGroupSeqId}">${uiLabelMap.OrderShipGroup} ${shipGroup.shipGroupSeqId}</option>
							                                </#list>
							                            </select>
							                        </td>
							                        <td width="28%">
							                            ${uiLabelMap.DADescription}: <input type="text" name="description" value="" size="30" maxlength="60"/>
							                        </td>
							                        <td width="12%">
							                            <input type="text" name="amount" size="6" value="<@ofbizAmount amount=0.00/>" class="width-cell-100px"/>
							                        </td>
							                        <td width="8%">
							                        	<button class="btn btn-mini btn-primary" type="submit">
							                        		<i class="icon-plus open-sans">${uiLabelMap.CommonAdd}</i>
							                        	</button>
							                        </td>
							                    </tr>
							                </table>
							            </form>
							        </#if>
						        </#if>
						        <#-- subtotal -->
						        <table class="basic-table" cellspacing="0" style="width:100%">
						            <tr><td colspan="4"><hr class="no-bottom-margin" /></td></tr>
						            <tr class="align-text">
						              <td width="80%"><span class="label" style="float:right">${uiLabelMap.OrderItemsSubTotal}: </span></td>
						              <td width="10%" nowrap="nowrap"><@ofbizCurrency amount=orderSubTotal isoCode=currencyUomId/></td>
						              <td width="10%" colspan="2">&nbsp;</td>
						            </tr>
						
						            <#-- other adjustments -->
						            <tr class="align-text">
						              <td><span class="label" style="float:right">${uiLabelMap.OrderTotalOtherOrderAdjustments}: </span></td>
						              <td nowrap="nowrap"><@ofbizCurrency amount=otherAdjAmount isoCode=currencyUomId/></td>
						              <td colspan="2">&nbsp;</td>
						            </tr>
						
						            <#-- shipping adjustments -->
						            <tr class="align-text">
						              <td><span class="label" style="float:right">${uiLabelMap.OrderTotalShippingAndHandling}: </span></td>
						              <td nowrap="nowrap"><@ofbizCurrency amount=shippingAmount isoCode=currencyUomId/></td>
						              <td colspan="2">&nbsp;</td>
						            </tr>
						
						            <#-- tax adjustments -->
						            <tr class="align-text">
						              <td><span class="label" style="float:right">${uiLabelMap.OrderTotalSalesTax}: </span></td>
						              <td nowrap="nowrap"><@ofbizCurrency amount=taxAmount isoCode=currencyUomId/></td>
						              <td colspan="2">&nbsp;</td>
						            </tr>
						
						            <#-- grand total -->
						            <tr class="align-text">
						              <td><span class="label" style="float:right">${uiLabelMap.OrderTotalDue}: </span></td>
						              <td nowrap="nowrap"><@ofbizCurrency amount=grandTotal isoCode=currencyUomId/></td>
						              <td colspan="2">&nbsp;</td>
						            </tr>
						        </table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div><!--.span12-->
</div>
<form id="alterpopupWindowform" name="alterpopupWindowform" class="form-horizontal basic-custom-form form-size-mini" method="post" action="<@ofbizUrl>appendItemToOrder</@ofbizUrl>">
	<div id="alterpopupWindow">
		<div>${uiLabelMap.DAAddToOrder}</div>
		<#if orderHeader?has_content>
			<div class="form-horizontal basic-custom-form form-size-small">
		    	<div class="row-fluid">
		    		<div class="span12">
		    			<input type="hidden" name="orderId" id="orderId_w" value="${orderId?if_exists}"/>
		    			<#if !catalogCol?has_content>
			                <input type="hidden" name="prodCatalogId" id="prodCatalogId_w" value=""/>
			            </#if>
			            <#if catalogCol?has_content && catalogCol?size == 1>
			                <input type="hidden" name="prodCatalogId" id="prodCatalogId_w" value="${catalogCol.first}"/>
			            </#if>
			            <#if shipGroups?size == 1>
			                <input type="hidden" name="shipGroupSeqId" id="shipGroupSeqId_w" value="${shipGroups.first.shipGroupSeqId}"/>
			            </#if>
		    			<#--
		    			<div class="control-group" style="margin:0 !important; font-size:9pt;">
							<span style="color:#666"><i>(${uiLabelMap.DAThisPriceApplyFor1Packing})</i></span>
						</div>
		    			-->
		    			<div class="control-group">
		    				<label class="control-label">${uiLabelMap.DADesiredDeliveryDate}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<input type="hidden" name="itemDesiredDeliveryDate" id="itemDesiredDeliveryDate_w" value="${defaultItemDeliveryDate?if_exists}"/>
		    						<#if defaultItemDeliveryDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(defaultItemDeliveryDate, "dd/MM/yyyy - HH:mm:ss", locale, timeZone)!}</#if>
		    					</div>
		    				</div>
		    			</div>
		    			<#if catalogCol?has_content && (catalogCol?size > 1)>
		    			<div class="control-group">
		    				<label class="control-label">${uiLabelMap.ProductChooseCatalog}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<select name='prodCatalogId' id="prodCatalogId_w">
					                    <#list catalogCol as catalogId>
					                      	<#assign thisCatalogName = Static["org.ofbiz.product.catalog.CatalogWorker"].getCatalogName(request, catalogId)>
					                      	<option value='${catalogId}'>${thisCatalogName}</option>
					                    </#list>
			                  		</select>
		    					</div>
		    				</div>
		    			</div>
		    			</#if>
		    			<div class="control-group">
		    				<label class="control-label required">${uiLabelMap.DAProduct}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<input type="hidden" name="productId" id="productId_w" value=""/>
		    						<div id="jqxdropdownbuttonProduct">
							       	 	<div id="jqxgridProduct"></div>
							       	</div>
		    					</div>
		    				</div>
		    			</div>
		    			<div class="control-group">
		    				<label class="control-label required">${uiLabelMap.DAUom}</label>
		    				<div class="controls">
		    					<div class="span12">
	    							<div id="jqxgridQuantityUom"></div>
		    					</div>
		    				</div>
		    			</div>
		    			<div class="control-group">
		    				<label class="control-label">${uiLabelMap.DAExpireDate}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<div id="jqxdropdownbuttonExpireDate">
	    								<div id="jqxgridExpireDate"></div>
	    							</div>
		    					</div>
		    				</div>
		    			</div>
		    			<#-- <div class="control-group">
		    				<label class="control-label">${uiLabelMap.ProductProductId}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						FIXME Problem here: the input field is shared
			                      	<@htmlTemplate.lookupField formName="alterpopupWindowform" name="productId" id="productId" fieldFormName="LookupProduct"/>
			                      	<#if "PURCHASE_ORDER" == orderHeader.orderTypeId>
			                          	<a href="javascript:quicklookup(document.appendItemForm.orderId)" class="buttontext">${uiLabelMap.OrderQuickLookup}</a>
			                      	</#if>
		    					</div>
		    				</div>
		    			</div> -->
			    		<div class="control-group">
		    				<label class="control-label">${uiLabelMap.OrderPrice}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<input type="text" size="6" name="basePrice" id="basePrice_w" value="${requestParameters.price?if_exists}" style="min-height: 18px;"/>
		    						&nbsp; &nbsp;<input type="checkbox" name="overridePrice" id="overridePrice_w" value="Y" /><label class="lbl" for="id-disable-check" style="text-align: left"> ${uiLabelMap.OrderOverridePrice}</label>
		    					</div>
		    				</div>
		    			</div>
		    			<div class="control-group">
		    				<label class="control-label required">${uiLabelMap.OrderQuantity}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<input type="text" size="6" name="quantity" id="quantity_w" value="${requestParameters.quantity?default("1")}" style="min-height: 18px;"/>
		    					</div>
		    				</div>
		    			</div>
		    			<#if (shipGroups?size > 1)>
		    			<div class="control-group">
		    				<label class="control-label required">${uiLabelMap.OrderShipGroup}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<select name="shipGroupSeqId" id="shipGroupSeqId_w">
		                      			<#list shipGroups as shipGroup>
		                         			<option value="${shipGroup.shipGroupSeqId}">${shipGroup.shipGroupSeqId}</option>
		                      			</#list>
		                      		</select>
		    					</div>
		    				</div>
		    			</div>
		    			</#if>
		    			<div class="control-group">
		    				<label class="control-label">${uiLabelMap.OrderReturnReason}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<select name="reasonEnumId" id="reasonEnumId_w">
				                        <option value="">&nbsp;</option>
				                        <#list orderItemChangeReasons as reason>
				                        	<option value="${reason.enumId}">${reason.get("description",locale)?default(reason.enumId)}</option>
				                        </#list>
			                		</select>
		    					</div>
		    				</div>
		    			</div>
		    			<#if orderHeader.orderTypeId == "PURCHASE_ORDER" && purchaseOrderItemTypeList?has_content>
		    			<div class="control-group">
		    				<label class="control-label">${uiLabelMap.OrderOrderItemType}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<select name="orderItemTypeId" id="orderItemTypeId_w">
				                      	<option value="">&nbsp;</option>
				                      	<#list purchaseOrderItemTypeList as orderItemType>
				                        	<option value="${orderItemType.orderItemTypeId}">${orderItemType.description}</option>
				                      	</#list>
				                    </select>
		    					</div>
		    				</div>
		    			</div>
		    			<#else>
		    				<input type="hidden" value="" name="orderItemTypeId" id="orderItemTypeId_w"/>
		    			</#if>
		    			<div class="control-group">
		    				<label class="control-label">${uiLabelMap.CommonComment}</label>
		    				<div class="controls">
		    					<div class="span12">
		    						<input type="text" size="25" name="changeComments" id="changeComments_w" style="min-height: 18px;"/>
		    					</div>
		    				</div>
		    			</div>
		    		</div>
		    	</div><!--.row-fluid-->
		    	<div class="row-fluid" style="margin-top:20px">
		    		<button type="button" id="alterCancel4" class="btn btn-small btn-danger pull-left" style="padding: 5px 10px"><i class="icon-remove open-sans"></i>${uiLabelMap.CommonCancel}</button>
					<button type="button" id="alterSave4" class="btn btn-primary btn-small pull-right" style="padding: 5px 10px"><i class="icon-ok open-sans"></i>${uiLabelMap.DAAddToOrder}</button>
		    	</div>
	    	</#if>
	    </div>
	</div>		
</form>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script type="text/javascript">
	$(function(){
		$("#jqxButtonAddNewRow").jqxButton({ width: '150', theme: theme});
		$("#alterpopupWindow").jqxWindow({width: 700, height: 480, resizable: false, isModal: true, autoOpen: false, cancelButton: $("#alterCancel4"), modalOpacity: 0.7, theme:theme});
	    $("#alterCancel4").jqxButton({theme: theme});
	    $("#alterSave4").jqxButton({theme: theme});
	    $("#jqxdropdownbuttonProduct").jqxDropDownButton({ theme: theme, width: 200, height: 25});
	    $("#jqxdropdownbuttonExpireDate").jqxDropDownButton({ theme: theme, width: 200, height: 25});
	    
	    // Product JQX Dropdown
	    var productIds = [];
	    var sourceP2 =
	    {
	        datafields:[{name: 'productId', type: 'string'},
	            		{name: 'productName', type: 'string'},
	            		{name: 'productTypeId', type: 'string'},
	            		{name: 'quantityUomId', type: 'string'},
	            		{name: 'packingUomId', type: 'string'},
	            		{name: 'expireDateList', type: 'string'}
        				],
	        cache: false,
	        root: 'results',
	        datatype: "json",
	        updaterow: function (rowid, rowdata) {
	            // synchronize with the server - send update command   
	        },
	        beforeprocessing: function (data) {
	            sourceP2.totalrecords = data.TotalRows;
	        },
	        filter: function () {
	            // update the grid and send a request to the server.
	            $("#jqxgridProduct").jqxGrid('updatebounddata');
	        },
	        pager: function (pagenum, pagesize, oldpagenum) {
	            // callback called when a page or page size is changed.
	        },
	        sort: function () {
	            $("#jqxgridProduct").jqxGrid('updatebounddata');
	        },
	        sortcolumn: 'productId',
			sortdirection: 'asc',
	        type: 'POST',
	        data: {
		        noConditionFind: 'Y',
		        conditionsFind: 'N',
		        productStoreId: '${orderHeader.productStoreId?if_exists}',
		        catalogId: '${prodCatalogId?if_exists}'
		    },
		    pagesize:5,
	        contentType: 'application/x-www-form-urlencoded',
	        url: 'jqxGeneralServicer?sname=JQGetListProductByCatalogAndStore',
	    };
	    var dataAdapterP2 = new $.jqx.dataAdapter(sourceP2,
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
	                if (!sourceP2.totalRecords) {
	                    sourceP2.totalRecords = parseInt(data["odata.count"]);
	                }
	        }, 
	        beforeLoadComplete: function (records) {
	        	for (var i = 0; i < records.length; i++) {
	        		if(typeof(records[i])=="object"){
	        			for(var key in records[i]) {
	        				var value = records[i][key];
	        				if(value != null && typeof(value) == "object" && typeof(value) != null){
	        					//var date = new Date(records[i][key]["time"]);
	        					//records[i][key] = date;
	        				}
	        			}
	        		}
	        	}
	        }
	    });
	    $("#jqxgridProduct").jqxGrid({
	    	width:610,
	        source: dataAdapterP2,
	        filterable: true,
	        showfilterrow: true,
	        virtualmode: true, 
	        sortable:true,
	        theme: theme,
	        editable: false,
	        autoheight:true,
	        pageable: true,
	        rendergridrows: function(obj){
				return obj.data;
			},
	        columns: [{text: '${uiLabelMap.DAProductId}', datafield: 'productId', width:'180px'},
	          			{text: '${uiLabelMap.DAProductName}', datafield: 'productName', width:'250px'},
	          			{text: '${uiLabelMap.DAProductTypeId}', datafield: 'productTypeId', width:'180px'}
	        		]
	    });
	    
	    //ExpireDate JQX Dropdown
	    var localDataEXP = new Array();
	    var sourceEXP = {
			localdata: localDataEXP,
			dataType: "array",
			datafields: [{name: 'expireDate', type: 'string'}, 
						{name: 'atpTotal', type: 'string'}, 
						{name: 'qohTotal', type: 'string'}
						]
		};
		var dataAdapterEXP = new jQuery.jqx.dataAdapter(sourceEXP);
		jQuery("#jqxgridExpireDate").jqxGrid({
			width: '100%',
			source: dataAdapterEXP,
			pageable: true,
	        autoheight: true,
	        filterable:true,
	        showfilterrow: false,
	        sortable: true,
	        altrows: false,
	        showtoolbar: false,
	        enabletooltips: true,
	        editable: false,
	        selectionmode: 'singlerow',
	        columns: [{text: '${uiLabelMap.DAExpireDate}', dataField: 'expireDate'}, 
						{text: '${uiLabelMap.DAATPTotal}', dataField: 'atpTotal'},
						{text: '${uiLabelMap.DAQOHTotal}', dataField: 'qohTotal'}
					]
		});
		
	    
	    $("#jqxButtonAddNewRow").on('click', function () {
			$('#alterpopupWindow').jqxWindow('open');
	    });
	    $("#jqxgridProduct").on('rowselect', function (event) {
	        var args = event.args;
	        var row = $("#jqxgridProduct").jqxGrid('getrowdata', args.rowindex);
	        var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['productId'] +'</div>';
	        $('#jqxdropdownbuttonProduct').jqxDropDownButton('setContent', dropDownContent);
	        //$('#productName').val(row['productName']);
	        $('#productId_w').val(row['productId']);
	        if (row.packingUomId != undefined) {
	        	var dataPOIBP = row.packingUomId;
	        	var itemSelected = row.quantityUomId;
				$("#jqxgridQuantityUom").jqxDropDownList({ theme: theme, source: dataPOIBP, displayMember: "uomId", valueMember: "uomId", width: '200', height: '25'});
	        	$("#jqxgridQuantityUom").jqxDropDownList('selectItem', itemSelected);
	        }
	        if (row.expireDateList != undefined) {
	        	var dataEXP = row.expireDateList;
				//$("#jqxgridExpireDate").jqxDropDownList({ theme: theme, source: dataEXP, displayMember: "expireDate", valueMember: "uomId", width: '200', height: '25'});
				var sourceEXP2 = {
					localdata: dataEXP,
					dataType: "array",
					datafields: [{name: 'expireDate', type: 'string'}, 
								{name: 'atpTotal', type: 'string'}, 
								{name: 'qohTotal', type: 'string'}
								]
				};
				var dataAdapterEXP2 = new jQuery.jqx.dataAdapter(sourceEXP2);
				$("#jqxgridExpireDate").jqxGrid({ source: dataAdapterEXP2});
	        }
	    });
	    
	    <#--$("#jqxgridQuantityUom").on('select', function (event) {
	        var args = event.args;
		    if (args) {
			    var row = $("#jqxgridQuantityUom").jqxGrid('getrowdata', args.rowindex);
		    }
	    });-->
	    
	    $("#jqxgridExpireDate").on('rowselect', function (event) {
	        var args = event.args;
	        var row = $("#jqxgridExpireDate").jqxGrid('getrowdata', args.rowindex);
	        var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['expireDate'] +'</div>';
	        $('#jqxdropdownbuttonExpireDate').jqxDropDownButton('setContent', dropDownContent);
	    });
	    
	    // update the edited row when the user clicks the 'Save' button.
	    $("#alterSave4").click(function () {
		    if($('#alterpopupWindowform').jqxValidator('validate')){
	    		var row;
		        row = { 
		        		orderId:$('#orderId_w').val(),
		        		shipGroupSeqId:$('#shipGroupSeqId_w').val(),
		        		quantity:$('#quantity_w').val(),
		        		productId:$('#jqxdropdownbuttonProduct').val(),
		        		quantityUomId:$('#jqxgridQuantityUom').val(),
		        		expireDate:$('#jqxdropdownbuttonExpireDate').val(),
		        		prodCatalogId:$('#prodCatalogId_w').val(), 
		        		shipGroupSeqId:$('#shipGroupSeqId_w').val(), 
		        		itemDesiredDeliveryDate:$('#itemDesiredDeliveryDate_w').val(), 
		        		basePrice:$('#basePrice_w').val(), 
		        		overridePrice:$('#overridePrice_w').val(), 
		        		reasonEnumId:$('#reasonEnumId_w').val(), 
		        		orderItemTypeId:$('#orderItemTypeId_w').val(), 
		        		changeComments:$('#changeComments_w').val(), 
		        	  };
			   	$("#jqxgridSO").jqxGrid('addRow', null, row, "first");
		        // select the first row and clear the selection.
		        $("#jqxgridSO").jqxGrid('clearSelection');                        
		        $("#jqxgridSO").jqxGrid('selectRow', 0);  
		        $("#alterpopupWindow").jqxWindow('close');
		        
		        // reset value on window
				$('#jqxdropdownbuttonProduct').val("");
				$('#jqxgridQuantityUom').val("");
				$('#jqxdropdownbuttonExpireDate').val("");
				$('#basePrice_w').val("");
				$('#reasonEnumId_w').val("");
				$('#changeComments_w').val("");
				$("#jqxgridProduct").jqxGrid('updatebounddata');
				$("#jqxgridProduct").jqxGrid('clearSelection');
				$("#jqxgridExpireDate").jqxGrid('updatebounddata');
				$("#jqxgridExpireDate").jqxGrid('clearSelection');
			} else {
	        	return;
	        }
	    	<#--
	    	orderId_w
			prodCatalogId_w
			shipGroupSeqId_w
			itemDesiredDeliveryDate_w
			productId_w
			basePrice_w
			overridePrice_w
			quantity_w
			shipGroupSeqId_w
			reasonEnumId_w
			orderItemTypeId_w
			changeComments_w
	    	if($('#alterpopupWindowform').jqxValidator('validate')){
		    	var row;
		        row = { productId:$('#jqxdropdownbuttonProduct').val(),
		        		productName:$('#productName').val(),
		        		priceToDist:$('#priceToDist').val(),
		        		<#if quotationSelected.salesChannel != "SALES_MT_CHANNEL">priceToMarket:$('#priceToMarket').val(),</#if>
		        		priceToConsumer:$('#priceToConsumer').val()
		        	  };
			   	$("#jqxgridQuotationItems").jqxGrid('addRow', null, row, "first");
		        // select the first row and clear the selection.
		        $("#jqxgridQuotationItems").jqxGrid('clearSelection');                        
		        $("#jqxgridQuotationItems").jqxGrid('selectRow', 0);  
		        $("#alterpopupWindow").jqxWindow('close');
		        productIds[productIds.length] = row["productId"];
		        
		        // reset value on window
				$('#jqxdropdownbuttonProduct').val("");
				$('#productName').val("");
				$('#priceToDist').val("");
				<#if quotationSelected.salesChannel != "SALES_MT_CHANNEL">$('#priceToMarket').val("");</#if>
				$('#priceToConsumer').val("");
				$("#jqxgridProduct").jqxGrid('updatebounddata');
				$("#jqxgridProduct").jqxGrid('clearSelection');
	        }else{
	        	return;
	        }
	    	-->
	    });
	});
	
	function updateCartItems() {
		if (productQuantities.length > 0) {
			var strParam = "N";
			var countQuantity = 0;
			for (i = 0; i < productQuantities.length; i++) {
				var rowData = productQuantities[i];
	   			var productId = rowData.productId;
	   			var quantity = rowData.quantity;
	   			var quantityUomId = rowData.quantityUomId;
	   			var expireDate = rowData.expireDate;
	   			var orderItemSeqId = rowData.orderItemSeqId;
	   			var shipGroupSeqId = rowData.shipGroupSeqId;
	   			if (quantityUomId == undefined) quantityUomId = "";
	   			if (expireDate == undefined) expireDate = "";
	   			if (orderItemSeqId == undefined) orderItemSeqId = "";
	   			if (shipGroupSeqId == undefined) shipGroupSeqId = "";
	   			
	   			countQuantity += quantity;
				strParam += "|OLBIUS|" + productId + "|SUIBLO|" + quantity + "|SUIBLO|" + quantityUomId + "|SUIBLO|" + expireDate + "|SUIBLO|" + orderItemSeqId + "|SUIBLO|" + shipGroupSeqId;
			}
			if (countQuantity <= 0) {
				bootbox.dialog("${uiLabelMap.DANotYetChooseProduct}!", [{
					"label" : "OK",
					"class" : "btn-small btn-primary",
					}]
				);
				return false;
			} else {
				//  style='color:#b94a48'
				var formSend = document.getElementById('updateItemInfo');
			    var hiddenField = document.createElement("input");
	            hiddenField.setAttribute("type", "hidden");
	            hiddenField.setAttribute("name", "strParam");
	            hiddenField.setAttribute("value", strParam);
	            formSend.appendChild(hiddenField);
			    formSend.submit();
				<#--
				data = $("#updateItemInfo").serialize();
				data += "&strParam=" + strParam;
				$.ajax({
		            type: "POST",                        
		            url: "updateOrderItemsSales",
		            data: data,
		            async: false, 
		            beforeSend: function () {
						$("#checkoutInfoLoader").show();
					}, 
		            success: function (data) {
		            	if (data.thisRequestUri == "json") {
		            		var errorMessage = "";
					        if (data._ERROR_MESSAGE_LIST_ != null) {
					        	for (var i = 0; i < data._ERROR_MESSAGE_LIST_.length; i++) {
					        		errorMessage += "<p><b>${uiLabelMap.DAErrorUper}</b>: " + data._ERROR_MESSAGE_LIST_[i] + "</p>";
					        	}
					        }
					        if (data._ERROR_MESSAGE_ != null) {
					        	errorMessage += "<p><b>${uiLabelMap.DAErrorUper}</b>: " + data._ERROR_MESSAGE_ + "</p>";
					        }
					        if (errorMessage != "") {
					        	$('#container').empty();
					        	$('#jqxNotification').jqxNotification({ template: 'info'});
					        	$("#jqxNotification").html(errorMessage);
					        	$("#jqxNotification").jqxNotification("open");
					        } else {
					        	$('#container').empty();
					        	$('#jqxNotification').jqxNotification({ template: 'info'});
					        	$("#jqxNotification").html("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
					        	$("#jqxNotification").jqxNotification("open");
					        }
		            	} else {
		            		//$("body").html(data);
		            		window.location.href = "orderView?orderId=${orderId?if_exists}";
		            	}
		            },
		            error: function () {
		                //commit(false);
		            },
		            complete: function() {
				        $("#checkoutInfoLoader").hide();
				    }
		        });
				-->
			}
		} else {
			//bootbox.alert("${uiLabelMap.DANotYetChooseProduct}!");
			bootbox.dialog("${uiLabelMap.DANotYetChooseProduct}!", [{
				"label" : "OK",
				"class" : "btn-small btn-primary",
				}]
			);
			return false;
		}
	}
</script>
<script type="text/javascript">
	 $('#alterpopupWindowform').jqxValidator({
        rules: [
           	{input: '#quantity_w', message: '${uiLabelMap.CommonRequired}. ${uiLabelMap.DANotValidateDataOnlyNumber}', action: 'keyup, blur', 
           		rule: function (input) {
           			var value = $(input).val();
           			if (/^\s*$/.test(value) || isNaN(value)) return false;
           			else return true;
           		}
       		}, 
       		{input: '#jqxgridQuantityUom', message: '${uiLabelMap.CommonRequired}', action: 'blur', 
           		rule: function (input, commit) {
    				var value = $(input).val();
                    return value != "";
                }
       		}, 
           	{input: "#jqxdropdownbuttonProduct", message: "${uiLabelMap.CommonRequired}", action: 'blur', 
       			rule: function (input, commit) {
    				var value = $(input).val();
                    return value != "";
                }
           	}]
    });
    
	$("#jqxgridSO").on("cellBeginEdit", function(event){
		var args = event.args;
    	if (args.datafield == "expireDate") {
    		var rowBoundIndex = args.rowindex;
	    	var data = $("#jqxgridSO").jqxGrid("getrowdata", rowBoundIndex);
	    	var valueSelected = data.expireDate;
	    	var expireDateList = data.expireDateList;
	    	if (valueSelected != null && expireDateList != null) {
	    		for (var i = 0; i < expireDateList.length; i++) {
	    			var row = expireDateList[i];
	    			if (valueSelected != null && valueSelected == row.expireDate) {
						$('#jqxgridSO').jqxGrid('setcellvalue', rowBoundIndex, 'qohTotal', row.qohTotal, 'atpTotal', row.atpTotal);
	    			}
	    		}
	    	}
    	}
	});
	$("#jqxgridSO").on("cellEndEdit", function (event) {
    	var args = event.args;
    	if (args.datafield == "quantity") {
    		var rowBoundIndex = args.rowindex;
	    	var data = $("#jqxgridSO").jqxGrid("getrowdata", rowBoundIndex);
	    	if (data && data.productId) {
	    		var productId = data.productId;
	    		var quantityUomId = data.quantityUomId;
	    		var orderItemSeqId = data.orderItemSeqId;
	    		var shipGroupSeqId = data.shipGroupSeqId;
		   		var oldValue = args.oldvalue;
		   		var newValue = args.value;
		   		var indexFinded = rowChangeArr.indexOf(productId);
		   		if (indexFinded > -1) {
		   			var objSelected = productQuantities[indexFinded];
		   			if (productId == objSelected["productId"] && oldValue == objSelected["quantity"]) {
		   				objSelected["quantity"] = newValue;
		   			} else {
		   				for (var i = 0; i < productQuantities.length; i++) {
		   					var objItem = productQuantities[i];
		   					if (productId == objItem["productId"]) {
		   						objItem["quantity"] = newValue;
		   						break;
		   					}
		   				}
		   			}
		   		} else {
		   			if (newValue && !(/^\s*$/.test(newValue))) {
		   				var objNew = {};
			   			objNew["productId"] = productId;
			   			objNew["quantityUomId"] = quantityUomId;
			   			objNew["quantity"] = newValue;
			   			objNew["orderItemSeqId"] = orderItemSeqId;
			   			objNew["shipGroupSeqId"] = shipGroupSeqId;
			   			var expireDate = data.expireDate;
			   			if (expireDate != undefined) {
			   				objNew["expireDate"] = expireDate;
			   			}
			   			productQuantities.push(objNew);
			   			rowChangeArr.push(productId);
		   			}
		   		}
	    	}
    	} else if (args.datafield == "quantityUomId") {
    		var rowBoundIndex = args.rowindex;
	    	var data = $("#jqxgridSO").jqxGrid("getrowdata", rowBoundIndex);
	    	if (data && data.productId) {
	    		var productId = data.productId;
	    		var quantityUomId = data.quantityUomId;
		   		var oldValue = args.oldvalue;
		   		var newValue = args.value;
		   		var indexFinded = rowChangeArr.indexOf(productId);
		   		if (indexFinded > -1) {
		   			var objSelected = productQuantities[indexFinded];
		   			if (productId == objSelected["productId"] && oldValue == objSelected["quantityUomId"]) {
		   				objSelected["quantityUomId"] = newValue;
		   			} else {
		   				for (var i = 0; i < productQuantities.length; i++) {
		   					var objItem = productQuantities[i];
		   					if (productId == objItem["productId"]) {
		   						objItem["quantityUomId"] = newValue;
		   						break;
		   					}
		   				}
		   			}
	   			}
	    	}
    	} else if (args.datafield == "expireDate") {
    		var rowBoundIndex = args.rowindex;
	    	var data = $("#jqxgridSO").jqxGrid("getrowdata", rowBoundIndex);
	    	if (data && data.productId) {
	    		var oldValue = args.oldvalue;
		   		var newValue = args.value;
	    		var valueSelected = args.value; //newValue
	    		var expireDateList = data.expireDateList;
	    		if (valueSelected != undefined && expireDateList != undefined) {
		    		for (var i = 0; i < expireDateList.length; i++) {
		    			var row = expireDateList[i];
		    			if (valueSelected != null && valueSelected == row.expireDate) {
							$('#jqxgridSO').jqxGrid('setcellvalue', rowBoundIndex, 'qohTotal', row.qohTotal);
							$('#jqxgridSO').jqxGrid('setcellvalue', rowBoundIndex, 'atpTotal', row.atpTotal);
		    			}
		    		}
		    	}
		    	var productId = data.productId;
		    	var indexFinded = rowChangeArr.indexOf(productId);
		   		if (indexFinded > -1) {
		   			var objSelected = productQuantities[indexFinded];
		   			if (productId == objSelected["productId"] && oldValue == objSelected["expireDate"]) {
		   				objSelected["expireDate"] = newValue;
		   			} else {
		   				for (var i = 0; i < productQuantities.length; i++) {
		   					var objItem = productQuantities[i];
		   					if (productId == objItem["productId"]) {
		   						objItem["expireDate"] = newValue;
		   						break;
		   					}
		   				}
		   			}
	   			}
	    	}
    	}
	});
</script>
</#if>