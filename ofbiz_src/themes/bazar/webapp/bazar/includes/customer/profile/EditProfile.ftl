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
			<div id="post-392" class="post-392 page type-page status-publish hentry group instock">
                <div class="woocommerce">
                    <div class="col2-set">
<div class="screenlet">
  <h2>${uiLabelMap.EcommerceMyAccount}</h2>
  <form id="editUserForm" method="post" action="<@ofbizUrl>updateCustomerProfile</@ofbizUrl>">
    <div class="row" style="margin-left:5px">
    <div class="col-1">
      <input type="hidden" name="emailContactMechPurposeTypeId" value="PRIMARY_EMAIL" />
      <input type="hidden" name="emailContactMechId" value="${emailContactMechId?if_exists}" />
        <h3>${uiLabelMap.PartyContactInformation}</h3>
        <table class="margin10" style="width:100%">
	        <tr>
	          <td>
	          	<label for="firstName">
	          		${uiLabelMap.PartyFirstName}* 
	          		<span id="advice-required-firstName" style="display: none" class="errorMessage">(${uiLabelMap.CommonRequired}) </span>
          		</label>
      		  </td>
	          <td>
	          	<input type="text" name="firstName" id="firstName" class="required" value="${firstName?if_exists}" maxlength="30" />
          	  </td>
	        </tr>
	        <tr>
	          <td><label for="lastName">${uiLabelMap.PartyLastName}* <span id="advice-required-lastName" style="display: none" class="errorMessage">(${uiLabelMap.CommonRequired})</span></label></td>
	          <td><input type="text" name="lastName" id="lastName" class="required" value="${lastName?if_exists}" maxlength="30" /></td>
	        </tr>
	        <tr>
	          <td><label for="emailAddress">${uiLabelMap.CommonEmail}*
	            <span id="advice-required-emailAddress" style="display: none" class="errorMessage">(${uiLabelMap.CommonRequired})</span>
	            <span id="advice-validate-email-emailAddress" class="errorMessage" style="display:none">${uiLabelMap.PartyEmailAddressNotFormattedCorrectly}</span>
	          </label></td>
	          <td><input type="text" class="required validate-email" name="emailAddress" id="emailAddress" value="${emailAddress?if_exists}" maxlength="255" /></td>
	        </tr>
        </table>
    </div>
	<div class="col-2">
        <h3>${uiLabelMap.EcommerceAccountInformation}</h3>
        <table class="margin10" style="width:100%">
        	<tr>
		          <td><label for="userLoginId">${uiLabelMap.CommonUsername}*</label></td>
		          <td><input type="text" name="userLoginId" id="userLoginId" value="${userLogin.userLoginId?if_exists}" maxlength="255" <#if userLogin.userLoginId?exists>disabled="disabled"</#if> /></td>
	        <tr>
	        <tr>
	          <td><label for="currentPassword">${uiLabelMap.CommonCurrentPassword}*</label></td>
	          <td><input type="password" name="currentPassword" id="currentPassword" value="" maxlength="16" /></td>
	        </tr>
	        <tr>
	          <td><label for="newPassword">${uiLabelMap.CommonNewPassword}*</label></td>
	          <td><input type="password" name="newPassword" id="newPassword" value="" maxlength="16" /></td>
	        </tr>
	        <tr>
	          <td><label for="newPasswordVerify">${uiLabelMap.CommonNewPasswordVerify}*</label></td>
	          <td><input type="password" name="newPasswordVerify" id="newPasswordVerify" value="" maxlength="16" /></td>
	        </tr>
        </table>
    </div>
    </div>
    <div class="margin10">
      <input type="submit" id="submitEditUserForm" class="button" value="${uiLabelMap.CommonSubmit}" style="height:31px; padding-bottom:10px"/>
      <a id="cancelEditUserForm" href="<@ofbizUrl>viewprofile</@ofbizUrl>" class="button" style="padding-bottom:9px;">${uiLabelMap.CommonCancel}</a>
    </div>
  </form>
</div>



</div>
</div>
</div>

			</div>
			<!-- END CONTENT -->

			<!-- START EXTRA CONTENT -->
			<!-- END EXTRA CONTENT -->
		</div>
	</div>
</div>
