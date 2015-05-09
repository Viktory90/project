import javolution.util.FastList;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;

import com.olbius.util.PartyUtil;

List<String> list = FastList.newInstance();
list.add("PROMOTION_GIRL");
list.add("SALESMAN");
parameters.emplPositionTypeId_fld0_op = "in";
parameters.emplPositionTypeId_fld0_value = list;

/**
 * if userLogin.partyId is not HeadOfHR, get salessupList that userLogin.partyId manage
 */
if(!PartyUtil.getHrmAdmin(delegator).equals(userLogin.partyId)){
	parameters.workingPartyId_fld1_op = "in";
	List<String> salessupList = PartyUtil.getSalessupDeptListByMgr(delegator, userLogin.partyId);
	if(UtilValidate.isEmpty(salessupList)){
		salessupList.add("");
	}
	//println ("salessupList: " + salessupList);
	parameters.workingPartyId_fld1_value = salessupList; 
}

