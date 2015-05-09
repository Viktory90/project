package com.olbius.util;

import java.util.ArrayList;
import java.util.List;

import javolution.util.FastList;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityUtil;

public class OrgComposite extends Organization{

	public List<GenericValue> getChildList() throws GenericEntityException {
		List<GenericValue> childAllList = FastList.newInstance();
		for(Organization org : childList){
			childAllList.add(org.getOrg());
			if(UtilValidate.isNotEmpty(org.getChildList())){
				childAllList.addAll(org.getChildList());
			}
		}
		return childAllList;
	}

	@Override
	public List<GenericValue> getEmployeeInOrg(Delegator delegator) throws GenericEntityException {
		List<GenericValue> employeeList = FastList.newInstance();
		String rootPartyId = org.getString("partyId"); 
		
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyIdFrom", rootPartyId));
		conditions.add(EntityCondition.makeCondition("roleTypeIdTo", "EMPLOYEE"));
		conditions.add(EntityUtil.getFilterByDateExpr());
		employeeList = delegator.findList("EmploymentAndPersonOlbius", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		for(Organization org: childList){
			employeeList.addAll(org.getEmployeeInOrg(delegator));
		}
		return employeeList;
	}
	
	/*@Override
	public List<GenericValue> getEmployeeInOrg(Delegator delegator,
			int viewIndex, int viewSize) throws GenericEntityException {
		// TODO Auto-generated method stub
		List<GenericValue> employeeList = FastList.newInstance();
		String rootPartyId = org.getString("partyId"); 
		
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyIdFrom", rootPartyId));
		conditions.add(EntityCondition.makeCondition("roleTypeIdTo", "EMPLOYEE"));
		conditions.add(EntityUtil.getFilterByDateExpr());
		int lowIndex = viewIndex * viewSize + 1;
		int highIndex = (viewIndex + 1) * viewSize;
		EntityFindOptions findOpts = new EntityFindOptions(true, EntityFindOptions.TYPE_SCROLL_INSENSITIVE, EntityFindOptions.CONCUR_READ_ONLY, -1, highIndex, true);
		employeeList = delegator.find("EmploymentAndPerson", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, findOpts);
		for(Organization org: childList){
			employeeList.addAll(org.getEmployeeInOrg(delegator));
		}
		return employeeList;		
	}*/
	
	public List<GenericValue> getDirectEmployee(Delegator delegator) throws GenericEntityException{
		List<GenericValue> employeeList = FastList.newInstance();
		String rootPartyId = org.getString("partyId"); 		
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyIdFrom", rootPartyId));
		conditions.add(EntityCondition.makeCondition("roleTypeIdTo", "EMPLOYEE"));
		conditions.add(EntityUtil.getFilterByDateExpr());
		employeeList = delegator.findList("EmploymentAndPerson", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		return employeeList;
	}
	
	public List<GenericValue> getAllDepartmentList(Delegator delegator) throws GenericEntityException{
		List<GenericValue> allDepartmentList = FastList.newInstance();
		String rootPartyId = org.getString("partyId");
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyIdFrom", rootPartyId));
		conditions.add(EntityCondition.makeCondition("partyRelationshipTypeId", "GROUP_ROLLUP"));
		List<GenericValue> departmentList = delegator.findList("PartyRelationshipAndDetail", EntityCondition.makeCondition(conditions), null, UtilMisc.toList("groupName"), null, false);
		allDepartmentList.addAll(departmentList);
		for(Organization tempOrg: childList){
			List<GenericValue> tempList = tempOrg.getAllDepartmentList(delegator);
			if(UtilValidate.isNotEmpty(tempList)){
				allDepartmentList.addAll(tempList);
			}
		}
		return allDepartmentList;
	}
	
	public List<GenericValue> getDirectChildList(Delegator delegator){
		List<GenericValue> adapterList=new ArrayList<GenericValue>();
		for(Organization item : childList){
			String orgTypeId = item.getOrgType();
			if(PropertiesUtil.GROUP_TYPE.equals(orgTypeId)){
				adapterList.add(item.getOrg());
			}
		}
		return adapterList;
	}
	
	public void add(Organization org){
		this.childList.add(org);
	}
	
	public void remove(Organization org){
		this.childList.remove(org);
	}

}
