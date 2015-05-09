package com.olbius.delys.lookup;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class LookupServices {
	public final static String module = LookupServices.class.getName();
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqListCustomerOfDistributor(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	/*Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("agreementId", parameters.get("agreementId")[0]);
    	mapCondition.put("agreementItemSeqId", parameters.get("agreementItemSeqId")[0]);
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	*/
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("partyIdFrom", userLogin.getString("partyId"));
    	mapCondition.put("partyRelationshipTypeId", "CUSTOMER");
    	mapCondition.put("roleTypeId", "DELYS_CUSTOMER_GT");
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	listAllConditions.add(condStatusPartyDisable);
    	try {
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqListCustomerOfDistributor service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> jqListCustomerGTOfCompany(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	/*Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("agreementId", parameters.get("agreementId")[0]);
    	mapCondition.put("agreementItemSeqId", parameters.get("agreementItemSeqId")[0]);
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);*/
    	if (parameters.containsKey("productStoreId")) {
    		String productStoreId = parameters.get("productStoreId")[0];
    		if (UtilValidate.isNotEmpty(productStoreId)) {
    			listAllConditions.add(EntityCondition.makeCondition("productStoreId", EntityOperator.EQUALS, productStoreId));
    			listAllConditions.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "CUSTOMER"));
    			List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	    	listAllConditions.add(condStatusPartyDisable);
    	    	try {
    	    		listAllConditions.add(EntityUtil.getFilterByDateExpr());
    	    		EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    	    		opts.setDistinct(true);
    	    		listIterator = delegator.find("ProductStoreRoleDetailPartyStatus", tmpConditon, null, null, listSortFields, opts);
    			} catch (Exception e) {
    				String errMsg = "Fatal error calling jqListCustomerGTOfCompany service: " + e.toString();
    				Debug.logError(e, errMsg, module);
    			}
    		}
    	}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqListProduct(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	List<String> listProductId = new ArrayList<String>();
    	try {
    		String productQuotationId = "";
    		if (parameters.containsKey("productIds[]")) {
    			String[] productIds = (String[]) parameters.get("productIds[]");
    			if (UtilValidate.isNotEmpty(productIds)) {
    				for (String productId : productIds) {
    					listProductId.add(productId);
    				}
    			}
    		}
    		if (parameters.containsKey("productQuotationId")) {
    			productQuotationId = parameters.get("productQuotationId")[0];
    			List<String> listProductId2 = EntityUtil.getFieldListFromEntityList(
        				delegator.findByAnd("ProductQuotationAndPriceRCA", UtilMisc.toMap("pq_ProductQuotationId", productQuotationId, "inputParamEnumId", "PRIP_PRODUCT_ID", 
        						"productPriceActionTypeId", "PRICE_FLAT"), UtilMisc.toList("productId"), false), "productId", true);
    			if (listProductId2 != null) {
        			listProductId.addAll(listProductId2);
        		}
    		}
    		if (UtilValidate.isNotEmpty(listProductId)) {
    			listAllConditions.add(EntityCondition.makeCondition("productId", EntityOperator.NOT_IN, listProductId));
    		}
    		EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		listIterator = delegator.find("Product", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqListProduct service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
}
