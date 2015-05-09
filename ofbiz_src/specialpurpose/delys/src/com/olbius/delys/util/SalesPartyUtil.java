package com.olbius.delys.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javolution.util.FastList;
import javolution.util.FastSet;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

public class SalesPartyUtil {
	public static final String RESOURCE = "general";
	public static String module = SalesPartyUtil.class.getName();
	
	public static boolean isDistributor (GenericValue userLogin, Delegator delegator) {
		boolean isDistributor = false;
		if (UtilValidate.isEmpty(userLogin)) return isDistributor; 
		String partyIdUserLogin = userLogin.getString("partyId");
		if (partyIdUserLogin != null && SecurityUtil.hasRoleWithCurrentOrg("DELYS_DISTRIBUTOR", partyIdUserLogin, delegator)) {
			List<GenericValue> listPartyRole = null;
			try {
				listPartyRole = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyIdUserLogin), null, false);
			} catch (GenericEntityException e) {
				String errMsg = "Fatal error when check distributor role: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
			if (UtilValidate.isNotEmpty(listPartyRole)) {
				List<String> roleTypeIds = EntityUtil.getFieldListFromEntityList(listPartyRole, "roleTypeId", true);
				if (roleTypeIds != null) {
					if (roleTypeIds.contains("DELYS_DISTRIBUTOR")) {
						// userLogin is distributor
						isDistributor = true;
					}
				}
			}
		}
		return isDistributor;
	}
	
	public static boolean isLogStoreKeeper(GenericValue userLogin, Delegator delegator) throws Exception{
		if (UtilValidate.isEmpty(userLogin.get("partyId"))) {
			return false;
		}
		GenericValue logistic = delegator.findOne("PartyRole", UtilMisc.toMap("roleTypeId", "LOG_STOREKEEPER", "partyId", userLogin.get("partyId")), false);
		if(UtilValidate.isNotEmpty(logistic)){
			return true;
		}
		return false;
	}
	
	public static boolean isCeoEmployee (GenericValue userLogin, Delegator delegator) {
		boolean isDistributor = false;
		if (UtilValidate.isEmpty(userLogin)) return isDistributor; 
		String partyIdUserLogin = userLogin.getString("partyId");
		if (partyIdUserLogin != null && SecurityUtil.hasRoleWithCurrentOrg("DELYS_CEO", partyIdUserLogin, delegator)) {
			List<GenericValue> listPartyRole = null;
			try {
				listPartyRole = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyIdUserLogin), null, false);
			} catch (GenericEntityException e) {
				String errMsg = "Fatal error when check distributor role: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
			if (UtilValidate.isNotEmpty(listPartyRole)) {
				List<String> roleTypeIds = EntityUtil.getFieldListFromEntityList(listPartyRole, "roleTypeId", true);
				if (roleTypeIds != null) {
					if (roleTypeIds.contains("DELYS_CEO")) {
						// userLogin is distributor
						isDistributor = true;
					}
				}
			}
		}
		return isDistributor;
	}
	
	/*
	public static boolean isSupervisorEmployee (GenericValue userLogin, Delegator delegator) {
		boolean isSup = false;
		if (UtilValidate.isEmpty(userLogin)) return isSup;
		String partyIdUserLogin = userLogin.getString("partyId");
		if (partyIdUserLogin != null && SecurityUtil.hasRole("EMPLOYEE", partyIdUserLogin, delegator)) {
			List<GenericValue> listPartyRole = null;
			try {
				listPartyRole = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", partyIdUserLogin), null, false);
			} catch (GenericEntityException e) {
				String errMsg = "Fatal error when check supervisor role: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
			if (UtilValidate.isNotEmpty(listPartyRole)) {
				List<String> rolesAccept = getListDescendantRoleInclude("DELYS_SALESSUP", delegator);
				List<String> roleTypeIds = EntityUtil.getFieldListFromEntityList(listPartyRole, "roleTypeId", true);
				if (hasContain(roleTypeIds, rolesAccept)) {
					isSup = true;
				}
			}
		}
		return isSup;
	}
	 */
	public static boolean isEmployeeCore (String roleTypeId, GenericValue userLogin, Delegator delegator) {
		boolean isSup = false;
		if (UtilValidate.isEmpty(userLogin)) return isSup;
		String partyIdUserLogin = userLogin.getString("partyId");
		if (partyIdUserLogin != null && SecurityUtil.hasRole("EMPLOYEE", partyIdUserLogin, delegator)) {
			List<String> departments = getListDepartment(partyIdUserLogin, delegator);
			if (UtilValidate.isNotEmpty(departments)) {
				List<String> rolesAccept = getListDescendantRoleInclude(roleTypeId, delegator);
				if (UtilValidate.isNotEmpty(rolesAccept)) {
					for (String department : departments) {
						for (String roleAccept : rolesAccept) {
							if (SecurityUtil.hasRole(roleAccept, department, delegator)) {
								isSup = true;
								break;
							}
						}
						if (isSup) break;
					}
				}
			}
		}
		return isSup;
	}
	
	public static boolean isSupervisorEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_SALESSUP", userLogin, delegator);
	}
	
	public static boolean isSupervisorGTEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_SALESSUP_GT", userLogin, delegator);
	}
	
	public static boolean isSupervisorMTEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_SALESSUP_MT", userLogin, delegator);
	}
	
	public static boolean isAsmGTEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_ASM_GT", userLogin, delegator);
	}
	
	public static boolean isSalesAdminGTEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_SALESADMIN_GT", userLogin, delegator);
	}
	
	public static boolean isSalesAdminManagerEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("SALESADMIN_MANAGER", userLogin, delegator);
	}
	
	public static boolean isRsmGTEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_RSM_GT", userLogin, delegator);
	}
	
	public static boolean isNbdEmployee (GenericValue userLogin, Delegator delegator) {
		return isEmployeeCore("DELYS_NBD", userLogin, delegator);
	}
	
	public static List<String> getListDepartment (String employeeId, Delegator delegator) {
		List<String> partyDepartment = null;
		try {
			List<GenericValue> listDepartment = delegator.findByAnd("PartyRelationship", 
					UtilMisc.toMap("partyIdTo", employeeId, "partyRelationshipTypeId", "EMPLOYMENT", "roleTypeIdFrom", "INTERNAL_ORGANIZATIO", "roleTypeIdTo", "EMPLOYEE"), null, false);
			partyDepartment = EntityUtil.getFieldListFromEntityList(listDepartment, "partyIdFrom", true);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error when getListDescendantRoleInclude: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		return partyDepartment;
	}
	
	public static boolean hasContain (List<String> listChild, List<String> listParent) {
		boolean isContain = false;
		for (String child : listChild) {
			if (listParent.contains(child)) {
				isContain = true;
				break;
			}
		}
		return isContain;
	}
	
	public static List<String> getListDescendantRoleInclude (String roleTypeId, Delegator delegator) {
		List<String> listDescendantRole = new ArrayList<String>();
		try {
			GenericValue roleType = delegator.findOne("RoleType", UtilMisc.toMap("roleTypeId", roleTypeId), false);
			listDescendantRole.add(roleType.getString("roleTypeId"));
			List<GenericValue> listChild = delegator.findByAnd("RoleType", UtilMisc.toMap("parentTypeId", roleType.get("roleTypeId")), null, false);
			if (UtilValidate.isNotEmpty(listChild)) {
				for (GenericValue child : listChild) {
					List<String> resultList = getListDescendantRoleInclude(child.getString("roleTypeId"), delegator);
					if (UtilValidate.isNotEmpty(resultList)) listDescendantRole.addAll(resultList);
				}
			}
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error when getListDescendantRoleInclude: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		return listDescendantRole;
	}
	
	public static List<String> getListChildRoleOutclude (String roleTypeId, Delegator delegator) {
		List<String> listChildRole = new ArrayList<String>();
		try {
			List<GenericValue> listChild = delegator.findByAnd("RoleType", UtilMisc.toMap("parentTypeId", roleTypeId), null, false);
			if (UtilValidate.isNotEmpty(listChild)) {
				listChildRole = EntityUtil.getFieldListFromEntityList(listChild, "roleTypeId", true);
			}
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error when getListChildRoleOutclude: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		return listChildRole;
	}
	
	public static List<String> getListParentRoleInclude (String roleTypeId, Delegator delegator) {
		List<String> listParentRole = new ArrayList<String>();
		try {
			boolean isRun = true;
			while (isRun) {
				GenericValue roleType = delegator.findOne("RoleType", UtilMisc.toMap("roleTypeId", roleTypeId), false);
				listParentRole.add(roleType.getString("roleTypeId"));
				if (UtilValidate.isEmpty(roleType.getString("parentTypeId"))) {
					isRun = false;
				}
				roleTypeId = roleType.getString("parentTypeId");
			}
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error when getListParentRoleInclude: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		return listParentRole;
	}
	
	/**
	 * Get list the distributors are active (Search in "PartyRoleNameDetailPartyRelTo" entity) 
	 * @param supervisorId
	 * @param listSortFields
	 * @param delegator
	 * @return
	 * @throws GenericEntityException
	 */
	public static EntityListIterator getListDistributorActiveBySupervisor (String supervisorId, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
    	EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	Map<String, String> mapCondition1 = new HashMap<String, String>();
    	mapCondition1.put("partyIdFrom", supervisorId);
    	mapCondition1.put("partyRelationshipTypeId", "MANAGER");
    	mapCondition1.put("roleTypeId", "INTERNAL_ORGANIZATIO");
    	mapCondition1.put("roleTypeIdTo", "INTERNAL_ORGANIZATIO");
    	EntityCondition tmpConditon1 = EntityCondition.makeCondition(mapCondition1);
    	List<EntityCondition> listConds1 = FastList.newInstance();
    	listConds1.add(condStatusPartyDisable);
    	listConds1.add(tmpConditon1);
    	
    	GenericValue listSupPosition = EntityUtil.getFirst(EntityUtil.filterByDate(delegator.findList("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds1, EntityOperator.AND), null, null, opts, false)));
    	if (listSupPosition != null) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
        	mapCondition2.put("partyIdFrom", listSupPosition.getString("partyId"));
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeId", "DELYS_DISTRIBUTOR");
        	mapCondition2.put("roleTypeIdTo", "DELYS_DISTRIBUTOR");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	
    	// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
    	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
    	
    	return listIterator;
    }
	
	/**
	 * Get list the distributors are active (Search in "PartyRoleNameDetailPartyRelTo" entity) 
	 * @param supervisorIds
	 * @param listSortFields
	 * @param listAllConditions
	 * @param opts
	 * @param delegator
	 * @return
	 * @throws GenericEntityException
	 */
	public static EntityListIterator getListDistributorActiveBySupervisor (List<String> supervisorIds, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
    	EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	Map<String, String> mapCondition1 = new HashMap<String, String>();
    	//mapCondition1.put("partyIdFrom", supervisorId);
    	mapCondition1.put("partyRelationshipTypeId", "MANAGER");
    	mapCondition1.put("roleTypeId", "INTERNAL_ORGANIZATIO");
    	mapCondition1.put("roleTypeIdTo", "INTERNAL_ORGANIZATIO");
    	EntityCondition tmpConditon1 = EntityCondition.makeCondition(mapCondition1);
    	List<EntityCondition> listConds1 = FastList.newInstance();
    	listConds1.add(condStatusPartyDisable);
    	listConds1.add(tmpConditon1);
    	listConds1.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, supervisorIds));
    	
    	List<GenericValue> listSupPosition = EntityUtil.filterByDate(delegator.findList("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds1, EntityOperator.AND), null, null, opts, false));
    	if (listSupPosition != null) {
    		List<String> listParty2 = EntityUtil.getFieldListFromEntityList(listSupPosition, "partyId", true);
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
        	//mapCondition2.put("partyIdFrom", listSupPosition.getString("partyId"));
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeId", "DELYS_DISTRIBUTOR");
        	mapCondition2.put("roleTypeIdTo", "DELYS_DISTRIBUTOR");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, listParty2));
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	
    	// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
    	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
    	
    	return listIterator;
    }
	
	/**
	 * Get list the distributors are active (Search in "PartyRoleNameDetailPartyRelTo" entity) 
	 * @param supervisorDepartmentIds
	 * @param listSortFields
	 * @param listAllConditions
	 * @param opts
	 * @param delegator
	 * @return
	 * @throws GenericEntityException
	 */
	public static EntityListIterator getListDistributorActiveBySupervisorDepartment (List<String> supervisorDepartmentIds, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
    	EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	if (UtilValidate.isNotEmpty(supervisorDepartmentIds)) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeId", "DELYS_DISTRIBUTOR");
        	mapCondition2.put("roleTypeIdTo", "DELYS_DISTRIBUTOR");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, supervisorDepartmentIds));
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
    	return listIterator;
    }
	
	public static EntityListIterator getListDistributorActiveByOrganization (String organization, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
    	EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	if (UtilValidate.isNotEmpty(organization)) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
    		mapCondition2.put("partyIdFrom", organization);
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeId", "DELYS_DISTRIBUTOR");
        	mapCondition2.put("roleTypeIdTo", "DELYS_DISTRIBUTOR");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	// <PartyRelationship partyIdFrom="company" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="INTERNAL_ORGANIZATIO" roleTypeIdTo="DELYS_DISTRIBUTOR" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
    	return listIterator;
    }
	
	public static EntityListIterator getListSupDepartmentActiveByOrganization (String organization, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
    	EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	if (UtilValidate.isNotEmpty(organization)) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
    		mapCondition2.put("partyIdFrom", organization);
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeIdTo", "DELYS_SALESSUP_GT");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	// <PartyRelationship partyIdFrom="company" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="INTERNAL_ORGANIZATIO" roleTypeIdTo="DELYS_DISTRIBUTOR" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
    	return listIterator;
    }
	
	public static EntityListIterator getListSalesmanActiveBySupervisorDepartment (List<String> supervisorDepartmentIds, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
    	EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	if (UtilValidate.isNotEmpty(supervisorDepartmentIds)) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
    		mapCondition2.put("roleTypeId", "EMPLOYEE");
        	mapCondition2.put("partyRelationshipTypeId", "EMPLOYMENT");
        	mapCondition2.put("roleTypeIdTo", "EMPLOYEE");
        	mapCondition2.put("partyRelationshipTypeIdReverse", "SALES_EMPLOYEE");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, supervisorDepartmentIds));
        	listConds2.add(EntityCondition.makeCondition("roleTypeIdReverse", EntityOperator.IN, getListDescendantRoleInclude("DELYS_SALESMAN", delegator)));
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="salesman1" roleTypeIdFrom="INTERNAL_ORGANIZATIO" roleTypeIdTo="EMPLOYEE" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="EMPLOYMENT"/>
    	return listIterator;
    }
	public static EntityListIterator getListSalesmanActiveBySupervisor (String supervisorId, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
		EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	if (UtilValidate.isNotEmpty(supervisorId)) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
    		mapCondition2.put("partyIdFrom", supervisorId);
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeIdTo", "EMPLOYEE");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.IN, getListDescendantRoleInclude("DELYS_SALESMAN", delegator)));
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="salesman1" roleTypeIdFrom="INTERNAL_ORGANIZATIO" roleTypeIdTo="EMPLOYEE" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="EMPLOYMENT"/>
    	return listIterator;
    }
	public static EntityListIterator getListSupDepartmentActiveByAsmDepartment(List<String> asmDepartmentIds, List<String> listSortFields, List<EntityCondition> listAllConditions, EntityFindOptions opts, Delegator delegator) throws GenericEntityException {
		EntityListIterator listIterator = null;
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	
    	if (UtilValidate.isNotEmpty(asmDepartmentIds)) {
    		Map<String, String> mapCondition2 = new HashMap<String, String>();
        	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
        	mapCondition2.put("roleTypeIdTo", "DELYS_SALESSUP_GT");
        	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
        	List<EntityCondition> listConds2 = FastList.newInstance();
        	listConds2.add(condStatusPartyDisable);
        	listConds2.add(tmpConditon2);
        	listConds2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, asmDepartmentIds));
        	listConds2.add(EntityUtil.getFilterByDateExpr());
        	if (UtilValidate.isNotEmpty(listAllConditions)) listConds2.addAll(listAllConditions);
        	
        	listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, listSortFields, opts);
    	}
    	// <PartyRelationship partyIdFrom="company" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="INTERNAL_ORGANIZATIO" roleTypeIdTo="DELYS_DISTRIBUTOR" 
    	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
    	return listIterator;
    }
	
	
