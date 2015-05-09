
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;

import javolution.util.FastMap;
import javolution.util.FastList;
import javolution.util.FastList.*;

import com.olbius.olap.order.CommonInternal;


String partyIdFrom=userLogin.getString("partyId");
String departmentManager="";
if(CommonInternal.hasRole("SALES_ADMIN", partyIdFrom, delegator)){
	departmentManager="NBD"
}else{
	departmentManager=CommonInternal.getOrgByManager(userLogin, delegator);
}
List<String> departmentMg= FastList.newInstance();
List<String> listDepartment1= FastList.newInstance();
List<String> listDepartment2= FastList.newInstance();
List<String> listDepartment= FastList.newInstance();
departmentMg.add(departmentManager);
listDepartment= CommonInternal.getAllDepartmentChildWithRoleAndRoot(departmentMg, "DELYS_SALESSUP_GT", delegator);
listDepartment2= CommonInternal.getAllDepartmentChildWithRoleAndRoot(departmentMg, "DELYS_SALESSUP_MT", delegator);
listDepartment.addAll(listDepartment2);

List<GenericValue> groupList= delegator.findList("PartyGroup", null, null, null, null, false);
Map<String,Object> mapName= new HashMap<String, Object>();
if(UtilValidate.isNotEmpty(groupList)){
	for(GenericValue per:groupList){
		String partyId= per.getString("partyId");
		String name="";
		name=per.getString("groupName");
		if(UtilValidate.isEmpty(name)){
			name=partyId;
		}
		mapName.put(partyId, name);
	}
}
//println("avc"+listDepartment2);

context.listDepartment=listDepartment;
context.mapName=mapName;