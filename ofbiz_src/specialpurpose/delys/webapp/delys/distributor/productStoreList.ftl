<div class="widget-body">	 
	<div class="widget-main">
		<div class="row-fluid">
			<#if listProductStore?exists && listProductStore?has_content>
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th style="width:10px">${uiLabelMap.DANo}</th>
							<th class="center">${uiLabelMap.DAProductStoreId}</th>
							<th class="center">${uiLabelMap.DAStoreName}</th>
							<th class="center">${uiLabelMap.DACurrencyUomId}</th>
							<th class="center">${uiLabelMap.DAFromDate}</th>
							<th class="center">${uiLabelMap.DAMainFacilityId}</th>
							<th class="center">${uiLabelMap.DAPartyId}</th>
							<th class="center">${uiLabelMap.DAPayToPartyId}</th>
							
						</tr>
					</thead>
					<tbody>
					<#list listProductStore as psItem>
						<tr>
							<td>${psItem_index + 1}</td>
							<td>
								<a href="<@ofbizUrl>viewProductStoreDis?productStoreId=${psItem.productStoreId?if_exists}</@ofbizUrl>">${psItem.productStoreId?if_exists}</a>
							</td>
							<td>${psItem.storeName?if_exists}</td>
							<td>${psItem.defaultCurrencyUomId?if_exists}</td>
							<td>
								<#if psItem.fromDate?exists>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(psItem.fromDate, "dd/MM/yyyy - HH:mm:ss:SSS", locale, timeZone)!}</#if>
							</td>
							<td>${psItem.inventoryFacilityId?if_exists}</td>
							<td>${psItem.partyId?if_exists}</td>
							<td>${psItem.payToPartyId?if_exists}</td>
						</tr>
					</#list>
					</tbody>
				</table>
			<#else>
				<div class="alert alert-info">${uiLabelMap.DANoItemToDisplay}</div>
			</#if>
		</div>
	</div>
</div>