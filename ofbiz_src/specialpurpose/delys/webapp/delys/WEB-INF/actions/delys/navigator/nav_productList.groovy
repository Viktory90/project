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
	String menuName = businessMenus.iterator().next();
	if ("DELYS_SALESADMIN_GT".equals(menuName)) {
		context.selectedMenuItem = "product";
		context.selectedSubMenuItem = "listProduct";
	} else if ("DELYS_ACCOUNTANTS".equals(menuName)) {
		context.selectedMenuItem = "accApprovement";
		context.selectedSubMenuItem = "listProduct";
	}
}
