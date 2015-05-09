<#assign currentStatusId = quotationSelected.statusId?if_exists>
<script type="text/javascript">
	var dataSelected = new Array();
</script>
<#if currentStatusId?exists && currentStatusId == "QUOTATION_ACCEPTED">
<div class="row-fluid">
	<h4 id="step-title" class="header smaller lighter blue span3" style="margin-bottom:0 !important; border-bottom: none; margin-top:3px !important; padding-bottom:0">
		${uiLabelMap.DAPreparePrintQuotation} (${quotationSelected.productQuotationId})</h4>
	<div id="fuelux-wizard" class="row-fluid hide span8" data-target="#step-container">
		<ul class="wizard-steps wizard-steps-mini">
			<li data-target="#step1" class="active">
				<span class="step" data-rel="tooltip" title="${uiLabelMap.DAChooseItemToPrint}" data-placement="bottom">1</span>
			</li>
			<li data-target="#step2">
				<span class="step" data-rel="tooltip" title="${uiLabelMap.DAConfirmation}" data-placement="bottom">2</span>
			</li>
		</ul>
	</div>
	<div class="span1 align-right" style="padding-top:5px">
		<a href="<@ofbizUrl>viewQuotation?productQuotationId=${quotationSelected.productQuotationId}</@ofbizUrl>" data-rel="tooltip" title="${uiLabelMap.DAViewQuotation}" data-placement="bottom" class="no-decoration"><i class="fa fa-arrow-circle-left" style="font-size:16pt"></i></a>
	</div>
	<div style="clear:both"></div>
	<hr style="margin: 8px 0" />

	<div class="step-content row-fluid position-relative" id="step-container">
		<div class="step-pane active" id="step1">
			<div class="form-horizontal basic-custom-form form-size-mini form-decrease-padding">
				<div class="row margin_left_10 row-desc">
					<div class="span6">
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAQuotationId}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.productQuotationId}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAQuotationName}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.quotationName?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.CommonDescription}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.description?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DASalesChannel}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.salesChannel?if_exists}</span>
							</div>
						</div>
					</div><!--.span6-->
					<div class="span6">
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DACurrencyUomId}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.currencyUomId?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAPartyApply}:</label>
							<div class="controls-desc">
								<span>
									<#list roleTypes as roleType>
										<#list roleTypesSelected as roleTypeSelected>
											<#if roleType.roleTypeId == roleTypeSelected.roleTypeId>
												<#if roleTypeSelected_index &gt; 0 && roleTypeSelected_index &lt; roleTypesSelected?size>, </#if>
												<#if roleType.description?exists>${roleType.description}<#else>${roleType.roleTypeId}</#if>
											</#if>
										</#list>
									</#list>
								</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAFromDate}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.fromDate?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAThroughDate}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.thruDate?if_exists}</span>
							</div>
						</div>
					</div><!--.span6-->
				</div><!--.row-fluid-->
			</div>
			<div class="row-fluid">
				<div class="span12">
					<#assign dataField="[{ name: 'productId', type: 'string' },
					               		{ name: 'productName', type: 'string' },
					               		{ name: 'priceToDist', type: 'number', formatter: 'integer'},
					               		{ name: 'priceToMarket', type: 'number', formatter: 'integer'},
					               		{ name: 'priceToConsumer', type: 'number', formatter: 'integer'},
					                	]"/>
					<#assign columnlist="{ text: '${uiLabelMap.DAProductId}', dataField: 'productId', width: '180px', editable:false},
										 { text: '${uiLabelMap.DAProductName}', dataField: 'productName', editable:false}," />
					<#if quotationSelected.salesChannel == "SALES_MT_CHANNEL">
						<#assign columnlist = columnlist + "{ text: '${uiLabelMap.DAPriceToCustomer}<br />${uiLabelMap.DAParenthesisBeforeVAT}', dataField: 'priceToDist', width: '180px', cellsalign: 'right', filterable:false, sortable:false},
										 { text: '${uiLabelMap.DAPriceToConsumer}<br/>${uiLabelMap.DAParenthesisAfterVAT}', dataField: 'priceToConsumer', width: '180px', cellsalign: 'right', filterable:false, sortable:false}"/>
					<#else>
						<#assign columnlist = columnlist + "{ text: '${uiLabelMap.DAPriceToDistributor}<br />${uiLabelMap.DAParenthesisBeforeVAT}', dataField: 'priceToDist', width: '180px', cellsalign: 'right', filterable:false, sortable:false},
										 { text: '${uiLabelMap.DATheMarketPriceOfDistributor}<br/>${uiLabelMap.DAParenthesisAfterVAT}', dataField: 'priceToMarket', width: '180px', cellsalign: 'right', filterable:false, sortable:false},
										 { text: '${uiLabelMap.DAPricesProposalForConsumer}<br/>${uiLabelMap.DAParenthesisAfterVAT}', dataField: 'priceToConsumer', width: '180px', cellsalign: 'right', filterable:false, sortable:false}"/>
					</#if>
					<@jqGrid id="jqxgridQuotationItems" clearfilteringbutton="false" editable="false" alternativeAddPopup="alterpopupWindow" columnlist=columnlist dataField=dataField
							viewSize="30" showtoolbar="false" editmode="click" selectionmode="checkbox" 
							url="jqxGeneralServicer?sname=JQGetListProductQuotationRules&productQuotationId=${quotationSelected.productQuotationId?if_exists}"/>
				</div>
			</div>
		</div><!--.step1-->

		<div class="step-pane" id="step2">
			<div class="form-horizontal basic-custom-form form-size-mini form-decrease-padding">
				<div class="row margin_left_10 row-desc">
					<div class="span6">
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAQuotationId}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.productQuotationId}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAQuotationName}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.quotationName?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.CommonDescription}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.description?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DASalesChannel}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.salesChannel?if_exists}</span>
							</div>
						</div>
					</div><!--.span6-->
					<div class="span6">
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DACurrencyUomId}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.currencyUomId?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAPartyApply}:</label>
							<div class="controls-desc">
								<span>
									<#list roleTypes as roleType>
										<#list roleTypesSelected as roleTypeSelected>
											<#if roleType.roleTypeId == roleTypeSelected.roleTypeId>
												<#if roleTypeSelected_index &gt; 0 && roleTypeSelected_index &lt; roleTypesSelected?size>, </#if>
												<#if roleType.description?exists>${roleType.description}<#else>${roleType.roleTypeId}</#if>
											</#if>
										</#list>
									</#list>
								</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAFromDate}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.fromDate?if_exists}</span>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label-desc">${uiLabelMap.DAThroughDate}:</label>
							<div class="controls-desc">
								<span>${quotationSelected.thruDate?if_exists}</span>
							</div>
						</div>
					</div><!--.span6-->
				</div><!--.row-fluid-->
				
				<div class="row-fluid">
					<div class="span12">
						<div id="jqxgridProdSelected" style="width: 100%">
						</div>
						<script type="text/javascript">
							$(document).ready(function () {
								var sourceSuccess = {
										localdata: dataSelected,
										dataType: "array",
										datafields:[
										   {name: 'productId', type: 'string'},
										   {name: 'productName', type:'string'},
										   {name: 'priceToDist', type: 'number', formatter: 'integer'},
										   {name: 'priceToMarket', type: 'number', formatter: 'integer'},
										   {name: 'priceToConsumer', type: 'number', formatter: 'integer'}
										   ]
									};
								var dataAdapterSuccess = new jQuery.jqx.dataAdapter(sourceSuccess);
								jQuery("#jqxgridProdSelected").jqxGrid({
									width: '100%',
									source:dataAdapterSuccess,
									pageable: true,
							        autoheight: true,
							        sortable: false,
							        altrows: true,
							        showaggregates: false,
							        showstatusbar: false,
							        enabletooltips: true,
							        editable: false,
							        selectionmode: 'singlerow',
							        columns:[
							            {text: '${uiLabelMap.DAProductId}', dataField: 'productId', width: '180px'},
							            {text: '${uiLabelMap.DAProductName}', dataField: 'productName'},
							            <#if quotationSelected.salesChannel == "SALES_MT_CHANNEL">
							            	{text: '${uiLabelMap.DAPriceToCustomer}<br />${uiLabelMap.DAParenthesisBeforeVAT}', dataField: 'priceToDist', width: '180px', cellsalign: 'right'},
								            {text: '${uiLabelMap.DAPriceToConsumer}<br />${uiLabelMap.DAParenthesisAfterVAT}', dataField: 'priceToConsumer', width: '180px', cellsalign: 'right'}
							            <#else>
							            	{text: '${uiLabelMap.DAPriceToDistributor}<br />${uiLabelMap.DAParenthesisBeforeVAT}', dataField: 'priceToDist', width: '180px', cellsalign: 'right'},
								            {text: '${uiLabelMap.DATheMarketPriceOfDistributor}<br />${uiLabelMap.DAParenthesisAfterVAT}', dataField: 'priceToMarket', width: '180px', cellsalign: 'right'},
								            {text: '${uiLabelMap.DAPricesProposalForConsumer}<br />${uiLabelMap.DAParenthesisAfterVAT}', dataField: 'priceToConsumer', width: '180px', cellsalign: 'right'}
							            </#if>
							        ]
								});
							});
						</script>
					</div>
				</div>
			</div>
		</div><!--.step2-->
	</div>
	
	<hr />
	<div class="row-fluid wizard-actions">
		<button class="btn btn-small btn-prev">
			<i class="icon-arrow-left"></i>
			${uiLabelMap.DAPrev}
		</button>
		<button class="btn btn-small btn-success btn-next" data-last="${uiLabelMap.DAPrint}" id="btnNextWizard">
			${uiLabelMap.DANext}
			<i class="icon-arrow-right icon-on-right"></i>
		</button>
	</div>
