<#macro updateOrderContactMech orderHeader contactMechTypeId contactMechList contactMechPurposeTypeId contactMechAddress title>
	<#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
	    <form name="updateOrderContactMech" method="post" action="<@ofbizUrl>updateOrderContactMech</@ofbizUrl>">
	      	<input type="hidden" name="orderId" value="${orderId?if_exists}" />
	      	<input type="hidden" name="contactMechPurposeTypeId" value="${contactMechPurpose.contactMechPurposeTypeId?if_exists}" />
	      	<input type="hidden" name="oldContactMechId" value="${contactMech.contactMechId?if_exists}" />
	      	<select name="contactMechId" class="margin-top11" style="width:auto; max-width:500px; margin:0px">
		        <#if contactMech.contactMechTypeId == "POSTAL_ADDRESS">
		          <option value="${contactMechAddress.contactMechId}">${(contactMechAddress.address1)?default("")} - ${contactMechAddress.city?default("")}</option>
		          <option value="${contactMechAddress.contactMechId}"></option>
		          <#list contactMechList as contactMech>
		            <#assign postalAddress = contactMech.getRelatedOne("PostalAddress", false)?if_exists />
		            <#assign partyContactPurposes = postalAddress.getRelated("PartyContactMechPurpose", null, null, false)?if_exists />
		            <#list partyContactPurposes as partyContactPurpose>
		              <#if contactMech.contactMechId?has_content && partyContactPurpose.contactMechPurposeTypeId == contactMechPurposeTypeId>
		                <option value="${contactMech.contactMechId?if_exists}">${(postalAddress.address1)?default("")} - ${postalAddress.city?default("")}</option>
		              </#if>
		            </#list>
		          </#list>
		        <#elseif contactMech.contactMechTypeId == "TELECOM_NUMBER">
		          <option value="${contactMechAddress.contactMechId}">${contactMechAddress.countryCode?if_exists} <#if contactMechAddress.areaCode?exists>${contactMechAddress.areaCode}-</#if>${contactMechAddress.contactNumber}</option>
		          <option value="${contactMechAddress.contactMechId}"></option>
		          <#list contactMechList as contactMech>
		             <#assign telecomNumber = contactMech.getRelatedOne("TelecomNumber", false)?if_exists />
		             <#assign partyContactPurposes = telecomNumber.getRelated("PartyContactMechPurpose", null, null, false)?if_exists />
		             <#list partyContactPurposes as partyContactPurpose>
		               <#if contactMech.contactMechId?has_content && partyContactPurpose.contactMechPurposeTypeId == contactMechPurposeTypeId>
		                  <option value="${contactMech.contactMechId?if_exists}">${telecomNumber.countryCode?if_exists} <#if telecomNumber.areaCode?exists>${telecomNumber.areaCode}-</#if>${telecomNumber.contactNumber}</option>
		               </#if>
		             </#list>
		          </#list>
		        <#elseif contactMech.contactMechTypeId == "EMAIL_ADDRESS">
		          <option value="${contactMechAddress.contactMechId}">${(contactMechAddress.infoString)?default("")}</option>
		          <option value="${contactMechAddress.contactMechId}"></option>
		          <#list contactMechList as contactMech>
		             <#assign partyContactPurposes = contactMech.getRelated("PartyContactMechPurpose", null, null, false)?if_exists />
		             <#list partyContactPurposes as partyContactPurpose>
		               <#if contactMech.contactMechId?has_content && partyContactPurpose.contactMechPurposeTypeId == contactMechPurposeTypeId>
		                  <option value="${contactMech.contactMechId?if_exists}">${contactMech.infoString?if_exists}</option>
		               </#if>
		             </#list>
		          </#list>
		        </#if>
	      	</select>
	      	<button type="submit" name="submitButton" data-rel="tooltip" title="${uiLabelMap.CommonUpdate}: ${title}" data-placement="bottom" class="btn btn-mini btn-primary"><i class="fa-floppy-o"></i></button>
	    </form>
	</#if>
</#macro>

