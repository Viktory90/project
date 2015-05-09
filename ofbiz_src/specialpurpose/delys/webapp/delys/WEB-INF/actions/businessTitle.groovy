import java.util.*;
import org.ofbiz.base.util.UtilMisc;
if (userLogin != null){
String partyId = userLogin.getString("partyId");
List<GenericValue> roleTypeList = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyId), null, false);
Set<String> businessMenus = new HashSet<String>();
for (roleType in roleTypeList) {
	if (context.businessTitle ==null){
		String roleTypeId = roleType.getString("roleTypeId");
		GenericValue titleRoleTypeAttr = delegator.findOne("RoleTypeAttr" ,UtilMisc.toMap("roleTypeId", roleTypeId, "attrName", "BusinessTitle"), false);
		if (titleRoleTypeAttr != null){
			context.businessTitle =titleRoleTypeAttr.getString("attrValue");
		}
	}
}
}