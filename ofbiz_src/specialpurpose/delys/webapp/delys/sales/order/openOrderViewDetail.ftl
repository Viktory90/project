<div class="row-fluid">
	<div class="span12">
		<div class="widget-box transparent" id="recent-box">
			<div class="widget-header" style="border-bottom:none">
				<div style="width:100%; border-bottom: 1px solid #c5d0dc"><#--widget-toolbar no-border-->
					<div class="row-fluid">
						<div class="span10">
							<div class="tabbable">
								<ul class="nav nav-tabs" id="recent-tab"><#-- nav-tabs-menu-->
									<#if orderHeader?has_content>
										<#-- 
										<#if security.hasEntityPermission("DELYS_ORDER", "_APPROVE", session)>
											<li class="active">
												<a data-toggle="tab" href="#orderoverview-tab">${uiLabelMap.DAOverview}</a>
											</li>
											<li>
												<a data-toggle="tab" href="#orderinfo-tab">${uiLabelMap.DAOrderGeneralInfo}</a>
											</li>
										<#else>
											<li class="active">
												<a data-toggle="tab" href="#orderinfo-tab">${uiLabelMap.DAOrderGeneralInfo}</a>
											</li>
										</#if>
										-->
										
										<li class="active">
											<a data-toggle="tab" href="#orderoverview-tab">${uiLabelMap.DAOverview}</a>
										</li>
										<li>
											<a data-toggle="tab" href="#orderinfo-tab">${uiLabelMap.DAOrderGeneralInfo}</a>
										</li>
										
										<#if orderTerms?has_content>
										<li>
											<a data-toggle="tab" href="#terms-tab">${uiLabelMap.DAOrderTerms}</a>
										</li>
										</#if>
										
										<li>
											<a data-toggle="tab" href="#payment-tab">${uiLabelMap.DAPayment}</a>
										</li>
										
										<#if security.hasEntityPermission("PROJECTMGR", "_VIEW", session)>
										<li>
											<a data-toggle="tab" href="#projectAssoOrder-tab">Project Asso</a>
										</li>
										</#if>
										
										<#--<#if displayParty?has_content || orderContactMechValueMaps?has_content>
										<li>
											<a data-toggle="tab" href="#contactinfo-tab">${uiLabelMap.DAContact}</a>
										</li>
										</#if>-->
										
										<#if (security.hasEntityPermission("ORDERMGR", "_UPDATE", session) && (!orderHeader.salesChannelEnumId?exists || orderHeader.salesChannelEnumId != "POS_SALES_CHANNEL")) || (shipGroups?has_content && (!orderHeader.salesChannelEnumId?exists || orderHeader.salesChannelEnumId != "POS_SALES_CHANNEL"))>
										<li>
											<a data-toggle="tab" href="#actions-tab">
												<#if (security.hasEntityPermission("ORDERMGR", "_UPDATE", session) && (!orderHeader.salesChannelEnumId?exists || orderHeader.salesChannelEnumId != "POS_SALES_CHANNEL"))>
													${uiLabelMap.OrderActions}</#if>
											</a>
										</li>
										<li>
											<a data-toggle="tab" href="#shippinginfo-tab">
												<#if (shipGroups?has_content && (!orderHeader.salesChannelEnumId?exists || orderHeader.salesChannelEnumId != "POS_SALES_CHANNEL"))>
													${uiLabelMap.DAShipment}</#if></a>
										</li>
										</#if>
										
										<#if salesReps?has_content>
										<li>
											<a data-toggle="tab" href="#salesreps-tab">${uiLabelMap.OrderSalesReps}</a>
										</li>
										</#if>
										
										<li>
											<a data-toggle="tab" href="#items-tab">${uiLabelMap.DAOrderItem}</a><#--DAOrderItems-->
										</li>
										
										<li>
											<a data-toggle="tab" href="#deliveries-tab">${uiLabelMap.Delivery}</a>
										</li>
										
										<#--
										<#if security.hasEntityPermission("DELYS_ORDER", "_APPROVE", session)>
											<li>
												<a data-toggle="tab" href="#balance-tab">${uiLabelMap.DABalance}</a>
											</li>
										</#if>
										-->
										
										<#--
										<li>
											<a data-toggle="tab" href="#notes-tab">${uiLabelMap.OrderNotes}</a>
										</li>
										-->
									</#if>
									<#if inProcess?exists>
										<li>
											<a data-toggle="tab" href="#transitions-tab">${uiLabelMap.OrderProcessingTransitions}</a>
										</li>
									</#if>
								</ul>
							</div><!--.tabbable-->
						</div>
						<div class="span2" style="height:34px; text-align:right">
							<#--list buttons action to order-->
								<#if orderHeader.externalId?has_content>
							       <#assign externalOrder = "(" + orderHeader.externalId + ")"/>
							    </#if>
							    <#assign orderType = orderHeader.getRelatedOne("OrderType", false)/>
								<#--
								icon-remove open-sans btn btn-warning btn-mini tooltip-warning floatLeftTableContent margin-right3
								icon-remove open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3
								-->
						      	<#if hasPrinted>
									<#if currentStatus.statusId == "ORDER_APPROVED" && orderHeader.orderTypeId == "SALES_ORDER">
										<#--icon-print open-sans btn btn-primary btn-mini floatLeftTableContent margin-right3 -->
										<a href="javascript:document.PrintOrderPickSheet.submit()" data-rel="tooltip" title="${uiLabelMap.FormFieldTitle_printPickSheet}" data-placement="bottom" class="button-action"><i class="icon-print open-sans"></i></a>
										<form name="PrintOrderPickSheet" method="post" action="<@ofbizUrl>orderPickSheet.pdf</@ofbizUrl>" target="_BLANK" style="position: absolute;">
											<input type="hidden" name="facilityId" value="${storeFacilityId?if_exists}"/>
											<input type="hidden" name="orderId" value="${orderHeader.orderId?if_exists}"/>
											<input type="hidden" name="maxNumberOfOrdersToPrint" value="1"/>
										</form>
						            </#if>
						        </#if>   
							    <#if currentStatus.statusId == "ORDER_CREATED" || currentStatus.statusId == "ORDER_PROCESSING">
									<#if hasApproved>
										<#--icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderApproveOrder.submit()" data-rel="tooltip" title="${uiLabelMap.DAActionApprove}" data-placement="bottom" class="button-action"><i class="icon-check-square-o open-sans"></i></a>
										<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position: absolute;">
											<input type="hidden" name="statusId" value="ORDER_APPROVED"/>
											<input type="hidden" name="newStatusId" value="ORDER_APPROVED"/>
											<input type="hidden" name="setItemStatus" value="Y"/>
											<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
											<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
											<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
											<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
											<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
											<input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								<#elseif currentStatus.statusId == "ORDER_APPROVED">
									<#if hasHoled>
										<#--icon-lock open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderHold.submit()" data-rel="tooltip" title="${uiLabelMap.OrderHold}" data-placement="bottom" class="button-action"><i class="icon-check-square-o open-sans"></i></a>
										<form name="OrderHold" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position: absolute;">
											<input type="hidden" name="statusId" value="ORDER_HOLD"/>
											<input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
											<input type="hidden" name="orderId" value="${orderId?if_exists}"/>
											<input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
											<input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
											<input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
											<input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								<#elseif currentStatus.statusId == "ORDER_HOLD">
									<#if hasApproved>
										<#--icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderApproveOrder.submit()" data-rel="tooltip" title="${uiLabelMap.DAActionApprove}" data-placement="bottom" class="button-action"><i class="icon-check-square-o open-sans"></i></a>
										<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position: absolute;">
							                <input type="hidden" name="statusId" value="ORDER_APPROVED"/>
							                <input type="hidden" name="setItemStatus" value="Y"/>
							                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
							                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
							                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
							                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
							                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								</#if>
								<#if currentStatus.statusId != "ORDER_COMPLETED" && currentStatus.statusId != "ORDER_CANCELLED">
									<#if hasCancel><#--btn btn-warning btn-mini tooltip-warning -->
										<a href="javascript:document.OrderCancel.submit()" data-rel="tooltip" title="${uiLabelMap.OrderCancelOrder}" data-placement="bottom" class="button-action"><i class="fa fa-times-circle"></i></a>
										<form name="OrderCancel" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position: absolute;">
							                <input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
							                <input type="hidden" name="setItemStatus" value="Y"/>
							                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
							                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
							                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
							                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
							                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								</#if>
								<#if setOrderCompleteOption>
									<#if hasCompleted>
										<#--open-sans btn btn-primary btn-mini floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderCompleteOrder.submit()" data-rel="tooltip" title="${uiLabelMap.OrderCompleteOrder}" data-placement="bottom" class="button-action"><i class="fa fa-star"></i></a>
										<form name="OrderCompleteOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
							                <input type="hidden" name="statusId" value="ORDER_COMPLETED"/>
							                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								</#if>
								
								<#if currentStatus.statusId == "ORDER_CREATED">
									<#if hasSupApproved == "TRUE">
										<#--icon-remove open-sans btn btn-warning btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderCancel.submit()" data-rel="tooltip" title="${uiLabelMap.OrderCancelOrder}" data-placement="bottom" class="button-action"><i class="fa fa-times-circle"></i></a>
										<form name="OrderCancel" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position: absolute;">
							                <input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
							                <input type="hidden" name="setItemStatus" value="Y"/>
							                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
							                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
							                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
							                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
							                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
							                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
						              	</form>
						              	<#--icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderSupApprove.submit()" data-rel="tooltip" title="${uiLabelMap.DAActionApprove}" data-placement="bottom" class="button-action"><i class="icon-check-square-o open-sans"></i></a>
										<form name="OrderSupApprove" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position: absolute;">
							                <input type="hidden" name="orderId" value="${orderId?if_exists}" />
											<input type="hidden" name="statusId" value="ORDER_SUPAPPROVED" />
											<input type="hidden" name="setItemStatus" value="Y" />
											<input type="hidden" name="changeReason" value="" />
											<input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								</#if>
								<#if currentStatus.statusId == "ORDER_SUPAPPROVED">
									<#if hasSadApproved == "TRUE">
										<#--icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
										<a href="javascript:document.OrderSadApprove.submit()" data-rel="tooltip" title="${uiLabelMap.DAActionApprove}" data-placement="bottom" class="button-action"><i class="icon-check-square-o open-sans"></i></a>
										<form name="OrderSadApprove" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
							                <input type="hidden" name="orderId" value="${orderId}" />
											<input type="hidden" name="statusId" value="ORDER_SADAPPROVED" />
											<input type="hidden" name="setItemStatus" value="Y" />
											<input type="hidden" name="changeReason" value="" />
											<input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
										</form>
									</#if>
								</#if>
								<#--Start Code New-->
								<#--
								Code Old
								<#if currentStatus.statusId == "ORDER_CREATED">
									<#if hasSadApproved == "TRUE">
										<a class="icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3" href="javascript:document.OrderSadApprove.submit()">${uiLabelMap.DAAcceptOrder}</a>
										<form name="OrderSadApprove" method="post" action="<@ofbizUrl>changeOrderStatus/orderView</@ofbizUrl>">
							                <input type="hidden" name="orderId" value="${orderId}" />
											<input type="hidden" name="statusId" value="ORDER_SADAPPROVED" />
											<input type="hidden" name="setItemStatus" value="Y" />
											<input type="hidden" name="changeReason" value="" />
										</form>
									</#if>
								</#if>-->
								<#--End Code New-->
								<#if currentStatus.statusId == "ORDER_NPPAPPROVED">
									<#if hasChiefAccountantApproved == "TRUE">
										<#if currentStatus.statusId == "ORDER_APPROVED" && orderHeader.orderTypeId == "SALES_ORDER">
											<#--icon-print open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
											<a href="javascript:document.PrintOrderPickSheet.submit()" data-rel="tooltip" title="${uiLabelMap.FormFieldTitle_printPickSheet}" data-placement="bottom" class="button-action"><i class="icon-print open-sans"></i></a>
							              	<form name="PrintOrderPickSheet" method="post" action="<@ofbizUrl>orderPickSheet.pdf</@ofbizUrl>" target="_BLANK" style="position:absolute;">
							                	<input type="hidden" name="facilityId" value="${storeFacilityId?if_exists}"/>
							                	<input type="hidden" name="orderId" value="${orderHeader.orderId?if_exists}"/>
							                	<input type="hidden" name="maxNumberOfOrdersToPrint" value="1"/>
							                	<input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
							              	</form>
							            </#if>
							            <#if currentStatus.statusId != "ORDER_COMPLETED" && currentStatus.statusId != "ORDER_CANCELLED">
							              	<#--icon-remove open-sans btn btn-warning btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
											<a href="javascript:document.OrderCancel.submit()" data-rel="tooltip" title="${uiLabelMap.OrderCancelOrder}" data-placement="bottom" class="button-action"><i class="fa fa-times-circle"></i></a>
							              	<form name="OrderCancel" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
								                <input type="hidden" name="statusId" value="ORDER_CANCELLED"/>
								                <input type="hidden" name="setItemStatus" value="Y"/>
								                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
								                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
								                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
								                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
								                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
								                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
							              	</form>
							            </#if>
							            <#--<#if currentStatus.statusId == "ORDER_CREATED" || currentStatus.statusId == "ORDER_PROCESSING" || currentStatus.statusId == "ORDER_NPPAPPROVED">-->
							            <#if currentStatus.statusId == "ORDER_PROCESSING" || currentStatus.statusId == "ORDER_NPPAPPROVED">
							              	<#--icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
											<a href="javascript:document.OrderApproveOrder.submit()" data-rel="tooltip" title="${uiLabelMap.DAActionApprove}" data-placement="bottom" class="button-action"><i class="icon-check-square-o open-sans"></i></a>
						              		<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
								                <input type="hidden" name="statusId" value="ORDER_APPROVED"/>
								                <input type="hidden" name="newStatusId" value="ORDER_APPROVED"/>
								                <input type="hidden" name="setItemStatus" value="Y"/>
								                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
								                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
								                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
								                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
								                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
								                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
							              	</form>
							            <#elseif currentStatus.statusId == "ORDER_APPROVED">
							            	<#--icon-lock open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
											<a href="javascript:document.OrderHold.submit()" data-rel="tooltip" title="${uiLabelMap.OrderHold}" data-placement="bottom" class="button-action"><i class="icon-lock open-sans"></i></a>
							              	<form name="OrderHold" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
								                <input type="hidden" name="statusId" value="ORDER_HOLD"/>
								                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
								                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
								                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
								                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
								                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
								                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
							              	</form>
							            <#elseif currentStatus.statusId == "ORDER_HOLD">
							            	<#--icon-check-square-o open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
											<a href="javascript:document.OrderApproveOrder.submit()" data-rel="tooltip" title="${uiLabelMap.DAActionApprove}" data-placement="bottom" class="button-action"><i class="icon-lock open-sans"></i></a>
							              	<form name="OrderApproveOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
								                <input type="hidden" name="statusId" value="ORDER_APPROVED"/>
								                <input type="hidden" name="setItemStatus" value="Y"/>
								                <input type="hidden" name="workEffortId" value="${workEffortId?if_exists}"/>
								                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
								                <input type="hidden" name="partyId" value="${assignPartyId?if_exists}"/>
								                <input type="hidden" name="roleTypeId" value="${assignRoleTypeId?if_exists}"/>
								                <input type="hidden" name="fromDate" value="${fromDate?if_exists}"/>
							                	<input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
							              	</form>
							            </#if>
							            <#if setOrderCompleteOption>
							            	<#--open-sans btn btn-primary btn-mini tooltip-warning floatLeftTableContent margin-right3 -->
											<a href="javascript:document.OrderCompleteOrder.submit()" data-rel="tooltip" title="${uiLabelMap.OrderCompleteOrder}" data-placement="bottom" class="button-action"><i class="fa fa-star"></i></a>
							              	<form name="OrderCompleteOrder" method="post" action="<@ofbizUrl>changeOrderStatus</@ofbizUrl>" style="position:absolute;">
								                <input type="hidden" name="statusId" value="ORDER_COMPLETED"/>
								                <input type="hidden" name="orderId" value="${orderId?if_exists}"/>
								                <input type="hidden" name="ntfId" value="${parameters.ntfId?if_exists}">
							              	</form>
							            </#if>
									</#if>
								</#if>
							<#-- end -->
							
							<#if orderHeader?has_content>
								<#if security.hasPermission("ORDERMGR_UPDATE", session)>
									<a href="<@ofbizUrl>editOrderItemsSales?${paramString}</@ofbizUrl>" data-rel="tooltip" title="${uiLabelMap.DAEditOrderItems}" data-placement="bottom" class="button-action"><i class="icon-edit open-sans"></i></a>
								</#if>
								<a href="<@ofbizUrl>orderpr.pdf?orderId=${orderId}</@ofbizUrl>" target="_blank" data-rel="tooltip" title="${uiLabelMap.DAExportToPDF}" data-placement="bottom" class="button-action"><i class="fa-file-pdf-o"></i></a>
							</#if>
						</div>
					</div>
					<script type="text/javascript">
						$('[data-rel=tooltip]').tooltip();
					</script>
					<style type="text/css">
						.button-action {
							font-size:18px; padding:0 0 0 8px;
						}
					</style>
				</div>
			</div>

			<div class="widget-body" style="margin-top: -12px !important">
				<div class="widget-main padding-4">
					<div class="tab-content overflow-visible" style="padding:8px 0">
					