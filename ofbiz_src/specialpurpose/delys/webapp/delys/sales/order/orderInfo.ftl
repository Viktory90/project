<!-- Order general info -->
<#--
<#if security.hasEntityPermission("DELYS_ORDER", "_APPROVE", session)>
<div id="orderinfo-tab" class="tab-pane">
<#else>
<div id="orderinfo-tab" class="tab-pane active">
</#if>
-->
<div id="orderinfo-tab" class="tab-pane">
	<#if orderHeader.externalId?has_content>
       <#assign externalOrder = "(" + orderHeader.externalId + ")"/>
    </#if>
    <#assign orderType = orderHeader.getRelatedOne("OrderType", false)/>
	<h4 class="smaller lighter green" style="display:inline-block">
		<#-- <i class="fa-file"></i> -->
		${orderType?if_exists.get("description", locale)?default(uiLabelMap.OrderOrder)}&nbsp;${uiLabelMap.CommonNbr}&nbsp;
	</h4>
	
	<!-- orderinfo... -->
	<div style="display:inline-block; display:none">
    	<a class="btn btn-primary btn-mini" href="<@ofbizUrl>orderView?orderId=${orderId}</@ofbizUrl>">${orderId}</a> 
    	${externalOrder?if_exists} &nbsp;<a href="<@ofbizUrl>order.pdf?orderId=${orderId}</@ofbizUrl>" class="btn btn-primary btn-mini" target="_blank">PDF</a>&nbsp;
	</div>
	
	<div style="width:100%;height:25px;">
		<#if hasPrinted>
			<#if currentStatus.statusId == "ORDER_APPROVED" && orderHeader.orderTypeId == "SALES_ORDER">
				<a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.PrintOrderPickSheet.submit()">${uiLabelMap.FormFieldTitle_printPickSheet}</a>
				<form name="PrintOrderPickSheet" method="post" action="<@ofbizUrl>orderPickSheet.pdf</@ofbizUrl>" target="_BLANK">
					<input type="hidden" name="facilityId" value="${storeFacilityId?if_exists}"/>
					<input type="hidden" name="orderId" value="${orderHeader.orderId?if_exists}"/>
					<input type="hidden" name="maxNumberOfOrdersToPrint" value="1"/>
				</form>
            </#if>
        </#if>   
	    <#if currentStatus.statusId == "ORDER_CREATED" || currentStatus.statusId == "ORDER_PROCESSING">
			<#if hasApproved>
				<a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderApproveOrder.submit()">${uiLabelMap.OrderApproveOrder}</a>
				<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
					<input type="hidden" name="statusId" value="ORDER_APPROVED"/>
					<input type="hidden" name="newStatusId" value="ORDER_APPROVED"/>
					<input type="hidden" name="setItemStatus" value="Y"/>
					<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
					<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
					<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
					<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
					<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
				</form>
			</#if>
		<#elseif currentStatus.statusId == "ORDER_APPROVED">
			<#if hasHoled>
				<a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderHold.submit()">${uiLabelMap.OrderHold}</a>
				<form name="OrderHold" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
					<input type="hidden" name="statusId" value="ORDER_HOLD"/>
					<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
					<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
					<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
					<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
					<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
				</form>
			</#if>
		<#elseif currentStatus.statusId == "ORDER_HOLD">
			<#if hasApproved>
				<a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderApproveOrder.submit()">${uiLabelMap.OrderApproveOrder}</a>
				<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_APPROVED"/>
	                <input type="hidden" name="setItemStatus" value="Y"/>
	                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
				</form>
			</#if>
		</#if>
		<#if currentStatus.statusId != "ORDER_COMPLETED" && currentStatus.statusId != "ORDER_CANCELLED">
			<#if hasCancel>
				<a class="btn btn-warning btn-mini tooltip-warning floatLeftTableContent margin-left3" href="javascript:document.OrderCancel.submit()">${uiLabelMap.OrderCancelOrder}</a>
				<form name="OrderCancel" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
	                <input type="hidden" name="setItemStatus" value="Y"/>
	                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
				</form>
			</#if>
		</#if>
		<#if setOrderCompleteOption>
			<#if hasCompleted>
				<a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderCompleteOrder.submit()">${uiLabelMap.OrderCompleteOrder}</a>
				<form name="OrderCompleteOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_COMPLETED"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
				</form>
			</#if>
		</#if>
		<#--
		Code Old
		<#if currentStatus.statusId == "ORDER_CREATED">
			<#if hasSupApproved == "TRUE">
				<a class="btn btn-primary btn-mini floatLeftTableContent margin-left3" href="javascript:document.OrderSupApprove.submit()">${uiLabelMap.DAApprove}</a>
				<form name="OrderSupApprove" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="orderId" value="${orderId}" />
					<input type="hidden" name="statusId" value="ORDER_SUPAPPROVED" />
					<input type="hidden" name="setItemStatus" value="Y" />
					<input type="hidden" name="changeReason" value="" />
				</form>
			</#if>
		</#if>
		<#if currentStatus.statusId == "ORDER_SUPAPPROVED">
			<#if hasSadApproved == "TRUE">
				<a class="btn btn-primary btn-mini floatLeftTableContent margin-left3" href="javascript:document.OrderSadApprove.submit()">${uiLabelMap.DAApprove}</a>
				<form name="OrderSadApprove" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="orderId" value="${orderId}" />
					<input type="hidden" name="statusId" value="ORDER_SADAPPROVED" />
					<input type="hidden" name="setItemStatus" value="Y" />
					<input type="hidden" name="changeReason" value="" />
				</form>
			</#if>
		</#if>
		-->
		<#--Start Code New-->
		<#if currentStatus.statusId == "ORDER_CREATED">
			<#if hasSadApproved == "TRUE">
				<a class="btn btn-primary btn-mini floatLeftTableContent margin-left3" href="javascript:document.OrderSadApprove.submit()">${uiLabelMap.DAAcceptOrder}</a>
				<form name="OrderSadApprove" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="orderId" value="${orderId}" />
					<input type="hidden" name="statusId" value="ORDER_SADAPPROVED" />
					<input type="hidden" name="setItemStatus" value="Y" />
					<input type="hidden" name="changeReason" value="" />
				</form>
			</#if>
		</#if>
		<#--End Code New-->
		<#if currentStatus.statusId == "ORDER_NPPAPPROVED">
			<#if hasChiefAccountantApproved == "TRUE">
				<#if currentStatus.statusId == "ORDER_APPROVED" && orderHeader.orderTypeId == "SALES_ORDER">
	              <a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.PrintOrderPickSheet.submit()">${uiLabelMap.FormFieldTitle_printPickSheet}</a>
	              <form name="PrintOrderPickSheet" method="post" action="<@ofbizUrl>orderPickSheet.pdf</@ofbizUrl>" target="_BLANK">
	                <input type="hidden" name="facilityId" value="${storeFacilityId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderHeader.orderId?if_exists}"/>
	                <input type="hidden" name="maxNumberOfOrdersToPrint" value="1"/>
	              </form>
	            </#if>
	            
	            <#if currentStatus.statusId == "ORDER_CREATED" || currentStatus.statusId == "ORDER_PROCESSING" || currentStatus.statusId == "ORDER_NPPAPPROVED">
	              <a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderApproveOrder.submit()">${uiLabelMap.OrderApproveOrder}</a>
	              <form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_APPROVED"/>
	                <input type="hidden" name="newStatusId" value="ORDER_APPROVED"/>
	                <input type="hidden" name="setItemStatus" value="Y"/>
	                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	              </form>
	            <#elseif currentStatus.statusId == "ORDER_APPROVED">
	              <a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderHold.submit()">${uiLabelMap.OrderHold}</a>
	              <form name="OrderHold" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_HOLD"/>
	                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	              </form>
	            <#elseif currentStatus.statusId == "ORDER_HOLD">
	              <a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderApproveOrder.submit()">${uiLabelMap.OrderApproveOrder}</a>
	              <form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_APPROVED"/>
	                <input type="hidden" name="setItemStatus" value="Y"/>
	                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	              </form>
	            </#if>
	            <#if currentStatus.statusId != "ORDER_COMPLETED" && currentStatus.statusId != "ORDER_CANCELLED">
	              <a class="btn btn-warning btn-mini tooltip-warning floatLeftTableContent margin-left3" href="javascript:document.OrderCancel.submit()">${uiLabelMap.OrderCancelOrder}</a>
	              <form name="OrderCancel" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
	                <input type="hidden" name="setItemStatus" value="Y"/>
	                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	              </form>
	            </#if>
	            <#if setOrderCompleteOption>
	              <a class="btn btn-primary btn-mini floatLeftTableContent" href="javascript:document.OrderCompleteOrder.submit()">${uiLabelMap.OrderCompleteOrder}</a>
	              <form name="OrderCompleteOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>">
	                <input type="hidden" name="statusId" value="ORDER_COMPLETED"/>
	                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	              </form>
	            </#if>
			</#if>
		</#if>
	</div>
	
	<table class="table table-striped table-bordered dataTable table-hover" cellspacing='0'>
		<#if orderHeader.orderName?has_content>
            <tr>
              	<td align="right" valign="top">&nbsp;${uiLabelMap.OrderOrderName}</td>
              	<td>${orderHeader.orderName?if_exists}</td>
            </tr>
		</#if>
			<#-- order status history -->
	        <tr>
	          	<td align="right" valign="top">&nbsp;${uiLabelMap.OrderStatusHistory}</td>
	          	<td valign="top"<#if currentStatus.statusCode?has_content> class="${currentStatus.statusCode}"</#if>>
	                <span class="current-status">${uiLabelMap.OrderCurrentStatus}: ${currentStatus.get("description",locale)}</span>
	                <#if orderHeaderStatuses?has_content>
	                  <hr />
	                  <#list orderHeaderStatuses as orderHeaderStatus>
	                    <#assign loopStatusItem = orderHeaderStatus.getRelatedOne("StatusItem", false)>
	                    <#assign userlogin = orderHeaderStatus.getRelatedOne("UserLogin", false)>
	                    <div>
	                      ${loopStatusItem.get("description",locale)} <#if orderHeaderStatus.statusDatetime?has_content>- ${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(orderHeaderStatus.statusDatetime, "", locale, timeZone)?default("0000-00-00 00:00:00")}</#if>
	                      &nbsp;
	                      ${uiLabelMap.CommonBy} - <#--${Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, userlogin.getString("partyId"), true)}--> [${orderHeaderStatus.statusUserLogin}]
	                    </div>
	                  </#list>
	                </#if>
	          	</td>
	    	</tr>
	        <tr>
	          	<td align="right" valign="top">&nbsp;${uiLabelMap.OrderDateOrdered}</td>
	          	<td valign="top"><#if orderHeader.orderDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(orderHeader.orderDate, "", locale, timeZone)!}</#if></td>
	        </tr>
	        <tr>
	          	<td align="right" valign="top">&nbsp;${uiLabelMap.CommonCurrency}</td>
	          	<td valign="top">${orderHeader.currencyUom?default("???")}</td>
	        </tr>
        <#if orderHeader.internalCode?has_content>
            <tr>
              	<td align="right" valign="top" >&nbsp;${uiLabelMap.OrderInternalCode}</td>
              	<td valign="top">${orderHeader.internalCode}</td>
            </tr>
        </#if>
            
            <tr>
              	<td align="right" valign="top" >&nbsp;${uiLabelMap.OrderSalesChannel}</td>
              	<td valign="top">
                  	<#if orderHeader.salesChannelEnumId?has_content>
	                    <#assign channel = orderHeader.getRelatedOne("SalesChannelEnumeration", false)>
	                    ${(channel.get("description",locale))?default("N/A")}
                  	<#else>
                    	${uiLabelMap.CommonNA}
                  	</#if>
              	</td>
            </tr>
        <#if productStore?has_content>
          	<tr>
                <td align="right" valign="top" >&nbsp;${uiLabelMap.OrderProductStore}</td>
                <td valign="top">
                  	${productStore.storeName!}&nbsp;<a href="<@ofbizUrl>editProductStore?productStoreId=${productStore.productStoreId}${externalKeyParam}</@ofbizUrl>" target="_blank" class="btn btn-mini btn-primary">(${productStore.productStoreId})</a>
                </td>
      		</tr>  
        </#if>
        
            <tr>
              	<td align="right" valign="top" >&nbsp;${uiLabelMap.OrderOriginFacility}</td>
              	<td valign="top">
                  	<#if orderHeader.originFacilityId?has_content>
                    	<a href="inventoryItemList?facilityId=${orderHeader.originFacilityId}${externalKeyParam}" target="facilitymgr" class="btn btn-mini btn-primary">${orderHeader.originFacilityId}</a>
                  	<#else>
                    	${uiLabelMap.CommonNA}
                  	</#if>
              	</td>
            </tr>
            <tr>
              	<td align="right" valign="top" >&nbsp;${uiLabelMap.CommonCreatedBy}</td>
              	<td valign="top">
                  	<#if orderHeader.createdBy?has_content>
                    	${orderHeader.createdBy}
                 	<#else>
                    	${uiLabelMap.CommonNotSet}
                  	</#if>
              	</td>
            </tr>
        <#if orderItem.cancelBackOrderDate?exists>
      		<tr>
                <td align="right" valign="top" >&nbsp;${uiLabelMap.FormFieldTitle_cancelBackOrderDate}</td>
                <td valign="top"><#if orderItem.cancelBackOrderDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(orderItem.cancelBackOrderDate, "", locale, timeZone)!}</#if></td>
          	</tr>
        </#if>
        
        <#if distributorId?exists>
            <tr>
              <td align="right" valign="top" >&nbsp;${uiLabelMap.OrderDistributor}</td>
              <td valign="top">
                  <#assign distPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", distributorId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
                  ${distPartyNameResult.fullName?default("[${uiLabelMap.OrderPartyNameNotFound}]")}
              </td>
            </tr>
        </#if>
        
        <#if affiliateId?exists>
            <tr>
              <td align="right" valign="top" >&nbsp;${uiLabelMap.OrderAffiliate}</td>
              <td valign="top">
                  <#assign affPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", affiliateId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
                  ${affPartyNameResult.fullName?default("[${uiLabelMap.OrderPartyNameNotFound}]")}
                </div>
              </td>
            </tr>
        </#if>
        
        <#if orderContentWrapper.get("IMAGE_URL")?has_content>
            <tr>
              <td align="right" valign="top" >&nbsp;${uiLabelMap.OrderImage}</td>
              <td valign="top">
                  <a href="<@ofbizUrl>viewimage?orderId=${orderId}&amp;orderContentTypeId=IMAGE_URL</@ofbizUrl>" target="_orderImage" class="btn btn-mini btn-primary">${uiLabelMap.OrderViewImage}</a>
              </td>
            </tr>
		</#if>
		
		<#--
		<#if "SALES_ORDER" == orderHeader.orderTypeId>
        	<tr>
              	<td align="right" valign="top" >&nbsp;${uiLabelMap.FormFieldTitle_priority}</td>
              	<td valign="top">
             		<form name="setOrderReservationPriority" method="post" action="<@ofbizUrl>setOrderReservationPriority</@ofbizUrl>">
                 		<input type = "hidden" name="orderId" value="${orderId}"/>
                    	<select name="priority">
                      		<option value="1" <#if (orderHeader.priority)?if_exists == "1">selected="selected" </#if>>${uiLabelMap.CommonHigh}</option>
                      		<option value="2" <#if (orderHeader.priority)?if_exists == "2">selected="selected" <#elseif !(orderHeader.priority)?has_content>selected="selected"</#if>>${uiLabelMap.CommonNormal}</option>
                      		<option value="3" <#if (orderHeader.priority)?if_exists == "3">selected="selected" </#if>>${uiLabelMap.CommonLow}</option>
                    	</select>
                    	<button type="submit" class="btn btn-primary btn-mini margin-top-nav-10">
                    		<i class="icon-ok"></i>${uiLabelMap.FormFieldTitle_reserveInventory}
                		</button>
                	</form>
              	</td>
            </tr>
        </#if>
        <tr>
          	<td align="right" valign="top" >&nbsp;${uiLabelMap.AccountingInvoicePerShipment}</td>
          	<td valign="top">
             	<form name="setInvoicePerShipment" method="post" action="<@ofbizUrl>setInvoicePerShipment</@ofbizUrl>">
             		<input type = "hidden" name="orderId" value="${orderId}"/>
            		<select name="invoicePerShipment">
              			<option value="Y" <#if (orderHeader.invoicePerShipment)?if_exists == "Y">selected="selected" </#if>>${uiLabelMap.CommonYes}</option>
              			<option value="N" <#if (orderHeader.invoicePerShipment)?if_exists == "N">selected="selected" </#if>>${uiLabelMap.CommonNo}</option>
            		</select>
            		<button type="submit" class="btn btn-primary btn-mini margin-top-nav-10">
            			<i class="icon-ok"></i>${uiLabelMap.CommonUpdate}
        			</button>
            	</form>
          	</td>
        </tr>
		-->
            
        <#if orderHeader.isViewed?has_content && orderHeader.isViewed == "Y">
            <tr id="isViewed" style="display: none;">
              	<td >${uiLabelMap.OrderMarkViewed}</td>
              	<td valign="top">
                	<form id="orderViewed" action="">
                  		<label>
							<input type="checkbox" name="checkViewed" id="checkViewed" onclick="javascript:markOrderViewed();"/><span class="lbl" style="vertical-align: bottom;">&nbsp;${uiLabelMap.DAMark}</span>
				  		</label>
                  		<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
                  		<input type="hidden" name="isViewed" value="Y"/>
                	</form>
              	</td>
            </tr>
            <tr id="viewed">
              	<td >${uiLabelMap.OrderViewed}</td>
              	<td valign="top">
                	<span style="float:left; margin-right:10px">${uiLabelMap.CommonYes}</span>
                	<form id="orderUnViewed" action="" style="float:left">
                  		<label>
                  			<button type="button" class="btn btn-mini btn-primary" onclick="javascript:markOrderUnViewed();">
                  				${uiLabelMap.DAUnMark}
                  			</button>
				  		</label>
				  		<input type="hidden" name="checkViewed" value=""/>
                  		<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
                  		<input type="hidden" name="isViewed" value="N"/>
                	</form>
              	</td>
            </tr>
        <#else>
            <tr id="isViewed">
              	<td >${uiLabelMap.OrderMarkViewed}</td>
              	<td valign="top">
                	<form id="orderViewed" action="">
                  		<label>
							<input type="checkbox" name="checkViewed" id="checkViewed" onclick="javascript:markOrderViewed();"/><span class="lbl" style="vertical-align: bottom;">&nbsp;${uiLabelMap.DAMark}</span>
				  		</label>
                  		<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
                  		<input type="hidden" name="isViewed" value="Y"/>
                	</form>
              	</td>
            </tr>
            <tr id="viewed" style="display: none;">
              	<td >${uiLabelMap.OrderViewed}</td>
              	<td valign="top">
                	<span style="float:left; margin-right:10px">${uiLabelMap.CommonYes}</span>
                	<form id="orderUnViewed" action="" style="float:left">
                  		<label>
                  			<button type="button" class="btn btn-mini btn-primary" onclick="javascript:markOrderUnViewed();">
                  				${uiLabelMap.DAUnMark}
                  			</button>
				  		</label>
				  		<input type="hidden" name="checkViewed" value=""/>
                  		<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
                  		<input type="hidden" name="isViewed" value="N"/>
                	</form>
              	</td>
            </tr>
        </#if>
    </table>
</div> <!--#orderinfo-tab-->