import javolution.util.FastList;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;

import com.olbius.training.JqxTreeJson;
import com.olbius.util.Organization;
import com.olbius.util.PartyUtil;
import com.olbius.util.PropertiesUtil;

public static List<JqxTreeJson> getPartyGroupTree(Delegator delegator, Organization org){
	List<JqxTreeJson> retList = FastList.newInstance();
	List<Organization> childList = org.getChilListOrg();
	String parentId = org.getOrg().getString("partyId");
	for(Organization tempOrg: childList){
		String tempPartyId = tempOrg.getOrg().getString("partyId");
		if(PropertiesUtil.GROUP_TYPE.equals(tempOrg.getOrgType())){
			GenericValue tempPartyGroup = delegator.findOne("PartyGroup", UtilMisc.toMap("partyId", tempPartyId), false);
			String tempGroupName = tempPartyGroup.getString("groupName");
			if(tempGroupName == null){
				tempGroupName = tempPartyId;
			}
			retList.add(new JqxTreeJson(tempPartyId, tempGroupName, parentId, tempPartyId));
		}
		retList.addAll(getPartyGroupTree(delegator, tempOrg));
		 
	}	
	return retList;
}

org = context.org;
if(org == null){
	String rootCompanyId = UtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY");
	org = PartyUtil.buildOrg(delegator, rootCompanyId);
}

GenericValue parentOrg = org.getOrg();
String partyId = parentOrg.getString("partyId");
GenericValue partyGroup = delegator.findOne("PartyGroup", UtilMisc.toMap("partyId", partyId), false);
String groupName = partyGroup.getString("groupName");
if(groupName == null){
	groupName = partyId;
}
List<JqxTreeJson> treePartyGroup = FastList.newInstance();
treePartyGroup.add(new JqxTreeJson(partyId, groupName, "-1", partyId));
treePartyGroup.addAll(getPartyGroupTree(delegator, org));
List<String> expandedList = FastList.newInstance();
expandedList.add(partyId);
context.treePartyGroup = treePartyGroup;
context.expandedList = expandedList;
 