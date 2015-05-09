<div id="show-Aggree" style="width: 80%;" class="modal hide fade modal-dialog" tabindex="-1">
<div class="modal-header no-padding">
	<div class="table-header">
		<button type="button" class="close" data-dismiss="modal">&times;</button>
		${uiLabelMap.EditAgreementToSendSupp}
	</div>
</div>
<div class="modal-body no-padding">
<div class="widget-body">
<div class="widget-main">
	
	<div class="row-fluid">
		<div id="fuelux-wizard" class="row-fluid">
		  <ul class="wizard-steps">
			<li data-target="#step1" class="active"><span class="step">1</span> <span class="title">${uiLabelMap.EditUpdateAgreement}</span></li>
			<li data-target="#step2"><span class="step">2</span> <span class="title">${uiLabelMap.ViewAgreement}</span></li>
			<li data-target="#step3"><span class="step">3</span> <span class="title">${uiLabelMap.SendAccountant}</span></li>
		  </ul>
		</div>
		
		<hr />
		
		<div class="step-content row-fluid position-relative">
			<div class="step-pane active" id="step1">
				${screens.render("component://delys/widget/import/ImportScreens.xml#EditPurchaseAgreement2")}
			</div>
			
			<div class="step-pane" id="step2">
				<div class="row-fluid">
					<div id="test">
					</div>
				</div>
			</div>
			
			<div class="step-pane" id="step3">
				<div class="center">
					<div id="emailSuccess"></div>
					<h3 class="blue lighter">${uiLabelMap.sendAgreementForAcc}</h3>
					<div class='row-fluid'>
						<div class='span12 no-left-margin'>
							<div class='span4'>${uiLabelMap.dateSend}: </div>
							<div class='span8'><div id='ngayGui'></div></div>
						</div>
						<div class='span12 no-left-margin'>
							<div class='span2'></div>
							<div class='span8'><button style='margin-right: 5px;' id='btnSentNotify' class="btn fa-send-o">${uiLabelMap.SentNotify}</button></div>
						</div>
					</div>
					<input type="hidden" id="agrIdAcc"/>
				</div>
			</div>
		</div>
		
		<hr />
		
		<div class="row-fluid wizard-actions">
			<button class="btn btn-prev"><i class="icon-arrow-left"></i> Prev</button>
			<button class="btn btn-success btn-next" data-last="Finish ">Next <i class="icon-arrow-right icon-on-right"></i></button>
		</div>
	</div>

</div><!--/widget-main-->
</div><!--/widget-body-->
</div>

</div>

<script type="text/javascript">

$('#show-Aggree').on('hide', function(){
	$('#pos-show-hold-cart').modal('show');
});


