<div id="orderoverview-tab" class="tab-pane active">
	<h3 style="text-align:center;font-weight:bold">
		<#-- order name -->
	    <#if (orderHeader.orderName?has_content)>
			${orderHeader.orderName}
		<#else>
			${uiLabelMap.DAOrderFormTitle}
		</#if>
	</h3>
	
	<div class="widget-body">	
		<div class="widget-main">
			<div class="row-fluid">
				<div class="form-horizontal basic-custom-form form-decrease-padding" style="display: block;">
					<div class="row margin_left_10 row-desc">
						<div class="span6">
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.DAOrderName}:</label>
								<div class="controls-desc">
									<b>
										<#if orderHeader.orderName?exists && orderHeader.orderName?has_content>
											${orderHeader.orderName}
										<#else>
											${uiLabelMap.DANotData}
										</#if>
									</b>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.DAOrderId}:</label>
								<div class="controls-desc">
									<b>
										<#if orderHeader.orderId?exists && orderHeader.orderId?has_content>
											${orderHeader.orderId}
										<#else>
											${uiLabelMap.DANotData}
										</#if>
									</b>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.DACurrency}:</label>
								<div class="controls-desc">
									<b>
										<#if orderHeader.currencyUom?exists && orderHeader.currencyUom?has_content>
											${orderHeader.currencyUom}
										<#else>
											${uiLabelMap.DANotData}
										</#if>
									</b>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.DADesiredDeliveryDate}:</label>
								<div class="controls-desc">
									<#if orderItemList?exists && orderItemList?has_content>
										<#assign desiredDeliveryDate = orderItemList[0]>
										<#if desiredDeliveryDate.estimatedDeliveryDate?has_content>
											<b>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(desiredDeliveryDate.estimatedDeliveryDate, "dd/MM/yyyy", locale, timeZone)!}</b>
										</#if>
									<#else>
										<b>${uiLabelMap.DANotData}</b>
									</#if>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.DACustomer}:</label>
								<div class="controls-desc">
									<b><#--${orderHeader.partyId?if_exists}-->
										<#--
										<#assign placingCustomer = orderReadHelper.getPlacingParty()!>
										<#if placingCustomer?exists>[${placingCustomer.partyId?if_exists}]</#if>
										-->
										<#if displayParty?has_content || orderContactMechValueMaps?has_content>
											<#if displayParty?has_content>
								                <#assign displayPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", displayParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
								                ${displayPartyNameResult.fullName?default("[${uiLabelMap.OrderPartyNameNotFound}]")}
							              	</#if>
							              	<#-- 
							              	<#if partyId?exists>
								                &nbsp;(<a href="${customerDetailLink?if_exists}${partyId}${externalKeyParam}" target="partymgr">${partyId}</a>)
							              	</#if>
							              	-->
							           	<#else>
											${uiLabelMap.DANotData}
										</#if>
									</b>
								</div>
							</div>
						</div><!--.span6-->
						<div class="span6">
							<div>
								<#assign orderContactMechValueMaps = Static['org.ofbiz.party.contact.ContactMechWorker'].getOrderContactMechValueMaps(delegator, orderId) />
								<#list orderContactMechValueMaps as orderContactMechValueMap>
						          	<#assign contactMech = orderContactMechValueMap.contactMech>
						          	<#assign contactMechPurpose = orderContactMechValueMap.contactMechPurposeType>
					              	<#-- <span>&nbsp;${contactMechPurpose.get("description",locale)}</span> -->
					              	<#if contactMech.contactMechTypeId == "POSTAL_ADDRESS">
						                <#assign postalAddress = orderContactMechValueMap.postalAddress>
						                <#if postalAddress?has_content>
					         	 			<div class="control-group">
												<label class="control-label-desc">${uiLabelMap.OrderDestination}:</label>
												<div class="controls-desc">
													<b>
														<#if postalAddress.toName?has_content><b>${uiLabelMap.CommonTo}:</b>&nbsp;${postalAddress.toName}<br /></#if>
											            <#if postalAddress.attnName?has_content><b>${uiLabelMap.CommonAttn}:</b>&nbsp;${postalAddress.attnName}<br /></#if>
											            <#if postalAddress.address1?has_content>${postalAddress.address1}<br /></#if>
											            <#if postalAddress.address2?has_content>${postalAddress.address2}<br /></#if>
											            <#if postalAddress.city?has_content>${postalAddress.city}</#if>
											            <#if postalAddress.stateProvinceGeoId?has_content>&nbsp;
													      	<#assign stateProvince = postalAddress.getRelatedOne("StateProvinceGeo", true)>
												      		${stateProvince.abbreviation?default(stateProvince.geoId)}
											            </#if>
											            <#if postalAddress.postalCode?has_content>, ${postalAddress.postalCode?if_exists}</#if>
											            <#if postalAddress.countryGeoId?has_content><br />
													      	<#assign country = postalAddress.getRelatedOne("CountryGeo", true)>
													      	${country.get("geoName", locale)?default(country.geoId)}
												    	</#if>
													</b>
												</div>
											</div>
						                </#if>
					                </#if>
				                </#list>
						    </div>
						    <#--
						    <#if !postalAddress.countryGeoId?has_content>
							    <#assign addr1 = postalAddress.address1?if_exists>
							    <#if addr1?has_content && (addr1.indexOf(" ") > 0)>
							      	<#assign addressNum = addr1.substring(0, addr1.indexOf(" "))>
							      	<#assign addressOther = addr1.substring(addr1.indexOf(" ")+1)>
							      	<a target="_blank" href="${uiLabelMap.CommonLookupWhitepagesAddressLink}" class="buttontext">${uiLabelMap.CommonLookupWhitepages}</a>
							    </#if>
						  	</#if>
						    -->
							<#--
							DADebt
							<label>${uiLabelMap.accTotalInvoicesValue}: </label> <label style="color : red">${totalValue}</label> 
							<label>${uiLabelMap.accReceivableToApplyTotal}: </label> <label style="color : red">${totalToApply}</label>
							-->
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.accReceivableToApplyTotal}:</label>
								<div class="controls-desc">
									<b style="color:#d6412b">
										<#if totalToApply?exists && totalToApply?has_content>
							                <@ofbizCurrency amount=totalToApply isoCode=currencyUomId rounding=0/>
										<#else>
											${uiLabelMap.DANotData}
										</#if>
									</b>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label-desc">${uiLabelMap.DASup}:</label>
								<div class="controls-desc">
									<b>
										<#if displayParty?exists && displayParty?has_content>
											<#assign supList = delegator.findByAnd("PartyRelationship", {"partyIdTo" : displayParty.partyId, "roleTypeIdFrom" : "DELYS_SALESSUP_GT"}, null, false)>
							               	<#list supList as supItem>
							               		<#assign displayPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", supItem.partyIdFrom, "userLogin", userLogin))/>
							                	${displayPartyNameResult.fullName?default("[${uiLabelMap.OrderPartyNameNotFound}]")}
							               	</#list>
										<#else>
											${uiLabelMap.DANotData}
										</#if>
									</b>
								</div>
							</div>
						</div><!--.span6-->
					</div><!--.row-->
				</div><!--.form-horizontal.form-decrease-padding-->
				<div class="form-horizontal basic-custom-form" style="display: block;">
					<table cellspacing="0" cellpadding="1" border="0" class="table table-bordered">
						<thead>
							<tr style="font-weight: bold;">
								<td rowspan="2">${uiLabelMap.DASeqId}</td>
								<td colspan="3" class="center">${uiLabelMap.DAProduct}</td>
								<td rowspan="2" style="width:10px">${uiLabelMap.DAPackingPerTray}</td>
								<td rowspan="2" style="width:20px">${uiLabelMap.DAQuantityUomId}</td>
								<td rowspan="2" align="center" class="center">${uiLabelMap.DAQuantity}</td>
								<td rowspan="2">${uiLabelMap.DASumTray}</td>
							  	<td rowspan="2" align="right" class="align-center" style="width:60px">${uiLabelMap.DAPriceBeforeVAT}</td>
							  	<td rowspan="2" align="right" class="align-right">${uiLabelMap.DAAdjustment}</td>
								<td rowspan="2" align="right" class="align-right">${uiLabelMap.DASubTotal} <br />${uiLabelMap.DAParenthesisBeforeVAT}</td>
								<#--<td rowspan="2" style="width:60px">${uiLabelMap.DAPriceAfterVAT}</td>
								<td colspan="2" class="color-red">${uiLabelMap.DAInvoicePrice}</td>-->
								<#if isChiefAccountant || isDistributor>
								<td colspan="2" class="color-red">${uiLabelMap.DAInvoicePrice}</td>
								</#if>
							</tr>
							<tr style="font-weight: bold;">
								<td>${uiLabelMap.DAProductId} - ${uiLabelMap.DAProductName}</td>
								<td>${uiLabelMap.DABarcode}</td>
								<td>${uiLabelMap.DAExpireDate}</td>
								<#--
								<td>${uiLabelMap.DAOrdered}</td>
								<td>${uiLabelMap.DAPromos}</td>
								<td>${uiLabelMap.DASum}</td>
								-->
								<#--
								<td class="color-red">${uiLabelMap.DAPrice}</td>
								<td class="color-red">${uiLabelMap.OrderSubTotal}</td>
								-->
								<#if isChiefAccountant || isDistributor>
								<td class="color-red">${uiLabelMap.DAPrice}</td>
								<td class="color-red">${uiLabelMap.DASubTotal}</td>
								</#if>
							</tr>
						</thead>
						<tbody>
						<#assign taxTotalOrderItems = 0/>
						<#assign subAmountExportOrder = 0.00/>
						<#assign subAmountExportInvoice = 0.00/>
						<#list orderItemList as orderItem>
	            			<#assign itemType = orderItem.getRelatedOne("OrderItemType", false)?if_exists>
	            			
	            			<#assign orderItemContentWrapper = Static["org.ofbiz.order.order.OrderContentWrapper"].makeOrderContentWrapper(orderItem, request)>
		                    <#assign orderItemShipGrpInvResList = orderReadHelper.getOrderItemShipGrpInvResList(orderItem)>
		                    <#if orderHeader.orderTypeId == "SALES_ORDER"><#assign pickedQty = orderReadHelper.getItemPickedQuantityBd(orderItem)></#if>
	            			<tr>
	            				<#assign orderItemType = orderItem.getRelatedOne("OrderItemType", false)?if_exists>
	            				<#assign product = orderItem.getRelatedOne("Product", false) />
		                        <#assign productId = orderItem.productId?if_exists>
								<td>${orderItem.get("orderItemSeqId")}</td>
		                        <#if productId?exists && productId == "shoppingcart.CommentLine">
					                <td colspan="9" valign="top">
					                  <b><div> &gt;&gt; ${orderItem.itemDescription}</div></b>
					                </td>
		              			<#else>
		            				<td valign="top">
					                  	<div>
					                  		<#if orderItem.supplierProductId?has_content>
		                                        ${orderItem.supplierProductId} - ${orderItem.itemDescription?if_exists}
		                                    <#elseif productId?exists>
		                                        <a href="<@ofbizUrl>editProduct?productId=${productId}</@ofbizUrl>">${productId}</a>
		                                         - ${orderItem.itemDescription?if_exists}
		                                        <#if (product.salesDiscontinuationDate)?exists && Static["org.ofbiz.base.util.UtilDateTime"].nowTimestamp().after(product.salesDiscontinuationDate)>
		                                            <br />
		                                            <span style="color: red;">${uiLabelMap.OrderItemDiscontinued}: ${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(product.salesDiscontinuationDate, "", locale, timeZone)!}</span>
		                                        </#if>
		                                    <#elseif orderItemType?exists>
		                                        ${orderItemType.description} - ${orderItem.itemDescription?if_exists}
		                                    <#else>
		                                        ${orderItem.itemDescription?if_exists}
		                                    </#if>
					                  	</div>
		               				</td>
		                			<td><#--Barcode-->
		                				<#assign displayBarcode = delegator.findOne("GoodIdentification", {"goodIdentificationTypeId" : "SKU", "productId" : orderItem.productId}, false)! />
		                				${displayBarcode.idValue?if_exists}
		                			</td>
		                			<td><#--ExpireDate-->
		                				<#if orderItem.fromInventoryItemId?exists>
			                				<#assign inventoryItem = delegator.findOne("InventoryItem", {"inventoryItemId" : orderItem.fromInventoryItemId}, false) />
			                				<#if inventoryItem?exists>
			                					<#if inventoryItem.expireDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(inventoryItem.expireDate, "dd/MM/yyyy", locale, timeZone)!}</#if>
			                				</#if>
			                			<#else>
			                				<#assign inventoryItem = "">
		                				</#if>
		                			</td>
		                			<td><#--QC/khay -->
		                				<#if product.productPackingUomId?exists>
		                					<#assign displayPackingPerTray = delegator.findOne("ConfigPacking", {"productId" : orderItem.productId, "uomFromId" : "DELYS_KHAY", "uomToId", product.productPackingUomId}, false)! />
		                					${displayPackingPerTray.quantityConvert?if_exists}
		                				<#else>
		                					<#assign displayPackingPerTray = "">
		                				</#if>
		                			</td>
		                			<td align="right" valign="top" class="align-right">
		                				<div nowrap="nowrap">
			                				<#if orderItem.quantityUomId?exists>
			                					<#assign quantityUom = delegator.findOne("Uom", {"uomId" : orderItem.quantityUomId}, false)!/>
			                					${quantityUom.description?if_exists}
		                					</#if>
					                  	</div>
					                </td>
					                <#--
					                <td align="right" valign="top" class="align-right">
					                  <div nowrap="nowrap">${orderItem.quantityUomId?if_exists}</div>
					                </td>
					                <td align="right" valign="top" class="align-right">
					                  <div nowrap="nowrap"><#if orderItem.alternativeQuantity?exists>${orderItem.alternativeQuantity?string.number}</#if></div>
					                </td>
					                <td align="right" valign="top" class="align-right">
					                  <div nowrap="nowrap"><#if orderItem.alternativeUnitPrice?exists><@ofbizCurrency amount=orderItem.alternativeUnitPrice isoCode=currencyUomId/></#if></div>
					                </td>
					                -->
		                			<#assign isNormal = true>
		                			<#if orderItem.alternativeQuantity?exists && orderItem.alternativeUnitPrice?exists><#assign isNormal = false></#if>
					                <td align="right" valign="top" class="align-right">
					                  	<div nowrap="nowrap"><#if isNormal>${orderItem.quantity?default(0)?string.number}<#else>${orderItem.alternativeQuantity?string.number}</#if></div>
					                </td>
					                <#--
					                <td align="right" valign="top" class="align-right">
					                  	<div nowrap="nowrap">${orderItem.quantity?default(0)?string.number}</div>
					                </td>
					                -->
					                <#--km <td></td>
					                <td> sum
					                	<div nowrap="nowrap">${orderItem.quantity?default(0)?string.number}</div>
					                </td>
					                -->
					                <td><#--sum tray-->
					                <#if isNormal>
					                	<#if orderItem.quantity?exists && displayPackingPerTray?exists && displayPackingPerTray?has_content && displayPackingPerTray.quantityConvert?exists && (displayPackingPerTray.quantityConvert != 0)>
			        						<#assign packingPerTray = orderItem.quantity / displayPackingPerTray.quantityConvert>
			        						${Static["org.ofbiz.base.util.UtilFormatOut"].formatDecimalNumber(packingPerTray, "#0.00", locale)}
		        						<#else>
		        							<#assign packingPerTray = "" />
		        						</#if>
		        					<#else>
		        						<#assign convertQuantityUomIdPerTray = dispatcher.runSync("getConvertPackingNumber", {"productId" : orderItem.productId, "uomFromId" : "DELYS_KHAY", "uomToId" : orderItem.quantityUomId, "userLogin" : userLogin})! />
		        						<#if orderItem.alternativeQuantity?exists && convertQuantityUomIdPerTray?exists && convertQuantityUomIdPerTray?has_content && convertQuantityUomIdPerTray.convertNumber?exists && (convertQuantityUomIdPerTray.convertNumber != 0)>
			        						<#assign packingPerTray = orderItem.alternativeQuantity / convertQuantityUomIdPerTray.convertNumber>
			        						${Static["org.ofbiz.base.util.UtilFormatOut"].formatDecimalNumber(packingPerTray, "#0.00", locale)}
		        						<#else>
		        							<#assign packingPerTray = "" />
		        						</#if>
		        					</#if>
					                </td>
					                <td align="right" valign="top"><#--unit price-->
					                  	<div nowrap="nowrap">
					                  	<#if isNormal><@ofbizCurrency amount=orderItem.unitPrice isoCode=currencyUomId/>
					                  	<#else><@ofbizCurrency amount=orderItem.alternativeUnitPrice isoCode=currencyUomId/></#if>
					                  	</div>
					                </td>
					                <td align="right" class="align-right" valign="top"><#--adjustment-->
					                  	<div nowrap="nowrap">
											<@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemAdjustmentsTotal(orderItem, orderAdjustments, true, false, false) isoCode=currencyUomId/>
										</div>
					                </td>
					                <td align="right" class="align-right" valign="top" nowrap="nowrap"><#--DASubTotalBeforeVAT-->
					                  	<div>
					                  		<#if orderItem.statusId != "ITEM_CANCELLED">
												<@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments) isoCode=currencyUomId rounding=0/>
												<#assign subAmountExportOrder = subAmountExportOrder + Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments)/>
											<#else>
												<#--
												<@ofbizCurrency amount=0.00 isoCode=currencyUomId/>
												<#assign subAmountExportOrder = subAmountExportOrder + 0.00/>
												-->
												<@ofbizCurrency amount=Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments) isoCode=currencyUomId rounding=0/>
												<#assign subAmountExportOrder = subAmountExportOrder + Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments)/>
											</#if>
					                  	</div>
					                </td>
					                <#--unit price after vat <td></td>-->
					                <#if isChiefAccountant || isDistributor>
					                <#assign productPriceInvoice = delegator.findByAnd("ProductPrice", {"productId" : productId, "productPriceTypeId" : "INVOICE_PRICE_GT"}, null, false)!/>
									<td class="color-red align-right">
										<#if productPriceInvoice?exists && productPriceInvoice?has_content>
											<#assign productPriceInvoiceFirst = productPriceInvoice?first/>
											<#if productPriceInvoiceFirst.price?exists>
												<@ofbizCurrency amount=productPriceInvoiceFirst.price isoCode=currencyUomId/>
												<#if (Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments) &gt; 0.00) 
													|| (Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemSubTotal(orderItem, orderAdjustments) &lt; 0.00)>
													<#assign subTotalExport = orderItem.quantity * productPriceInvoiceFirst.price />
												<#else>
													<#assign subTotalExport = 0.00>
												</#if>
											<#else>
												<#assign subTotalExport = 0.00>
											</#if>
										<#else>
												<#assign subTotalExport = 0.00>
										</#if>
									</td>
									<td class="color-red align-right">
										<#if subTotalExport?exists>
											<#assign subAmountExportInvoice = subAmountExportInvoice + subTotalExport/>
											<@ofbizCurrency amount=subTotalExport isoCode=currencyUomId/>
										</#if>
									</td>
									</#if>
		          				</#if>
							</tr>
							
							<#-- show info from workeffort -->
							
							<#-- show linked order lines -->
							
							<#-- show linked requirements -->
		                    
							<#-- show linked quote -->
							
							<#-- now show adjustment details per line item -->
		                    <#assign orderItemAdjustments = Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemAdjustmentList(orderItem, orderAdjustments)>
		                    <#if orderItemAdjustments?exists && orderItemAdjustments?has_content>
		                        <#list orderItemAdjustments as orderItemAdjustment>
		                            <#assign adjustmentType = orderItemAdjustment.getRelatedOne("OrderAdjustmentType", true)>
		                            <#if adjustmentType.orderAdjustmentTypeId == "SALES_TAX">
		                            	<#assign taxTotalOrderItems = taxTotalOrderItems + Static["org.ofbiz.order.order.OrderReadHelper"].calcItemAdjustment(orderItemAdjustment, orderItem) />
		                        	</#if>
		                        </#list>
		                    </#if>
							
							<#-- now show price info per line item -->
							
							<#-- now show survey information per line item -->
		                    
		                    <#-- display the ship estimated/before/after dates -->
		                    
		                    <#-- now show ship group info per line item -->
		                    
		                    <#-- now show inventory reservation info per line item -->
		                    <#--
		                    <#if orderItemShipGrpInvResList?exists && orderItemShipGrpInvResList?has_content>
		                        <#list orderItemShipGrpInvResList as orderItemShipGrpInvRes>
		                            <tr>
		                                <td align="right" colspan="8">
		                                    <span >${uiLabelMap.CommonInventory}</span>&nbsp;
		                                    <a class="btn btn-mini btn-primary" href="/facility/control/EditInventoryItem?inventoryItemId=${orderItemShipGrpInvRes.inventoryItemId}${externalKeyParam}"
		                                       class="buttontext">${orderItemShipGrpInvRes.inventoryItemId}</a>
		                                    <span >${uiLabelMap.OrderShipGroup}</span>&nbsp;${orderItemShipGrpInvRes.shipGroupSeqId}
		                                </td>
		                                <td align="center">
		                                    ${orderItemShipGrpInvRes.quantity?string.number}&nbsp;
		                                </td>
		                                <td>
		                                    <#if (orderItemShipGrpInvRes.quantityNotAvailable?has_content && orderItemShipGrpInvRes.quantityNotAvailable > 0)>
		                                        <span style="color: red;">
		                                            [${orderItemShipGrpInvRes.quantityNotAvailable?string.number}&nbsp;${uiLabelMap.OrderBackOrdered}]
		                                        </span>
		                                        //<a href="<@ofbizUrl>balanceInventoryItems?inventoryItemId=${orderItemShipGrpInvRes.inventoryItemId}&amp;orderId=${orderId}&amp;priorityOrderId=${orderId}&amp;priorityOrderItemSeqId=${orderItemShipGrpInvRes.orderItemSeqId}</@ofbizUrl>" class="buttontext" style="font-size: xx-small;">Raise Priority</a> 
		                                    </#if>
		                                    &nbsp;
		                                </td>
		                                <td colspan="1">&nbsp;</td>
		                            </tr>
		                        </#list>
		                    </#if>
		                    -->
		                    <#-- now show planned shipment info per line item -->
		                    
		                    <#-- now show item issuances (shipment) per line item -->
		                    
		                    <#-- now show item issuances (inventory item) per line item -->
		                    
		                    <#-- now show shipment receipts per line item -->
						</#list>
						
						<#if orderItemList?exists && orderItemList?has_content && orderItemList?size &gt; 0>
							<#assign orderItemAdjustments = Static["org.ofbiz.order.order.OrderReadHelper"].getOrderItemAdjustmentList(orderItemList[0], orderAdjustments)>
		                    <#if orderItemAdjustments?exists && orderItemAdjustments?has_content>
		                        <#list orderItemAdjustments as orderItemAdjustment>
		                            <#assign adjustmentType = orderItemAdjustment.getRelatedOne("OrderAdjustmentType", true)>
		                            <#if orderItemAdjustment.orderAdjustmentTypeId == "SALES_TAX">
		                            <tr>
		                                <td align="right" class="align-right" colspan="10">
		                                    <span >${uiLabelMap.OrderAdjustment}</span>&nbsp;${adjustmentType.get("description",locale)}
		                                    ${orderItemAdjustment.get("description",locale)?if_exists}
		                                    <#if orderItemAdjustment.comments?has_content>
		                                        (${orderItemAdjustment.comments?default("")})
		                                    </#if>
		                                    <#if orderItemAdjustment.productPromoId?has_content>
		                                        <a class="btn btn-mini btn-primary" href="/catalog/control/EditProductPromo?productPromoId=${orderItemAdjustment.productPromoId}${externalKeyParam}"
		                                            >${orderItemAdjustment.getRelatedOne("ProductPromo", false).getString("promoName")}</a>
		                                    </#if>
		                                    <#if orderItemAdjustment.orderAdjustmentTypeId == "SALES_TAX">
		                                        <#if orderItemAdjustment.primaryGeoId?has_content>
		                                            <#assign primaryGeo = orderItemAdjustment.getRelatedOne("PrimaryGeo", true)/>
		                                            <#if primaryGeo.geoName?has_content>
		                                                <span >${uiLabelMap.OrderJurisdiction}</span>&nbsp;${primaryGeo.geoName} [${primaryGeo.abbreviation?if_exists}]
		                                            </#if>
		                                            <#if orderItemAdjustment.secondaryGeoId?has_content>
		                                                <#assign secondaryGeo = orderItemAdjustment.getRelatedOne("SecondaryGeo", true)/>
		                                                <span >${uiLabelMap.CommonIn}</span>&nbsp;${secondaryGeo.geoName} [${secondaryGeo.abbreviation?if_exists}])
		                                            </#if>
		                                        </#if>
		                                        <#if orderItemAdjustment.sourcePercentage?exists>
		                                            <span >${uiLabelMap.OrderRate}</span>&nbsp;${orderItemAdjustment.sourcePercentage?string("0.######")}
		                                        </#if>
		                                        <#if orderItemAdjustment.customerReferenceId?has_content>
		                                            <span >${uiLabelMap.OrderCustomerTaxId}</span>&nbsp;${orderItemAdjustment.customerReferenceId}
		                                        </#if>
		                                        <#if orderItemAdjustment.exemptAmount?exists>
		                                            <span >${uiLabelMap.OrderExemptAmount}</span>&nbsp;${orderItemAdjustment.exemptAmount}
		                                        </#if>
		                                    </#if>
		                                </td>
		                                <td class="align-right">
		                                	<#if (taxTotalOrderItems &lt; 0)>
		                                		<#assign taxTotalOrderItemsNegative = -taxTotalOrderItems>
		                                		(<@ofbizCurrency amount=taxTotalOrderItemsNegative isoCode=currencyUomId/>)
		                                	<#else>
		                                		<@ofbizCurrency amount=taxTotalOrderItems isoCode=currencyUomId/>
		                                	</#if>
		                                </td>
		                                <#if isChiefAccountant || isDistributor>
		                                <td></td>
		                                <td align="right" class="color-red align-right">
		                                	<#assign taxTotalOrderItemsExportInvoice = (taxTotalOrderItems * (subAmountExportInvoice / subAmountExportOrder))?round>
		                                	<#if (taxTotalOrderItemsExportInvoice &lt; 0)>
			                                	<#assign taxTotalOrderItemsExportInvoiceNegative = -taxTotalOrderItemsExportInvoice>
			                                	(<@ofbizCurrency amount=taxTotalOrderItemsExportInvoiceNegative isoCode=currencyUomId rounding=0/>)
			                                <#else>
			                                	<@ofbizCurrency amount=taxTotalOrderItemsExportInvoice isoCode=currencyUomId rounding=0/>
			                                </#if>
		                                </td>
		                                </#if>
		                            </tr>
		                            </#if>
		                        </#list>
		                    </#if>
						</#if>
						
						<#list orderHeaderAdjustments as orderHeaderAdjustment>
			                <#assign adjustmentType = orderHeaderAdjustment.getRelatedOne("OrderAdjustmentType", false)>
			                <#assign adjustmentAmount = Static["org.ofbiz.order.order.OrderReadHelper"].calcOrderAdjustment(orderHeaderAdjustment, orderSubTotal)>
			                <#if adjustmentAmount != 0>
			                    <tr>
			                        <td align="right" class="align-right" colspan="10">
			                            <#if orderHeaderAdjustment.comments?has_content>${orderHeaderAdjustment.comments} - </#if>
			                            <#if orderHeaderAdjustment.description?has_content>${orderHeaderAdjustment.description} - </#if>
			                            <span >${adjustmentType.get("description", locale)}</span>
			                        </td>
			                        <td align="right" class="align-right" nowrap="nowrap">
			                        	<#if (adjustmentAmount &lt; 0)>
	                                		<#assign adjustmentAmountNegative = -adjustmentAmount>
			                            	(<@ofbizCurrency amount=adjustmentAmountNegative isoCode=currencyUomId rounding=0/>)
			                            <#else>
			                            	<@ofbizCurrency amount=adjustmentAmount isoCode=currencyUomId rounding=0/>
			                            </#if>
			                        </td>
			                        <#if isChiefAccountant || isDistributor>
			                        <td></td>
	                                <td align="right" class="color-red align-right">
	                                	<#if subAmountExportOrder?exists && subAmountExportOrder?has_content && (subAmountExportOrder &gt; 0)>
	                                		<#assign adjustmentAmountExportInvoice = (adjustmentAmount * (subAmountExportInvoice / subAmountExportOrder))?round>
	                                	<#else>
	                                		<#assign adjustmentAmountExportInvoice = 0/>
	                                	</#if>
	                                	<#if (adjustmentAmountExportInvoice &lt; 0)>
	                                		<#assign adjustmentAmountExportInvoiceNegative = -adjustmentAmountExportInvoice>
	                                		(<@ofbizCurrency amount=adjustmentAmountExportInvoiceNegative isoCode=currencyUomId rounding=0/>)
	                                	<#else>
	                                		<@ofbizCurrency amount=adjustmentAmountExportInvoice isoCode=currencyUomId rounding=0/>
	                                	</#if>
	                                </td>
	                                </#if>
			                    </tr>
			                </#if>
			            </#list>
						
						<#-- subtotal -->
	          			<tr>
	            			<td align="right" class="align-right" colspan="10"><div><b>${uiLabelMap.OrderItemsSubTotal}</b></div></td>
	            			<td align="right" class="align-right" nowrap="nowrap">
	            				<#if (orderSubTotal &lt; 0)>
                            		<#assign orderSubTotalNegative = -orderSubTotal>
                            		(<@ofbizCurrency amount=orderSubTotalNegative isoCode=currencyUomId rounding=0/>)
                            	<#else>
                            		<@ofbizCurrency amount=orderSubTotal isoCode=currencyUomId rounding=0/>
                        		</#if>
	        				</td>
	        				<#if isChiefAccountant || isDistributor>
	        				<td></td>
                            <td align="right" class="color-red align-right">
                            	<#if subAmountExportOrder?exists && subAmountExportOrder?has_content && (subAmountExportOrder &gt; 0)>
                            		<#assign orderSubTotalExportInvoice = (orderSubTotal * (subAmountExportInvoice / subAmountExportOrder))?round/>
                            	<#else>
                            		<#assign orderSubTotalExportInvoice = 0/>
                            	</#if>
                            	<#if (orderSubTotalExportInvoice &lt; 0)>
                            		<#assign orderSubTotalExportInvoiceNegative = -orderSubTotalExportInvoice>
                            		(<@ofbizCurrency amount=orderSubTotalExportInvoiceNegative isoCode=currencyUomId rounding=0/>)
                            	<#else>
                            		<@ofbizCurrency amount=orderSubTotalExportInvoice isoCode=currencyUomId rounding=0/>
                            	</#if>
                            </td>
                            </#if>
	          			</tr>
	          			
	          			<#-- other adjustments -->
			            <tr>
			              	<td align="right" class="align-right" colspan="10"><div><b>${uiLabelMap.OrderTotalOtherOrderAdjustments}</b></div></td>
			              	<td align="right" class="align-right" nowrap="nowrap">
			              		<#if (otherAdjAmount &lt; 0)>
                            		<#assign otherAdjAmountNegative = -otherAdjAmount>
									(<@ofbizCurrency amount=otherAdjAmountNegative isoCode=currencyUomId rounding=0/>)
								<#else>
									<@ofbizCurrency amount=otherAdjAmount isoCode=currencyUomId rounding=0/>
								</#if>
							</td>
			              	<#if isChiefAccountant || isDistributor>
			              	<td></td>
                            <td align="right" class="color-red align-right">
                            	<#if subAmountExportOrder?exists && subAmountExportOrder?has_content && (subAmountExportOrder &gt; 0)>
                            		<#assign otherAdjAmountExportInvoice = (otherAdjAmount * (subAmountExportInvoice / subAmountExportOrder))?round>
                            	<#else>
                            		<#assign otherAdjAmountExportInvoice = 0>
                            	</#if>
                            	<#if (otherAdjAmountExportInvoice &lt; 0)>
                            		<#assign otherAdjAmountExportInvoiceNegative = -otherAdjAmountExportInvoice>
                            		(<@ofbizCurrency amount=otherAdjAmountExportInvoiceNegative isoCode=currencyUomId rounding=0/>)
                            	<#else>
                            		<@ofbizCurrency amount=otherAdjAmountExportInvoice isoCode=currencyUomId rounding=0/>
                            	</#if>
                            </td>
                            </#if>
			            </tr>
	          			
	          			<#-- shipping adjustments -->
			          	<#--
			          	<tr>
				            <td align="right" colspan="9"><div><b>${uiLabelMap.OrderTotalShippingAndHandling}</b></div></td>
				            <td align="right" class="align-right" nowrap="nowrap"><div><@ofbizCurrency amount=shippingAmount isoCode=currencyUomId rounding=0/></div></td>
			          	</tr>
			          	-->
			          	
			          	<#-- tax adjustments -->
			          	<tr>
				            <td align="right" class="align-right" colspan="10"><div><b>${uiLabelMap.OrderTotalSalesTax}</b></div></td>
				            <td align="right" class="align-right" nowrap="nowrap">
				            	<#if (taxAmount &lt; 0)>
                            		<#assign taxAmountNegative = -taxAmount>
				            		(<@ofbizCurrency amount=taxAmountNegative isoCode=currencyUomId rounding=0/>)
				            	<#else>
				            		<@ofbizCurrency amount=taxAmount isoCode=currencyUomId rounding=0/>
				            	</#if>
				            </td>
				            <#if isChiefAccountant || isDistributor>
				            <td></td>
                            <td align="right" class="color-red align-right">
                            	<#if subAmountExportOrder?exists && subAmountExportOrder?has_content && (subAmountExportOrder &gt; 0)>
                            		<#assign taxAmountExportInvoice = (taxAmount * (subAmountExportInvoice / subAmountExportOrder))?round>
                            	<#else>
                            		<#assign taxAmountExportInvoice = 0>
                            	</#if>
                            	<#if (taxAmountExportInvoice &lt; 0)>
                            		<#assign taxAmountExportInvoiceNegative = -taxAmountExportInvoice>
                            		(<@ofbizCurrency amount=taxAmountExportInvoice isoCode=currencyUomId rounding=0/>)
                            	<#else>
                            		<@ofbizCurrency amount=taxAmountExportInvoice isoCode=currencyUomId rounding=0/>
                            	</#if>
                            </td>
                            </#if>
			          	</tr>
			          	
			          	<#-- grand total -->
			          	<tr>
				            <td align="right" class="align-right" colspan="10"><div><b>${uiLabelMap.OrderTotalDue}</b></div></td>
				            <td align="right" class="align-right" nowrap="nowrap">
				            	<#if (grandTotal &lt; 0)>
                            		<#assign grandTotalNegative = -grandTotal>
				            		(<@ofbizCurrency amount=grandTotalNegative isoCode=currencyUomId rounding=0/>)
				            	<#else>
				            		<@ofbizCurrency amount=grandTotal isoCode=currencyUomId rounding=0/>
				            	</#if>
				            </td>
				            <#if isChiefAccountant || isDistributor>
				            <td></td>
                            <td align="right" class="color-red align-right">
                            	<#if subAmountExportOrder?exists && subAmountExportOrder?has_content && (subAmountExportOrder &gt; 0)>
                            		<#assign grandTotalExportInvoice = (grandTotal * (subAmountExportInvoice / subAmountExportOrder))?round>
                            	<#else>
                            		<#assign grandTotalExportInvoice = 0>
                            	</#if>
                            	<#if (grandTotalExportInvoice &lt; 0)>
                            		<#assign grandTotalExportInvoiceNegative = -grandTotalExportInvoice>
                            		(<@ofbizCurrency amount=grandTotalExportInvoiceNegative isoCode=currencyUomId rounding=0/>)
                            	<#else>
                            		<@ofbizCurrency amount=grandTotalExportInvoice isoCode=currencyUomId rounding=0/>
                            	</#if>
                            </td>
                            </#if>
			          	</tr>
			          	<#if isChiefAccountant || isDistributor>
				          	<tr>
								<td colspan="3" class="color-red align-right" align="right" valign="bottom" class="align-right">
									<b>${uiLabelMap.DASendToAccount}</b>
								</td>
							  	<td colspan="3" align="right" valign="bottom" class="align-right">
									<b>${uiLabelMap.DADelysAccount}</b>
								</td> 
							  	<td colspan="3" align="right" class="color-red align-right" valign="bottom">
									<b>
									<#if (grandTotalExportInvoice &lt; 0)>
	                            		<#assign grandTotalExportInvoiceNegative = -grandTotalExportInvoice>
										<@ofbizCurrency amount=grandTotalExportInvoiceNegative isoCode=currencyUomId/>
									<#else>
										<@ofbizCurrency amount=grandTotalExportInvoice isoCode=currencyUomId/>
									</#if>
									</b>
								</td>
								
							  	<td colspan="3" class="align-right"><b>${uiLabelMap.DAAccountSecond}</b></td>				  	
							  	<td colspan="3" class="color-red align-right">
							  		<b>
							  		<#if ((grandTotal - grandTotalExportInvoice) &lt; 0)>
							  			<@ofbizCurrency amount=(grandTotalExportInvoice - grandTotal) isoCode=currencyUomId/>
							  		<#else>
							  			<@ofbizCurrency amount=(grandTotal - grandTotalExportInvoice) isoCode=currencyUomId/>
							  		</#if>
							  		</b>
							  	</td>
							</tr>
						</#if>
						</tbody>
					</table>
				</div><!--.form-horizontal-->
				<#if grandTotalExportInvoice?exists && grandTotalExportInvoice?has_content>
					<#if grandTotalExportInvoice &lt; 0>
						<#assign accountOneValue = grandTotalExportInvoiceNegative>
					<#else>
						<#assign accountOneValue = grandTotalExportInvoice>
					</#if>
					<#if ((grandTotal - grandTotalExportInvoice) &lt; 0)>
						<#assign accountTwoValue = grandTotalExportInvoice - grandTotal>
					<#else>
						<#assign accountTwoValue = grandTotal - grandTotalExportInvoice>
					</#if>
				<#else>
					<#assign accountOneValue = 0>
					<#assign accountTwoValue = 0>
				</#if>
				
				<input type="hidden" name="accountOneValue" id="accountOneValue" value="${accountOneValue?default(0)}"/>
				<input type="hidden" name="accountTwoValue" id="accountTwoValue" value="${accountTwoValue?default(0)}"/>
