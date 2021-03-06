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
<div class="position-relative" style="width:500px;margin:0 auto;">
<div id="forgot-box" class="widget-box no-border visible">
	<form style="margin:0px;" method="post" action="<@ofbizUrl>forgotPassword${previousParams?if_exists}</@ofbizUrl>" name="forgotpassword" id="forgotpassword">
		<div class="widget-body">
		 <div class="widget-main">
			<h4 class="header red lighter bigger"><i class="icon-key"></i> ${uiLabelMap.CommonForgotYourPassword}?</h4>
			<div class="space-6"></div>
			<p>
				${uiLabelMap.CommonUsername}
			</p>
			 <fieldset>
				<label>
					<span class="block input-icon input-icon-right">
						<input style="width:85%;" type="text" class="span12" placeholder="Email" name="USERNAME" value="<#if requestParameters.USERNAME?has_content>${requestParameters.USERNAME}<#elseif autoUserLogin?has_content>${autoUserLogin.userLoginId}</#if>">
						<i class="icon-envelope"></i>
					</span>
				</label>
				<div class="row-fluid">
					<div style="float:left;width:50%;"><button type="submit" style="margin-left:10px;width:80%;" class="span5 offset7 btn btn-small btn-danger" name="GET_PASSWORD_HINT" value="${uiLabelMap.CommonGetPasswordHint}"><i class="icon-lightbulb"></i> ${uiLabelMap.CommonGetPasswordHint}</button></div>
					<div style="float:left;width:40%;"><button type="submit" style="margin-left:0px;width:100%;" class="span5 offset7 btn btn-small btn-danger" name="EMAIL_PASSWORD" value="${uiLabelMap.CommonEmailPassword}"><i class="icon-lightbulb"></i> ${uiLabelMap.CommonEmailPassword}!</button></div>
				</div>
			  </fieldset>
		 </div><!--/widget-main-->
		 <div class="toolbar center">
			<a href="<@ofbizUrl>authview</@ofbizUrl>" onclick="show_box('login-box'); return false;" class="back-to-login-link">${uiLabelMap.CommonGoBack} <i class="icon-arrow-right"></i></a>
		 </div>
		</div><!--/widget-body-->
		<input type="hidden" name="JavaScriptEnabled" value="N"/>
	</form>
	</div>
</div>