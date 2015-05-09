
<div class="row-fluid">
	<h4 id="step-title" class="header smaller lighter blue span3" style="margin-bottom:0 !important; border-bottom: none; margin-top:3px !important; padding-bottom:0">${uiLabelMap.DAInputInfoOrder}</h4>
	<div id="fuelux-wizard" class="row-fluid hide span8" data-target="#step-container">
		<ul class="wizard-steps wizard-steps-mini">
			<li data-target="#step1" class="active">
				<span class="step" data-rel="tooltip" title="${uiLabelMap.DAInputInfoOrder}" data-placement="bottom">1</span>
			</li>

			<li data-target="#step2">
				<span class="step" data-rel="tooltip" title="${uiLabelMap.DAOrderConfirmation}" data-placement="bottom">2</span>
			</li>
		</ul>
	</div>
	<div class="span1 align-right" style="padding-top:5px">
		<a href="<@ofbizUrl>emptyPurchaseCartDis</@ofbizUrl>" data-rel="tooltip" title="${uiLabelMap.DAClearOrder}" data-placement="bottom" class="no-decoration"><i class="icon-trash icon-only" style="font-size:16pt"></i></a>
	</div>
	<div style="clear:both"></div>
	<hr style="margin: 8px 0" />

	<div class="step-content row-fluid position-relative" id="step-container">
		<div class="step-pane active" id="step1">
			<#include "checkInitsSalesJQ.ftl"/>
		</div>

		<div class="step-pane" id="step2">
			<div class="row-fluid">
				<h4 class="header smaller lighter blue">${uiLabelMap.DAOrderConfirmation}</h4>
				<div>${uiLabelMap.DAProcessing} ... </div>
			</div>
		</div>
	</div>
	
	<div class="row-fluid wizard-actions">
		<button class="btn btn-prev btn-small" id="btnPrevWizard">
			<i class="icon-arrow-left"></i>
			${uiLabelMap.DAPrev}
		</button>
		<button class="btn btn-success btn-next btn-small" data-last="${uiLabelMap.DAFinish}" id="btnNextWizard">
			${uiLabelMap.DANext}
			<i class="icon-arrow-right icon-on-right"></i>
		</button>
	</div>
</div>

