package com.olbius.organization.services;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

public class OrganizationServices {

	public static String module = OrganizationServices.class.getName();
	public static String resource = "hrolbiusUiLabels";
	public static String resourceNoti = "NotificationUiLabels";

	/**
	 * Create a Organization
	 * 
	 * @param dpctx
	 * @param context
	 * @return
	 */
	public Map<String, Object> createOrgUnit(DispatchContext dpctx,
			Map<String, ? extends Object> context) {

		Delegator delegator = dpctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		// Create a party group
		String organizationalUnitName = (String) context
				.get("organizationalUnitName");
		String parentOrgId = (String) context.get("parentOrgId");
		String functions = (String) context.get("functions");
		String officeSiteName = (String) context.get("officeSiteName");
		String orgUnitLevel = (String) context.get("orgUnitLevel");
		String managerId = (String) context.get("managerId");
		String title = (String) context.get("title");
		String address1 = (String) context.get("address1");
		String countryGeoId = (String) context.get("countryGeoId");
		String stateProvinceGeoId = (String) context.get("stateProvinceGeoId");
		String countryCode = (String) context.get("countryCode");
		String areaCode = (String) context.get("areaCode");
		String contactNumber = (String) context.get("contactNumber");
		String emailAddress = (String) context.get("emailAddress");
		
		String orgUnitId = delegator.getNextSeqId("Party");
		Timestamp fromDate = new Timestamp(new Date().getTime());

		GenericValue partyGroup = delegator.makeValue("PartyGroup");
		partyGroup.set("partyId", orgUnitId);
		partyGroup.set("groupName", organizationalUnitName);
		partyGroup.set("officeSiteName", officeSiteName);
		partyGroup.set("comments", functions);

		GenericValue party = delegator.makeValue("Party");
		party.set("partyId", orgUnitId);
		party.set("partyTypeId", "LEGAL_ORGANIZATION");

		GenericValue role1 = delegator.makeValue("PartyRole");
		role1.set("partyId", orgUnitId);
		//FIXME role of party get from context
		//role1.set("roleTypeId", "INTERNAL_ORGANIZATIO");
		role1.set("roleTypeId", orgUnitLevel);
		Map<String, Object> partyRoleMaps = FastMap.newInstance();		
		partyRoleMaps.put("partyId", orgUnitId);
		partyRoleMaps.put("roleTypeId", "INTERNAL_ORGANIZATIO");
		partyRoleMaps.put("userLogin", context.get("userLogin"));
		try {
			party.create();
			partyGroup.create();
			role1.create();
			dpctx.getDispatcher().runSync("createPartyRole", partyRoleMaps);
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(
					resourceNoti, "CreateError",
					new Object[] { e.getMessage() }, locale));
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Map<String, Object> result = FastMap.newInstance();
		String parentRoleTypeId = (String)context.get("parentRoleTypeId");
		if(UtilValidate.isEmpty(parentRoleTypeId)){
			try {
				List<GenericValue> partyRoles = delegator.findByAnd("RoleTypeAndParty", UtilMisc.toMap("partyId", parentOrgId, "parentTypeId", "ORGANIZATION_UNIT"), null, false);
				GenericValue roleType = EntityUtil.getFirst(partyRoles);
				result.put("parentRoleTypeId", roleType.getString("roleTypeId"));
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		result.put("orgUnitId", orgUnitId);
		result.put("parentOrgId", parentOrgId);
		result.put("orgUnitLevel", orgUnitLevel);
		result.put("address1", address1);
		result.put("countryGeoId", countryGeoId);
		result.put("stateProvinceGeoId", stateProvinceGeoId);
		result.put("countryCode", countryCode);
		result.put("areaCode", areaCode);
		result.put("contactNumber", contactNumber);
		result.put("emailAddress", emailAddress);
		result.put("managerId", managerId);
		result.put("title", title);
		result.put("orgUnitId", orgUnitId);
		result.put("fromDate", fromDate);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
		return result;

	}

	public Map<String, Object> createOrgPostalAddr(DispatchContext dpctx,
			Map<String, ? extends Object> context) {

		Delegator delegator = dpctx.getDelegator();
		Locale locale = (Locale) context.get("locale");

		String address1 = (String) context.get("address1");
		String countryGeoId = (String) context.get("countryGeoId");
		String stateProvinceGeoId = (String) context.get("stateProvinceGeoId");
		String partyId = (String) context.get("orgUnitId");
		Date date = new Date();
		Timestamp currentTime = new Timestamp(date.getTime());
		String contactMechId = delegator.getNextSeqId("ContactMech");

		GenericValue partyContactMech = delegator.makeValue("PartyContactMech");
		GenericValue contactMech = delegator.makeValue("ContactMech");
		GenericValue postalAddress = delegator.makeValue("PostalAddress");
		
		partyContactMech.set("partyId", partyId);
		partyContactMech.set("contactMechId", contactMechId);
		partyContactMech.set("fromDate", currentTime);
		
		contactMech.set("contactMechId", contactMechId);
		contactMech.set("contactMechTypeId", "POSTAL_ADDRESS");

		postalAddress.set("contactMechId", contactMechId);
		postalAddress.set("address1", address1);
		postalAddress.set("countryGeoId", countryGeoId);
		postalAddress.set("stateProvinceGeoId", stateProvinceGeoId);

		try {
			contactMech.create();
			postalAddress.create();
			partyContactMech.create();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(
					resourceNoti, "CreateError",
					new Object[] { e.getMessage() }, locale));
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(
				resourceNoti, "createError", locale));
	}

	public Map<String, Object> createOrgEmail(DispatchContext dpctx,
			Map<String, ? extends Object> context) {

		Delegator delegator = dpctx.getDelegator();
		Locale locale = (Locale) context.get("locale");

		String emailAddress = (String) context.get("emailAddress");
		String contactMechId = delegator.getNextSeqId("ContactMech");
		String partyId = (String) context.get("orgUnitId");
		Date date = new Date();
		Timestamp currentTime = new Timestamp(date.getTime());

		GenericValue partyContactMech = delegator.makeValue("PartyContactMech");
		GenericValue contactMech = delegator.makeValue("ContactMech");

		contactMech.set("contactMechId", contactMechId);
		contactMech.set("contactMechTypeId", "EMAIL_ADDRESS");
		contactMech.set("infoString", emailAddress);

		partyContactMech.set("partyId", partyId);
		partyContactMech.set("contactMechId", contactMechId);
		partyContactMech.set("fromDate", currentTime);
		try {
			contactMech.create();
			partyContactMech.create();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(
					resourceNoti, "createError",
					new Object[] { e.getMessage() }, locale));
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(
				resourceNoti, "createError", locale));
	}

