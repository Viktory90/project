<#if party?exists>
<#-- Main Heading -->
<div class="row">
	<div class="span6">
      <h2>${uiLabelMap.PartyTheProfileOf}
        <#if person?exists>
          ${person.personalTitle?if_exists}
          ${person.firstName?if_exists}
          ${person.middleName?if_exists}
          ${person.lastName?if_exists}
          ${person.suffix?if_exists}
        <#else>
          "${uiLabelMap.PartyNewUser}"
        </#if>
      </h2>
    </div>
	<div class="span6" align="right">
      <#if showOld>
        <a href="<@ofbizUrl>viewprofile</@ofbizUrl>"><button class="btn">${uiLabelMap.PartyHideOld}</button></a>
      <#else>
        <a href="<@ofbizUrl>viewprofile?SHOW_OLD=true</@ofbizUrl>"><button class="btn">${uiLabelMap.PartyShowOld}</button></a>
      </#if>
      <#if (productStore.enableDigProdUpload)?if_exists == "Y">
        <a href="<@ofbizUrl>digitalproductlist</@ofbizUrl>"><button class="btn">${uiLabelMap.EcommerceDigitalProductUpload}</button></a>
      </#if>
    </div>
</div>

<div class="row">
	<div class="span6">

<div class="screenlet">
  <div class="boxlink">
    <a href="<@ofbizUrl>editperson</@ofbizUrl>" class="submenutextright">
    <#if person?exists>${uiLabelMap.CommonUpdate}<#else>${uiLabelMap.CommonCreate}</#if></a>
  </div>
  <h3>${uiLabelMap.PartyPersonalInformation}</h3>
  <div class="screenlet-body">
    <#if person?exists>
    <div>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td align="right">${uiLabelMap.PartyName}</td>
          <td>
              ${person.personalTitle?if_exists}
              ${person.firstName?if_exists}
              ${person.middleName?if_exists}
              ${person.lastName?if_exists}
              ${person.suffix?if_exists}
          </td>
        </tr>
      <#if person.nickname?has_content><tr><td align="right">${uiLabelMap.PartyNickName}</td><td>${person.nickname}</td></tr></#if>
      <#if person.gender?has_content><tr><td align="right">${uiLabelMap.PartyGender}</td><td>${person.gender}</td></tr></#if>
      <#if person.birthDate?exists><tr><td align="right">${uiLabelMap.PartyBirthDate}</td><td>${person.birthDate.toString()}</td></tr></#if>
      <#if person.height?exists><tr><td align="right">${uiLabelMap.PartyHeight}</td><td>${person.height}</td></tr></#if>
      <#if person.weight?exists><tr><td align="right">${uiLabelMap.PartyWeight}</td><td>${person.weight}</td></tr></#if>
      <#if person.mothersMaidenName?has_content><tr><td align="right">${uiLabelMap.PartyMaidenName}</td><td>${person.mothersMaidenName}</td></tr></#if>
      <#if person.maritalStatus?has_content><tr><td align="right">${uiLabelMap.PartyMaritalStatus}</td><td>${person.maritalStatus}</td></tr></#if>
      <#if person.socialSecurityNumber?has_content><tr><td align="right">${uiLabelMap.PartySocialSecurityNumber}</td><td>${person.socialSecurityNumber}</td></tr></#if>
      <#if person.passportNumber?has_content><tr><td align="right">${uiLabelMap.PartyPassportNumber}</td><td>${person.passportNumber}</td></tr></#if>
      <#if person.passportExpireDate?exists><tr><td align="right">${uiLabelMap.PartyPassportExpireDate}</td><td>${person.passportExpireDate.toString()}</td></tr></#if>
      <#if person.totalYearsWorkExperience?exists><tr><td align="right">${uiLabelMap.PartyYearsWork}</td><td>${person.totalYearsWorkExperience}</td></tr></#if>
      <#if person.comments?has_content><tr><td align="right">${uiLabelMap.CommonComments}</td><td>${person.comments}</td></tr></#if>
      </table>
    </div>
    <#else>
      <label>${uiLabelMap.PartyPersonalInformationNotFound}</label>
    </#if>
  </div>
</div>
    </div>
	<div class="span6">

