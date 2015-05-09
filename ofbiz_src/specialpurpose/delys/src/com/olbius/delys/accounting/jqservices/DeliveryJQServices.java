package com.olbius.delys.accounting.jqservices;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javolution.util.FastSet;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityComparisonOperator;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class DeliveryJQServices {
	
	public static final String module = CostsJQServices.class.getName();
	public static final String resource = "widgetUiLabels";
    public static final String resourceError = "widgetErrorUiLabels";
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> getListDelivery(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	String deliveryTypeId = "DELIVERY_SALES";
    	String deliveryId = "";
    	String statusId = null;
    	if(parameters.get("deliveryId") != null){
    		deliveryId = parameters.get("deliveryId")[0];
    	}
    	if(parameters.get("deliveryTypeId") != null){
    		deliveryTypeId = parameters.get("deliveryTypeId")[0];
    	}
    	if(parameters.get("statusId") != null){
    		statusId = parameters.get("statusId")[0];
    	}
    	if ("DELIVERY_SALES".equals(deliveryTypeId)){
    		if(UtilValidate.isEmpty(parameters.get("orderId"))){
    			Map<String, String> mapCondition = new HashMap<String, String>();
    			if (deliveryTypeId != null && !"".equals(deliveryTypeId)){
    				mapCondition.put("deliveryTypeId", deliveryTypeId);
    	    	}
            	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
            	listAllConditions.add(tmpConditon);
        		try {
    				listIterator = delegator.find("Delivery", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
    			} catch (GenericEntityException e) {
    				String errMsg = "Fatal error calling getListDelivery service: " + e.toString();
    				Debug.logError(e, errMsg, module);
    			}
        	}else{
        		String orderId = parameters.get("orderId")[0];
            	Map<String, String> mapCondition = new HashMap<String, String>();
            	mapCondition.put("orderId", orderId);
            	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
            	listAllConditions.add(tmpConditon);
            	try {
            		listIterator = delegator.find("Delivery", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
            	} catch (GenericEntityException e) {
        			String errMsg = "Fatal error calling getListDelivery service: " + e.toString();
        			Debug.logError(e, errMsg, module);
        		}
        	}
    	} else if ("DELIVERY_TRANSFER".equals(deliveryTypeId)){
    		if(UtilValidate.isEmpty(parameters.get("transferId"))){
    			Map<String, String> mapCondition = new HashMap<String, String>();
    			if (deliveryTypeId != null && !"".equals(deliveryTypeId)){
    				mapCondition.put("deliveryTypeId", deliveryTypeId);
    	    	}
            	if (deliveryId != null && !"".equals(deliveryId)){
            		mapCondition.put("deliveryId", deliveryId);
            	}
            	if (statusId != null && !"".equals(statusId)){
    				mapCondition.put("statusId", statusId);
    	    	}
            	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
            	listAllConditions.add(tmpConditon);
        		try {
    				listIterator = delegator.find("Delivery", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
    			} catch (GenericEntityException e) {
    				String errMsg = "Fatal error calling getListDelivery service: " + e.toString();
    				Debug.logError(e, errMsg, module);
    			}
        	}else{
        		String transferId = parameters.get("transferId")[0];
            	Map<String, String> mapCondition = new HashMap<String, String>();
            	mapCondition.put("transferId", transferId);
            	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
            	listAllConditions.add(tmpConditon);
            	try {
            		listIterator = delegator.find("Delivery", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
            	} catch (GenericEntityException e) {
        			String errMsg = "Fatal error calling getListDelivery service: " + e.toString();
        			Debug.logError(e, errMsg, module);
        		}
        	}
    	}
    	
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
   	public static Map<String, Object> getListOrderItemDelivery(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
       	List<String> listSortFields = (List<String>) context.get("listSortFields");
       	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
       	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
       	String orderId = parameters.get("orderId")[0];
       	
       	List<GenericValue> deliveryItems = null;
       	try {
       		deliveryItems = delegator.findList("DeliveryItem", EntityCondition.makeCondition("fromOrderId", orderId), null, null, null, false);
		} catch (GenericEntityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} 
       	
       	Set<String> orderItemSeqIdSet = FastSet.newInstance();
       	for(GenericValue item: deliveryItems){
       		orderItemSeqIdSet.add(item.getString("fromOrderItemSeqId"));
       	}
       	String facilityId = parameters.get("facilityId")[0];
       	Map<String, String> mapCondition = new HashMap<String, String>();
       	mapCondition.put("orderId", orderId);
       	mapCondition.put("facilityId", facilityId);
       	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
       	if(!UtilValidate.isEmpty(orderItemSeqIdSet)){
       		EntityCondition orderItemSeqCond = EntityCondition.makeCondition("orderItemSeqId", EntityComparisonOperator.NOT_IN, orderItemSeqIdSet);
       		listAllConditions.add(orderItemSeqCond);
       	}
       	listAllConditions.add(tmpConditon);
       	List<GenericValue> listOrderItems = new ArrayList<GenericValue>();
       	try {
       		listOrderItems = delegator.findList("OrderItemShipGroupResFacilityView", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND),null, listSortFields, opts, false);
       	} catch (GenericEntityException e) {
   			String errMsg = "Fatal error calling getListOrderItemDelivery service: " + e.toString();
   			Debug.logError(e, errMsg, module);
   		}
       	
       	successResult.put("listIterator", listOrderItems);
       	return successResult;
       }
    
    @SuppressWarnings("unchecked")
   	public static Map<String, Object> getListDeliveryItem(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
       	List<String> listSortFields = (List<String>) context.get("listSortFields");
       	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
       	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
       	EntityListIterator listIterator = null;
       	String deliveryId = null;
       	if(!UtilValidate.isEmpty(parameters.get("deliveryId"))){
       		deliveryId = parameters.get("deliveryId")[0];
       	}
       	Map<String, String> mapCondition = new HashMap<String, String>();
       	mapCondition.put("deliveryId", deliveryId);
       	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	
    	try {
    		listIterator = delegator.find("DeliveryItemView", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
    	} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListDelivery service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
       	
       }
}
