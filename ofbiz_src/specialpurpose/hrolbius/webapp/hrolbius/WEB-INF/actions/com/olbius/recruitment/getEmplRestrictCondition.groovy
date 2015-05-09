import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.util.EntityUtil;

import com.olbius.util.PartyUtil;

partyId = userLogin.partyId;
if(!PartyUtil.isAdmin(partyId, delegator)){
	List<GenericValue> emplList = PartyUtil.getListEmployeeOfManager(delegator, partyId);
	List<String> emplListId = EntityUtil.getFieldListFromEntityList(emplList, "partyId", false);
	parameters.emplPartyId_fld0_op = "in";
	parameters.emplPartyId_fld0_value = emplListId;
}
