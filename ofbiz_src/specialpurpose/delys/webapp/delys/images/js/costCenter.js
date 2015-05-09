function saveCostCenters(listGlCategory){
	var griddata = $('#jqxgrid').jqxGrid('getdatainformation');
	listGlCategory = listGlCategory.trim();	
	var listGLC = listGlCategory.split(" ");
	
	var rowCount = griddata.rowscount;
	var costCenters = new Array();
	
	if (rowCount > 0) {
		for (var i = 0; i < rowCount; i++) {
			var row = $("#jqxgrid").jqxGrid('getrowdata', i);
			var costCenter = new Object;
			if(row.organizationPartyId){
				costCenter.organizationPartyId = row.organizationPartyId;
			}else{
				costCenter.organizationPartyId = null;
			}
			if(listGLC){
				for (var z= 0; z < listGLC.length; z++) {
					var glCategoryId = listGLC[z];
					costCenter[''+glCategoryId] = row[''+glCategoryId];
				}
				
			}
			if(row.glAccountId){
				costCenter.glAccountId = row.glAccountId;
			}else{
				costCenter.glAccountId = null;
			}
			if(row.accountCode){
				costCenter.accountCode = row.accountCode;
			}else{
				costCenter.accountCode = null;
			}
			if(row.accountName){
				costCenter.accountName = row.accountName;
			}else{
				costCenter.accountName = null;
			}
			
			costCenters.push(costCenter);
			
		}

	}
	var param = "costCenters=" + JSON.stringify(costCenters);
	
	$.ajax({
		url : 'updateCostCenters',
		data : param,
		type : 'post',
		async : false,

		success : function(data) {
			console.log("mmmm");
			getResultOfSaveCostCenters(data);

		},
		error : function(data) {
			console.log("mmmm1");
			getResultOfSaveCostCenters(data);
		}
	});
}

function getResultOfSaveCostCenters(data) {
    var serverError = getServerError(data);
    $('#jqxgrid').jqxGrid('updatebounddata');
    if (serverError != "") {
    	
    	$('#jqxNotification').jqxNotification({ template: 'error'});
    	$("#jqxNotification").text(serverError);
    	$("#jqxNotification").jqxNotification("open");
    	
       
    } else {
    	$('#jqxNotification').jqxNotification({ template: 'info'});
    	$("#jqxNotification").text("Success");
    	$("#jqxNotification").jqxNotification("open");
    	
       
    }
  
   
}
function getServerError(data) {
    var serverErrorHash = [];
    var serverError = "";
   
    
    if (data._ERROR_MESSAGE_LIST_ != undefined) {
    	
        serverErrorHash = data._ERROR_MESSAGE_LIST_;
        jQuery.each(serverErrorHash, function(i, error) {
          if (error != undefined) {
              if (error.message != undefined) {
                  serverError += error.message;
              } else {
                  serverError += error;
              }
            }
        });
    }
    if (data._ERROR_MESSAGE_ != undefined) {
    	
        serverError = data._ERROR_MESSAGE_;
    }
    
    return serverError;
}