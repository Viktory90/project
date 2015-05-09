package com.olbius.util;

import java.util.List;

import javolution.util.FastList;

import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;

public abstract class Organization {
	protected GenericValue org;
	private String orgType;
	public List<Organization> childList = FastList.newInstance();
	public GenericValue getOrg() {
		return org;
	}
	
	public void setOrg(GenericValue org) {
		this.org = org;
	}

	public String getOrgType() {
		return orgType;
	}

	public void setOrgType(String orgType) {
		this.orgType = orgType;
	}

	public List<Organization> getChilListOrg(){
		return childList;
	}
	
	public abstract List<GenericValue> getEmployeeInOrg(Delegator delegator) throws GenericEntityException;
	/*public abstract List<GenericValue> getEmployeeInOrg(Delegator delegator, int viewIndex, int viewSize) throws GenericEntityException;*/
	public abstract List<GenericValue> getChildList() throws GenericEntityException;
	public abstract List<GenericValue> getDirectEmployee(Delegator delegator) throws GenericEntityException;
	public abstract List<GenericValue> getDirectChildList(Delegator delegator);
	public abstract List<GenericValue> getAllDepartmentList(Delegator delegator) throws GenericEntityException;
	
}
