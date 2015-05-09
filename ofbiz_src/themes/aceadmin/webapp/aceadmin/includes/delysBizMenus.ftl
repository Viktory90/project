<#if businessMenus?has_content>
<#--<div id="delys-logo">
	<div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
		<img src="/images/delys-logo.png" alt="">
	</div>

	<div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
		<img src="/images/delys-logo-mini.png" alt="">
	</div>
</div>
-->
<div id="hed" style="height:40px;"><div id="sidebar-collapse" style="height:100%;" class="sidebar-collapse"><i class="icon-double-angle-left" style="margin-top:6px"></i></div></div>
	<#list businessMenus as bMenu>
		${screens.render("component://delys/widget/DelysMenuScreens.xml#${bMenu}")}
	</#list>
<#else>
  <#include "applicationList.ftl"/>
</#if>