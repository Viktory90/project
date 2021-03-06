import java.util.*;
import java.lang.*;
import org.ofbiz.base.util.UtilMisc;

if (security.hasPermission("DELYS_ORDER_APPROVE", session)){
	hasApproved = true;
	context.hasApproved = hasApproved;
} else {
	hasApproved = false;
	context.hasApproved = hasApproved;
}

if (security.hasPermission("DELYS_ORDER_CANCEL", session)){
	hasCancel = true;
	context.hasCancel = hasCancel;
} else {
	hasCancel = false;
	context.hasCancel = hasCancel;
}

if (security.hasPermission("DELYS_ORDER_COMPLETE", session)){
	hasCompleted = true;
	context.hasCompleted = hasCompleted;
} else {
	hasCompleted = false;
	context.hasCompleted = hasCompleted;
}


if (security.hasPermission("DELYS_ORDER_CREATE", session)){
	hasCreated = true;
	context.hasCreated = hasCreated;
} else {
	hasCreated = false;
	context.hasCreated = hasCreated;
}

if (security.hasPermission("DELYS_ORDER_REJECT", session)){
	hasRejected = true;
	context.hasRejected = hasRejected;
} else {
	hasRejected = false;
	context.hasRejected = hasRejected;
}

if (security.hasPermission("DELYS_ORDER_PROCESS", session)){
	hasProcess = true;
	context.hasProcess = hasProcess;
} else {
	hasProcess = false;
	context.hasProcess = hasProcess;
}

if (security.hasPermission("DELYS_ORDER_VIEW", session)){
	hasView = true;
	context.hasView = hasView;
} else {
	hasView = false;
	context.hasView = hasView;
}

if (security.hasPermission("DELYS_ORDER_HOLD", session)){
	hasHoled = true;
	context.hasHoled = hasHoled;
} else {
	hasHoled = false;
	context.hasHoled = hasHoled;
}

if (security.hasPermission("DELYS_ORDER_PRINT", session)){
	hasPrinted = true;
	context.hasPrinted = hasPrinted;
} else {
	hasPrinted = false;
	context.hasPrinted = hasPrinted;
}
if (security.hasPermission("DELYS_ORDER_RECEIVE", session)){
	hasReceived = true;
	context.hasReceived = hasReceived;
} else {
	hasReceived = false;
	context.hasReceived = hasReceived;
}


userLogin1 = parameters.userLogin;
context.userLogin1 = userLogin1;

userLoginId1 = userLogin1.userLoginId;
listUserLoginSecurityGroup = delegator.findByAnd("UserLoginSecurityGroup" ,UtilMisc.toMap("userLoginId", userLoginId1), null, false);
hasSupApproved = "FALSE";
hasSadApproved = "FALSE";
hasDistributorApproved = "FALSE";
hasChiefAccountantApproved = "FALSE";
for (item in listUserLoginSecurityGroup) {
	if (item.get("groupId") == "DELYS_SALESSUP_GT") {
		hasSupApproved = "TRUE";
		break;
	} else {
		hasSupApproved = "FALSE";
	}
	if (item.get("groupId") == "DELYS_SALESADMIN_GT") {
		hasSadApproved = "TRUE";
		break;
	} else {
		hasSadApproved = "FALSE";
	}
	if (item.get("groupId") == "DELYS_DISTRIBUTOR") {
		hasDistributorApproved = "TRUE";
		break;
	} else {
		hasDistributorApproved = "FALSE";
	}
	if (item.get("groupId") == "DELYS_ACCOUNTANTS") {
		hasChiefAccountantApproved = "TRUE";
		break;
	} else {
		hasChiefAccountantApproved = "FALSE";
	}
}

context.hasSupApproved = hasSupApproved;
context.hasSadApproved = hasSadApproved;
context.hasDistributorApproved = hasDistributorApproved;
context.hasChiefAccountantApproved = hasChiefAccountantApproved;





