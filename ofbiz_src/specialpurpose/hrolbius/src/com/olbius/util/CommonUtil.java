package com.olbius.util;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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


public class CommonUtil {
	public static List<String> listOperatorPayroll = FastList.newInstance();
	static{
		listOperatorPayroll.add("AND");
		listOperatorPayroll.add("OR");
		listOperatorPayroll.add("lt=");
		listOperatorPayroll.add("lt");
		listOperatorPayroll.add("gt=");
		listOperatorPayroll.add("gt");
		listOperatorPayroll.add("=");
		listOperatorPayroll.add("!=");
	}
	public static List<GenericValue> getPositionTypeOfDept(String departmentId, Delegator delegator) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, departmentId));
		//FIXME need filter by date
		conditions.add(EntityUtil.getFilterByDateExpr("actualFromDate", "actualThruDate"));
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		List<GenericValue> positionTypeList = delegator.findList("EmplPosition", EntityCondition.makeCondition(conditions, EntityOperator.AND), 
																UtilMisc.toSet("emplPositionTypeId"), null, options, false);
		
		return positionTypeList;
	}
	
	public static boolean checkPositionTypeInDept(String positionTypeId, String departmentId, Delegator delegator) throws GenericEntityException{
		List<String> positionTypeList = EntityUtil.getFieldListFromEntityList(getPositionTypeOfDept(departmentId, delegator), "emplPositionTypeId", true) ;
		if(UtilValidate.isEmpty(positionTypeList) || !positionTypeList.contains(positionTypeId)){
			return false;
		}
		return true;
	}	
	public static boolean checkWhiteSpace(String str){
		Pattern pattern = Pattern.compile("\\s");
		Matcher matcher = pattern.matcher(str);
		boolean found = matcher.find();
		return found;
	}

	public static boolean containsValidCharacter(String s) {
	    return (s == null) ? false : s.matches("[A-Za-z_]+");
	}
	
	public static boolean checkValidStringId(String s){
		String p = "[a-zA-Z0-9_]+";
		return Pattern.matches(p, s);
	}
	
	public static String getPartyTypeOfParty(Delegator delegator, String partyTypeId) throws GenericEntityException {
		// TODO Auto-generated method stub
		if(partyTypeId != null){
			GenericValue partyType = delegator.findOne("PartyType", UtilMisc.toMap("partyTypeId", partyTypeId), false);
			if(partyType == null){
				return null;
			}
			String parentTypeId = partyType.getString("parentTypeId");
			if(parentTypeId == null){
				if(PropertiesUtil.PERSON_TYPE.equals(partyTypeId)){
					return PropertiesUtil.PERSON_TYPE;
				}else{
					return PropertiesUtil.GROUP_TYPE;
				}
				
			}
			return getPartyTypeOfParty(delegator, parentTypeId);
		}else{
			return null;
		}
	}
}
