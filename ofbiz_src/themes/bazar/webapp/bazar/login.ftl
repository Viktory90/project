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
<#assign janrainEnabled = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("ecommerce.properties", "janrain.enabled")>
<#assign appName = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("ecommerce.properties", "janrain.appName")>


<div class="login-content">
	<div id="primary" class="sidebar-no">
	    <div class="container group">
	    	<div class="row">
		        <!-- START CONTENT -->
				<div id="content-page" class="span12 content group">
					<div id="post-392" class="post-392 page type-page status-publish hentry group instock">
						<div class="woocommerce">
							<div class="col2-set" id="customer_login">
	<#if janrainEnabled == "Y">
			<script type="text/javascript">
			(function() {
			    if (typeof window.janrain !== 'object') window.janrain = {};
			    window.janrain.settings = {};
			    
			    janrain.settings.tokenUrl = '<@ofbizUrl fullPath="true" secure="true">janrainCheckLogin</@ofbizUrl>';
			
			    function isReady() { janrain.ready = true; };
			    if (document.addEventListener) {
			      document.addEventListener("DOMContentLoaded", isReady, false);
			    } else {
			      window.attachEvent('onload', isReady);
			    }
			
			    var e = document.createElement('script');
			    e.type = 'text/javascript';
			    e.id = 'janrainAuthWidget';
			
			    if (document.location.protocol === 'https:') {
			      e.src = 'https://rpxnow.com/js/lib/${appName}/engage.js';
			    } else {
			      e.src = 'http://widget-cdn.rpxnow.com/js/lib/${appName}/engage.js';
			    }
			
			    var s = document.getElementsByTagName('script')[0];
			    s.parentNode.insertBefore(e, s);
			})();
			</script>

			<div class="col-1">
				<h2>${uiLabelMap.CommonRegistered}</h2>
				<form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform" class="login">
					<p class="form-row form-row-first">
						<label for="username">
							${uiLabelMap.CommonUsername}<span class="required">*</span>
						</label>
						<input type="text" id="userName" class="input-text" name="USERNAME" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>"/>
					</p>
					
					<#if autoUserLogin?has_content>
		                <p>(${uiLabelMap.CommonNot} ${autoUserLogin.userLoginId}? <a href="<@ofbizUrl>${autoLogoutUrl}</@ofbizUrl>">${uiLabelMap.CommonClickHere}</a>)</p>
		            </#if>
		            
					<p class="form-row form-row-last">
						<label for="password">${uiLabelMap.CommonPassword}: <span class="required">*</span></label>
						<input class="input-text" type="password" name="PASSWORD" id="password" value="">
					</p>
					
					<div class="clear"></div>
		
					<p class="form-row">		
						<input type="submit" class="button" name="login" value="${uiLabelMap.CommonLogin}">
					</p>
					
					<div>
		                <label for="newcustomer_submit">${uiLabelMap.CommonMayCreateNewAccountHere}:</label>
		                <a href="<@ofbizUrl>newcustomer</@ofbizUrl>">${uiLabelMap.CommonMayCreate}</a>
	      			</div>
				</form>
				
				<div id="janrainEngageEmbed"></div>
			</div>
	<#else>    
			<div class="col-1">
				<h2>${uiLabelMap.CommonRegistered}</h2>
				<form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform" class="login">
					<p class="form-row form-row-first">
						<label for="username">${uiLabelMap.CommonUsername} <span class="required">*</span></label>
						<input type="text" class="input-text" name="USERNAME" id="userName"  value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>"/>
					</p>
					<#if autoUserLogin?has_content>
			          	<p>(${uiLabelMap.CommonNot} ${autoUserLogin.userLoginId}? <a href="<@ofbizUrl>${autoLogoutUrl}</@ofbizUrl>">${uiLabelMap.CommonClickHere}</a>)</p>
			        </#if>
					<p class="form-row form-row-last">
						<label for="password">${uiLabelMap.CommonPassword}: <span class="required">*</span></label>
						<input class="input-text" type="password" name="PASSWORD" id="password" value=""/>
					</p>
					<div class="clear"></div>
		
					<p class="form-row">
						<input type="hidden" id="_n" name="_n" value="54f36d50d1">
						<input type="hidden" name="_wp_http_referer" value="/bazar/my-account/">				
						<input type="submit" class="button" name="login" value="${uiLabelMap.CommonLogin}">
					</p>
				</form>
			</div>
	</#if>
	
	
			<div class="col-2">
				<h2>${uiLabelMap.CommonNewUser}</h2>
				<form method="post" action="<@ofbizUrl>newcustomer</@ofbizUrl>" class="register">
					<p>
						<label for="newcustomer_submit">${uiLabelMap.CommonMayCreateNewAccountHere}:</label>
					</p>
					<p>
						<input type="submit" class="button" id="newcustomer_submit" value="${uiLabelMap.CommonMayCreate}"/>
					</p>
				</form>
			</div>

		</div>
	</div>
</div>
<!-- START COMMENTS -->
<div id="comments"></div>
<!-- END COMMENTS -->
</div>
<!-- END CONTENT -->        
<!-- START EXTRA CONTENT -->
<!-- END EXTRA CONTENT -->
</div>
	
	<div class="row">
		<!-- START CONTENT -->
		<div id="content-page" class="span12 content group">
			<div id="post-392" class="post-392 page type-page status-publish hentry group instock">
				<div class="woocommerce">
					<div class="col2-set" id="customer_login">
						<div class="col-1">
							  <h2>${uiLabelMap.CommonForgotYourPassword}</h2>
							  <div class="content">
							  <form method="post" action="<@ofbizUrl>forgotpassword</@ofbizUrl>" class="horizontal">
							      <b>${uiLabelMap.CommonUsername}</b><br/>
							      <input type="text" class="input-text" id="forgotpassword_userName" name="USERNAME" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>"/><br/><br/>
							      <input type="submit" class="button" name="GET_PASSWORD_HINT" value="${uiLabelMap.BigshopGetPasswordHint}"/>
							      <input type="submit" class="button" name="EMAIL_PASSWORD" value="${uiLabelMap.BigshopEmailPassword}"/>
							  </form>
		  				</div>
		  			</div>
		  		</div>
	  		</div>
		  </div>
		</div>
	</div>
	
	
		</div>
	</div>
</div>
	
	
<div class="endcolumns">&nbsp;</div>



<script language="JavaScript" type="text/javascript">
  <#if autoUserLogin?has_content>document.loginform.PASSWORD.focus();</#if>
  <#if !autoUserLogin?has_content>document.loginform.USERNAME.focus();</#if>
</script>





















