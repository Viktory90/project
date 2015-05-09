import java.util.List;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;

List<GenericValue> productList = delegator.findList("Product", null, null, null, null, false);
context.listProducts = productList;
List<GenericValue> listStatus = delegator.findList("StatusItem", EntityCondition.makeCondition(UtilMisc.toMap("statusTypeId", "AGREEMENT_STATUS")), null, null, null, false);
context.listStatus = listStatus;

//System.out.println("AA:" +productList);

//String a = "Fri Feb 20 2015 00:00:00 GMT+0700 (SE Asia Standard Time)";
//
//Date date = new Date(a);