<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxvalidator.js"></script>
<script src="/delys/images/js/fuelux/fuelux.wizard.min.js"></script>
<script src="/delys/images/js/additional-methods.min.js"></script>
<script src="/delys/images/js/bootbox.min.js"></script>
<script src="/delys/images/js/jquery.maskedinput.min.js"></script>
<script src="/delys/images/js/select2.min.js"></script>
<script type="text/javascript">
	//"partyId=" + $("input[name='partyId']").val(),
	$("input[name='partyId']").on("blur", function(){
		updateCheckoutArea();
	});
	
	function updateCheckoutArea () {
		var partyId = $("input[name='partyId']").val();
		if (partyId && !(/^\s*$/.test(partyId))) {
			var data = $("#initOrderEntry").serialize();
			data += "&preContactMechTypeId=POSTAL_ADDRESS&contactMechPurposeTypeId=SHIPPING_LOCATION";
			$.ajax({
				type: "POST", 
				url: "quickCheckoutAjaxSales",
				data: data, 
				beforeSend: function () {
					$("#checkoutInfoLoader").show();
				}, 
				success: function (data) {
					$("#checkoutInfo").html(data);
					$("#checkoutInfoLoader").hide();
					$('#container').empty();
				}, 
				error: function() {
					//commit(false);
				}
			});
		}
	}

	function createCart() {
		if (productQuantities.length > 0) {
			var strParam = "N";
			var countQuantity = 0;
			for (i = 0; i < productQuantities.length; i++) {
				var rowData = productQuantities[i];
	   			var productId = rowData.productId;
	   			var quantity = rowData.quantity;
	   			var quantityUomId = rowData.quantityUomId;
	   			var expireDate = rowData.expireDate;
	   			if (quantityUomId == undefined) {
	   				quantityUomId = "";
	   			}
	   			if (expireDate == undefined) {
	   				expireDate = "";
	   			}
	   			countQuantity += quantity;
				strParam += "|OLBIUS|" + productId + "|SUIBLO|" + quantity + "|SUIBLO|" + quantityUomId + "|SUIBLO|" + expireDate;
			}
			if (countQuantity <= 0) {
				bootbox.dialog("${uiLabelMap.DAYouNotYetChooseProduct}!", [{
					"label" : "OK",
					"class" : "btn-small btn-primary",
					}]
				);
				return false;
			} else {
				//  style='color:#b94a48'
				data = $("#initOrderEntry").serialize();
				data += "&" + $("#checkoutInfoForm").serialize();
				data += "&desiredDeliveryDate=" + $("#desiredDeliveryDate2").val();
				data += "&strParam=" + strParam;
				var isSuccess = false;
				$.ajax({
		            type: "POST",                        
		            url: "initPurchaseOrderEntryDis",
		            data: data,
		            async: false, 
		            beforeSend: function () {
						$("#checkoutInfoLoader").show();
					}, 
		            success: function (data) {
		            	if (data.thisRequestUri == "json") {
		            		isSuccess = false;
		            		var errorMessage = "";
					        if (data._ERROR_MESSAGE_LIST_ != null) {
					        	for (var i = 0; i < data._ERROR_MESSAGE_LIST_.length; i++) {
					        		errorMessage += "<p><b>${uiLabelMap.DAErrorUper}</b>: " + data._ERROR_MESSAGE_LIST_[i] + "</p>";
					        	}
					        }
					        if (data._ERROR_MESSAGE_ != null) {
					        	errorMessage += "<p><b>${uiLabelMap.DAErrorUper}</b>: " + data._ERROR_MESSAGE_ + "</p>";
					        }
					        if (errorMessage != "") {
					        	$('#container').empty();
					        	$('#jqxNotification').jqxNotification({ template: 'info'});
					        	$("#jqxNotification").html(errorMessage);
					        	$("#jqxNotification").jqxNotification("open");
					        } else {
					        	$('#container').empty();
					        	$('#jqxNotification').jqxNotification({ template: 'info'});
					        	$("#jqxNotification").html("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
					        	$("#jqxNotification").jqxNotification("open");
					        }
		            	} else {
		            		isSuccess = true;
		            		$("#step-title").html("${uiLabelMap.DAOrderConfirmation}");
		            		$("#step2").html(data);
		            	}
		            },
		            error: function () {
		                //commit(false);
		            },
		            complete: function() {
				        $("#checkoutInfoLoader").hide();
				    }
		        });
			}
			
	        return isSuccess;
		} else {
			//bootbox.alert("${uiLabelMap.DAYouNotYetChooseProduct}!");
			bootbox.dialog("${uiLabelMap.DAYouNotYetChooseProduct}!", [{
				"label" : "OK",
				"class" : "btn-small btn-primary",
				}]
			);
			return false;
		}
	}
	<#--
	/* function (data, status, xhr) {}
    	var errorMessage = "";
        if (data._ERROR_MESSAGE_LIST_ != null) {
        	for (var i = 0; i < data._ERROR_MESSAGE_LIST_.length; i++) {
        		errorMessage += "<p><b>${uiLabelMap.DAErrorUper}</b>: " + data._ERROR_MESSAGE_LIST_[i] + "</p>";
        	}
        }
        if (data._ERROR_MESSAGE_ != null) {
        	errorMessage += "<p><b>${uiLabelMap.DAErrorUper}</b>: " + data._ERROR_MESSAGE_ + "</p>";
        }
        if (errorMessage != "") {
        	$('#container').empty();
        	$('#jqxNotification').jqxNotification({ template: 'info'});
        	$("#jqxNotification").html(errorMessage);
        	$("#jqxNotification").jqxNotification("open");
        } else {
        	$('#container').empty();
        	$('#jqxNotification').jqxNotification({ template: 'info'});
        	$("#jqxNotification").html("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
        	$("#jqxNotification").jqxNotification("open");
        }
    	*/
        /*// update command is executed.
        if(data.responseMessage == "error"){
        	//commit(false);
        	$('#jqxNotification').jqxNotification({ template: 'error'});
        	$("#jqxNotification").text(data.errorMessage);
        	$("#jqxNotification").jqxNotification("open");
        }else{
        	//commit(true);
        	$('#container').empty();
        	$('#jqxNotification').jqxNotification({ template: 'info'});
        	$("#jqxNotification").text("${StringUtil.wrapString(uiLabelMap.wgupdatesuccess)}");
        	$("#jqxNotification").jqxNotification("open");
        }*/
	if (("_ERROR_MESSAGE_LIST_" in data) || ("_ERROR_MESSAGE_" in data)) {
            		$('#jqxNotification').jqxNotification({ template: 'error'});
                	var errorMessage = "";
                	var errorList = data;
            		console.log(errorList);
                	$("#jqxNotification").jqxNotification("open");
            	}
	-->
	
	//$.mask.definitions['n']='[0-9]';
	$(".input-mask-product").keydown(function (e) {
        if (e.keyCode == 13) {
        	var elementName = $(this).attr("name");
        	var elementNameArray = elementName.split("_o_");
        	if (elementNameArray[1] != null) {
        		var elementNumber = parseInt(elementNameArray[1]);
        		var elementNameNext = elementNameArray[0] + "_o_" + (elementNumber + 1);
        		$("input[name='" + elementNameNext + "']").focus();
        	}
        } else if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110]) !== -1 ||
            		(e.keyCode == 65 && e.ctrlKey === true) || 
            		(e.keyCode >= 35 && e.keyCode <= 40)) {
     		return;
        }
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    });
</script>
<script type="text/javascript">
	$(function() {
		$('[data-rel=tooltip]').tooltip();
	
		$(".select2").css('width','150px').select2({allowClear:true})
		.on('change', function(){
			$(this).closest('form').validate().element($(this));
		}); 
	
		var $validation = false;
		$('#fuelux-wizard').ace_wizard().on('change' , function(e, info){
			//if(info.step == 1 && $validation) {
			//	if(!$('#validation-form').valid()) return false;
			//}
			if ((info.step == 1) && (info.direction == "next")) {
				$('#container').empty();
				if(!$('#initOrderEntry').jqxValidator('validate')) return false;
				var strValue = createCart();
				if (strValue != true) {
					return false;
				}
			}
		}).on('finished', function(e) {
			bootbox.confirm("${uiLabelMap.DAAreYouSureCreate}", function(result) {
				if(result) {
					$("#btnPrevWizard").addClass("disabled");
					$("#btnNextWizard").addClass("disabled");
					window.location.href = "processPurchaseOrderDis";
				}
			});
			
		}).on('stepclick', function(e){
			//return false;//prevent clicking on steps
		});
		
		$('#initOrderEntry').jqxValidator({
        	rules: [
        		{input: '#currencyUomId', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
        			function (input, commit) {
						if($('#currencyUomId').val() == null || $('#currencyUomId').val() == ''){
							return false;
						}
						return true;
					}
				},
				{input: '#partyId', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
					function (input, commit) {
						if($('#partyId').val() == null || $('#partyId').val() == ''){
							return false;
						}
						return true;
					}
				},
				{input: '#desiredDeliveryDate2', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 
					function (input, commit) {
						if($('#desiredDeliveryDate2').jqxDateTimeInput('getDate') == null || $('#desiredDeliveryDate2').jqxDateTimeInput('getDate') == ''){
							return false;
						}
						return true;
					}
				},
				{input: '#desiredDeliveryDate2', message: '${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherToDay)}', action: 'blur', rule: 
					function (input, commit) {
						var now = new Date();
						now.setHours(0,0,0,0);
		        		if(input.jqxDateTimeInput('getDate') < now){
		        			return false;
		        		}
		        		return true;
		    		}
				}
        	]
        });
		
		<#--
		,
		{input: '#partyId', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 'required'},
		{input: '#desiredDeliveryDate', message: '${uiLabelMap.DAThisFieldIsRequired}', action: 'blur', rule: 'required'},
		{input: '#desiredDeliveryDate', message: '${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherToDay)}', action: 'blur', rule: 
			function (input, commit) {
				var now = new Date();
				now.setHours(0,0,0,0);
        		if(input.jqxDateTimeInput('getDate') < now){
        			return false;
        		}
        		return true;
    		}
		}
		
		$.validator.addMethod('validateToDay',function(value,element){
			var now = new Date();
			now.setHours(0,0,0,0);
			return Date.parseExact(value,"dd/MM/yyyy HH:mm:ss") >= now;
		},'Greather than today');
		$('#initOrderEntry').validate({
			errorElement: 'span',
			errorClass: 'help-inline',
			focusInvalid: false,
			rules: {
				currencyUomId: {
					required: true
				},
				partyRoleTypesApply: {
					required: true
				},
				quotationName: {
					required: true
				},
				desiredDeliveryDate_i18n:{
					validateToDay:true
				},
				partyId:{
					required: true
				}
			},
			messages: {
				currencyUomId: {
					required: "${uiLabelMap.DAThisFieldIsRequired}"
				},
				partyRoleTypesApply: {
					required: "${uiLabelMap.DAThisFieldIsRequired}"
				},
				quotationName: {
					required: "${uiLabelMap.DAThisFieldIsRequired}"
				},
				desiredDeliveryDate_i18n:{
					validateToDay:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherToDay)}"
				},
				partyId:{
					required: "${uiLabelMap.DAThisFieldIsRequired}"
				}
			},
			invalidHandler: function (event, validator) { //display error alert on form submit   
				$('.alert-error', $('.login-form')).show();
			},
			highlight: function (e) {
				$(e).closest('.control-group').removeClass('info').addClass('error');
			},
			unhighlight: function(element, errorClass) {
	    		var parentControls = $(element).closest(".controls");
	    		if (parentControls != undefined) {
	    			parentControls.find("ul.chzn-choices").css("border", "1px solid #64a6bc");
	    		}
	    	},
			success: function (e) {
				$(e).closest('.control-group').removeClass('error').addClass('info');
				$(e).remove();
			},
			errorPlacement: function (error, element) {
				var parentControls = element.closest(".controls");
				if (parentControls != undefined) {
					error.appendTo(parentControls);
					parentControls.find("ul.chzn-choices").css("border", "1px solid #f09784");
				}
			}
		});
		-->
	})
</script>