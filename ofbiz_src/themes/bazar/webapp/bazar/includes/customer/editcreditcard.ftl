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

<style type="text/css">
	a.button{
		color:#FFFFFF;
		background-color:#333333;
	}
	a.button:hover{
		color:#FFFFFF;
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

<#if canNotView>
  <h3>${uiLabelMap.AccountingCardInfoNotBelongToYou}.</h3>
<a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="button">${uiLabelMap.CommonGoBack}</a>
<#else>
  <#if !creditCard?exists>
      <h2>${uiLabelMap.AccountingAddNewCreditCard}</h2>
      <form method="post" action="<@ofbizUrl>createCreditCard?DONE_PAGE=${donePage}</@ofbizUrl>" name="editcreditcardform">
      <div>
    <#else>
      <h2>${uiLabelMap.AccountingEditCreditCard}</h2>
      <form method="post" action="<@ofbizUrl>updateCreditCard?DONE_PAGE=${donePage}</@ofbizUrl>" name="editcreditcardform">
        <div>
        <input type="hidden" name="paymentMethodId" value="${paymentMethodId}" />
    </#if>      
      &nbsp;<a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="button">${uiLabelMap.CommonGoBack}</a>
      &nbsp;<a href="javascript:document.editcreditcardform.submit()" class="button">${uiLabelMap.CommonSave}</a>  
      <p/>
      <table width="90%" border="0" cellpadding="2" cellspacing="10">
         ${screens.render("component://bigshop/widget/CommonScreens.xml#creditCardFields")}
         <tr>
           <td align="right" valign="top">${uiLabelMap.PartyBillingAddress}</td>
           <td>&nbsp;</td>
           <td>
        <#-- Removed because is confusing, can add but would have to come back here with all data populated as before...
        <a href="<@ofbizUrl>editcontactmech</@ofbizUrl>" class="buttontext">
          [Create New Address]</a>&nbsp;&nbsp;
        -->
             <table width="100%" border="0" cellpadding="1">
             <#assign hasCurrent = false />
             <#if curPostalAddress?has_content>
               <#assign hasCurrent = true />
               <tr>
                 <td align="right" valign="top">
                   <input type="radio" name="contactMechId" value="${curContactMechId}" checked="checked" />
                 </td>
                 <td valign="top">
                   ${uiLabelMap.PartyUseCurrentAddress}:
                   <#list curPartyContactMechPurposes as curPartyContactMechPurpose>
                     <#assign curContactMechPurposeType = curPartyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true) />
                     <div>
                       ${curContactMechPurposeType.get("description",locale)?if_exists}
                       <#if curPartyContactMechPurpose.thruDate?exists>
                         ((${uiLabelMap.CommonExpire}:${curPartyContactMechPurpose.thruDate.toString()})
                       </#if>
                     </div>
                   </#list>
                   <div>
                   <#if curPostalAddress.toName?exists>${uiLabelMap.CommonTo}: ${curPostalAddress.toName}<br /></#if>
                   <#if curPostalAddress.attnName?exists>${uiLabelMap.PartyAddrAttnName}: ${curPostalAddress.attnName}<br /></#if>
                     ${curPostalAddress.address1?if_exists}<br />
                   <#if curPostalAddress.address2?exists>${curPostalAddress.address2}<br /></#if>
                     ${curPostalAddress.city}<#if curPostalAddress.stateProvinceGeoId?has_content>,&nbsp;${curPostalAddress.stateProvinceGeoId}</#if>&nbsp;${curPostalAddress.postalCode}
                   <#if curPostalAddress.countryGeoId?exists><br />${curPostalAddress.countryGeoId}</#if>
                   <div>(${uiLabelMap.CommonUpdated}:&nbsp;${(curPartyContactMech.fromDate.toString())?if_exists})</div>
                   <#if curPartyContactMech.thruDate?exists><div>${uiLabelMap.CommonDelete}:&nbsp;${curPartyContactMech.thruDate.toString()}</#if>
                   </div>
                 </td>
               </tr>
             <#else>
           <#-- <tr>
            <td valign="top" colspan="2">
              <div>${uiLabelMap.PartyBillingAddressNotSelected}</div>
            </td>
          </tr> -->
             </#if>
          <#-- is confusing
          <tr>
            <td valign="top" colspan="2">
              <div>${uiLabelMap.EcommerceMessage3}</div>
            </td>
          </tr>
          -->
             <#list postalAddressInfos as postalAddressInfo>
               <#assign contactMech = postalAddressInfo.contactMech />
               <#assign partyContactMechPurposes = postalAddressInfo.partyContactMechPurposes />
               <#assign postalAddress = postalAddressInfo.postalAddress />
               <#assign partyContactMech = postalAddressInfo.partyContactMech />
               <tr>
                 <td align="right" valign="top">
                   <input type="radio" name="contactMechId" value="${contactMech.contactMechId}" />
                 </td>
                 <td valign="middle">
                   <#list partyContactMechPurposes as partyContactMechPurpose>
                     <#assign contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true) />
                     <div>
                       ${contactMechPurposeType.get("description",locale)?if_exists}
                       <#if partyContactMechPurpose.thruDate?exists>(${uiLabelMap.CommonExpire}:${partyContactMechPurpose.thruDate})</#if>
                     </div>
                   </#list>
                   <div>
                     <#if postalAddress.toName?exists>${uiLabelMap.CommonTo}: ${postalAddress.toName}<br /></#if>
                     <#if postalAddress.attnName?exists>${uiLabelMap.PartyAddrAttnName}: ${postalAddress.attnName}<br /></#if>
                     ${postalAddress.address1?if_exists}<br />
                     <#if postalAddress.address2?exists>${postalAddress.address2}<br /></#if>
                     ${postalAddress.city}<#if postalAddress.stateProvinceGeoId?has_content>,&nbsp;${postalAddress.stateProvinceGeoId}</#if>&nbsp;${postalAddress.postalCode}
                     <#if postalAddress.countryGeoId?exists><br />${postalAddress.countryGeoId}</#if>
                   </div>
                   <div>(${uiLabelMap.CommonUpdated}:&nbsp;${(partyContactMech.fromDate.toString())?if_exists})</div>
                   <#if partyContactMech.thruDate?exists><div>${uiLabelMap.CommonDelete}:&nbsp;${partyContactMech.thruDate.toString()}</div></#if>
                 </td>
               </tr>
               </#list>
               <#if !postalAddressInfos?has_content && !curContactMech?exists>
                 <tr><td colspan="2"><div>${uiLabelMap.PartyNoContactInformation}.</div></td></tr>
               </#if>
               <tr>
                 <td align="right" valign="top">
                   <input type="radio" name="contactMechId" value="_NEW_" <#if !hasCurrent>checked="checked"</#if> />
                 </td>
                 <td valign="middle">
                   <span>${uiLabelMap.PartyCreateNewBillingAddress}.</span>
                 </td>
               </tr>
             </table>
           </td>
         </tr>
       </table>
       </div>
     </form>  
  &nbsp;<a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="button">${uiLabelMap.CommonGoBack}</a>
  &nbsp;<a href="javascript:document.editcreditcardform.submit()" class="button">${uiLabelMap.CommonSave}</a>  
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

