<div class="widget-body">	 
	<div class="widget-main">
		<div class="row-fluid">
			<#if listFacility?exists && listFacility?has_content>
				<table class="table table-striped table-bordered table-hover">
					<thead>
						<tr>
							<th style="width:10px">${uiLabelMap.DANo}</th>
							<th class="center">${uiLabelMap.DAFacilityId}</th>
							<th class="center">${uiLabelMap.DAFacilityTypeId}</th>
							<th class="center">${uiLabelMap.DAName}</th>
							<th class="center">${uiLabelMap.DADescription}</th>
						</tr>
					</thead>
					<tbody>
					<#list listFacility as faItem>
						<tr>
							<td>${faItem_index + 1}</td>
							<td>
								<a href="<@ofbizUrl>editFacilityDis?facilityId=${faItem.facilityId?if_exists}</@ofbizUrl>">${faItem.facilityId?if_exists}</a>
							</td>
							<td>
								<#assign facilityType = faItem.getRelatedOne("FacilityType", false)!/>
								${facilityType.description?if_exists}
							</td>
							<td>${faItem.facilityName?if_exists}</td>
							<td>${faItem.description?if_exists}</td>
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