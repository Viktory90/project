<#assign externalKeyParam = "&amp;externalLoginKey=" + requestAttributes.externalLoginKey?if_exists>

<#if (requestAttributes.person)?exists><#assign person = requestAttributes.person></#if>
<#if (requestAttributes.partyGroup)?exists><#assign partyGroup = requestAttributes.partyGroup></#if>
<#assign docLangAttr = locale.toString()?replace("_", "-")>
<#assign langDir = "ltr">
<#if "ar.iw"?contains(docLangAttr?substring(0, 2))>
    <#assign langDir = "rtl">
</#if>
<#if defaultOrganizationPartyGroupName?has_content>
  <#assign orgName = defaultOrganizationPartyGroupName?if_exists>
<#else>
  <#assign orgName = "">
</#if>
<html lang="${docLangAttr}" dir="${langDir}" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <title>${layoutSettings.companyName}: <#if (page.titleProperty)?has_content>${uiLabelMap[page.titleProperty]}<#else>${(page.title)?if_exists}</#if></title>
    <#if layoutSettings.shortcutIcon?has_content>
      <#assign shortcutIcon = layoutSettings.shortcutIcon/>
    <#elseif layoutSettings.VT_SHORTCUT_ICON?has_content>
      <#assign shortcutIcon = layoutSettings.VT_SHORTCUT_ICON.get(0)/>
    </#if>
    <#if shortcutIcon?has_content>
      <link rel="shortcut icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)}</@ofbizContentUrl>" />
    </#if>
    <#if layoutSettings.javaScripts?has_content>
        <#--layoutSettings.javaScripts is a list of java scripts. -->
        <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
        <#assign javaScriptsSet = Static["org.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
        <#list layoutSettings.javaScripts as javaScript>
            <#if javaScriptsSet.contains(javaScript)>
                <#assign nothing = javaScriptsSet.remove(javaScript)/>
                <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="text/javascript"></script>
            </#if>
        </#list>
    </#if>
    <#if layoutSettings.VT_HDR_JAVASCRIPT?has_content>
        <#list layoutSettings.VT_HDR_JAVASCRIPT as javaScript>
            <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="text/javascript"></script>
        </#list>
    </#if>
    <link rel="stylesheet" href="/aceadmin/assets/css/jquery-ui-1.10.3.custom.min.css" type="text/css">
    <link rel="stylesheet" href="/aceadmin/assets/css/custom-actors.css" type="text/css">
	<link rel="stylesheet" href="/aceadmin/jqw/jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="/aceadmin/jqw/jqwidgets/styles/jqx.energyblue.css" type="text/css" />
    <link rel="stylesheet" href="/aceadmin/jqw/jqwidgets/styles/jqx.wigetolbius.css" type="text/css" />
    <link rel="stylesheet" href="/aceadmin/jqw/jqwidgets/styles/jqx.custom.css" type="text/css" />
    <#if layoutSettings.VT_STYLESHEET?has_content>
        <#list layoutSettings.VT_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.styleSheets?has_content>
        <#--layoutSettings.styleSheets is a list of style sheets. So, you can have a user-specified "main" style sheet, AND a component style sheet.-->
        <#list layoutSettings.styleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.rtlStyleSheets?has_content && langDir == "rtl">
        <#--layoutSettings.rtlStyleSheets is a list of rtl style sheets.-->
        <#list layoutSettings.rtlStyleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_RTL_STYLESHEET?has_content && langDir == "rtl">
        <#list layoutSettings.VT_RTL_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_EXTRA_HEAD?has_content>
        <#list layoutSettings.VT_EXTRA_HEAD as extraHead>
            ${extraHead}
        </#list>
    </#if>
    <#if layoutSettings.WEB_ANALYTICS?has_content>
      <script language="JavaScript" type="text/javascript">
        <#list layoutSettings.WEB_ANALYTICS as webAnalyticsConfig>
          ${StringUtil.wrapString(webAnalyticsConfig.webAnalyticsCode?if_exists)}
        </#list>
      </script>
    </#if>
    <!-- add the jQuery script 
    <script type="text/javascript" src="/aceadmin/jqw/scripts/jquery-1.10.2.min.js"></script>-->
</head>
<#if layoutSettings.headerImageLinkUrl?exists>
  <#assign logoLinkURL = "${layoutSettings.headerImageLinkUrl}">
<#else>
  <#assign logoLinkURL = "${layoutSettings.commonHeaderImageLinkUrl}">
</#if>
<#assign organizationLogoLinkURL = "${layoutSettings.organizationLogoLinkUrl?if_exists}">

