<div class="row-fluid">
	<script type="text/javascript">
	</script>
    <div class="span12 widget-container-span">
        <div class="widget-box transparent">
            <div class="widget-body">
            	<div style="text-align: center;">
            		<h4><b>${uiLabelMap.TransferDetail}</b></h4>
            		${uiLabelMap.createDate}: ${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(transfer.createDate, "dd/MM/yyyy", locale, timeZone)!}
            	</div>
            	</br>
            	<div style="text-align: left;">
            		<div style="text-align: left; margin-left: 3%">
	            		<#assign originFacility = delegator.findOne("Facility", {"facilityId" : transfer.originFacilityId}, true) />
	            		<#assign destFacility = delegator.findOne("Facility", {"facilityId" : transfer.destFacilityId}, true) />
	            		<#assign status = delegator.findOne("StatusItem", {"statusId" : transfer.statusId}, true) />
	            		<table>
		            		<tr>
			            		<td>${uiLabelMap.TransferId}:</td>
			            		<td style="width: 10px"></td>
			            		<td><b>${transfer.transferId}</b></td>
		            		</tr>
		            		<tr>
			            		<td>${uiLabelMap.FacilityFrom}:</td>
			            		<td style="width: 10px"></td>
			            		<td>${originFacility.get("facilityName",locale)}</td>
		            		</tr>
		            		<tr>
			            		<td>${uiLabelMap.FacilityTo}:</td>
			            		<td style="width: 10px"></td>
			            		<td>${destFacility.get("facilityName",locale)}</td>
		            		</tr>
		            		<tr>
			            		<td>${uiLabelMap.Status}:</td>
			            		<td style="width: 10px"></td>
			            		<td>${status.get("description",locale)}</td>
		            		</tr>
	            		</table>
            		</div>
            	<div>
                <div class="widget-main padding-12 no-padding-left no-padding-right">
                	<form method="post" id="ListTransferItems" name="ListTransferItems" action="">
	                	<table id="sale-forecast" class="table table-striped table-bordered table-hover">
			            	<thead>
			            		<tr class="sf-product">
			            			<td>${uiLabelMap.SequenceId}</td>
			            			<td>${uiLabelMap.ProductProductId}</td>
									<td>${uiLabelMap.ProductName}</td>
									<td>${uiLabelMap.Quantity}</td>
									<td>${uiLabelMap.ExpireDate}</td>
			            		</tr>
			            	</thead>
			            	<tbody>
		            			<#if listItems?has_content>
									<#assign rowCount = 0 />
									<#list listItems as item>
										<#assign product = delegator.findOne("Product", {"productId" : item.productId}, true) />
										<#assign uom = delegator.findOne("Uom", {"uomId" : item.quantityUomId}, true) />
										<tr>	
											<td>${rowCount + 1}</td>
											<td>${item.productId?if_exists}</td>
		            			 			<td>${product.productName?if_exists}</td>
		            			 			<td>${item.quantity?if_exists} (${uom.get("description",locale)})</td>
		            			 			<#if item.expireDate?has_content>
		            			 				<td>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(item.expireDate, "dd/MM/yyyy", locale, timeZone)!}</td>
		            			 			<#else>
		            			 				<td>${item.expireDate?if_exists}</td>
		            			 			</#if>
										</tr>			
									<#assign rowCount=rowCount + 1/>
									</#list>
								</#if>
			            	</tbody>
		            	</table>
	            	</form>
				</div>
			</div>
		</div>
	</div>
</div>