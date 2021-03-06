<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<div class="widget-box transparent no-bottom-border">
    <div class="widget-header">
        <h4>${uiLabelMap.CommonReceive} ${uiLabelMap.OrderOrderReturn} ${returnId?if_exists} ${uiLabelMap.CommonTo} ${uiLabelMap.facility} <#if facility?has_content>"${facility.facilityName?default("Not Defined")}"</#if> [${facilityId?if_exists}] ${uiLabelMap.CommonBy} ${uiLabelMap.Shipment} ${shipmentId?if_exists}</h4>
   		<!-- 
   			<span class="widget-toolbar none-content">
        		<a href="<@ofbizUrl>EditFacility</@ofbizUrl>" class="icon-plus-sign open-sans">${uiLabelMap.ProductNewFacility}</a>
        	</span>
        -->
    </div>
        <#-- Receiving Results -->
        <#if receivedItems?has_content>
        <!--  
        	<h3 class="small blue lighter">${uiLabelMap.ProductReceiptForReturn} ${uiLabelMap.CommonNbr}<a href="/ordermgr/control/returnMain?returnId=${returnHeader.returnId}${externalKeyParam?if_exists}" class="btn btn-small btn-info">${returnHeader.returnId}</a></h3>
        -->
          <#if "RETURN_RECEIVED" == returnHeader.getString("statusId")>
            <h3 class="small blue lighter">${uiLabelMap.ProductReturnCompletelyReceived}</h3>
          </#if>
          <br />
          <table cellspacing="0" class="basic-table">
            <tr class="header-row">
              <td>${uiLabelMap.ProductReceipt}</td>
              <td>${uiLabelMap.CommonDate}</td>
              <td>${uiLabelMap.CommonReturn}</td>
              <td>${uiLabelMap.ProductLine}</td>
              <td>${uiLabelMap.ProductProductId}</td>
              <td>${uiLabelMap.ProductPerUnitPrice}</td>
              <td>${uiLabelMap.ProductReceived}</td>
            </tr>
            <#list receivedItems as item>
              <tr>
                <td>${item.receiptId}</td>
                <td>${item.getString("datetimeReceived").toString()}</td>
                <td>${item.returnId}</td>
                <td>${item.returnItemSeqId}</td>
                <td>${item.productId?default("Not Found")}</td>
                <td>${item.unitCost?default(0)?string("##0.00")}</td>
                <td>${item.quantityAccepted?string.number}</td>
              </tr>
            </#list>
          </table>
          <br />
        </#if>

        <#-- Multi-Item Return Receiving -->
        <#if returnHeader?has_content>
        	<#if notOrderComponent?has_content>
        		<#assign formAction = "receiveReturnItems">
        	<#else>
        		<#assign formAction = "receiveReturnedProduct">
        	</#if>
          <form method="post" action="<@ofbizUrl>${formAction}</@ofbizUrl>" name='selectAllForm'>
            <#-- general request fields -->
            <input type="hidden" name="facilityId" value="${requestParameters.facilityId?if_exists}" />
            <input type="hidden" name="returnId" value="${requestParameters.returnId?if_exists}" />
            <input type="hidden" name="_useRowSubmit" value="Y" />
            <#assign now = Static["org.ofbiz.base.util.UtilDateTime"].nowTimestamp().toString()>
            <#assign rowCount = 0>
            <div id="table-container">
            <table cellspacing="0" class="table table-striped table-bordered table-hover dataTable">
              <#if !returnItems?exists || returnItems?size == 0>
                <tr>
                  <td colspan="2" class="label">${uiLabelMap.ProductNoItemsToReceive}</td>
                </tr>
              <#else>
                
                  <!--
                  <tr>
	                  <td>
	                    <h3 class="small blue lighter">
	                      ${uiLabelMap.ProductReceiveReturn} <a href="/ordermgr/control/returnMain?returnId=${returnHeader.returnId}${externalKeyParam?if_exists}" class="btn btn-small btn-info">#${returnHeader.returnId}</a>
	                      <#if parameters.shipmentId?has_content>${uiLabelMap.ProductShipmentId} <a href="<@ofbizUrl>ViewShipment?shipmentId=${parameters.shipmentId}</@ofbizUrl>" class="btn btn-small btn-info">${parameters.shipmentId}</a></#if>
	                    </h3>
	                  </td>
	                  </tr>
                  -->
                
                <#list returnItems as returnItem>
                  <#assign defaultQuantity = returnItem.returnQuantity - receivedQuantities[returnItem.returnItemSeqId]?double>
                  <#assign orderItem = returnItem.getRelatedOne("OrderItem", false)?if_exists>
                  <#if (orderItem?has_content && 0 < defaultQuantity)>
                  <#assign orderItemType = (orderItem.getRelatedOne("OrderItemType", false))?if_exists>
                  <input type="hidden" name="returnId_o_${rowCount}" value="${returnItem.returnId}" />
                  <input type="hidden" name="returnItemSeqId_o_${rowCount}" value="${returnItem.returnItemSeqId}" />
                  <input type="hidden" name="shipmentId_o_${rowCount}" value="${parameters.shipmentId?if_exists}" />
                  <input type="hidden" name="facilityId_o_${rowCount}" value="${requestParameters.facilityId?if_exists}" />
                  <input type="hidden" name="datetimeReceived_o_${rowCount}" value="${now}" />
                  <input type="hidden" name="quantityRejected_o_${rowCount}" value="0" />
                  <input type="hidden" name="comments_o_${rowCount}" value="${uiLabelMap.OrderReturnedItemRaNumber} ${returnItem.returnId}" />

                  <#assign unitCost = Static["org.ofbiz.order.order.OrderReturnServices"].getReturnItemInitialCost(delegator, returnItem.returnId, returnItem.returnItemSeqId)/>
                  <tr class="header-row">
                  		<td>${uiLabelMap.ReturnItemSeqId}</td>
		              	<td>${uiLabelMap.ProductProductId}</td>
		              	<td>${uiLabelMap.ProductLocation}</td>
		              	<td>${uiLabelMap.ProductQtyReceived}</td>
		              	<td>${uiLabelMap.InventoryItemType}</td>
		              	<td>${uiLabelMap.ProductInitialInventoryItemStatus}</td>
			            <td>${uiLabelMap.ProductPerUnitPrice}</td>
		              	<td colspan="1" align="right">
                  			${uiLabelMap.ProductSelectAll}
                    		<input type="checkbox" style="opacity: 1 !important; position: initial !important;" name="selectAll" value="Y" onclick="javascript:toggleAll(this, 'selectAllForm');" />
                  		</td>
		            </tr>
                  	<tr>
                      <#assign productId = "">
                      <#if orderItem.productId?exists>
                        <#assign product = orderItem.getRelatedOne("Product", false)>
                        <#assign productId = product.productId>
                            <#assign serializedInv = product.getRelated("InventoryItem", Static["org.ofbiz.base.util.UtilMisc"].toMap("inventoryItemTypeId", "SERIALIZED_INV_ITEM"), null, false)>
                            <input type="hidden" name="productId_o_${rowCount}" value="${product.productId}" />
                            <td>${returnItem.returnItemSeqId}</td>
                            <td width="45%">
                                <!--
                                	<a href="/catalog/control/EditProduct?productId=${product.productId}${externalKeyParam?if_exists}" target="catalog" class="">${product.productId}&nbsp;-&nbsp;${product.internalName?if_exists}</a>
                                -->
                                ${product.internalName?if_exists} [${product.productId}]
                                <#if serializedInv?has_content><font color='red'>**${uiLabelMap.ProductSerializedInventoryFound}**</font></#if>
                            </td>
                          <#elseif orderItem?has_content>
                            <td width="45%">
                                <b>${orderItemType.get("description",locale)}</b> : ${orderItem.itemDescription?if_exists}&nbsp;&nbsp;
                                <input type="text" size="12" name="productId_o_${rowCount}" />
                                <a href="/catalog/control/EditProduct?${externalKeyParam}" target="catalog" class="btn btn-small btn-info">${uiLabelMap.ProductCreateProduct}</a>
                            </td>
                          <#else>
                            <td width="45%">
                                ${returnItem.get("description",locale)?if_exists}
                            </td>
                          </#if>

                          <#-- location(s) -->
                          <td align="right">
                            <#assign facilityLocations = (product.getRelated("ProductFacilityLocation", Static["org.ofbiz.base.util.UtilMisc"].toMap("facilityId", facilityId), null, false))?if_exists>
                            <#if facilityLocations?has_content>
                              <select name="locationSeqId_o_${rowCount}">
                                <#list facilityLocations as productFacilityLocation>
                                  <#assign facility = productFacilityLocation.getRelatedOne("Facility", true)>
                                  <#assign facilityLocation = productFacilityLocation.getRelatedOne("FacilityLocation", false)?if_exists>
                                  <#assign facilityLocationTypeEnum = (facilityLocation.getRelatedOne("TypeEnumeration", true))?if_exists>
                                  <option value="${productFacilityLocation.locationSeqId}"><#if facilityLocation?exists>${facilityLocation.areaId?if_exists}:${facilityLocation.aisleId?if_exists}:${facilityLocation.sectionId?if_exists}:${facilityLocation.levelId?if_exists}:${facilityLocation.positionId?if_exists}</#if><#if facilityLocationTypeEnum?exists>(${facilityLocationTypeEnum.get("description",locale)})</#if>[${productFacilityLocation.locationSeqId}]</option>
                                </#list>
                                <option value="">${uiLabelMap.ProductNoLocation}</option>
                              </select>
                            <#else>
                              <span>
                                <#if parameters.facilityId?exists>
                                    <#assign LookupFacilityLocationView="LookupFacilityLocation?facilityId=${facilityId}">
                                <#else>
                                    <#assign LookupFacilityLocationView="LookupFacilityLocation">
                                </#if>
                                <@htmlTemplate.lookupField formName="selectAllForm" name="locationSeqId_o_${rowCount}" id="locationSeqId_o_${rowCount}" fieldFormName="${LookupFacilityLocationView}"/>
                              </span>
                            </#if>
                          </td>
                          <td align="right">
                            <input type="text" class="width100px" name="quantityAccepted_o_${rowCount}" size="6" value="${defaultQuantity?string.number}" />
                          </td>
	                       <td width='10%'>
                              <select name="inventoryItemTypeId_o_${rowCount}" size="1" id="inventoryItemTypeId_o_${rowCount}" onchange="javascript:setInventoryItemStatus(this,${rowCount});">
                                 <#list inventoryItemTypes as nextInventoryItemType>
                                    <option value='${nextInventoryItemType.inventoryItemTypeId}'
                                 <#if (facility.defaultInventoryItemTypeId?has_content) && (nextInventoryItemType.inventoryItemTypeId == facility.defaultInventoryItemTypeId)>
                                    selected="selected"
                                  </#if>
                                 >${nextInventoryItemType.get("description",locale)?default(nextInventoryItemType.inventoryItemTypeId)}</option>
                                 </#list>
                              </select>
                          </td>
                          <td width="35%">
                            <select name="statusId_o_${rowCount}" size='1' id = "statusId_o_${rowCount}">
                              <option value="INV_RETURNED">${uiLabelMap.ProductReturned}</option>
                              <option value="INV_AVAILABLE">${uiLabelMap.ProductAvailable}</option>
                              <option value="INV_NS_DEFECTIVE" <#if returnItem.returnReasonId?default("") == "RTN_DEFECTIVE_ITEM">Selected</#if>>${uiLabelMap.ProductDefective}</option>
                            </select>
                          </td>
                          <#if serializedInv?has_content>
                            <td align="right" class="label">${uiLabelMap.ProductExistingInventoryItem}</td>
                            <td align="right">
                              <select name="inventoryItemId_o_${rowCount}">
                                <#list serializedInv as inventoryItem>
                                  <option>${inventoryItem.inventoryItemId}</option>
                                </#list>
                              </select>
                            </td>
                          <#else>
                          </#if>
                          <td align="right">
                          	<#if unitCost?has_content>
                          		<input type='text' class="width100px" name='unitCost_o_${rowCount}' size='6' value='<@ofbizCurrency amount=unitCost isoCode=returnHeader.currencyUomId/>' />	
                          	<#else>
                          		<#assign unitCost = 0>
                          		<input type='text' class="width100px" name='unitCost_o_${rowCount}' size='6' value='<@ofbizCurrency amount=unitCost isoCode=returnHeader.currencyUomId/>' />
                          	</#if>
                            
                          </td>
                    <td align="right">
                      <input type="checkbox" style="opacity: 1 !important; position: initial !important;" name="_rowSubmit_o_${rowCount}" value="Y" onclick="javascript:checkToggle(this, 'selectAllForm');" />
                    </td>
                  <#assign rowCount = rowCount + 1>
                  </#if>
                </#list>
                <#if rowCount == 0>
                </tr>
                  <tr>
                    <td colspan="8" class="label">${uiLabelMap.ProductNoItemsReturn} #${returnHeader.returnId} ${uiLabelMap.ProductToReceive}.</td>
                  </tr>
                  <tr>
                    <td colspan="8" align="right">
                      <a href="<@ofbizUrl>ReceiveReturn?facilityId=${requestParameters.facilityId?if_exists}</@ofbizUrl>" class="btn btn-small btn-info">${uiLabelMap.ProductReturnToReceiving}</a>
                    </td>
                  </tr>
                <#else>
                  <tr>
                    <td colspan="8" align="right">
                      <a href="javascript:document.selectAllForm.submit();" class="btn btn-small btn-info">${uiLabelMap.ProductReceiveSelectedProduct}</a>
                    </td>
                  </tr>
                </#if>
              </#if>
            </table>
            </div>
            <input type="hidden" name="_rowCount" value="${rowCount}" />
          </form>
          <script language="JavaScript" type="text/javascript">selectAll('selectAllForm');</script>

          <#-- Initial Screen -->
        <#else>
          <form name="selectAllForm" method="post" action="<@ofbizUrl>ReceiveReturn</@ofbizUrl>">
            <input type="hidden" name="facilityId" value="${requestParameters.facilityId?if_exists}" />
            <input type="hidden" name="initialSelected" value="Y" />
            <table cellspacing="0" class="basic-table">
              <tr><td colspan="4"><h3 class="small blue lighter">${uiLabelMap.ProductReceiveReturn}</h3></td></tr>
              <tr>
                <td align='right' class="olbius-label">${uiLabelMap.ProductReturnNumber}</td>
                <td>&nbsp;</td>
                <td width="90%">
                  <input type="text" name="returnId" size="20" maxlength="20" value="${requestParameters.returnId?if_exists}" />
                </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
                <td colspan="2">
                  <a href="javascript:document.selectAllForm.submit();" class="btn btn-small btn-info">${uiLabelMap.ProductReceiveProduct}</a>
                </td>
              </tr>
            </table>
          </form>
        </#if>
</div>
<script language="JavaScript" type="text/javascript">
    function setInventoryItemStatus(selection,index) {
        var statusId = "statusId_o_" + index;
        jObjectStatusId = jQuery("#" + statusId);
        jQuery.ajax({
            url: 'UpdatedInventoryItemStatus',
            data: {inventoryItemType: selection.value, inventoryItemStatus: jObjectStatusId.val()},
            type: "POST",
            success: function(data){jObjectStatusId.html(data);}
        });
    }
</script>
