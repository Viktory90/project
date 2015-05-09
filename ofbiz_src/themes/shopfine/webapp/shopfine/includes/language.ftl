							<a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
							    ${locale.getDisplayName(locale)} <span class="caret"></span>
							</a>
							<ul class="dropdown-menu language">
						        <#assign availableLocales = Static["org.ofbiz.base.util.UtilMisc"].availableLocales()/>
						        <#list availableLocales as availableLocale>
									<li><a href="<@ofbizUrl>setSessionLocale?newLocale=${availableLocale.toString()}</@ofbizUrl>">${availableLocale.getDisplayName(availableLocale)}</a></li>
									<li class="divider"></li>
						        </#list>
							</ul>