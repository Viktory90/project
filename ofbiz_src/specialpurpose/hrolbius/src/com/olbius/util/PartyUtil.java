package com.olbius.util;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.apache.commons.lang.StringUtils;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityUtil;

import com.olbius.payroll.PayrollUtil;

public class PartyUtil {

	public static final String RESOURCE = "general";
	public static final String module = PartyUtil.class.getName();
	
	/**
	 * Get a organization by manger Id
	 * @param managerId
	 * @param delegator
	 * @return Id of Organization
	 * @throws Exception
	 */
	public static String getOrgByManager(String managerId, Delegator delegator) throws Exception{
		//FIXME Don't have condition about status
		EntityCondition filterDateCon = EntityUtil.getFilterByDateExpr();
		Map<String, String> mapCondition = UtilMisc.toMap("partyIdFrom", managerId, "partyRelationshipTypeId", "MANAGER");
		
		EntityCondition conditionList = EntityCondition.makeCondition(EntityJoinOperator.AND, EntityCondition.makeCondition(mapCondition), filterDateCon);
		List<GenericValue> relationshipList = (List<GenericValue>)delegator.findList("PartyRelationship", conditionList, null, null, null, false);
		if(UtilValidate.isEmpty(relationshipList)){
				return null;
		}
		GenericValue firstValue = EntityUtil.getFirst(relationshipList);
		return firstValue.getString("partyIdTo");
	}
	
	/**
	 * Get a organization by a manager
	 * @param userLogin
	 * @param delegator
	 * @return Id of Organization
	 * @throws Exception
	 */
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
	
	/**
	 * Get a manager by organization id
	 * @param deptId
	 * @param delegator
	 * @return Id of Manager
	 * @throws Exception
	 */
	public static String getManagerbyOrg(String deptId, Delegator delegator) throws Exception{
		EntityCondition dateCon = EntityUtil.getFilterByDateExpr();
		Map<String, String> mapCondition = UtilMisc.toMap("partyIdTo", deptId, "partyRelationshipTypeId", "MANAGER");
		EntityCondition conditionList = EntityCondition.makeCondition(EntityJoinOperator.AND, EntityCondition.makeCondition(mapCondition), dateCon);
		List<GenericValue> relationshipList = (List<GenericValue>)delegator.findList("PartyRelationship", conditionList, null, null, null, false);
		if(UtilValidate.isEmpty(relationshipList)){
			return null;
		}
		GenericValue firstValue = EntityUtil.getFirst(relationshipList);
		return firstValue.getString("partyIdFrom");
	}
	
	/**
	 * Get a manager by a organization
	 * @param deptId
	 * @param delegator
	 * @return Id of Manager
	 * @throws Exception
	 */
	public static String getManagerbyOrg(GenericValue org, Delegator delegator) throws Exception{
		EntityCondition dateCon = EntityUtil.getFilterByDateExpr();
		Map<String, String> mapCondition = UtilMisc.toMap("partyIdTo", org.getString("partyId"), "partyRelationshipTypeId", "MANAGER");
		EntityCondition conditionList = EntityCondition.makeCondition(EntityJoinOperator.AND, EntityCondition.makeCondition(mapCondition), dateCon);
		List<GenericValue> relationshipList = (List<GenericValue>)delegator.findList("PartyRelationship", conditionList, null, null, null, false);
		if(UtilValidate.isEmpty(relationshipList)){
			return null;
		}
		GenericValue firstValue = EntityUtil.getFirst(relationshipList);
		return firstValue.getString("partyIdFrom");
	}
	
	/**
	 * Get department name by id
	 * @param managerId
	 * @param delegator
	 * @return Name of department
	 * @throws Exception
	 */
	public static String getDeptNameById(String managerId, Delegator delegator) throws Exception {
		String internalOrgId = PartyUtil.getOrgByManager(managerId, delegator);
		GenericValue internalOrg = delegator.findOne("PartyGroup",UtilMisc.toMap("partyId", internalOrgId),false);
		return internalOrg.getString("groupName");
	}
	