<#-- ============================================================= -->
<div class="screenlet">
  <div class="boxlink">
    <a href="<@ofbizUrl>changepassword</@ofbizUrl>" class="submenutextright">${uiLabelMap.PartyChangePassword}</a>
  </div>
  <h3>${uiLabelMap.CommonUsername} &amp; ${uiLabelMap.CommonPassword}</h3>
  <div class="screenlet-body">
    <table width="100%" border="0" cellpadding="1">
      <tr>
        <td align="right" valign="top">${uiLabelMap.CommonUsername}</td>
        <td align="left" valign="top">${userLogin.userLoginId}</td>
      </tr>
    </table>
  </div>
</div>

    </div>
</div>

<div class="row">
	<div class="span12">

<#-- ============================================================= -->
<div class="screenlet">
  <div class="boxlink">
    <a href="<@ofbizUrl>editcontactmech</@ofbizUrl>" class="submenutextright">${uiLabelMap.CommonCreateNew}</a>
  </div>
  <h3>${uiLabelMap.PartyContactInformation}</h3>
  <div class="screenlet-body">
  	<div class="viewprofile-contact">
  <#if partyContactMechValueMaps?has_content>
    <table width="100%" border="0" cellpadding="0">
      <tr valign="bottom">
        <th class="type">${uiLabelMap.PartyContactType}</th>
        <th align="left">${uiLabelMap.CommonInformation}</th>
        <th colspan="2">${uiLabelMap.PartySolicitingOk}?</th>
        <th></th>
        <th></th>
      </tr>
      <#list partyContactMechValueMaps as partyContactMechValueMap>
        <#assign contactMech = partyContactMechValueMap.contactMech?if_exists />
        <#assign contactMechType = partyContactMechValueMap.contactMechType?if_exists />
        <#assign partyContactMech = partyContactMechValueMap.partyContactMech?if_exists />
          <tr>
            <td class="type">
              ${contactMechType.get("description",locale)}
            </td>
            <td valign="top">
              <#list partyContactMechValueMap.partyContactMechPurposes?if_exists as partyContactMechPurpose>
                <#assign contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true) />
                <div>
                  <#if contactMechPurposeType?exists>
                    ${contactMechPurposeType.get("description",locale)}
                    <#if contactMechPurposeType.contactMechPurposeTypeId == "SHIPPING_LOCATION" && (profiledefs.defaultShipAddr)?default("") == contactMech.contactMechId>
                      <span class="buttontextdisabled">${uiLabelMap.EcommerceIsDefault}</span>
                    <#elseif contactMechPurposeType.contactMechPurposeTypeId == "SHIPPING_LOCATION">
                      <form name="defaultShippingAddressForm" method="post" action="<@ofbizUrl>setprofiledefault/viewprofile</@ofbizUrl>">
                        <input type="hidden" name="productStoreId" value="${productStoreId}" />
                        <input type="hidden" name="defaultShipAddr" value="${contactMech.contactMechId}" />
                        <input type="hidden" name="partyId" value="${party.partyId}" />
                        <input type="submit" value="${uiLabelMap.EcommerceSetDefault}" class="button" />
                      </form>
                    </#if>
                  <#else>
                    ${uiLabelMap.PartyPurposeTypeNotFound}: "${partyContactMechPurpose.contactMechPurposeTypeId}"
                  </#if>
                  <#if partyContactMechPurpose.thruDate?exists>(${uiLabelMap.CommonExpire}:${partyContactMechPurpose.thruDate.toString()})</#if>
                </div>
              </#list>
              <#if contactMech.contactMechTypeId?if_exists = "POSTAL_ADDRESS">
                <#assign postalAddress = partyContactMechValueMap.postalAddress?if_exists />
                <div>
                  <#if postalAddress?exists>
                    <#if postalAddress.toName?has_content>${uiLabelMap.CommonTo}: ${postalAddress.toName}<br /></#if>
                    <#if postalAddress.attnName?has_content>${uiLabelMap.PartyAddrAttnName}: ${postalAddress.attnName}<br /></#if>
                    ${postalAddress.address1}<br />
                    <#if postalAddress.address2?has_content>${postalAddress.address2}<br /></#if>
                    ${postalAddress.city}<#if postalAddress.stateProvinceGeoId?has_content>,&nbsp;${postalAddress.stateProvinceGeoId}</#if>&nbsp;${postalAddress.postalCode?if_exists}
                    <#if postalAddress.countryGeoId?has_content><br />${postalAddress.countryGeoId}</#if>
                    <#if (!postalAddress.countryGeoId?has_content || postalAddress.countryGeoId?if_exists = "USA")>
                      <#assign addr1 = postalAddress.address1?if_exists />
                      <#if (addr1.indexOf(" ") > 0)>
                        <#assign addressNum = addr1.substring(0, addr1.indexOf(" ")) />
                        <#assign addressOther = addr1.substring(addr1.indexOf(" ")+1) />
                        <a target="_blank" href="${uiLabelMap.CommonLookupWhitepagesAddressLink}" class="linktext">(${uiLabelMap.CommonLookupWhitepages})</a>
                      </#if>
                    </#if>
                  <#else>
                    ${uiLabelMap.PartyPostalInformationNotFound}.
                  </#if>
                  </div>
              <#elseif contactMech.contactMechTypeId?if_exists = "TELECOM_NUMBER">
                <#assign telecomNumber = partyContactMechValueMap.telecomNumber?if_exists>
                <div>
                <#if telecomNumber?exists>
                  ${telecomNumber.countryCode?if_exists}
                  <#if telecomNumber.areaCode?has_content>${telecomNumber.areaCode}-</#if>${telecomNumber.contactNumber?if_exists}
                  <#if partyContactMech.extension?has_content>ext&nbsp;${partyContactMech.extension}</#if>
                  <#if (!telecomNumber.countryCode?has_content || telecomNumber.countryCode = "011")>
                    <a target="_blank" href="${uiLabelMap.CommonLookupAnywhoLink}" class="linktext">${uiLabelMap.CommonLookupAnywho}</a>
                    <a target="_blank" href="${uiLabelMap.CommonLookupWhitepagesTelNumberLink}" class="linktext">${uiLabelMap.CommonLookupWhitepages}</a>
                  </#if>
                <#else>
                  ${uiLabelMap.PartyPhoneNumberInfoNotFound}.
                </#if>
                </div>
              <#elseif contactMech.contactMechTypeId?if_exists = "EMAIL_ADDRESS">
                  ${contactMech.infoString}
                  <a href="mailto:${contactMech.infoString}" class="linktext">(${uiLabelMap.PartySendEmail})</a>
              <#elseif contactMech.contactMechTypeId?if_exists = "WEB_ADDRESS">
                <div>
                  ${contactMech.infoString}
                  <#assign openAddress = contactMech.infoString?if_exists />
                  <#if !openAddress.startsWith("http") && !openAddress.startsWith("HTTP")><#assign openAddress = "http://" + openAddress /></#if>
                  <a target="_blank" href="${openAddress}" class="linktext">(${uiLabelMap.CommonOpenNewWindow})</a>
                </div>
              <#else>
                ${contactMech.infoString?if_exists}
              </#if>
              <div>(${uiLabelMap.CommonUpdated}:&nbsp;${partyContactMech.fromDate.toString()})</div>
              <#if partyContactMech.thruDate?exists><div>${uiLabelMap.CommonDelete}:&nbsp;${partyContactMech.thruDate.toString()}</div></#if>
            </td>
            <td align="center" valign="top"><div>(${partyContactMech.allowSolicitation?if_exists})</div></td>
            <td>&nbsp;</td>
            <td align="right" valign="top">
              <a href="<@ofbizUrl>editcontactmech?contactMechId=${contactMech.contactMechId}</@ofbizUrl>" class="button">${uiLabelMap.CommonUpdate}</a>
            </td>
            <td align="right" valign="top">
              <form name= "deleteContactMech_${contactMech.contactMechId}" method= "post" action= "<@ofbizUrl>deleteContactMech</@ofbizUrl>">
                <div>
                <input type= "hidden" name= "contactMechId" value= "${contactMech.contactMechId}"/>
                <a href='javascript:document.deleteContactMech_${contactMech.contactMechId}.submit()' class='button'>${uiLabelMap.CommonExpire}</a>
              </div>
              </form>
            </td>
          </tr>
      </#list>
    </table>
  <#else>
    <label>${uiLabelMap.PartyNoContactInformation}.</label><br />
  </#if>
  	</div>
  </div>
