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
  <h3>${uiLabelMap.FacilitySelectOptionsToGroupBy}</h3>
    <span class="widget-toolbar">
    </span>
    <br class="clear"/>
  </div>
  <div class="widget-body" style="margin-top:15px !important;">
  <form method="post" name="selectFactors" action="<@ofbizUrl>PicklistOptions</@ofbizUrl>">
    <input type="hidden" name="facilityId" value="${facilityId}"/>
    <table class="basic-table" cellspacing='0'>
      <tr>
        <td></td>
        <td><input type="checkbox" name="groupByShippingMethod" value="Y" <#if "${requestParameters.groupByShippingMethod?if_exists}" == "Y">checked="checked"</#if>/>&nbsp; <span class="lbl">${uiLabelMap.FacilityGroupByShippingMethod}</span></td>
        <td></td>
        <td><input type="checkbox" name="groupByWarehouseArea" value="Y" <#if "${requestParameters.groupByWarehouseArea?if_exists}" == "Y">checked="checked"</#if>/>&nbsp; <span class="lbl">${uiLabelMap.FacilityGroupByWarehouseArea}</span></td>
        <td></td>
        <td><input type="checkbox" name="groupByNoOfOrderItems" value="Y" <#if "${requestParameters.groupByNoOfOrderItems?if_exists}" == "Y">checked="checked"</#if>/>&nbsp; <span class="lbl">${uiLabelMap.FacilityGroupByNoOfOrderItems}</span></td>
      </tr>
      <tr><td>&nbsp;</td></tr>
    </table>
    <div align ='left'>
      <button class="btn btn-small btn-primary btn-position-center" type="submit">
      	<i class="icon-ok"></i>
      	submit
      </button>
    </div>
  </form>
  </div>
  <div class="widget-header">
  <h3>${uiLabelMap.ProductFindOrdersToPick}</h3>
    <span class="widget-toolbar>
    </span>
    <br class="clear"/>
  </div>
  <div class="widget-body">
    <div align ='right'>
      <a class="btn btn-mini btn-info" href="<@ofbizUrl>ReviewOrdersNotPickedOrPacked?facilityId=${facilityId}</@ofbizUrl>">${uiLabelMap.FormFieldTitle_reviewOrdersNotPickedOrPacked}</a>
    </div>
    <table cellspacing="0" class="table table-hover table-striped table-bordered dataTable">
      <#if pickMoveInfoList?has_content || rushOrderInfo?has_content>
        <tr class="header-row">
          <#if !((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
            <td>${uiLabelMap.OrderOrder} ${uiLabelMap.CommonNbr}</td>
          <#else>
            <td>${uiLabelMap.ProductShipmentMethod}</td>
            <td>${uiLabelMap.ProductWarehouseArea}</td>
            <td>${uiLabelMap.ProductNumberOfOrderItems}</td>
          </#if>
          <td>${uiLabelMap.ProductReadyToPick}</td>
          <td>${uiLabelMap.ProductNeedStockMove}</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </#if>
      <#if rushOrderInfo?has_content>
        <#assign orderReadyToPickInfoList = rushOrderInfo.orderReadyToPickInfoList?if_exists>
        <#assign orderNeedsStockMoveInfoList = rushOrderInfo.orderNeedsStockMoveInfoList?if_exists>
        <#assign orderReadyToPickInfoListSize = (orderReadyToPickInfoList.size())?default(0)>
        <#assign orderNeedsStockMoveInfoListSize = (orderNeedsStockMoveInfoList.size())?default(0)>
        <tr>
          <td>[Rush Orders, all Methods]</td>
          <td>${orderReadyToPickInfoListSize}</td>
          <td>${orderNeedsStockMoveInfoListSize}</td>
          <td>
            <#if orderReadyToPickInfoList?has_content>
              <form method="post" action="<@ofbizUrl>createPicklistFromOrders</@ofbizUrl>">
                <input type="hidden" name="facilityId" value="${facilityId}"/>
                <input type="hidden" name="isRushOrder" value="Y"/>
                ${uiLabelMap.ProductPickFirst}:
                <input type="text" size="4" name="maxNumberOfOrders" value="20"/>
                <button class="btn btn-small btn-primary" type="submit">                
                <i class="icon-ok"></i>
                ${uiLabelMap.ProductCreatePicklist}
                </button>
              </form>
            <#else>
              &nbsp;
            </#if>
          </td>
        </tr>
      </#if>
      <#if pickMoveInfoList?has_content>
        <#assign orderReadyToPickInfoListSizeTotal = 0>
        <#assign orderNeedsStockMoveInfoListSizeTotal = 0>
        <#assign alt_row = false>
        <#list pickMoveInfoList as pickMoveInfo>
          <#assign groupName = pickMoveInfo.groupName?if_exists>
          <#assign groupName1 = pickMoveInfo.groupName1?if_exists>
          <#assign groupName2 = pickMoveInfo.groupName2?if_exists>
          <#assign groupName3 = pickMoveInfo.groupName3?if_exists>
          <#assign orderReadyToPickInfoList = pickMoveInfo.orderReadyToPickInfoList?if_exists>
          <#assign orderNeedsStockMoveInfoList = pickMoveInfo.orderNeedsStockMoveInfoList?if_exists>
          <#assign orderReadyToPickInfoListSize = (orderReadyToPickInfoList.size())?default(0)>
          <#assign orderNeedsStockMoveInfoListSize = (orderNeedsStockMoveInfoList.size())?default(0)>
          <#assign orderReadyToPickInfoListSizeTotal = orderReadyToPickInfoListSizeTotal + orderReadyToPickInfoListSize>
          <#assign orderNeedsStockMoveInfoListSizeTotal = orderNeedsStockMoveInfoListSizeTotal + orderNeedsStockMoveInfoListSize>
          <tr valign="middle"<#if alt_row> class="alternate-row"</#if>>
                <td>
                    <form name="viewGroupDetail_${pickMoveInfo_index}" action="<@ofbizUrl>PicklistOptions</@ofbizUrl>" method="post">
                      <input type ="hidden" name="viewDetail" value= "${groupName?if_exists}"/>
                      <input type="hidden" name="groupByShippingMethod" value="${requestParameters.groupByShippingMethod?if_exists}"/>
                      <input type="hidden" name="groupByWarehouseArea" value="${requestParameters.groupByWarehouseArea?if_exists}"/>
                      <input type="hidden" name="groupByNoOfOrderItems" value="${requestParameters.groupByNoOfOrderItems?if_exists}"/>
                      <input type="hidden" name="facilityId" value="${facilityId?if_exists}"/>
                    </form>
              <#if ((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
                  <#if groupName1?has_content>
                    <a href="javascript:document.viewGroupDetail_${pickMoveInfo_index}.submit()" class="">${groupName1}</a>
                  </#if>
                </td>
                <td>
                  <#if groupName2?has_content>
                    <a href="javascript:document.viewGroupDetail_${pickMoveInfo_index}.submit()" class="">${groupName2}</a>
                  </#if>
                </td>
                <td>
                  <#if groupName3?has_content>
                    <a href="javascript:document.viewGroupDetail_${pickMoveInfo_index}.submit()" class="">${groupName3}</a></td>
                  </#if>
              <#else>
                  <a href="javascript:document.viewGroupDetail_${pickMoveInfo_index}.submit()" class="">${groupName?if_exists}</a>
              </#if>
                </td>
            <td>
              <#if !((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
                <#if orderReadyToPickInfoListSize == 0 >${uiLabelMap.CommonN}<#else>${uiLabelMap.CommonY}</#if>
              <#else>
                ${orderReadyToPickInfoListSize}
              </#if>
            </td>
            <td>
              <#if !((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
                <#if orderNeedsStockMoveInfoListSize == 0>${uiLabelMap.CommonN}<#else>${uiLabelMap.CommonY}</#if>
              <#else>
                ${orderNeedsStockMoveInfoListSize}
              </#if>
            </td>
            <td>
              <#if orderReadyToPickInfoList?has_content>
                <form method="post" action="<@ofbizUrl>createPicklistFromOrders</@ofbizUrl>">
                  <input type="hidden" name="facilityId" value="${facilityId?if_exists}"/>
                  <input type="hidden" name="groupByShippingMethod" value="${requestParameters.groupByShippingMethod?if_exists}"/>
                  <input type="hidden" name="groupByWarehouseArea" value="${requestParameters.groupByWarehouseArea?if_exists}"/>
                  <input type="hidden" name="groupByNoOfOrderItems" value="${requestParameters.groupByNoOfOrderItems?if_exists}"/>
                  <input type="hidden" name="orderIdList" value=""/>
                  <#assign orderIdsForPickList = orderReadyToPickInfoList?if_exists>
                  <#list orderIdsForPickList as orderIdForPickList>
                    <input type="hidden" name="orderIdList" value="${orderIdForPickList.orderHeader.orderId}"/>
                  </#list>
                  <#if ((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
                    <span class="label">${uiLabelMap.ProductPickFirst}</span>
                    <input type="text" size="4" name="maxNumberOfOrders" value="20"/>
                  </#if>
                  <button type="submit" class="btn btn-small btn-primary">
                  <i class="icon-ok"></i>
                  ${uiLabelMap.ProductCreatePicklist}
                  </button>
                </form>
              <#else>
                &nbsp;
              </#if>
            </td>
            <td>
              <#if orderReadyToPickInfoList?has_content>
                <form method="post" action="<@ofbizUrl>printPickSheets</@ofbizUrl>">
                  <input type="hidden" name="printGroupName" value="${groupName?if_exists}"/>
                  <input type="hidden" name="facilityId" value="${facilityId?if_exists}"/>
                  <input type="hidden" name="groupByShippingMethod" value="${requestParameters.groupByShippingMethod?if_exists}"/>
                  <input type="hidden" name="groupByWarehouseArea" value="${requestParameters.groupByWarehouseArea?if_exists}"/>
                  <input type="hidden" name="groupByNoOfOrderItems" value="${requestParameters.groupByNoOfOrderItems?if_exists}"/>
                  <#if !((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
                    <input type="hidden" name="maxNumberOfOrdersToPrint" value="1"/>
                    <input type="hidden" name="orderId" value="${groupName?if_exists}"/>
                  <#else>
                    <span class="label">${uiLabelMap.FormFieldTitle_printPickSheetFirst}</span>
                    <input type="text" size="4" name="maxNumberOfOrdersToPrint" value="20"/>
                  </#if>
                  <button class="btn btn-small btn-primary" type="submit">
                  <i class="icon-ok"></i>
                  ${uiLabelMap.FormFieldTitle_printPickSheet}
                  </button>
                </form>
              <#else>
                &nbsp;
              </#if>
            </td>
          </tr>
          <#-- toggle the row color -->
          <#assign alt_row = !alt_row>
        </#list>
        <#if ((requestParameters.groupByShippingMethod?exists && requestParameters.groupByShippingMethod == "Y") || (requestParameters.groupByWarehouseArea?exists && requestParameters.groupByWarehouseArea == "Y") || (requestParameters.groupByNoOfOrderItems?exists && requestParameters.groupByNoOfOrderItems == "Y"))>
          <tr<#if alt_row> class="alternate-row"</#if>>
            <th>${uiLabelMap.CommonAllMethods}</div></th>
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <th>${orderReadyToPickInfoListSizeTotal}</div></th>
            <th>${orderNeedsStockMoveInfoListSizeTotal}</div></th>
            <td>
              <#if (orderReadyToPickInfoListSizeTotal > 0)>
                <form method="post" action="<@ofbizUrl>createPicklistFromOrders</@ofbizUrl>">
                  <input type="hidden" name="facilityId" value="${facilityId?if_exists}"/>
                  <span class="label">${uiLabelMap.ProductPickFirst}</span>
                  <input type="text" size="4" name="maxNumberOfOrders" value="20"/>
                  <button class="btn btn-small btn-primary" type="submit">
                  <i class="icon-ok"></i>
                  ${uiLabelMap.ProductCreatePicklist}
                  </button>
                </form>
              <#else>
                &nbsp;
              </#if>
            </td>
            <td>
              <#if (orderReadyToPickInfoListSizeTotal > 0)>
                <form method="post" action="<@ofbizUrl>printPickSheets</@ofbizUrl>">
                  <input type="hidden" name="facilityId" value="${facilityId?if_exists}"/>
                  <span class="label">${uiLabelMap.FormFieldTitle_printPickSheetFirst}</span>
                  <input type="text" size="4" name="maxNumberOfOrdersToPrint" value="20"/>
                  <button class="btn btn-small btn-primary" type="submit">
                  <i class="icon-ok"></i>
                  ${uiLabelMap.FormFieldTitle_printPickSheet}
                  </button>
                </form>
              <#else>
                &nbsp;
              </#if>
            </td>
          </tr>
        </#if>
      <#else>
        <tr><td colspan="4"><p class="alert alert-info">${uiLabelMap.ProductNoOrdersFoundReadyToPickOrNeedStockMoves}.</p></td></tr>
      </#if>
    </table>
  </div>
