<div class="widget-body">	 
	<div class="widget-main">
		<div class="row-fluid">
			<#if listCustomer?exists && listCustomer?has_content>
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th style="width:10px">${uiLabelMap.DANo}</th>
							<th class="center">${uiLabelMap.DACustomerId}</th>
							<th class="center">${uiLabelMap.DAName}</th>
							<th class="center">${uiLabelMap.DAAddress}</th>
						</tr>
					</thead>
					<tbody>
					<#list listCustomer as cmItem>
						<tr>
							<td>${cmItem_index + 1}</td>
							<td>${cmItem.partyId?if_exists}</td>
							<td>
								<#if "PERSON" == cmItem.partyTypeId>
									${cmItem.lastName?if_exists} ${cmItem.middleName?if_exists} ${cmItem.firstName?if_exists}
								<#elseif "PARTY_GROUP" == cmItem.partyTypeId>
									${cmItem.groupName?if_exists}
								</#if>
							</td>
							<td>
								<#assign addresses = delegator.findByAnd("PartyAndContactMech", {"partyId" : cmItem.partyId, "contactMechTypeId" : "POSTAL_ADDRESS"})/>
								<#list addresses as address>
									${address.paAddress1?if_exists}<#if address.paCity?exists>, ${address.paCity}</#if>
									<#if address?has_content><br/></#if>
								</#list>
							</td>
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