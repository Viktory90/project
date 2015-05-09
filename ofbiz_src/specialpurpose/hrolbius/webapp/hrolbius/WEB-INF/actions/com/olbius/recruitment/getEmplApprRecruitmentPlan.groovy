import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;

import com.olbius.util.PartyUtil;

partyId = userLogin.partyId;
if(internalOrgId){
	GenericValue partyRole = delegator.findOne("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "DELYS_SALESSUP_GT"), false);
	if(UtilValidate.isNotEmpty(partyRole)){
		String parentOrgId = PartyUtil.getOrgNextLevelOfEmpl(delegator, partyId);
		context.partyNtfId = PartyUtil.getManagerbyOrg(parentOrgId, delegator); 
	}else{
		context.partyNtfId = PartyUtil.getHrmAdmin(delegator); 
	}
}
