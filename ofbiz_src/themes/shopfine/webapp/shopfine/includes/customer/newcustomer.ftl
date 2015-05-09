<#macro fieldErrors fieldName>
  <#if errorMessageList?has_content>
    <#assign fieldMessages = Static["org.ofbiz.base.util.MessageString"].getMessagesForField(fieldName, true, errorMessageList)>
    <span>
    	<#list fieldMessages as errorMsg>
        &nbsp;&nbsp;<i class="icon-remove"></i> ${errorMsg}
     	</#list>
	</span>
  </#if>
</#macro>
<#macro fieldErrorsMulti fieldName1 fieldName2 fieldName3 fieldName4>
  <#if errorMessageList?has_content>
    <#assign fieldMessages = Static["org.ofbiz.base.util.MessageString"].getMessagesForField(fieldName1, fieldName2, fieldName3, fieldName4, true, errorMessageList)>
    <ul>
      <#list fieldMessages as errorMsg>
        <li class="errorMessage">${errorMsg}</li>
      </#list>
    </ul>
  </#if>
</#macro>
				<div class="span12">
					<div class="register">

						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.PartyRequestNewAccount}</h3>
						</div><!--end titleHeader-->

						<form method="post" action="<@ofbizUrl>createcustomer${previousParams}</@ofbizUrl>" id="newuserform" name="newuserform" class="form-horizontal">
    						<input type="hidden" name="emailProductStoreId" value="${productStoreId}"/>

							<h4>&nbsp;&nbsp;&nbsp;&nbsp;1. ${uiLabelMap.PartyFullName} - ${uiLabelMap.PartyPhoneNumbers}</h4>

							<div class="control-group">
							    <label class="control-label" for="USER_FIRST_NAME">${uiLabelMap.PartyFirstName}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="USER_FIRST_NAME" id="USER_FIRST_NAME" value="${requestParameters.USER_FIRST_NAME?if_exists}"  placeholder="John"/>
      							  <@fieldErrors fieldName="USER_FIRST_NAME"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="USER_LAST_NAME">${uiLabelMap.PartyLastName}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="USER_LAST_NAME" id="USER_LAST_NAME" value="${requestParameters.USER_LAST_NAME?if_exists}"  placeholder="Doe"/>
      							  <@fieldErrors fieldName="USER_LAST_NAME"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_EMAIL">${uiLabelMap.PartyEmailAddress}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_EMAIL" id="CUSTOMER_EMAIL" value="${requestParameters.CUSTOMER_EMAIL?if_exists}"  placeholder="example@example.com"/>
      							  <@fieldErrors fieldName="CUSTOMER_EMAIL"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_HOME_CONTACT">${uiLabelMap.PartyHomePhone}:</label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_HOME_CONTACT" id="CUSTOMER_HOME_CONTACT" value="${requestParameters.CUSTOMER_HOME_CONTACT?if_exists}"  placeholder="(02)-1598-548"/>
      							  <@fieldErrors fieldName="CUSTOMER_HOME_CONTACT"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_MOBILE_CONTACT">${uiLabelMap.PartyMobilePhone}:</label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_MOBILE_CONTACT" id="CUSTOMER_MOBILE_CONTACT" value="${requestParameters.CUSTOMER_MOBILE_CONTACT?if_exists}"  placeholder="(02)-1598-548"/>
      							  <@fieldErrors fieldName="CUSTOMER_MOBILE_CONTACT"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_FAX_CONTACT">${uiLabelMap.PartyFaxNumber}:</label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_FAX_CONTACT" id="CUSTOMER_FAX_CONTACT" value="${requestParameters.CUSTOMER_FAX_CONTACT?if_exists}"  placeholder="(02)-1598-548"/>
      							  <@fieldErrors fieldName="CUSTOMER_FAX_CONTACT"/>
							    </div>
							</div><!--end control-group-->

							<h4>&nbsp;&nbsp;&nbsp;&nbsp;2. Delivery Informations</h4>

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_ADDRESS1">${uiLabelMap.PartyAddressLine1}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_ADDRESS1" id="CUSTOMER_ADDRESS1" value="${requestParameters.CUSTOMER_ADDRESS1?if_exists}"  placeholder="3st el-hikem"/>
      							  <@fieldErrors fieldName="CUSTOMER_ADDRESS1"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_ADDRESS2">${uiLabelMap.PartyAddressLine2}:</label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_ADDRESS2" id="CUSTOMER_ADDRESS2" value="${requestParameters.CUSTOMER_ADDRESS2?if_exists}"  placeholder="6st el-hikem"/>
      							  <@fieldErrors fieldName="CUSTOMER_ADDRESS2"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_CITY">${uiLabelMap.PartyCity}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_CITY" id="CUSTOMER_CITY" value="${requestParameters.CUSTOMER_CITY?if_exists}"  placeholder="Origan"/>
      							  <@fieldErrors fieldName="CUSTOMER_CITY"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_POSTAL_CODE">${uiLabelMap.PartyZipCode}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="CUSTOMER_POSTAL_CODE" id="CUSTOMER_POSTAL_CODE" value="${requestParameters.CUSTOMER_POSTAL_CODE?if_exists}"  placeholder="78675"/>
      							  <@fieldErrors fieldName="CUSTOMER_POSTAL_CODE"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_COUNTRY">${uiLabelMap.CommonCountry}: <span class="text-error">*</span></label>
							    <div class="controls">
        						  <select name="CUSTOMER_COUNTRY" id="newuserform_countryGeoId">
						            ${screens.render("component://common/widget/CommonScreens.xml#countries")}        
						            <#assign defaultCountryGeoId = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "country.geo.id.default")>
						            <option selected="selected" value="${defaultCountryGeoId}">
						                <#assign countryGeo = delegator.findOne("Geo",Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
						                ${countryGeo.get("geoName",locale)}
						            </option>
							      </select>
      							  <@fieldErrors fieldName="CUSTOMER_COUNTRY"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="CUSTOMER_STATE">${uiLabelMap.PartyState}: <span class="text-error">*</span></label>
							    <div class="controls">
					        		<select name="CUSTOMER_STATE" id="newuserform_stateProvinceGeoId"></select>
      							  <@fieldErrors fieldName="CUSTOMER_STATE"/>
							    </div>
							</div><!--end control-group-->

							<h4>&nbsp;&nbsp;&nbsp;&nbsp;3. ${uiLabelMap.CommonUsername} - ${uiLabelMap.CommonPassword}</h4>

							<div class="control-group">
							    <label class="control-label" for="USERNAME">${uiLabelMap.CommonUsername}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="text" name="USERNAME" id="USERNAME" value="${requestParameters.USERNAME?if_exists}"  placeholder="jonh"/>
      							  <@fieldErrors fieldName="USERNAME"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="PASSWORD">${uiLabelMap.CommonPassword}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="password" name="PASSWORD" id="PASSWORD" value="${requestParameters.PASSWORD?if_exists}"  placeholder="jonh"/>
      							  <@fieldErrors fieldName="PASSWORD"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="USERNAME">${uiLabelMap.PartyRepeatPassword}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="password" name="CONFIRM_PASSWORD" id="CONFIRM_PASSWORD" value="${requestParameters.CONFIRM_PASSWORD?if_exists}"  placeholder="jonh"/>
      							  <@fieldErrors fieldName="CONFIRM_PASSWORD"/>
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <div class="controls">
								    <br>
								    <button type="submit" class="btn btn-primary">Register</button>
							    </div>
							</div><!--end control-group-->

						</form><!--end form-->

					</div><!--end register-->
				</div><!--end span9-->