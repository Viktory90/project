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


<div id="primary" class="sidebar-no">
	<div class="container group">
		<div class="row">
			<!-- START CONTENT -->
			<div id="content-page" class="span12 content group">
				<div id="post-392"
					class="post-392 page type-page status-publish hentry group instock">
					<div class="woocommerce">
						<p class="myaccount_user">
							
						    <div class="col2-set">
						    	<div class="row">
						    		<div class="col-1" style="width:85%; margin-left:32px">
						    		Hello, <strong style="padding:0">${firstName?if_exists} ${lastName?if_exists}</strong>. From your account dashboard you
									can view your recent orders, manage your shipping and billing
									addresses and edit your profile.
									<br />
									
									<input type="hidden" id="updatedEmailContactMechId" name="emailContactMechId" value="${emailContactMechId?if_exists}"/>
								    <input type="hidden" id="updatedEmailAddress" name="updatedEmailAddress" value="${emailAddress?if_exists}"/>
								    
						    		<#if emailAddress?exists>
								        <label style="float:left; padding:0">${emailAddress?if_exists}</label> &nbsp; &nbsp;
								        <a href="mailto:${emailAddress?if_exists}" class="linkcolor">(${uiLabelMap.PartySendEmail})</a>
								    </#if>
						    		</div>
						    		<div class="col-2" style="width:10%">
						    			<a class="button" href="<@ofbizUrl>editProfile</@ofbizUrl>" style="float:right; padding-bottom:0px; height: 25px">${uiLabelMap.EcommerceEditProfile}</a>
						    		</div>
						    	</div>
						    </div>
							
						    <div id="serverError_${emailContactMechId?if_exists}" class="errorMessage"></div>
						</p>

						<h2>Recent Orders</h2>

						<table class="shop_table my_account_orders">
							<thead>
								<tr>
									<th class="order-number"><span class="nobr">Order Nbr</span></th>
									<th class="order-date"><span class="nobr">Date</span></th>
									<th class="order-status"><span class="nobr">Status</span></th>
									<th class="order-total"><span class="nobr">Amount</span></th>
									<th class="order-actions">&nbsp;</th>
								</tr>
							</thead>

							<tbody>
								<#if orderHeaderList?has_content>
						          <#list orderHeaderList as orderHeader>
						            <#assign status = orderHeader.getRelatedOne("StatusItem", true) />
									<tr class="order">
										<td class="order-number">
											<a href="<@ofbizUrl>orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>">
												${orderHeader.orderId}
											</a>
										</td>
										<td class="order-date">
											<time datetime="2013-11-20" title="1384939737">${orderHeader.orderDate.toString()}</time>
										</td>
										<td class="order-status" style="text-align: left; white-space: nowrap;">
											${status.get("description",locale)}
										</td>
										<td class="order-total">
											<@ofbizCurrency amount=orderHeader.grandTotal isoCode=orderHeader.currencyUom />
										</td>
										<td class="order-actions">
											<a href="<@ofbizUrl>orderstatus?orderId=${orderHeader.orderId}</@ofbizUrl>" class="button view">
												${uiLabelMap.CommonView}
											</a>
										</td>
									</tr>
								</#list>
						      <#else>
						          	<tr><td colspan="5">${uiLabelMap.OrderNoOrderFound}</td></tr>
						      </#if>
							</tbody>

						</table>



						<h2>My Addresses</h2>

						<p class="myaccount_address">The following addresses will be
							used on the checkout page by default.</p>

						<div class="col2-set addresses">

							<div class="col-1 address">
								<div>
									<header class="title">
										<h3>Billing Address</h3>
										<a id="updateBillToPostalAddress" href="javascript:void(0)" class="edit">${uiLabelMap.CommonEdit}</a>
									</header>
									<address>
										<#if billToContactMechId?exists>
											${firstName?if_exists} ${lastName?if_exists}<br> 
											${billToAddress1?if_exists}<br> 
											<#if billToAddress2?has_content>${billToAddress2?if_exists}<br></#if>
											${billToCity?if_exists}, 
											<#if billToStateProvinceGeoId?has_content && billToStateProvinceGeoId != "_NA_">
							                    ${billToStateProvinceGeoId}, 
							                </#if>
											${billToPostalCode?if_exists}, 
											${billToCountryGeoId?if_exists}
											<#if billToTelecomNumber?has_content>
								              <br>${billToTelecomNumber.countryCode?if_exists}-
								              ${billToTelecomNumber.areaCode?if_exists}-
								              ${billToTelecomNumber.contactNumber?if_exists}
								              <#if billToExtension?exists>-${billToExtension?if_exists}</#if>
								            </#if>
										<#else>
							            	${uiLabelMap.PartyPostalInformationNotFound}
							            </#if>
						            </address>
								</div>
								
								<div id="displayEditBillToPostalAddress" style="display: none" title="${uiLabelMap.CommonEdit}">
							        <#include "EditBillToAddress.ftl" />
							    </div>
							    <script type="text/javascript">
							        //<![CDATA[
							        jQuery("#displayEditBillToPostalAddress").dialog({autoOpen: false,width:600, modal: true,
							            buttons: {
							            '${uiLabelMap.CommonSubmit}': function() {
							                var createAddressForm = jQuery("#displayEditBillToPostalAddress");
							                $("#updateaddp").remove();
							                jQuery("<p id='updateaddp'>${uiLabelMap.CommonUpdatingData}</p>").insertBefore(createAddressForm);
							                updatePartyBillToPostalAddress();
							            },
							            '${uiLabelMap.CommonClose}': function() {
							                jQuery(this).dialog('close');
							                }
							            }
							        });
							        jQuery("#updateBillToPostalAddress").click(function(){jQuery("#displayEditBillToPostalAddress").dialog("open")});
							        //]]>
							     </script>
							</div>
							
						    
						    
						    

							<div class="col-2 address">
								<div>
									<header class="title">
										<h3>Shipping Address</h3>
										<a id="updateShipToPostalAddress" href="javascript:void(0)" class="edit">${uiLabelMap.CommonEdit}</a>
									</header>
									<address>
										<#if shipToContactMechId?exists>
											${firstName?if_exists} ${lastName?if_exists}<br> 
											${shipToAddress1?if_exists}<br> 
											<#if shipToAddress2?has_content>${shipToAddress2?if_exists}<br></#if> 
											${shipToCity?if_exists}, 
											<#if shipToStateProvinceGeoId?has_content && shipToStateProvinceGeoId != "_NA_">
							                    ${shipToStateProvinceGeoId}, 
							                </#if>
							                ${shipToPostalCode?if_exists}, 
							                ${shipToCountryGeoId?if_exists}
							                <#if shipToTelecomNumber?has_content>
								              <br>${shipToTelecomNumber.countryCode?if_exists}-
								              ${shipToTelecomNumber.areaCode?if_exists}-
								              ${shipToTelecomNumber.contactNumber?if_exists}
								              <#if shipToExtension?exists>-${shipToExtension?if_exists}</#if>
								            </#if>
						                <#else>
								            ${uiLabelMap.PartyPostalInformationNotFound}
								        </#if>
									</address>
								</div>
								<div id="displayEditShipToPostalAddress" style="display: none;" title="${uiLabelMap.CommonEdit}">
							        <#include "EditShipToAddress.ftl" />
							    </div>
							    <script type="text/javascript">
							         //<![CDATA[
							          jQuery("#displayEditShipToPostalAddress").dialog({autoOpen: false,width:600, modal: true,
							            buttons: {
							            '${uiLabelMap.CommonSubmit}': function() {
							                var createAddressForm = jQuery("#displayEditShipToPostalAddress");
							                jQuery("<p>${uiLabelMap.CommonUpdatingData}</p>").insertBefore(createAddressForm);
							                updatePartyShipToPostalAddress('submitEditShipToPostalAddress');
							            },
							            '${uiLabelMap.CommonClose}': function() {
							                jQuery(this).dialog('close');
							                }
							            }
							          });
							          jQuery("#updateShipToPostalAddress").click(function(){jQuery("#displayEditShipToPostalAddress").dialog("open")});
							          //]]>
							    </script>
							</div>


						</div>
					</div>
				</div>
				<!-- START COMMENTS -->
				<div id="comments"></div>
				<!-- END COMMENTS -->
			</div>
			<!-- END CONTENT -->



			<!-- START EXTRA CONTENT -->
			<!-- END EXTRA CONTENT -->
		</div>
	</div>
</div>







