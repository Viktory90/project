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

<script language="JavaScript" type="text/javascript">
<!--
    var clicked = 0;
    function processOrder() {
        if (clicked == 0) {
            clicked++;
            //window.location.replace("<@ofbizUrl>processorder</@ofbizUrl>");
            document.${parameters.formNameValue}.processButton.value="${uiLabelMap.OrderSubmittingOrder}";
            document.${parameters.formNameValue}.processButton.disabled=true;
            document.${parameters.formNameValue}.submit();
        } else {
            showErrorAlert("${uiLabelMap.CommonErrorMessage2}","${uiLabelMap.YoureOrderIsBeingProcessed}");
        }
    }
// -->
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
</style>







<!-- START PRIMARY -->
<div id="primary" class= "sidebar -no">
	<div class="container group">
		<div class="row">
			<!-- START CONTENT -->
			<div id="content-page" class= "span12 content group">
				<div id="post-389" class= "post-389 page type-page status-publish hentry group instock">
					<div class="woocommerce" >
						<!-- START WOO -->
						<div id="checkout_multistep">
							<div id="multistep_resume">
								<div>
									<span class="checkout_progress">
										<img src="/bazar/images/icons/multistep_cart.png" alt="Checkout Progress"> 
										Checkout Progress
									</span>
								</div>
								<div>
									<a data-step="1" class="user_logged_in multistep_section">Login</a>
								</div>
								<div>
									<a data-step="2" class="passed multistep_section">Shilling Address</a>
								</div>
								<div>
									<a data-step="3" class="passed multistep_section">Shipping Options</a>
								</div>
								<div>
									<a data-step="4" class="passed multistep_section">Payment Method</a>
								</div>
								<div>
									<a data-step="5" class="current multistep_section">Order Review</a>
								</div>
							</div>

							<div class="clear"></div>

							<div class="row">
								<div id="multistep_progress" class="span12 progress progress-striped">
									<div class="bar" style="width: 100%;"></div>
								</div>
							</div>
						</div>


<h1>${uiLabelMap.OrderFinalCheckoutReview}</h1>
<#if !isDemoStore?exists && isDemoStore><p>${uiLabelMap.OrderDemoFrontNote}.</p></#if>

<#if cart?exists && 0 < cart.size()>
  ${screens.render("component://bazar/widget/OrderScreens.xml#orderheader")}
  <br />
  ${screens.render("component://bazar/widget/OrderScreens.xml#orderitems")}
  <table border="0" cellpadding="1" width="100%" class="shop_table my_account_orders">
   <tr>
      <td colspan="4">
        &nbsp;
      </td>
      <td align="right">
        <form type="post" action="<@ofbizUrl>processorder</@ofbizUrl>" name="${parameters.formNameValue}" id="${parameters.formNameValue}">
          <#if (requestParameters.checkoutpage)?has_content>
            <input type="hidden" name="checkoutpage" value="${requestParameters.checkoutpage}" />
          </#if>
          <#if (requestAttributes.issuerId)?has_content>
            <input type="hidden" name="issuerId" value="${requestAttributes.issuerId}" />
          </#if>
          <input type="button" name="processButton" value="${uiLabelMap.OrderSubmitOrder}" onclick="processOrder();" class="button" />
        </form>
        <#-- doesn't work with Safari, seems to work with IE, Mozilla <a href="#" onclick="processOrder();" class="buttontextbig">[${uiLabelMap.OrderSubmitOrder}]&nbsp;</a> -->
      </td>
    </tr>
  </table>
<#else>
  <h3>${uiLabelMap.OrderErrorShoppingCartEmpty}.</h3>
</#if>

						<!-- END WOO -->
                         </div>
                    </div>
               </div>
               <!-- END CONTENT -->
          </div>
     </div>
</div>
<!-- END PRIMARY -->
