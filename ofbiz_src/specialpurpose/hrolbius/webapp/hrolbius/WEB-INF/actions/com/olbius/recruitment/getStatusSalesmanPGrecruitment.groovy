context.statusId = "APPROVAL";
if(terminationTypeId){
	if(terminationTypeId.equals("FIRE")){
		context.statusId = "NOT_APPROVAL";
	}else if(terminationTypeId.equals("RESIGN")){
		context.statusId = "RESIGN";
	}
}