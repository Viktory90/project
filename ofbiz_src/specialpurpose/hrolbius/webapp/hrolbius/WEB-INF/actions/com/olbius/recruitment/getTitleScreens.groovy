import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;

applicationId = parameters.applicationId;
if(applicationId){
	GenericValue emplApp = delegator.findOne("EmploymentApp", UtilMisc.toMap("applicationId", applicationId), false);
	if(UtilValidate.isNotEmpty(emplApp)){
		statusId = emplApp.getString("statusId");
		GenericValue statusItem = delegator.findOne("StatusItem", UtilMisc.toMap("statusId", statusId), false);
		context.title = UtilProperties.getMessage("RecruitmentUiLabels", "EditEmployeePgProfile", locale) + " - " + UtilProperties.getMessage("CommonUiLabels", "CommonStatus", locale) + ": " + statusItem.getString("description") ;	
	}else{
		context.title = UtilProperties.getMessage("RecruitmentUiLabels", "AddNewEmployeePgProfile", locale);
	}
}