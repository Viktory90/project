package com.olbius.delys.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;

public class SecurityUtil {
	public static final String module = SecurityUtil.class.getName();
	private static final List<String> listEntities = Arrays.asList("FacilityParty");
	// Check to has specific role
	public static boolean hasRole(String strRole, String strPartyId , Delegator delegator){
		List<String> tmpList =  getCurrentRoles(strPartyId, delegator);
		if(tmpList != null && !tmpList.isEmpty()){
			return tmpList.contains(strRole);
		}else{
			return false;
		}
	}
	// Check to has specific role on specific entity
	public static boolean hasRole(String strRole, String strPartyId , Delegator delegator, String strEntityName){
		List<String> tmpList =  getCurrentRoles(strPartyId, strEntityName, delegator);
		if(tmpList != null && !tmpList.isEmpty()){
			return tmpList.contains(strRole);
		}else{
			return false;
		}
	}
	// Check to has specific role
	public static boolean hasRoleWithCurrentOrg(String strRole, String strPartyId , Delegator delegator){
		List<String> tmpList =  getCurrentRolesWithCurrentOrg(strPartyId, delegator);
		if(tmpList != null && !tmpList.isEmpty()){
			return tmpList.contains(strRole);
		}else{
			return false;
		}
	}
	// TODO test the below method
	public static List<String> getCurrentRoles(String strPartyId, String strEntityName, Delegator delegator){
		List<String> listDatas = new ArrayList<String>();
		// check for Entity-roles map
		try {
			List<GenericValue> listTmp = delegator.findByAnd(strEntityName, UtilMisc.toMap("partyId", strPartyId), null, false);
			listTmp = EntityUtil.filterByDate(listTmp);
			if(!listTmp.isEmpty()){
				for (GenericValue genericValue : listTmp) {
					listDatas.add(genericValue.getString("roleTypeId"));
				}
				listDatas = (List<String>) SetUtil.removeDuplicateElementInList(listDatas);
			}
		} catch (Exception e) {
			Debug.logError(e, module);
		}
		return listDatas;
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
			listDatas = (List<String>) SetUtil.removeDuplicateElementInList(listDatas);
		} catch (Exception e) {
			Debug.logError(e, module);
		}
		return listDatas;
	}
	public static List<String> getCurrentRolesWithCurrentOrg(String strPartyId, Delegator delegator){
		List<String> listDatas = new ArrayList<String>();
		// check for party relationship
		String strCurrentOrganization = MultiOrganizationUtil.getCurrentOrganization(delegator);
		List<EntityCondition> listEC = new ArrayList<EntityCondition>();
		EntityCondition tmpEC = EntityCondition.makeCondition("partyIdFrom", EntityOperator.EQUALS, strCurrentOrganization);
		listEC.add(tmpEC);
		tmpEC = EntityCondition.makeCondition("partyIdTo", EntityOperator.EQUALS, strPartyId);
		listEC.add(tmpEC);
		try {
			List<GenericValue> listTmp = delegator.findList("PartyRelationship", EntityCondition.makeCondition(listEC, EntityOperator.AND), UtilMisc.toSet("roleTypeIdTo"), null, null, false);
			listTmp = EntityUtil.filterByDate(listTmp);
			if(!listTmp.isEmpty()){
				for (GenericValue genericValue : listTmp) {
					listDatas.add(genericValue.getString("roleTypeIdTo"));
				}
			}
			listEC.clear();
			tmpEC = EntityCondition.makeCondition("partyIdFrom", EntityOperator.EQUALS, strPartyId);
			listEC.add(tmpEC);
			tmpEC = EntityCondition.makeCondition("partyIdTo", EntityOperator.EQUALS, strCurrentOrganization);
			listEC.add(tmpEC);
			listTmp = delegator.findList("PartyRelationship", EntityCondition.makeCondition(listEC, EntityOperator.AND), UtilMisc.toSet("roleTypeIdFrom"), null, null, false);
			listTmp = EntityUtil.filterByDate(listTmp);
			if(!listTmp.isEmpty()){
				for (GenericValue genericValue : listTmp) {
					listDatas.add(genericValue.getString("roleTypeIdFrom"));
				}
			}
			listDatas = (List<String>) SetUtil.removeDuplicateElementInList(listDatas);
		} catch (Exception e) {
			Debug.logError(e, module);
		}
		return listDatas;
	}
}