	/**
	 * Get Employees in Organization which is configured in general.property
	 * @param delegator
	 * @return A employee list
	 */
	public static List<GenericValue> getEmployeeInOrg(Delegator delegator) {
		//FIXME Need a specific company
		Properties generalProp = UtilProperties.getProperties(RESOURCE);
		String defaultOrganizationPartyId = (String)generalProp.get("ORGANIZATION_PARTY");
		List<GenericValue> employeeList = FastList.newInstance();
		Organization org = null;
		try {
			org = buildOrg(delegator, defaultOrganizationPartyId);
		} catch (GenericEntityException e1) {
			Debug.log("Build Organization Fail");
			return null;
		};
		try {
			employeeList = org.getEmployeeInOrg(delegator);
		} catch (GenericEntityException e) {
			Debug.log("Get Employee Fail");
			return null;
		}
		
		return employeeList;
	}
	
	/**
	 * Build a organization tree
	 * @param delegator
	 * @param partyId
	 * @return A Organization Object
	 * @throws GenericEntityException
	 */
	public static Organization buildOrg(Delegator delegator, String partyId) throws GenericEntityException{
		EntityCondition condition1 = EntityCondition.makeCondition("partyIdFrom", partyId);
		EntityCondition condition2 = EntityCondition.makeCondition("partyRelationshipTypeId", "GROUP_ROLLUP");
		EntityCondition condition3 = EntityCondition.makeCondition("partyRelationshipTypeId", "EMPLOYMENT");
		EntityCondition condition23 = EntityCondition.makeCondition(EntityJoinOperator.OR, condition2, condition3);
		EntityCondition condition4 = PayrollUtil.makeGTEcondition("thruDate", new Timestamp(new Date().getTime()));
		EntityCondition conditionList = EntityCondition.makeCondition(EntityJoinOperator.AND, condition1, condition23, condition4);
		//FIXME Fix partyIdTo is childId
		List<GenericValue> childList = delegator.findList("PartyRelationship", conditionList, UtilMisc.toSet("partyIdTo") , null, null, false);
		GenericValue party = delegator.findOne("Party", UtilMisc.toMap("partyId", partyId), false);
		String orgTypeId = CommonUtil.getPartyTypeOfParty(delegator, party.getString("partyTypeId"));
		if(childList == null || childList.isEmpty()){
			//Get party for this organization
			OrgLeaf leaf = new OrgLeaf();
			//GenericValue party = delegator.findOne("Party", UtilMisc.toMap("partyId", partyId), false);
			leaf.setOrg(party);
			if(orgTypeId != null){
				leaf.setOrgType(orgTypeId);
			}
			return leaf;
		}else {
			OrgComposite composite = new OrgComposite();
			composite.setOrg(party);
			if(orgTypeId != null){
				composite.setOrgType(orgTypeId);
			}
			for(GenericValue child: childList){
				Organization childOrg =  buildOrg(delegator, child.getString("partyIdTo"));
				composite.add(childOrg);
			}
			return composite;
		}
	}
	
