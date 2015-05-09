<div class="widget-body">	 
	<div class="widget-main">
		<div class="row-fluid">
			<div style="text-align:right">
				<h5 class="lighter block green" style="float:left"><b>${uiLabelMap.DAListProduct}</b></h5>
			</div>
			<div style="clear:both"></div>
			<div id="list-agreement-term">
				<#if listProduct?exists && listProduct?has_content>
					<table class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th style="width:10px">${uiLabelMap.DANo}</th>
								<th class="center">${uiLabelMap.DAPrimaryCategoryId}</th>
								<th class="center">${uiLabelMap.DAProductId}</th>
								<th class="center">${uiLabelMap.DAInternalName}</th>
								<th class="center">${uiLabelMap.DAProductName}</th>
							</tr>
						</thead>
						<tbody>
						<#list listProduct as productItem>
							<tr>
								<td>${productItem_index + 1}</td>
								<td>${productItem.primaryProductCategoryId?if_exists}</td>
								<td>${productItem.productId?if_exists}</td>
								<td>${productItem.internalName?if_exists}</td>
								<td>${productItem.productName?if_exists}</td>
							</tr>
						</#list>
						</tbody>
					</table>
				<#else>
					<div class="alert alert-info">${uiLabelMap.DANoItemToDisplay}</div>
				</#if>
			</div>
			<!--END LIST 2-->
		</div>
	</div>
</div>