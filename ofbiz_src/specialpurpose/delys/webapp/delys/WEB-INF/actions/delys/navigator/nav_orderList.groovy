/*<set field="selectedMenuItem" value="order" />
<set field="selectedSubMenuItem" value="orderList" />*/

/*context.selectedMenuItem = "order";
context.selectedSubMenuItem = "orderList";*/
import java.util.*;
import org.ofbiz.base.util.UtilMisc;

String partyId = userLogin.getString("partyId");
List<GenericValue> roleTypeList = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyId), null, false);
Set<String> businessMenus = new HashSet<String>();
Set<String> roleTypeIds = new HashSet<String>();
boolean isChiefAccountant = false;
boolean isDistributor = false;
for (roleType in roleTypeList) {
	String roleTypeId = roleType.getString("roleTypeId");
	if ("DELYS_ACCOUNTANTS".equals(roleTypeId)) {
		isChiefAccountant = true;
	} else if ("DELYS_DISTRIBUTOR".equals(roleTypeId)) {
		isDistributor = true;
	}
	roleTypeIds.add(roleTypeId);
	GenericValue roleTypeAttr = delegator.findOne("RoleTypeAttr" ,UtilMisc.toMap("roleTypeId", roleTypeId, "attrName", "BusinessMenu"), false);
	if (roleTypeAttr != null){
		businessMenus.add(roleTypeAttr.getString("attrValue"));
	}
}
context.isChiefAccountant = isChiefAccountant;
context.isDistributor = isDistributor;
if (businessMenus) {
	String menuName = businessMenus.iterator().next();
	if ("DELYS_SALESADMIN_GT".equals(menuName)) {
		context.selectedMenuItem = "order";
		context.selectedSubMenuItem = "orderList";
	} else if ("DELYS_ACCOUNTANTS".equals(menuName)) {
		context.selectedMenuItem = "accApprovement";
		context.selectedSubMenuItem = "accOrderList";
	} else if ("DELYS_DISTRIBUTOR".equals(menuName)) {
		context.selectedMenuItem = "distributorListPO";
		context.selectedSubMenuItem = "";
		/*if ("purcharseOrderListDis".equals(requestNameScreen)) {
			context.selectedMenuItem = "distributorListPO";
			context.selectedSubMenuItem = "";
		} else if ("salesOrderListDis".equals(requestNameScreen)) {
			context.selectedMenuItem = "distributorListSO";
			context.selectedSubMenuItem = "";
		}*/
	} else if ("DELYS_LOGISTICS_GT".equals(menuName)) {
		context.selectedMenuItem = "deliverySub";
		context.selectedSubMenuItem = "orderList";
	}
}
