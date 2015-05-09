$(window).bind('beforeunload', function(e) {
	    if (confirm) {
	        return "Are you sure?";
	    }
});
$(document).ready(function(){
//	$(document).bind('contextmenu', function (e) {
//        e.preventDefault();
//      });
	$("#fromDate").jqxDateTimeInput();
	$("#thruDate").jqxDateTimeInput();
	$('#thruDate').val(null);
	$("select[name='Product']").change(function(){
		var product = $("select[name='Product'] option:selected").text();
		$("input[name='ProductName']").val(product);
		$("input[name='xdspcdkn']").val(product);
	});
	$("input[name='txtNhaSanXuat']").change(function(){
		var txtNhaSanXuat = $("input[name='txtNhaSanXuat']").val();
		$("input[name='Manufacturer']").val(txtNhaSanXuat);
	});
	
	$("input[name='txtXuatXu']").change(function(){
		var txtXuatXu = $("input[name='txtXuatXu']").val();
		$("input[name='txtorigin']").val(txtXuatXu);
	});
	$("input[name='txtNhaXuatKhau']").change(function(){
		var txtNhaXuatKhau = $("input[name='txtNhaXuatKhau']").val();
		$("input[name='Exporter']").val(txtNhaXuatKhau);
	});
	$("textarea[name='Components']").change(function(){
		var Components = $("textarea[name='Components']").val();
		$("textarea[name='Components2']").val(Components);
	});
	$("textarea[name='Instruction']").change(function(){
		var Instruction = $("textarea[name='Instruction']").val();
		$("input[name='txtInstruction']").val(Instruction);
	});
	$("textarea[name='Maintain']").change(function(){
		var Maintain = $("textarea[name='Maintain']").val();
		$("input[name='txtMaintain']").val(Maintain);
	});
	$("input[name='ManufacturerAddress']").change(function(){
		var ManufacturerAddress = $("input[name='ManufacturerAddress']").val();
		$("input[name='AddressManufacturer']").val(ManufacturerAddress);
	});
	$("textarea[name='Importer']").change(function(){
		var Importer = $("textarea[name='Importer']").val();
		$("textarea[name='Importer2']").val(Importer);
	});
	$("input[name='NetWeight']").change(function(){
		var NetWeight = $("input[name='NetWeight']").val();
		$("input[name='txtNetWeight']").val(NetWeight);
	});
	$("input[name='DVNK']").change(function(){
		var DVNK = $("input[name='DVNK']").val();
		$("textarea[name='Importer']").val(DVNK);
		$("textarea[name='Importer2']").val(DVNK);
		$("input[name='organizationName']").val(DVNK);
	});
	$("input[name='AddressDVNK']").change(function(){
		var AddressDVNK = $("input[name='AddressDVNK']").val();
		$("textarea[name='AddressImporter']").val(AddressDVNK);
		$("textarea[name='organizationAddress']").val(AddressDVNK);
	});
	$("input[name='dateOfManufacture']").change(function(){
		var dateOfManufacture = $("input[name='dateOfManufacture']").val();
		$("input[name='dateOfManufacture2']").val(dateOfManufacture);
	});
	$("input[name='ExpireDate']").change(function(){
		var ExpireDate = $("input[name='ExpireDate']").val();
		$("input[name='shelfLife2']").val(ExpireDate);
	});
});
function btnCreateClick() {
	window.onbeforeunload = null;
	var productId = $("select[name='Product']").val();
	var qualityPublicationName = $("input[name='NumberQP']").val();
	var fromDate = $("#fromDate").val().toTimeStamp();
	var thruDate = $("#thruDate").val().toTimeStamp();
	var expireDate = $("input[name='txtExpireDay']").val();
	if (productId == "") {
		$("select[name='Product']").focus();
		return false;
	}
	if (qualityPublicationName == "") {
		$("input[name='NumberQP']").focus();
		return false;
	}
	if (expireDate == "") {
		$("input[name='txtExpireDay']").focus();
		return false;
	}
	if (fromDate == "") {
		$('#fromDate').jqxDateTimeInput('focus');
		return false;
	}
	if (thruDate == "") {
		$('#thruDate').jqxDateTimeInput('focus');
		return false;
	}
	saveQualityPublication(
			{productId: productId,
			qualityPublicationName : qualityPublicationName,
			fromDate : fromDate,
			thruDate : thruDate,
			expireDate : expireDate,}
			,"saveQualityPublicationAjax");
}
function saveQualityPublication(jsonObject, url) {
	jQuery.ajax({
        url: url,
        type: "POST",
        data: jsonObject,
        success: function(res) {
        	
        }
    }).done(function() {
    	var productId = $("select[name='Product']").val();
    	var header = "Cong bo chat luong san pham " + "[" + productId + "] sap het han";
    	createQuotaNotification(productId, "qaadmin", header);
	});
}
function createQuotaNotification(productId, partyId, messages) {
	var targetLink = "productId=" + productId;
	var action = "CreateProductQuality";
	var header = messages;
	var newDate = $("#thruDate").val();
	newDate = newDate.toMilliseconds() - (10*86400000);
	newDate = new Date(newDate);
	var dateNotify = newDate.toTimeStamp();
	var jsonObject = {partyId: partyId,
						header: header,
						openTime: dateNotify,
						action: action,
						targetLink: targetLink,};
	console.log(jsonObject);
	jQuery.ajax({
        url: "createQuotaNotification",
        type: "POST",
        data: jsonObject,
        success: function(res) {
        	
        }
    }).done(function() {
    	var newButton = "<input type='submit' class='btn btn-primary' value='createPDF'/>";
    	$("#myButton").html(newButton);
	});
}