</div>

    </div>
</div>

<#-- ============================================================= -->
<div class="screenlet">
  <h3>${uiLabelMap.PartyContactLists}</h3>
  <div class="screenlet-body">
    <table width="100%" border="0" cellpadding="1" cellspacing="0">
      <tr>
        <th>${uiLabelMap.EcommerceListName}</th>
        <#-- <th >${uiLabelMap.OrderListType}</th> -->
        <th>${uiLabelMap.CommonFromDate}</th>
        <th>${uiLabelMap.CommonThruDate}</th>
        <th>${uiLabelMap.CommonStatus}</th>
        <th>${uiLabelMap.CommonEmail}</th>
        <th>&nbsp;</th>
        <th>&nbsp;</th>
      </tr>
      <#list contactListPartyList as contactListParty>
      <#assign contactList = contactListParty.getRelatedOne("ContactList", false)?if_exists />
      <#assign statusItem = contactListParty.getRelatedOne("StatusItem", true)?if_exists />
      <#assign emailAddress = contactListParty.getRelatedOne("PreferredContactMech", true)?if_exists />
      <#-- <#assign contactListType = contactList.getRelatedOne("ContactListType", true)/> -->
      <tr><td colspan="7"></td></tr>
      <tr>
        <td>${contactList.contactListName?if_exists}<#if contactList.description?has_content>&nbsp;-&nbsp;${contactList.description}</#if></td>
        <#-- <td><div>${contactListType.get("description",locale)?if_exists}</div></td> -->
        <td>${contactListParty.fromDate?if_exists}</td>
        <td>${contactListParty.thruDate?if_exists}</td>
        <td>${(statusItem.get("description",locale))?if_exists}</td>
        <td>${emailAddress.infoString?if_exists}</td>
        <td>&nbsp;</td>
        <td>
          <#if (contactListParty.statusId?if_exists == "CLPT_ACCEPTED")>            
            <form method="post" action="<@ofbizUrl>updateContactListParty</@ofbizUrl>" name="clistRejectForm${contactListParty_index}">
            <div>
              <#assign productStoreId = Static["org.ofbiz.product.store.ProductStoreWorker"].getProductStoreId(request) />
              <input type="hidden" name="productStoreId" value="${productStoreId?if_exists}" />
              <input type="hidden" name="partyId" value="${party.partyId}"/>
              <input type="hidden" name="contactListId" value="${contactListParty.contactListId}"/>
              <input type="hidden" name="preferredContactMechId" value="${contactListParty.preferredContactMechId}"/>
              <input type="hidden" name="fromDate" value="${contactListParty.fromDate}"/>
              <input type="hidden" name="statusId" value="CLPT_REJECTED"/>
              <input type="submit" value="${uiLabelMap.EcommerceUnsubscribe}" class="smallSubmit"/>
              </div>
            </form>
          <#elseif (contactListParty.statusId?if_exists == "CLPT_PENDING")>
            <form method="post" action="<@ofbizUrl>updateContactListParty</@ofbizUrl>" name="clistAcceptForm${contactListParty_index}">
            <div>
              <input type="hidden" name="partyId" value="${party.partyId}"/>
              <input type="hidden" name="contactListId" value="${contactListParty.contactListId}"/>
              <input type="hidden" name="preferredContactMechId" value="${contactListParty.preferredContactMechId}"/>
              <input type="hidden" name="fromDate" value="${contactListParty.fromDate}"/>
              <input type="hidden" name="statusId" value="CLPT_ACCEPTED"/>
              <input type="text" size="10" name="optInVerifyCode" value="" class="inputBox"/>
              <input type="submit" value="${uiLabelMap.EcommerceVerifySubscription}" class="smallSubmit"/>
              </div>
            </form>
          <#elseif (contactListParty.statusId?if_exists == "CLPT_REJECTED")>
            <form method="post" action="<@ofbizUrl>updateContactListParty</@ofbizUrl>" name="clistPendForm${contactListParty_index}">
            <div>
              <input type="hidden" name="partyId" value="${party.partyId}"/>
              <input type="hidden" name="contactListId" value="${contactListParty.contactListId}"/>
              <input type="hidden" name="preferredContactMechId" value="${contactListParty.preferredContactMechId}"/>
              <input type="hidden" name="fromDate" value="${contactListParty.fromDate}"/>
              <input type="hidden" name="statusId" value="CLPT_PENDING"/>
              <input type="submit" value="${uiLabelMap.EcommerceSubscribe}" class="smallSubmit"/>
              </div>
            </form>
          </#if>
        </td>
      </tr>
      </#list>
    </table>
    <hr/>
    <div>
      <form method="post" action="<@ofbizUrl>createContactListParty</@ofbizUrl>" name="clistPendingForm">
        <div>
        <input type="hidden" name="partyId" value="${party.partyId}"/>
        <input type="hidden" name="statusId" value="CLPT_PENDING"/>
        <span class="tableheadtext">${uiLabelMap.EcommerceNewListSubscription}: </span>
        <select name="contactListId" class="selectBox">
          <#list publicContactLists as publicContactList>
            <#-- <#assign publicContactListType = publicContactList.getRelatedOne("ContactListType", true)> -->
            <#assign publicContactMechType = publicContactList.getRelatedOne("ContactMechType", true)?if_exists />
            <option value="${publicContactList.contactListId}">${publicContactList.contactListName?if_exists} <#-- ${publicContactListType.get("description",locale)} --> <#if publicContactMechType?has_content>[${publicContactMechType.get("description",locale)}]</#if></option>
          </#list>
        </select>
        <select name="preferredContactMechId" class="selectBox">
        <#-- <option></option> -->
          <#list partyAndContactMechList as partyAndContactMech>
            <option value="${partyAndContactMech.contactMechId}"><#if partyAndContactMech.infoString?has_content>${partyAndContactMech.infoString}<#elseif partyAndContactMech.tnContactNumber?has_content>${partyAndContactMech.tnCountryCode?if_exists}-${partyAndContactMech.tnAreaCode?if_exists}-${partyAndContactMech.tnContactNumber}<#elseif partyAndContactMech.paAddress1?has_content>${partyAndContactMech.paAddress1}, ${partyAndContactMech.paAddress2?if_exists}, ${partyAndContactMech.paCity?if_exists}, ${partyAndContactMech.paStateProvinceGeoId?if_exists}, ${partyAndContactMech.paPostalCode?if_exists}, ${partyAndContactMech.paPostalCodeExt?if_exists} ${partyAndContactMech.paCountryGeoId?if_exists}</#if></option>
          </#list>
        </select>
        <input type="submit" value="${uiLabelMap.EcommerceSubscribe}" class="smallSubmit"/>
        </div>
      </form>
    </div>
    <label>${uiLabelMap.EcommerceListNote}</label>
  </div>
