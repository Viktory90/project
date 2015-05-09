<script>
var uiLabelMap = {}
function showCampaign(id){
	window.location.href=  "<@ofbizUrl>EditTradeCampaign</@ofbizUrl>?id=" + id;
}
	
</script>
<div class="">
	<#assign dataField="[{ name: 'marketingCampaignId', type: 'string' },
						 { name: 'campaignName', type: 'string'},
						 { name: 'campaignSummary', type: 'string'},
						 { name: 'marketingTypeId', type: 'string'},
						 { name: 'marketingPlace', type: 'string'},
						 { name: 'fromDate', type: 'date'},
						 { name: 'thruDate', type: 'date'},
						 { name: 'budgetedCost', type: 'string'},
						 { name: 'estimatedCost', type: 'string'},
						 { name: 'people', type: 'string'},
						 { name: 'statusId', type: 'string'}]"/>
	<#assign columnlist="{ text: '${uiLabelMap.marketingCampaignId}', datafield: 'marketingCampaignId', width: '160px', filterable: true, editable: false, 
							cellsrenderer: function(row, colum, value){
						 		var data = $('#listRequest').jqxGrid('getrowdata', row);
	        					return '<div class=\"click\" style=\"margin-left: 10px;\" onclick=' 
	        							+ 'showCampaign(\"' + data.marketingCampaignId + '\"' + ')' + '>' 
	        							+  data.marketingCampaignId + '</div>'	
					 		}
						 },
						 { text: '${uiLabelMap.campaignName}', datafield: 'campaignName', filterable: true, width: '120px'},
						 { text: '${uiLabelMap.campaignSummary}', datafield: 'campaignSummary', filterable: true, hidden: true},
						 { text: '${uiLabelMap.marketingTypeId}', datafield: 'marketingTypeId', width: '200px', filterable: true},
						 { text: '${uiLabelMap.marketingPlace}', datafield: 'marketingPlace', filterable: true},
						 { text: '${uiLabelMap.fromDate}', datafield: 'fromDate', width: '200px', filtertype: 'date', filterable: true, cellsformat:'dd-MM-yyyy'},
						 { text: '${uiLabelMap.thruDate}', datafield: 'thruDate', width: '120px', filtertype: 'date', filterable: true, cellsformat:'dd-MM-yyyy'},
						 { text: '${uiLabelMap.budgetedCost}', datafield: 'budgetedCost', hidden: true},
						 { text: '${uiLabelMap.estimatedCost}', datafield: 'estimatedCost', hidden: true},
						 { text: '${uiLabelMap.people}', datafield: 'people', hidden: true},
						 { text: '${uiLabelMap.statusId}', datafield: 'statusId'}"/>
	
	<@jqGrid url="jqxGeneralServicer?sname=JQGetListTradeMarketing&type=spl" dataField=dataField columnlist=columnlist
		clearfilteringbutton="true"
		autorowheight="true"
		showtoolbar = "true" deleterow="true"
		id="listPartyInsuranceReport" contextMenuId="jqxmenu" mouseRightMenu="true"
		removeUrl="jqxGeneralServicer?sname=deletePartyInsuranceReport&jqaction=D" deleteColumn="reportId;partyId;insuranceParticipateTypeId;insuranceTypeId"
		createUrl="jqxGeneralServicer?jqaction=C&sname=createMarketingCampaignHeader" alternativeAddPopup="popupAddrow" addrow="true" addType="popup" 
		addColumns="marketingCampaignId;marketingName;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);statusId;" addrefresh="true"
/>
</div>
<div id='jqxmenu'  style="display:none;">
    <ul>
        <li id="edit"><a href="javascript:void(0)"><i class='fa fa-edit'></i>&nbsp;Edit</a></li>
        <li id="del"><a href="javascript:void(0)"><i class='fa fa-trash'></i>&nbsp;Delete</a></li>
    </ul>
</div>

