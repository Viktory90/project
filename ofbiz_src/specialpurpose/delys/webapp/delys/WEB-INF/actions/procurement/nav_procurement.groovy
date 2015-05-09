/*<set field="selectedMenuItem" value="product"/>
<set field="selectedSubMenuItem" value="listProduct"/>*/

import java.util.*;
import org.ofbiz.base.util.UtilMisc;

String partyId = userLogin.getString("partyId");
List<GenericValue> roleTypeList = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyId), null, false);
Set<String> businessMenus = new HashSet<String>();
for (roleType in roleTypeList) {
	String roleTypeId = roleType.getString("roleTypeId");
	
	GenericValue roleTypeAttr = delegator.findOne("RoleTypeAttr" ,UtilMisc.toMap("roleTypeId", roleTypeId, "attrName", "BusinessMenu"), false);
	if (roleTypeAttr != null){
		businessMenus.add(roleTypeAttr.getString("attrValue"));
	}
}
if (businessMenus) {
	
	String selectedSubMenuItem = "";
	String selectedMenuItem = "";
	String roleTypeId = "";
	String menuName = businessMenus.iterator().next();
	
	if ("DELYS_PROCURMENT".equals(menuName)) {
		selectedMenuItem = "listShoppingPoroposal";
		roleTypeId = "DELYS_PROCURMENT";
		
	} else if ("DELYS_REQUEST".equals(menuName)) {
		selectedMenuItem = "request";
		roleTypeId = "DELYS_REQUEST";
	}else if ("DELYS_CEO".equals(menuName)) {
		roleTypeId = "DELYS_CEO";
		selectedMenuItem = "procurement";
		selectedSubMenuItem  = "listShoppingPoroposal"
	}
	
	context.selectedSubMenuItem =selectedSubMenuItem ;
	context.selectedMenuItem = selectedMenuItem;
	context.roleTypeId = roleTypeId;
}
