import org.ofbiz.base.util.UtilValidate;

import com.olbius.util.PartyUtil;


partyId = userLogin.partyId;
List<String> salessupList = PartyUtil.getSalessupDeptListByMgr(delegator, partyId);
if(UtilValidate.isEmpty(salessupList)){
	salessupList.add("");
}
context.salessupList = salessupList;