				<div class="span12">
					<div class="editperson">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.PartyChangePassword}</h3>
						</div><!--end titleHeader-->
  &nbsp;<a id="CommonGoBack1" href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-small">${uiLabelMap.CommonGoBack}</a>
  &nbsp;<a id="CommonSave1" href="javascript:document.getElementById('changepasswordform').submit()" class="btn btn-primary">${uiLabelMap.CommonSave}</a>

    <form id="changepasswordform" method="post" action="<@ofbizUrl>updatePassword/${donePage}</@ofbizUrl>" class="form-horizontal">
  		<h4>&nbsp;&nbsp;&nbsp;&nbsp;${uiLabelMap.PartyChangePassword}</h4>  
      
							<div class="control-group">
							    <label class="control-label" for="currentPassword">${uiLabelMap.PartyOldPassword}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="password" name="currentPassword" id="currentPassword" maxlength="20" />
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="newPassword">${uiLabelMap.PartyNewPassword}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="password" name="newPassword" id="newPassword" maxlength="20" />
							    </div>
							</div><!--end control-group-->
      
							<div class="control-group">
							    <label class="control-label" for="newPasswordVerify">${uiLabelMap.PartyNewPasswordVerify}: <span class="text-error">*</span></label>
							    <div class="controls">
      							  <input type="password" name="newPasswordVerify" id="newPasswordVerify" maxlength="20" />
							    </div>
							</div><!--end control-group-->

							<div class="control-group">
							    <label class="control-label" for="passwordHint">${uiLabelMap.PartyPasswordHint}:</label>
							    <div class="controls">
      							  <input type="text" name="passwordHint" id="passwordHint" maxlength="100" value="${userLoginData.passwordHint?if_exists}"/>
							    </div>
							</div><!--end control-group-->

        					<p>&nbsp;&nbsp;&nbsp;&nbsp;${uiLabelMap.CommonFieldsMarkedAreRequired}</p>
    </form>
    <a href="<@ofbizUrl>${donePage}</@ofbizUrl>" class="btn btn-small">${uiLabelMap.CommonGoBack}</a>
    <a href="javascript:document.getElementById('changepasswordform').submit()" class="btn btn-primary">${uiLabelMap.CommonSave}</a>

					</div><!--end register-->
				</div><!--end span9-->