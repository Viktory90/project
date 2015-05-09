<#assign janrainEnabled = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("ecommerce.properties", "janrain.enabled")>
<#assign appName = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("ecommerce.properties", "janrain.appName")>
				<div class="span6">
						<div class="titleHeader clearfix">
									<h3>${uiLabelMap.PartyRequestNewAccount}</h3>
						</div>
						<div class="control-group">
									<p>${uiLabelMap.CommonMayCreateNewAccountHere}</p>
									<a href="<@ofbizUrl>newcustomer</@ofbizUrl>" class="btn">${uiLabelMap.CommonMayCreate}</a>
						</div>
				</div><!--end span9-->
				<div class="span6">
						<div class="titleHeader clearfix">
									<h3>${uiLabelMap.CommonLogin}</h3>
						</div><!--end login-->
						
									<form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">
										<div class="controls">
											<label>${uiLabelMap.CommonUsername}: <span class="text-error">*</span></label>
											<input type="text" id="userName" name="USERNAME" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>" placeholder="${uiLabelMap.CommonUsername}"/>
										</div>
						              <#if autoUserLogin?has_content>
						                <p>(${uiLabelMap.CommonNot} ${autoUserLogin.userLoginId}? <a href="<@ofbizUrl>${autoLogoutUrl}</@ofbizUrl>">${uiLabelMap.CommonClickHere}</a>)</p>
						              </#if>
										<div class="controls">
											<label>${uiLabelMap.CommonPassword}: <span class="text-error">*</span></label>
											<input type="password" id="password" name="PASSWORD" value="" placeholder="**************"/>
										</div>
										<div class="controls">
										    <button type="submit" class="btn btn-primary">${uiLabelMap.CommonLogin}</button>
										</div>
									</form><!--end form-->

				</div><!--end span9-->
