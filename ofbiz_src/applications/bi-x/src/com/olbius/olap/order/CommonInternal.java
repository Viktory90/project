package com.olbius.olap.order;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javolution.util.FastList;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;


public class CommonInternal {
	public static final String module = CommonInternal.class.getName();
	private static final List<String> listEntities = Arrays.asList("FacilityParty");
	
	public static List<String> getAllDepartmentChildWithRoleAndRoot(List<String> rootList, String roleType, Delegator delegator) throws GenericEntityException{
		List<String> listDistri= FastList.newInstance();
		for(String item:rootList){
			boolean flag=true;
			if(hasRole(roleType, item, delegator)){
				listDistri.add(item);
				
			}else{
				while(flag){
					EntityCondition cond1= EntityCondition.makeCondition("partyIdFrom",item);
					EntityCondition cond2= EntityCondition.makeCondition("partyRelationshipTypeId","GROUP_ROLLUP");
					List<GenericValue> child= EntityUtil.filterByDate(delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityJoinOperator.AND,cond1,cond2), null, null, null, false));
					if(UtilValidate.isNotEmpty(child)){
						List<String> allPartyChild=FastList.newInstance();
						for(GenericValue itemChild:child){
							String partyIdTo= itemChild.getString("partyIdTo");
							String roleTypeIdTo= itemChild.getString("roleTypeIdTo");
							if(roleType.equals(roleTypeIdTo)){
								listDistri.add(partyIdTo);
							}else{
								allPartyChild.add(partyIdTo);
							}
							
						}
						List<String> childWithRole= getAllDepartmentChildWithRoleAndRoot(allPartyChild, roleType, delegator);
						
						if(UtilValidate.isNotEmpty(childWithRole)){
							for(String one:childWithRole){
								if(!listDistri.contains(one)){
									listDistri.add(one);
								}
							}
							
						}
						flag=false;
					}else{
						flag=false;
					}
				
				}
				
			}
		}
		
		return listDistri;
	}
	
	public static RelationshipDepartmentProduct getRelationDepartment(List<String> listRole,String rootId, String roleChild, Delegator delegator) throws GenericEntityException{
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
		
		RelationshipDepartmentProduct obj= new RelationshipDepartmentProduct(delegator);
		obj.setPartyId(rootId);
		obj.setName((String)mapName.get(rootId));
		if(hasRole(roleChild, rootId, delegator)){
			obj.setFlag(true);
			return obj;
			
		}else{
			obj.setFlag(false);
			EntityCondition cond1= EntityCondition.makeCondition("partyIdFrom",rootId);
			EntityCondition cond2= EntityCondition.makeCondition("partyRelationshipTypeId","GROUP_ROLLUP");
			List<GenericValue> child= EntityUtil.filterByDate(delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityJoinOperator.AND,cond1,cond2), null, null, null, false));
			if(UtilValidate.isNotEmpty(child)){
				for(GenericValue item:child){
					String itemId= item.getString("partyIdTo"); 
					if(hasRole(listRole, itemId, delegator)){
						RelationshipDepartmentProduct itemChild= new RelationshipDepartmentProduct(delegator);
						itemChild=getRelationDepartment(listRole,itemId, roleChild, delegator);
						itemChild.setParentId(rootId);
						obj.addChildRd(itemChild);
					}
				}
			}
		}
		return obj;
	}
	
	public static boolean hasRole(String strRole, String strPartyId , Delegator delegator){
		List<String> tmpList =  getCurrentRoles(strPartyId, delegator);
		if(tmpList != null && !tmpList.isEmpty()){
			return tmpList.contains(strRole);
		}else{
			return false;
		}
	}
	
	public static boolean hasRole(List<String> strRole, String strPartyId , Delegator delegator){
		List<String> tmpList =  getCurrentRoles(strPartyId, delegator);
		if(tmpList != null && !tmpList.isEmpty()){
			for(String item:strRole){
				if(tmpList.contains(item)){
					return true;
				}
			}
			return false;
		}else{
			return false;
		}
	}
	
	public static List<String> getCurrentRoles(String strPartyId, Delegator delegator){
		List<String> listDatas = new ArrayList<String>();
		// check for Entity-roles map
		for (String entity : listEntities) {
			try {
				List<GenericValue> listTmp = delegator.findByAnd(entity, UtilMisc.toMap("partyId", strPartyId), null, false);
				listTmp = EntityUtil.filterByDate(listTmp);
				if(!listTmp.isEmpty()){
					for (GenericValue genericValue : listTmp) {
						listDatas.add(genericValue.getString("roleTypeId"));
					}
				}
			} catch (Exception e) {
				Debug.logError(e, module);
			}
		}
		// check for party relationship
		try {
			List<GenericValue> listTmp = delegator.findList("PartyRelationship", EntityCondition.makeCondition("partyIdFrom", EntityOperator.EQUALS, strPartyId), UtilMisc.toSet("roleTypeIdFrom"), null, null, false);
			listTmp = EntityUtil.filterByDate(listTmp);
			if(!listTmp.isEmpty()){
				for (GenericValue genericValue : listTmp) {
					listDatas.add(genericValue.getString("roleTypeIdFrom"));
				}
			}
			listTmp = delegator.findList("PartyRelationship", EntityCondition.makeCondition("partyIdTo", EntityOperator.EQUALS, strPartyId), UtilMisc.toSet("roleTypeIdTo"), null, null, false);
			listTmp = EntityUtil.filterByDate(listTmp);
			if(!listTmp.isEmpty()){
				for (GenericValue genericValue : listTmp) {
					listDatas.add(genericValue.getString("roleTypeIdTo"));
				}
			}
			listDatas = (List<String>) removeDuplicateElementInList(listDatas);
		} catch (Exception e) {
			Debug.logError(e, module);
		}
		return listDatas;
	}
	
	
	public static String getOrgByManager(GenericValue userLogin, Delegator delegator) throws Exception{
		//FIXME Don't have condition about status
		EntityCondition filterDateCon = EntityUtil.getFilterByDateExpr();
		Map<String, String> mapCondition = UtilMisc.toMap("partyIdFrom", userLogin.getString("partyId"), "partyRelationshipTypeId", "MANAGER");
		EntityCondition conditionList = EntityCondition.makeCondition(EntityJoinOperator.AND, filterDateCon, EntityCondition.makeCondition(mapCondition));
		List<GenericValue> relationshipList = (List<GenericValue>)delegator.findList("PartyRelationship", conditionList, null, null, null, false);
		if(UtilValidate.isEmpty(relationshipList)){
			return null;
		}
		GenericValue partyRelationship = EntityUtil.getFirst(relationshipList);
		return partyRelationship.getString("partyIdTo");
	}
	
	public static List<?> removeDuplicateElementInList(List<?> listDatas){
		if(!listDatas.isEmpty()){
			HashSet hs = new HashSet();
			hs.addAll(listDatas);
			listDatas.clear();
			listDatas.addAll(hs);
		}
		return listDatas;
	}
}