<#--Attach Payment Order-->
				<#if isChiefAccountant || isDistributor>
					<#if currentStatus.statusId?has_content && currentStatus.statusId == "ORDER_NPPAPPROVED">
						<span style="color:#F00; display:block; margin-bottom:20px">${uiLabelMap.DADistributorApproved}</span>
					<#else>
						<#if currentStatus.statusId == "ORDER_SADAPPROVED">
							<#if hasDistributorApproved == "TRUE">
							<form name="attachPaymentOrder" id="attachPaymentOrder" action="<@ofbizUrl>attachPaymentOrder</@ofbizUrl>" method="post" enctype="multipart/form-data">	
								<input type="hidden" name="orderId" id="orderId" value="${orderId}" />
								<input type="hidden" name="_uploadedFile_fileName" id="_uploadedFile_fileName" value="" />
								<input type="hidden" name="_uploadedFile_contentType" id="_uploadedFile_contentType" value="" />
								<input type="hidden" name="imageResize" id="imageResize" value="" />
								<h6><b>${uiLabelMap.DAAttachPaymentOrder}</b></h6>
								<div class="widget-body">
									<div class="widget-main">
										<div class="span6">
											<input type="file" id="uploadedFile" name="uploadedFile"/>
											<#--
											<input multiple="" type="file" id="id-input-file-3" />
											<label>
												<input type="checkbox" name="file-format" id="id-file-format" />
												<span class="lbl"> Allow only images</span>
											</label>
											 -->
											 
											 <button id="btn_attachPaymentOrder" type="submit" class="btn btn-small btn-primary">
									 			<i class="icon-plus"></i> ${uiLabelMap.DAAdd} </button>
										</div>
									</div>
								</div>
								<div style="clear:both"></div>
							</form>	
						
								<div class="row-fluid wizard-actions">
									<form action="<@ofbizUrl>changeOrderStatusDis/findPurcharseOrderListDis</@ofbizUrl>" method="post" style="display:inline-block">
										<input type="hidden" name="orderId" value="${orderId}" />
										<input type="hidden" name="statusId" value="ORDER_CANCELLED" />
										<input type="hidden" name="setItemStatus" value="Y" />
										<input type="hidden" name="changeReason" value="" />
										
										<button class="btn btn-primary" type="submit">
											<i class="icon-angle-left"></i> ${uiLabelMap.DACancel}</button>
									</form>
									<form action="<@ofbizUrl>changeOrderStatusDis/findPurcharseOrderListDis</@ofbizUrl>" method="post" style="display:inline-block">
										<input type="hidden" name="orderId" value="${orderId}" />
										<input type="hidden" name="statusId" value="ORDER_NPPAPPROVED" />
										<input type="hidden" name="setItemStatus" value="Y" />
										<input type="hidden" name="changeReason" value="" />
										
										<button class="btn btn-primary" type="submit"> ${uiLabelMap.DASendConfirm} <i class="icon-angle-right icon-on-right"></i></button>
									</form>
								</div>
							</#if>
						</#if>
					</#if>
					<h6><b>${uiLabelMap.DAAttachPaymentOrder}</b></h6>
					<div class="span12" style="margin-bottom:20px">
							<div class="span7">
								<#if paymentOrderList?has_content>
								<div style="overflow: auto; width: auto; height:auto; max-height: 200px;overflow-y: scroll;">
								
									<#list paymentOrderList as paymentOrder>
										<div class="itemdiv commentdiv">
											<div class="user">
												<a href="${paymentOrder.objectInfo?if_exists}" target="_blank" style="max-width:42px; max-height:42px">
													<img alt="${paymentOrder.dataResourceName?if_exists}" src="${paymentOrder.objectInfo?if_exists}" style="max-width:42px; max-height:42px" />
												</a>
											</div>
			
											<div class="body">
												<div class="name">
													<a href="${paymentOrder.objectInfo?if_exists}" target="_blank">${paymentOrder.dataResourceName?if_exists}</a>
												</div>
												<div class="text">
													<i class="icon-quote-left"></i>
													<#assign personAttachPaymentOrder = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", paymentOrder.createdByUserLogin, "compareDate", paymentOrder.createdDate, "userLogin", userLogin))/>
													${uiLabelMap.DAPersonCreate}: ${personAttachPaymentOrder.fullName?if_exists} [${paymentOrder.createdByUserLogin}]
													<div class="time" class="pull-right" style="display:inline-block; float:right; margin-right:50px">
														<i class="icon-time"></i>
														<span class="green">${paymentOrder.createdDate?string("yyyy-MM-dd HH:mm:ss.SSS")}</span>
													</div>
												</div>
											</div>
			
											<div class="tools">
												<#if currentStatus.statusId?has_content && currentStatus.statusId == "ORDER_NPPAPPROVED">
												<#else>
													<a href="#" class="btn btn-minier btn-danger">
														<i class="icon-only icon-trash"></i>
													</a>
												</#if>
											</div>
										</div>
									</#list>
								
								</div><!--.comments-->
								<#else>
									${uiLabelMap.DANotFile}
								</#if>
							</div>
					</div><!--.span12-->
					<div style="clear:both"></div>
				</#if>
			</div><!--.row-fluid-->
		</div><!--.widget-main-->
	</div><!--.widget-body-->
