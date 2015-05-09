package com.olbius.delys.accounting.appr;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilFormatOut;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.olbius.delys.services.DelysServices;

public class DeliveryServices {
	
	public enum DeliveryStatus{
		DLV_CREATED, DLV_EXPORTED, DLV_DELIVERED, DLV_APPROVED, DLV_COMPLETED, DLV_CANCELED;
	}
	
	public static final String module = DeliveryServices.class.getName();
	public static final String ApprUiLabels = "DelysAccApprUiLabels";
	public static final int DELIVERY_ITEM_SEQUENCE_ID_DIGITS = 5;
	
	@SuppressWarnings("unchecked")
	public static Map<String,Object> createDelivery(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Map<String, Object> result = new FastMap<String, Object>();
    	Delegator delegator = ctx.getDelegator();
    	
    	//Get Parameters
    	String deliveryId = delegator.getNextSeqId("Delivery");
    	String partyIdTo = (String)context.get("partyIdTo");
    	String partyIdFrom = (String)context.get("partyIdFrom");
    	String currencyUomId = (String)context.get("currencyUomId");
    	String originProductStoreId = (String)context.get("originProductStoreId");
    	String orderId = (String)context.get("orderId");
    	String statusId = (String)context.get("statusId");
    	String destContactMechId = (String)context.get("destContactMechId");
    	String originContactMechId = (String)context.get("originContactMechId");
    	String originFacilityId = (String)context.get("originFacilityId");
    	String destFacilityId = (String)context.get("destFacilityId");
    	String noNumber = (String)context.get("no");
    	String deliveryTypeId = (String)context.get("deliveryTypeId");
    	List<Map<String, String>> listOrderItems = (List<Map<String, String>>)context.get("listOrderItems");
    	
    	//Make Delivery
    	GenericValue delivery = delegator.makeValue("Delivery");
    	Timestamp deliveryDate = (Timestamp)(context.get("deliveryDate"));
    	delivery.put("deliveryDate", deliveryDate);
    	Timestamp createDate = (Timestamp)(context.get("createDate"));
    	delivery.put("createDate", createDate);
    	delivery.put("partyIdFrom", partyIdFrom);
    	delivery.put("deliveryTypeId", deliveryTypeId);
    	delivery.put("currencyUomId", currencyUomId);
    	delivery.put("originContactMechId", originContactMechId);
    	delivery.put("originFacilityId", originFacilityId);
    	delivery.put("destFacilityId", destFacilityId);
    	delivery.put("deliveryId", deliveryId);
    	delivery.put("partyIdTo", partyIdTo);
    	delivery.put("originProductStoreId", originProductStoreId);
    	delivery.put("orderId", orderId);
    	delivery.put("statusId", statusId);
    	delivery.put("no", noNumber);
    	delivery.put("destContactMechId", destContactMechId);
    	GenericValue OrderHeader = delegator.findOne("OrderHeader", false, UtilMisc.toMap("orderId", orderId));
    	OrderHeader.put("productStoreId", originProductStoreId);
    	delivery.put("totalAmount", BigDecimal.ZERO);
    	delivery.create();
    	
    	//Make Delivery Item
    	if (!listOrderItems.isEmpty()){
    		int deliveryItemSeqNum = 1;
    		for (Map<String, String> item : listOrderItems){
    			GenericValue deliveryItem = delegator.makeValue("DeliveryItem");
    			deliveryItem.put("deliveryId", deliveryId);
    			List<String> listOrderBy = new ArrayList<String>();
				listOrderBy.add("-deliveryItemSeqId");
				
				//Set Seq for delivery Item
		        String deliveryItemSeqId = UtilFormatOut.formatPaddedNumber(deliveryItemSeqNum, DELIVERY_ITEM_SEQUENCE_ID_DIGITS);
		        deliveryItem.put("deliveryItemSeqId", deliveryItemSeqId);
    			deliveryItem.put("fromOrderItemSeqId", item.get("orderItemSeqId"));
    			deliveryItem.put("fromOrderId", item.get("orderId"));
    			deliveryItem.put("quantity", BigDecimal.valueOf(Double.parseDouble(item.get("quantity"))));
    			deliveryItem.put("actualExportedQuantity", BigDecimal.ZERO);
    			deliveryItem.put("actualDeliveredQuantity", BigDecimal.ZERO);
    			deliveryItem.put("statusId", "DELI_ITEM_CREATED");
    			deliveryItem.create();
    			deliveryItemSeqNum++;
    		}
    	}
    	
    	//Create DeliveryStatus
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
		String userLoginId = (String)userLogin.get("userLoginId");
		GenericValue deliveryStatus = delegator.makeValue("DeliveryStatus");
		deliveryStatus.put("deliveryStatusId", delegator.getNextSeqId("DeliveryStatus"));
		deliveryStatus.put("deliveryId", deliveryId);
		deliveryStatus.put("statusId", statusId);
		deliveryStatus.put("statusDatetime", UtilDateTime.nowTimestamp());
		deliveryStatus.put("statusUserLogin", userLoginId);
		delegator.createOrStore(deliveryStatus);
		
    	result.put("deliveryId", deliveryId);
    	return result;
	}
	