<!-- <div class="modal fade requestModal" id="approveRequest" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content" id="marketingDetail">
			<ul>
				<li><a href="#general">${uiLabelMap.generalInfo}</a></li>
				<li><a href="#costList">${uiLabelMap.costList}</a></li>
			</ul>
			<div id="general">
				<form method="post" action="" class="basic-form form-horizontal">
			    	<div class="row-fluid">
			  			<div class=" span6 no-left-margin no-widget-header">
			  				<div class="control-group no-left-margin ">
								<label for="campaignName">${uiLabelMap.ResearchCampaignName}</label>
		 						<div class="controls">
									<input autocomplete="off" disabled name="campaignName" id="campaignName" type="text">  
		  						</div>
							</div>
			  				<div class="control-group no-left-margin ">
								<label>${uiLabelMap.ResearchCampaignSummary}</label>
			  					<div class="controls">
									<textarea class="no-resize" autocomplete="off" disabled name="campaignSummary" cols="60" rows="3" id="campaignSummary"></textarea>
			  					</div>
				  			</div>
				  			<div class="control-group no-left-margin ">
			 					 <label class="">
									<label for="place">${uiLabelMap.Place}</label>  </label>
			 						<div class="controls">
										<input autocomplete="off" disabled name="place" id="place" type="text">  
			  						</div>
							</div>
				  			<div class="control-group no-left-margin ">
								<label>${uiLabelMap.MarketingProduct}</label>
								<div class="controls">
								     <ul class="list-product" id="list-product">
								     	
								     </ul>
				  				</div>
				  			</div>
				  			
						</div>
				  		<div class=" span6 no-widget-header">
				  			<div class="control-group no-left-margin ">
								<label>Budgeted Cost</label>
					  				<div class="controls">
										<input autocomplete="off" disabled name="budgetedCost" size="6" id="budgetedCost" type="text">  
					 				</div>
					  		</div>
					  		<div class="control-group no-left-margin ">
								<label>Estimated cost</label>
					  			<div class="controls">
									<input autocomplete="off" disabled name="estimatedCost" size="6" id="estimatedCost" type="text">  
					 	 		</div>
							</div>
				  	
				  			<div class="control-group no-left-margin ">
								<label>${uiLabelMap.MarketingHumanResource}</label> 
				  				<div class="controls">
									<input autocomplete="off" disabled name="people" size="55" id="people" type="text"/>  
								</div>
				  			</div>
			  				<div class="control-group no-left-margin ">
								<label>${uiLabelMap.fromDate}</label> 
				  				<div class="controls">
									<div class="input-append">
										<input autocomplete="off" disabled class="span10" id="fromDate" type="text" />
										<span class="add-on">
											<i class="icon-calendar"></i>
										</span>
									</div>  
								</div>
				  			</div>
				  			<div class="control-group no-left-margin ">
								<label>${uiLabelMap.thruDate}</label> 
				  				<div class="controls">
									<div class="input-append">
										<input autocomplete="off" disabled class="span10" id="thruDate" type="text" />
										<span class="add-on">
											<i class="icon-calendar"></i>
										</span>
									</div>  
								</div>
				  			</div>
			  			</div>
					</div>
				</form>
			</div>
			<div id="costList"  class="cost-form cost-form-approve">
				<div class="row-al header-cost-form">
					<div class="col-al4 aligncenter">Chi phí</div>
					<div class="col-al8">
						<div class="row-al">
							<div class="col-al4 aligncenter borderleft">Mô tả</div>
							<div class="col-al2 aligncenter borderleft">Số lượng</div>
							<div class="col-al3 aligncenter borderleft">Đơn giá</div>
							<div class="col-al3 aligncenter borderleft">Thành tiền</div>
						</div>
					</div>
				</div>
				<div id="cost-form" class="costForm">
						
				</div>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-default" id="reject">
				${uiLabelMap.reject}
			</button>
			<button type="button" class="btn btn-primary" id="approve">
				${uiLabelMap.approve}
			</button>
		</div>
	</div>
</div> -->
<!-- <div class="modal requestModal" tabindex="-1" role="dialog" aria-hidden="true" id="rejectNote">
	<div class="modal-dialog">
		<div class="modal-header modal-header-form">
			<h3 class="modal-header-title">${uiLabelMap.marketingCampaignNote}</h3>
		</div>
		<div class="modal-content">
			<textarea class="note-area no-resize" id="noteArea" autocomplete="off"></textarea>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-default" id="cancelReject">
				${uiLabelMap.cancel}
			</button>
			<button type="button" class="btn btn-primary" id="confirmReject">
				${uiLabelMap.ok}
			</button>
		</div>
	</div>
</div> -->

