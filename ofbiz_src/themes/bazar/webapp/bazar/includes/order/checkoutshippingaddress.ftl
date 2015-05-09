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

<script type="text/javascript">
//<![CDATA[
function submitForm(form, mode, value) {
    if (mode == "DN") {
        // done action; checkout
        form.action="<@ofbizUrl>checkoutoptions</@ofbizUrl>";
        form.submit();
    } else if (mode == "CS") {
        // continue shopping
        form.action="<@ofbizUrl>updateCheckoutOptions/showcart</@ofbizUrl>";
        form.submit();
    } else if (mode == "NA") {
        // new address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?preContactMechTypeId=POSTAL_ADDRESS&contactMechPurposeTypeId=SHIPPING_LOCATION&DONE_PAGE=checkoutshippingaddress</@ofbizUrl>";
        form.submit();
    } else if (mode == "EA") {
        // edit address
        form.action="<@ofbizUrl>updateCheckoutOptions/editcontactmech?DONE_PAGE=checkoutshippingaddress&contactMechId="+value+"</@ofbizUrl>";
        form.submit();
    }
}

function toggleBillingAccount(box) {
    var amountName = box.value + "_amount";
    box.checked = true;
    box.form.elements[amountName].disabled = false;

    for (var i = 0; i < box.form.elements[box.name].length; i++) {
        if (!box.form.elements[box.name][i].checked) {
            box.form.elements[box.form.elements[box.name][i].value + "_amount"].disabled = true;
        }
    }
}

//]]>
</script>

<style type="text/css">
	a.button{
		color:#FFFFFF;
		background-color:#333333;
	}
	a.button:hover{
		color:#FFFFFF;
	}
	a.multistep_section{
		background-color:#FFFFFF !important;
	}
	a.multistep_section:hover{
		cursor:default !important;
	}
	a.current:hover{
		background:#e6e3e3 !important;
	}
	a.user_logged_in, a.passed{
		background:#f9f9f9 !important;
	}
	
	tr{
		background-color:#FFFFFF !important;
	}
</style>


<script type="text/javascript" src="/bazar/js/frontend/checkout.min.js"></script>

<#assign cart = shoppingCart?if_exists/>