<!-- Order general info -->
<div id="orderinfo-tab" class="tab-pane">
	<#if orderHeader.externalId?has_content>
       <#assign externalOrder = "(" + orderHeader.externalId + ")"/>
    </#if>
    <#assign orderType = orderHeader.getRelatedOne("OrderType", false)/>
    <div class="row-fluid">
    	<#--
    	<div class="span5">
    		<h4 class="smaller lighter green" style="margin:0">
				${orderType?if_exists.get("description", locale)?default(uiLabelMap.OrderOrder)}
			</h4>
    	</div>
    	-->
    	<div class="span12">
    		<#if setOrderCompleteOption>
	          	<a class="open-sans btn btn-primary btn-mini floatLeftTableContent margin-right3" href="javascript:document.OrderCompleteOrder.submit()">${uiLabelMap.OrderCompleteOrder}</a>
	          	<form name="OrderCompleteOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>">
	            	<input type="hidden" name="statusId" value="ORDER_COMPLETED"/>
	            	<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	          	</form>
	        </#if>
    		<#if currentStatus.statusId != "ORDER_COMPLETED" && currentStatus.statusId != "ORDER_CANCELLED">
	          	<a class="icon-remove open-sans btn btn-warning btn-mini tooltip-warning floatLeftTableContent margin-right3" href="javascript:document.OrderCancel.submit()">${uiLabelMap.OrderCancelOrder}</a>
	          	<form name="OrderCancel" method="post" action="<@ofbizUrl>changeOrderStatusDis/orderViewDis</@ofbizUrl>">
	            	<input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
	            	<input type="hidden" name="setItemStatus" value="Y"/>
	            	<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	            	<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	            	<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	            	<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	            	<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	          	</form>
	        </#if>
	        <#if currentStatus.statusId == "ORDER_CREATED" || currentStatus.statusId == "ORDER_PROCESSING">
	          	<a class="open-sans icon-check-square-o btn btn-primary btn-mini floatLeftTableContent margin-right3" href="javascript:document.OrderApproveOrder.submit()">${uiLabelMap.OrderApproveOrder}</a>
	          	<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatusDis/orderViewDis</@ofbizUrl>">
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
	          	<a class=" icon-lock btn btn-primary btn-mini floatLeftTableContent open-sans margin-right3" href="javascript:document.OrderHold.submit()">${uiLabelMap.OrderHold}</a>
	          	<form name="OrderHold" method="post" action="<@ofbizUrl>changeOrderStatusDis/orderViewDis</@ofbizUrl>">
	            	<input type="hidden" name="statusId" value="ORDER_HOLD"/>
	            	<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	            	<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	            	<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	            	<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	            	<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	          	</form>
	        <#elseif currentStatus.statusId == "ORDER_HOLD">
	          	<a class="btn btn-primary btn-mini icon-check-square-o open-sans floatLeftTableContent margin-right3" href="javascript:document.OrderApproveOrder.submit()">${uiLabelMap.OrderApproveOrder}</a>
	          	<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatusDis/orderViewDis</@ofbizUrl>">
	            	<input type="hidden" name="statusId" value="ORDER_APPROVED"/>
	            	<input type="hidden" name="setItemStatus" value="Y"/>
	            	<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
	            	<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
	            	<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
	            	<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
	            	<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
	          	</form>
	        </#if>
	        <#if currentStatus.statusId == "ORDER_APPROVED" && orderHeader.orderTypeId == "SALES_ORDER">
	          	<a class="icon-print open-sans btn btn-primary btn-mini floatLeftTableContent margin-right3" href="javascript:document.PrintOrderPickSheet.submit()">${uiLabelMap.FormFieldTitle_printPickSheet}</a>
	          	<form name="PrintOrderPickSheet" method="post" action="<@ofbizUrl>orderPickSheet.pdf</@ofbizUrl>" target="_BLANK">
	            	<input type="hidden" name="facilityId" value="${storeFacilityId?if_exists}"/>
	            	<input type="hidden" name="orderId" value="${orderHeader.orderId?if_exists}"/>
	            	<input type="hidden" name="maxNumberOfOrdersToPrint" value="1"/>
	          	</form>
	        </#if>
    	</div>
    </div>
	
    <div class="row-fluid">
    	<div class="span6">
    		<h4 class="smaller green" style="display:inline-block">
				${uiLabelMap.DAOrderGeneralInfo}
			</h4>
    		<table class="table table-striped table-bordered dataTable table-hover table-decrease-padding" cellspacing='0'>
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
		             		<hr style="margin: 5px 0"/>
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
		          	<td align="right" valign="top">&nbsp;${uiLabelMap.DACreateDate}</td>
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
		              	${productStore.storeName!}&nbsp;<a href="viewProductStoreDis?productStoreId=${productStore.productStoreId}${externalKeyParam}" target="_blank" class="open-sans">(${productStore.productStoreId})</a>
		            </td>
		      	</tr>
		        </#if>
		        <tr>
		          	<td align="right" valign="top" >&nbsp;${uiLabelMap.OrderOriginFacility}</td>
		          	<td valign="top">
		              	<#if orderHeader.originFacilityId?has_content>
		                	<a href="editFacilityDis?facilityId=${orderHeader.originFacilityId}${externalKeyParam}" target="_blank" class="open-sans">${orderHeader.originFacilityId}</a>
		              	<#else>
		                	${uiLabelMap.CommonNA}
		              	</#if>
		          	</td>
		        </tr>
		        <tr>
		          	<td align="right" valign="top" >&nbsp;${uiLabelMap.CommonCreatedBy}</td>
		          	<td valign="top">
		              	<#if orderHeader.createdBy?has_content>
		                	<a href="/partymgr/control/viewprofile?userlogin_id=${orderHeader.createdBy}${externalKeyParam}" target="partymgr" class="open-sans">${orderHeader.createdBy}</a>
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
		          	</td>
		        </tr>
		        </#if>
		        <#if orderContentWrapper.get("IMAGE_URL")?has_content>
		        <tr>
		          	<td align="right" valign="top" >&nbsp;${uiLabelMap.OrderImage}</td>
		          	<td valign="top">
		              	<a href="<@ofbizUrl>viewimage?orderId=${orderId}&amp;orderContentTypeId=IMAGE_URL</@ofbizUrl>" target="_orderImage" class="open-sans">${uiLabelMap.OrderViewImage}</a>
		          	</td>
		        </tr>
		        </#if>
		        <#if "SALES_ORDER" == orderHeader.orderTypeId>
		            <tr>
		              	<td align="right" valign="top" >&nbsp;${uiLabelMap.FormFieldTitle_priority}</td>
		              	<td valign="top">
		                 	<form name="setOrderReservationPriority" method="post" action="<@ofbizUrl>setOrderReservationPriority</@ofbizUrl>">
			                 	<input type = "hidden" name="orderId" value="${orderId}"/>
			                	<select name="priority" style="margin-bottom:0">
			                  		<option value="1" <#if (orderHeader.priority)?if_exists == "1">selected="selected" </#if>>${uiLabelMap.CommonHigh}</option>
			                  		<option value="2" <#if (orderHeader.priority)?if_exists == "2">selected="selected" <#elseif !(orderHeader.priority)?has_content>selected="selected"</#if>>${uiLabelMap.CommonNormal}</option>
			                  		<option value="3" <#if (orderHeader.priority)?if_exists == "3">selected="selected" </#if>>${uiLabelMap.CommonLow}</option>
			                	</select>
			            		<button type="submit" data-rel="tooltip" title="${uiLabelMap.CommonUpdate}: ${uiLabelMap.FormFieldTitle_priority}" data-placement="bottom" class="btn btn-mini btn-primary"><i class="fa-floppy-o"></i></button>
		                	</form>
		              	</td>
		            </tr>
		        </#if>
		        <#--
		        <tr>
		          	<td align="right" valign="top" >&nbsp;${uiLabelMap.AccountingInvoicePerShipment}</td>
		          	<td valign="top">
		             	<form name="setInvoicePerShipment" method="post" action="<@ofbizUrl>setInvoicePerShipment</@ofbizUrl>">
			             	<input type = "hidden" name="orderId" value="${orderId}"/>
			        		<select name="invoicePerShipment">
				              	<option value="Y" <#if (orderHeader.invoicePerShipment)?if_exists == "Y">selected="selected" </#if>>${uiLabelMap.CommonYes}</option>
				              	<option value="N" <#if (orderHeader.invoicePerShipment)?if_exists == "N">selected="selected" </#if>>${uiLabelMap.CommonNo}</option>
			            	</select>
			            	<button type="submit" class="btn btn-primary btn-mini">
			            		<i class="icon-ok"></i>${uiLabelMap.CommonUpdate}
			        		</button>
		            	</form>
		          	</td>
		        </tr>
		        <#if orderHeader.isViewed?has_content && orderHeader.isViewed == "Y">
		        <tr>
		          <td >${uiLabelMap.OrderViewed}</td>
		          <td valign="top">
		            ${uiLabelMap.CommonYes}
		          </td>
		        </tr>
		        <#else>
		        <tr id="isViewed">
		          <td >${uiLabelMap.OrderMarkViewed}</td>
		          <td valign="top">
		            <form id="orderViewed" action="">
		              <label>
						<input type="checkbox" name="checkViewed" onclick="javascript:markOrderViewed();"/><span class="lbl">Quote Items</span>
					  </label>
		              <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
		              <input type="hidden" name="isViewed" value="Y"/>
		            </form>
		          </td>
		        </tr>
		        <tr id="viewed" style="display: none;">
		          <td >${uiLabelMap.OrderViewed}</td>
		          <td valign="top">
		            ${uiLabelMap.CommonYes}
		          </td>
		        </tr>
		        </#if>
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
		                  				<i class="icon-remove open-sans"></i>${uiLabelMap.DAUnMark}
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
    	</div>
    	<div class="span6">
    		<#if displayParty?has_content || orderContactMechValueMaps?has_content>
				<h4 class="smaller green" style="display:inline-block">
					${uiLabelMap.OrderContactInformation}
				</h4>
		      	<table class="table table-striped table-bordered table-hover dataTable" cellspacing='0' style="width: 100%">
			        <tr>
			          	<td align="left" valign="top" width="24%"><span>&nbsp;${uiLabelMap.CommonName}</span></td>
			          	<td valign="top" width="75%">
				            <div>
				              	<#if displayParty?has_content>
				                	<#assign displayPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", displayParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
				                	${displayPartyNameResult.fullName?default("[${uiLabelMap.OrderPartyNameNotFound}]")}
				              	</#if>
				              	<#if partyId?exists><#-- <a href="${customerDetailLink?if_exists}${partyId}${externalKeyParam}".../> -->
				                	&nbsp;(<a href="javascript:void(0);" target="partymgr">${partyId}</a>)&nbsp;
				                	<#if orderHeader.salesChannelEnumId != "POS_SALES_CHANNEL">
				                		<div style="display:inline-block;">
							                <#if hasCreated>
							                	<#-- /ordermgr/control/orderentry?partyId=${partyId}&amp;orderTypeId=${orderHeader.orderTypeId} -->
							                   	<a href="<@ofbizUrl>newSalesOrderDis?partyId=${partyId}&amp;orderTypeId=${orderHeader.orderTypeId}</@ofbizUrl>" class="btn btn-mini btn-primary">${uiLabelMap.OrderNewOrder}</a>
							                </#if>
				                   			<a href="javascript:document.searchOtherOrders.submit()" target="_blank"><i class="fa-search"></i> ${uiLabelMap.OrderOtherOrders}</a>
				                		</div>
					                  	<form name="searchOtherOrders" method="post" action="<@ofbizUrl>searchOrders</@ofbizUrl>">
						                    <input type="hidden" name="lookupFlag" value="Y"/>
						                    <input type="hidden" name="hideFields" value="Y"/>
						                    <input type="hidden" name="partyId" value="${partyId}" />
						                    <input type="hidden" name="viewIndex" value="1"/>
						                    <input type="hidden" name="viewSize" value="20"/>
					                  	</form>
				                	</#if>
				              	</#if>
			            	</div>
			          	</td>
		        	</tr>
			        <#list orderContactMechValueMaps as orderContactMechValueMap>
			          	<#assign contactMech = orderContactMechValueMap.contactMech>
			          	<#assign contactMechPurpose = orderContactMechValueMap.contactMechPurposeType>
			          	<tr>
		            		<td align="left" valign="top" width="24%">
				              	<span>${contactMechPurpose.get("description",locale)}</span>
				            </td>
				            <td valign="top" width="75%">
				              	<#if contactMech.contactMechTypeId == "POSTAL_ADDRESS">
				                	<#assign postalAddress = orderContactMechValueMap.postalAddress>
				                	<#if postalAddress?has_content>
				                		<div class="row-fluid">
				                			<div class="span5">
				                				${setContextField("postalAddress", postalAddress)}
					                     		${screens.render("component://party/widget/partymgr/PartyScreens.xml#postalAddressHtmlFormatter")}
				                			</div>
				                			<div class="span7">
				                				<@updateOrderContactMech orderHeader=orderHeader?if_exists contactMechTypeId=contactMech.contactMechTypeId contactMechList=postalContactMechList?if_exists contactMechPurposeTypeId=contactMechPurpose.contactMechPurposeTypeId?if_exists contactMechAddress=postalAddress?if_exists title=contactMechPurpose.get("description",locale)/>
				                			</div>
				                		</div>
				                	</#if>
				              	<#elseif contactMech.contactMechTypeId == "TELECOM_NUMBER">
				                	<#assign telecomNumber = orderContactMechValueMap.telecomNumber>
				                	<div class="row-fluid">
			                			<div class="span5">
					                  		${telecomNumber.countryCode?if_exists}
					                  		<#if telecomNumber.areaCode?exists>${telecomNumber.areaCode}-</#if>${telecomNumber.contactNumber}
				                  			<#--<#if partyContactMech.extension?exists>ext&nbsp;${partyContactMech.extension}</#if>-->
						                  	<#if !telecomNumber.countryCode?exists || telecomNumber.countryCode == "011" || telecomNumber.countryCode == "1">
						                    	<a target="_blank" href="${uiLabelMap.CommonLookupAnywhoLink}" class="btn btn-mini btn-primary">${uiLabelMap.CommonLookupAnywho}</a>
						                   		<a target="_blank" href="${uiLabelMap.CommonLookupWhitepagesTelNumberLink}" class="btn btn-mini btn-primary">${uiLabelMap.CommonLookupWhitepages}</a>
						                  	</#if>
				                		</div>
				                		<div class="span7">
				                			<@updateOrderContactMech orderHeader=orderHeader?if_exists contactMechTypeId=contactMech.contactMechTypeId contactMechList=telecomContactMechList?if_exists contactMechPurposeTypeId=contactMechPurpose.contactMechPurposeTypeId?if_exists contactMechAddress=telecomNumber?if_exists title=contactMechPurpose.get("description",locale)/>
				                		</div>
				                	</div>
			                	<#elseif contactMech.contactMechTypeId == "EMAIL_ADDRESS">
				                	<div class="row-fluid">
			                			<div class="span5">
					                  		${contactMech.infoString}
					                  		<#if security.hasEntityPermission("ORDERMGR", "_SEND_CONFIRMATION", session)>
					                     		(<a href="<@ofbizUrl>confirmationmailedit?orderId=${orderId}&amp;partyId=${partyId}&amp;sendTo=${contactMech.infoString}</@ofbizUrl>" class="btn btn-mini btn-primary">${uiLabelMap.OrderSendConfirmationEmail}</a>)
					                  		<#else>
					                     		<a href="mailto:${contactMech.infoString}" class="btn btn-mini btn-primary">(${uiLabelMap.OrderSendEmail})</a>
					                  		</#if>
				                		</div>
				                		<div class="span7">
				                			<@updateOrderContactMech orderHeader=orderHeader?if_exists contactMechTypeId=contactMech.contactMechTypeId contactMechList=emailContactMechList?if_exists contactMechPurposeTypeId=contactMechPurpose.contactMechPurposeTypeId?if_exists contactMechAddress=contactMech?if_exists title=contactMechPurpose.get("description",locale)/>
				                		</div>
				                	</div>
			                	<#elseif contactMech.contactMechTypeId == "WEB_ADDRESS">
				                	<div>
				                  		${contactMech.infoString}
				                  		<#assign openString = contactMech.infoString>
				                  		<#if !openString?starts_with("http") && !openString?starts_with("HTTP")>
				                    		<#assign openString = "http://" + openString>
				                  		</#if>
				                  		<a target="_blank" href="${openString}" class="btn btn-mini btn-primary">(open&nbsp;page&nbsp;in&nbsp;new&nbsp;window)</a>
			                		</div>
				              	<#else>
				                	<div>
				                  		${contactMech.infoString?if_exists}
				                	</div>
				              	</#if>
			            	</td>
			          	</tr>
		        	</#list>
		      	</table>
			</#if>
			<#if orderHeader?has_content>
				<h4 class="smaller lighter green" style="display:inline-block">
					<#-- <i class="fa-file"></i> -->
					${uiLabelMap.OrderNotes}
				</h4>
				<div>
			     	<#if security.hasEntityPermission("ORDERMGR", "_NOTE", session)>
			      		<a class="btn btn-primary btn-mini margin-bottom8" href="<@ofbizUrl>createNewNote?${paramString}</@ofbizUrl>">${uiLabelMap.OrderNotesCreateNew}</a>
				  	</#if>
			    	<#if orderNotes?has_content>
			            <table class="table table-striped table-bordered table-hover" cellspacing='0'>
			              	<#list orderNotes as note>
			                	<tr>
			                  		<td valign="top" width="30%">
			                    		<#if note.noteParty?has_content>
			                      			<div>&nbsp;${uiLabelMap.CommonBy}:&nbsp;${Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, note.noteParty, true)}</div>
			                    		</#if>
			                    		<div>&nbsp;${uiLabelMap.DAAt}:&nbsp;<#if note.noteDateTime?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(note.noteDateTime, "", locale, timeZone)!}</#if></div>
			                  		</td>
			                  		<td valign="top" width="50%">
			                    		${note.noteInfo?replace("\n", "<br/>")}
			                  		</td>
			                  		<td align="right" valign="top" width="20%">
					                    <#if note.internalNote?if_exists == "N">
					                        ${uiLabelMap.OrderPrintableNote}
					                        <form name="privateNotesForm_${note_index}" method="post" action="<@ofbizUrl>updateOrderNote</@ofbizUrl>">
					                          	<input type="hidden" name="orderId" value="${orderId}"/>
					                          	<input type="hidden" name="noteId" value="${note.noteId}"/>
					                          	<input type="hidden" name="internalNote" value="Y"/>
					                          	<a href="javascript:document.privateNotesForm_${note_index}.submit()" class="btn btn-mini btn-primary">${uiLabelMap.OrderNotesPrivate}</a>
					                        </form>
					                    </#if>
			                    		<#if note.internalNote?if_exists == "Y">
					                        ${uiLabelMap.OrderNotPrintableNote}
					                        <form name="publicNotesForm_${note_index}" method="post" action="<@ofbizUrl>updateOrderNote</@ofbizUrl>">
					                          	<input type="hidden" name="orderId" value="${orderId}"/>
					                          	<input type="hidden" name="noteId" value="${note.noteId}"/>
					                          	<input type="hidden" name="internalNote" value="N"/>
					                          	<a href="javascript:document.publicNotesForm_${note_index}.submit()" class="btn btn-mini btn-primary">${uiLabelMap.OrderNotesPublic}</a>
					                        </form>
			                    		</#if>
			                  		</td>
			                	</tr>
			                	<#--<#if note_has_next>
			                  		<tr><td colspan="3"><hr/></td></tr>
			            		</#if>-->
			              	</#list>
			        	</table>
			        <#else>
			          	<div> <p class="alert alert-info">${uiLabelMap.OrderNoNotes}.</p></div>
			        </#if>
				</div>
			</#if>
    	</div><!--.span6-->
    </div><!--.row-fluid-->
</div> <!--#orderinfo-tab-->
<script type="text/javascript">
	$('[data-rel=tooltip]').tooltip();
</script>