import javolution.util.FastList;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;

import com.olbius.util.PartyUtil;

partyId = userLogin.partyId;
List<EntityCondition> conditions = FastList.newInstance();
conditions.add(EntityCondition.makeCondition("partyIdFrom", partyId));
conditions.add(EntityCondition.makeCondition("roleTypeIdFrom", "MANAGER"));
conditions.add(EntityCondition.makeCondition("partyRelationshipTypeId", "MANAGER"));
conditions.add(EntityCondition.makeCondition("roleTypeIdTo", "INTERNAL_ORGANIZATIO"));
conditions.add(EntityUtil.getFilterByDateExpr());
List<GenericValue> partyRels = delegator.findList("PartyRelationship", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
List<String> statusIdCondList = FastList.newInstance();

for(GenericValue partyRel: partyRels){
	String partyIdTo = partyRel.getString("partyIdTo");
	List<GenericValue> partyRoles = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyIdTo), null, false);
	List<String> roleTypes = EntityUtil.getFieldListFromEntityList(partyRoles, "roleTypeId", true);	
	
	/*if(roleTypes.contains("DELYS_CSM_GT")){
		statusIdCondList.add("CSM_APPROVAL_WAIT");		
	}
	if(roleTypes.contains("DELYS_RSM_GT")){
		statusIdCondList.add("RSM_APPROVAL_WAIT");
	}*/
	if(roleTypes.contains("DELYS_ASM_GT")){
		statusIdCondList.add("ASM_APPROVAL_WAIT");		
	}	
}
if(UtilValidate.isEmpty(statusIdCondList)){
	statusIdCondList.add("");
}
context.statusIdCondList = statusIdCondList;