</div>
<#assign viewDetail = requestParameters.viewDetail?if_exists>
<#if viewDetail?has_content>
  <#list pickMoveInfoList as pickMoveInfo>
    <#assign groupName = pickMoveInfo.groupName?if_exists>
    <#if groupName?if_exists == viewDetail>
      <#assign toPickList = pickMoveInfo.orderReadyToPickInfoList?if_exists>
    </#if>
  </#list>
</#if>

<#if toPickList?has_content>
  <div class="widget-box">
    <div class="widget-header">
    <h3>${uiLabelMap.ProductPickingDetail}</h3>
      <span class="alert alert-info">
      </span>
      <br class="clear"/>
    </div>
    <div class="widget-body">
      <table cellspacing="0" class="table table-hover table-striped table-bordered dataTable">
        <tr class="header-row">
          <td>${uiLabelMap.ProductOrderId}</td>
          <td>${uiLabelMap.FormFieldTitle_orderDate}</td>
          <td>${uiLabelMap.ProductChannel}</td>
          <td>${uiLabelMap.ProductOrderItem}</td>
          <td>${uiLabelMap.ProductProductDescription}</td>
          <td>${uiLabelMap.ProductOrderShipGroupId}</td>
          <td>${uiLabelMap.ProductQuantity}</td>
          <td>${uiLabelMap.ProductQuantityNotAvailable}</td>
        </tr>
        <#assign alt_row = false>
        <#list toPickList as toPick>
          <#assign oiasgal = toPick.orderItemShipGrpInvResList>
          <#assign header = toPick.orderHeader>
          <#assign channel = header.getRelatedOne("SalesChannelEnumeration", false)?if_exists>
          <#list oiasgal as oiasga>
            <#assign orderProduct = oiasga.getRelatedOne("OrderItem", false).getRelatedOne("Product", false)?if_exists>
            <#assign product = oiasga.getRelatedOne("InventoryItem", false).getRelatedOne("Product", false)?if_exists>
            <tr valign="middle"<#if alt_row> class="alternate-row"</#if>>
              <td><a href="/ordermgr/control/orderview?orderId=${oiasga.orderId}${externalKeyParam}" class="btn btn-mini btn-info" target="_blank">${oiasga.orderId}</a></td>
              <td>${header.orderDate?string}</td>
              <td>${(channel.description)?if_exists}</td>
              <td>${oiasga.orderItemSeqId}</td>
              <td>
                <a href="/catalog/control/EditProduct?productId=${orderProduct.productId?if_exists}${externalKeyParam}" class="btn btn-mini btn-info" target="_blank">${(orderProduct.internalName)?if_exists}</a>
                <#if orderProduct.productId != product.productId>
                  &nbsp;[<a href="/catalog/control/EditProduct?productId=${product.productId?if_exists}${externalKeyParam}" class="btn btn-mini btn-info" target="_blank">${(product.internalName)?if_exists}</a>]
                </#if>
              </td>
              <td>${oiasga.shipGroupSeqId}</td>
              <td>${oiasga.quantity}</td>
              <td>${oiasga.quantityNotAvailable?if_exists}</td>
            </tr>
          </#list>
          <#-- toggle the row color -->
          <#assign alt_row = !alt_row>
        </#list>
      </table>
    </div>
  </div>
</#if>