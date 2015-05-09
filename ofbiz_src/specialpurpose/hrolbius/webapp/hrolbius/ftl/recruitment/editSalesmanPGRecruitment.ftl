<div class="widget-body">	 
	<div class="widget-main">
		<div class="row-fluid">
			<div id="fuelux-wizard" class="row-fluid">
				<ul class="wizard-steps">
					<li data-target="#step1" style="min-width: 25%; max-width: 25%;" class="active"><span class="step">1</span> <span class="title">${uiLabelMap.GeneralInformation}</span></li>
					<li data-target="#step2" style="min-width: 25%; max-width: 25%;" ><span class="step">2</span> <span class="title">${uiLabelMap.ContactInformation}</span></li>					
					<li data-target="#step3" style="min-width: 25%; max-width: 25%;" ><span class="step">3</span> <span class="title">${uiLabelMap.RecruitmentInformation}</span></li>
					<li data-target="#step4" style="min-width: 25%; max-width: 25%;" ><span class="step">4</span> <span class="title">${uiLabelMap.OtherInformation}</span></li>
				</ul>
			</div>
			<hr>
			<div class="step-content row-fluid position-relative">
				<form name="editSalesmanPG" id="editSalesmanPG" method = "post" action = "<@ofbizUrl>CreateSalesmanPG</@ofbizUrl>">
					<div class="step-pane active" id="step1">
						<#include "applicantGeneralInfo.ftl">
					</div>	
					<div class="step-pane" id="step2">
						<#include "applicantContactInfo.ftl">
					</div>				
					<div class="step-pane" id="step3">
						<#include "recruitmentInfo.ftl">
					</div>
				</form>
			</div>
			<div class="row-fluid wizard-actions">
				<button class="btn btn-prev btn-small" id="btnPrev"><i class="icon-arrow-left"></i> ${uiLabelMap.CommonPrevious}</button>
				<button class="btn btn-success btn-next btn-small" id="btnNext" data-last="Finish ">${uiLabelMap.CommonNext} <i class="icon-arrow-right icon-on-right"></i></button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(document).ready(function() {
	var $validation = false;
	$('#fuelux-wizard').ace_wizard().on('change' , function(e, info){
		if(info.direction == "next"){
			if(!$('#editSalesmanPG').valid()) 
				return false;	
		}
	}).on('finished', function(e) {
		document.getElementById("editSalesmanPG").submit();
	});
					
$("#copyContactInfo").click(function(){
		address1 = jQuery("#address1_PermanentResidence").val();
		countryGeoId = jQuery("#permanentResidence_countryGeoId").val();
		stateGeoId = jQuery("#permanentResidence_stateProvinceGeoId").val();
		districtGeoId = jQuery("#permanentResidence_districtGeoId").val();
		wardGeoId = jQuery("#permanentResidence_wardGeoId").val();
		
		jQuery("#address1_CurrResidence").val(address1);
		jQuery("#currResidence_countryGeoId").val(countryGeoId);
		jQuery("#currResidence_countryGeoId").trigger("change");
		
		jQuery("#currResidence_stateProvinceGeoId").val(stateGeoId);
		jQuery("#currResidence_stateProvinceGeoId").trigger("change");
		
		jQuery("#currResidence_districtGeoId").val(districtGeoId);
		jQuery("#currResidence_districtGeoId").trigger("change");
		
		jQuery("#currResidence_wardGeoId").val(wardGeoId);
	});
});

$.validator.addMethod("validateGreat",function(value,element){
	if(value){
		var now= new Date();
		return Date.parseExact(value,"dd/MM/yyyy HH:mm:ss")>=now;
	}else{
		return true;
	}
},"less than today");

$.validator.addMethod("validateToday",function(value,element){
	if(value){
		var now= new Date();
		return Date.parseExact(value,"dd/MM/yyyy HH:mm:ss")<=now;
	}else{
		return true;
	}
},"less than today");

$.validator.addMethod("greatThan",function(value,element,params){
	if(value){
		if($(params).val()){
			return Date.parseExact(value,"dd/MM/yyyy HH:mm:ss")>Date.paresExact($(params).val(),"dd/MM/yyyy HH:mm:ss");
		}else{
			var now= new Date();
			return Date.parseExact(value,"dd/MM/yyyy HH:mm:ss")>now;
		}
	}else{
		return true;
	}
},"Great than params");
$('#editSalesmanPG').validate({
		errorElement: 'span',
		errorClass: 'help-inline red-color',
		focusInvalid: false,
		errorPlacement: function(error, element) {
			element.addClass("border-error");
    		if (element.parent() != null ){   
				element.parent().find("button").addClass("button-border");     			
    			error.appendTo(element.parent());
			}
    	  },
    	unhighlight: function(element, errorClass) {
    		$(element).removeClass("border-error");
    		$(element).parent().find("button").removeClass("button-border");
    	},
    	rules:{
    		firstName:{
    			required:true
    		},
    		lastName:{
    			required:true
    		},
    		idNumber:{
    			required:true
    		},
    		birthDate_i18n:{
    			validateToday:true
    		},
    		idIssueDate_i18n:{
    			validateToday:true
    		},
    		passportIssueDate_i18n:{
    			validateToday:true
    		},
    		passportExpiryDate_i18n:{
    			greatThan:"#passportIssueDate_i18n"
    		},
    		address1_PermanentResidence:{
    			required:true
    		},
    		recruitment_fromDate_i18n:{
    			required:true,
    			validateGreat:true
    		},
    		expectedSalary:{
    			required:true,
    			min:0
    		}
    		
    	},
    	messages:{
    		birthDate_i18n:{
    			validateToday:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredBirthDay)}"
    		},
    		idIssueDate_i18n:{
    			validateToday:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueSmallerToDay)}"
    		},
    		passportIssueDate_i18n:{
    			validateToday:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueSmallerToDay)}"
    		},
    		passportExpiryDate_i18n:{
    			greatThan:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherFromDateOrToday)}"
    		},
    		recruitment_fromDate_i18n:{
    			validateGreat:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherToDay)}"
    		},
    		expectedSalary:{
    			min:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValue)}"
    		}
    	}
});
</script>