	public Map<String, Object> createOrgTel(DispatchContext dpctx,
			Map<String, ? extends Object> context) {

		Delegator delegator = dpctx.getDelegator();
		Locale locale = (Locale) context.get("locale");

		String countryCode = (String) context.get("countryCode");
		String areaCode = (String) context.get("areaCode");
		String contactNumber = (String) context.get("contactNumber");
		String contactMechId = delegator.getNextSeqId("ContactMech");
		String partyId = (String) context.get("orgUnitId");
		Date date = new Date();
		Timestamp currentTime = new Timestamp(date.getTime());

		GenericValue partyContactMech = delegator.makeValue("PartyContactMech");
		GenericValue contactMech = delegator.makeValue("ContactMech");
		GenericValue telecomNumber = delegator.makeValue("TelecomNumber");

		contactMech.set("contactMechId", contactMechId);
		contactMech.set("contactMechTypeId", "TELECOM_NUMBER");

		telecomNumber.set("contactMechId", contactMechId);
		telecomNumber.set("countryCode", countryCode);
		telecomNumber.set("areaCode", areaCode);
		telecomNumber.set("contactNumber", contactNumber);

		partyContactMech.set("partyId", partyId);
		partyContactMech.set("contactMechId", contactMechId);
		partyContactMech.set("fromDate", currentTime);
		try {
			contactMech.create();
			telecomNumber.create();
			partyContactMech.create();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(
					resourceNoti, "createError",
					new Object[] { e.getMessage() }, locale));
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(
				resourceNoti, "createError", locale));
	}
	
	public static Map<String, Object> assignSecGroupManager(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		String managerId = (String)context.get("managerId");
		String role = (String)context.get("title");
		
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyId", managerId));
		conditions.add(EntityCondition.makeCondition("enabled", "Y"));
		try {
			List<GenericValue> userLoginList = delegator.findList("UserLogin", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
			List<String> securityGroups = FastList.newInstance();
			if(role.equals("CEO")){
				securityGroups.add("HEADOFCOM");
				securityGroups.add("HEADOFDEPT");
				securityGroups.add("HRMADMIN");
			}else if(role.equals("DHOD")){
				securityGroups.add("HEADOFDEPT");
			}else if(role.equals("HOD")){
				securityGroups.add("HEADOFDEPT");	
			}else if(role.equals("HRMADMIN")){
				securityGroups.add("HEADOFDEPT");
				securityGroups.add("HRMADMIN");
			}
			for(String securityGroup: securityGroups){
				for(GenericValue userLogin: userLoginList){
					if(!checkUserLoginSecurityGroup(delegator, securityGroup, userLogin.getString("userLoginId"))){
						dispatcher.runSync("addUserLoginToSecurityGroup", 
										UtilMisc.toMap("userLoginId", userLogin.getString("userLoginId"),
														"groupId", securityGroup,
														"fromDate", UtilDateTime.nowTimestamp(),
														"userLogin", context.get("userLogin")));
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
		return ServiceUtil.returnSuccess();
	}
	
	private static boolean checkUserLoginSecurityGroup(Delegator delegator, String groupId, String userLoginId) throws GenericEntityException{
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("userLoginId", userLoginId));
		conditions.add(EntityCondition.makeCondition("groupId", groupId));
		conditions.add(EntityUtil.getFilterByDateExpr());
		List<GenericValue> userLoginGroup = delegator.findList("UserLoginSecurityGroup", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
		if(UtilValidate.isNotEmpty(userLoginGroup)){
			return true;
		}else{
			return false;
		}
	}
	
	public static Map<String, Object> CreateMgrForOrg(DispatchContext dctx, Map<String, Object> context){
		String managerId = (String) context.get("managerId");
		String roleTypeId = (String) context.get("roleTypeId");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		//String mgrRoleType = (String) context.get("title");
		String orgId = (String) context.get("orgId");
		
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("partyIdFrom", orgId));
		conditions.add(EntityCondition.makeCondition("partyIdTo", managerId));
		conditions.add(EntityCondition.makeCondition("roleTypeIdTo", "EMPLOYEE"));
		conditions.add(EntityUtil.getFilterByDateExpr());
		try {
			List<GenericValue> empl = dctx.getDelegator().findList("Employment", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
			if(UtilValidate.isEmpty(empl)){
				ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "EmployeeNotBelongDept", (Locale)context.get("locale")));
			}
		} catch (GenericEntityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		Map<String, Object> ctx = FastMap.newInstance();
		ctx.put("partyId", managerId);
		ctx.put("roleTypeId", "MANAGER");
		ctx.put("partyIdFrom", managerId);
		ctx.put("partyIdTo", orgId);
		ctx.put("roleTypeIdFrom", "MANAGER");
		ctx.put("roleTypeIdTo", roleTypeId);
		ctx.put("partyRelationshipTypeId", "MANAGER");
		ctx.put("userLogin", context.get("userLogin"));
		
		try {			
			dispatcher.runSync("createPartyRelationshipAndRole", ctx);			
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess();
	}
}