	/**
	 * Get CEO 
	 * @param delegator
	 * @return Id of chief of executive(CEO)
	 * @throws Exception
	 */
	public static String getCEO(Delegator delegator) throws Exception{
		Properties generalProp = UtilProperties.getProperties(RESOURCE);
		String defaultOrganizationPartyId = (String)generalProp.get("ORGANIZATION_PARTY");
		EntityCondition filterDateCon = EntityUtil.getFilterByDateExpr();
		Map<String, String> mapCondition = UtilMisc.toMap("partyIdTo", defaultOrganizationPartyId , "partyRelationshipTypeId", "MANAGER", "roleTypeIdFrom", "CEO");
		List<GenericValue> ceoList = delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityJoinOperator.AND, filterDateCon, EntityCondition.makeCondition(mapCondition)) , UtilMisc.toSet("partyIdFrom"), null, null, false);
		if(UtilValidate.isEmpty(ceoList)){
			return null;
		}
		return EntityUtil.getFirst(ceoList).getString("partyIdFrom");
	}
	
	public static boolean isCEO(Delegator delegator, GenericValue userLogin) throws Exception{
		String ceoId = getCEO(delegator);
		return userLogin.getString("partyId").equals(ceoId) ? true : false;
	}
	/**
	 * Get Department of employee
	 * @param delegator
	 * @param employeeId
	 * @return GenericValue: employee
	 * @throws GenericEntityException
	 */
	public static GenericValue getDepartmentOfEmployee(Delegator delegator, String employeeId) throws GenericEntityException{
		//find department of employee
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("roleTypeIdFrom", EntityOperator.EQUALS, "INTERNAL_ORGANIZATIO"));
		conditions.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "EMPLOYEE"));
		conditions.add(EntityCondition.makeCondition("partyIdTo", EntityOperator.EQUALS, employeeId));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> departmentList = delegator.findList("Employment", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		if(UtilValidate.isEmpty(departmentList)){
			return null;
		}
		return EntityUtil.getFirst(departmentList);
	}
	
	public static GenericValue getParentOrgOfDepartmentCurr(Delegator delegator, String departmentId) throws Exception{
		//find department of employee
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyRelationshipTypeId", "GROUP_ROLLUP"));
		conditions.add(EntityCondition.makeCondition("partyIdTo", EntityOperator.EQUALS, departmentId));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> departmentList = delegator.findList("PartyRelationship", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		if(UtilValidate.isEmpty(departmentList)){
			return null;
		}
					
		return EntityUtil.getFirst(departmentList);
	}
	
	public static String getManagerOfEmpl(Delegator delegator, String employeeId) throws Exception{
		GenericValue dept = getDepartmentOfEmployee(delegator, employeeId);
		return getManagerbyOrg(dept.getString("partyIdFrom"), delegator);
	}
	
	public static List<GenericValue> getCurrPositionTypeOfEmpl(Delegator delegator, String employeeId) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		//FIXME need change entity EmplPositionAndPositionType to EmplPositionAndFulfillment 
		conditions.add(EntityCondition.makeCondition("employeePartyId", EntityOperator.EQUALS, employeeId));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> positionList = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		return positionList;
	}
	
	public static List<GenericValue> getCurrPositionTypeOfEmpl(Delegator delegator) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		//FIXME need change entity EmplPositionAndPositionType to EmplPositionAndFulfillment
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> positionList = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		return positionList;
	}
	
	public static Map<String,String> getListEmplPositionInOrgOfManager(Delegator delegator,String managerId) throws Exception{
		List<GenericValue> listEmpl  = getListEmployeeOfManager(delegator,managerId);
		Map<String,String> listPosOfEmpl = FastMap.newInstance();
		for(GenericValue empl : listEmpl){
			if(!empl.getString("partyId").isEmpty()){
				List<GenericValue> listEmplFullFillment = getCurrPositionTypeOfEmpl(delegator,empl.getString("partyId"));
				for(GenericValue emplPosType : listEmplFullFillment){
					String emplPosTypeId = emplPosType.getString("emplPositionId");
					GenericValue tempPos = delegator.findOne("EmplPosition", UtilMisc.toMap("emplPositionId", emplPosTypeId), false);
					GenericValue tmpPosType = delegator.findOne("EmplPositionType", UtilMisc.toMap("emplPositionTypeId", tempPos.getString("emplPositionTypeId")), false);
					if(!listPosOfEmpl.containsKey(tmpPosType.getString("emplPositionTypeId"))){
						listPosOfEmpl.put(tmpPosType.getString("emplPositionTypeId"), tmpPosType.getString("description"));
					}else continue;
				}
			}
		}
		return listPosOfEmpl;
	}
	
	public static String getCurrPosTypeOfEmplOverview(Delegator delegator, String employeeId) throws GenericEntityException{
		List<GenericValue> emplPosType = getCurrPositionTypeOfEmpl(delegator, employeeId);
		List<String> emplPos = FastList.newInstance();
		for(GenericValue tempPos: emplPosType){
			GenericValue emplType = delegator.findOne("EmplPositionType", UtilMisc.toMap("emplPositionTypeId", tempPos.getString("emplPositionTypeId")), false);
			emplPos.add(emplType.getString("description"));
		}
		return StringUtils.join(emplPos, ", ");
	}
	
	public static List<GenericValue> getPositionTypeOfEmplAtTime(Delegator delegator, String employeeId, Timestamp moment) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityUtil.getFilterByDateExpr(moment));
		conditions.add(EntityCondition.makeCondition("employeePartyId", employeeId));
		List<GenericValue> emplPosFul = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition(conditions), null, null, null, false);
		return emplPosFul;
	}
	
	public static List<GenericValue> getPositionOfEmplInDate(Delegator delegator, String employeeId, java.sql.Date date) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		Timestamp timestamp = new Timestamp(date.getTime());
		Timestamp fromDate = UtilDateTime.getDayStart(timestamp);
		Timestamp thruDate = UtilDateTime.getDayEnd(timestamp);
		conditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, fromDate));
		conditions.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
													EntityOperator.OR,
													EntityCondition.makeCondition("thruDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate)));
		conditions.add(EntityCondition.makeCondition("employeePartyId", employeeId));
		List<GenericValue> emplPosFul = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition(conditions), null, null, null, false);
		return emplPosFul;
	}
	
	public static List<GenericValue> getListEmployeeOfManager(Delegator delegator, String managerId) throws Exception{
		List<GenericValue> employeeList = FastList.newInstance();
		Organization org = null;
		String orgId = getOrgByManager(managerId, delegator);
		
		try {
			org = buildOrg(delegator, orgId);
		} catch (GenericEntityException e1) {
			Debug.log("Build Organization Fail");
		}
		try {
			employeeList = org.getEmployeeInOrg(delegator);
		} catch (GenericEntityException e) {
			Debug.log("Get Employee Fail");
		}
		
		return employeeList;
	}
	
	public static boolean isRetiredAge(Delegator delegator, String employeeId) throws GenericEntityException{
		GenericValue employee = delegator.findOne("Person", UtilMisc.toMap("partyId", employeeId), false);		
		java.sql.Date birthDate = employee.getDate("birthDate");
		if(UtilValidate.isEmpty(birthDate)){
			return false;
		}
		Calendar dob = Calendar.getInstance();
		dob.setTime(birthDate);
		Calendar today = Calendar.getInstance();
		int age = today.get(Calendar.YEAR) - dob.get(Calendar.YEAR);
		if (today.get(Calendar.MONTH) < dob.get(Calendar.MONTH)) {
			  age--;  
		} else if (today.get(Calendar.MONTH) == dob.get(Calendar.MONTH)
		    && today.get(Calendar.DAY_OF_MONTH) < dob.get(Calendar.DAY_OF_MONTH)) {
		  age--;  
		}
		if(PropertiesUtil.retiredAge > age){
			return false;
		}
		return true;
	}
	
	public static List<String> getSalessupDeptListByMgr(Delegator delegator, String managerId){
		List<String> retList = FastList.newInstance();
		try {
			String orgPartyId = PartyUtil.getOrgByManager(managerId, delegator);
			Organization organization = PartyUtil.buildOrg(delegator, orgPartyId);
			List<GenericValue> orgList = FastList.newInstance(); 
			orgList = organization.getChildList();
			orgList.add(organization.getOrg());
			for(GenericValue org: orgList){
				List<GenericValue> orgRolesGv = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", org.getString("partyId")), null, false);
				List<String> roles = EntityUtil.getFieldListFromEntityList(orgRolesGv, "roleTypeId", true);
				if(roles.contains("DELYS_SALESSUP_GT")){
					retList.add(org.getString("partyId"));
				}
			}
		} catch (Exception e){
			Debug.log(e.getStackTrace().toString(), module);
		}		
		return retList;
	}
	
	public static boolean isAdmin(String partyId, Delegator delegator){
		String adminId = getHrmAdmin(delegator);
		
		return partyId.equals(adminId) ? true : false;
	}
	
	public static String getHrmAdmin(Delegator delegator){
		EntityCondition condition = EntityCondition.makeCondition("roleTypeId", "HR_DEPARTMENT");
		List<GenericValue> hrDepartmenList = null;
		try {
			hrDepartmenList = delegator.findList("PartyRole", condition, UtilMisc.toSet("partyId"), null, null, false);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			Debug.log(e.getMessage());
		}
		
		String partyId = EntityUtil.getFirst(hrDepartmenList).getString("partyId");
		try {
			return getManagerbyOrg(partyId, delegator);
		} catch (Exception e) {
			Debug.log(e.getMessage());
			return "";
		}
	}		
	
	public static String getOrgNextLevelOfEmpl(Delegator delegator, String partyId) throws Exception{
		GenericValue dept = getDepartmentOfEmployee(delegator, partyId);
		GenericValue parentDept = getParentOrgOfDepartmentCurr(delegator, dept.getString("partyIdFrom"));
		return parentDept.getString("partyIdFrom");
	}
	
	public static List<String> getPartyByRootAndRole(Delegator delegator, String partyId, String role) throws GenericEntityException{
		Organization org = null;
		List<String> childListbyRole = FastList.newInstance();
		org = buildOrg(delegator, partyId);
		List<GenericValue> childList = org.getChildList();
		for(GenericValue item: childList){
			EntityCondition partyCon = EntityCondition.makeCondition("partyId", item.getString("partyId"));
			EntityCondition RoleCon = EntityCondition.makeCondition("roleTypeId", role);
			List<GenericValue> partyRoleList = delegator.findList("PartyRole", EntityCondition.makeCondition(EntityJoinOperator.AND, partyCon, RoleCon), UtilMisc.toSet("partyId"), null, null, false);
			if(UtilValidate.isEmpty(partyRoleList)){
				continue;
			}else{
				childListbyRole.add(item.getString("partyId"));
				}
			}
		return childListbyRole;
	}
	
	public static List<String> getPeopleByRootAndRole(Delegator delegator, String partyId, String role) throws GenericEntityException{
		Organization org = null;
		List<String> childListbyRole = FastList.newInstance();
		org = buildOrg(delegator, partyId);
		List<GenericValue> childList = org.getChildList();
		for(GenericValue item: childList){
			EntityCondition partyCon = EntityCondition.makeCondition("partyId", item.getString("partyId"));
			EntityCondition RoleCon = EntityCondition.makeCondition("roleTypeId", role);
			List<GenericValue> partyRoleList = delegator.findList("PartyRole", EntityCondition.makeCondition(EntityJoinOperator.AND, partyCon, RoleCon), UtilMisc.toSet("partyId"), null, null, false);
			if(UtilValidate.isEmpty(partyRoleList)){
				continue;
			}else{
				GenericValue person = delegator.findOne("Person", UtilMisc.toMap("partyId", item.getString("partyId")), false);
				if(UtilValidate.isEmpty(person)){
					continue;
				}
				childListbyRole.add(item.getString("partyId"));
				}
			}
		return childListbyRole;
	}
	
	public static List<String> getPartyByRootAndRoles(Delegator delegator, String partyId, List<String> roles) throws GenericEntityException{
		Organization org = null;
		List<String> childListbyRole = FastList.newInstance();
		org = buildOrg(delegator, partyId);
		List<GenericValue> childList = org.getChildList();
		for(GenericValue item: childList){
			EntityCondition partyCon = EntityCondition.makeCondition("partyId", item.getString("partyId"));
			//Map<String, Object> roleConMap = FastMap.newInstance();
			List<EntityCondition> roleConds = new ArrayList<EntityCondition>();
			for(String role : roles){
				//roleConMap.put("roleTypeId", role);
				roleConds.add(EntityCondition.makeCondition("roleTypeId", role));
			}
			//EntityCondition RoleCon = EntityCondition.makeCondition(roleConMap, EntityJoinOperator.OR);
			EntityCondition RoleCon = EntityCondition.makeCondition(roleConds, EntityJoinOperator.OR);
			List<GenericValue> partyRoleList = delegator.findList("PartyRole", EntityCondition.makeCondition(EntityJoinOperator.AND, partyCon, RoleCon), UtilMisc.toSet("partyId"), null, null, false);
			if(UtilValidate.isEmpty(partyRoleList)){
				continue;
			}else{
				childListbyRole.add(item.getString("partyId"));
				}
			}
		return childListbyRole;
	}
	
	public static List<GenericValue> getAllManagerInOrg(Delegator delegator) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("roleTypeIdFrom", "MANAGER"));
		conditions.add(EntityUtil.getFilterByDateExpr());
		conditions.add(EntityCondition.makeCondition("partyRelationshipTypeId", "MANAGER"));
		EntityFindOptions findOpts = new EntityFindOptions();
		findOpts.setDistinct(true);
		List<GenericValue> managerList = delegator.findList("PartyRelationship", EntityCondition.makeCondition(conditions), UtilMisc.toSet("partyIdFrom"), UtilMisc.toList("partyIdFrom"), findOpts, false);
		List<GenericValue> retList = FastList.newInstance();
		for(GenericValue manager: managerList){
			String partyId = manager.getString("partyIdFrom");
			GenericValue party = delegator.findOne("Person", UtilMisc.toMap("partyId", partyId), false);
			if(party != null){
				retList.add(party);
			}else{
				System.err.println("cannot find partyId: " + partyId);
			}
		}
		return retList;
	}
	
	public static String getPersonName(Delegator delegator, String partyId) throws GenericEntityException{
		
		GenericValue person = delegator.findOne("Person", UtilMisc.toMap("partyId", partyId), false);
		if(person == null){
			return "";
		}
		StringBuffer partyName = new StringBuffer();
		if(person.getString("firstName") != null){
			partyName.append(person.getString("firstName"));
		}
		if(person.getString("middleName") != null){
			partyName.append(" ");
			partyName.append(person.getString("middleName"));
		}
		if(person.getString("lastName") != null){
			partyName.append(" ");
			partyName.append(person.getString("lastName"));
		}
		return partyName.toString();
	}

	public static List<GenericValue> getPostalAddressByPurpose(Delegator delegator, String purpose){
		List<EntityCondition> conditions = FastList.newInstance();
		//FIXME need change entity EmplPositionAndPositionType to EmplPositionAndFulfillment
		conditions.add(EntityCondition.makeCondition("contactMechPurposeTypeId", purpose));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> postalAddressList = null;
		try {
			postalAddressList = delegator.findList("PartyPostalAddressPurpose", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}
		return postalAddressList;
	}
	public static List<GenericValue> getTelecomNumberByPurpose(Delegator delegator, String purpose){
		List<EntityCondition> conditions = FastList.newInstance();
		//FIXME need change entity EmplPositionAndPositionType to EmplPositionAndFulfillment
		conditions.add(EntityCondition.makeCondition("contactMechPurposeTypeId", purpose));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> postalAddressList = null;
		try {
			postalAddressList = delegator.findList("PartyTelecomNumberPurpose", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}
		return postalAddressList;
	}
	public static List<GenericValue> getFaxNumberByPurpose(Delegator delegator, String purpose){
		List<EntityCondition> conditions = FastList.newInstance();
		//FIXME need change entity EmplPositionAndPositionType to EmplPositionAndFulfillment
		conditions.add(EntityCondition.makeCondition("contactMechPurposeTypeId", purpose));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> postalAddressList = null;
		try {
			postalAddressList = delegator.findList("PartyFaxNumberPurpose", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}
		return postalAddressList;
	}
	public static List<GenericValue> getPartyTax(Delegator delegator){
		List<EntityCondition> conditions = FastList.newInstance();
		//FIXME need change entity EmplPositionAndPositionType to EmplPositionAndFulfillment
		conditions.add(EntityCondition.makeCondition("taxAuthGeoId", "VNM"));
		conditions.add(EntityCondition.makeCondition("taxAuthPartyId", "VNM_TAX"));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> partyTaxList = null;
		try {
			partyTaxList = delegator.findList("PartyTaxAuthInfo", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}
		return partyTaxList;
	}
	public static List<GenericValue> getFinAccount(Delegator delegator){
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> finAccountList = null;
		try {
			finAccountList = delegator.findList("FinAccount", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}
		return finAccountList;
	}
}

