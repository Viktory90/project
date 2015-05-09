package com.olbius.delys.logistics.transfer;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormatter;
import org.joda.time.format.ISODateTimeFormat;
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
import org.ofbiz.security.Security;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.olbius.delys.services.DelysServices;
import com.olbius.delys.util.MultiOrganizationUtil;
import com.olbius.delys.util.SecurityUtil;

import javolution.util.FastMap;

public class TransferServices {
	
	public static final String module = TransferServices.class.getName();
	public static final String resource = "DelysUiLabels";
	public static final String resourceError = "DelysErrorUiLabels";

	public static Map<String, Object> createTransfer(DispatchContext ctx, Map<String, ? extends Object> context) {
		Map<String, Object> result = FastMap.newInstance();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		Security sec = ctx.getSecurity();
		String statusId = null;
		String itemStatusId = null;
		if(sec.hasPermission("TRANSFER_ADMIN", userLogin)){
			statusId = "TRANSFER_APPROVED";
			itemStatusId = "TRANS_ITEM_APPROVED";
		} else {
			if (sec.hasPermission("TRANSFER_CREATE", userLogin)){
				statusId = "TRANSFER_CREATED";
				itemStatusId = "TRANS_ITEM_CREATED";
			}
		}
		String originFacilityId = (String)context.get("originFacilityId");
		String destFacilityId = (String)context.get("destFacilityId");
		String transferTypeId = (String)context.get("transferTypeId");
		Timestamp shipBeforeDate = (Timestamp)context.get("shipBeforeDate");
		Timestamp shipAfterDate = (Timestamp)context.get("shipAfterDate");
		String description = (String)context.get("description");
		// create transfer header
		GenericValue transfer = delegator.makeValue("TransferHeader");
		String transferId = delegator.getNextSeqId("TransferHeader");
		transfer.put("transferId", transferId);
		transfer.put("originFacilityId", originFacilityId);
		transfer.put("destFacilityId", destFacilityId);
		transfer.put("transferTypeId", transferTypeId);
		transfer.put("createDate", UtilDateTime.nowTimestamp());
		transfer.put("statusId", statusId);
		transfer.put("description", description);
		try {
			delegator.create(transfer);
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		// create transfer items
		@SuppressWarnings("unchecked")
		List<Map<String, String>> listProducts = (List<Map<String, String>>)context.get("listProducts");
    	for(Map<String, String> item: listProducts){
    		String productId = item.get("productId");
    		String quantity = item.get("quantity");
    		String quantityUomId = item.get("quantityUomId");
    		String transferItemTypeId = item.get("transferItemTypeId");
    		String expDateTmp = item.get("expireDate");
    		Timestamp expireDate = null;
    		Timestamp itemShipBeforeDate = null;
    		Timestamp itemShipAfterDate = null;
    		if (expDateTmp != null && !"".equals(expDateTmp) && !"null".equals(expDateTmp)){
    			expireDate = new Timestamp(Long.valueOf(expDateTmp));
    		}
    		String itemShipBeforeDateTmp = item.get("itemShipBeforeDate");
    		if (itemShipBeforeDateTmp != null && !"".equals(itemShipBeforeDateTmp) && !"null".equals(itemShipBeforeDateTmp)){
		        itemShipBeforeDate = new Timestamp(Long.valueOf(itemShipBeforeDateTmp));
    		}
    		String itemShipAfterDateTmp = item.get("itemShipAfterDate");
    		if (itemShipAfterDateTmp != null && !"".equals(itemShipAfterDateTmp) && !"null".equals(itemShipAfterDateTmp)){
		        itemShipAfterDate = new Timestamp(Long.valueOf(itemShipAfterDateTmp));
    		}
    		GenericValue transferItem = delegator.makeValue("TransferItem");
    		transferItem.put("transferId", transferId);
    		delegator.setNextSubSeqId(transferItem, "transferItemSeqId", 5, 1);
    		transferItem.put("transferItemTypeId", transferItemTypeId);
    		transferItem.put("productId", productId);
    		transferItem.put("quantity", new BigDecimal(quantity));
    		transferItem.put("cancelQuantity", BigDecimal.ZERO);
    		transferItem.put("quantityUomId", quantityUomId);
    		transferItem.put("expireDate", expireDate);
    		if (itemShipBeforeDate != null){
    			transferItem.put("shipBeforeDate", itemShipBeforeDate);
    		} else {
    			transferItem.put("shipBeforeDate", shipBeforeDate);
    		}
    		if (itemShipAfterDate != null){
    			transferItem.put("shipAfterDate", itemShipAfterDate);
    		} else {
    			transferItem.put("shipAfterDate", shipAfterDate);
    		}
    		transferItem.put("statusId", itemStatusId);
    		try {
				delegator.create(transferItem);
			} catch (GenericEntityException e) {
				e.printStackTrace();
			}
    	}
		// create transfer item ship group
    	// create one group for all transfer item, can split to many group for one transfer (when extend function)
    	String originContactMechId = (String)context.get("originContactMechId");
		String destContactMechId = (String)context.get("destContactMechId");
		String shipmentMethodTypeId = (String)context.get("shipmentMethodTypeId");
		String carrierPartyId = (String)context.get("carrierPartyId");
 		GenericValue transferItemShipGroup = delegator.makeValue("TransferItemShipGroup");
		transferItemShipGroup.put("transferId", transferId);
		delegator.setNextSubSeqId(transferItemShipGroup, "shipGroupSeqId", 5, 1);
		transferItemShipGroup.put("originFacilityId", originFacilityId);
		transferItemShipGroup.put("destFacilityId", destFacilityId);
		transferItemShipGroup.put("originContactMechId", originContactMechId);
		transferItemShipGroup.put("destContactMechId", destContactMechId);
		transferItemShipGroup.put("shipmentMethodTypeId", shipmentMethodTypeId);
		transferItemShipGroup.put("carrierPartyId", carrierPartyId);
		transferItemShipGroup.put("carrierRoleTypeId", "CARRIER");
		transferItemShipGroup.put("shipAfterDate", shipAfterDate);
		transferItemShipGroup.put("shipBeforeDate", shipBeforeDate);
		try {
			delegator.create(transferItemShipGroup);
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		
		String shipGroupSeqId = (String)transferItemShipGroup.get("shipGroupSeqId");
		
		// create transfer item ship group assoc (current all item in one shipgroup)
		List<GenericValue> listTransferItems = new ArrayList<GenericValue>();
		try {
			listTransferItems = delegator.findList("TransferItem", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
			if (!listTransferItems.isEmpty()){
				for (GenericValue item : listTransferItems){
					GenericValue assoc = delegator.makeValue("TransferItemShipGroupAssoc");
					assoc.put("transferId", transferId);
					assoc.put("shipGroupSeqId", shipGroupSeqId);
					assoc.put("transferItemSeqId", (String)item.get("transferItemSeqId"));
					assoc.put("quantity", item.getBigDecimal("quantity"));
					assoc.put("cancelQuantity", item.getBigDecimal("cancelQuantity"));
					delegator.create(assoc);
				}
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		
		// create transfer item ship group inventory item reserved
		if ("TRANSFER_APPROVED".equals(statusId)){
			try {
				List<GenericValue> listTransItemShipGrpAssoc = delegator.findList("TransferItemShipGroupAssoc", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
				if (!listTransItemShipGrpAssoc.isEmpty()){
					for (GenericValue assoc : listTransItemShipGrpAssoc){
						Map<String, Object> mapInv = FastMap.newInstance();
						GenericValue transferItem = delegator.findOne("TransferItem", false, UtilMisc.toMap("transferId", transferId, "transferItemSeqId", (String)assoc.get("transferItemSeqId")));
						if (transferItem != null){
							String productId = (String)transferItem.get("productId");
							mapInv.put("productId", productId);
							mapInv.put("facilityId", originFacilityId);
							mapInv.put("inventoryItemTypeId", "NON_SERIAL_INV_ITEM");
							mapInv.put("userLogin", userLogin);
							mapInv.put("expireDate", transferItem.get("expireDate"));
							Map<String, Object> mapInvResult = FastMap.newInstance();
							String inventoryItemId = null;
							GenericValue product = delegator.findOne("Product", false, UtilMisc.toMap("productId", productId));
							if (product == null){
								return ServiceUtil.returnError("Product not found for TransferItem:" + transferId + "transferItemSeqId:" + transferItem.getString("transferItemSeqId"));
							}
							String baseUomId = product.getString("quantityUomId");
							if (baseUomId == null){
								return ServiceUtil.returnError("QuantityUomId not found for Product:" + productId);
							}
							String quantityUomId = transferItem.getString("quantityUomId");
							BigDecimal invQuantity = assoc.getBigDecimal("quantity");
							BigDecimal cancelQuantity = assoc.getBigDecimal("cancelQuantity");
							if (!baseUomId.equals(quantityUomId)){
								BigDecimal convert = BigDecimal.ONE;
								convert = DelysServices.getConvertNumber(delegator, convert, productId, quantityUomId, baseUomId);
								if (convert.compareTo(BigDecimal.ONE) == 1) {
									invQuantity = invQuantity.multiply(convert);
									cancelQuantity = cancelQuantity.multiply(convert);
								}
							}
							try {
								mapInvResult = dispatcher.runSync("createInventoryItem", mapInv);
								inventoryItemId = (String)mapInvResult.get("inventoryItemId");
								mapInv = FastMap.newInstance();
								mapInv.put("inventoryItemId", inventoryItemId);
								mapInv.put("availableToPromiseTotal", invQuantity.negate());
								mapInv.put("quantityOnHandTotal", BigDecimal.ZERO);
								mapInv.put("userLogin", userLogin);
								dispatcher.runSync("createInventoryItemCheckSetAtpQoh", mapInv);
							} catch (GenericServiceException e) {
								e.printStackTrace();
							}
					        
					        if (inventoryItemId != null){
					        	GenericValue reservedItem = delegator.makeValue("TransferItemShipGrpInvRes");
					        	reservedItem.put("transferId", transferId);
					        	reservedItem.put("shipGroupSeqId", (String)assoc.get("shipGroupSeqId"));
					        	reservedItem.put("transferItemSeqId", (String)assoc.get("transferItemSeqId"));
					        	reservedItem.put("inventoryItemId", inventoryItemId);
					        	reservedItem.put("quantity", invQuantity);
					        	reservedItem.put("quantityNotAvailable", cancelQuantity);
					        	reservedItem.put("reservedDatetime", UtilDateTime.nowTimestamp());
					        	reservedItem.put("createdDatetime", UtilDateTime.nowTimestamp());
					        	delegator.create(reservedItem);
					        }
						}
					}
				}
			} catch (GenericEntityException e) {
				e.printStackTrace();
			}
		}	
		result.put("transferId", transferId);
		return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getListTransfer(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
		Security security = ctx.getSecurity();
		List<GenericValue> listTransfers = new ArrayList<GenericValue>();
		List<EntityCondition> listFacilityCond = new ArrayList<EntityCondition>();
        if (!security.hasPermission("LOGISTICS_ADMIN", userLogin)) {
        	if (!security.hasPermission("LOGISTICS_VIEW", userLogin)) {
        		if (!security.hasPermission("FACILITY_ADMIN", userLogin)) {
        			if (!security.hasPermission("FACILITY_VIEW", userLogin)) {
        				if (security.hasPermission("FACILITY_ROLE_VIEW", userLogin)) {
        					listFacilityCond.add(EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")));
            	    		List<EntityCondition> tmpListCond = new ArrayList<EntityCondition>();
            	    		tmpListCond.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "MANAGER"));
            	    		tmpListCond.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "LOG_STOREKEEPER"));
            	    		listFacilityCond.add(EntityCondition.makeCondition(tmpListCond,EntityJoinOperator.OR));
	        			} else {
	        				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "NotHasPermission", (Locale)context.get("locale")));
	        			}
        			}
        		}
        	}
        }
        
    	try {
    		List<GenericValue> listFacilities = delegator.findList("FacilityPartyFacility", EntityCondition.makeCondition(listFacilityCond), null, null, null, false);
    		
    		listTransfers = delegator.findList("TransferHeader", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		List<GenericValue> listTmps = new ArrayList<GenericValue>();
    		List<String> listFacilityIds = new ArrayList<String>();
    		for (GenericValue fac : listFacilities){
				String facilityId = (String)fac.get("facilityId");
				listFacilityIds.add(facilityId);
    		}
    		if (!listTransfers.isEmpty() && !listFacilities.isEmpty()){
    			for (GenericValue transfer : listTransfers){
    				String originFacilityId = (String)transfer.get("originFacilityId");
    				String destFacilityId = (String)transfer.get("destFacilityId");
    				if (!listFacilityIds.contains(originFacilityId) && !listFacilityIds.contains(destFacilityId)){
    					listTmps.add(transfer);
    				} 
    			}
    		}
    		if (!listTmps.isEmpty()){
    			listTransfers.removeAll(listTmps);
    		}
    	} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListTransfer service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listTransfers);
    	return successResult;
	}
	public static Map<String, Object> getFacilityByTransferType(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> result = ServiceUtil.returnSuccess();
		String transferTypeId = (String)context.get("transferTypeId");
		List<GenericValue> listOriginFacilities = new ArrayList<GenericValue>();
		List<GenericValue> listDestFacilities = new ArrayList<GenericValue>();
		List<GenericValue> listOriginContactMechs = new ArrayList<GenericValue>();
		List<GenericValue> listDestContactMechs = new ArrayList<GenericValue>();
		if (transferTypeId != null){
			List<GenericValue> listOriginFacilitiesTmp = new ArrayList<GenericValue>();
			List<GenericValue> listDestFacilitiesTmp = new ArrayList<GenericValue>();
			String geoId = null;
			String geoTypeId = null;
			String company = MultiOrganizationUtil.getCurrentOrganization(delegator);
			try {
				if ("TRANS_INTERNAL".equals(transferTypeId)){
					geoId = "VN-HN";
					listOriginFacilitiesTmp = delegator.findList("FacilityAndGeo", EntityCondition.makeCondition(UtilMisc.toMap("ownerPartyId", company, "geoId", geoId)), null, null, null, false);
					listDestFacilitiesTmp = delegator.findList("FacilityAndGeo", EntityCondition.makeCondition(UtilMisc.toMap("ownerPartyId", company, "geoId", geoId)), null, null, null, false);
				}
				if ("TRANS_DISTRIBUTOR".equals(transferTypeId)){
					listOriginFacilitiesTmp = delegator.findList("FacilityAndGeo", EntityCondition.makeCondition(UtilMisc.toMap("ownerPartyId", company)), null, null, null, false);			
					listDestFacilitiesTmp = delegator.findList("FacilityPartyOwnerRole", EntityCondition.makeCondition(UtilMisc.toMap("roleTypeId", "DELYS_DISTRIBUTOR")), null, null, null, false);
				}
				if ("TRANS_INTERMEDIARY".equals(transferTypeId)){
					geoTypeId = "PROVINCE";
					listOriginFacilitiesTmp = delegator.findList("FacilityAndGeo", EntityCondition.makeCondition(UtilMisc.toMap("ownerPartyId", company, "geoTypeId", geoTypeId)), null, null, null, false);
					listDestFacilitiesTmp = delegator.findList("FacilityAndGeo", EntityCondition.makeCondition(UtilMisc.toMap("ownerPartyId", company, "geoTypeId", geoTypeId)), null, null, null, false);
				}
				if ("TRANS_SALES_CHANNEL".equals(transferTypeId)){
					
				}
				if (!listDestFacilitiesTmp.isEmpty()){
					for (GenericValue fa : listDestFacilitiesTmp){
						GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", (String)fa.get("facilityId")));
						if (!listDestFacilities.contains(facility)){
							listDestFacilities.add(facility);
						}
					}
				}
				if (!listOriginFacilitiesTmp.isEmpty()){
					for (GenericValue fa : listOriginFacilitiesTmp){
						GenericValue facility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", (String)fa.get("facilityId")));
						if (!listOriginFacilities.contains(facility)){
							listOriginFacilities.add(facility);
						}
					}
				}
				if (!listDestFacilities.isEmpty()){
					GenericValue facility = listDestFacilities.get(0);
					listDestFacilities.remove(0);
					listDestFacilities.add(facility);
				}
			} catch (GenericEntityException e) {
				e.printStackTrace();
			}
		}
		
		if (!listDestFacilities.isEmpty()){
			try {
				List<GenericValue> listContactMechPurpose = delegator.findList("FacilityContactMechPurpose", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", listDestFacilities.get(0).get("facilityId"), "contactMechPurposeTypeId", "SHIPPING_LOCATION")), null, null, null, false);
				listContactMechPurpose = EntityUtil.filterByDate(listContactMechPurpose);
				if (!listContactMechPurpose.isEmpty()){
					for (GenericValue contact : listContactMechPurpose){
						List<GenericValue> listPostalAddress = delegator.findList("PostalAddress", EntityCondition.makeCondition(UtilMisc.toMap("contactMechId", contact.get("contactMechId"))), null, null, null, false);
						for (GenericValue pa : listPostalAddress){
							if (!listDestContactMechs.contains(pa)){
								listDestContactMechs.add(pa);
							}
						}
					}
				}
			} catch (GenericEntityException e) {
				Debug.logError(e, module);
				return ServiceUtil.returnError(e.getMessage());
			}
		}
		if (!listOriginFacilities.isEmpty()){
			try {
				List<GenericValue> listContactMechPurpose = delegator.findList("FacilityContactMechPurpose", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", listOriginFacilities.get(0).get("facilityId"), "contactMechPurposeTypeId", "SHIP_ORIG_LOCATION")), null, null, null, false);
				listContactMechPurpose = EntityUtil.filterByDate(listContactMechPurpose);
				if (!listContactMechPurpose.isEmpty()){
					for (GenericValue contact : listContactMechPurpose){
						List<GenericValue> listPostalAddress = delegator.findList("PostalAddress", EntityCondition.makeCondition(UtilMisc.toMap("contactMechId", contact.get("contactMechId"))), null, null, null, false);
						for (GenericValue pa : listPostalAddress){
							if (!listOriginContactMechs.contains(pa)){
								listOriginContactMechs.add(pa);
							}
						}
					}
				}
			} catch (GenericEntityException e) {
				Debug.logError(e, module);
				return ServiceUtil.returnError(e.getMessage());
			}
		}
		result.put("listDestFacilities", listDestFacilities);
		result.put("listOriginFacilities", listOriginFacilities);
		result.put("listOriginContactMechs", listOriginContactMechs);
		result.put("listDestContactMechs", listDestContactMechs);
		return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getListProducts(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String facilityId = (String)parameters.get("facilityId")[0];
    	if (facilityId != null && !"".equals(facilityId)){
    		mapCondition.put("facilityId", facilityId);
    	}
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	List<GenericValue> listProducts = new ArrayList<GenericValue>();
    	List<GenericValue> listTmps = new ArrayList<GenericValue>();
    	try {
    		listTmps = delegator.findList("GroupProductInventory", EntityCondition.makeCondition(listAllConditions), null, listSortFields, opts, false);
    		if (!listTmps.isEmpty()){
    			for (GenericValue pr : listTmps){
    				if ((pr.getBigDecimal("ATP") != null) && (pr.getBigDecimal("ATP").compareTo((BigDecimal.ZERO)) == 1)){
    					listProducts.add(pr);
    				}
    			}
    		}
    	} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListProducts service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listProducts);
    	return successResult;
    }
	
	public static Map<String, Object> createTransferRequirement(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException{
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String partyId = (String)userLogin.get("partyId");
		String requirementTypeId = (String)context.get("requirementTypeId");
		String facilityIdTo = (String)context.get("facilityIdTo");
		String facilityIdFrom = (String)context.get("facilityIdFrom");
		String productStoreIdFrom = (String)context.get("productStoreIdFrom");
		String destContactMechId = (String)context.get("destContactMechId");
		String originContactMechId = (String)context.get("originContactMechId");
		String productStoreIdTo = (String)context.get("productStoreIdTo");
		Timestamp requirementStartDate = (Timestamp)context.get("requirementStartDate");
		Timestamp requiredByDate = (Timestamp)context.get("requiredByDate");
		String currencyUomId = (String)context.get("currencyUomId");
		String budgetTmp = (String)context.get("estimatedBudget");
		BigDecimal estimatedBudget = BigDecimal.ZERO;
		if (budgetTmp != null && !"".equals(budgetTmp)){
			estimatedBudget = new BigDecimal(budgetTmp);
		}
		String description = (String)context.get("description");
		String reason = (String)context.get("reason");
		String requirementId = delegator.getNextSeqId("Requirement");
		
		GenericValue requirement = delegator.makeValue("Requirement");
		requirement.put("requirementId", requirementId);
		requirement.put("requirementTypeId", requirementTypeId);
		requirement.put("facilityId", facilityIdFrom);
		requirement.put("productStoreId", productStoreIdFrom);
		requirement.put("requirementStartDate", requirementStartDate);
		requirement.put("requiredByDate", requiredByDate);
		requirement.put("estimatedBudget", estimatedBudget);
		requirement.put("currencyUomId", currencyUomId);
		requirement.put("reason", reason);
		requirement.put("statusId", "REQ_CREATED");
		
		delegator.createOrStore(requirement);
		
		GenericValue requirementRole = delegator.makeValue("RequirementRole");
		requirementRole.put("requirementId", requirementId);
		requirementRole.put("partyId", partyId);
		requirementRole.put("roleTypeId", "OWNER");
		requirementRole.put("fromDate", UtilDateTime.nowTimestamp());
		
		delegator.create(requirementRole);
				
		@SuppressWarnings("unchecked")
		List<Map<String, String>> listProducts = (List<Map<String, String>>)context.get("listProducts");
    	for(Map<String, String> item: listProducts){
    		String productId = item.get("productId");
    		String quantity = item.get("quantity");
    		String quantityUomId = item.get("quantityUomId");
    		String expDateTmp = item.get("expireDate");
    		Timestamp expireDate = null;
    		if (expDateTmp != null && !"".equals(expDateTmp) && !"null".equals(expDateTmp)){
		        DateTimeFormatter parser = ISODateTimeFormat.dateTime();
		        DateTime dt = parser.parseDateTime(expDateTmp);
		        expireDate = new Timestamp(dt.getMillis());
    		}
    		String statusId = "REQ_ITEM_CREATED";
    		Map<String, Object> mapTmp = FastMap.newInstance();
    		try {
    			mapTmp.put("requirementId", requirementId);
    			mapTmp.put("requirementTypeId", requirementTypeId);
    			mapTmp.put("productId", productId);
    			mapTmp.put("quantity", quantity);
    			mapTmp.put("quantityUomId", quantityUomId);
    			mapTmp.put("currencyUomId", currencyUomId);
    			mapTmp.put("expireDate", expireDate);
    			mapTmp.put("statusId", statusId);
    			mapTmp.put("userLogin", userLogin);
				dispatcher.runSync("addProductToRequirement", mapTmp);
			} catch (GenericServiceException e) {
				e.printStackTrace();
			}
    	}
		
		GenericValue reqFacility = delegator.makeValue("RequirementFacility");
		reqFacility.put("requirementId", requirementId);
		reqFacility.put("productStoreIdFrom", productStoreIdFrom);
		reqFacility.put("facilityIdFrom", facilityIdFrom);
		reqFacility.put("originContactMechId", originContactMechId);
		reqFacility.put("productStoreIdTo", productStoreIdTo);
		reqFacility.put("facilityIdTo", facilityIdTo);
		reqFacility.put("destContactMechId", destContactMechId);
		reqFacility.put("description", description);
		delegator.createOrStore(reqFacility);
		
		result.put("requirementId", requirementId);
		return result;
	}
	public static Map<String, Object> sendTransferRequirement(DispatchContext ctx, Map<String, Object> context){
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		String requirementId = (String)context.get("requirementId");
		String partyIdTo = (String)context.get("partyIdTo");
		String sendMessage = (String)context.get("sendMessage");
		String action = (String)context.get("action");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		try {
			GenericValue requirement = delegator.findOne("Requirement", false, UtilMisc.toMap("requirementId", requirementId));
			if (requirement != null){
				requirement.put("statusId", "REQ_PROPOSED");
				delegator.createOrStore(requirement);
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		try {
			try {
				List<GenericValue> listLogSpecialist = delegator.findList("PartyRelationship", EntityCondition.makeCondition(UtilMisc.toMap("partyIdTo", partyIdTo, "roleTypeIdTo", "INTERNAL_ORGANIZATIO", "roleTypeIdFrom", "MANAGER")), null, null, null, false);
				if(!listLogSpecialist.isEmpty()){
					for (GenericValue managerParty : listLogSpecialist){
						String tagetLink = "requirementId="+requirementId;
						String sendToPartyId = (String)managerParty.get("partyIdFrom");
						Map<String, Object> mapContext = new HashMap<String, Object>();
						mapContext.put("partyId", sendToPartyId);
						mapContext.put("action", action);
						mapContext.put("targetLink", tagetLink);
						mapContext.put("header", sendMessage);
						mapContext.put("userLogin", userLogin);
						dispatcher.runSync("createNotification", mapContext);
					}
				}
			} catch (GenericEntityException e) {
				e.printStackTrace();
			}
		} catch (GenericServiceException e) {
			e.printStackTrace();
		}
		result.put("requirementId", requirementId);
		return result;
	}
	public static Map<String, Object> approveTransferRequirement(DispatchContext ctx, Map<String, Object> context){
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
//		LocalDispatcher dispatcher = ctx.getDispatcher();
		String requirementId = (String)context.get("requirementId");
//		String partyIdTo = (String)context.get("partyIdTo");
//		String sendMessage = (String)context.get("sendMessage");
//		String action = (String)context.get("action");
//		GenericValue userLogin = (GenericValue)context.get("userLogin");
		try {
			GenericValue requirement = delegator.findOne("Requirement", false, UtilMisc.toMap("requirementId", requirementId));
			if (requirement != null){
				requirement.put("statusId", "REQ_APPROVED");
				delegator.createOrStore(requirement);
			}
			List<GenericValue> listReqItems = delegator.findList("RequirementItem", EntityCondition.makeCondition(UtilMisc.toMap("requirementId", requirementId)), null, null, null, false);
			if (!listReqItems.isEmpty()){
				for (GenericValue item : listReqItems){
					item.put("statusId", "REQ_ITEM_APPROVED");
					delegator.store(item);
				}
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
//		try {
//			try {
//				List<GenericValue> listLogSpecialist = delegator.findList("PartyRelationship", EntityCondition.makeCondition(UtilMisc.toMap("partyIdTo", partyIdTo, "roleTypeIdTo", "INTERNAL_ORGANIZATIO", "roleTypeIdFrom", "MANAGER")), null, null, null, false);
//				if(!listLogSpecialist.isEmpty()){
//					for (GenericValue managerParty : listLogSpecialist){
//						String tagetLink = "requirementId="+requirementId;
//						String sendToPartyId = (String)managerParty.get("partyIdFrom");
//						Map<String, Object> mapContext = new HashMap<String, Object>();
//						mapContext.put("partyId", sendToPartyId);
//						mapContext.put("action", action);
//						mapContext.put("targetLink", tagetLink);
//						mapContext.put("header", sendMessage);
//						mapContext.put("userLogin", userLogin);
//						dispatcher.runSync("createNotification", mapContext);
//					}
//				}
//			} catch (GenericEntityException e) {
//				e.printStackTrace();
//			}
//		} catch (GenericServiceException e) {
//			e.printStackTrace();
//		}
		result.put("requirementId", requirementId);
		return result;
	}
	
	public static Map<String, Object> getRequirementRoles(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException{
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		String requirementId = (String)context.get("requirementId");
		String roleTypeId = (String)context.get("roleTypeId");
		List<GenericValue> listRequirementRoles = delegator.findList("RequirementRole", EntityCondition.makeCondition(UtilMisc.toMap("requirementId", requirementId, "roleTypeId", roleTypeId)), null, null, null, false);
		result.put("requirementId", requirementId);
		result.put("listRequirementRoles", listRequirementRoles);
		return result;
	}	
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getListRequirements(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		mapCondition.put("requirementTypeId", (String)parameters.get("requirementTypeId")[0]);
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
		Security security = ctx.getSecurity();
		List<GenericValue> listAllReqs = new ArrayList<GenericValue>();
		List<EntityCondition> listFacilityCond = new ArrayList<EntityCondition>();
        if (!security.hasPermission("LOGISTICS_ADMIN", userLogin)) {
        	if (!security.hasPermission("LOGISTICS_VIEW", userLogin)) {
        		if (!security.hasPermission("FACILITY_ADMIN", userLogin)) {
        			if (!security.hasPermission("FACILITY_VIEW", userLogin)) {
        				if (security.hasPermission("FACILITY_ROLE_VIEW", userLogin)) {
        					listFacilityCond.add(EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")));
            	    		List<EntityCondition> tmpListCond = new ArrayList<EntityCondition>();
            	    		tmpListCond.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "MANAGER"));
            	    		tmpListCond.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "LOG_STOREKEEPER"));
            	    		listFacilityCond.add(EntityCondition.makeCondition(tmpListCond,EntityJoinOperator.OR));
	        			} else {
	        				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "NotHasPermission", (Locale)context.get("locale")));
	        			}
        			}
        		}
        	}
        }
        
    	try {
    		List<GenericValue> listFacilities = delegator.findList("FacilityPartyFacility", EntityCondition.makeCondition(listFacilityCond), null, null, null, false);
    		
    		listAllReqs = delegator.findList("RequirementAndFacility", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		List<GenericValue> listTmps = new ArrayList<GenericValue>();
    		List<String> listFacilityIds = new ArrayList<String>();
    		for (GenericValue fac : listFacilities){
				String facilityId = (String)fac.get("facilityId");
				listFacilityIds.add(facilityId);
    		}
    		if (!listAllReqs.isEmpty() && !listFacilities.isEmpty()){
    			for (GenericValue req : listAllReqs){
    				String facilityIdFrom = (String)req.get("facilityIdFrom");
    				String facilityIdTo = (String)req.get("facilityIdTo");
    				if (!listFacilityIds.contains(facilityIdFrom) && !listFacilityIds.contains(facilityIdTo)){
    					listTmps.add(req);
    				} 
    			}
    		}
    		if (!listTmps.isEmpty()){
    			listAllReqs.removeAll(listTmps);
    		}
    	} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListRequirements service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listAllReqs);
    	return successResult;
    }
	
	public static Map<String, Object> getProductPackingUoms(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException{
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		String productId = (String)context.get("productId");

		List<GenericValue> listConfigPacking = delegator.findList("ConfigPacking", EntityCondition.makeCondition(UtilMisc.toMap("productId", productId)), null, null, null, false);
		List<GenericValue> listProductQuantityUom = new ArrayList<GenericValue>();
		if (!listConfigPacking.isEmpty()){
			for (GenericValue cf : listConfigPacking){
				GenericValue uom = delegator.findOne("Uom", false, UtilMisc.toMap("uomId", (String)cf.get("uomFromId")));
				if (!listProductQuantityUom.contains(uom) && "PRODUCT_PACKING".equals((String)uom.get("uomTypeId"))){
					listProductQuantityUom.add(uom);
				}
				uom = delegator.findOne("Uom", false, UtilMisc.toMap("uomId", (String)cf.get("uomToId")));
				if (!listProductQuantityUom.contains(uom) && "PRODUCT_PACKING".equals((String)uom.get("uomTypeId"))){
					listProductQuantityUom.add(uom);
				}
			}
		}
		result.put("listPackingUoms", listProductQuantityUom);
		return result;
	}
	
	public static Map<String, Object> approveTransfer(DispatchContext ctx, Map<String, Object> context){
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		String transferId = (String)context.get("transferId");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		try {
			GenericValue transfer = delegator.findOne("TransferHeader", false, UtilMisc.toMap("transferId", transferId));
			if (transfer != null){
				transfer.put("statusId", "TRANSFER_APPROVED");
				delegator.createOrStore(transfer);
			} else {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource,
	                    "TransferNotFound", (Locale)context.get("locale")));
			}
			List<GenericValue> listTransferItems = delegator.findList("TransferItem", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
			if (!listTransferItems.isEmpty()){
				for (GenericValue item : listTransferItems){
					item.put("statusId", "TRANS_ITEM_APPROVED");
					delegator.store(item);
				}
			}
			List<GenericValue> listTransItemShipGrpAssoc = delegator.findList("TransferItemShipGroupAssoc", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
			if (!listTransItemShipGrpAssoc.isEmpty()){
				for (GenericValue assoc : listTransItemShipGrpAssoc){
					Map<String, Object> mapInv = FastMap.newInstance();
					GenericValue transferItem = delegator.findOne("TransferItem", false, UtilMisc.toMap("transferId", transferId, "transferItemSeqId", (String)assoc.get("transferItemSeqId")));
					if (transferItem != null){
						mapInv.put("productId", (String)transferItem.get("productId"));
						mapInv.put("facilityId", (String)transfer.get("originFacilityId"));
						mapInv.put("inventoryItemTypeId", "NON_SERIAL_INV_ITEM");
						mapInv.put("userLogin", userLogin);
						mapInv.put("expireDate", transferItem.get("expireDate"));
						Map<String, Object> mapInvResult = FastMap.newInstance();
						String inventoryItemId = null;
						try {
							mapInvResult = dispatcher.runSync("createInventoryItem", mapInv);
							inventoryItemId = (String)mapInvResult.get("inventoryItemId");
							mapInv = FastMap.newInstance();
							mapInv.put("inventoryItemId", inventoryItemId);
							mapInv.put("availableToPromiseTotal", transferItem.getBigDecimal("quantity").negate());
							mapInv.put("quantityOnHandTotal", BigDecimal.ZERO);
							mapInv.put("userLogin", userLogin);
							dispatcher.runSync("createInventoryItemCheckSetAtpQoh", mapInv);
						} catch (GenericServiceException e) {
							e.printStackTrace();
						}
				        
				        if (inventoryItemId != null){
				        	GenericValue reservedItem = delegator.makeValue("TransferItemShipGrpInvRes");
				        	reservedItem.put("transferId", transferId);
				        	reservedItem.put("shipGroupSeqId", (String)assoc.get("shipGroupSeqId"));
				        	reservedItem.put("transferItemSeqId", (String)assoc.get("transferItemSeqId"));
				        	reservedItem.put("inventoryItemId", inventoryItemId);
				        	reservedItem.put("quantity", assoc.getBigDecimal("quantity"));
				        	reservedItem.put("quantityNotAvailable", assoc.getBigDecimal("cancelQuantity"));
				        	reservedItem.put("reservedDatetime", UtilDateTime.nowTimestamp());
				        	reservedItem.put("createdDatetime", UtilDateTime.nowTimestamp());
				        	delegator.create(reservedItem);
				        }
					}
				}
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		result.put("transferId", transferId);
		return result;
	}
	
	public static Map<String,Object> createDeliveryFromRequirement(DispatchContext ctx, Map<String,Object> context){
		Map<String,Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		String requirementId = (String)context.get("requirementId");
		String deliveryTypeId = (String)context.get("deliveryTypeId");
		String partyIdFrom = (String)context.get("partyIdFrom");
		String partyIdTo = (String)context.get("partyIdTo");
		String deliveryId = null;
		String sendMessage = (String)context.get("sendMessage");
		String action = (String)context.get("action");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		try {
			GenericValue requirement = delegator.findOne("Requirement", false, UtilMisc.toMap("requirementId", requirementId));
			GenericValue reqFacility = delegator.findOne("RequirementFacility", false, UtilMisc.toMap("requirementId", requirementId));
			List<GenericValue> listReqItems = delegator.findList("RequirementItem", EntityCondition.makeCondition(UtilMisc.toMap("requirementId", requirementId, "statusId", "REQ_ITEM_APPROVED")), null, null, null, false);
			if (requirement != null && reqFacility != null && !listReqItems.isEmpty()){
				GenericValue delivery = delegator.makeValue("Delivery");
				String facilityIdFrom = (String)reqFacility.get("facilityIdFrom");
				String facilityIdTo = (String)reqFacility.get("facilityIdTo");
				String productStoreIdFrom = (String)reqFacility.get("productStoreIdFrom");
				String productStoreIdTo = (String)reqFacility.get("productStoreIdTo");
				
				deliveryId = delegator.getNextSeqId("Delivery");
				delivery.put("deliveryId", deliveryId);
				delivery.put("requirementId", requirementId);
				delivery.put("deliveryTypeId", deliveryTypeId);
				delivery.put("partyIdFrom", partyIdFrom);
				delivery.put("partyIdTo", partyIdTo);
				delivery.put("createDate", UtilDateTime.nowTimestamp());
				delivery.put("deliveryDate", requirement.get("requirementStartDate"));
				delivery.put("originProductStoreId",productStoreIdFrom);
				delivery.put("destProductStoreId", productStoreIdTo);
				delivery.put("originFacilityId",facilityIdFrom);
				delivery.put("destFacilityId", facilityIdTo);
				delivery.put("originContactMechId", (String)reqFacility.get("originContactMechId"));
				delivery.put("destContactMechId", (String)reqFacility.get("destContactMechId"));
				delivery.put("statusId", "DLV_CREATED");
				delivery.put("deliveryReason", (String)requirement.get("reason"));
				
				delegator.create(delivery);
				for (GenericValue reqItem : listReqItems){
					GenericValue deliveryItem = delegator.makeValue("DeliveryItem");
					deliveryItem.put("deliveryId", deliveryId);
					delegator.setNextSubSeqId(deliveryItem, "deliveryItemSeqId", 5, 1);
					deliveryItem.put("fromRequirementId", requirementId);
					deliveryItem.put("fromReqItemSeqId", (String)reqItem.get("reqItemSeqId"));
					deliveryItem.put("quantity", reqItem.getBigDecimal("quantity"));
					deliveryItem.put("actualExportedQuantity", BigDecimal.ZERO);
					deliveryItem.put("actualDeliveredQuantity", BigDecimal.ZERO);
					delegator.create(deliveryItem);
				}
				requirement.put("statusId", "REQ_COMPLETED");
				delegator.store(requirement);
				
				try {
					List<GenericValue> listLogStorekeepers = delegator.findList("PartyRelationship", EntityCondition.makeCondition(UtilMisc.toMap("partyIdTo", "LOG_STOREKEEPER", "roleTypeIdTo", "INTERNAL_ORGANIZATIO", "roleTypeIdFrom", "MANAGER")), null, null, null, false);
					if(!listLogStorekeepers.isEmpty()){
						for (GenericValue managerParty : listLogStorekeepers){
							List<GenericValue> listStorekeeperByFacility = delegator.findList("FacilityParty", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", facilityIdFrom, "partyId", (String)managerParty.get("partyIdFrom"), "roleTypeId", "LOG_STOREKEEPER")), null, null, null, false);
							listStorekeeperByFacility = EntityUtil.filterByDate(listStorekeeperByFacility);
							if (!listStorekeeperByFacility.isEmpty()){
								String tagetLink = "deliveryId="+deliveryId;
								String sendToPartyId = (String)managerParty.get("partyIdFrom");
								Map<String, Object> mapContext = new HashMap<String, Object>();
								mapContext.put("partyId", sendToPartyId);
								mapContext.put("action", action);
								mapContext.put("targetLink", tagetLink);
								mapContext.put("header", sendMessage);
								mapContext.put("userLogin", userLogin);
								try {
									dispatcher.runSync("createNotification", mapContext);
								} catch (GenericServiceException e) {
									e.printStackTrace();
								}
							}
						}
					}
				} catch (GenericEntityException e) {
					e.printStackTrace();
				}
			} else {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "NotFoundRequirementOrNotProductItem", (Locale)context.get("locale")));
			}
			
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		result.put("deliveryId", deliveryId);
		result.put("requirementId", requirementId);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getListTransferDelivery(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String transferId = (String)parameters.get("transferId")[0];
    	if (transferId != null && !"".equals(transferId)){
    		mapCondition.put("transferId", transferId);
    	}
    	String statusId = (String)parameters.get("statusId")[0];
    	if (statusId != null && !"".equals(statusId)){
    		mapCondition.put("statusId", statusId);
    	}
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	List<GenericValue> listDeliveries = new ArrayList<GenericValue>();
    	try {
    		listDeliveries = delegator.findList("Delivery", EntityCondition.makeCondition(listAllConditions), null, listSortFields, opts, false);
    	} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListTransferDelivery service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listDeliveries);
    	return successResult;
	}
	
	@SuppressWarnings("unchecked")
   	public static Map<String, Object> getListTransferItemDelivery(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
       	List<String> listSortFields = (List<String>) context.get("listSortFields");
       	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
       	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
       	String transferId = parameters.get("transferId")[0];
       	
       	Map<String, String> mapCondition = new HashMap<String, String>();
       	mapCondition.put("transferId", transferId);
       	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
       	listAllConditions.add(tmpConditon);
       	
       	List<GenericValue> transferItems = new ArrayList<GenericValue>();
       	List<GenericValue> deliveryItems = new ArrayList<GenericValue>();
       	try {
       		transferItems = delegator.findList("TransferItem", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListTransferItemDelivery service: " + e.toString();
   			Debug.logError(e, errMsg, module);
		} 
       	List<GenericValue> listTransfered = new ArrayList<GenericValue>();
       	if (!transferItems.isEmpty()){
       		for(GenericValue item: transferItems){
       			try {
       				deliveryItems = delegator.findList("DeliveryItem", EntityCondition.makeCondition(UtilMisc.toMap("fromTransferId", transferId, "fromTransferItemSeqId", (String)item.get("transferItemSeqId"))), null, null, null, false);
       				if (!deliveryItems.isEmpty()){
       					BigDecimal totalTransferQty = BigDecimal.ZERO;
       					BigDecimal itemQuantity = item.getBigDecimal("quantity");
	       				for(GenericValue dlvItem: deliveryItems){
	       					totalTransferQty = totalTransferQty.add(dlvItem.getBigDecimal("quantity"));
	       		       	}
	       				if (totalTransferQty.compareTo(itemQuantity) >= 0){
	       					listTransfered.add(item);
	       				} else {
	       					item.put("quantity", itemQuantity.subtract(totalTransferQty));
	       				}
       				}
       			} catch (GenericEntityException e1) {
       				e1.printStackTrace();
       			} 
       		}
       		if (!listTransfered.isEmpty()){
       			transferItems.removeAll(listTransfered);
       		}
       	}
       	
       	successResult.put("listIterator", transferItems);
       	return successResult;
   }
	
	@SuppressWarnings("unchecked")
	public static Map<String,Object> createTransferDelivery(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
    	Map<String, Object> result = new FastMap<String, Object>();
    	Delegator delegator = ctx.getDelegator();
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
    	//Get Parameters
    	String transferId = (String)context.get("transferId");
    	GenericValue transfer = delegator.findOne("TransferHeader", false, UtilMisc.toMap("transferId", transferId));
    	
    	String originFacilityId = (String)transfer.get("originFacilityId");
    	String destFacilityId = (String)transfer.get("destFacilityId");
    	GenericValue originFacility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", originFacilityId));
    	GenericValue destFacility = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", destFacilityId));
    	
    	String deliveryId = delegator.getNextSeqId("Delivery");
    	
    	String partyIdFrom = (String)originFacility.get("ownerPartyId");
    	String partyIdTo = (String)destFacility.get("ownerPartyId");
		String statusId = null;
		String itemStatusId = null;
		statusId = "DLV_CREATED";
		itemStatusId = "DELI_ITEM_CREATED";
    	List<GenericValue> transferItemShipGroups = delegator.findList("TransferItemShipGroup", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
    	GenericValue shipGroup = null;
    	if (!transferItemShipGroups.isEmpty()){
    		shipGroup = transferItemShipGroups.get(0);
    	} 
    	String destContactMechId = null;
    	String originContactMechId = null;
    	if (shipGroup != null){
    		destContactMechId = (String)shipGroup.get("destContactMechId");
    		originContactMechId = (String)shipGroup.get("originContactMechId");
    	} else {
    		return ServiceUtil.returnError(UtilProperties.getMessage(resource, "NotFoundShipInfoOfTransfer", (Locale)context.get("locale")));
    	}
    	String deliveryTypeId = (String)context.get("deliveryTypeId");
    	List<Map<String, String>> listTransferItems = (List<Map<String, String>>)context.get("listTransferItems");
    	
    	//Make Delivery
    	GenericValue delivery = delegator.makeValue("Delivery");
    	Timestamp deliveryDate = (Timestamp)(context.get("deliveryDate"));
    	delivery.put("deliveryDate", deliveryDate);
    	Timestamp createDate = UtilDateTime.nowTimestamp();
    	delivery.put("createDate", createDate);
    	delivery.put("partyIdFrom", partyIdFrom);
    	delivery.put("partyIdTo", partyIdTo);
    	delivery.put("deliveryTypeId", deliveryTypeId);
    	delivery.put("originContactMechId", originContactMechId);
    	delivery.put("originFacilityId", originFacilityId);
    	delivery.put("destFacilityId", destFacilityId);
    	delivery.put("destContactMechId", destContactMechId);
    	delivery.put("deliveryId", deliveryId);
    	delivery.put("transferId", transferId);
    	delivery.put("statusId", statusId);
    	
    	delivery.put("totalAmount", BigDecimal.ZERO);
    	delivery.create();
    	
    	//Make Delivery Item
    	if (!listTransferItems.isEmpty()){
    		for (Map<String, String> item : listTransferItems){
    			GenericValue deliveryItem = delegator.makeValue("DeliveryItem");
    			deliveryItem.put("deliveryId", deliveryId);
				//Set Seq for delivery Item
		        delegator.setNextSubSeqId(deliveryItem, "deliveryItemSeqId", 5, 1);
    			deliveryItem.put("fromTransferItemSeqId", item.get("transferItemSeqId"));
    			deliveryItem.put("fromTransferId", item.get("transferId"));
    			deliveryItem.put("quantity", BigDecimal.valueOf(Double.parseDouble(item.get("quantity"))));
    			deliveryItem.put("actualExportedQuantity", BigDecimal.ZERO);
    			deliveryItem.put("actualDeliveredQuantity", BigDecimal.ZERO);
    			deliveryItem.put("statusId", itemStatusId);
    			deliveryItem.create();
    		}
    	} else {
    		return ServiceUtil.returnError(UtilProperties.getMessage(resource, "NoProductSelected", (Locale)context.get("locale")));
    	}
    	
    	//Create DeliveryStatus
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
	@SuppressWarnings("static-access")
	public static Map<String,Object> createTransferFromRequirement(DispatchContext ctx, Map<String,Object> context){
		Map<String,Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		String requirementId = (String)context.get("requirementId");
		String company = MultiOrganizationUtil.getCurrentOrganization(delegator);
		SecurityUtil sec = new SecurityUtil();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String transferId = null;
		try {
			GenericValue requirement = delegator.findOne("Requirement", false, UtilMisc.toMap("requirementId", requirementId));
			GenericValue reqFacility = delegator.findOne("RequirementFacility", false, UtilMisc.toMap("requirementId", requirementId));
			List<GenericValue> listReqItems = delegator.findList("RequirementItem", EntityCondition.makeCondition(UtilMisc.toMap("requirementId", requirementId, "statusId", "REQ_ITEM_APPROVED")), null, null, null, false);
			if (requirement != null && reqFacility != null && !listReqItems.isEmpty()){
				Map<String, Object> transferMap = FastMap.newInstance();
				String facilityIdFrom = (String)reqFacility.get("facilityIdFrom");
				String facilityIdTo = (String)reqFacility.get("facilityIdTo");
				String originContactMechId = (String)reqFacility.get("originContactMechId");
				String destContactMechId = (String)reqFacility.get("destContactMechId");
				
				GenericValue facilityFrom = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", facilityIdFrom));
				GenericValue facilityTo = delegator.findOne("Facility", false, UtilMisc.toMap("facilityId", facilityIdTo));
				String ownerFacilityFrom = (String)facilityFrom.get("ownerPartyId");
				String ownerFacilityTo = (String)facilityTo.get("ownerPartyId");
				String transferTypeId = null;
				if (company.equals(ownerFacilityFrom) && company.equals(ownerFacilityTo)){
					GenericValue facFromGeo = delegator.findOne("FacilityLocationGeo", false, UtilMisc.toMap("facilityId", facilityIdFrom));
					GenericValue facToGeo = delegator.findOne("FacilityLocationGeo", false, UtilMisc.toMap("facilityId", facilityIdTo));
					if (facFromGeo != null && facToGeo != null){
						String geoFromId = (String)facFromGeo.get("geoId");
						String geoToId = (String)facToGeo.get("geoId");
						if ("VN-HN".equals(geoFromId) && "VN-HN".equals(geoToId)){
							transferTypeId = "TRANS_INTERNAL";
						} else {
							transferTypeId = "TRANS_INTERMEDIARY";
						}
					} else {
						return ServiceUtil.returnError(UtilProperties.getMessage(resource, "PleaseSetGeoForFacility", (Locale)context.get("locale")));
					}
				} else {
					List<String> rolesFrom = sec.getCurrentRoles(ownerFacilityFrom, delegator);
					List<String> rolesTo = sec.getCurrentRoles(ownerFacilityTo, delegator);
					if (company.equals(ownerFacilityFrom) && rolesTo.contains("DELYS_DISTRIBUTOR")){
						transferTypeId = "TRANS_DISTRIBUTOR";
					}
					if (company.equals(ownerFacilityTo) && rolesFrom.contains("DELYS_DISTRIBUTOR")){
						transferTypeId = "TRANS_DISTRIBUTOR";
					}
				}
				transferMap.put("transferTypeId", transferTypeId);
				transferMap.put("originFacilityId",facilityIdFrom);
				transferMap.put("destFacilityId", facilityIdTo);
				transferMap.put("originContactMechId", originContactMechId);
				transferMap.put("destContactMechId", destContactMechId);
				transferMap.put("shipmentMethodTypeId", "NO_SHIPPING");
				transferMap.put("carrierPartyId", "_NA_");
				
				List<Map<String, String>> listProducts = new ArrayList<Map<String, String>>();
				for (GenericValue reqItem : listReqItems){
					Map<String, String> prItem = FastMap.newInstance();
					prItem.put("productId", (String)reqItem.get("productId"));
					prItem.put("quantity", reqItem.get("quantity").toString());
					prItem.put("quantityUomId", (String)reqItem.get("quantityUomId"));
					if (reqItem.get("expireDate") != null){
						prItem.put("expireDate", Long.toString(reqItem.getTimestamp("expireDate").getTime()));
					}
					if (reqItem.get("shipBeforeDate") != null){
						prItem.put("shipBeforeDate", Long.toString(reqItem.getTimestamp("shipBeforeDate").getTime()));
					} else {
						transferMap.put("shipBeforeDate", requirement.getTimestamp("requirementStartDate"));
					}
					if (reqItem.get("shipAfterDate") != null){
						prItem.put("shipAfterDate", Long.toString(reqItem.getTimestamp("shipAfterDate").getTime()));
					} else {
						transferMap.put("shipAfterDate", requirement.getTimestamp("requiredByDate"));
					}
					listProducts.add(prItem);
				}
				transferMap.put("listProducts", listProducts);
				transferMap.put("userLogin", userLogin);
				try {
					Map<String,Object> resultTmp = dispatcher.runSync("createTransfer", transferMap);
					transferId = (String)resultTmp.get("transferId");
				} catch (GenericServiceException e) {
					e.printStackTrace();
				}
				requirement.put("statusId", "REQ_COMPLETED");
				delegator.store(requirement);
			} else {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "NotFoundRequirementOrNotProductItem", (Locale)context.get("locale")));
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		result.put("transferId", transferId);
		return result;
	}
	
	public static Map<String, Object> setTransferItemStatus(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();

        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String transferId = (String) context.get("transfer");
        String transferItemSeqId = (String) context.get("transferItemSeqId");
        String fromStatusId = (String) context.get("fromStatusId");
        String statusId = (String) context.get("statusId");
        Timestamp statusDateTime = (Timestamp) context.get("statusDateTime");
        Locale locale = (Locale) context.get("locale");

        // check and make sure we have permission to change the order

        Map<String, String> fields = UtilMisc.<String, String>toMap("transferId", transferId);
        if (transferItemSeqId != null)
            fields.put("transferItemSeqId", transferItemSeqId);
        if (fromStatusId != null)
            fields.put("statusId", fromStatusId);

        List<GenericValue> transferItems = null;
        try {
        	transferItems = delegator.findByAnd("TransferItem", fields, null, false);
        } catch (GenericEntityException e) {
            return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                    "CannotGetTransferItemEntity",locale) + e.getMessage());
        }

        if (UtilValidate.isNotEmpty(transferItems)) {
            List<GenericValue> toBeStored = new ArrayList<GenericValue>();
            for (GenericValue transferItem : transferItems) {
                if (transferItem.getString("statusId").equals(statusId)) {
                    continue;
                }
                try {
                    Map<String, String> statusFields = UtilMisc.<String, String>toMap("statusId", transferItem.getString("statusId"), "statusIdTo", statusId);
                    GenericValue statusChange = delegator.findOne("StatusValidChange", statusFields, true);

                    if (statusChange == null) {
                        continue;
                    }
                } catch (GenericEntityException e) {
                    return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                            "CouldNotChangeItemStatus",locale) + e.getMessage());
                }

                transferItem.set("statusId", statusId);
                toBeStored.add(transferItem);
                if (statusDateTime == null) {
                    statusDateTime = UtilDateTime.nowTimestamp();
                }
                // now create a status change
                Map<String, Object> changeFields = new HashMap<String, Object>();
                changeFields.put("transferStatusId", delegator.getNextSeqId("TransferStatus"));
                changeFields.put("statusId", statusId);
                changeFields.put("transferId", transferId);
                changeFields.put("transferItemSeqId", transferItem.getString("transferItemSeqId"));
                changeFields.put("statusDatetime", statusDateTime);
                changeFields.put("statusUserLogin", userLogin.getString("userLoginId"));
                GenericValue transferStatus = delegator.makeValue("TransferStatus", changeFields);
                toBeStored.add(transferStatus);
            }

            // store the changes
            if (toBeStored.size() > 0) {
                try {
                    delegator.storeAll(toBeStored);
                } catch (GenericEntityException e) {
                    return ServiceUtil.returnError(UtilProperties.getMessage(resource,
                            "CouldNotChangeItemStatus", locale) + e.getMessage());
                }
            }

        }

        return ServiceUtil.returnSuccess();
    }
	
	public static Map<String, Object> checkTransferItemStatus(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        LocalDispatcher dispatcher = ctx.getDispatcher();
        Locale locale = (Locale) context.get("locale");

        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String transferId = (String) context.get("transferId");
        // get the transfer header
        GenericValue transferHeader = null;
        try {
        	transferHeader = delegator.findOne("TransferHeader", UtilMisc.toMap("transferId", transferId), false);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get TransferHeader record", module);
        }
        if (transferHeader == null) {
            Debug.logError("TransferHeader came back as null", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "TransferCannotBeFound", (Locale)context.get("locale")));
        }

        // get the transfer items
        List<GenericValue> transferItems = null;
        try {
        	transferItems = delegator.findByAnd("TransferItem", UtilMisc.toMap("transferId", transferId), null, false);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get TransferItem records", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "ProblemGettingTransferItemRecords", locale));
        }

        String transferHeaderStatusId = transferHeader.getString("statusId");

        boolean allCanceled = true;
        boolean allComplete = true;
        boolean allApproved = true;
        if (transferItems != null) {
            for (GenericValue item : transferItems) {
                String statusId = item.getString("statusId");
                if (!"TRANS_ITEM_CANCELLED".equals(statusId)) {
                    allCanceled = false;
                    if (!"TRANS_ITEM_COMPLETED".equals(statusId)) {
                        allComplete = false;
                        if (!"TRANS_ITEM_APPROVED".equals(statusId)) {
                            allApproved = false;
                            break;
                        }
                    }
                }
            }

            // find the next status to set to (if any)
            
            String newStatus = null;
            if (allCanceled) {
                newStatus = "TRANSFER_CANCELLED";
            } else if (allComplete) {
                newStatus = "TRANSFER_COMPLETED";
            } else if (allApproved) {
                boolean changeToApprove = true;
                if ("TRANSFER_COMPLETED".equals(transferHeaderStatusId)) {
                	changeToApprove = false;
                }
                if ("TRANSFER_CANCELLED".equals(transferHeaderStatusId)){
                	changeToApprove = false;
                }
                if (changeToApprove) {
                    newStatus = "TRANSFER_APPROVED";
                }
            }

            // now set the new transfer status
            if (newStatus != null && !newStatus.equals(transferHeaderStatusId)) {
                Map<String, Object> serviceContext = UtilMisc.<String, Object>toMap("transferId", transferId, "statusId", newStatus, "userLogin", userLogin);
                Map<String, Object> newSttsResult = null;
                try {
                    newSttsResult = dispatcher.runSync("changeTransferStatus", serviceContext);
                } catch (GenericServiceException e) {
                    Debug.logError(e, "Problem calling the changeTransferStatus service", module);
                }
                if (ServiceUtil.isError(newSttsResult)) {
                    return ServiceUtil.returnError(ServiceUtil.getErrorMessage(newSttsResult));
                }
            }
        }

        return ServiceUtil.returnSuccess();
    }
	
	public static Map<String, Object> setTransferStatus(DispatchContext ctx, Map<String, ? extends Object> context) {
        LocalDispatcher dispatcher = ctx.getDispatcher();
        Delegator delegator = ctx.getDelegator();
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String transferId = (String) context.get("transferId");
        String statusId = (String) context.get("statusId");
        String changeReason = (String) context.get("changeReason");
        Map<String, Object> successResult = ServiceUtil.returnSuccess();
        Locale locale = (Locale) context.get("locale");
        GenericValue transferHeader  = null;
        try {
            transferHeader = delegator.findOne("TransferHeader", UtilMisc.toMap("transferId", transferId), false);

            if (transferHeader == null) {
                return ServiceUtil.returnError(UtilProperties.getMessage(resource, "TransferCannotBeFound", locale));
            }

            if (transferHeader.getString("statusId").equals(statusId)) {
            	return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CannotChangeStatusWithTheSameStatusId", locale));
            }
            try {
                Map<String, String> statusFields = UtilMisc.<String, String>toMap("statusId", transferHeader.getString("statusId"), "statusIdTo", statusId);
                GenericValue statusChange = delegator.findOne("StatusValidChange", statusFields, true);
                if (statusChange == null) {
                    return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CannotChangeBetweenTwoStatus", locale) + ": [" + statusFields.get("statusId") + "] -> [" + statusFields.get("statusIdTo") + "]");
                }
            } catch (GenericEntityException e) {
            	e.printStackTrace();
            }

            // update the current status
            transferHeader.set("statusId", statusId);

            // now create a status change
            GenericValue transferStatus = delegator.makeValue("TransferStatus");
            transferStatus.put("transferStatusId", delegator.getNextSeqId("TransferStatus"));
            transferStatus.put("statusId", statusId);
            transferStatus.put("transferId", transferId);
            transferStatus.put("statusDatetime", UtilDateTime.nowTimestamp());
            transferStatus.put("statusUserLogin", userLogin.getString("userLoginId"));
            transferStatus.put("changeReason", changeReason);

            transferHeader.store();
            transferStatus.create();

        } catch (GenericEntityException e) {
        	e.printStackTrace();
        }

        String newItemStatusId = null;
        if ("TRANSFER_APPROVED".equals(statusId)) {
            newItemStatusId = "TRANS_ITEM_APPROVED";
            try {
				dispatcher.runSync("reserveInventoryForTransfer", UtilMisc.toMap("transferId", transferId, "facilityId", (String)transferHeader.get("originFacilityId")));
			} catch (GenericServiceException e) {
				e.printStackTrace();
			}
        } else if ("TRANSFER_COMPLETED".equals(statusId)) {
            newItemStatusId = "TRANS_ITEM_COMPLETED";
        } else if ("TRANSFER_CANCELLED".equals(statusId)) {
            newItemStatusId = "TRANS_ITEM_CANCELLED";
        } else if ("TRANSFER_REJECTED".equals(statusId)) {
            newItemStatusId = "TRANS_ITEM_REJECTED";
        }
        
        if (newItemStatusId != null) {
            try {
                Map<String, Object> resp = dispatcher.runSync("changeTransferItemStatus", UtilMisc.<String, Object>toMap("transferId", transferId, "statusId", newItemStatusId, "userLogin", userLogin));
                if (ServiceUtil.isError(resp)) {
                	return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CouldNotChangeItemStatus", locale));
                }
            } catch (GenericServiceException e) {
            	e.printStackTrace();
            }
        }

        return successResult;
    }
	public static Map<String, Object> reserveInventoryForTransfer(DispatchContext ctx, Map<String, ? extends Object> context) {
		LocalDispatcher dispatcher = ctx.getDispatcher();
        Delegator delegator = ctx.getDelegator();
        Map<String, Object> successResult = ServiceUtil.returnSuccess();
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String transferId = (String) context.get("transferId");
        String facilityId = (String)context.get("facilityId");
        Locale locale = (Locale) context.get("locale");
		List<GenericValue> listTransItemShipGrpAssoc;
		try {
			listTransItemShipGrpAssoc = delegator.findList("TransferItemShipGroupAssoc", EntityCondition.makeCondition(UtilMisc.toMap("transferId", transferId)), null, null, null, false);
			if (!listTransItemShipGrpAssoc.isEmpty()){
				for (GenericValue assoc : listTransItemShipGrpAssoc){
					Map<String, Object> mapInv = FastMap.newInstance();
					GenericValue transferItem = delegator.findOne("TransferItem", false, UtilMisc.toMap("transferId", transferId, "transferItemSeqId", (String)assoc.get("transferItemSeqId")));
					if (transferItem != null){
						mapInv.put("productId", (String)transferItem.get("productId"));
						mapInv.put("facilityId", facilityId);
						mapInv.put("inventoryItemTypeId", "NON_SERIAL_INV_ITEM");
						mapInv.put("userLogin", userLogin);
						mapInv.put("expireDate", transferItem.get("expireDate"));
						Map<String, Object> mapInvResult = FastMap.newInstance();
						String inventoryItemId = null;
						try {
							mapInvResult = dispatcher.runSync("createInventoryItem", mapInv);
							inventoryItemId = (String)mapInvResult.get("inventoryItemId");
							mapInv = FastMap.newInstance();
							mapInv.put("inventoryItemId", inventoryItemId);
							mapInv.put("availableToPromiseTotal", transferItem.getBigDecimal("quantity").negate());
							mapInv.put("quantityOnHandTotal", BigDecimal.ZERO);
							dispatcher.runSync("createInventoryItemCheckSetAtpQoh", mapInv);
						} catch (GenericServiceException e) {
							e.printStackTrace();
						}
				        if (inventoryItemId != null){
				        	GenericValue reservedItem = delegator.makeValue("TransferItemShipGrpInvRes");
				        	reservedItem.put("transferId", transferId);
				        	reservedItem.put("shipGroupSeqId", (String)assoc.get("shipGroupSeqId"));
				        	reservedItem.put("transferItemSeqId", (String)assoc.get("transferItemSeqId"));
				        	reservedItem.put("inventoryItemId", inventoryItemId);
				        	reservedItem.put("quantity", assoc.getBigDecimal("quantity"));
				        	reservedItem.put("quantityNotAvailable", assoc.getBigDecimal("cancelQuantity"));
				        	reservedItem.put("reservedDatetime", UtilDateTime.nowTimestamp());
				        	reservedItem.put("createdDatetime", UtilDateTime.nowTimestamp());
				        	delegator.create(reservedItem);
				        }
					}
				}
			} else {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CannotFoundTransferItemShipGroupAssoc", locale));
			}
		} catch (GenericEntityException e1) {
			e1.printStackTrace();
		}
		return successResult;
	}
	
	public static Map<String, Object> checkDeliveryTransferStatus(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        LocalDispatcher dispatcher = ctx.getDispatcher();
        Locale locale = (Locale) context.get("locale");

        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String transferId = (String) context.get("transferId");
        // get the transfer header
        GenericValue transferHeader = null;
        try {
        	transferHeader = delegator.findOne("TransferHeader", UtilMisc.toMap("transferId", transferId), false);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get TransferHeader record", module);
        }
        if (transferHeader == null) {
            Debug.logError("TransferHeader came back as null", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "TransferCannotBeFound", (Locale)context.get("locale")));
        }

        // get the transfer items
        List<GenericValue> transferDeliveries = null;
        try {
        	transferDeliveries = delegator.findByAnd("Delivery", UtilMisc.toMap("transferId", transferId), null, false);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get Delivery by Transfer", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "ProblemGettingDeliveryRecords", locale));
        }

        String transferHeaderStatusId = transferHeader.getString("statusId");
        
        boolean isCreated = false;
        boolean isApproved = false;
        boolean isExported = false;
        boolean isDelivered = false;
        boolean isCompleted = false;
        String newStatus = null;
        if (transferDeliveries != null) {
            for (GenericValue delivery : transferDeliveries) {
                String statusId = delivery.getString("statusId");
                if ("DLV_CREATED".equals(statusId)) {
                	isCreated = true;
                	break;
                }
            }
            if (isCreated){
            	newStatus = "TRANSFER_CREATED";
            } else {
            	for (GenericValue delivery : transferDeliveries) {
                    String statusId = delivery.getString("statusId");
                    if ("DLV_APPROVED".equals(statusId)) {
                    	isApproved = true;
                    	break;
                    }
                }
            	if (isApproved){
            		newStatus = "TRANSFER_APPROVED";
            	} else {
            		for (GenericValue delivery : transferDeliveries) {
                        String statusId = delivery.getString("statusId");
                        if ("DLV_EXPORTED".equals(statusId)) {
                        	isExported = true;
                        	break;
                        }
                    }
            		if (isExported){
            			newStatus = "TRANSFER_EXPORTED";
            		} else {
            			for (GenericValue delivery : transferDeliveries) {
                            String statusId = delivery.getString("statusId");
                            if ("DLV_DELIVERED".equals(statusId)) {
                            	isDelivered = true;
                            	break;
                            }
                        }
            			if (isDelivered){
            				newStatus = "TRANSFER_DELIVERED";
            			} else {
            				for (GenericValue delivery : transferDeliveries) {
                                String statusId = delivery.getString("statusId");
                                if ("DLV_COMPLETED".equals(statusId)) {
                                	isCompleted = true;
                                	break;
                                }
                            }
            				if (isCompleted){
            					newStatus = "TRANSFER_COMPLETED";
            				}
            			}
            		}
            	}
            }
            // now set the new transfer status
            if (newStatus != null && !newStatus.equals(transferHeaderStatusId)) {
            	try {
	            	Map<String, String> statusFields = UtilMisc.<String, String>toMap("statusId", transferHeader.getString("statusId"), "statusIdTo", newStatus);
	                GenericValue statusChange;
					try {
						statusChange = delegator.findOne("StatusValidChange", statusFields, true);
						if (statusChange != null) {
		                	Map<String, Object> serviceContext = UtilMisc.<String, Object>toMap("transferId", transferId, "statusId", newStatus, "userLogin", userLogin);
		                    Map<String, Object> newSttsResult = null;
		                    newSttsResult = dispatcher.runSync("changeTransferStatus", serviceContext);
		                    if (ServiceUtil.isError(newSttsResult)) {
		                        return ServiceUtil.returnError(ServiceUtil.getErrorMessage(newSttsResult));
		                    }
		                }
					} catch (GenericEntityException e) {
						e.printStackTrace();
					}
                } catch (GenericServiceException e) {
                    Debug.logError(e, "Problem calling the changeTransferStatus service", module);
                }
                
            }
        }

        return ServiceUtil.returnSuccess();
    }
	public static Map<String, Object> getDeliveryItemDetail(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        Map<String, Object> result = FastMap.newInstance();
        String deliveryId = (String)context.get("deliveryId");
        String deliveryItemSeqId = (String)context.get("deliveryItemSeqId");
        String productId = null;
        String quantityUomId = null;
        Timestamp expireDate = null;
        try {
			GenericValue deliveryItem = delegator.findOne("DeliveryItem", false, UtilMisc.toMap("deliveryId", deliveryId, "deliveryItemSeqId", deliveryItemSeqId));
			if (deliveryItem != null){
				String orderId = (String)deliveryItem.get("fromOrderId");
				String transferId = (String)deliveryItem.get("fromTransferId");
				if (orderId != null){
					String orderItemSeqId = (String)deliveryItem.get("fromOrderItemSeqId");
					GenericValue orderItem = delegator.findOne("OrderItem", false, UtilMisc.toMap("orderId", orderId, "orderItemSeqId", orderItemSeqId));
					productId = (String)orderItem.get("productId");
					quantityUomId = (String)orderItem.get("quantityUomId");
					if (quantityUomId == null){
						GenericValue product = delegator.findOne("Product", false, UtilMisc.toMap("productId", productId));
						quantityUomId = (String)product.get("quantityUomId");
					}
					expireDate = orderItem.getTimestamp("expireDate");
				} else if (transferId != null){
					String transferItemSeqId = (String)deliveryItem.get("fromTransferItemSeqId");
					GenericValue transferItem = delegator.findOne("TransferItem", false, UtilMisc.toMap("transferId", transferId, "transferItemSeqId", transferItemSeqId));
					productId = (String)transferItem.get("productId");
					quantityUomId = (String)transferItem.get("quantityUomId");
					expireDate = transferItem.getTimestamp("expireDate");
				}
				result.put("productId", productId);
				result.put("quantityUomId", quantityUomId);
				result.put("expireDate", expireDate);
				
			} else {
				return ServiceUtil.returnError("Problem when get DeliveryItem records");
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
        return result;
	}
	public static Map<String, Object> sendNotificationToStorekeeper(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        LocalDispatcher dispatcher = ctx.getDispatcher();
        Map<String, Object> result = FastMap.newInstance();
        String deliveryId = (String)context.get("deliveryId");
        GenericValue delivery = null;
        GenericValue userLogin = (GenericValue)context.get("userLogin");
        try {
			delivery = delegator.findOne("Delivery", false, UtilMisc.toMap("deliveryId", deliveryId));
			if (delivery == null){
				return ServiceUtil.returnError("Delivery not found");
			}
			String deliveryTypeId = (String)delivery.get("deliveryTypeId");
	        String originFacilityId = (String)delivery.get("originFacilityId");
	        String destFacilityId = (String)delivery.get("destFacilityId");
	        List<GenericValue> listOriginStorekeepers = delegator.findList("FacilityParty", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", originFacilityId, "roleTypeId", "LOG_STOREKEEPER")), null, null, null, false);
	        listOriginStorekeepers = EntityUtil.filterByDate(listOriginStorekeepers);
	        if (listOriginStorekeepers.isEmpty()){
	        	return ServiceUtil.returnError("Storekeeper of origin Facility not found");
	        }
	        List<GenericValue> listDestStorekeepers = delegator.findList("FacilityParty", EntityCondition.makeCondition(UtilMisc.toMap("facilityId", destFacilityId, "roleTypeId", "LOG_STOREKEEPER")), null, null, null, false);
	        listDestStorekeepers = EntityUtil.filterByDate(listDestStorekeepers);
	        if (listDestStorekeepers.isEmpty()){
	        	return ServiceUtil.returnError("Storekeeper of destination Facility not found");
	        }
	        String header = "";
	        if ("DELIVERY_SALES".equals(deliveryTypeId)){
	        	header = "Có phiếu xuất kho mới";
	        } else if ("DELIVERY_TRANSFER".equals(deliveryTypeId)){
	        	header = "Có phiếu chuyển kho nội bộ mới"; 
	        }
	        
	        for (GenericValue party : listOriginStorekeepers){
	        	String tagetLink = "deliveryTypeId=" + deliveryTypeId + ";deliveryId=" + deliveryId;
	    		String sendToPartyId = (String)party.get("partyId");
	    		Map<String, Object> mapContext = new HashMap<String, Object>();
	    		mapContext.put("partyId", sendToPartyId);
	    		mapContext.put("action", "listAllDeliveries");
	    		mapContext.put("targetLink", tagetLink);
	    		mapContext.put("header", header);
	    		mapContext.put("userLogin", userLogin);
	    		try {
	    			dispatcher.runSync("createNotification", mapContext);
	    		} catch (GenericServiceException e) {
	    			e.printStackTrace();
	    		}
	        }
	        for (GenericValue party : listDestStorekeepers){
	        	String tagetLink = "deliveryTypeId=" + deliveryTypeId + ";deliveryId=" + deliveryId;
	    		String sendToPartyId = (String)party.get("partyId");
	    		Map<String, Object> mapContext = new HashMap<String, Object>();
	    		mapContext.put("partyId", sendToPartyId);
	    		mapContext.put("action", "listAllDeliveries");
	    		mapContext.put("targetLink", tagetLink);
	    		mapContext.put("header", header);
	    		mapContext.put("userLogin", userLogin);
    			try {
					dispatcher.runSync("createNotification", mapContext);
				} catch (GenericServiceException e) {
					e.printStackTrace();
				}
	        }
        } catch(GenericEntityException e){
        	e.printStackTrace();
        }
        return result;
	}
	public static Map<String, Object> updateShipmentByDelivery(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        LocalDispatcher dispatcher = ctx.getDispatcher();
        Map<String, Object> result = FastMap.newInstance();
        String deliveryId = (String)context.get("deliveryId");
        GenericValue delivery = null;
        
        try {
			delivery = delegator.findOne("Delivery", false, UtilMisc.toMap("deliveryId", deliveryId));
			if (delivery == null){
				return ServiceUtil.returnError("Delivery not found");
			}
			String shipmentId = (String)delivery.get("shipmentId");
			if (shipmentId == null){
				return ServiceUtil.returnError("Shipment not found in delivery");
			}
			GenericValue shipment = delegator.findOne("Shipment", false, UtilMisc.toMap("shipmentId", shipmentId));
			String deliveryStatusId = (String)delivery.get("statusId");
			String shipmentStatusId = null;
			if ("DLV_EXPORTED".equals(deliveryStatusId)){
				shipmentStatusId = "SHIPMENT_PACKED";
			} else if ("DLV_DELIVERED".equals(deliveryStatusId)){
				shipmentStatusId = "SHIPMENT_DELIVERED";
			}
			if (shipmentStatusId != null){
				Map<String, String> statusFields = UtilMisc.<String, String>toMap("statusId", shipment.getString("statusId"), "statusIdTo", shipmentStatusId);
                GenericValue statusChange = delegator.findOne("StatusValidChange", statusFields, true);
                if (statusChange != null){
    				try {
    					GenericValue userLogin = delegator.findOne("UserLogin", false, UtilMisc.toMap("userLoginId", "system"));
    					Map<String, Object> mapShipment = FastMap.newInstance();
        				mapShipment.put("userLogin", userLogin);
        				mapShipment.put("shipmentId", shipmentId);
        				mapShipment.put("statusId", shipmentStatusId);
    					dispatcher.runSync("updateShipment", mapShipment);
    				} catch (GenericServiceException e) {
    					e.printStackTrace();
    				}
                }
			}
        } catch(GenericEntityException e){
        	e.printStackTrace();
        }
        return result;
	}
	public static Map<String, Object> getStatusValidToChange(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        Map<String, Object> result = FastMap.newInstance();
        String statusId = (String)context.get("statusId");
        try {
			List<GenericValue> listStatusIds = delegator.findList("StatusValidChange", EntityCondition.makeCondition(UtilMisc.toMap("statusId", statusId)), null, null, null, false);
			result.put("listStatusIds", listStatusIds);
        } catch (GenericEntityException e) {
			e.printStackTrace();
		}
        return result;
	}
	public static Map<String, Object> updateDeliveryByShipment(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        Map<String, Object> result = FastMap.newInstance();
        String shipmentId = (String)context.get("shipmentId");
        GenericValue shipment = null;
        try {
        	shipment = delegator.findOne("Shipment", false, UtilMisc.toMap("shipmentId", shipmentId));
			if (shipment == null){
				return ServiceUtil.returnError("Shipment not found");
			}
			String shipmentStatusId = shipment.getString("statusId");
			if (!"SHIPMENT_INPUT".equals(shipmentStatusId) && !"SHIPMENT_SCHEDULED".equals(shipmentStatusId) && !"SHIPMENT_CANCELLED".equals(shipmentStatusId)){
				List<GenericValue> listDeliveries = delegator.findList("Delivery", EntityCondition.makeCondition(UtilMisc.toMap("shipmentId", shipmentId)), null, null, null, false);
				if (!listDeliveries.isEmpty()){
					for (GenericValue delivery : listDeliveries){
						String deliveryStatusId = (String)delivery.get("statusId");
						String newDeliveryStatusId = null;
						if ("SHIPMENT_PICKED".equals(shipmentStatusId) || "SHIPMENT_PACKED".equals(shipmentStatusId) || "SHIPMENT_SHIPPED".equals(shipmentStatusId)){
							newDeliveryStatusId = "DLV_EXPORTED";
						} else if ("SHIPMENT_DELIVERED".equals(shipmentStatusId)){
							newDeliveryStatusId = "DLV_DELIVERED";
						}
						if (newDeliveryStatusId != null && !newDeliveryStatusId.equals(deliveryStatusId)){
							List<GenericValue> deliveryItems = delegator.findList("DeliveryItem", EntityCondition.makeCondition(UtilMisc.toMap("deliveryId", delivery.get("deliveryId"))), null, null, null, false);
							if (!deliveryItems.isEmpty()){
								for (GenericValue item : deliveryItems){
									if ("DLV_EXPORTED".equals(newDeliveryStatusId)){
										item.put("statusId", "DELI_ITEM_EXPORTED");
										item.put("actualExportedQuantity", item.getBigDecimal("quantity"));
										item.store();
									} else if ("DLV_DELIVERED".equals(newDeliveryStatusId)){
										item.store();
										item.put("statusId", "DELI_ITEM_DELIVERED");
										item.put("actualDeliveredQuantity", item.getBigDecimal("actualExportedQuantity"));
									}
								}
							}
							delivery.put("statusId", newDeliveryStatusId);
							delivery.store();
						}
					}
				}
			}
        } catch(GenericEntityException e){
        	e.printStackTrace();
        }
        return result;
	}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getListShipmentItem(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String shipmentId = (String)parameters.get("shipmentId")[0];
    	if (shipmentId != null && !"".equals(shipmentId)){
    		mapCondition.put("shipmentId", shipmentId);
    	}
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	List<GenericValue> listItems = new ArrayList<GenericValue>();
    	try {
    		listItems = delegator.findList("ShipmentItemDetail", EntityCondition.makeCondition(listAllConditions), null, listSortFields, opts, false);
    	} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListShipmentItem service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listItems);
    	return successResult;
	}
}