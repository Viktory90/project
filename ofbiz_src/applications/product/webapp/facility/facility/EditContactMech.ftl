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

<#if !mechMap.facilityContactMech?exists && mechMap.contactMech?exists>
  <p><h3>${uiLabelMap.PartyContactInfoNotBelongToYou}.</h3></p>
  &nbsp;<a href="<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>" class="icon-arrow-left icon-on-left"> ${uiLabelMapCommon.Back}</a>
<#else>
  <#if !mechMap.contactMech?exists>
    <#-- When creating a new contact mech, first select the type, then actually create -->
    <#if !preContactMechTypeId?has_content>
    <div class="button-bar">
      <a href='<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>' class='margin-top10'><i class="icon-arrow-left icon-on-left"></i>${uiLabelMap.CommonGoBack}</a>
    </div>
    <form method="post" action='<@ofbizUrl>EditContactMech</@ofbizUrl>' name="createcontactmechform">
      <input type='hidden' name='facilityId' value='${facilityId}' />
      <input type='hidden' name='DONE_PAGE' value='${donePage?if_exists}' />
      <table width="50%" class="basic-table" cellspacing="0">
        <tr>
          <td class="float-right margin-top15">${uiLabelMap.PartySelectContactType}: </td>
          <td>
            <select name="preContactMechTypeId" class="margin-top10" >
              <#list mechMap.contactMechTypes as contactMechType>
                <option value='${contactMechType.contactMechTypeId}'>${contactMechType.get("description",locale)}</option>
              </#list>
            </select>&nbsp;<a href="javascript:document.createcontactmechform.submit()" class="margin-top10 btn btn-primary btn-small">${uiLabelMap.CommonCreate} <i class="icon-arrow-right icon-on-right"></i></a>
          </td>
        </tr>
      </table>
    </form>
    </#if>
  </#if>

  <#if mechMap.contactMechTypeId?has_content>
    <#if !mechMap.contactMech?has_content>
      <div class="button-bar">
        <a href='<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>'><i class="icon-arrow-left"></i>${uiLabelMap.CommonGoBack}</a>
      </div>
      <#if contactMechPurposeType?exists>
        <div><span >(${uiLabelMap.PartyMsgContactHavePurpose}</span>"${contactMechPurposeType.get("description",locale)?if_exists}")</div>
      </#if>
      <table width="90%" class="basic-table" cellspacing="0">
        <form method="post" action='<@ofbizUrl>${mechMap.requestName}</@ofbizUrl>' name="editcontactmechform" id="editcontactmechform">
        <input type='hidden' name='DONE_PAGE' value='${donePage}' />
        <input type='hidden' name='contactMechTypeId' value='${mechMap.contactMechTypeId}' />
        <input type='hidden' name='facilityId' value='${facilityId}' />
        <#if preContactMechTypeId?exists><input type='hidden' name='preContactMechTypeId' value='${preContactMechTypeId}' /></#if>
        <#if contactMechPurposeTypeId?exists><input type='hidden' name='contactMechPurposeTypeId' value='${contactMechPurposeTypeId?if_exists}' /></#if>

        <#if paymentMethodId?exists><input type='hidden' name='paymentMethodId' value='${paymentMethodId}' /></#if>

        <tr>
          <td >${uiLabelMap.PartyContactPurposes}</td>
          <td>
            <select name='contactMechPurposeTypeId' class="required">
              <option></option>
              <#list mechMap.purposeTypes as contactMechPurposeType>
                <option value='${contactMechPurposeType.contactMechPurposeTypeId}'>${contactMechPurposeType.get("description",locale)}</option>
               </#list>
            </select>
          *</td>
        </tr>
    <#else>
      <div class="button-bar">
        <a href='<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>' class='icon-arrow-left icon-on-left'>${uiLabelMap.CommonGoBack}</a>
        &nbsp;
        <a href="<@ofbizUrl>EditContactMech?facilityId=${facilityId}</@ofbizUrl>" class="icon-plus">${uiLabelMap.CommonCreateNew}</a>
      </div>
      <table class="basic-table" cellspacing="0">
        <#if mechMap.purposeTypes?has_content>
        <tr>
          <td valign="top" >${uiLabelMap.PartyContactPurposes}</td>
          <td>
            <table class="basic-table" cellspacing="0">
            <#if mechMap.facilityContactMechPurposes?has_content>
              <#assign alt_row = false>
              <#list mechMap.facilityContactMechPurposes as facilityContactMechPurpose>
                <#assign contactMechPurposeType = facilityContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
                <tr valign="middle"<#if alt_row> class="alternate-row"</#if>>
                  <td>
                      <#if contactMechPurposeType?has_content>
                        <b>${contactMechPurposeType.get("description",locale)}</b>
                      <#else>
                        <b>${uiLabelMap.PartyMechPurposeTypeNotFound}: "${facilityContactMechPurpose.contactMechPurposeTypeId}"</b>
                      </#if>
                      (${uiLabelMap.CommonSince}: ${facilityContactMechPurpose.fromDate})
                      <#if facilityContactMechPurpose.thruDate?has_content>(${uiLabelMap.CommonExpires}: ${facilityContactMechPurpose.thruDate.toString()}</#if>
                      <a href="javascript:document.getElementById('deleteFacilityContactMechPurpose_${facilityContactMechPurpose_index}').submit();" class="btn btn-mini btn-danger icon-trash"> ${uiLabelMap.CommonDelete}</a>
                  </td>
                </tr>
                <#-- toggle the row color -->
                <#assign alt_row = !alt_row>
                <form id="deleteFacilityContactMechPurpose_${facilityContactMechPurpose_index}" method="post" action="<@ofbizUrl>deleteFacilityContactMechPurpose</@ofbizUrl>">
                  <input type="hidden" name="facilityId" value="${facilityId?if_exists}" />
                  <input type="hidden" name="contactMechId" value="${contactMechId?if_exists}" />
                  <input type="hidden" name="contactMechPurposeTypeId" value="${(facilityContactMechPurpose.contactMechPurposeTypeId)?if_exists}" />
                  <input type="hidden" name="fromDate" value="${(facilityContactMechPurpose.fromDate)?if_exists}" />
                  <input type="hidden" name="DONE_PAGE" value="${donePage?if_exists}" />
                  <input type="hidden" name="useValues" value="true" />
                </form>
              </#list>
              </#if>
              <tr>
                <td>
                  <form method="post" action='<@ofbizUrl>createFacilityContactMechPurpose?DONE_PAGE=${donePage}&amp;useValues=true</@ofbizUrl>' name='newpurposeform'>
                  <input type="hidden" name='facilityId' value='${facilityId}' />
                  <input type="hidden" name='contactMechId' value='${contactMechId?if_exists}' />
                    <select name='contactMechPurposeTypeId'>
                      <option></option>
                      <#list mechMap.purposeTypes as contactMechPurposeType>
                        <option value='${contactMechPurposeType.contactMechPurposeTypeId}'>${contactMechPurposeType.get("description",locale)}</option>
                      </#list>
                    </select>
                    &nbsp;<a href='javascript:document.newpurposeform.submit()' class='btn btn-mini btn-info icon-plus'>${uiLabelMap.PartyAddPurpose}</a>
                  </form>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        </#if>
        <form method="post" action='<@ofbizUrl>${mechMap.requestName}</@ofbizUrl>' name="editcontactmechform" id="editcontactmechform">
        <input type="hidden" name="contactMechId" value='${contactMechId}' />
        <input type="hidden" name="contactMechTypeId" value='${mechMap.contactMechTypeId}' />
        <input type="hidden" name='facilityId' value='${facilityId}' />
        </form>
    </#if>

  <#if "POSTAL_ADDRESS" = mechMap.contactMechTypeId?if_exists>
    <tr>
      <td >${uiLabelMap.PartyToName}</td>
      <td>
        <input type="text" size="30" maxlength="60" name="toName" value="${(mechMap.postalAddress.toName)?default(request.getParameter('toName')?if_exists)}" />
      </td>
    </tr>
    <tr>
      <td >${uiLabelMap.PartyAttentionName}</td>
      <td>
        <input type="text" size="30" maxlength="60" name="attnName" value="${(mechMap.postalAddress.attnName)?default(request.getParameter('attnName')?if_exists)}" />
      </td>
    </tr>
    <tr>
      <td >${uiLabelMap.PartyAddressLine1}</td>
      <td>
        <input type="text" class="required" size="30" maxlength="30" name="address1" value="${(mechMap.postalAddress.address1)?default(request.getParameter('address1')?if_exists)}" />
      *</td>
    </tr>
    <tr>
      <td >${uiLabelMap.PartyAddressLine2}</td>
      <td>
          <input type="text" size="30" maxlength="30" name="address2" value="${(mechMap.postalAddress.address2)?default(request.getParameter('address2')?if_exists)}" />
      </td>
    </tr>
    <tr>
      <td >${uiLabelMap.PartyCity}</td>
      <td>
          <input type="text" class="required" size="30" maxlength="30" name="city" value="${(mechMap.postalAddress.city)?default(request.getParameter('city')?if_exists)}" />
      *</td>
    </tr>
    <tr>
      <td >${uiLabelMap.PartyState}</td>
      <td>
        <select name="stateProvinceGeoId" id="editcontactmechform_stateProvinceGeoId">
        </select>
      </td>
    </tr>
    <tr>
      <td >${uiLabelMap.PartyZipCode}</td>
      <td>
        <input type="text" class="required" size="12" maxlength="10" name="postalCode" value="${(mechMap.postalAddress.postalCode)?default(request.getParameter('postalCode')?if_exists)}" />
      *</td>
    </tr>
    <tr>   
      <td >${uiLabelMap.CommonCountry}</td>      
      <td>     
        <select name="countryGeoId" id="editcontactmechform_countryGeoId">
          ${screens.render("component://common/widget/CommonScreens.xml#countries")}        
          <#if (mechMap.postalAddress?exists) && (mechMap.postalAddress.countryGeoId?exists)>
            <#assign defaultCountryGeoId = mechMap.postalAddress.countryGeoId>
          <#else>
           <#assign defaultCountryGeoId = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "country.geo.id.default")>
          </#if>
          <option selected="selected" value="${defaultCountryGeoId}">
            <#assign countryGeo = delegator.findOne("Geo",Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
            ${countryGeo.get("geoName",locale)}
          </option>
        </select>
      </td>
    </tr>
  <#elseif "TELECOM_NUMBER" = mechMap.contactMechTypeId?if_exists>
    <tr>
      <td >${uiLabelMap.PartyPhoneNumber}</td>
      <td>
        <input type="text" size="4" maxlength="10" name="countryCode" value="${(mechMap.telecomNumber.countryCode)?default(request.getParameter('countryCode')?if_exists)}" />
        -&nbsp;<input type="text" size="4" maxlength="10" name="areaCode" value="${(mechMap.telecomNumber.areaCode)?default(request.getParameter('areaCode')?if_exists)}" />
        -&nbsp;<input type="text" size="15" maxlength="15" name="contactNumber" value="${(mechMap.telecomNumber.contactNumber)?default(request.getParameter('contactNumber')?if_exists)}" />
        &nbsp;ext&nbsp;<input type="text" size="6" maxlength="10" name="extension" value="${(mechMap.facilityContactMech.extension)?default(request.getParameter('extension')?if_exists)}" />
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>[${uiLabelMap.CommonCountryCode}] [${uiLabelMap.PartyAreaCode}] [${uiLabelMap.PartyContactNumber}] [${uiLabelMap.PartyExtension}]</td>
    </tr>
  <#elseif "EMAIL_ADDRESS" = mechMap.contactMechTypeId?if_exists>
    <tr>
      <td >${uiLabelMap.PartyEmailAddress}</td>
      <td>
          <input type="text" class="required" size="60" maxlength="255" name="emailAddress" value="${(mechMap.contactMech.infoString)?default(request.getParameter('emailAddress')?if_exists)}" />
      *</td>
    </tr>																																																							
  <#else>
    <tr>
      <td >${mechMap.contactMechType.get("description",locale)}</td>																																		 
      <td>
          <input type="text" class="required" size="60" maxlength="255" name="infoString" value="${(mechMap.contactMech.infoString)?if_exists}" />
      *</td>
    </tr>
  </#if>
    <tr>
    	<td>&nbsp;</td>
      <td>
        <a href="javascript:document.editcontactmechform.submit()" class="btn btn-small btn-primary icon-save"> ${uiLabelMap.CommonSave}</a>
      </td>
    </tr>
  </form>
  </table>
  </#if>
</#if>