</div>

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>

<script src="/delys/images/js/fuelux/fuelux.wizard.min.js"></script>
<script src="/delys/images/js/bootbox.min.js"></script>
<script src="/delys/images/js/select2.min.js"></script>
<script type="text/javascript">
	var alterData = null;
	var productIds = [];
	$(function() {
		$('[data-rel=tooltip]').tooltip();
	
		$(".select2").css('width','150px').select2({allowClear:true})
		.on('change', function(){
			$(this).closest('form').validate().element($(this));
		}); 
		
		$(".chzn-select").chosen({allow_single_deselect:true , no_results_text: "${uiLabelMap.DANoSuchState}"});
		
		$('#fuelux-wizard').ace_wizard().on('change' , function(e, info){
			if ((info.step == 1) && (info.direction == "next")) {
				$('#container').empty();
				$("#step-title").html("${uiLabelMap.DAConfirmation}");
				
		        var selectedRowIndexes = $('#jqxgridQuotationItems').jqxGrid('selectedrowindexes');
				if (selectedRowIndexes.length <= 0) {
					bootbox.dialog("${uiLabelMap.DANotYetChooseItem}!", [{
						"label" : "OK",
						"class" : "btn-small btn-primary",
						}]
					);
					return false;
				}
				dataSelected = new Array();
				$('#container').empty();
				for(var index in selectedRowIndexes) {
					var data = $('#jqxgridQuotationItems').jqxGrid('getrowdata', selectedRowIndexes[index]);
					var row = {};
					row["productId"] = data.productId;
					row["productName"] = data.productName;
					if (data.priceToDist != undefined) {
						row["priceToDist"] = data.priceToDist;
					} else {
						row["priceToDist"] = "";
					}
					if (data.priceToMarket != undefined) {
						row["priceToMarket"] = data.priceToMarket;
					} else {
						row["priceToMarket"] = "";
					}
					if (data.priceToConsumer != undefined) {
						row["priceToConsumer"] = data.priceToConsumer;
					} else {
						row["priceToConsumer"] = "";
					}
					dataSelected[index] = row;
				}
				
				var sourceSuccessTwo = {
					localdata: dataSelected,
					dataType: "array",
					datafields:[
						   {name: 'productId', type: 'string'},
						   {name: 'productName', type:'string'},
						   {name: 'priceToDist', type: 'number', formatter: 'integer'},
						   {name: 'priceToMarket', type: 'number', formatter: 'integer'},
						   {name: 'priceToConsumer', type: 'number', formatter: 'integer'}
					   ]
				};
				var dataAdapter = new $.jqx.dataAdapter(sourceSuccessTwo);
                $("#jqxgridProdSelected").jqxGrid({ source: dataAdapter });
			} else if ((info.step == 2) && (info.direction == "previous")) {
				alterData = null;
				$("#step-title").html("${uiLabelMap.DACreateQuotationForProduct}");
			}
		}).on('finished', function(e) {
			var form = document.createElement("form");
		    form.setAttribute("method", "POST");
		    form.setAttribute("action", "quotation.pdf");
		    form.setAttribute("target", "_blank");
		    
		    var hiddenField0 = document.createElement("input");
            hiddenField0.setAttribute("type", "hidden");
            hiddenField0.setAttribute("name", "productQuotationId");
            hiddenField0.setAttribute("value", "${quotationSelected.productQuotationId}");
            form.appendChild(hiddenField0);
            
            var hiddenField1 = document.createElement("input");
            hiddenField1.setAttribute("type", "hidden");
            hiddenField1.setAttribute("name", "isPrint");
            hiddenField1.setAttribute("value", "true");
            form.appendChild(hiddenField1);
            
		    var prodSelectedList = new Array();
		    var prodSelectedRows = $('#jqxgridProdSelected').jqxGrid('getrows');
			for (var i = 0; i < prodSelectedRows.length; i++) {
				var itemSelected = prodSelectedRows[i];
				if (itemSelected.productId != undefined) {
					var hiddenField = document.createElement("input");
		            hiddenField.setAttribute("type", "hidden");
		            hiddenField.setAttribute("name", "productId");
		            hiddenField.setAttribute("value", itemSelected.productId);
		            form.appendChild(hiddenField);
				}
			}
		    document.body.appendChild(form);
		    form.submit();
		});
	})
</script>
<#else>
	<div class="alert alert-info">${uiLabelMap.DAQuotationUpdatePermissionError}</div>
</#if>