	public static Map<String,Object> createShipmentFromDelivery(DispatchContext ctx, Map<String, Object> context){
		String deliveryId = (String)context.get("deliveryId");
		Locale locale = (Locale)context.get("locale");
		
		//Create Shipment
		Map<String, Object> shipmentPara = FastMap.newInstance();
		shipmentPara.put("deliveryId", deliveryId);
		shipmentPara.put("ctx", ctx);
		shipmentPara.put("locale", locale);
		DeliveryHelper.createShipmentFromDelivery(shipmentPara);
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(ApprUiLabels, "createShipmentFromDeliverySuccessfully", locale));
	}
	
	public static Map<String,Object> updateDeliveryItem(DispatchContext ctx, Map<String, Object> context){
		
		//Get parameters
		String deliveryId = (String)context.get("deliveryId");
		String deliveryItemSeqId = (String)context.get("deliveryItemSeqId");
		BigDecimal actualExportedQuantity = (BigDecimal)context.get("actualExportedQuantity");
		BigDecimal actualDeliveredQuantity = (BigDecimal)context.get("actualDeliveredQuantity");
		Locale locale = (Locale)context.get("locale");
		Delegator delegator = ctx.getDelegator();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		LocalDispatcher dispatcher = ctx.getDispatcher();
		//Create Subject, Observer and Attach Observer to Subject 
		Observer o = new DeliveryObserver();
		ItemSubject is = new DeliveryItemSubject();
		is.attach(o);
		
		//Set Map
		Map<String, Object> parameters = FastMap.newInstance();
		parameters.put("deliveryId", deliveryId);
		parameters.put("deliveryItemSeqId", deliveryItemSeqId);
		parameters.put("delegator", delegator);
		String deliveryTypeId = null;
		GenericValue delivery = null;
		try {
			delivery = delegator.findOne("Delivery", false, UtilMisc.toMap("deliveryId", deliveryId));
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		if (delivery == null) {
            Debug.logError("delivery is null", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "DeliveryCannotBeFound", (Locale)context.get("locale")));
        }
		deliveryTypeId = (String)delivery.get("deliveryTypeId");
		if(actualDeliveredQuantity.intValue() == 0){
			//Issue to Delivery Note
			Map<String, Object> issuePara = FastMap.newInstance();
			issuePara.put("deliveryId", deliveryId);
			issuePara.put("deliveryItemSeqId", deliveryItemSeqId);
			issuePara.put("context", ctx);
			issuePara.put("locale", locale);
			BigDecimal quantityToIssuse = actualExportedQuantity;
			try {
				GenericValue deliveryItem = delegator.findOne("DeliveryItem", false, UtilMisc.toMap("deliveryId", deliveryId, "deliveryItemSeqId", deliveryItemSeqId));
				String quantityUomId = null;
				String baseUomId = null;
				GenericValue product = null;
				if ("DELIVERY_SALES".equals(deliveryTypeId)){
					GenericValue orderItem = delegator.findOne("OrderItem", false, UtilMisc.toMap("orderId", deliveryItem.getString("fromOrderId"), "orderItemSeqId", deliveryItem.get("fromOrderItemSeqId")));
					if (orderItem == null){
						ServiceUtil.returnError("OrderItem not found for DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
					}
					product = delegator.findOne("Product", false, UtilMisc.toMap("productId", orderItem.getString("productId")));
					if (product == null){
						ServiceUtil.returnError("Product not found for DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
					}
					baseUomId = product.getString("quantityUomId"); 
					if (baseUomId == null){
						ServiceUtil.returnError("Quantity Uom not found for product:" + product.getString("productId") + " of DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
					}
					quantityUomId = orderItem.getString("quantityUomId");
					BigDecimal convertNumber = BigDecimal.ONE;
					convertNumber = DelysServices.getConvertNumber(delegator, convertNumber, product.getString("productId"), quantityUomId, baseUomId);
					if (convertNumber.compareTo(BigDecimal.ONE) == 1){
						quantityToIssuse = actualExportedQuantity.multiply(convertNumber);
					}
				} else if ("DELIVERY_TRANSFER".equals(deliveryTypeId)){
					GenericValue transferItem = delegator.findOne("TransferItem", false, UtilMisc.toMap("transferId", deliveryItem.getString("fromTransferId"), "transferItemSeqId", deliveryItem.get("fromTransferItemSeqId")));
					if (transferItem == null){
						ServiceUtil.returnError("TransferItem not found for DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
					}
					product = delegator.findOne("Product", false, UtilMisc.toMap("productId", transferItem.getString("productId")));
					if (product == null){
						ServiceUtil.returnError("Product not found for DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
					}
					baseUomId = product.getString("quantityUomId");
					if (baseUomId == null){
						ServiceUtil.returnError("Quantity Uom not found for product:" + product.getString("productId") + " of DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
					}
					quantityUomId = transferItem.getString("quantityUomId");
					BigDecimal convertNumber = BigDecimal.ONE;
					convertNumber = DelysServices.getConvertNumber(delegator, convertNumber, product.getString("productId"), quantityUomId, baseUomId);
					if (convertNumber.compareTo(BigDecimal.ONE) == 1){
						quantityToIssuse = actualExportedQuantity.multiply(convertNumber);
					}
				}
				issuePara.put("quantity", quantityToIssuse);
				try {
					DeliveryHelper.issuseDelivery(issuePara);
				} catch (GenericEntityException e1) {
					Debug.log(e1.getStackTrace().toString(), module);
					ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryItemError", locale));
				} catch (GenericServiceException e1) {
					Debug.log(e1.getStackTrace().toString(), module);
					ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryItemError", locale));
				}
				} catch (Exception e) {
				e.printStackTrace();
			}
			
			parameters.put("actualExportedQuantity", actualExportedQuantity);
			try {
				is.updateExportedQuantity(parameters);
			} catch (GenericEntityException e) {
				Debug.log(e.getStackTrace().toString(), module);
				ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryItemError", locale));
			}
		} else{
			if ("DELIVERY_SALES".equals(deliveryTypeId)){
				parameters.put("actualDeliveredQuantity", actualDeliveredQuantity);
				try {
					is.updateDeliveredQuantity(parameters);
				} catch (GenericEntityException e) {
					Debug.log(e.getStackTrace().toString(), module);
					ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryItemError", locale));
				}
			} else if ("DELIVERY_TRANSFER".equals(deliveryTypeId)){
				// update inventory item of destination facility
				try {
					GenericValue deliveryItem = delegator.findOne("DeliveryItem", false, UtilMisc.toMap("deliveryId", deliveryId, "deliveryItemSeqId", deliveryItemSeqId));
					if (deliveryItem == null) {
			            Debug.logError("delivery item is null", module);
			            return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "DeliveryItemCannotBeFound", (Locale)context.get("locale")));
			        }
					parameters.put("actualDeliveredQuantity", actualDeliveredQuantity);
					try {
						is.updateDeliveredQuantity(parameters);
					} catch (GenericEntityException e) {
						Debug.log(e.getStackTrace().toString(), module);
						ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryItemError", locale));
					}
					String transferId = (String)deliveryItem.get("fromTransferId");
					String transferItemSeqId = (String)deliveryItem.get("fromTransferItemSeqId");
					List<GenericValue> listTransferItemShipGroups = delegator.findList("TransferItemShipGroup", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
					if (!listTransferItemShipGroups.isEmpty()){
						GenericValue transferItemShipGroup = listTransferItemShipGroups.get(0);
						String shipGroupSeqId = (String)transferItemShipGroup.get("shipGroupSeqId");
						List<GenericValue> listInventoryItems = delegator.findList("TransferItemIssuance", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId, "transferItemSeqId", transferItemSeqId, "shipGroupSeqId", shipGroupSeqId)), null, null, null, false);
						if (!listInventoryItems.isEmpty()){
							String inventoryItemId = (String)listInventoryItems.get(0).get("inventoryItemId");
							GenericValue invItemFrom = delegator.findOne("InventoryItem", false, UtilMisc.toMap("inventoryItemId", inventoryItemId));
							Map<String, Object> mapInv = FastMap.newInstance();
							GenericValue transferItem = delegator.findOne("TransferItem", false, UtilMisc.toMap("transferId", transferId, "transferItemSeqId", transferItemSeqId));
							GenericValue product = null;
							BigDecimal quantityExported = actualExportedQuantity;
							BigDecimal quantityDelivered = actualDeliveredQuantity;
							if (transferItem != null){
								
								product = delegator.findOne("Product", false, UtilMisc.toMap("productId", transferItem.getString("productId")));
								if (product == null){
									ServiceUtil.returnError("Product not found for DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
								}
								String baseUomId = product.getString("quantityUomId");
								if (baseUomId == null){
									ServiceUtil.returnError("Quantity Uom not found for product:" + product.getString("productId") + " of DeliveryItem: deliveryId" + deliveryId + "deliveryItemSeqId:" + deliveryItemSeqId);
								}
								String quantityUomId = transferItem.getString("quantityUomId");
								BigDecimal convertNumber = BigDecimal.ONE;
								convertNumber = DelysServices.getConvertNumber(delegator, convertNumber, product.getString("productId"), quantityUomId, baseUomId);
								if (convertNumber.compareTo(BigDecimal.ONE) == 1){
									quantityDelivered = actualDeliveredQuantity.multiply(convertNumber);
									quantityExported = actualExportedQuantity.multiply(convertNumber);
								}
								
								mapInv.put("productId", (String)transferItem.get("productId"));
								mapInv.put("facilityId", (String)delivery.get("destFacilityId"));
								mapInv.put("inventoryItemTypeId", "NON_SERIAL_INV_ITEM");
								mapInv.put("userLogin", userLogin);
								mapInv.put("expireDate", transferItem.get("expireDate"));
								mapInv.put("unitCost", invItemFrom.get("unitCost"));
								mapInv.put("purCost", invItemFrom.get("purCost"));
								mapInv.put("quantityAccepted", quantityDelivered);
								mapInv.put("shipmentId", delivery.get("shipmentId"));
								mapInv.put("transferId", transferId);
								mapInv.put("transferItemSeqId", transferItemSeqId);
								BigDecimal quantityRejected = quantityExported.subtract(quantityDelivered);
								if (quantityRejected.compareTo(BigDecimal.ZERO) == 1){
									mapInv.put("quantityRejected", quantityRejected);
									mapInv.put("quantityExcess", BigDecimal.ZERO);
								} else if (quantityRejected.compareTo(BigDecimal.ZERO) == -1){
									mapInv.put("quantityRejected", BigDecimal.ZERO);
									mapInv.put("quantityExcess", quantityRejected.negate());
								} else if (quantityRejected.compareTo(BigDecimal.ZERO) == 0){	
									mapInv.put("quantityExcess", BigDecimal.ZERO);
									mapInv.put("quantityRejected", BigDecimal.ZERO);
								}
								mapInv.put("quantityQualityAssurance", BigDecimal.ZERO);
								try {
									dispatcher.runSync("receiveInventoryProduct", mapInv);
								} catch (GenericServiceException e) {
									e.printStackTrace();
								}
							}
						} else {
							Debug.logError("TransferItemIssuance not found", module);
				            return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "TransferItemIssuanceCannotBeFound", (Locale)context.get("locale")));
						}
					} else {
						Debug.logError("TransferItemShipGroup not found", module);
			            return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "TransferItemShipGroupCannotBeFound", (Locale)context.get("locale")));
					}
				} catch (GenericEntityException e) {
					e.printStackTrace();
				}
			}
		}
		Map<String, Object> result = ServiceUtil.returnSuccess(UtilProperties.getMessage(ApprUiLabels, "updateDeliverySuccessfully", locale));
		try {
			delivery.refresh();
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		String deliveryStatusId = (String)delivery.get("statusId");
		String transferId = (String)delivery.get("transferId");
		result.put("deliveryTypeId", deliveryTypeId);
		result.put("deliveryStatusId", deliveryStatusId);
		result.put("transferId", transferId);
		result.put("deliveryId", deliveryId);
		result.put("deliveryItemSeqId", deliveryItemSeqId);
		return result;
	}
	
	public static Map<String,Object> updateDelivery(DispatchContext ctx, Map<String, Object> context){
		
		//Get parameters
		String deliveryId = (String)context.get("deliveryId");
		String statusId = (String)context.get("statusId");
		Locale locale = (Locale)context.get("locale");
		Delegator delegator = ctx.getDelegator();
		GenericValue delivery = null;
		try {
			delivery = delegator.findOne("Delivery", UtilMisc.toMap("deliveryId", deliveryId), false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
			ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryError", locale));
		}
		delivery.put("statusId", statusId);
		try {
			delivery.store();
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
			ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryError", locale));
		}
		
		/*//Update Delivery Item
		switch (DeliveryStatus.valueOf(statusId)) {
		case DLV_APPROVED:
			try {
				List<GenericValue> listDelivertItems = delegator.findList("DeliveryItem", EntityCondition.makeCondition("deliveryId", deliveryId), null, null, null, false);
				for(GenericValue item: listDelivertItems){
					item.put("statusId", "DELI_ITEM_APPROVED");
					item.store();
				}
			} catch (GenericEntityException e) {
				Debug.log(e.getStackTrace().toString(), module);
				ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryError", locale));
			}
			
			break;
		case DLV_CANCELED:
			try {
				List<GenericValue> listDelivertItems = delegator.findList("DeliveryItem", EntityCondition.makeCondition("deliveryId", deliveryId), null, null, null, false);
				for(GenericValue item: listDelivertItems){
					item.put("statusId", "DELI_ITEM_CANCELED");
					item.store();
				}
			} catch (GenericEntityException e) {
				Debug.log(e.getStackTrace().toString(), module);
				ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "updateDeliveryError", locale));
			}
			
			break;
		default:
			break;
		}*/
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(ApprUiLabels, "updateDeliverySuccessfully", locale));
	}
	
	public static Map<String,Object> getDeliveryById(DispatchContext ctx, Map<String, Object> context){
		
		//Get parameters
		String deliveryId = (String)context.get("deliveryId");
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		GenericValue delivery = null;
		try {
			delivery = delegator.findOne("Delivery", UtilMisc.toMap("deliveryId", deliveryId), false);
		} catch (GenericEntityException e) {
			Debug.log(e.getStackTrace().toString(), module);
		}
		
		Map<String, Object> result = ServiceUtil.returnSuccess(UtilProperties.getMessage(ApprUiLabels, "updateDeliverySuccessfully", locale));
		result.put("deliveryId", delivery.get("deliveryId"));
		result.put("statusId", delivery.get("statusId"));
		result.put("orderId", delivery.get("orderId"));
		result.put("transferId", delivery.get("transferId"));
		result.put("originFacilityId", delivery.get("originFacilityId"));
		result.put("destFacilityId", delivery.get("destFacilityId"));
		result.put("originProductStoreId", delivery.get("originProductStoreId"));
		result.put("createDate", delivery.get("createDate"));
		result.put("partyIdTo", delivery.get("partyIdTo"));
		result.put("destContactMechId", delivery.get("destContactMechId"));
		result.put("partyIdFrom", delivery.get("partyIdFrom"));
		result.put("deliveryDate", delivery.get("deliveryDate"));
		result.put("originContactMechId", delivery.get("originContactMechId"));
		result.put("deliveryDate", delivery.get("deliveryDate"));
		result.put("no", delivery.get("no"));
		return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getDeliveryEntryPackages(DispatchContext ctx, Map<String, ? extends Object> context){
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	List<GenericValue> listPackages = new ArrayList<GenericValue>();
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String deliveryEntryId = (String)parameters.get("deliveryEntryId")[0];
    	if (deliveryEntryId != null && !"".equals(deliveryEntryId)){
    		mapCondition.put("deliveryEntryId", deliveryEntryId);
    	}
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	try {
    		listPackages = delegator.findList("DeliveryEntryPackage", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		if(!UtilValidate.isEmpty(listPackages)){
    			for(GenericValue packageItem : listPackages){
    				Map<String, Object> row = new HashMap<String, Object>();
    				String deliveryEntryIdTmp = (String)packageItem.get("deliveryEntryId");
    				String deliveryPackageSeqId = (String)packageItem.get("deliveryPackageSeqId");
    				String deliveryBoxTypeId = (String)packageItem.get("deliveryBoxTypeId");
    				BigDecimal weight = packageItem.getBigDecimal("weight");
    				String weightUomId = (String)packageItem.get("weightUomId");
    				row.put("deliveryEntryId", deliveryEntryIdTmp);
    				row.put("deliveryPackageSeqId", deliveryPackageSeqId);
    				row.put("deliveryBoxTypeId", deliveryBoxTypeId);
    				row.put("weight", weight);
    				row.put("weightUomId", weightUomId);
    				
    				List<GenericValue> listPackageContent = delegator.findList("DeliveryEntryPackageContentDetail", EntityCondition.makeCondition(UtilMisc.toMap("deliveryEntryId", deliveryEntryId, "deliveryPackageSeqId", deliveryPackageSeqId)), null, null, null, false);
    				List<Map<String, Object>> rowDetail = new ArrayList<Map<String,Object>>();
    				if(!UtilValidate.isEmpty(listPackageContent)){
    					for(GenericValue productItem : listPackageContent){
    						Map<String, Object> childDetail = new HashMap<String, Object>(); 
    						childDetail.put("deliveryEntryId", deliveryEntryIdTmp);
    						childDetail.put("deliveryPackageSeqId", deliveryPackageSeqId);
    						childDetail.put("shipmentId", productItem.getString("shipmentId"));
    						childDetail.put("shipmentItemSeqId", productItem.getString("shipmentItemSeqId"));
    						childDetail.put("productId", productItem.getString("productId"));
    						childDetail.put("productName", productItem.getString("productName"));
    						childDetail.put("quantity", productItem.get("quantity"));
    						childDetail.put("weight", productItem.get("weight"));
    						childDetail.put("weightUomId", (String)productItem.get("weightUomId"));
    						childDetail.put("quantityUomId", (String)productItem.get("quantityUomId"));
    						rowDetail.add(childDetail);
    					}
    				}
    				row.put("rowDetail", rowDetail);
    				listIterator.add(row);
    			}
    		}
    		
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getDeliveryEntryPackages service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getShipmentByDeliveryEntry(DispatchContext ctx, Map<String, ? extends Object> context){
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String deliveryEntryId = (String)parameters.get("deliveryEntryId")[0];
    	if (deliveryEntryId != null && !"".equals(deliveryEntryId)){
    		mapCondition.put("deliveryEntryId", deliveryEntryId);
    	}
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	List<GenericValue> listShipments = new ArrayList<GenericValue>();
    	try {
    		listShipments = delegator.findList("Shipment", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		if(!UtilValidate.isEmpty(listShipments)){
    			for(GenericValue shipment : listShipments){
    				Map<String, Object> row = new HashMap<String, Object>();
    				String deliveryEntryIdTmp = (String)shipment.get("deliveryEntryId");
    				String shipmentId = (String)shipment.get("shipmentId");
    				String defaultWeightUomId = (String)shipment.get("defaultWeightUomId");
    				row.put("deliveryEntryId", deliveryEntryIdTmp);
    				row.put("shipmentId", shipmentId);
    				row.put("shipmentTypeId", (String)shipment.get("shipmentTypeId"));
    				row.put("originFacilityId", (String)shipment.get("originFacilityId"));
    				row.put("destinationFacilityId", (String)shipment.get("destinationFacilityId"));
    				row.put("originContactMechId", (String)shipment.get("originContactMechId"));
    				row.put("destinationContactMechId", (String)shipment.get("destinationContactMechId"));
    				row.put("defaultWeightUomId", defaultWeightUomId);
    				row.put("currencyUomId", (String)shipment.get("currencyUomId"));
    				
    				List<GenericValue> listShipmentItems = delegator.findList("ShipmentItemDetail", EntityCondition.makeCondition(UtilMisc.toMap("shipmentId", shipmentId)), null, null, null, false);
    				List<Map<String, Object>> rowDetail = new ArrayList<Map<String,Object>>();
    				if(!UtilValidate.isEmpty(listShipmentItems)){
    					for(GenericValue item : listShipmentItems){
    						Map<String, Object> childDetail = new HashMap<String, Object>(); 
    						childDetail.put("deliveryEntryId", deliveryEntryIdTmp);
    						childDetail.put("shipmentId", item.getString("shipmentId"));
    						childDetail.put("shipmentItemSeqId", item.getString("shipmentItemSeqId"));
    						childDetail.put("productId", item.getString("productId"));
    						childDetail.put("productName", item.getString("productName"));
    						childDetail.put("quantity", item.get("quantity"));
    						childDetail.put("weight", item.get("weight"));
    						childDetail.put("weightUomId", (String)item.get("weightUomId"));
    						childDetail.put("quantityUomId", (String)item.get("quantityUomId"));
    						
    						List<GenericValue> listPackagedItems = delegator.findList("DeliveryEntryPackageContent", EntityCondition.makeCondition(UtilMisc.toMap("deliveryEntryId", deliveryEntryId, "shipmentId", shipmentId, "shipmentItemSeqId", item.getString("shipmentItemSeqId"))), null, null, null, false);
    						BigDecimal quantityPackaged = BigDecimal.ZERO;
    						if (!listPackagedItems.isEmpty()){
    							for (GenericValue itemPackaged : listPackagedItems){
    								quantityPackaged = quantityPackaged.add(itemPackaged.getBigDecimal("quantity"));
    							}
    						}
    						childDetail.put("quantityPackaged", quantityPackaged);
    						rowDetail.add(childDetail);
    					}
    				}
    				row.put("rowDetail", rowDetail);
    				listIterator.add(row);
    			}
    		}
    		
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getShipmentByDeliveryEntry service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> createDeliveryEntryPackage(DispatchContext ctx, Map<String, ? extends Object> context) {
		Map<String, Object> result = FastMap.newInstance();
		Delegator delegator = ctx.getDelegator();
		String deliveryEntryId = (String)context.get("deliveryEntryId");
		String deliveryBoxTypeId = (String)context.get("deliveryBoxTypeId");
		List<Map<String, String>> listShipmentItems = (List<Map<String, String>>)context.get("listShipmentItems");
		Locale locale = (Locale)context.get("locale");
		GenericValue deliveryEntry = null;
		try {
			deliveryEntry = delegator.findOne("DeliveryEntry", false, UtilMisc.toMap("deliveryEntryId", deliveryEntryId));
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		if (deliveryEntry == null) {
			return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "DeliveryEntryNotFound", locale));
		}
		if (listShipmentItems.isEmpty()){
			return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "NoShipmentItemFound", locale));
		}
		List<String> listShipmentIds = new ArrayList<String>();
		for (Map<String, String> item : listShipmentItems){
			if (!listShipmentIds.contains(item.get("shipmentId")) && item.get("shipmentId") != null){
				listShipmentIds.add(item.get("shipmentId"));
			}
		}
		String deliveryWeightUomId = deliveryEntry.getString("weightUomId");
		if (deliveryWeightUomId == null) {
			return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "DeliveryEntryWeightUomNotFound", locale));
		}
		BigDecimal boxWeight = BigDecimal.ZERO;
		String boxWeightUomId = null;
		GenericValue boxType = null;
		try {
			boxType = delegator.findOne("DeliveryBoxType", false, UtilMisc.toMap("deliveryBoxTypeId", deliveryBoxTypeId));
		} catch (GenericEntityException e2) {
			e2.printStackTrace();
		}
		if (boxType == null){
			return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "BoxTypeNotFound", locale));
		} else {
			try {
				if (boxType.getBigDecimal("boxWeight") != null){
					boxWeight = boxType.getBigDecimal("boxWeight");
					boxWeightUomId  = boxType.getString("weightUomId");
					if (!deliveryWeightUomId.equals(boxWeightUomId)){
						GenericValue conversion = delegator.findOne("UomConversion", false, UtilMisc.toMap("uomId", boxWeightUomId, "uomIdTo", deliveryWeightUomId));
						boxWeight = boxWeight.multiply(conversion.getBigDecimal("conversionFactor"));
					}
				}
			} catch (GenericEntityException e) {
				e.printStackTrace();
			}
		}
		if (!listShipmentIds.isEmpty()){
			for (String shipmentId : listShipmentIds){
				GenericValue newPackage = delegator.makeValue("DeliveryEntryPackage");
				delegator.setNextSubSeqId(newPackage, "deliveryPackageSeqId", 5, 1);
				newPackage.put("deliveryEntryId", deliveryEntryId);
				newPackage.put("deliveryBoxTypeId", deliveryBoxTypeId);
				newPackage.put("weightUomId", deliveryWeightUomId);
				
				try {
					delegator.createOrStore(newPackage);
				} catch (GenericEntityException e) {
					e.printStackTrace();
				}
				try {
					newPackage.refresh();
				} catch (GenericEntityException e1) {
					e1.printStackTrace();
				}
				BigDecimal productWeight = BigDecimal.ZERO;
				String productWeightUomId = null;
				String deliveryPackageSeqId = newPackage.getString("deliveryPackageSeqId");
				try {
			    	for(Map<String, String> item: listShipmentItems){
			    		if (shipmentId.equals(item.get("shipmentId"))){
				    		BigDecimal quantityToPacking = new BigDecimal(item.get("quantity"));
				    		BigDecimal weight = new BigDecimal(item.get("weight"));
				    		productWeightUomId = item.get("weightUomId");
				    		if (!deliveryWeightUomId.equals(productWeightUomId)){
				    			GenericValue conversion = delegator.findOne("UomConversion", false, UtilMisc.toMap("uomId", productWeightUomId, "uomIdTo", deliveryWeightUomId));
					    		weight = weight.multiply(conversion.getBigDecimal("conversionFactor"));
				    		}
							productWeight = productWeight.add(quantityToPacking.multiply(weight));
							if (quantityToPacking.compareTo(BigDecimal.ZERO) == 1){
				    			GenericValue newPackageItem = delegator.makeValue("DeliveryEntryPackageContent");
				    			newPackageItem.put("deliveryEntryId", deliveryEntryId);
				    			newPackageItem.put("deliveryPackageSeqId", deliveryPackageSeqId);
				    			newPackageItem.put("shipmentId", item.get("shipmentId"));
				    			newPackageItem.put("shipmentItemSeqId", item.get("shipmentItemSeqId"));
				    			newPackageItem.put("quantity", quantityToPacking);
								delegator.createOrStore(newPackageItem);
				    		}
			    		}
			    	}
				} catch (GenericEntityException e) {
					e.printStackTrace();
				}
		    	newPackage.put("weight", boxWeight.add(productWeight));
		    	try {
					delegator.store(newPackage);
				} catch (GenericEntityException e) {
					e.printStackTrace();
				}
			}
		}
    	return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getShipmentItemByDeliveryEntry(DispatchContext ctx, Map<String, ? extends Object> context){
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String deliveryEntryId = (String)parameters.get("deliveryEntryId")[0];
    	if (deliveryEntryId != null && !"".equals(deliveryEntryId)){
    		mapCondition.put("deliveryEntryId", deliveryEntryId);
    	}
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	List<GenericValue> listShipments = new ArrayList<GenericValue>();
    	try {
    		listShipments = delegator.findList("Shipment", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		if(!UtilValidate.isEmpty(listShipments)){
    			for(GenericValue shipment : listShipments){
    				List<GenericValue> listShipmentItems = delegator.findList("ShipmentItemDetail", EntityCondition.makeCondition(UtilMisc.toMap("shipmentId", shipment.get("shipmentId"))), null, null, null, false);
    				if(!UtilValidate.isEmpty(listShipmentItems)){
    					for(GenericValue item : listShipmentItems){
    						Map<String, Object> row = new HashMap<String, Object>();
    						row.put("deliveryEntryId", deliveryEntryId);
    						row.put("shipmentId", item.getString("shipmentId"));
    						row.put("shipmentItemSeqId", item.getString("shipmentItemSeqId"));
    						row.put("productId", item.getString("productId"));
    						row.put("productName", item.getString("productName"));
    						row.put("quantity", item.get("quantity"));
    						row.put("weight", item.get("weight"));
    						row.put("weightUomId", (String)item.get("weightUomId"));
    						row.put("quantityUomId", (String)item.get("quantityUomId"));
    						
    						List<GenericValue> listItemHadInVehicles = delegator.findList("DeliveryEntryVehicleItem", EntityCondition.makeCondition(UtilMisc.toMap("deliveryEntryId", deliveryEntryId, "shipmentId",  shipment.get("shipmentId"), "shipmentItemSeqId", item.getString("shipmentItemSeqId"))), null, null, null, false);
    						BigDecimal quantityTmp = BigDecimal.ZERO;
    						if (!listItemHadInVehicles.isEmpty()){
    							for (GenericValue itemTmp : listItemHadInVehicles){
    								quantityTmp = quantityTmp.add(itemTmp.getBigDecimal("quantity"));
    							}
    						}
    						row.put("quantityFree", item.getBigDecimal("quantity").subtract(quantityTmp));
    						listIterator.add(row);
    					}
    				}
    			}
    		}
    		
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getShipmentByDeliveryEntry service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> createDeliveryEntryVehicle(DispatchContext ctx, Map<String, ? extends Object> context) {
		Map<String, Object> result = FastMap.newInstance();
		Delegator delegator = ctx.getDelegator();
		String deliveryEntryId = (String)context.get("deliveryEntryId");
		String statusId = (String)context.get("statusId");
		String deliveryManId = (String)context.get("deliveryManId");
		String driverId = (String)context.get("driverId");
		String vehicleId = (String)context.get("vehicleId");
		List<Map<String, String>> listShipmentItems = (List<Map<String, String>>)context.get("listShipmentItems");
		Locale locale = (Locale)context.get("locale");
		GenericValue deliveryEntry = null;
		try {
			deliveryEntry = delegator.findOne("DeliveryEntry", false, UtilMisc.toMap("deliveryEntryId", deliveryEntryId));
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		if (deliveryEntry == null) {
			return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "DeliveryEntryNotFound", locale));
		}
		if (listShipmentItems.isEmpty()){
			return ServiceUtil.returnError(UtilProperties.getMessage(ApprUiLabels, "NoShipmentItemFound", locale));
		}
		String deliveryWeightUomId = deliveryEntry.getString("weightUomId");
		GenericValue deVehicle = delegator.makeValue("DeliveryEntryVehicle");
		deVehicle.put("deliveryEntryId", deliveryEntryId);
		deVehicle.put("vehicleId", vehicleId);
		deVehicle.put("statusId", statusId);
		deVehicle.put("fromDate", UtilDateTime.nowTimestamp());
		try {
			delegator.create(deVehicle);
			
			GenericValue deVehicleRoleDeMan = delegator.makeValue("DeliveryEntryVehicleRole");
			deVehicleRoleDeMan.put("deliveryEntryId", deliveryEntryId);
			deVehicleRoleDeMan.put("vehicleId", vehicleId);
			deVehicleRoleDeMan.put("partyId", deliveryManId);
			deVehicleRoleDeMan.put("roleTypeId", "DELIVERY_MAN");
			delegator.create(deVehicleRoleDeMan);
			
			GenericValue deVehicleRoleDriver = delegator.makeValue("DeliveryEntryVehicleRole");
			deVehicleRoleDriver.put("deliveryEntryId", deliveryEntryId);
			deVehicleRoleDriver.put("vehicleId", vehicleId);
			deVehicleRoleDriver.put("partyId", driverId);
			deVehicleRoleDriver.put("roleTypeId", "DRIVER");
			delegator.create(deVehicleRoleDriver);
			
			BigDecimal weight = BigDecimal.ZERO;
			for (Map<String, String> item : listShipmentItems){
				GenericValue vehicleItem = delegator.makeValue("DeliveryEntryVehicleItem");
				vehicleItem.put("deliveryEntryId", deliveryEntryId);
				vehicleItem.put("vehicleId", vehicleId);
				vehicleItem.put("shipmentId", item.get("shipmentId"));
				vehicleItem.put("shipmentItemSeqId", item.get("shipmentItemSeqId"));
				vehicleItem.put("quantity", new BigDecimal(item.get("quantity")));
				BigDecimal quantityItem = new BigDecimal(item.get("quantity"));
				delegator.create(vehicleItem);
				String productWeightUomId = item.get("weightUomId");
				BigDecimal weightItem = new BigDecimal(item.get("weight"));
				if (!deliveryWeightUomId.equals(productWeightUomId)){
	    			GenericValue conversion = delegator.findOne("UomConversion", false, UtilMisc.toMap("uomId", productWeightUomId, "uomIdTo", deliveryWeightUomId));
	    			weightItem = weightItem.multiply(conversion.getBigDecimal("conversionFactor"));
	    		}
				weight = weight.add(weightItem.multiply(quantityItem));
			}
			deVehicle.put("weight", weight);
			deVehicle.store();
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		return result;
	}
}