<!-- START PRIMARY -->
<div id="primary" class= "sidebar -no">
	<div class="container group">
		<div class="row">
			<!-- START CONTENT -->
			<div id="content-page" class= "span12 content group">
				<div id="post-389" class= "post-389 page type-page status-publish hentry group instock">
					<div class="woocommerce" >
						<!-- START WOO -->
						
						
						
						<p class="woocommerce_info">
							Have a coupon? <a href="#" class="showcoupon">Click here to enter your code</a>
						</p>
						<form class="checkout_coupon" method="post" name="addpromocodeform" id="addpromocodeform" action="<@ofbizUrl>addpromocode<#if requestAttributes._CURRENT_VIEW_?has_content>/${requestAttributes._CURRENT_VIEW_}</#if></@ofbizUrl>" style="display: none;">
							<p class="form-row form-row-first">
								<input type="text" name="productPromoCodeId" class="input-text" placeholder="Coupon code" id="productPromoCodeId" value="">
							</p>

							<p class="form-row form-row-last">
								<a href="javascript:void(0)" type="submit" name="apply_coupon" onclick="document.getElementById('addpromocodeform').submit();" class="button">Apply Coupon</a>
							</p>

							<div class="clear"></div>
						</form>
						<div id="checkout_multistep">
							<div id="multistep_resume">
								<div>
									<span class="checkout_progress">
										<img src="/bazar/images/icons/multistep_cart.png" alt="Checkout Progress"> 
										Checkout Progress
									</span>
								</div>
								<div>
									<a href="#" data-step="1" class="user_logged_in multistep_section">Login</a>
								</div>
								<div>
									<a href="#" data-step="2" class="current multistep_section">Shilling Address</a>
								</div>
								<div>
									<a href="#" data-step="3" class="multistep_section">Shipping Options</a>
								</div>
								<div>
									<a href="#" data-step="4" class="multistep_section">Payment Method</a>
								</div>
								<div>
									<a href="#" data-step="5" class="multistep_section">Order Review</a>
								</div>
							</div>

							<div class="clear"></div>

							<div class="row">
								<div id="multistep_progress" class="span12 progress progress-striped">
									<div class="bar" style="width: 50%;"></div>
								</div>
							</div>

							<div id="multistep_steps" class="row"></div>
						</div> <!-- end checkout_multistep -->


	<h1>1.&nbsp;${uiLabelMap.OrderWhereShallWeShipIt}?</h1>
	<form method="post" name="checkoutInfoForm" id="checkoutInfoForm" style="margin:0;">
    	<input type="hidden" name="checkoutpage" value="shippingaddress"/>
		<div class="screenlet" style="height: 100%;">
        <div class="screenlet-title-bar">
            <div class="h3">
            	<hr /> <h2>${uiLabelMap.OrderMethod}</h2>
            </div>
        </div>
        <div class="screenlet-body" style="height: 100%;">
            <table width="100%" border="0" cellpadding="1" cellspacing="0">
              <tr>
                <td colspan="2">
                  <a href="<@ofbizUrl>splitship</@ofbizUrl>" class="button">${uiLabelMap.OrderSplitShipment}</a>
                  <a href="javascript:submitForm(document.getElementById('checkoutInfoForm'), 'NA', '');" class="button">${uiLabelMap.PartyAddNewAddress}</a>
                  <#if (cart.getShipGroupSize() > 1)>
                    <div style="color: red;">${uiLabelMap.OrderNOTEMultipleShipmentsExist}</div>
                  </#if>
                </td>
              </tr>
               <#if shippingContactMechList?has_content>
                 <tr><td colspan="2"><hr /><h2>${uiLabelMap.OrderShippingInformation}</h2></td></tr>
                 <#list shippingContactMechList as shippingContactMech>
                   <#assign shippingAddress = shippingContactMech.getRelatedOne("PostalAddress", false)>
                   <#assign checkThisAddress = (shippingContactMech_index == 0 && !cart.getShippingContactMechId()?has_content) || (cart.getShippingContactMechId()?default("") == shippingAddress.contactMechId)/>
                   <tr>
                     <td valign="top" width="2%" nowrap="nowrap" style="padding-top:10px;">
                       <input type="radio" name="shipping_contact_mech_id" value="${shippingAddress.contactMechId}"<#if checkThisAddress> checked="checked"</#if> />
                     </td>
                     <td valign="top" width="99%" nowrap="nowrap" style="padding-top:10px;">
                       <div>
                         <#if shippingAddress.toName?has_content><b>${uiLabelMap.CommonTo}:</b>&nbsp;${shippingAddress.toName}<br /></#if>
                         <#if shippingAddress.attnName?has_content><b>${uiLabelMap.PartyAddrAttnName}:</b>&nbsp;${shippingAddress.attnName}<br /></#if>
                         <#if shippingAddress.address1?has_content>${shippingAddress.address1}<br /></#if>
                         <#if shippingAddress.address2?has_content>${shippingAddress.address2}<br /></#if>
                         <#if shippingAddress.city?has_content>${shippingAddress.city}</#if>
                         <#if shippingAddress.stateProvinceGeoId?has_content><br />${shippingAddress.stateProvinceGeoId}</#if>
                         <#if shippingAddress.postalCode?has_content><br />${shippingAddress.postalCode}</#if>
                         <#if shippingAddress.countryGeoId?has_content><br />${shippingAddress.countryGeoId}</#if>
                         <br /><br /><a href="javascript:submitForm(document.getElementById('checkoutInfoForm'), 'EA', '${shippingAddress.contactMechId}');" class="button">${uiLabelMap.CommonUpdate}</a>
                       </div>
                     </td>
                   </tr>
                   <tr><td colspan="2"></td></tr>
                 </#list>
               </#if>
              </table>
             <div>
             	<hr />
				<h2>
					${uiLabelMap.AccountingAgreementInformation}
				</h2>
			</div>
               <table>
                 <#if agreements?exists>
                   <#if agreements.size()!=1>
                     <tr>
                       <td>&nbsp;</td>
                       <td align='left' valign='top' nowrap="nowrap">
                         <div class='tableheadtext'>
                           ${uiLabelMap.OrderSelectAgreement}
                         </div>
                       </td>
                       <td>&nbsp;</td>
                       <td valign='middle'>
                         <div class='tabletext' valign='top'>
                           <select name="agreementId">
                             <#list agreements as agreement>
                               <option value='${agreement.agreementId?if_exists}'>${agreement.agreementId} - ${agreement.description?if_exists}</option>
                             </#list>
                           </select>
                         </div>
                       </td>
                     </tr>
                   <#else>
                     <#list agreements as agreement>
                        <input type="radio" name="agreementId" value="${agreement.agreementId?if_exists}"<#if checkThisAddress> checked="checked"</#if> />${agreement.description?if_exists} will be used for this order.
                     </#list>
                   </#if>
                 </#if>
               </table>
             <br />
            <#-- Party Tax Info -->
            <div>
            	<hr />
				<h2>
					${uiLabelMap.PartyTaxIdentification}
				</h2>		
			</div>
            ${screens.render("component://order/widget/ordermgr/OrderEntryOrderScreens.xml#customertaxinfo")}
        </div>
    </div>
</form>
<br/>
<table width="100%">
  <tr valign="top">
    <td>
      &nbsp;<a href="javascript:submitForm(document.getElementById('checkoutInfoForm'), 'CS', '');" class="button">${uiLabelMap.OrderBacktoShoppingCart}</a>
    </td>
    <td align="right" style="text-align:right">
      <a href="javascript:submitForm(document.getElementById('checkoutInfoForm'), 'DN', '');" class="button">${uiLabelMap.CommonNext}</a>
    </td>
  </tr>
</table>
						
						<!-- END WOO -->
                         </div>
                    </div>
               </div>
               <!-- END CONTENT -->
          </div>
     </div>
</div>
<!-- END PRIMARY -->
