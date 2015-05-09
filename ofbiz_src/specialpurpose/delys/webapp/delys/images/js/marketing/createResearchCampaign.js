function setNotification(message){
	$("#notificationMk").html(message);
}
/*cost type is chosen*/
// var costChosen = [];
$(document).ready(function() {
	$("#submit").click(submitForm);
	$("#reset").click(resetForm);
	$("#productId").chosen();
	$("#place").chosen();
	initDate();
	var date = {};
	
	function initDate() {
		var currentDate = Utils.getCurrentDate();
		$('#fromDate').daterangepicker({
			format : "DD-MM-YYYY",
			minDate : currentDate,
			startDate : currentDate
		}, function(start, end, label) {
			date = {
				fromDate : start.format("YYYY-MM-DD"),
				thruDate : end.format("YYYY-MM-DD")
			};
		});
	}
	/*add costs category*/
	

	function submitForm() {
		var mkId = Utils.getUrlParameter("id");
		var action = mkId ? "createResearchCampaign" : "updateResearchCampaign";
		var costList = JSON.stringify(getCostList());
		var products = JSON.stringify($("#productId").val());

		var data = {
			fromDate : date.fromDate,
			thruDate : date.thruDate,
			people : $("#people").val(),
			marketingPlace: $("#place").val(),
			estimatedCost : $("#estimatedCost").val(),
			budgetedCost : $("#budgetedCost").val(),
			isActive : $("#isActive").val(),
			campaignName : $("#campaignName").val(),
			campaignSummary : $("#campaignSummary").val(),
			// statusId: $("#isActive").val(),
			productId : products,
			costList : costList
		};
		// return;/	
		$.ajax({
			url : action,
			type : "POST",
			data : data,
			dataType : "json",
			success : function(res) {
				if(res.message && res.message == "success"){
					var su = uiLabelMap && uiLabelMap.sendRequestSuccess ? uiLabelMap.sendRequestSuccess : "success"; 
					setNotification(su);
				}else{
					var su = uiLabelMap && uiLabelMap.sendRequestError ? uiLabelMap.sendRequestError : "error"; 
					setNotification(su);
				}
			}
		});
	}


	function validateForm() {

	}

	function resetForm() {

	}

});
