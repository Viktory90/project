
	<#assign strLocale = locale.toString()?substring(0,2)>
	<div id="language">
	  <img src="/bazar/images/flags/${strLocale}.png" alt="${locale.getDisplayName(locale)}" class="lang_sel_sel icl-en" style="margin-bottom:4px;" />
	  ${locale.getDisplayName(locale)}
    	<ul>
    		<#assign availableLocales = Static["org.ofbiz.base.util.UtilMisc"].availableLocales()/>
    		<#list availableLocales as availableLocale>
      			<#assign langAttr = availableLocale.toString()?replace("_", "-")>
      			<#assign langDir = "ltr">
      			<#if "ar.iw"?contains(langAttr?substring(0, 2))>
       				<#assign langDir = "rtl">
      			</#if>
      			<li class="icl-it">
      				<a href="<@ofbizUrl>setSessionLocale?newLocale=${availableLocale.toString()}</@ofbizUrl>" >
      					<img src="/bazar/images/flags/${availableLocale.toString()}.png" alt="${availableLocale.getDisplayName(availableLocale)}" style="margin-bottom:4px;" />
      			 		<span style="font-family:'Tahoma'; padding-left:5px">${availableLocale.getDisplayName(availableLocale)}</span>
      			 	</a>
      			</li>
    		</#list>
    	</ul>
      </div>