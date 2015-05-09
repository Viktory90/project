import org.ofbiz.service.*;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.*;
import org.ofbiz.entity.condition.*;
import org.ofbiz.entity.util.*;

organizations = delegator.findByAnd("PartyAcctgPrefAndGroupAndRole", UtilMisc.toMap("roleTypeId", "INTERNAL_ORGANIZATIO"), null, false);
context.organizations = organizations;
