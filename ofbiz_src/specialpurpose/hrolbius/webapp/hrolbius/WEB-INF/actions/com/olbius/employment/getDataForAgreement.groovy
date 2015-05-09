import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.base.util.*;
import org.ofbiz.product.catalog.*;
import org.ofbiz.product.category.*;

import javolution.util.FastMap;
import javolution.util.FastList;
import javolution.util.FastList.*;

import org.ofbiz.entity.*;

import com.olbius.util.PartyUtil;

import java.util.List;

emplPosition = delegator.findOne("EmplPosition", UtilMisc.toMap("emplPositionId", parameters.emplPositionId), true);
emplPositionTypeId=null;
partyIdWork=null;
defaultOrganizationPartyId=null;
if(UtilValidate.isNotEmpty(emplPosition)){
	emplPositionTypeId = emplPosition.getString("emplPositionTypeId");
	partyIdWork = emplPosition.getString("partyId");
	
	Properties generalProp = UtilProperties.getProperties("general");
	String defaultOrganizationPartyId = (String)generalProp.get("ORGANIZATION_PARTY");
	
	
}
context.emplPositionTypeId = emplPositionTypeId
context.partyIdWork = partyIdWork
context.partyIdFrom = defaultOrganizationPartyId