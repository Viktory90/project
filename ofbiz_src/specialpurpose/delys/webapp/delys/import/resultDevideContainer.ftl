<#assign contCreated = parameters.contCreated !>
<#assign listLotToDoAgreement = parameters.listLotToDoAgreement !>
<#assign productIdHeader = parameters.listProductIdHeader !>
<#assign productPlanIdCont = parameters.productPlanHeader!>
<#assign orderMode = 'PURCHASE_ORDER' !>
<#assign partyIdCont = parameters.partyId !>
<#assign listPartyContactMechs = parameters.listPartyContactMechs !>

<div id="pos-show-hold-cart" style="width: 80%;" class="modal hide fade modal-dialog" tabindex="-1">
<div class="modal-header no-padding">
	<div class="table-header">
		<button type="button" class="close" data-dismiss="modal">&times;</button>
		<#if listLotToDoAgreement?exists && productIdHeader?exists && productPlanIdCont?exists>
			${uiLabelMap.DetailCont}
			<#else>
			${uiLabelMap.DetailCont}
		</#if>
	</div>
</div>
<div class="modal-body" id="bodyCont">
	<#if listLotToDoAgreement?exists && productIdHeader?exists && productPlanIdCont?exists>
		<table class="table table-striped table-bordered table-hover no-margin-bottom no-border-top">
			<thead>
				<tr>
					<td style="width: 20px;">${uiLabelMap.No}</td>
					<td style="width: 100px;">${uiLabelMap.editorAgreement}</td>
					<#list productIdHeader as pro>
						<#assign pr = pro.internalName !>
						<td>
							${pr} (${pro.description})
						</td>
					</#list>
				</tr>
			</thead>
			<tbody>
				<#assign count = 1 !>
				<#list listLotToDoAgreement as lot>
					<#assign lotIdCont = lot.lot !>
					<tr>
						<td>${count}</td>
						<td id="tdAgreeDetail_${count}" onmouseenter = "tooltipEditAgree('${count}')">
							<a href="javascript:showPopup2('${orderMode}', '${lotIdCont}', '${productPlanIdCont}')" class="green"> ${lotIdCont} </a>
						</td>
						<#list productIdHeader as pro1>
							<#assign value = 0 />
							<#assign listLotItem = lot.listProductLot !>
							<#assign product1 = pro1.productId !>
							<#assign uom="" !>
							<#list listLotItem as lotItem>
								<#assign product2 = lotItem.productId !>
								<#if product1 == product2>
									<#assign valueLotQuantity = lotItem.lotQuantity !>
									<#assign value = valueLotQuantity !>
									<#assign uom = lotItem.description !>	
								</#if>
							</#list>
							<td style="text-align: right;">${value?string(",##0")}</td>
						</#list>
					</tr>
					<#assign count = count + 1 !>
				</#list>
			</tbody>
		</table>
		<#else>
			${uiLabelMap.NotCont}
	</#if>
</div>
	<div class="modal-footer">
		<button class="btn btn-small btn-danger pull-left" id="resetCont">
			<i class="icon-refresh"></i>
			Reset
		</button>
	</div>
</div>



<div id="showPopupEditAgreement">
	
</div>

<style type="text/css">
.modal-dialog {
 margin: 0;
    position: absolute;
    outline: none;
    left: 10%;
   }
.modal.fade.in{
 	top: 0%;
}  
}   
</style>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript">

function showPopup2(orderMode, lotId, productPlanId){
	onLoadData();
	$.ajax({
		url: 'showPopupEditPurchaseAgreement?orderMode='+orderMode+'&lotId='+lotId+'&productPlanId='+productPlanId,
    	type: "POST",
    	data: {},
    	async: false,
    	success: function(data) {
    		$('#pos-show-hold-cart').modal('hide');
    		//$("#step1").html(data);
    		$("#showPopupEditAgreement").html(data);
			$('#show-Aggree').modal('show');
// alert(data);
    	},
    	error: function(data){
    	}
		}).done(function() {
			onLoadDone();
		});
	
}

$(document).ready(function(){
	
	$('.modal .modal-body').css('max-height', $(window).height() * 0.75);
	
});
</script>

<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>
<script type="text/javascript">
$('#resetCont').on('click', function(){
	var productPlanId2 = "${productPlanIdCont}";
	$.ajax({
		url: 'resetDevideContainer',
    	type: "POST",
    	data: {productPlanId: productPlanId2},
    	async: false,
    	success: function(data) {
    		//$("#bodyCont").empty();
    		window.setTimeout('location.reload()', 3000);
    	},
    	error: function(data){
//    		$('#test').html(data);
    	}
		}).done(function() {
	    	onLoadDone();
		});
});

$('#resetCont').on('hover', function(){
	var data = '${uiLabelMap.ResetContainer}';
	$('#resetCont').jqxTooltip({ content: data, position: 'bottom', opacity: 1 });
});

function tooltipEditAgree(count){
	var data = '${uiLabelMap.EditUpdateAgreement}';
	$('#tdAgreeDetail_'+count).jqxTooltip({ content: data, position: 'top', opacity: 1 });
}
</script>
