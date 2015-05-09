import java.util.*;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.util.EntityUtil;

import com.olbius.delys.util.SalesPartyUtil;
import com.olbius.delys.util.SecurityUtil;

boolean isSalesSup = false;
boolean isAsm = false;
boolean isSalesAdmin = false;
boolean isRsm = false;
boolean isNbd = false;
boolean isCeo = false;
boolean isDistributor = false;

/*	String partyIdUserLogin = userLogin.get("partyId");
	if (partyIdUserLogin != null && SecurityUtil.hasRole("EMPLOYEE", (String) userLogin.get("partyId"), delegator)) {
	List<GenericValue> listPartyRole = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyIdUserLogin), null, false);
	if (listPartyRole != null) {
		List<String> roleTypeIds = EntityUtil.getFieldListFromEntityList(listPartyRole, "roleTypeId", true);
		if (roleTypeIds != null) {
			if (roleTypeIds.contains("DELYS_SALESSUP_GT")) {
				isSalesSup = true;
			}
			if (roleTypeIds.contains("DELYS_ASM_GT")) {
				isAsm = true;
			}
			if (roleTypeIds.contains("DELYS_SALESADMIN_GT")) {
				isSalesAdmin = true;
			}
			if (roleTypeIds.contains("DELYS_RSM_GT")) {
				isRsm = true;
			}
			if (roleTypeIds.contains("DELYS_NBD")) {
				isNbd = true;
			}
			if (roleTypeIds.contains("DELYS_CEO")) {
				isCeo = true;
			}
		}
	}
}
if (partyIdUserLogin != null && SecurityUtil.hasRoleWithCurrentOrg("DELYS_DISTRIBUTOR", (String) userLogin.get("partyId"), delegator)) {
	List<GenericValue> listPartyRole = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyIdUserLogin), null, false);
	if (listPartyRole != null) {
		List<String> roleTypeIds = EntityUtil.getFieldListFromEntityList(listPartyRole, "roleTypeId", true);
		if (roleTypeIds != null) {
			if (roleTypeIds.contains("DELYS_DISTRIBUTOR")) {
				isDistributor = true;
			}
		}
	}
}*/

if (SalesPartyUtil.isSupervisorGTEmployee(userLogin, delegator)) {
	isSalesSup = true;
}
if (SalesPartyUtil.isAsmGTEmployee(userLogin, delegator)) {
	isAsm = true;
}
if (SalesPartyUtil.isSalesAdminGTEmployee(userLogin, delegator)) {
	isSalesAdmin = true;
}
if (SalesPartyUtil.isRsmGTEmployee(userLogin, delegator)) {
	isRsm = true;
}
if (SalesPartyUtil.isNbdEmployee(userLogin, delegator)) {
	isNbd = true;
}
if (SalesPartyUtil.isCeoEmployee(userLogin, delegator)) {
	isCeo = true;
}
if (SalesPartyUtil.isDistributor(userLogin, delegator)) {
	isDistributor = true;
}

context.isSalesSup = isSalesSup;
context.isAsm = isAsm;
context.isSalesAdmin = isSalesAdmin;
context.isRsm = isRsm;
context.isNbd = isNbd;
context.isCeo = isCeo;
context.isDistributor = isDistributor;