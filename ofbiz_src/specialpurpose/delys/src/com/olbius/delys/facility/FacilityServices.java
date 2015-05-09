package com.olbius.delys.facility;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.GeneralRuntimeException;
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
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;


public class FacilityServices {
	
	public static final String module = FacilityServices.class.getName();
	public static final String resource = "DelysUiLabels";
	public static Map<String, Object> getProductId (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String facilityId = (String)context.get("facilityId");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("productId");
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listProductId = delegator.findList("ListProductByInventoryItemId",EntityCondition.makeCondition(UtilMisc.toMap("facilityId", facilityId)), fieldToSelects, null, null, false);
		result.put("listProductId", listProductId);
		return result;
	}
	
	public static Map<String, Object> getLocationByProductId (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productId = (String)context.get("productId");
		String facilityId = (String)context.get("facilityId");
		if(productId != null){
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listLocationByProductId = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition(UtilMisc.toMap("productId", productId, "faciityId", facilityId)), null, null, null, false);
		List<GenericValue> listLocationByProductIds = new ArrayList<GenericValue>();
		if (!listLocationByProductId.isEmpty()){
			listLocationByProductIds.addAll(listLocationByProductId);
		}
		result.put("listLocationByProductId", listLocationByProductIds);
		}
		return result;
	}
	
	public static Map<String, Object> jqGetLocationByProductId(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String locationId = parameters.get("locationId")[0];
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("locationId", EntityOperator.EQUALS, locationId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
	    	listIterator = delegator.find("FindInventoryItemByLocationSeqId", cond, null, null, listSortFields, opts);
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetLocationByProductId service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	public static Map<String,Object> jqCreateInventoryItemByProductId(DispatchContext ctx,
		Map<String, Object> context) throws GenericEntityException {
		Locale locale = (Locale)context.get("locale");
    	
    	
    	Map<String, Object> result = new FastMap<String, Object>();
    	
    	Delegator delegator = ctx.getDelegator();
    	
    	GenericValue inventoryItemLocation = delegator.makeValue("InventoryItemLocation");
    	
    	String productId = (String)context.get("productId");
    	String locationId = (String)context.get("locationId");
    	BigDecimal quantity = (BigDecimal)context.get("quantity");
    	String uomId = (String)context.get("uomId");
    	String inventoryItemId = null;
    	BigDecimal quantityOnHandTotal = null;
    	
    	List<GenericValue> listAll = delegator.findList("InventoryItem", EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productId), null, null, null, false);
    	for (GenericValue list : listAll) {
			inventoryItemId = (String) list.get("inventoryItemId");
			GenericValue inventoryItems = delegator.findOne("InventoryItem", false, UtilMisc.toMap("inventoryItemId", inventoryItemId));
			GenericValue inventoryItemLocationCheck = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "locationId", locationId));
			quantityOnHandTotal = inventoryItems.getBigDecimal("quantityOnHandTotal");
			
			if(inventoryItemLocationCheck != null){
	    		return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkInventoryItemExits", locale));
	    	}
			
			int quantityOnHandTotalData = quantityOnHandTotal.intValue();
			int quantityCast = quantity.intValue();
			
			if(quantityCast > quantityOnHandTotalData){
				return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkQuantityOnHandTotal", locale));
			}
			
			if(quantityCast < quantityOnHandTotalData){
				inventoryItemLocation.put("productId", productId);
		    	inventoryItemLocation.put("inventoryItemId", inventoryItemId);
		    	inventoryItemLocation.put("locationId", locationId);
		    	inventoryItemLocation.put("quantity", quantity);
		    	inventoryItemLocation.put("uomId", uomId);
		    	delegator.create(inventoryItemLocation);
		    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "CreateSucessful", locale));
			}
	    	
    	}
		return result;
    }
	
	public static Map<String, Object> jqGetInventoryItemByLocation(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String facilityId = parameters.get("facilityId")[0];
    	String locationSeqId = parameters.get("locationSeqId")[0];
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("facilityId", EntityOperator.EQUALS, facilityId));
    		listAllConditions.add(EntityCondition.makeCondition("locationSeqId", EntityOperator.NOT_EQUAL, locationSeqId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
	    	listIterator = delegator.find("InventoryItemLocation", cond, null, null, listSortFields, opts);
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetLocationByProductId service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	
	public static Map<String,Object> stockLocation(DispatchContext ctx,
		Map<String, Object> context) throws GenericEntityException {
		Locale locale = (Locale)context.get("locale");
    	Map<String, Object> result = new FastMap<String, Object>();
    	Delegator delegator = ctx.getDelegator();
    	GenericValue inventoryItemLocation = delegator.makeValue("InventoryItemLocation");
    	
    	String productId = (String)context.get("productId");
    	String facilityId = (String)context.get("facilityId");
    	String locationSeqIdTranfer = (String)context.get("locationSeqIdTranfer");
    	String locationSeqIdCurrent = (String)context.get("locationSeqIdCurrent");
    	String quantity = (String)context.get("quantityTransfer");
    	String quantityCurrent = (String)context.get("quantityCurrent");
    	String uomId = (String)context.get("uomId");
    	String inventoryItemId = null;
    	
    	
    	
    	List<GenericValue> listAllProductId = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productId), null, null, null, false);
    	for (GenericValue list : listAllProductId) {
			inventoryItemId = (String) list.get("inventoryItemId");
		}
    	GenericValue inventoryItemLocationCurrentData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdCurrent));
		GenericValue inventoryItemLocationTranferToData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdTranfer));
    	
		BigDecimal quantityToData = (BigDecimal) inventoryItemLocationTranferToData.get("quantity");
		int quantityCastDataTo = quantityToData.intValue();
		String uomIdTranferToData = (String) inventoryItemLocationTranferToData.get("uomId");
		
		
    	BigDecimal quantityCastInput =  BigDecimal.ZERO;
    	NumberFormat fm = NumberFormat.getInstance(locale);
		if (quantity != null){
			try {
				quantityCastInput = new BigDecimal(fm.parse(quantity).toString());
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		
		BigDecimal quantityCurrentCastInput =  BigDecimal.ZERO;
		if (quantityCurrent != null){
			try {
				quantityCurrentCastInput = new BigDecimal(fm.parse(quantityCurrent).toString());
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
    	
		GenericValue inventoryItemLocationTranferData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdTranfer));
		if(inventoryItemLocationTranferData == null){
			inventoryItemLocation.put("productId", productId);
			inventoryItemLocation.put("inventoryItemId", inventoryItemId);
	    	inventoryItemLocation.put("facilityId", facilityId);
	    	inventoryItemLocation.put("locationSeqId", locationSeqIdTranfer);
	    	inventoryItemLocation.put("quantity", quantityCastInput);
	    	inventoryItemLocation.put("uomId", uomId);
	    	delegator.create(inventoryItemLocation);
	    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "CreateSucessful", locale));
		}
    	
		else{
			int quantityCurrentCastTo = quantityCurrentCastInput.intValue();
			int quantityCastTo = quantityCastInput.intValue();
			if(uomId.equals(uomIdTranferToData) == false){
				return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkUomId", locale));
			}
			
			if(quantityCastTo > quantityCurrentCastTo){
					return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "CheckQuantityCurrent", locale));
			}
			int quantityInputCurrent = quantityCurrentCastTo - quantityCastTo;
			BigDecimal valnputCurrent = new BigDecimal(quantityInputCurrent);
					
			inventoryItemLocationCurrentData.put("quantity", valnputCurrent);
			delegator.store(inventoryItemLocationCurrentData);
					
			int quantityInputTo = quantityCastTo + quantityCastDataTo;
			BigDecimal valnputTranfer = new BigDecimal(quantityInputTo);
					
			inventoryItemLocationTranferToData.put("quantity", valnputTranfer);
			delegator.store(inventoryItemLocationTranferToData);
			return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "StockLocationInventoryItemSuccess", locale));
			
		}
    }
	
	public static Map<String,Object> stockLocationMany(DispatchContext ctx,
		Map<String, Object> context) throws GenericEntityException {
		Locale locale = (Locale)context.get("locale");
    	Map<String, Object> result = new FastMap<String, Object>();
    	Delegator delegator = ctx.getDelegator();
    	GenericValue inventoryItemLocation = delegator.makeValue("InventoryItemLocation");
    	
    	//String[] productId = (String[])context.get("productId[]");
    	List<String> productId = (List<String>)context.get("productId[]");
    	List<String> locationSeqIdCurrent = (List<String>)context.get("locationSeqIdCurrent[]");
    	String facilityId = (String)context.get("facilityId");
    	String locationSeqIdTranfer = (String)context.get("locationSeqIdTranfer");
    	List<String> quantity = (List<String>)context.get("quantityTranfers[]");
    	List<String> quantityCurrent = (List<String>)context.get("quantityCurrent[]");
    	List<String> uomId = (List<String>)context.get("uomId[]");
    	
    	String inventoryItemId = null;
    	GenericValue inventoryItemLocationCurrentData = null;
    	GenericValue inventoryItemLocationTranferToData = null;
    	GenericValue inventoryItemLocationTranferData = null;
    	BigDecimal quantityCurrentCastInput =  BigDecimal.ZERO;
    	BigDecimal quantityCastInput =  BigDecimal.ZERO;
    	
    	NumberFormat fm = NumberFormat.getInstance(locale);
		
		
    	for (String productIdFor : productId) {
    		if (quantity != null){
				try {
					for (String quantityTranferCast : quantity) {
						quantityCastInput = new BigDecimal(fm.parse(quantityTranferCast).toString());
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if (quantityCurrent != null){
				try {
					for (String quantityCurrentCast : quantityCurrent) {
						quantityCurrentCastInput = new BigDecimal(fm.parse(quantityCurrentCast).toString());
					}
					
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
    		List<GenericValue> listAllProductId = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productIdFor), null, null, null, false);
	    	for (GenericValue list : listAllProductId) {
				inventoryItemId = (String) list.get("inventoryItemId");
				inventoryItemLocationTranferToData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdTranfer));
				inventoryItemLocationTranferData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdTranfer));
	    	}
	    	int quantityCurrentCastTo = quantityCurrentCastInput.intValue();
			int quantityCastTo = quantityCastInput.intValue();
			
	    	for (String locationSeqIdCurrentFor : locationSeqIdCurrent) {
	    		inventoryItemLocationCurrentData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdCurrentFor));
	    	}
	    	

    		
    		BigDecimal quantityToData = (BigDecimal) inventoryItemLocationTranferToData.get("quantity");
			int quantityCastDataTo = quantityToData.intValue();
			String uomIdTranferToData = (String) inventoryItemLocationTranferToData.get("uomId");
			
		
			if(inventoryItemLocationTranferData == null){
				inventoryItemLocation.put("productId", productId);
				inventoryItemLocation.put("inventoryItemId", inventoryItemId);
		    	inventoryItemLocation.put("facilityId", facilityId);
		    	inventoryItemLocation.put("locationSeqId", locationSeqIdTranfer);
		    	inventoryItemLocation.put("quantity", quantityCastInput);
		    	inventoryItemLocation.put("uomId", uomId);
		    	delegator.create(inventoryItemLocation);
		    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "CreateSucessful", locale));
			}
	    	
			else{
				for (String uomIdCast : uomId) {
					if(uomIdCast.equals(uomIdTranferToData) == false){
						return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkUomId", locale));
					}
				}
				if(quantityCastTo > quantityCurrentCastTo){
						return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "CheckQuantityCurrent", locale));
				}
				int quantityInputCurrent = quantityCurrentCastTo - quantityCastTo;
				BigDecimal valnputCurrent = new BigDecimal(quantityInputCurrent);
						
					inventoryItemLocationCurrentData.put("quantity", valnputCurrent);
				delegator.store(inventoryItemLocationCurrentData);
						
				int quantityInputTo = quantityCastTo + quantityCastDataTo;
				BigDecimal valnputTranfer = new BigDecimal(quantityInputTo);
						
				inventoryItemLocationTranferToData.put("quantity", valnputTranfer);
				delegator.store(inventoryItemLocationTranferToData);
			}
	    	
	    	
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "StockLocationInventoryItemSuccess", locale));
    	
    }
	
	public static Map<String,Object> stockOneProductForLocationMany(DispatchContext ctx,
		Map<String, Object> context) throws GenericEntityException {
		Locale locale = (Locale)context.get("locale");
    	Delegator delegator = ctx.getDelegator();
    	GenericValue inventoryItemLocation = delegator.makeValue("InventoryItemLocation");
    	
    	//String[] productId = (String[])context.get("productId[]");
    	String productId = (String)context.get("productId");
    	String locationSeqIdCurrent = (String)context.get("locationSeqIdCurrent");
    	String facilityId = (String)context.get("facilityId");
    	
    	List<String> lstlocationSeqIdTranfer=(List<String>)context.get("locationSeqIdTranfer[]");
    	List<String> lstquantity = (List<String>)context.get("quantityTranfers[]");
    	
    	Map<String, String> lstItemLocationTranfer = new HashMap<String,String>(); 	
    	for (int i = 0; i < lstlocationSeqIdTranfer.size(); i++) {				
    		lstItemLocationTranfer.put(lstlocationSeqIdTranfer.get(i), lstquantity.get(i));	    		
		}
    	
    	String uomId = (String)context.get("uomId");
    	
    	String inventoryItemId = null;
    	GenericValue inventoryItemLocationCurrentData = null;
    	GenericValue inventoryItemLocationTranferToData = null;
    	BigDecimal quantityCurrentCastInput =  BigDecimal.ZERO;
    	BigDecimal quantityCastInput =  BigDecimal.ZERO;
    	
    	NumberFormat fm = NumberFormat.getInstance(locale);
	    	String quantityCurrent = (String)context.get("quantityCurrent");
			if (quantityCurrent != null){
				try {
						quantityCurrentCastInput = new BigDecimal(fm.parse(quantityCurrent).toString());																		
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
			int quantityCurrentCastTo = quantityCurrentCastInput.intValue();
			int quantityCastTo = quantityCastInput.intValue();
			String locationSeqId = null;
			int totalQuantityCastTo=0;
    		List<GenericValue> listAllProductId = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productId), null, null, null, false);
	    	for (GenericValue list : listAllProductId) {
				inventoryItemId = (String) list.get("inventoryItemId");
				locationSeqId = (String) list.get("locationSeqId");
				for (Map.Entry<String,String> locationTranfersss : lstItemLocationTranfer.entrySet() ) {
					
					inventoryItemLocationTranferToData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationTranfersss.getKey()));
					inventoryItemLocationCurrentData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdCurrent));
					
					
					
					
					if(inventoryItemLocationTranferToData == null){
						
						totalQuantityCastTo+=Integer.parseInt(locationTranfersss.getValue());
						int quantityInputCurrent = quantityCurrentCastInput.intValue() - totalQuantityCastTo;
						BigDecimal valnputCurrent = new BigDecimal(quantityInputCurrent);
						
						inventoryItemLocationCurrentData.put("quantity", valnputCurrent);
						delegator.store(inventoryItemLocationCurrentData);
						BigDecimal quantityInputToDataaaa = new BigDecimal(locationTranfersss.getValue());
						
						inventoryItemLocation.put("productId", productId);
						inventoryItemLocation.put("inventoryItemId", inventoryItemId);
				    	inventoryItemLocation.put("facilityId", facilityId);
				    	inventoryItemLocation.put("locationSeqId", locationTranfersss.getKey());
				    	inventoryItemLocation.put("quantity", quantityInputToDataaaa);
				    	inventoryItemLocation.put("uomId", uomId);
				    	delegator.create(inventoryItemLocation);
				    	
					}
					
					else{
						if (locationTranfersss.getKey().contains(locationSeqId)) { 	
							
							totalQuantityCastTo+=Integer.parseInt(locationTranfersss.getValue());
							int quantityInputCurrent = quantityCurrentCastInput.intValue() - totalQuantityCastTo;
							BigDecimal valnputCurrent = new BigDecimal(quantityInputCurrent);
							
							BigDecimal quantityToData = (BigDecimal) inventoryItemLocationTranferToData.get("quantity");
							int quantityCastDataTo = quantityToData.intValue();
							
							String uomIdTranferToData = (String) inventoryItemLocationTranferToData.get("uomId");
							
							if(uomId.equals(uomIdTranferToData) == false){
								return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkUomId", locale));
							}
							
							if(quantityCastTo > quantityCurrentCastTo){
									return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "CheckQuantityCurrent", locale));
							}
							inventoryItemLocationCurrentData.put("quantity", valnputCurrent);
							delegator.store(inventoryItemLocationCurrentData);
									
							int quantityInputTo = quantityCastDataTo + Integer.parseInt(locationTranfersss.getValue());
							BigDecimal valnputTranfer = new BigDecimal(quantityInputTo);
									
							inventoryItemLocationTranferToData.put("quantity", valnputTranfer);
							delegator.store(inventoryItemLocationTranferToData);
						}
					}
				}
				
	    	}
	    	
	    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "CreateSucessful", locale));
    }
	
	public static Map<String, Object> jqGetLocationAndQuantityByFacilityId(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String facilityId = parameters.get("facilityId")[0];
    	String locationSeqId = parameters.get("locationSeqId")[0];
    	List<GenericValue> listLocationSeqId = new ArrayList<GenericValue>();
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("facilityId", EntityOperator.EQUALS, facilityId));
    		listAllConditions.add(EntityCondition.makeCondition("locationSeqId", EntityOperator.NOT_EQUAL, locationSeqId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
    		opts.setDistinct(true);
    		listLocationSeqId = delegator.findList("FacilityLocation", cond, null, listSortFields, opts, false);
    		if(!UtilValidate.isEmpty(listLocationSeqId)){
    			for(GenericValue location : listLocationSeqId){
    				Map<String, Object> row = new HashMap<String, Object>();
    				row.put("locationSeqId", (String)location.get("locationSeqId"));
    				List<GenericValue> listDetail = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition(UtilMisc.toMap("locationSeqId", (String)location.get("locationSeqId"), "facilityId", facilityId)), null, null, null, false);
    				
    				List<Map<String, String>> rowDetail = new ArrayList<Map<String,String>>();
    				if(!UtilValidate.isEmpty(listDetail)){
    					for(GenericValue detail : listDetail){
    							GenericValue uom = delegator.findOne("Uom", false, UtilMisc.toMap("uomId", (String)detail.get("uomId")));
        						Map<String, String> childDetail = new HashMap<String, String>(); 
        						String inventoryItemId = (String)detail.get("inventoryItemId");
        						String product = (String)detail.get("productId");
        						BigDecimal quantity = (BigDecimal)detail.getBigDecimal("quantity");
        						String quanityData = quantity.intValue() + "";
        						String descriptionUomId = (String) uom.get("description");
        						String locationSeqIdCurrent = (String) detail.get("locationSeqId");
        						childDetail.put("inventoryItemId", inventoryItemId);
        						childDetail.put("productId", product);
        						childDetail.put("quantity", quanityData);
        						childDetail.put("locationSeqIdCurrent", locationSeqIdCurrent);
        						childDetail.put("uomId", descriptionUomId);
        						rowDetail.add(childDetail);
    						
    					}
    				}
    				row.put("rowDetail", rowDetail);
    				listIterator.add(row);
    			}
    		}
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetLocationByProductId service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetProductByFacilityIdPhysical(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String facilityId = parameters.get("facilityId")[0];
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("facilityId", EntityOperator.EQUALS, facilityId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
	    	listIterator = delegator.find("ListInventoryItemForPhysical", cond, null, null, listSortFields, opts);
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetLocationByProductId service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	public static Map<String, Object> createPhysicalVariancesLog(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		LocalDispatcher dispatcher = dpx.getDispatcher();
		Locale locale = (Locale) context.get("locale");
		/*Map<String, Object> result = new FastMap<String, Object>();*/
		/*String facilityId = (String)context.get("facilityId");*/
		String temp = (String)context.get("quantityOnHandVar");
		String tempAvailableToPromiseVar = (String)context.get("availableToPromiseVar");
		GenericValue userlogin = (GenericValue)context.get("userLogin");
		String inventoryItemId = (String)context.get("inventoryItemId");
		/*String partyId = (String)userlogin.get("partyId");
		Timestamp dateCheck = (Timestamp)context.get("dateCheck");
		String personCheck = (String)context.get("personCheck");
		Timestamp currentDate = UtilDateTime.nowTimestamp();*/
		BigDecimal quantityReason = new BigDecimal(temp);
		
		/*String physicalInvIdInput = (String)context.get("physicalInventoryId");*/
		String variance = (String)context.get("varianceReasonId");
		/*String physicalInvId = null;*/
		//create data physical Inventory
		
		int qohInput = quantityReason.intValue();
		GenericValue invItemList = null;
        try {
            invItemList = delegator.findOne("InventoryItem", false, UtilMisc.toMap("inventoryItemId", inventoryItemId));
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
            throw new GeneralRuntimeException(e.getMessage());
        }

        
            if (invItemList != null) {
                /*int qoh = ((BigDecimal)invItemList.getBigDecimal("quantityOnHandTotal")).intValue();*/
            String commentQOHInput = null;
                if (qohInput < 0) {
                	commentQOHInput = "QOH less than stocktake correction";
                }
                else{
                	commentQOHInput = "QOH greater than or equal stocktake correction";
                }
                Map<String, Object> contextInput = UtilMisc.toMap("userLogin", userlogin, "inventoryItemId", invItemList.get("inventoryItemId"), "varianceReasonId", variance,"quantityOnHandVar", quantityReason, "comments", commentQOHInput);
                try {
                    dispatcher.runSync("createPhysicalInventoryAndVariance",contextInput);
                } catch (GenericServiceException e) {
                    Debug.logError(e, "fixProductNegativeQOH failed on createPhysicalInventoryAndVariance invItemId"+invItemList.get("inventoryItemId"), module);
                    return ServiceUtil.returnError(UtilProperties.getMessage(resource, "ProductErrorCreatePhysicalInventoryAndVariance", UtilMisc.toMap("inventoryItemId", invItemList.get("inventoryItemId")), locale));
                }
            }
        
        return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> updateProductIdByFacilityLocation(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String inventoryItemId = (String)context.get("inventoryItemId");
		String facilityId = (String)context.get("facilityId");
		String locationSeqId = (String) context.get("locationSeqId");
		String productId = (String) context.get("productId");
		BigDecimal quantity = (BigDecimal) context.get("quantity");
		String uomId = (String) context.get("uomId");
		
		
		GenericValue inventoryItemLocation = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqId));
		if(inventoryItemId != null){
			inventoryItemLocation.put("productId", productId);
			inventoryItemLocation.put("quantity", quantity);
			inventoryItemLocation.put("uomId", uomId);
			delegator.store(inventoryItemLocation);
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetContactMechInFacility(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	
    	Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("contactMechTypeId");
		/*List<String> orderBy = new ArrayList<String>();
		orderBy.add("contactMechTypeId");*/
		
    	String facilityId = parameters.get("facilityId")[0];
    	List<GenericValue> listContactMechInFacility = new ArrayList<GenericValue>();
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("facilityId", EntityOperator.EQUALS, facilityId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
    		opts.setDistinct(true);
    		listContactMechInFacility = delegator.findList("ContactMechInFacility", cond, fieldToSelects, listSortFields, opts, false);
    		if(!UtilValidate.isEmpty(listContactMechInFacility)){
    			for(GenericValue contactMechType : listContactMechInFacility){
    				Map<String, Object> row = new HashMap<String, Object>();
    				String contactMechTypeId = (String)contactMechType.get("contactMechTypeId");
    				row.put("contactMechTypeId", contactMechTypeId);
    				List<GenericValue> listDetail = delegator.findList("ContactMechInFacilityTypePurpose", EntityCondition.makeCondition(UtilMisc.toMap("contactMechTypeId", contactMechTypeId, "facilityId", facilityId)), null, null, null, false);
    				List<Map<String, String>> rowDetail = new ArrayList<Map<String,String>>();
    			
    				if(!UtilValidate.isEmpty(listDetail)){
    					for(GenericValue detail : listDetail){
    						/*if(contactMechTypeId.equals("EMAIL_ADDRESS") == true|| contactMechTypeId.equals("POSTAL_ADDRESS") == true || contactMechTypeId.equals("TELECOM_NUMBER") == true || contactMechTypeId.equals("WEB_ADDRESS") == true || contactMechTypeId.equals("LDAP_ADDRESS") == true){*/
    							Map<String, String> childDetail = new HashMap<String, String>();
    							String contactMechId = (String) detail.get("contactMechId");
            					String descriptionContactMechPurpuseType = (String) detail.get("descriptionContactMechPurpuseType");
            					String infoString = (String) detail.get("infoString");
            					String address1 = (String) detail.get("address1");
            					String toName = (String) detail.get("toName");
            					childDetail.put("contactMechId", contactMechId);
            					childDetail.put("descriptionContactMechPurpuseType", descriptionContactMechPurpuseType);
            					childDetail.put("infoString", infoString);
            					childDetail.put("address1", address1);
            					childDetail.put("toName", toName);
            					rowDetail.add(childDetail);
    						/*}
		    				else{
		    					String contactMechId = (String)detail.get("contactMechId");
		            			String infoString = (String)detail.get("infoString");
		            			childDetail.put("contactMechId", contactMechId);
		            			childDetail.put("infoString", infoString);
		    				} */
    					}
    				}
    				row.put("rowDetail", rowDetail);
    				listIterator.add(row);
    			}
    		}
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetLocationByProductId service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	public static Map<String, Object> loadContactMechTypePurposeList(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		Locale locale = (Locale)context.get("locale");
		String contactMechTypeId = (String)context.get("contactMechTypeId");
		GenericValue contactMechPurposeType = null;
		String contactMechPurposeTypeId = null;
		List<GenericValue> listContactTypePurpose = delegator.findList("ContactMechTypePurpose", EntityCondition.makeCondition(UtilMisc.toMap("contactMechTypeId", contactMechTypeId)), null, null, null, false);
		List<Map<String, String>> listcontactMechPurposeTypeMap = new ArrayList<Map<String,String>>();
		for (GenericValue contactTypePurpose : listContactTypePurpose) {
			if(contactTypePurpose != null){
				contactMechPurposeTypeId = (String) contactTypePurpose.get("contactMechPurposeTypeId");
				contactMechPurposeType = delegator.findOne("ContactMechPurposeType", false, UtilMisc.toMap("contactMechPurposeTypeId", contactMechPurposeTypeId));
			}
			String description = (String) contactMechPurposeType.get("description", locale);
	    	Map<String, String> contactMechPurposeTypeMap =  new HashMap<String,String>(); 			
	    	contactMechPurposeTypeMap.put(contactMechPurposeTypeId, description);	  
			listcontactMechPurposeTypeMap.add(contactMechPurposeTypeMap);
			
		}
		result.put("listcontactMechPurposeTypeMap", listcontactMechPurposeTypeMap);
		return result;
	}
	
	public static Map<String, Object> loadGeoAssocListByGeoId(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String geoId = (String)context.get("geoId");
		GenericValue geoAssoc = null;
		String geoIdTo = null;
		List<GenericValue> listGeoAssoc = delegator.findList("GeoAssoc", EntityCondition.makeCondition(UtilMisc.toMap("geoId", geoId, "geoAssocTypeId", "REGIONS")), null, null, null, false);
		List<Map<String, String>> listGeoAssocMap = new ArrayList<Map<String,String>>();
		for (GenericValue geoAssocData : listGeoAssoc) {
			if(geoAssocData != null){
				geoIdTo = (String) geoAssocData.get("geoIdTo");
				geoAssoc = delegator.findOne("Geo", false, UtilMisc.toMap("geoId", geoIdTo));
			}
			String geoName = (String) geoAssoc.get("geoName");
	    	Map<String, String> geoAssocMap =  new HashMap<String,String>(); 			
	    	geoAssocMap.put(geoIdTo, geoName);	  
	    	listGeoAssocMap.add(geoAssocMap);
			
		}
		result.put("listGeoAssocMap", listGeoAssocMap);
		return result;
	}
	
	public static Map<String, Object> createFacilityContactMech(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String contactMechId = null;
		String facilityId = (String)context.get("facilityId");
		String contactMechTypeId = (String)context.get("contactMechTypeId");
		String contactMechPurposeTypeId = (String)context.get("contactMechPurposeTypeId");
		String toName = (String)context.get("toName");
		String attnName = (String)context.get("attnName");
		String address1 = (String)context.get("address1");
		String address2 = (String)context.get("address2");
		String city = (String)context.get("city");
		String countryGeoId = (String)context.get("countryGeoId");
		String stateProvinceGeoId = (String)context.get("stateProvinceGeoId");
		String postalCode = (String)context.get("postalCode");
		Timestamp nowTimeStamp = UtilDateTime.nowTimestamp();
		
		if(contactMechId == null){
			contactMechId = delegator.getNextSeqId("ContactMech");
		}
		
		GenericValue contactMech = delegator.makeValue("ContactMech");
		contactMech.put("contactMechId", contactMechId);
		contactMech.put("contactMechTypeId", contactMechTypeId);
		delegator.create(contactMech);
		
		GenericValue facilityContactMech = delegator.makeValue("FacilityContactMech");
		facilityContactMech.put("facilityId", facilityId);
		facilityContactMech.put("contactMechId", contactMechId);
		facilityContactMech.put("fromDate", nowTimeStamp);
		delegator.create(facilityContactMech);
		
		GenericValue facilityContactMechPurpose = delegator.makeValue("FacilityContactMechPurpose");
		facilityContactMechPurpose.put("facilityId", facilityId);
		facilityContactMechPurpose.put("contactMechId", contactMechId);
		facilityContactMechPurpose.put("contactMechPurposeTypeId", contactMechPurposeTypeId);
		facilityContactMechPurpose.put("fromDate", nowTimeStamp);
		delegator.create(facilityContactMechPurpose);
		
		GenericValue postalAddress = delegator.makeValue("PostalAddress");
		postalAddress.put("contactMechId", contactMechId);
		postalAddress.put("toName", toName);
		postalAddress.put("attnName", attnName);
		postalAddress.put("address1", address1);
		postalAddress.put("address2", address2);
		postalAddress.put("city", city);
		postalAddress.put("countryGeoId", countryGeoId);
		postalAddress.put("stateProvinceGeoId", stateProvinceGeoId);
		postalAddress.put("postalCode", postalCode);
		delegator.create(postalAddress);
		
		return result;
	}
	
	public static Map<String, Object> createFacilityContactMechByEmailAddress(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String contactMechId = null;
		String facilityId = (String) context.get("facilityId");
		String contactMechTypeId = (String)context.get("contactMechTypeId");
		String contactMechPurposeTypeId = (String)context.get("contactMechPurposeTypeId");
		GenericValue facilityContactMech = delegator.makeValue("FacilityContactMech");
		GenericValue facilityContactMechPurpose = delegator.makeValue("FacilityContactMechPurpose");
		String infoString = (String) context.get("infoString");
		
		if(contactMechId == null){
			contactMechId = delegator.getNextSeqId("ContactMech");
		}
		
		GenericValue contactMech = delegator.makeValue("ContactMech");
		contactMech.put("contactMechId", contactMechId);
		contactMech.put("contactMechTypeId", contactMechTypeId);
		contactMech.put("infoString", infoString);
		delegator.create(contactMech);
		
		if(contactMechTypeId.equals("EMAIL_ADDRESS") == true || contactMechTypeId.equals("WEB_ADDRESS") == true|| contactMechTypeId.equals("LDAP_ADDRESS") == true){
			
			Timestamp nowTimeStamp = UtilDateTime.nowTimestamp();
			facilityContactMech.put("facilityId", facilityId);
			facilityContactMech.put("contactMechId", contactMechId);
			facilityContactMech.put("fromDate", nowTimeStamp);
			delegator.create(facilityContactMech);
			
			
			facilityContactMechPurpose.put("facilityId", facilityId);
			facilityContactMechPurpose.put("contactMechId", contactMechId);
			facilityContactMechPurpose.put("contactMechPurposeTypeId", contactMechPurposeTypeId);
			facilityContactMechPurpose.put("fromDate", nowTimeStamp);
			delegator.create(facilityContactMechPurpose);
		}
		return result;
	}
	
	public static Map<String, Object> jqGetListLocationInFacility(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String facilityId = parameters.get("facilityId")[0];
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("facilityId", EntityOperator.EQUALS, facilityId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
	    	listIterator = delegator.find("LocationFacility", cond, null, null, listSortFields, opts);
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetLocationByProductId service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	public static Map<String, Object> jqGetListInventoryItem(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String facilityId = parameters.get("facilityId")[0];
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("facilityId", EntityOperator.EQUALS, facilityId));
    		EntityCondition cond = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
	    	listIterator = delegator.find("ProductNameByInventoryItemTotal", cond, null, null, listSortFields, opts);
	    } catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListInventoryItem service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
    }
	
	public static Map<String, Object> loadListLocationFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String facilityId = (String) context.get("facilityId");
		List<GenericValue> listlocationFacilityList = delegator.findList("LocationFacility", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", facilityId)), null, null, null, false);
		List<GenericValue> listInventoryItem = new ArrayList<GenericValue>();
		Map<String, Object> listInventoryItemLocationDetailMap = new HashMap<String, Object>();
		for (GenericValue locationFacility : listlocationFacilityList) {
			String locationId = (String) locationFacility.get("locationId");
			listInventoryItem = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition(UtilMisc.toMap("locationId", locationId)), null, null, null, false);
			listInventoryItemLocationDetailMap.put(locationId, listInventoryItem);
		}
		
		result.put("listInventoryItemLocationDetailMap", listInventoryItemLocationDetailMap);
		result.put("listlocationFacilityMap", listlocationFacilityList);
		return result;
		
	}
	
public static Map<String, Object> loadLocationFacilityType(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationFacilityTypeId = null;	
		List<GenericValue> listlocationFacilityTypeList = delegator.findList("LocationFacilityType", null, null, null, null, false);
		List<Map<String, String>> listlocationFacilityTypeMapData = new ArrayList<Map<String,String>>();
		for (GenericValue locationFacilityType : listlocationFacilityTypeList) {
			locationFacilityTypeId = (String) locationFacilityType.get("locationFacilityTypeId");
			String description = (String) locationFacilityType.get("description");
	    	Map<String, String> listLoactionFacilityTypeMap =  new HashMap<String,String>(); 			
	    	listLoactionFacilityTypeMap.put(locationFacilityTypeId, description);	  
	    	listlocationFacilityTypeMapData.add(listLoactionFacilityTypeMap);
			
		}
		result.put("listlocationFacilityTypeMap", listlocationFacilityTypeMapData);
		return result;
		
	}

	public static Map<String, Object> createNewLocationFacilityType(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationId = null;	
		String locationCode = (String) context.get("locationCode");
		String facilityId = (String) context.get("facilityId");
		String parentLocationId = (String) context.get("parentLocationId");
		String locationFacilityTypeId = (String) context.get("locationFacilityTypeId");
		String description = (String) context.get("description");
		
		if(locationId == null){
			locationId = delegator.getNextSeqId("LocationFacility");
		}
		GenericValue locationFacility = delegator.makeValue("LocationFacility");
		locationFacility.put("locationId", locationId);
		locationFacility.put("locationCode", locationCode);
		locationFacility.put("facilityId", facilityId);
		locationFacility.put("parentLocationId", parentLocationId);
		locationFacility.put("locationFacilityTypeId", locationFacilityTypeId);
		locationFacility.put("description", description);
		delegator.create(locationFacility);
		return result;
		
	}
	
	public static Map<String, Object> createNewLocationFacilityTypeAISLE(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationId = null;	
		String locationCode = (String) context.get("locationCode");
		String facilityId = (String) context.get("facilityId");
		String locationFacilityTypeId = (String) context.get("locationFacilityTypeId");
		String parentLocationId = (String) context.get("parentLocationId");
		String description = (String) context.get("description");
		
		if(locationId == null){
			locationId = delegator.getNextSeqId("LocationFacility");
		}
		GenericValue locationFacility = delegator.makeValue("LocationFacility");
		locationFacility.put("locationId", locationId);
		locationFacility.put("facilityId", facilityId);
		locationFacility.put("locationCode", locationCode);
		locationFacility.put("locationFacilityTypeId", locationFacilityTypeId);
		locationFacility.put("parentLocationId", parentLocationId);
		locationFacility.put("description", description);
		delegator.create(locationFacility);
		return result;
		
	}
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListLocationFacilityType(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	try {
    		listAllConditions.add(EntityCondition.makeCondition("locationFacilityTypeId", EntityOperator.EQUALS, "POSITION"));
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		List<GenericValue> listLoactionFacilityByPosition = delegator.findList("LocationFacility", tmpConditon, null, null, null, false);
    		for (GenericValue locationFacilityByPosition : listLoactionFacilityByPosition) {
				
    			String locationTypeIdPOSITION = (String) locationFacilityByPosition.get("locationTypeId");
    			String descriptionPOSITION = (String) locationFacilityByPosition.get("description");
    			
    			
    			String parentLocationIdPosition = (String) locationFacilityByPosition.get("parentLocationId");
				GenericValue locationFacilityByLocationId = delegator.findOne("LocationFacility", false, UtilMisc.toMap("locationId", parentLocationIdPosition));
				String locationTypeIdLEVEL = (String) locationFacilityByLocationId.get("locationTypeId");
				String descriptionLEVEL = (String) locationFacilityByLocationId.get("description");
				
				String parentLocationIdLevel = (String) locationFacilityByLocationId.get("parentLocationId");
				GenericValue locationFacilityByLocationIdLevel = delegator.findOne("LocationFacility", false, UtilMisc.toMap("locationId", parentLocationIdLevel));
				String locationTypeIdSECTION = (String) locationFacilityByLocationIdLevel.get("locationTypeId");
				String descriptionSECTION = (String) locationFacilityByLocationIdLevel.get("description");
				
				String parentLocationIdSection = (String) locationFacilityByLocationIdLevel.get("parentLocationId");
				GenericValue locationFacilityByLocationIdSection = delegator.findOne("LocationFacility", false, UtilMisc.toMap("locationId", parentLocationIdSection));
				String locationTypeIdAISLE = (String) locationFacilityByLocationIdSection.get("locationTypeId");
				String descriptionAISLE = (String) locationFacilityByLocationIdSection.get("description");
				
				String parentLocationIdAisle = (String) locationFacilityByLocationIdSection.get("parentLocationId");
				GenericValue locationFacilityByLocationIdAisle = delegator.findOne("LocationFacility", false, UtilMisc.toMap("locationId", parentLocationIdAisle));
				String locationTypeIdAREA = (String) locationFacilityByLocationIdAisle.get("locationTypeId");
				String descriptionAREA = (String) locationFacilityByLocationIdAisle.get("description");
				
				Map<String, Object> childDetailPOSITION = new HashMap<String, Object>();
				Map<String, Object> rowPOSITION = new HashMap<String, Object>();
				
				childDetailPOSITION.put("locationTypeId", locationTypeIdPOSITION);
				childDetailPOSITION.put("description", descriptionPOSITION);
				
				//List<Map<String, Object>> listMapPOSITION = new ArrayList<Map<String,Object>>();
				//listMapPOSITION.add(childDetailPOSITION);
				
				//rowPOSITION.put("rowDetail", listMapPOSITION);
				rowPOSITION.put("locationTypeId", locationTypeIdLEVEL);
				rowPOSITION.put("description", descriptionLEVEL);
				//List<Map<String, Object>> listMapLEVEL = new ArrayList<Map<String,Object>>();
				//listMapLEVEL.add(rowPOSITION);
				
				Map<String, Object> rowLEVEL = new HashMap<String, Object>();
				//rowLEVEL.put("rowDetail", listMapLEVEL);
				rowLEVEL.put("locationTypeId", locationTypeIdSECTION);
				rowLEVEL.put("description", descriptionSECTION);
				//List<Map<String, Object>> listMapSECTION = new ArrayList<Map<String,Object>>();
				//listMapSECTION.add(rowLEVEL);
				
				Map<String, Object> rowSECTION = new HashMap<String, Object>();
				//rowSECTION.put("rowDetail", listMapSECTION);
				rowSECTION.put("locationTypeId", locationTypeIdAISLE);
				rowSECTION.put("description", descriptionAISLE);
				
				Map<String, Object> rowAISLE = new HashMap<String, Object>();
				rowAISLE.put("locationTypeId", locationTypeIdAREA);
				rowAISLE.put("description", descriptionAREA);
				
				List<Map<String, Object>> listMapAISLE = new ArrayList<Map<String,Object>>();
				listMapAISLE.add(rowPOSITION);
				listMapAISLE.add(rowLEVEL);
				listMapAISLE.add(rowSECTION);
				listMapAISLE.add(rowAISLE);
				
				Map<String, Object> rowPOSITION2 = new HashMap<String, Object>();
				rowPOSITION2.put("rowDetail", listMapAISLE);
				rowPOSITION2.put("locationTypeId", locationTypeIdPOSITION);
				rowPOSITION2.put("description", descriptionPOSITION);
				//List<Map<String, Object>> listMapAREA = new ArrayList<Map<String,Object>>();
				//listMapAREA.add(rowAISLE);
				
				//Map<String, Object> row = new HashMap<String, Object>();
				//row.put("rowDetail", listMapAREA);
				listIterator.add(rowPOSITION2);
    		} 
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProducts service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	public static Map<String, Object> loadLocationFacilityTypeId(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String facilityId = (String) context.get("facilityId");
		String locationFacilityTypeId = (String) context.get("locationFacilityTypeId");
		GenericValue listlocationFacilityType = delegator.findOne("LocationFacilityType", UtilMisc.toMap("locationFacilityTypeId", locationFacilityTypeId), false);
		String parentLocationFacilityTypeId = (String) listlocationFacilityType.get("parentLocationFacilityTypeId");
		List<GenericValue> listlocationFacilityList = delegator.findList("LocationFacility", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", facilityId, "locationFacilityTypeId", parentLocationFacilityTypeId)), null, null, null, false);
		result.put("listlocationFacilityMap", listlocationFacilityList);
		return result;
		
	}
	
	public static Map<String,Object> addProductInLocationFacility(DispatchContext ctx,
			Map<String, Object> context) throws GenericEntityException, ParseException {
	    	Map<String, Object> result = new FastMap<String, Object>();
	    	Delegator delegator = ctx.getDelegator();
	    	
	    	GenericValue inventoryItemLocation = delegator.makeValue("InventoryItemLocation");
	    	
	    	Map<String, String> listMapInventoryItemId = new HashMap<String, String>();
	    	Map<String, String> listMapUomId = new HashMap<String, String>();
	    	Map<String, String> listMapQuantity = new HashMap<String, String>();
	    	Map<String, String> listMapLocationId = new HashMap<String, String>();
	    	Map<Timestamp, String> mapInventoryItemData = new HashMap<Timestamp, String>();
	    	
	    	List<Map<Timestamp, String>> listMapInventoryItemData = new ArrayList<Map<Timestamp, String>>();
	    	
	    	Map<Object, Object> listMapObjectInventoryItem = new HashMap<Object, Object>();
	    	
	    	String facilityId = (String) context.get("facilityId");
	    	List<String> listLocationId = (List<String>)context.get("locationId[]");
	    	List<String> listProductId = (List<String>)context.get("productId[]");
	    	List<String> listInventoryItemId = (List<String>)context.get("inventoryItemId[]");
	    	List<String> listQuantity = (List<String>)context.get("quantity[]");
	    	List<String> listUomId = (List<String>)context.get("uomId[]");
	    	
	    	List<GenericValue> listInventoryItemByProductIdAndExpireDate = null;
	    	
	    	for (int i = 0; i < listInventoryItemId.size(); i++) {				
	    		listMapInventoryItemId.put(listProductId.get(i), listInventoryItemId.get(i));	    		
			}
	    	
	    	for (int i = 0; i < listLocationId.size(); i++) {				
	    		listMapLocationId.put(listInventoryItemId.get(i), listLocationId.get(i));	    		
			}
	    	
	    	for (int i = 0; i < listQuantity.size(); i++) {				
	    		listMapQuantity.put(listLocationId.get(i), listQuantity.get(i));	    		
			}
	    	
	    	for (int i = 0; i < listUomId.size(); i++) {				
	    		listMapUomId.put(listQuantity.get(i), listUomId.get(i));	    		
			}
	    	
	    	for (Map.Entry<String,String> inventoryItemByProductId : listMapInventoryItemId.entrySet()) {
	    		String productId = inventoryItemByProductId.getKey();
	    		String inventoryItemId = inventoryItemByProductId.getValue();
	    		
	    		for (Map.Entry<String,String> locationIdMap : listMapLocationId.entrySet()) {
	    			String inventoryItemIdBylocationId = locationIdMap.getKey();
	    			if(inventoryItemIdBylocationId.equals(inventoryItemId) == true){
	    				String locationId = locationIdMap.getValue();
	    				for (Map.Entry<String,String> listQuantityMap : listMapQuantity.entrySet()) {
	    					String locationIdQuantity = listQuantityMap.getKey();
	    					if(locationId.equals(locationIdQuantity) == true){
	    						String quantity = listQuantityMap.getValue();
	    						for (Map.Entry<String,String> listUomIdMap : listMapUomId.entrySet()) {
	    							String quantityUomId = listUomIdMap.getKey();
	    							if(quantity.equals(quantityUomId) == true){
	    								
	    								String uomId = listUomIdMap.getValue();
	    								
	    								BigDecimal quantityBig = new BigDecimal(quantityUomId);
	    								
	    								inventoryItemLocation.put("inventoryItemId", inventoryItemId);
	    								inventoryItemLocation.put("productId", productId);
	    								inventoryItemLocation.put("locationId", locationId);
	    								inventoryItemLocation.put("quantity", quantityBig);
	    								inventoryItemLocation.put("uomId", uomId);
	    								
	    								delegator.create(inventoryItemLocation);
	    								
	    							}
	    						}
	    					}
	    				}
	    			}
	    		}
	    		
	    		
	    	}
	    	return result;
	}
	
	public static Map<String, Object> loadExpireDateByProductIdInInventoryItem(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String facilityId = (String) context.get("facilityId");
		String productId = (String) context.get("productId");
		List<GenericValue> listInventoryItem = delegator.findList("InventoryItem", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", facilityId, "productId", productId)), null, null, null, false);
		List<GenericValue> listConfigPacking = delegator.findList("ConfigPacking", EntityCondition.makeCondition(UtilMisc.toMap("productId", productId)), null, null, null, false);
		result.put("listExpireDate", listInventoryItem);
		result.put("listConfigPacking", listConfigPacking);
		return result;
		
	}
	
	public static Map<String, Object> loadRowDetailsByLocationId(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> listLocationId = (List<String>)context.get("locationId[]");
		Map<String, Object> listInventoryItemLocationByLocationIdMap = new HashMap<String, Object>();
		for (String locationId : listLocationId) {
			List<GenericValue> listInventoryItem = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition(UtilMisc.toMap("locationId", locationId)), null, null, null, false);
			listInventoryItemLocationByLocationIdMap.put(locationId, listInventoryItem);
		}
		result.put("listInventoryItemLocationDetailsByLocationIdMap", listInventoryItemLocationByLocationIdMap);
		return result;
		
	}
	
	public static Map<String, Object> loadProductByLocationIdInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> listLocationId = (List<String>)context.get("locationIdTranfer[]");
		Map<String, Object> listMapProductLocationInFacility = new HashMap<String, Object>();
		for (String locationId : listLocationId) {
			List<GenericValue> listInventoryItem = delegator.findList("InventoryItemLocation", EntityCondition.makeCondition(UtilMisc.toMap("locationId", locationId)), null, null, null, false);
			listMapProductLocationInFacility.put(locationId, listInventoryItem);
		}
		result.put("listMapProductLocationInFacility", listMapProductLocationInFacility);
		return result;
		
	}
	
	public static Map<String, Object> createLocationFacilityTypeInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationFacilityTypeId = (String) context.get("locationFacilityTypeId");
		String parentLocationFacilityTypeId = (String) context.get("parentLocationFacilityTypeId");
		String description = (String) context.get("description");
		
		GenericValue locationFacilityType = delegator.makeValue("LocationFacilityType");
		GenericValue locationFacilityTypeCheck = delegator.findOne("LocationFacilityType", UtilMisc.toMap("locationFacilityTypeId", locationFacilityTypeId), false);
		/*if(parentLocationFacilityTypeId.equals(locationFacilityTypeId) == true){
			result.put("value", "errorParent");
			return result;
		}*/
		if(locationFacilityTypeCheck != null){
			result.put("value", "error");
			return result;
		}else{
			locationFacilityType.put("locationFacilityTypeId", locationFacilityTypeId);
			locationFacilityType.put("parentLocationFacilityTypeId", parentLocationFacilityTypeId);
			locationFacilityType.put("description", description);
			delegator.create(locationFacilityType);
			result.put("value", "success");
			return result;
		}
		
	}
	
	public static Map<String, Object> updateLocationFacilityTypeInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationFacilityTypeId = (String) context.get("locationFacilityTypeId");
		String parentLocationFacilityTypeId = (String) context.get("parentLocationFacilityTypeId");
		String description = (String) context.get("description");
		GenericValue locationFacilityType = delegator.findOne("LocationFacilityType", UtilMisc.toMap("locationFacilityTypeId", locationFacilityTypeId), false);
		if(parentLocationFacilityTypeId != null){
			GenericValue locationFacilityTypeCheckParent = delegator.findOne("LocationFacilityType", UtilMisc.toMap("locationFacilityTypeId", parentLocationFacilityTypeId), false);
			String parentLocationFacilityIdData = (String) locationFacilityTypeCheckParent.get("parentLocationFacilityTypeId");
			if(parentLocationFacilityIdData != null){
				if(parentLocationFacilityIdData.equals(locationFacilityTypeId) == true){
					result.put("value", "parentError");
					return result;
				}	
			}
			if(parentLocationFacilityTypeId.equals(locationFacilityTypeId) == true){
				result.put("value", "errorParent");
				return result;
			}
		}
		
		if(locationFacilityType != null){
			locationFacilityType.put("parentLocationFacilityTypeId", parentLocationFacilityTypeId);
			locationFacilityType.put("description", description);
			delegator.store(locationFacilityType);
			result.put("value", "success");
			return result;
		}
		else{
			result.put("value", "error");
			return result;
		}
	}
	
	public static Map<String, Object> deleteLocationFacilityTypeInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> listLocationFacilityTypeId = (List<String>)context.get("locationFacilityTypeId[]");
		for (String locationFacilityTypeId : listLocationFacilityTypeId) {
			GenericValue locationFacilityType = delegator.findOne("LocationFacilityType", UtilMisc.toMap("locationFacilityTypeId", locationFacilityTypeId), false);
			if(locationFacilityType != null){
				delegator.removeValue(locationFacilityType);
			}
			List<GenericValue> locationFacilityTypeByParent = delegator.findList("LocationFacilityType", EntityCondition.makeCondition(UtilMisc.toMap("parentLocationFacilityTypeId", locationFacilityTypeId)), null, null, null, false);
			for (GenericValue genericValue : locationFacilityTypeByParent) {
				if(genericValue != null){
					delegator.removeValue(genericValue);
				}
			}
		}
		result.put("value", "success");
		return result;
	}
	
	public static Map<String, Object> loadListLocationFacilityTypeInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<GenericValue> listlocationFacilityType = delegator.findList("LocationFacilityType", null , null, null, null, false);
		result.put("listlocationFacilityTypeMap", listlocationFacilityType);
		return result;
		
	}
	
	public static Map<String, Object> loadParentLocationFacilityTypeId(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationFacilityTypeId = (String) context.get("locationFacilityTypeId");
		GenericValue locationFacilityType = delegator.findOne("LocationFacilityType", UtilMisc.toMap("locationFacilityTypeId", locationFacilityTypeId), false);
		if(locationFacilityType != null){
			result.put("value", "exists");
		}
		else{
			result.put("value", "success");
		}
		return result;
		
	}
	
	public static Map<String, Object> loadParentLocationFacilityTypeIdInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<GenericValue> listParentLocationFacilityTypeMap = delegator.findList("LocationFacilityType", null, null, null, null, false);
		result.put("listParentLocationFacilityTypeMap", listParentLocationFacilityTypeMap);
		return result;
	}
	
	public static Map<String, Object> updateLocationFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationId = (String) context.get("locationId");
		String parentLocationId = (String) context.get("parentLocationId");
		String locationCode = (String) context.get("locationCode");
		String description = (String) context.get("description");
		GenericValue locationFacility = delegator.findOne("LocationFacility", UtilMisc.toMap("locationId", locationId), false);
		if(parentLocationId != null){
			GenericValue locationFacilityTypeCheckParent = delegator.findOne("LocationFacility", UtilMisc.toMap("locationId", parentLocationId), false);
			String parentLocationFacilityIdData = (String) locationFacilityTypeCheckParent.get("parentLocationId");
			if(parentLocationFacilityIdData != null){
				if(parentLocationFacilityIdData.equals(locationId) == true){
					result.put("value", "parentError");
					return result;
				}	
			}
			if(parentLocationId.equals(locationId) == true){
				result.put("value", "errorParent");
				return result;
			}
		}
		if(locationFacility != null){
			locationFacility.put("locationCode", locationCode);
			locationFacility.put("parentLocationId", parentLocationId);
			locationFacility.put("description", description);
			delegator.store(locationFacility);
			result.put("value", "success");
			return result;
		}
		else{
			result.put("value", "error");
			return result;
		}
	}
	
	public static Map<String, Object> deleteLocationFacilityType(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> listLocationId = (List<String>)context.get("locationId[]");
		for (String locationId : listLocationId) {
			GenericValue locationFacility = delegator.findOne("LocationFacility", UtilMisc.toMap("locationId", locationId), false);
			if(locationFacility != null){
				delegator.removeValue(locationFacility);
			}
		}
		result.put("value", "success");
		return result;
	}
	
	public static Map<String, Object> loadDataRowToJqxGirdTree(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> listLocationId = (List<String>)context.get("locationId[]");
		List<String> listLocationIdRemain = (List<String>)context.get("locationIdRemain[]");
		List<GenericValue> listLocationFacility = new ArrayList<GenericValue>();
		List<GenericValue> listLocationFacilityRemain = new ArrayList<GenericValue>();
		for (String locationId : listLocationId) {
			GenericValue locationFacility = delegator.findOne("LocationFacility", UtilMisc.toMap("locationId", locationId), false);
			listLocationFacility.add(locationFacility);
		}
		for (String locationIdRemain : listLocationIdRemain) {
			GenericValue locationFacilityRemain = delegator.findOne("LocationFacility", UtilMisc.toMap("locationId", locationIdRemain), false);
			listLocationFacilityRemain.add(locationFacilityRemain);
		}
		result.put("listLocationFacility", listLocationFacility);
		result.put("listLocationFacilityRemain", listLocationFacilityRemain);
		return result;
	}
	
	public static Map<String, Object> loadDataRowToJqxGirdTreeAddProduct(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> listLocationId = (List<String>)context.get("locationId[]");
		List<String> listLocationIdRemain = (List<String>)context.get("locationIdRemain[]");
		List<GenericValue> listLocationFacility = new ArrayList<GenericValue>();
		List<GenericValue> listLocationFacilityRemain = new ArrayList<GenericValue>();
		for (String locationId : listLocationId) {
			GenericValue locationFacility = delegator.findOne("LocationFacility", UtilMisc.toMap("locationId", locationId), false);
			listLocationFacility.add(locationFacility);
		}
		result.put("listLocationFacility", listLocationFacility);
		return result;
	}
	
	public static Map<String,Object> addInventoryItemForFacility(DispatchContext ctx,
		Map<String, Object> context) throws GenericEntityException {
		Locale locale = (Locale)context.get("locale");
    	
    	
    	Map<String, Object> result = new FastMap<String, Object>();
    	
    	Delegator delegator = ctx.getDelegator();
    	
    	GenericValue inventoryItemLocation = delegator.makeValue("InventoryItemLocation");
    	
    	
    	String productId = (String)context.get("productId");
    	String facilityId = (String)context.get("facilityId");
    	String locationSeqId = (String)context.get("locationSeqId");
    	String locationSeqIdCurrent = (String)context.get("locationSeqIdCurrent");
    	String quantity = (String)context.get("quantity");
    	String uomId = (String)context.get("uomId");
    	String inventoryItemId = null;
    	
    	
    	BigDecimal quantityCastInput =  BigDecimal.ZERO;
    	NumberFormat fm = NumberFormat.getInstance(locale);
		if (quantity != null){
			try {
				quantityCastInput = new BigDecimal(fm.parse(quantity).toString());
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
    	
    	
    	
    	List<GenericValue> listAll = delegator.findList("InventoryItem", EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productId), null, null, null, false);
    	for (GenericValue list : listAll) {
			inventoryItemId = (String) list.get("inventoryItemId");
		}
    	
    	GenericValue inventoryItems = delegator.findOne("InventoryItem", false, UtilMisc.toMap("inventoryItemId", inventoryItemId));
    	
    	/*List<GenericValue> listAll = delegator.findList("InventoryItem", EntityCondition.makeCondition("productId", EntityOperator.EQUALS, productId), null, null, null, false);*/
    	
    	BigDecimal quantityOnHandTotal = inventoryItems.getBigDecimal("quantityOnHandTotal");
    	
		int quantityOnHandTotalData = quantityOnHandTotal.intValue();
		int quantityCast = Integer.parseInt(quantity);
		
		GenericValue inventoryItemLocationCurrentData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdCurrent));
		GenericValue inventoryItemLocationToData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqId));
		
		
		/*if(locationSeqIdData != null){*/
			/*GenericValue inventoryItemLocationToData = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemId, "facilityId", facilityId, "locationSeqId", locationSeqIdTo));*/
			if(inventoryItemLocationCurrentData != null){
				String facilityIdDataCurrent = (String) inventoryItemLocationCurrentData.get("facilityId"); 
				String locationSeqIdDataCurrent = (String) inventoryItemLocationCurrentData.get("locationSeqId"); 
				BigDecimal quantityDataCurrent = (BigDecimal) inventoryItemLocationCurrentData.get("quantity");
				String uomIdDataCurrent = (String) inventoryItemLocationCurrentData.get("uomId");
				
				int quantityCastCurrent = quantityDataCurrent.intValue();
				
				if(inventoryItemLocationToData == null){
					if(quantityCast > quantityOnHandTotalData){
						return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkQuantityOnHandTotal", locale));
					}
					/*for (GenericValue list : listAll) {
						inventoryItemId = (String) list.get("inventoryItemId");
						
					}*/
					inventoryItemLocation.put("productId", productId);
					inventoryItemLocation.put("inventoryItemId", inventoryItemId);
			    	inventoryItemLocation.put("facilityId", facilityId);
			    	inventoryItemLocation.put("locationSeqId", locationSeqId);
			    	inventoryItemLocation.put("quantity", quantityCastInput);
			    	inventoryItemLocation.put("uomId", uomId);
			    	delegator.create(inventoryItemLocation);
			    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "CreateSucessful", locale));
				} 
				
				BigDecimal quantityDataTo = (BigDecimal) inventoryItemLocationToData.get("quantity");
				int quantityCastTo = quantityDataTo.intValue();
				
				if(uomId.equals(uomIdDataCurrent) == false){
					return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkUomId", locale));
				}
				
				if((facilityId.equals(facilityIdDataCurrent) == true) && (locationSeqId.equals(locationSeqIdDataCurrent) == true) && (uomId.equals(uomIdDataCurrent) == true)){
					return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "StockLocationError", locale));
				}
				if((facilityId.equals(facilityIdDataCurrent) == true) && (uomId.equals(uomIdDataCurrent) == true)){
					if(quantityCast > quantityCastCurrent){
						return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "CheckQuantityCurrent", locale));
					}else{
						int quantityInputCurrent = quantityCastCurrent - quantityCast;
						String quantityCurrent = String.valueOf(quantityInputCurrent);
						
						inventoryItemLocationCurrentData.put("quantity", quantityCurrent);
						delegator.store(inventoryItemLocationCurrentData);
						
						int quantityInputTo = quantityCastTo + quantityCast;
						String quantityIIL = String.valueOf(quantityInputTo);
						
						inventoryItemLocationToData.put("quantity", quantityIIL);
						delegator.store(inventoryItemLocationToData);
						return ServiceUtil.returnSuccess(UtilProperties.getMessage("DelysSalesUiLabels", "StockLocationInventoryItemSuccess", locale));
					}
				}
			}
		/*}*/
		if(quantityCast > quantityOnHandTotalData){
			return ServiceUtil.returnError(UtilProperties.getMessage("DelysSalesUiLabels", "checkQuantityOnHandTotal", locale));
		}
		/*for (GenericValue list : listAll) {
			String productId = (String) list.get("productId");
			
		}*/
		inventoryItemLocation.put("productId", productId);
    	inventoryItemLocation.put("inventoryItemId", inventoryItemId);
    	inventoryItemLocation.put("facilityId", facilityId);
    	inventoryItemLocation.put("locationSeqId", locationSeqId);
    	inventoryItemLocation.put("quantity", quantityCastInput);
    	inventoryItemLocation.put("uomId", uomId);
    	delegator.create(inventoryItemLocation);
    	
    	result.put("facilityId", facilityId);
    	result.put("locationSeqId", locationSeqId);
		return result;
	}
	
	
	public static Map<String, Object> tranfersProductFromLocationToLocationInFacility(DispatchContext dpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpx.getDelegator();
		Map<String, Object> result = new FastMap<String, Object>();
		String locationIdCurrent = (String)context.get("locationIdCurrent");
		List<String> listInventoryItemIdTranfers = (List<String>)context.get("inventoryItemIdTranfers[]");
		List<String> listLocationIdTranfers = (List<String>)context.get("locationIdTranfers[]");
		List<String> listProductIdTranfers = (List<String>)context.get("productIdTranfers[]");
		List<String> listQuantityCurrentTranfers = (List<String>)context.get("quantityCurrentTranfers[]");
		List<String> listQuantityTranferTranfer = (List<String>)context.get("quantityTranferTranfer[]");
		List<String> listUomIdTranfer = (List<String>)context.get("uomIdTranfer[]");
		
		
		GenericValue inventortItemLocationCurrent = null;
		GenericValue inventortItemLocationTranfer = null;
		GenericValue inventoryItemLocationCurrentData = delegator.makeValue("InventoryItemLocation");
		
		for (int i = 0; i < listInventoryItemIdTranfers.size(); i++) {
			String inventoryItemIdTranfer = listInventoryItemIdTranfers.get(i);
			String locationIdTranfer = listLocationIdTranfers.get(i);
			String productIdTranfer = listProductIdTranfers.get(i);
			String quantityCurrentTranfers = listQuantityCurrentTranfers.get(i);
			String quantityTranferTranfers = listQuantityTranferTranfer.get(i);
			String uomIdTranferTranfers = listUomIdTranfer.get(i);
			
			inventortItemLocationCurrent = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemIdTranfer, "locationId", locationIdCurrent));
			inventortItemLocationTranfer = delegator.findOne("InventoryItemLocation", false, UtilMisc.toMap("inventoryItemId", inventoryItemIdTranfer, "locationId", locationIdTranfer));	
			BigDecimal quantityBig = new BigDecimal(quantityTranferTranfers);
			
			int quantityCurrentTranfersInt = Integer.parseInt(quantityCurrentTranfers);
			int quantityTranferTranfersInt = Integer.parseInt(quantityTranferTranfers);
			
			if(quantityTranferTranfersInt <= quantityCurrentTranfersInt){
				if(inventortItemLocationCurrent != null){
					String uomIdTranfer = inventortItemLocationCurrent.getString("uomId");
					
					if(uomIdTranfer.equals(uomIdTranferTranfers) == true){
						int quantitySumTranfer = quantityCurrentTranfersInt - quantityTranferTranfersInt;
						
						String quantityStringSumTranfer = String.valueOf(quantitySumTranfer);
						BigDecimal quantityBigSumTranfer = new BigDecimal(quantityStringSumTranfer);
						
						BigDecimal quantityCurrentData = (BigDecimal) inventortItemLocationCurrent.get("quantity");
						String value = String.valueOf(quantityCurrentData.intValue());
						
						int quantityCurrentByData = Integer.parseInt(value);
						int quantityCurrentInputToData = quantityCurrentByData + quantityTranferTranfersInt;
						String quantityStringCurrentData = String.valueOf(quantityCurrentInputToData);
						BigDecimal quantityBigCurrentData = new BigDecimal(quantityStringCurrentData);
						inventortItemLocationCurrent.put("quantity", quantityBigCurrentData);
						delegator.store(inventortItemLocationCurrent);
						inventortItemLocationTranfer.put("quantity", quantityBigSumTranfer);
						delegator.store(inventortItemLocationTranfer);
						result.put("value", "success");
					}else{
						inventoryItemLocationCurrentData.put("inventoryItemId", inventoryItemIdTranfer);
						inventoryItemLocationCurrentData.put("productId", productIdTranfer);
						inventoryItemLocationCurrentData.put("locationId", locationIdCurrent);
						inventoryItemLocationCurrentData.put("quantity", quantityBig);
						inventoryItemLocationCurrentData.put("uomId", uomIdTranferTranfers);
						delegator.create(inventoryItemLocationCurrentData);
						result.put("value", "success");
					}
				}
				else{
					inventoryItemLocationCurrentData.put("inventoryItemId", inventoryItemIdTranfer);
					inventoryItemLocationCurrentData.put("productId", productIdTranfer);
					inventoryItemLocationCurrentData.put("locationId", locationIdCurrent);
					inventoryItemLocationCurrentData.put("quantity", quantityBig);
					inventoryItemLocationCurrentData.put("uomId", uomIdTranferTranfers);
					delegator.create(inventoryItemLocationCurrentData);
					result.put("value", "success");
				}
			}else{
				result.put("value", "errorQuantityTranfer");
			}
			
		}
		
		return result;
		
	}
}
