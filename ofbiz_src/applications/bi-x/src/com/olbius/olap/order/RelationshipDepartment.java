package com.olbius.olap.order;

import java.util.List;

import javolution.util.FastList;

import org.ofbiz.base.util.UtilValidate;

public class RelationshipDepartment {
	private String parentId=null;
	private String partyId;
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	private String name;
	private List<RelationshipDepartment> child=FastList.newInstance();
	private boolean flag;
	
	public boolean isFlag() {
		return flag;
	}
	public void setFlag(boolean flag) {
		this.flag = flag;
	}
	public String getPartyId() {
		return partyId;
	}
	public void setPartyId(String partyId) {
		this.partyId = partyId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<RelationshipDepartment> getChild() {
		return child;
	}
	public void setChild(List<RelationshipDepartment> child) {
		this.child = child;
	}
	
	public void addChild(RelationshipDepartment child) {
		this.child.add(child);
	}
	public RelationshipDepartment(String partyId, String name,
			List<RelationshipDepartment> child,boolean flag) {
		super();
		this.partyId = partyId;
		this.name = name;
		this.child = child;
		this.flag=flag;
	}
	
	public RelationshipDepartment(String partyId, String name,
			RelationshipDepartment child,boolean flag) {
		super();
		this.partyId = partyId;
		this.name = name;
		this.child.add(child);
		this.flag=flag;
	}
	
	public RelationshipDepartment() {
	}
	
//	public List<RelationshipDepartment> getAllChildBelongFlagTrue(){
//		List<RelationshipDepartment> child= FastList.newInstance();
//		if(UtilValidate.isNotEmpty(this.getChild())){
//			for(RelationshipDepartment item:this.getChild()){
//				if(item.isFlag()){
//					child.add(item);
//				}else{
//					item.getAllChildBelongFlagTrue();
//				}
//			}
//		}
//		
//		
//		return child;
//	}
	
}
