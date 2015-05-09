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

<div class="widget-box transparent no-bottom-border">
	<div class="widget-header widget-header-blue widget-header-flat">
		<h4 class="lighter">${uiLabelMap.DAShowOnlySalesPeriodsWithOrganization}</h4>
		<span class="widget-toolbar none-content">
			<a href="<@ofbizUrl>editCustomTimeSalesPeriod</@ofbizUrl>">
				<i class="icon-pencil open-sans">${uiLabelMap.DAEditCustomTimePeriods}</i>
			</a>
			<a href="<@ofbizUrl>newCustomTimeSalesPeriod</@ofbizUrl>">
				<i class="icon-plus open-sans">${uiLabelMap.DACreateNewCustomTimePeriod}</i>
			</a>
		</span>
	</div>
	<div class="widget-body">
 		<form method="post" action="<@ofbizUrl>editCustomTimeSalesPeriod</@ofbizUrl>" name="setOrganizationPartyIdForm" class="form-horizontal basic-custom-form">
         	<input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId?if_exists}" />
         	<div class="row">
         		<div class="span11">
         			<div class="control-group">
						<label class="control-label">${uiLabelMap.DAOrganizationId}:</label>
						<div class="controls">
							<@htmlTemplate.lookupField name="findOrganizationPartyId" id="" value='${findOrganizationPartyId?if_exists}' 
										formName="setOrganizationPartyIdForm" fieldFormName="LookupPartyGroupName"/>
							<button class="btn btn-mini btn-primary" type="submit" style="margin-left: 5px">
				         		<i class="icon-ok" ></i>${uiLabelMap.CommonUpdate}
				         	</button>
						</div>
					</div>
         		</div>
         	</div>
     	</form>
 	</div>
</div>
<div class="widget-box transparent no-bottom-border">
    <div class="widget-header">
    	<h4>${uiLabelMap.DAListCustomTimePeriod}</h4>
      	<span class="widget-toolbar></span>
      	<br class="clear"/>
    </div>
    <#if customTimePeriods?has_content>
		<div class="widget-body" >
    		<div style="width:100%; "><#--overflow-x: scroll !important; -->
		      	<table class="table table-striped table-bordered table-hover dataTable" cellspacing="0">
		        	<thead>
		        	<tr class="header-row">
		          		<th>${uiLabelMap.CommonId}</th>
		          		<th>${uiLabelMap.DAParentCustomTimePeriod}</th>
		          		<th nowrap>${uiLabelMap.DAPartyGroupId}</th>
		          		<th>${uiLabelMap.AccountingPeriodType}</th>
		          		<th>${uiLabelMap.CommonNbr}</th>
		          		<th>${uiLabelMap.AccountingPeriodName}</th>
		          		<th>${uiLabelMap.CommonFromDate}</th>
		          		<th>${uiLabelMap.CommonThruDate}</th>
		          		<th>&nbsp;</th>
		        	</tr>
		        	</thead>
		        	<#assign line = 0>
		        	<#list customTimePeriods as customTimePeriod>
		          		<#assign line = line + 1>
		          		<#assign periodType = customTimePeriod.getRelatedOne("PeriodType", true)>
		          		<#assign hasntStarted = false>
		          		<#assign compareDate = customTimePeriod.getDate("fromDate")>
		              	<#--DateTime: <#assign compareDate = customTimePeriod.getTimestamp("fromDate")>-->
		              	<#assign classNameFromDate = "">
		              	<#assign classNameThruDate = "">
		              	<#if compareDate?has_content>
		                	<#if nowTimestamp.before(compareDate)><#assign hasntStarted = true></#if>
		              	</#if>
		              	<#if hasntStarted>
							<#assign classNameFromDate = "alert">
						</#if>
						<#assign hasExpired = false>
						<#assign compareDate = customTimePeriod.getDate("thruDate")>
		              	<#--DateTime: <#assign compareDate = customTimePeriod.getTimestamp("thruDate")>-->
		              	<#if compareDate?has_content>
			                <#if nowTimestamp.after(compareDate)><#assign hasExpired = true></#if>
		              	</#if>
		              	<#if hasExpired>
		              		<#assign classNameThruDate = "alert">
		              	</#if>
		          		<tr>
	            			<td><a href="<@ofbizUrl>editCustomTimeSalesPeriod?currentCustomTimePeriodId=${customTimePeriod.customTimePeriodId?if_exists}&amp;findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>">${customTimePeriod.customTimePeriodId}</a></td>
				            <td><#if currentCustomTimePeriod?exists>${currentCustomTimePeriod.customTimePeriodId}</#if></td>
				            <td>${customTimePeriod.organizationPartyId?if_exists}</td>
				            <td>
			            		<#assign periodObj = customTimePeriod.getRelatedOne("PeriodType", false)!>
			            		<#if periodObj?exists>
			            			${periodObj.description?if_exists}
			            		</#if>
				            </td>
	            			<td>${customTimePeriod.periodNum?if_exists}</td>
	            			<td>${customTimePeriod.periodName?if_exists}</td>
	            			<td no-wrap class="${classNameFromDate?if_exists}">
								<#if customTimePeriod.fromDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(customTimePeriod.fromDate, "dd/MM/yyyy", locale, timeZone)!}</#if>
	            			</td>
	            			<td no-wrap class="${classNameThruDate?if_exists}">
				              	<#if customTimePeriod.thruDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(customTimePeriod.thruDate, "dd/MM/yyyy", locale, timeZone)!}</#if>
	             			</td>
			             	<td>
			              		<div class="hidden-phone visible-desktop btn-group">
									<button type="button" class="btn btn-mini btn-primary" onclick="window.location.href='<@ofbizUrl>editCustomTimeSalesPeriod?currentCustomTimePeriodId=${customTimePeriod.customTimePeriodId?if_exists}&amp;findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>';" 
										title="${uiLabelMap.DASetAsCurrent}">
										<i class="icon-edit bigger-120"></i>
									</button>
									<button class="btn btn-mini btn-danger" onclick="window.location.href='<@ofbizUrl>deleteCustomTimeSalesPeriod?customTimePeriodId=${customTimePeriod.customTimePeriodId?if_exists}&amp;currentCustomTimePeriodId=${currentCustomTimePeriodId?if_exists}&amp;findOrganizationPartyId=${findOrganizationPartyId?if_exists}</@ofbizUrl>';">
										<i class="icon-trash bigger-120"></i>
									</button>
								</div>
				            </td>
		          		</tr>
		        	</#list>
		      	</table>
      		</div>
  		</div>
    <#else>
      	<div class="widget-body"><p class="alert alert-info">${uiLabelMap.AccountingNoChildPeriodsFound}</p></div>
    </#if>
</div>