</div>

<script type="text/javascript">
	$(function() {
		$('#id-input-file-1 , #uploadedFile').ace_file_input({
			no_file:'No File ...',
			btn_choose:'Choose',
			btn_change:'Change',
			droppable:false,
			onchange:null,
			thumbnail:false //| true | large
			//whitelist:'gif|png|jpg|jpeg'
			//blacklist:'exe|php'
			//onchange:''
			//
		});
		$('#id-input-file-3').ace_file_input({
			style:'well',
			btn_choose:'Drop files here or click to choose',
			btn_change:null,
			no_icon:'icon-cloud-upload',
			droppable:true,
			thumbnail:'small'
			//,icon_remove:null//set null, to hide remove/reset button
			/**,before_change:function(files, dropped) {
				//Check an example below
				//or examples/file-upload.html
				return true;
			}*/
			/**,before_remove : function() {
				return true;
			}*/
			,
			preview_error : function(filename, error_code) {
				//name of the file that failed
				//error_code values
				//1 = 'FILE_LOAD_FAILED',
				//2 = 'IMAGE_LOAD_FAILED',
				//3 = 'THUMBNAIL_FAILED'
				//alert(error_code);
			}
		
		}).on('change', function(){
			//console.log($(this).data('ace_input_files'));
			//console.log($(this).data('ace_input_method'));
		});
		
		//dynamically change allowed formats by changing before_change callback function
		$('#id-file-format').removeAttr('checked').on('change', function() {
			var before_change
			var btn_choose
			var no_icon
			if(this.checked) {
				btn_choose = "Drop images here or click to choose";
				no_icon = "icon-picture";
				before_change = function(files, dropped) {
					var allowed_files = [];
					for(var i = 0 ; i < files.length; i++) {
						var file = files[i];
						if(typeof file === "string") {
							//IE8 and browsers that don't support File Object
							if(! (/\.(jpe?g|png|gif|bmp)$/i).test(file) ) return false;
						}
						else {
							var type = $.trim(file.type);
							if( ( type.length > 0 && ! (/^image\/(jpe?g|png|gif|bmp)$/i).test(type) )
									|| ( type.length == 0 && ! (/\.(jpe?g|png|gif|bmp)$/i).test(file.name) )//for android's default browser which gives an empty string for file.type
								) continue;//not an image so don't keep this file
						}
						
						allowed_files.push(file);
					}
					if(allowed_files.length == 0) return false;
	
					return allowed_files;
				}
			}
			else {
				btn_choose = "Drop files here or click to choose";
				no_icon = "icon-cloud-upload";
				before_change = function(files, dropped) {
					return files;
				}
			}
			var file_input = $('#id-input-file-3');
			file_input.ace_file_input('update_settings', {'before_change':before_change, 'btn_choose': btn_choose, 'no_icon':no_icon})
			file_input.ace_file_input('reset_input');
		});
		
		$('#attachPaymentOrder').on('submit', function(e){
			var file = $('#uploadedFile')[0].files[0];
			$("#_uploadedFile_fileName").val(file.name);
			$("#_uploadedFile_contentType").val(file.type);
			$("#attachPaymentOrder").submit();
		});
	})
</script>