$(function() {

$('[data-rel=tooltip]').tooltip();

$(".chzn-select").css('width','150px').chosen({allow_single_deselect:true , no_results_text: "No such state!"})
.on('change', function(){
$(this).closest('form').validate().element($(this));
}); 

var agr= '';
var $validation = false;
$('#fuelux-wizard').ace_wizard().on('change' , function(e, info){
if(info.step == 1) {
	
//	var agreementId = $("input[name=agreementId]").val();
	var agreementId = $("#EditPurchaseAgreement2_agreementId").val();
	var agreementTypeId = $("input[name=agreementTypeId]").val();
	var agreementDate = $("input[name=agreementDate]").val();
	var agreementName = $("input[name=agreementName]").val();
	var fromDate = $("input[name=fromDate]").val();
	var thruDate = $("input[name=thruDate]").val();
	var weekETD = $("input[name=weekETD]").val();
	var partyIdFrom = $('select[name=partyIdFrom]').val();
	var roleTypeIdFrom = $("select[name=roleTypeIdFrom]").val();
	var representPartyIdFrom = $("select[name=representPartyIdFrom]").val();
	var addressIdFrom = $("select[name=addressIdFrom]").val();
	var telephoneIdFrom = $("select[name=telephoneIdFrom]").val();
	var faxNumberIdFrom = $("select[name=faxNumberIdFrom]").val();
	var finAccountIdFroms = $("select[name=finAccountIdFroms]").val();
	var partyIdTo = $("select[name=partyIdTo]").val();
	var roleTypeIdTo = $("select[name=roleTypeIdTo]").val();
	var addressIdTo = $("select[name=addressIdTo]").val();
	var finAccountIdTos = $("select[name=finAccountIdTos]").val();
	var currencyUomIds = $("select[name=currencyUomIds]").val();
	console.log(currencyUomIds);
	var emailAddressIdTo = $("select[name=emailAddressIdTo]").val();
	var description = $("input[name=description]").val();
	var textData = $("input[name=textData]").val();
	var lotId = $("input[name=lotId]").val();
	var productPlanId = $('#EditPurchaseAgreement2_productPlanId').val();
	var portOfDischargeId = $("select[name=portOfDischargeId]").val();
	var facilityId = $("select[name=facilityId]").val();
	var productStoreId = $("select[name=productStoreId]").val();
	var contactMechId = $("select[name=contactMechId]").val();
	var transshipment = $("select[name=transshipment]").val();
	var partialShipment = $("select[name=partialShipment]").val();
	var statusId = $("input[name=statusId]").val();
	if(agreementName == null || agreementName == '') return false;
	onLoadData();
//	alert(agreementId);
//	
// $('#test').html('<h4>'+productPlanId+'</h4></hr><h6>'+agreementName+'</h6>');
	$.ajax({
		url: 'updatePurchaseAgreement2',
    	type: "POST",
    	data: {agreementId: agreementId, agreementTypeId: agreementTypeId, agreementDate:agreementDate, fromDate: fromDate, thruDate: thruDate,
    		weekETD: weekETD, partyIdFrom: partyIdFrom, roleTypeIdFrom: roleTypeIdFrom, representPartyIdFrom: representPartyIdFrom, addressIdFrom: addressIdFrom,
    		telephoneIdFrom: telephoneIdFrom, faxNumberIdFrom: faxNumberIdFrom, finAccountIdFroms: finAccountIdFroms, partyIdTo: partyIdTo, roleTypeIdTo: roleTypeIdTo,
    		addressIdTo: addressIdTo, finAccountIdTos: finAccountIdTos, currencyUomIds: currencyUomIds, emailAddressIdTo: emailAddressIdTo, description: description, textData:textData,
    		lotId: lotId, agreementName: agreementName, productPlanId: productPlanId, portOfDischargeId: portOfDischargeId, facilityId: facilityId, productStoreId: productStoreId,
    		contactMechId: contactMechId, transshipment: transshipment, partialShipment: partialShipment, statusId: statusId
    	},
    	async: false,
    	success: function(data) {
    		$('#test').html(data);
    	},
    	error: function(data){
    		$('#test').html(data);
    	}
		}).done(function() {
	    	onLoadDone();
		});
}

if(info.step == 2){
	var agr = $('#agrId').val();
	$('#agrIdAcc').val(agr);
	
}
}).on('finished', function(e) {
	$('#show-Aggree').modal('hide');
});

});
$("#ngayGui").jqxDateTimeInput();
$("#btnSentNotify").jqxButton();
$("#btnSentNotify").click(function () {
	var agrAcc = $('#agrIdAcc').val();
	var header = "Hop dong " + agrAcc + " can duoc duyet";
	var openTime = $('#ngayGui').jqxDateTimeInput('getDate');
	createQuotaNotification2(agrAcc, "chiefAccountant", header, openTime);
});
function createQuotaNotification2(agreementId, partyId, messages, openTime) {
	// HEADOFCOM 
		var targetLink = "agreementId=" + agreementId;
		var action = "getPendingAgreements";
		var header = messages;
		openTime = getDateTimestamp(openTime);
		var jsonObject = {partyId: partyId,
							header: header,
							openTime: openTime,
							action: action,
							targetLink: targetLink,};
		jQuery.ajax({
	        url: "createQuotaNotification",
	        type: "POST",
	        data: jsonObject,
	        success: function(res) {
	        	
	        }
	    }).done(function() {
	    	onLoadDone();
	    	var message = "<div id='contentMessages' class='alert alert-success'>" +
			"<p id='thisP' onclick='hiddenClick()'>" + '${uiLabelMap.SendSuccess}' + "</p></div>";
	    	$("#emailSuccess").html(message);
		});
	}
function getDateTimestamp(dateNotify) {
	var getFullYear = dateNotify.getFullYear();
	var getDate = dateNotify.getDate();
	var getMonth = dateNotify.getMonth() + 1;
	if (getDate < 10) {
		getDate = '0' + getDate;
	}
	if (getMonth < 10) {
		getMonth = '0' + getMonth;
	}
	dateNotify = getFullYear + '-' + getMonth + '-' + getDate;
	return dateNotify;
}

</script>
