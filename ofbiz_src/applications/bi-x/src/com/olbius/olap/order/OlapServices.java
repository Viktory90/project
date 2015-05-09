package com.olbius.olap.order;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javolution.util.FastList;
import javolution.util.FastSet;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class OlapServices {
	public static Map<String, Object> getListDepartment( DispatchContext dpcx, Map<String, ?extends Object> context) throws GenericEntityException{
		String chanels= (String)context.get("chanelsales");
		EntityFindOptions findoption=new  EntityFindOptions();
		Delegator delegator= dpcx.getDelegator();
		findoption.setDistinct(true);
		List<String> departmentList=  FastList.newInstance();
		Set<String> field= FastSet.newInstance();
		field.add("partyIdFrom");
		if(UtilValidate.isNotEmpty(chanels)){
			List<GenericValue> dep= EntityUtil.filterByDate(delegator.findList("PartyRelationship", EntityCondition.makeCondition("roleTypeIdFrom",chanels),field , null, findoption, false));
			if(UtilValidate.isNotEmpty(dep)){
				for(GenericValue entry:dep){
					String partyId= entry.getString("partyIdFrom");
					GenericValue group= delegator.findOne("PartyGroup", UtilMisc.toMap("partyId",partyId),false );
					String name= group.getString("groupName");
					departmentList.add(name+": "+partyId);
				}
				
			}
		}
		Map<String, Object> result= ServiceUtil.returnSuccess();
		result.put("departmentList", departmentList);
		return result;
		
	}
}
