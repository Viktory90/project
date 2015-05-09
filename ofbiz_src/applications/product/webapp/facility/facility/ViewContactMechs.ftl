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

<div>
<input type="hidden" value="${facilityId}" name="facilityId"/>
<a id="idLink" href="<@ofbizUrl>EditContactMech?facilityId=${facilityId}</@ofbizUrl>" class="open-sans icon-plus-sign">${uiLabelMap.CommonCreateNew}</a>
  <#if contactMeches?has_content>
    <table class="basic-table" style="width: 100%" cellspacing="0">
      <#list contactMeches as contactMechMap>
          <#assign contactMech = contactMechMap.contactMech>
          <#assign facilityContactMech = contactMechMap.facilityContactMech>
          <tr><td colspan="4"></td></tr>
          <tr style="float: left;">
            <td valign="top">
              <b class="blue margin-left10">${contactMechMap.contactMechType.get("description",locale)}</b>
            </td>
            <td style="width: 5%"></td>
            <td valign="top">
              <#list contactMechMap.facilityContactMechPurposes as facilityContactMechPurpose>
                  <#assign contactMechPurposeType = facilityContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
                      <#if contactMechPurposeType?has_content>
                        <b>${contactMechPurposeType.get("description",locale)}</b>
                      <#else>
                        <b>${uiLabelMap.ProductPurposeTypeNotFoundWithId}: "${facilityContactMechPurpose.contactMechPurposeTypeId}"</b>
                      </#if>
                      <#if facilityContactMechPurpose.thruDate?has_content>
                      (${uiLabelMap.CommonExpire}: ${facilityContactMechPurpose.thruDate.toString()})
                      </#if>
                      <br />
              </#list>
              <#if "POSTAL_ADDRESS" = contactMech.contactMechTypeId>
                  <#assign postalAddress = contactMechMap.postalAddress>
                    <#if postalAddress.toName?has_content><b>${uiLabelMap.CommonTo}:</b> ${postalAddress.toName}<br /></#if>
                    <#if postalAddress.attnName?has_content><b>${uiLabelMap.CommonAttn}:</b> ${postalAddress.attnName}<br /></#if>
                    ${postalAddress.address1?if_exists}<br />
                    <#if postalAddress.address2?has_content>${postalAddress.address2?if_exists}<br /></#if>
                    ${postalAddress.city?if_exists},
                    ${postalAddress.stateProvinceGeoId?if_exists}
                    ${postalAddress.postalCode?if_exists}
                    <#if postalAddress.countryGeoId?has_content><br />${postalAddress.countryGeoId}</#if>
                  <#if (postalAddress?has_content && !postalAddress.countryGeoId?has_content) || postalAddress.countryGeoId = "USA">
                      <#assign addr1 = postalAddress.address1?if_exists>
                      <#if (addr1.indexOf(" ") > 0)>
                        <#assign addressNum = addr1.substring(0, addr1.indexOf(" "))>
                        <#assign addressOther = addr1.substring(addr1.indexOf(" ")+1)>
                        <br /><a class="btn btn-info btn-mini" target='_blank' href='${uiLabelMap.CommonLookupWhitepagesAddressLink}' >${uiLabelMap.CommonLookupWhitepages}</a>
                      </#if>
                  </#if>
                  <#if postalAddress.geoPointId?has_content>
                    <#if contactMechPurposeType?has_content>
                      <#assign popUptitle = contactMechPurposeType.get("description",locale) + uiLabelMap.CommonGeoLocation>
                    </#if>
                    <br /><a class="btn btn-info btn-mini" href="javascript:popUp('<@ofbizUrl>geoLocation?geoPointId=${postalAddress.geoPointId}</@ofbizUrl>', '${popUptitle?if_exists}', '450', '550')">${uiLabelMap.CommonGeoLocation}</a>
                  </#if>
              <#elseif "TELECOM_NUMBER" = contactMech.contactMechTypeId>
                  <#assign telecomNumber = contactMechMap.telecomNumber>
                    ${telecomNumber.countryCode?if_exists}
                    <#if telecomNumber.areaCode?has_content>${telecomNumber.areaCode}-</#if>${telecomNumber.contactNumber?if_exists}
                    <#if facilityContactMech.extension?has_content>${uiLabelMap.CommonExt} ${facilityContactMech.extension}</#if>
                    <#if (telecomNumber?has_content && !telecomNumber.countryCode?has_content) || telecomNumber.countryCode = "011">
                      <br /><a class="btn btn-info btn-mini" target='_blank' href='${uiLabelMap.CommonLookupAnywhoLink}' >${uiLabelMap.CommonLookupAnywho}</a>
                      <a class="btn btn-info btn-mini" target='_blank' href='${uiLabelMap.CommonLookupWhitepagesTelNumberLink}' >${uiLabelMap.CommonLookupWhitepages}</a>
                    </#if>
              <#elseif "EMAIL_ADDRESS" = contactMech.contactMechTypeId>
                    ${contactMech.infoString?if_exists}
                    <a class="btn btn-info btn-mini" href='mailto:${contactMech.infoString?if_exists}' >${uiLabelMap.CommonSendEmail}</a>
              <#elseif "WEB_ADDRESS" = contactMech.contactMechTypeId>
                    ${contactMech.infoString?if_exists}
                    <#assign openAddress = contactMech.infoString?default("")>
                    <#if !openAddress?starts_with("http") && !openAddress?starts_with("HTTP")><#assign openAddress = "http://" + openAddress></#if>
                    <a class="btn btn-info btn-mini" target='_blank' href='${openAddress}' >((${uiLabelMap.CommonOpenPageNewWindow})</a>
              <#else>
                    ${contactMech.infoString?if_exists}
              </#if>
              <br />(${uiLabelMap.CommonUpdated}: ${facilityContactMech.fromDate.toString()})
              <#if facilityContactMech.thruDate?has_content><br /><b>${uiLabelMap.CommonUpdatedEffectiveThru}:&nbsp;${facilityContactMech.thruDate.toString()}</b></#if>
            </td>
            <td class="button-col">
              &nbsp;
              <#if security.hasEntityPermission("FACILITY", "_UPDATE", session)>
                <a class="open-sans icon-refresh" href='<@ofbizUrl>EditContactMech?facilityId=${facilityId}&amp;contactMechId=${contactMech.contactMechId}</@ofbizUrl>'>${uiLabelMap.CommonUpdate}</a>
              </#if>
              <#if security.hasEntityPermission("FACILITY", "_DELETE", session)>
                <form action="<@ofbizUrl>deleteContactMech/ViewContactMechs</@ofbizUrl>" name="deleteContactForm_${contactMechMap_index}" method="post">
                  <input type="hidden" name="facilityId" value="${facilityId?if_exists}"/>
                  <input type="hidden" name="contactMechId" value="${contactMech.contactMechId?if_exists}"/>
                </form>
                <a class="icon-remove open-sans" href="javascript:document.deleteContactForm_${contactMechMap_index}.submit()">${uiLabelMap.CommonExpire}</a>
              </#if>
            </td>
          </tr>
      </#list>
    </table>
  <#else>
    <div class="screenlet-body"><p class="alert alert-info">${uiLabelMap.CommonNoContactInformationOnFile}.</p></div>
  </#if>
</div>