</div>

<#-- ============================================================= -->
<#if surveys?has_content>
<div class="screenlet">
  <h3>${uiLabelMap.EcommerceSurveys}</h3>
  <div class="screenlet-body">
    <table width="100%" border="0" cellpadding="1">
      <#list surveys as surveyAppl>
        <#assign survey = surveyAppl.getRelatedOne("Survey", false) />
        <tr>
          <td valign="top" width="400">${survey.surveyName?if_exists}&nbsp;-&nbsp;${survey.description?if_exists}</td>
          <td valign="top" align="right" width="100">
            <#assign responses = Static["org.ofbiz.product.store.ProductStoreWorker"].checkSurveyResponse(request, survey.surveyId)?default(0)>
            <#if (responses < 1)>${uiLabelMap.EcommerceNotCompleted}<#else>${uiLabelMap.EcommerceCompleted}</#if>
          </td>
          <#if (responses == 0 || survey.allowMultiple?default("N") == "Y")>
            <#assign surveyLabel = uiLabelMap.EcommerceTakeSurvey />
            <#if (responses > 0 && survey.allowUpdate?default("N") == "Y")>
              <#assign surveyLabel = uiLabelMap.EcommerceUpdateSurvey />
            </#if>
            <td align="right"><a href="<@ofbizUrl>takesurvey?productStoreSurveyId=${surveyAppl.productStoreSurveyId}</@ofbizUrl>" class="button">${surveyLabel}</a></td>
          </#if>
        </tr>
      </#list>
    </table>
  </div>
</div>
</#if>

<#-- ============================================================= -->
<#-- only 5 messages will show; edit the ViewProfile.groovy to change this number -->
${screens.render("component://shopfine/widget/CustomerScreens.xml#messagelist-include")}

${screens.render("component://shopfine/widget/CustomerScreens.xml#FinAccountList-include")}

<#-- Serialized Inventory Summary -->
${screens.render('component://shopfine/widget/CustomerScreens.xml#SerializedInventorySummary')}

<#-- Subscription Summary -->
${screens.render('component://shopfine/widget/CustomerScreens.xml#SubscriptionSummary')}

<#-- Reviews -->
${screens.render('component://shopfine/widget/CustomerScreens.xml#showProductReviews')}

<#else>
    <h3>${uiLabelMap.PartyNoPartyForCurrentUserName}: ${userLogin.userLoginId}</h3>
</#if>