// =========================================================================================================================================
	
	public static String getCEO(Delegator delegator) throws Exception{
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "DELYS_CEO");
		List<GenericValue> ceoList = delegator.findList("PartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false);
		if(ceoList == null || ceoList.isEmpty()){
			return null;
		}
		return EntityUtil.getFirst(ceoList).getString("partyId");
	}
	public static String getPersonCEO(Delegator delegator) throws Exception{
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "DELYS_CEO");
		List<GenericValue> ceoList = delegator.findList("PartyPersonPartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false);
		if(ceoList == null || ceoList.isEmpty()){
			return null;
		}
		return EntityUtil.getFirst(ceoList).getString("partyId");
	}
	public static String getNBD(Delegator delegator) throws Exception{
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "DELYS_NBD");
		List<GenericValue> nbdList = delegator.findList("PartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false);
		if(nbdList == null || nbdList.isEmpty()){
			return null;
		}
		return EntityUtil.getFirst(nbdList).getString("partyId");
	}
	public static List<String> getNBDs(Delegator delegator) throws Exception{
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "DELYS_NBD");
		List<GenericValue> nbdList = delegator.findList("PartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false);
		if(nbdList == null || nbdList.isEmpty()){
			return null;
		}
		return EntityUtil.getFieldListFromEntityList(nbdList, "partyId", true);
	}
	public static List<String> getPersonNBDs(Delegator delegator) throws Exception{
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "DELYS_NBD");
		List<GenericValue> nbdList = delegator.findList("PartyPersonPartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false);
		if(nbdList == null || nbdList.isEmpty()){
			return null;
		}
		return EntityUtil.getFieldListFromEntityList(nbdList, "partyId", true);
	}
	public static List<String> getLogsSpecialist(Delegator delegator) throws Exception{
		List<String> listLogisticId = new ArrayList<String>();
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "LOG_SPECIALIST");
		List<String> listLogistic = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false), "partyId", true);
		if(UtilValidate.isNotEmpty(listLogistic)){
			listLogisticId.addAll(listLogistic);
		}
		return listLogisticId;
	}
	public static List<String> getAccoutants(Delegator delegator) throws Exception{
		EntityCondition condition1 = EntityCondition.makeCondition("roleTypeId", "DELYS_ACCOUNTANTS");
		List<GenericValue> accList = delegator.findList("PartyRole", condition1, UtilMisc.toSet("partyId"), null, null, false);
		if(accList == null || accList.isEmpty()){
			return null;
		}
		return EntityUtil.getFieldListFromEntityList(accList, "partyId", true);
	}
	public static List<String> getSUPsByDistributor(Delegator delegator, String partyId) throws Exception{
		List<GenericValue> listRelationToSUP = EntityUtil.filterByDate(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdTo", partyId, "roleTypeIdFrom", "DELYS_SALESSUP_GT"), null, false));
		if(listRelationToSUP == null || listRelationToSUP.isEmpty()){
			return null;
		}
		return EntityUtil.getFieldListFromEntityList(listRelationToSUP, "partyIdFrom", true);
	}
	public static String getSalesAdminManager(Delegator delegator){
		EntityCondition condition = EntityCondition.makeCondition("roleTypeId", "SALESADMIN_MANAGER");
		List<GenericValue> salesadminManagerList = null;
		try {
			salesadminManagerList = delegator.findList("PartyRole", condition, UtilMisc.toSet("partyId"), null, null, false);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return EntityUtil.getFirst(salesadminManagerList).getString("partyId");
	}
	
	/**
	 * get list party by roleTypeId
	 * @param roleTypeId Role of party
	 * @param hasChild has get role type children of roleTypeId
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<String> getPartiesByRole(Delegator delegator, LocalDispatcher dispatcher, GenericValue userLogin, String roleTypeId, boolean hasChild) {
		List<String> parties = new ArrayList<String>();
		List<String> listChildRoles = new ArrayList<String>();
		try {
			if (hasChild) {
				// get role type children of roleTypeId
				Map<String, Object> resultService = dispatcher.runSync("getChildRoleTypes", UtilMisc.toMap("roleTypeId", roleTypeId, "userLogin", userLogin));
				if (ServiceUtil.isSuccess(resultService)) {
					listChildRoles = (List<String>) resultService.get("childRoleTypeIdList");
				}
			} else {
				listChildRoles.add(roleTypeId);
			}
			for (String roleItem : listChildRoles) {
				EntityCondition condition = EntityCondition.makeCondition("roleTypeId", roleItem);
				List<GenericValue> listParty = delegator.findList("PartyRole", condition, UtilMisc.toSet("partyId"), null, null, false);
				if (listParty != null) {
					List<String> listPartyId = EntityUtil.getFieldListFromEntityList(listParty, "partyId", true);
					for (String partyId : listPartyId) {
						if (!parties.contains(partyId)) {
							parties.add(partyId);
						}
					}
				}
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return parties;
	}
	
	public static List<GenericValue> getAllSubRoleTypeIds(String parentRoleTypeId, Delegator delegator) {
		List<GenericValue> listAllSubRoleTypeIds = FastList.newInstance();
		Set<String> roleTypeIdSet = FastSet.newInstance();
        try {
            List<GenericValue> roleTypeList = delegator.findByAnd("RoleType", UtilMisc.toMap("parentTypeId", parentRoleTypeId), null, true);
            if (UtilValidate.isNotEmpty(roleTypeList)) {
            	for (GenericValue roleType : roleTypeList) {
                    String roleTypeId = roleType.getString("roleTypeId");
                    if (roleTypeIdSet.contains(roleTypeId)) {
                        continue;
                    }
                    listAllSubRoleTypeIds.add(roleType);
                    roleTypeIdSet.add(roleTypeId);
                    listAllSubRoleTypeIds.addAll(getAllSubRoleTypeIds(roleTypeId, delegator));
                }
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, "Error finding sub-roleTypes for roleType search", module);
        }
        return listAllSubRoleTypeIds;
    }
	
	public static List<GenericValue> getAllSubRoleTypeIdsByGroup(String roleTypeGroupId, Delegator delegator) {
		List<GenericValue> listAllSubRoleTypeIds = FastList.newInstance();
        try {
            List<GenericValue> roleTypeList = EntityUtil.filterByDate(delegator.findByAnd("RoleTypeGroupMember", UtilMisc.toMap("roleTypeGroupId", roleTypeGroupId), null, true));
            if (UtilValidate.isNotEmpty(roleTypeList)) {
            	for (GenericValue roleTypeMember : roleTypeList) {
                    String roleTypeId = roleTypeMember.getString("roleTypeId");
                    listAllSubRoleTypeIds.add(roleTypeMember.getRelatedOne("RoleType", false));
                    List<GenericValue> listTemp = getAllSubRoleTypeIds(roleTypeId, delegator);
                    if (UtilValidate.isNotEmpty(listTemp)) {
                    	 listAllSubRoleTypeIds.addAll(listTemp);
                    }
                }
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, "Error finding sub-roleTypes for roleType search", module);
        }
        return listAllSubRoleTypeIds;
    }
	
	public static List<String> getListSalesAdminIdByProductStore(String productStoreId, Delegator delegator) {
		List<String> listSalesAdmin = new ArrayList<String>();
		if (UtilValidate.isNotEmpty(productStoreId)) {
			try {
				List<EntityCondition> listConds = new ArrayList<EntityCondition>();
				listConds.add(EntityCondition.makeCondition("productStoreId", productStoreId));
				listConds.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.IN, getListDescendantRoleInclude("DELYS_SALESADMIN", delegator)));
				List<GenericValue> listProductStoreRole = EntityUtil.filterByDate(
						delegator.findList("ProductStoreRoleDetail", EntityCondition.makeCondition(listConds), null, null, null, false));
				if (UtilValidate.isNotEmpty(listProductStoreRole)) {
					listSalesAdmin = EntityUtil.getFieldListFromEntityList(listProductStoreRole, "partyId", true);
				}
			} catch (GenericEntityException e) {
	            Debug.logError(e, "Error finding sales admin id search", module);
	        }
		}
		return listSalesAdmin;
	}
	public static List<String> getListSalesAdminGTIdByProductStore(String productStoreId, Delegator delegator) {
		List<String> listSalesAdmin = new ArrayList<String>();
		if (UtilValidate.isNotEmpty(productStoreId)) {
			try {
				List<EntityCondition> listConds = new ArrayList<EntityCondition>();
				listConds.add(EntityCondition.makeCondition("productStoreId", productStoreId));
				listConds.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.IN, getListDescendantRoleInclude("DELYS_SALESADMIN_GT", delegator)));
				List<GenericValue> listProductStoreRole = EntityUtil.filterByDate(
						delegator.findList("ProductStoreRoleDetail", EntityCondition.makeCondition(listConds), null, null, null, false));
				if (UtilValidate.isNotEmpty(listProductStoreRole)) {
					listSalesAdmin = EntityUtil.getFieldListFromEntityList(listProductStoreRole, "partyId", true);
				}
			} catch (GenericEntityException e) {
	            Debug.logError(e, "Error finding sales admin id search", module);
	        }
		}
		return listSalesAdmin;
	}
	public static List<String> getListSalesAdminMTIdByProductStore(String productStoreId, Delegator delegator) {
		List<String> listSalesAdmin = new ArrayList<String>();
		if (UtilValidate.isNotEmpty(productStoreId)) {
			try {
				List<EntityCondition> listConds = new ArrayList<EntityCondition>();
				listConds.add(EntityCondition.makeCondition("productStoreId", productStoreId));
				listConds.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.IN, getListDescendantRoleInclude("DELYS_SALESADMIN_MT", delegator)));
				List<GenericValue> listProductStoreRole = EntityUtil.filterByDate(
						delegator.findList("ProductStoreRoleDetail", EntityCondition.makeCondition(listConds), null, null, null, false));
				if (UtilValidate.isNotEmpty(listProductStoreRole)) {
					listSalesAdmin = EntityUtil.getFieldListFromEntityList(listProductStoreRole, "partyId", true);
				}
			} catch (GenericEntityException e) {
	            Debug.logError(e, "Error finding sales admin id search", module);
	        }
		}
		return listSalesAdmin;
	}
}