<#if person?has_content>
  <#assign userName = person.firstName?if_exists + " " + person.middleName?if_exists + " " + person.lastName?if_exists>
<#elseif partyGroup?has_content>
  <#assign userName = partyGroup.groupName?if_exists>
<#elseif userLogin?exists>
  <#assign userName = userLogin.userLoginId>
<#else>
  <#assign userName = "">
</#if>

<body<#if userLogin?has_content><#else> class="login-layout"</#if>>
		<#include "component://aceadmin/webapp/aceadmin/includes/preferMenu.ftl"/>
  		<div class="navbar navbar-inverse">
		  <div class="navbar-inner">
		   <div id="nav" class="container-fluid">
		   		<div class="logo">
					<a href="#" class="brand" style="padding:6px 10px 0px">
						<small>
							<span class="logo-group-name">
								<img src="/images/delys-logo-ngang.png"/>
							</span>
							<span class="logo-text">
								<#if businessTitle?has_content>
									<b>${uiLabelMap.get(businessTitle)}</b>
								</#if>
							</span>
						</small>
					</a>
				</div>
			  <#if userLogin?has_content>
			  <ul class="nav ace-nav pull-right">
					<li class="grey">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">
							<i class="icon-tasks"></i>
							<#assign iTasks = 0>
							<#if layoutSettings.middleTopMessage1?has_content> <#assign iTasks = iTasks + 1> </#if>
							<#if layoutSettings.middleTopMessage2?has_content> <#assign iTasks = iTasks + 1> </#if>
							<#if layoutSettings.middleTopMessage3?has_content> <#assign iTasks = iTasks + 1> </#if>
							<#if (requestAttributes.externalLoginKey)?exists><#assign externalKeyParam = "&externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
							<#if (externalLoginKey)?exists><#assign externalKeyParam = "&externalLoginKey=" + requestAttributes.externalLoginKey?if_exists></#if>
							<span class="badge">${iTasks}</span>
						</a>
						<ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-closer">
							<li class="nav-header">
								<i class="icon-ok"></i> ${uiLabelMap.TasksToComplete}
							</li>
							
							<li <#if !layoutSettings.middleTopMessage1?has_content> style="display:none;" </#if>>
								<a href="${StringUtil.wrapString(layoutSettings.middleTopLink1!)}<#if externalKeyParam?has_content>${externalKeyParam}</#if>">
									<div class="clearfix">
										<span class="pull-left">${layoutSettings.middleTopMessage1?if_exists}</span>
									</div>
								</a>
							</li>
							
							<li <#if !layoutSettings.middleTopMessage2?has_content> style="display:none;" </#if>>
								<a href="${StringUtil.wrapString(layoutSettings.middleTopLink2!)}<#if externalKeyParam?has_content>${externalKeyParam}</#if>">
									<div class="clearfix">
										<span class="pull-left">${layoutSettings.middleTopMessage2?if_exists}</span>
									</div>
								</a>
							</li>
							
							<li <#if !layoutSettings.middleTopMessage3?has_content> style="display:none;" </#if>>
								<a href="${StringUtil.wrapString(layoutSettings.middleTopLink3!)}<#if externalKeyParam?has_content>${externalKeyParam}</#if>">
									<div class="clearfix">
										<span class="pull-left">${layoutSettings.middleTopMessage3?if_exists}</span>
									</div>
								</a>
							</li>
							
							<li>
								<a href="/hrolbius/control/MyTasks">
									${uiLabelMap.ThemeAllTasks}
									<i class="icon-arrow-right"></i>
								</a>
							</li>
						</ul>
					</li>

					<li class="purple" id="ntfarea">
						${screens.render("component://hrolbius/widget/notificationScreens.xml#NotificationListBar")}
					</li>
					<#include "component://Notification/webapp/notification/ftl/getNotInPeriod.ftl"/>

					<li class="green">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">
							<i class="icon-envelope-alt icon-animated-vertical icon-only"></i>
							<span class="badge badge-success">0</span>
						</a>
						<ul class="pull-right dropdown-navbar dropdown-menu dropdown-caret dropdown-closer">
							<li class="nav-header">
								<i class="icon-envelope"></i> 0 Messages
							</li>
							<li style="display:none;">
								<a href="#">
									<span class="msg-body">
										<span class="msg-title">
											<span class="blue">Bob:</span>
											Nullam quis risus eget urna mollis ornare ...
										</span>
										<span class="msg-time">
											<i class="icon-time"></i> <span>3:15 pm</span>
										</span>
									</span>
								</a>
							</li>
							
							<li style="display:none;">
								<a href="#">
									See all messages
									<i class="icon-arrow-right"></i>
								</a>
							</li>									
	
						</ul>
					</li>


					<li class="light-blue user-profile">
						<a class="user-menu dropdown-toggle" href="#" data-toggle="dropdown">
							<span id="user_info">
								<small>${uiLabelMap.CommonWelcome},</small> ${userName}
							</span>
							<i class="icon-caret-down"></i>
						</a>
						<ul id="user_menu" class="pull-right dropdown-menu dropdown-yellow dropdown-caret dropdown-closer">
							<li><a href="<@ofbizUrl>editperson</@ofbizUrl>?partyId=${partyId}"><i class="icon-cog"></i>${uiLabelMap.CommonSetting}</a></li>
							<li><a href="<@ofbizUrl>EmployeeProfile</@ofbizUrl>?partyId=${partyId}"><i class="icon-user"></i>${uiLabelMap.CommonProfile}</a></li>
							<li><a href="<@ofbizUrl>ListLocales</@ofbizUrl>"><i class="icon-flag"></i>${uiLabelMap.CommonLanguageTitle}</a> <!--<@ofbizUrl>ListLocales</@ofbizUrl> -->
								<ul class="obl_submenu">
									<#assign altRow = true>
								    <#assign availableLocales = Static["org.ofbiz.base.util.UtilMisc"].availableLocales()/>
								    <#list availableLocales as availableLocale>
								        <#assign altRow = !altRow>
								        <#assign langAttr = availableLocale.toString()?replace("_", "-")>
								        <#assign langDir = "ltr">
								        <#if "ar.iw"?contains(langAttr?substring(0, 2))>
								            <#assign langDir = "rtl">
								        </#if>
							            <li>
							                <a href="<@ofbizUrl>setSessionLocale</@ofbizUrl>?newLocale=${availableLocale.toString()}">
							                	<div>${availableLocale.getDisplayName(availableLocale)} &nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp; [${availableLocale.toString()}]</div>
						                	</a>
							            </li>
								    </#list>
								</ul>
							</li>
							<li class="divider"></li>
							<li><a href="<@ofbizUrl>logout</@ofbizUrl>"><i class="icon-off"></i> ${uiLabelMap.CommonLogout}</a></li>
						</ul>
					</li>
			  </ul><!--/.ace-nav-->
			  <script type="text/javascript">
				function nav(){
					$('div#nav ul li').mouseover(function() {
						$(this).find('ul:first').show();
					});
					
					$('div#nav ul li').mouseleave(function() {
						$('div#nav ul li ul').hide();
					});
					
					$('div#nav ul li ul').mouseleave(function() {						
						$('div#nav ul li ul').hide();;
					});
					};
					
					$(document).ready(function() {
					nav();
				});
			</script>
			  <style type="text/css">
			  	#user_menu ul,
				#user_menu ul li {
					margin:0;
					padding:0;
					list-style:none;
				}
				#user_menu ul li{
					float:left;
					display:block;
				}
				.obl_submenu {
					right:100%;
					position: absolute;
					width: 100%;
					background: #FFF;
					display: none;
					line-height: 26px;
					z-index: 1000;
					margin-top:-30px !important;
					border-radius: 0;
					box-shadow: 0 2px 4px rgba(0,0,0,0.2);
					border:1px solid #ccc;
					padding:5px 0 !important;
				}
				.obl_submenu:before{
					position: absolute;
					top: 4px;
					right: -7px;
					display: inline-block;
					border-bottom: 7px solid transparent;
					border-left: 7px solid #efefef;
					border-top: 7px solid transparent;
					border-left-color: rgba(0,0,0,0.2);
					content: '';
				}
				.obl_submenu:after{
					position: absolute;
					top: 5px;
					right: -6px;
					display: inline-block;
					border-bottom: 6px solid transparent;
					border-left: 6px solid #fff;
					border-top: 6px solid transparent;
					content: '';
				}
				.obl_submenu li{
					display:block !important;
					width:93% !important;
				}
				.obl_submenu a{
					display:block !important;
					width:92% !important;
					color: black !important;
				}
				.obl_submenu a:hover{
					text-decoration:none !important;
				}
				.obl_submenu a div{
					padding:4px;
				}
			  </style>
			  </#if>	
		   </div><!--/.container-fluid-->
		  </div><!--/.navbar-inner-->
		</div><!--/.navbar-->
  
  
  
  <div id="wait-spinner" style="display:none">
    <div id="wait-spinner-image"></div>
  </div>
  <div class="container-fluid main-container" id="main-container">
			<a class="menu-toggler" id="menu-toggler" href="#">
    <span class="menu-text"></span>
   </a><!-- menu toggler -->

