package com.olbius.delys.services;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.ObjectType;
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
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.entity.util.EntityUtilProperties;
import org.ofbiz.order.order.OrderListState;
import org.ofbiz.security.Security;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GeneralServiceException;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

import com.olbius.delys.policy.EntitySalesCommission;
import com.olbius.delys.policy.EntitySalesCommissionAdjustment;
import com.olbius.delys.policy.SalesPolicyWorker;
import com.olbius.delys.util.SalesPartyUtil;
import com.olbius.employment.services.EmploymentServices;

public class SalesServices {
	public static final String module = SalesServices.class.getName();
    public static final String resource = "DelysAdminUiLabels";
    public static final String resource_error = "DelysAdminErrorUiLabels";
    public static final String resourceNoti = "NotificationUiLabels";
	
    enum SqlOperator{ 
    	CONTAINS, DOES_NOT_CONTAIN, EQUAL, NOT_EQUAL, GREATER_THAN, LESS_THAN, GREATER_THAN_OR_EQUAL, LESS_THAN_OR_EQUAL, STARTS_WITH, ENDS_WITH, NULL, NOT_NULL
    }
    
    public enum ContactMechTypeIdEnum {
    	ELECTRONIC_ADDRESS, POSTAL_ADDRESS, TELECOM_NUMBER, EMAIL_ADDRESS, IP_ADDRESS, DOMAIN_NAME, WEB_ADDRESS, INTERNAL_PARTYID, LDAP_ADDRESS
    }
    
    public enum OrderStatusIdEnum {
    	ORDER_SUPAPPROVED, ORDER_SADAPPROVED, ORDER_APPROVED, ORDER_COMPLETED, ORDER_CANCELLED, ORDER_NPPAPPROVED
    }
    
    // TODO Cache parameters before calculating!
    /**
     * Description: calculate and output commission sales for parties
     * @param ctx
     * @param context
     * @return
     */
    public static Map<String, Object> getSalesCommissionAmountList(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	List<EntitySalesCommission> listEntitySalesCommissionAmount = null;
    	String roleTypeId = (String) context.get("roleTypeId");
    	String customTimePeriodId = (String) context.get("customTimePeriodId");
    	Timestamp fromDate = (Timestamp) context.get("fromDate");
    	Timestamp thruDate = (Timestamp) context.get("thruDate");
    	Locale locale = (Locale) context.get("locale");
    	// first access function
    	if((roleTypeId == null) || (roleTypeId.isEmpty()) || (customTimePeriodId == null) || (customTimePeriodId.isEmpty())){
    		if (fromDate == null || thruDate == null) {
    			return ServiceUtil.returnSuccess();
    		}
    	}
    	try {
    		/*listEntitySalesCommissionAmount = PayrollEngine.getSalaryList(ctx, strEmployeeId, listInputFormulas, tFromDate, tThruDate);*/
    		listEntitySalesCommissionAmount = SalesPolicyWorker.getSalesCommissionList(ctx, roleTypeId, customTimePeriodId, fromDate, thruDate, locale);
			result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		} catch (Exception e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "generalError", new Object[] { e.getMessage() }, locale));
		}
    	result.put("salesCommissionAmountList", listEntitySalesCommissionAmount); 
    	return result;
    }
    
    public static Map<String, Object> logSalesCommissionData(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	LocalDispatcher dispatcher = ctx.getDispatcher();
    	//Get parameters
    	/*String roleTypeId = (String) context.get("roleTypeId");
    	String customTimePeriodId = (String) context.get("customTimePeriodId");
    	Timestamp fromDate = (Timestamp) context.get("fromDate");
    	Timestamp thruDate = (Timestamp) context.get("fromDate");*/
    	@SuppressWarnings("unchecked")
		List<EntitySalesCommission> listEntitySalesCommission = (List<EntitySalesCommission>) context.get("salesCommissionAmountList");
    	Locale locale = (Locale) context.get("locale");
    	List<GenericValue> toBeStoredCommission = new LinkedList<GenericValue>();
    	try {
	    	//List payroll for all Employee in a payroll period
	    	for (EntitySalesCommission commissionItem : listEntitySalesCommission) {
	    		BigDecimal amountNeeded = BigDecimal.ZERO;
	    		boolean isHasQuantity = false;
	    		String commisstionDataId = delegator.getNextSeqId("SalesCommissionData");
	    		List<EntitySalesCommissionAdjustment> listEntitySalesCommissionAdj = commissionItem.getListSalesCommissionsAdj();
	    		List<GenericValue> toBeStored = new LinkedList<GenericValue>();
	    		for (EntitySalesCommissionAdjustment adjItem : listEntitySalesCommissionAdj) {
	    			if (UtilValidate.isNotEmpty(adjItem.getAmount())) {
	    				amountNeeded = amountNeeded.add(adjItem.getAmount());
	    			}
	    			if (UtilValidate.isNotEmpty(adjItem.getProductId()) || UtilValidate.isNotEmpty(adjItem.getCategoryId())) {
		    			if (UtilValidate.isNotEmpty(adjItem.getProductId())) {
		    				for (String prodItem : adjItem.getProductId()) {
		    					isHasQuantity = true;
		    					GenericValue commissionAdj = delegator.makeValue("SalesCommissionAdjustment");
		    	    			commissionAdj.set("salesCommissionId", delegator.getNextSeqId("SalesCommissionAdjustment"));
		    	    			commissionAdj.set("salesPolicyId", adjItem.getSalesPolicyId());
		    	    			commissionAdj.set("salesPolicyRuleId", adjItem.getSalesPolicyRuleId());
		    	    			commissionAdj.set("salesPolicyActionSeqId", adjItem.getSalesPolicyActionSeqId());
		    	    			commissionAdj.set("amount", adjItem.getAmount());
		    	    			commissionAdj.set("quantity", adjItem.getQuantity());
		    	    			commissionAdj.set("productId", prodItem);
		    	    			toBeStored.add(commissionAdj);
		    				}
		    			}
		    			if (UtilValidate.isNotEmpty(adjItem.getCategoryId())) {
		    				for (String categoryItem : adjItem.getCategoryId()) {
			    				isHasQuantity = true;
		    					GenericValue commissionAdj = delegator.makeValue("SalesCommissionAdjustment");
		    	    			commissionAdj.set("salesCommissionId", commisstionDataId);
		    	    			commissionAdj.set("salesPolicyId", adjItem.getSalesPolicyId());
		    	    			commissionAdj.set("salesPolicyRuleId", adjItem.getSalesPolicyRuleId());
		    	    			commissionAdj.set("salesPolicyActionSeqId", adjItem.getSalesPolicyActionSeqId());
		    	    			commissionAdj.set("amount", adjItem.getAmount());
		    	    			commissionAdj.set("quantity", adjItem.getQuantity());
		    	    			commissionAdj.set("categoryId", categoryItem);
		    	    			toBeStored.add(commissionAdj);
		    				}
		    			}
	    			} else {
	    				GenericValue commissionAdj = delegator.makeValue("SalesCommissionAdjustment");
		    			commissionAdj.set("salesCommissionId", commisstionDataId);
		    			commissionAdj.set("salesPolicyId", adjItem.getSalesPolicyId());
		    			commissionAdj.set("salesPolicyRuleId", adjItem.getSalesPolicyRuleId());
		    			commissionAdj.set("salesPolicyActionSeqId", adjItem.getSalesPolicyActionSeqId());
		    			commissionAdj.set("amount", adjItem.getAmount());
		    			toBeStored.add(commissionAdj);
	    			}
	    		}
	    		
	    		String hasQuantity = "N";
	    		if (isHasQuantity) {
	    			hasQuantity = "Y";
	    		}
	    		commissionItem.setAmount(amountNeeded);
	    		GenericValue commission = delegator.makeValue("SalesCommissionData");
	    		commission.set("salesCommissionId", commisstionDataId);
	    		commission.set("partyId", commissionItem.getPartyId());
	    		commission.set("salesStatementId", commissionItem.getSalesStatementId());
	    		commission.set("amount", commissionItem.getAmount());
	    		commission.set("hasQuantity", hasQuantity);
	    		commission.set("fromDate", commissionItem.getFromDate());
	    		commission.set("thruDate", commissionItem.getThruDate());
	    		commission.set("statusId", "SALES_COMM_CREATED");
	    		
	    		//commission.create();
	    		//delegator.storeAll(toBeStored);
	    		toBeStoredCommission.add(commission);
	    		toBeStoredCommission.addAll(toBeStored);
	    	}
    	
			delegator.storeAll(toBeStoredCommission);
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
    	
    	//call service "assignEmployeePayrollParameters"
    	try {
            // run this synchronously so it will run in the same transaction
    		GenericValue userLoginBorrow = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", "hrroom"), false);
    		for (EntitySalesCommission commissionItem : listEntitySalesCommission) {
    			if (UtilValidate.isNotEmpty(userLoginBorrow) && UtilValidate.isNotEmpty(commissionItem.getAmount()) && !BigDecimal.ZERO.equals(commissionItem.getAmount())) {
        			Map<String, Object> contextMap = UtilMisc.<String, Object>toMap(
        													"partyId", commissionItem.getPartyId(), "code", "SALES_COMMISSION", 
        													"type", "CONST", "value", commissionItem.getAmount().toString(), 
        													"periodTypeId", "_NA_", "fromDate", commissionItem.getFromDate(), 
        													"thruDate", commissionItem.getThruDate(), "userLogin", userLoginBorrow);
                    dispatcher.runSync("assignEmployeePayrollParameters", contextMap);
    			}
    		}
        } catch (GenericServiceException e1) {
            Debug.logError(e1, "Error calling assignEmployeePayrollParameters service", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                    "DAErrorCallingAssignEmployeePayrollParametersService",locale) + e1.toString());
        } catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
    }
    
    /*public static Map<String, Object> runSalesCommission(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	List<EntitySalesCommission> listEntitySalesCommissionAmount = null;
    	String roleTypeId = (String) context.get("roleTypeId");
    	String customTimePeriodId = (String) context.get("customTimePeriodId");
    	Locale locale = (Locale) context.get("locale");
    	// first access function
    	if((roleTypeId == null) || (roleTypeId.isEmpty()) || (customTimePeriodId == null) || (customTimePeriodId.isEmpty())){
    		return ServiceUtil.returnSuccess();
    	}
    	try {
    		listEntitySalesCommissionAmount = PayrollEngine.getSalaryList(ctx, strEmployeeId, listInputFormulas, tFromDate, tThruDate);
    		listEntitySalesCommissionAmount = SalesPolicyWorker.getSalesCommissionList(ctx, roleTypeId, customTimePeriodId, locale);
			result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		} catch (Exception e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "generalError", new Object[] { e.getMessage() }, locale));
		}
    	result.put("salesCommissionAmount", listEntitySalesCommissionAmount);
    	return result;
    }*/
    
    public static Map<String, Object> runSalesStatementReport(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	Delegator delegator = ctx.getDelegator();
    	String salesId = (String) context.get("salesId");
    	Locale locale = (Locale) context.get("locale");
    	
    	result.put("salesId", salesId);
    	GenericValue salesStatement = null;
    	try {
			salesStatement = delegator.findOne("SalesStatementHeader", UtilMisc.toMap("salesId", salesId), false);
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAFailedToGetSalesStatement", new Object[] {e.getMessage()}, locale));
		}
    	
    	if (salesStatement != null) {
    		List<GenericValue> listSalesStatementItem = null;
    		try {
				listSalesStatementItem = delegator.findByAnd("SalesStatementItem", UtilMisc.toMap("salesId", salesStatement.getString("salesId")), null, false);
			} catch (GenericEntityException e) {
				Debug.logError(e, module);
				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAFailedToGetSalesStatement", new Object[] {e.getMessage()}, locale));
			}
    		if (listSalesStatementItem != null) {
        		for (GenericValue ssItem : listSalesStatementItem) {
        			BigDecimal quantityActual = BigDecimal.ZERO;
        			BigDecimal amountActual = BigDecimal.ZERO;
        			try {
	        			if (ssItem.getString("productId") != null && !"".equals(ssItem.getString("productId"))) {
							// sales statement item is product. Get list orderItem buy productId, orderDate and isPromo == N
	        				List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
	        				conditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, ssItem.getString("productId")));
	        				conditionList.add(EntityCondition.makeCondition("isPromo", EntityOperator.EQUALS, "N"));
	        				conditionList.add(EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER"));
	        				conditionList.add(EntityCondition.makeCondition("itemStatusId", EntityOperator.EQUALS, "ITEM_COMPLETED"));
	        				conditionList.add(EntityCondition.makeCondition("customerId", EntityOperator.EQUALS, salesStatement.getString("internalPartyId")));
	        				conditionList.add(EntityCondition.makeCondition("orderDate", EntityOperator.BETWEEN, UtilMisc.toList(salesStatement.getTimestamp("fromDate"), salesStatement.getTimestamp("thruDate"))));
							List<GenericValue> listOrderItem = delegator.findList("OrderHeaderAndItemsDetail", EntityCondition.makeCondition(conditionList, EntityOperator.AND), null, null, null, false);
							if (listOrderItem != null) {
								for (GenericValue oItem : listOrderItem) {
									if (oItem.getString("quantity") != null && oItem.getString("unitPrice") != null) {
										quantityActual = quantityActual.add(oItem.getBigDecimal("quantity"));
										amountActual = amountActual.add(oItem.getBigDecimal("quantity").multiply(oItem.getBigDecimal("unitPrice")));
									}
								}
							}
						} else if (ssItem.getString("productCategoryId") != null && !"".equals(ssItem.getString("productCategoryId"))) {
							EntityFindOptions opts = new EntityFindOptions();
					        opts.setDistinct(true);
							List<EntityCondition> conditionListParent = new ArrayList<EntityCondition>();
							conditionListParent.add(EntityCondition.makeCondition("productCategoryId", EntityOperator.EQUALS, ssItem.getString("productCategoryId")));
	        				conditionListParent.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, ssItem.getTimestamp("fromDate")));
	        				List<EntityCondition> conditionOr = new ArrayList<EntityCondition>();
	        				conditionOr.add(EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null));
	        				conditionOr.add(EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, ssItem.getTimestamp("fromDate")));
	        				conditionListParent.add(EntityCondition.makeCondition(conditionOr, EntityOperator.OR));
							List<GenericValue> listProductId = delegator.findList("ProductCategoryMember", EntityCondition.makeCondition(conditionListParent, EntityOperator.AND), UtilMisc.toSet("productId"), null, opts, false);
							for (GenericValue pItem : listProductId) {
								List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
		        				conditionList.add(EntityCondition.makeCondition("productId", EntityOperator.EQUALS, pItem.getString("productId")));
		        				conditionList.add(EntityCondition.makeCondition("isPromo", EntityOperator.EQUALS, "N"));
		        				conditionList.add(EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER"));
		        				conditionList.add(EntityCondition.makeCondition("itemStatusId", EntityOperator.EQUALS, "ITEM_COMPLETED"));
		        				conditionList.add(EntityCondition.makeCondition("customerId", EntityOperator.EQUALS, salesStatement.getString("internalPartyId")));
		        				conditionList.add(EntityCondition.makeCondition("orderDate", EntityOperator.BETWEEN, UtilMisc.toList(salesStatement.getTimestamp("fromDate"), salesStatement.getTimestamp("thruDate"))));
								List<GenericValue> listOrderItem = delegator.findList("OrderHeaderAndItemsDetail", EntityCondition.makeCondition(conditionList, EntityOperator.AND), null, null, null, false);
								if (listOrderItem != null) {
									for (GenericValue oItem : listOrderItem) {
										if (oItem.getString("quantity") != null && oItem.getString("unitPrice") != null) {
											quantityActual.add(oItem.getBigDecimal("quantity"));
											amountActual.add(oItem.getBigDecimal("quantity").multiply(oItem.getBigDecimal("unitPrice")));
										}
									}
								}
							}
						}
        				ssItem.set("quantityActual", quantityActual);
        				ssItem.set("amountActual", amountActual);
        			} catch (GenericEntityException e) {
        				Debug.logError(e, module);
        				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAFailedToGetSalesStatement", new Object[] {e.getMessage()}, locale));
        			}
				}
    		}
    		if (listSalesStatementItem != null) {
    			try {
					delegator.storeAll(listSalesStatementItem);
					salesStatement.set("statusId", "SALES_SM_COMPLETED");
					delegator.store(salesStatement);
				} catch (GenericEntityException e) {
					Debug.logError(e, module);
    				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAFailedToGetSalesStatement", new Object[] {e.getMessage()}, locale));
				}
    		}
    	}
    	result = ServiceUtil.returnSuccess();
    	result.put("salesId", salesId);
    	return result;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> createPromoSettleRecord(DispatchContext ctx, Map<String, Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	result = ServiceUtil.returnSuccess();
    	
    	String promoSettleRecordId = "";
    	String acceptData = (String) context.get("acceptData");
    	String rejectData = (String) context.get("rejectData");
    	Timestamp createdDate = UtilDateTime.nowTimestamp();
    	Timestamp fromDate = (Timestamp) context.get("fromDate");
    	Timestamp toDate = (Timestamp) context.get("toDate");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	
    	String[] strAcceptDataLine = acceptData.split("\\|OLBIUS\\|"); //item (orderId - orderItemSeqId)
    	String[] strRejectDataLine = rejectData.split("\\|OLBIUS\\|"); //item (orderId - orderItemSeqId - reason)
    	if (("N".equals(strAcceptDataLine[0]) && strAcceptDataLine.length > 1) || ("N".equals(strRejectDataLine[0]) && strRejectDataLine.length > 1)) {
    		promoSettleRecordId = delegator.getNextSeqId("PromoSettleRecord");
			Map<String, Object> promoSettleRecordMap = UtilMisc.<String, Object>toMap("promoSettleRecordId", promoSettleRecordId, 
					"createdBy", userLogin.getString("userLoginId"), 
					"createdDate", createdDate, 
					"statusId", "SETTLE_RECD_CREATED");
			if (UtilValidate.isNotEmpty(fromDate)) {
				promoSettleRecordMap.put("fromDate", fromDate);
			}
			if (UtilValidate.isNotEmpty(toDate)) {
				promoSettleRecordMap.put("toDate", toDate);
			} else {
				promoSettleRecordMap.put("toDate", createdDate);
			}
			
			GenericValue promoSettleRecord = delegator.makeValue("PromoSettleRecord", promoSettleRecordMap);
			// first try to create the PromoSettleRecord; if this does not fail, continue.
	        try {
	            delegator.create(promoSettleRecord);
	        } catch (GenericEntityException e) {
	            Debug.logError(e, "Cannot create PromoSettleRecord entity; problems with insert", module);
	            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
	                    "DAPromoSettleRecordCreationFailedPleaseNotifyCustomerService",locale));
	        }
    		
    	}
    	List<GenericValue> toBeStored = new LinkedList<GenericValue>();
    	//List<String> distributorPartyId = new ArrayList<String>();
    	Map<String, Object> listDataMap = FastMap.newInstance(); //{partyId1: Map{productId1: List<OrderItem>, productId2: List<OrderItem>}, partyId2: ..., partyId3: ...]}
    	try {
	    	if ("N".equals(strAcceptDataLine[0]) && strAcceptDataLine.length > 1) {
		        // create list PromoSettleItems
	    		for (int i = 1; i < strAcceptDataLine.length; i++) {
	    			String[] lineValues = strAcceptDataLine[i].split("\\|SUIBLO\\|");
	    			String orderId = lineValues[0];
	    			String orderItemSeqId = lineValues[1];
	    			if (UtilValidate.isNotEmpty(orderId) && UtilValidate.isNotEmpty(orderItemSeqId)) {
	    				GenericValue orderItem = delegator.findOne("OrderItem", UtilMisc.toMap("orderId", orderId, "orderItemSeqId", orderItemSeqId), false);
	    				if (orderItem != null) {
	    					GenericValue orderRole = EntityUtil.getFirst(delegator.findByAnd("OrderRole", UtilMisc.toMap("orderId", orderId, "roleTypeId", "BILL_FROM_VENDOR"), null, false));
	    					if (orderRole != null) {
	    						if (listDataMap.containsKey(orderRole.get("partyId"))) {
	    							Map<String, Object> productDataMap = (Map<String, Object>) listDataMap.get(orderRole.getString("partyId"));
    								if (productDataMap.containsKey(orderItem.getString("productId"))) {
    									List<GenericValue> orderItemList = (List<GenericValue>) productDataMap.get(orderItem.getString("productId"));
    									orderItemList.add(orderItem);
    								} else {
    									// not yet exists, add product item
    									List<GenericValue> orderItemList = new ArrayList<GenericValue>();
    									orderItemList.add(orderItem);
    									productDataMap.put(orderItem.getString("productId"), orderItemList);
	    							}
	    						} else {
	    							// not yet exists, add party item
	    							List<GenericValue> orderItemList = new ArrayList<GenericValue>();
	    							orderItemList.add(orderItem);
	    							Map<String, Object> productDataMap = FastMap.newInstance();
	    							productDataMap.put(orderItem.getString("productId"), orderItemList);
	    							listDataMap.put(orderRole.getString("partyId"), productDataMap);
	    						}
	    					}
	    					GenericValue promoSettleItem = delegator.makeValue("PromoSettleItem");
		    				promoSettleItem.set("promoSettleRecordId", promoSettleRecordId);
		    				promoSettleItem.set("orderId", orderId);
		    				promoSettleItem.set("orderItemSeqId", orderItemSeqId);
		    				promoSettleItem.set("statusId", "SETTLE_ITEM_PAY");
		    				toBeStored.add(promoSettleItem);
	    				}
	    			}
	    		}
	    	}
	    	if ("N".equals(strRejectDataLine[0]) && strRejectDataLine.length > 1) {
		        // create list PromoSettleItems
	    		for (int i = 1; i < strRejectDataLine.length; i++) {
	    			String[] lineValues = strRejectDataLine[i].split("\\|SUIBLO\\|");
	    			String orderId = lineValues[0];
	    			String orderItemSeqId = lineValues[1];
	    			String reason = lineValues[2];
	    			if (UtilValidate.isNotEmpty(orderId) && UtilValidate.isNotEmpty(orderItemSeqId)) {
	    				GenericValue orderItem = delegator.findOne("OrderItem", UtilMisc.toMap("orderId", orderId, "orderItemSeqId", orderItemSeqId), false);
	    				if (orderItem != null) {
		    				GenericValue promoSettleItem = delegator.makeValue("PromoSettleItem");
		    				promoSettleItem.set("promoSettleRecordId", promoSettleRecordId);
		    				promoSettleItem.set("orderId", orderId);
		    				promoSettleItem.set("orderItemSeqId", orderItemSeqId);
		    				promoSettleItem.set("statusId", "SETTLE_ITEM_NOT_PAY");
		    				promoSettleItem.set("reason", reason);
		    				toBeStored.add(promoSettleItem);
	    				}
	    			}
	    		}
	    	}
	    	
	    	// insert to PromoSettleGroup and PromoSettleGroupItem
	    	if (UtilValidate.isNotEmpty(listDataMap)) {
	    		for (Map.Entry<String, Object> entry : listDataMap.entrySet()) {
	    			String partyId = entry.getKey();
	    			Map<String, Object> productDataMap = (Map<String, Object>) entry.getValue();
	    			String promoSettleGroupId = delegator.getNextSeqId("PromoSettleGroup");
					Map<String, Object> promoSettleGroupMap = UtilMisc.<String, Object>toMap("promoSettleGroupId", promoSettleGroupId, 
							"promoSettleRecordId", promoSettleRecordId, 
							"partyId", partyId, "statusId", "STLE_GRP_CREATED");
					GenericValue promoSettleGroup = delegator.makeValue("PromoSettleGroup", promoSettleGroupMap);
					toBeStored.add(promoSettleGroup);
					for (Map.Entry<String, Object> entryChild : productDataMap.entrySet()) {
						String productId = entryChild.getKey();
						List<GenericValue> orderItemList = (List<GenericValue>) entryChild.getValue();
						String promoSettleGroupItemId = delegator.getNextSeqId("PromoSettleGroupItem");
						Map<String, Object> promoSettleGroupItemMap = UtilMisc.<String, Object>toMap("promoSettleGroupItemId", promoSettleGroupItemId, 
								"promoSettleGroupId", promoSettleGroupId, "promoSettleGroupType", "PROMOTION", "productId", productId, "statusId", "STLE_GRPIM_CREATED");
						BigDecimal quantitySum = BigDecimal.ZERO;
						BigDecimal amountSum = BigDecimal.ZERO;
						for (GenericValue orderItem : orderItemList) {
							BigDecimal quantity = (BigDecimal) orderItem.get("quantity");
							BigDecimal unitPrice = (BigDecimal) orderItem.get("unitPrice");
							if (quantity.compareTo(BigDecimal.ZERO) > 0) {
								quantitySum = quantitySum.add(quantity);
								amountSum = amountSum.add(quantity.multiply(unitPrice));
							}
						}
						promoSettleGroupItemMap.put("quantityRequired", quantitySum);
						promoSettleGroupItemMap.put("amountRequired", amountSum);
						GenericValue promoSettleGroupItem = delegator.makeValue("PromoSettleGroupItem", promoSettleGroupItemMap);
						toBeStored.add(promoSettleGroupItem);
					}
				}
	    	}
    	} catch (GenericEntityException e) {
    		Debug.logError(e, "Problem with select OrderItem", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                    "DAErrorCouldNotSelectOrderItem (",locale) + e.getMessage() + ").");
    	}
    	try {
            // store line items, etc so that they will be there for the foreign key checks
            delegator.storeAll(toBeStored);
            
            result.put("promoSettleRecordId", promoSettleRecordId);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Problem with promo settlement record storage or reservations", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                    "DAErrorCouldNotCreateOrderWriteError",locale) + e.getMessage() + ").");
        }
    	return result;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqListOrderListCompany(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		Locale locale = (Locale) context.get("locale");
		Security security = ctx.getSecurity();
		
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	//mapCondition.put("agreementId", parameters.get("orderId")[0]);
    	//mapCondition.put("agreementItemSeqId", parameters.get("agreementItemSeqId")[0]);
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	
    	String strViewIndex = (String)parameters.get("pagenum")[0];
    	String strViewSize = (String)parameters.get("pagesize")[0];
    	//String strSortOrder = ((String[])parameters.get("sortorder") != null)?((String)parameters.get("sortorder")[0]):("");
    	//String strSortDataField = ((String[])parameters.get("sortdatafield") != null)?((String)parameters.get("sortdatafield")[0]):("");
    	String strFilterListFields = ((String[])parameters.get("filterListFields") != null)?((String)parameters.get("filterListFields")[0]):("");
    	//String strDictionaryColumns = ((String[])parameters.get("dictionaryColumns") != null)?((String)parameters.get("dictionaryColumns")[0]):("");
    	String strNoConditionsFind = (String) parameters.get("noConditionFind")[0];
    	String strConditionsFind = (String) parameters.get("conditionsFind")[0];
    	//String strServiceName = (String)parameters.get("sname")[0];
    	try {
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		//listIterator = delegator.find("AgreementGeographicalApplic", tmpConditon, null, null, listSortFields, opts);
    		
    		Map<String, Object> tmpResult = dispatcher.runSync("getListStoreByRoleTypeAndUserLogin", UtilMisc.toMap("roleTypeId", "SALES_ADMIN", "userLogin", userLogin));
    		/*
    		<set field="filterDate" type="Timestamp" from-field="parameters.filterDate"/>
			<set field="parameters.roleTypeId" value="SALES_ADMIN"/>
			<service service-name="getListStoreByRoleTypeAndUserLogin" auto-field-map="true" result-map="parameters.resultService"></service>
			<script location="component://delys/webapp/delys/WEB-INF/actions/delys/EmplFilter.groovy"/>
			<script location="component://delys/webapp/delys/WEB-INF/actions/delys/sales/order/OrderListOrigin.groovy" />
			<script location="component://delys/webapp/delys/WEB-INF/actions/order/filterOrder.groovy" />
    		*/
    		if (ServiceUtil.isError(tmpResult)) {
                return tmpResult;
            }
    		List<GenericValue> listStore = (List<GenericValue>) tmpResult.get("listAllStore");
    		
    		String[] facilityIds = parameters.get("facilityId");
    		String facilityId = null;
    		if (UtilValidate.isNotEmpty(facilityIds)) {
    			facilityId = facilityIds[0];
    		}
    		
    		/*//HttpServletRequest request = (HttpServletRequest) parameters.get("request")[0];//context.get("request"); __ORDER_LIST_STATUS__
			OrderListState state = OrderListState.getInstance(request);
			if (UtilValidate.isNotEmpty(state)) {
			state.updateJQ("N", (String) context.get("viewSize"), (String) context.get("viewIndex"));
    		 */
    		List<String> listStatusIdValue = new ArrayList<String>();
    		HttpServletRequest request = (HttpServletRequest) context.get("request");
    		boolean isFilterByStatus = false;
    		if((strFilterListFields != null && !strFilterListFields.isEmpty()) || strNoConditionsFind.equals("N")){
        		if (strFilterListFields == null || strFilterListFields.isEmpty()) strFilterListFields = strConditionsFind; 
        		else strFilterListFields = strConditionsFind + strFilterListFields; 
        		String[] arrField = strFilterListFields.split("\\|OLBIUS\\|");
        		//String tmpGO = "0";
        		// browse list condition statement
        		//|OLBIUS|statusId|SUIBLO|ORDER_APPROVED|SUIBLO|EQUAL|SUIBLO|1
        		//|OLBIUS|statusId|SUIBLO|ORDER_SUPAPPROVED|SUIBLO|EQUAL|SUIBLO|1
        		for(int i = 1; i < arrField.length; i++){
        			String[] arrTmp = arrField[i].split("\\|SUIBLO\\|"); //analyze the condition statement
        			SqlOperator so = SqlOperator.valueOf(arrTmp[2]); // Filter condition: EQUAL, NOT_EQUAL, ...
        			//tmpGO = arrTmp[3]; 								 // Filter Operator
        			Object fieldValue = arrTmp[1].toString(); 		 // Filter value
        			String fieldName = arrTmp[0];					 // Filter name
        			if (SqlOperator.EQUAL.equals(so) && "statusId".equals(fieldName)) {
        				/*name="viewcreated" 	ORDER_CREATED		state.hasStatus('viewcreated')			${uiLabelMap.CommonCreated}
        				name="viewprocessing"	ORDER_PROCESSING	state.hasStatus('viewprocessing')		${uiLabelMap.CommonProcessing}
        				name="viewapproved" 	ORDER_APPROVED		state.hasStatus('viewapproved')			${uiLabelMap.CommonApproved}
        				name="viewsupapproved"  ORDER_SUPAPPROVED	state.hasStatus('viewsupapproved')		${uiLabelMap.DASupApproved}
        			    name="viewsadapproved" 	ORDER_SADAPPROVED	state.hasStatus('viewsadapproved')		${uiLabelMap.DASadApproved}
        			    name="viewnppapproved" 	ORDER_NPPAPPROVED	state.hasStatus('viewnppapproved')		${uiLabelMap.DADistributorApproved}
        			    name="viewhold" 		ORDER_HOLD			state.hasStatus('viewhold')				${uiLabelMap.DAHeld}
        			    name="viewcompleted" 	ORDER_COMPLETED		state.hasStatus('viewcompleted')		${uiLabelMap.CommonCompleted}
        			    name="viewrejected" 	ORDER_REJECTED		state.hasStatus('viewrejected')			${uiLabelMap.CommonRejected}
        			    name="viewcancelled" 	ORDER_CANCELLED		state.hasStatus('viewcancelled')		${uiLabelMap.CommonCancelled}*/
        				if ("ORDER_CREATED".equals(fieldValue)) {
        					listStatusIdValue.add("viewcreated");
						} else if ("ORDER_PROCESSING".equals(fieldValue)) {
        					listStatusIdValue.add("viewprocessing");
						} else if ("ORDER_APPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewapproved");
						} else if ("ORDER_SUPAPPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewsupapproved");
						} else if ("ORDER_SADAPPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewsadapproved");
						} else if ("ORDER_NPPAPPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewnppapproved");
						} else if ("ORDER_HOLD".equals(fieldValue)) {
							listStatusIdValue.add("viewhold");
						} else if ("ORDER_COMPLETED".equals(fieldValue)) {
							listStatusIdValue.add("viewcompleted");
						} else if ("ORDER_REJECTED".equals(fieldValue)) {
							listStatusIdValue.add("viewrejected");
						} else if ("ORDER_CANCELLED".equals(fieldValue)) {
							listStatusIdValue.add("viewcancelled");
						}
        				isFilterByStatus = true;
        			}
        		}
    		}
    		/*if (listStatusIdValue.size() == 0) {
    			listStatusIdValue.add("viewcreated");
				listStatusIdValue.add("viewprocessing");
				listStatusIdValue.add("viewapproved");
				listStatusIdValue.add("viewsupapproved");
				listStatusIdValue.add("viewsadapproved");
				listStatusIdValue.add("viewnppapproved");
				listStatusIdValue.add("viewhold");
				listStatusIdValue.add("viewcompleted");
				listStatusIdValue.add("viewrejected");
				listStatusIdValue.add("viewcancelled");
				isFilterByStatus = true;
    		}*/
    		if (isFilterByStatus) {
    			request.setAttribute("changeStatusAndTypeState", "Y");
    		}
    		
    		if (UtilValidate.isNotEmpty(request)) {
    			OrderListState state = OrderListState.getInstance(request);
    			state.updateJQ(listStatusIdValue, strViewIndex, strViewSize);
    			
    			//check permission for each order type
    			
    			if (!security.hasPermission("DELYS_ORDER_LIST", userLogin)) {
    				Debug.logWarning("**** Security [" + (new Date()).toString() + "]: " + userLogin.get("userLoginId") + " attempt to run manual payment transaction!", module);
    	            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "DATransactionNotAuthorized", locale));
    			}
				
    			//set the page parameters
				//...
				Timestamp filterDate = (Timestamp) context.get("filterDate");
				String isFilterProductStoreId = (String) context.get("isFilterProductStoreId");
				//tmpConditon, null, null, listSortFields, opts);
				List<EntityCondition> conditions = new ArrayList<EntityCondition>();
				conditions.add(tmpConditon);
				conditions.add(EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER"));
				EntityCondition mainCondition = EntityCondition.makeCondition(conditions, EntityOperator.AND);
				listSortFields.add("orderDate DESC");
				if (UtilValidate.isNotEmpty(listStore)) {
					if ("Y".equals(isFilterProductStoreId)) {
						//filter by productStoreId only when filter action from orderSearchOption.ftl file
						String productStoreId = (String) context.get("productStoreId");
						listIterator = state.getListOrdersAdvanceJQ(facilityId, filterDate, delegator, listStore, productStoreId, mainCondition, listSortFields, opts);
					} else {
						listIterator = state.getListOrdersAdvanceJQ(facilityId, filterDate, delegator, listStore, null, mainCondition, listSortFields, opts);
					}
				}
    		}

    		/*state = OrderListState.getInstance(request); state.update(request); context.state = state;
    		// check permission for each order type
    		hasPermission = false;
    		if (security.hasPermission("DELYS_ORDER_LIST", session)) {
    				hasPermission = false; context.hasPermission = hasPermission;
    			    if (state.hasType("view_SALES") || (!(state.hasType("view_SALES")) && !(state.hasType("view_PURCHASE")))) {
    			        hasPermission = true;
    			        salesOrdersCondition = EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER");
    			    }
    			    if (state.hasType("view_PURCHASE") || (!(state.hasType("view_SALES")) && !(state.hasType("view_PURCHASE")))) {
    			        hasPermission = true;
    			        purchaseOrdersCondition = EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "PURCHASE_ORDER");
    			    }
    				context.hasPermission = hasPermission;
    				
    				// set the page parameters
    				viewIndex = request.getParameter("viewIndex") ? Integer.valueOf(request.getParameter("viewIndex")) : 0;
    				viewSize = 1;//request.getParameter("viewSize") ? Integer.valueOf(request.getParameter("viewSize")) : UtilProperties.getPropertyValue("widget", "widget.form.defaultViewSize");
    				context.viewIndex = viewIndex;
    				context.viewSize = viewSize;
    				// get the lookup flag
    				lookupFlag = request.getParameter("lookupFlag");
    				// fields from the service call
    				paramList = request.getAttribute("paramList") ?: "";
    				context.paramList = paramList;
    				if (paramList) {
    					paramIds = paramList.split("&amp;");
    					context.paramIdList = Arrays.asList(paramIds);
    				}
    				
    				isFilterProductStoreId = parameters.isFilterProductStoreId;
    				
    				if (parameters.resultService.responseMessage == "success") {
    					if (isFilterProductStoreId) {
    						//filter by productStoreId only when filter action from orderSearchOption.ftl file
    						orderHeaderList = state.getListOrdersAdvance(facilityId, filterDate, delegator, parameters.resultService.listAllStore, parameters.productStoreId);
    					} else {
    						orderHeaderList = state.getListOrdersAdvance(facilityId, filterDate, delegator, parameters.resultService.listAllStore, null);
    					}
    				}
    				
    				orderListSize = state.getSize();
    				context.orderListSize = orderListSize;
    				context.listSize = orderListSize;
    				context.listSizeDisplay = orderHeaderList.size();
    				lowIndex = request.getAttribute("lowIndex");
    				context.lowIndex = lowIndex;
    				highIndex = request.getAttribute("highIndex");
    				context.highIndex = highIndex;
    				
    				context.orderHeaderList = orderHeaderList;
    				
    				if (parameters.productStoreId == null || (parameters.productStoreId).equals("")){
    					context.productStoreId = "1";
    				} else {
    					context.productStoreId = parameters.productStoreId;
    					productStore = delegator.findOne("ProductStore",
    										UtilMisc.toMap("productStoreId", parameters.productStoreId), false);
    					context.storeName = productStore.get("storeName");							
    				}
    				// a list of order type descriptions
    				ordertypes = delegator.findList("OrderType", null, null, null, null, true);
    				ordertypes.each { type ->
    				    context["descr_" + type.orderTypeId] = type.get("description",locale);
    				}
    				
    				context.filterDate = filterDate;
    			
    		} else {
    			hasPermission = false;
    			context.hasPermission = hasPermission;
    		}	*/
    		//listIterator = delegator.find("OrderHeader", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqListAgreementGeographicalApplic service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqListOrderListCompanyForProposal(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	try {
    		List<EntityCondition> listCondOr = new ArrayList<EntityCondition>();
    		listCondOr.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "ORDER_CREATED"));
    		listCondOr.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "ORDER_APPROVED"));
    		listCondOr.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "ORDER_NPPAPPROVED"));
    		listCondOr.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "ORDER_SUPAPPROVED"));
    		listCondOr.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "ORDER_SADAPPROVED"));
    		listAllConditions.add(EntityCondition.makeCondition(listCondOr, EntityOperator.OR));
    		
    		Map<String, Object> tmpResult = dispatcher.runSync("getListStoreByRoleTypeAndUserLogin", UtilMisc.toMap("roleTypeId", "SALES_ADMIN", "userLogin", userLogin));
    		if (ServiceUtil.isError(tmpResult)) {
                return tmpResult;
            }
    		List<GenericValue> listStore = (List<GenericValue>) tmpResult.get("listAllStore");
    		List<String> productStoreIds = EntityUtil.getFieldListFromEntityList(listStore, "productStoreId", false);
    		if (productStoreIds != null) {
    			listAllConditions.add(EntityCondition.makeCondition("productStoreId", EntityOperator.IN, productStoreIds));
    			listAllConditions.add(EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER"));
        		EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
        		listIterator = delegator.find("OrderHeader", tmpConditon, null, null, listSortFields, opts);
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqListOrderListCompanyForProposal service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqListOrderListSm (DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		Locale locale = (Locale) context.get("locale");
		Security security = ctx.getSecurity();
		
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	
    	String strViewIndex = (String)parameters.get("pagenum")[0];
    	String strViewSize = (String)parameters.get("pagesize")[0];
    	String strFilterListFields = ((String[])parameters.get("filterListFields") != null)?((String)parameters.get("filterListFields")[0]):("");
    	String strNoConditionsFind = (String) parameters.get("noConditionFind")[0];
    	String strConditionsFind = (String) parameters.get("conditionsFind")[0];
    	try {
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		
    		Map<String, Object> tmpResult = dispatcher.runSync("getListStoreByRoleTypeAndUserLogin", UtilMisc.toMap("roleTypeId", "SALES_ADMIN", "userLogin", userLogin));
    		if (ServiceUtil.isError(tmpResult)) {
                return tmpResult;
            }
    		/*List<GenericValue> listStore = (List<GenericValue>) tmpResult.get("listAllStore");
    		
    		String[] facilityIds = parameters.get("facilityId");
    		String facilityId = null;
    		if (UtilValidate.isNotEmpty(facilityIds)) {
    			facilityId = facilityIds[0];
    		}*/
    		
    		List<String> listStatusIdValue = new ArrayList<String>();
    		HttpServletRequest request = (HttpServletRequest) context.get("request");
    		boolean isFilterByStatus = false;
    		if((strFilterListFields != null && !strFilterListFields.isEmpty()) || strNoConditionsFind.equals("N")){
        		if (strFilterListFields == null || strFilterListFields.isEmpty()) strFilterListFields = strConditionsFind; 
        		else strFilterListFields = strConditionsFind + strFilterListFields; 
        		String[] arrField = strFilterListFields.split("\\|OLBIUS\\|");
        		//String tmpGO = "0";
        		// browse list condition statement
        		for(int i = 1; i < arrField.length; i++){
        			String[] arrTmp = arrField[i].split("\\|SUIBLO\\|"); //analyze the condition statement
        			SqlOperator so = SqlOperator.valueOf(arrTmp[2]); // Filter condition: EQUAL, NOT_EQUAL, ...
        			//tmpGO = arrTmp[3]; 								 // Filter Operator
        			Object fieldValue = arrTmp[1].toString(); 		 // Filter value
        			String fieldName = arrTmp[0];					 // Filter name
        			if (SqlOperator.EQUAL.equals(so) && "statusId".equals(fieldName)) {
        				if ("ORDER_CREATED".equals(fieldValue)) {
        					listStatusIdValue.add("viewcreated");
						} else if ("ORDER_PROCESSING".equals(fieldValue)) {
        					listStatusIdValue.add("viewprocessing");
						} else if ("ORDER_APPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewapproved");
						} else if ("ORDER_SUPAPPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewsupapproved");
						} else if ("ORDER_SADAPPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewsadapproved");
						} else if ("ORDER_NPPAPPROVED".equals(fieldValue)) {
							listStatusIdValue.add("viewnppapproved");
						} else if ("ORDER_HOLD".equals(fieldValue)) {
							listStatusIdValue.add("viewhold");
						} else if ("ORDER_COMPLETED".equals(fieldValue)) {
							listStatusIdValue.add("viewcompleted");
						} else if ("ORDER_REJECTED".equals(fieldValue)) {
							listStatusIdValue.add("viewrejected");
						} else if ("ORDER_CANCELLED".equals(fieldValue)) {
							listStatusIdValue.add("viewcancelled");
						}
        				isFilterByStatus = true;
        			}
        		}
    		}
    		if (isFilterByStatus) {
    			request.setAttribute("changeStatusAndTypeState", "Y");
    		}
    		
    		if (UtilValidate.isNotEmpty(request)) {
    			OrderListState state = OrderListState.getInstanceSecond(request);
    			state.updateJQ(listStatusIdValue, strViewIndex, strViewSize);
    			
    			//check permission for each order type
    			if (!security.hasPermission("DELYS_ORDER_LIST", userLogin)) {
    				Debug.logWarning("**** Security [" + (new Date()).toString() + "]: " + userLogin.get("userLoginId") + " attempt to run manual payment transaction!", module);
    	            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "DATransactionNotAuthorized", locale));
    			}
				
    			//set the page parameters
				//...
				//Timestamp filterDate = (Timestamp) context.get("filterDate");
				//String isFilterProductStoreId = (String) context.get("isFilterProductStoreId");
				//tmpConditon, null, null, listSortFields, opts);
				List<EntityCondition> conditions = new ArrayList<EntityCondition>();
				conditions.add(tmpConditon);
				conditions.add(EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER"));
				EntityCondition mainCondition = EntityCondition.makeCondition(conditions, EntityOperator.AND);
				listSortFields.add("orderDate DESC");

				listIterator = state.getListOrdersSmJQ(delegator, userLogin, mainCondition, listSortFields, opts);
    		}

    		//listIterator = delegator.find("OrderHeader", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqListAgreementGeographicalApplic service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListProductSelected(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	/*Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("sellerRoleTypeId", "DELYS_DISTRIBUTOR");
    	mapCondition.put("promoSettleRecordId", null);
    	mapCondition.put("orderStatusId", "ORDER_COMPLETED");
    	mapCondition.put("itemStatusId", "ITEM_COMPLETED");
    	EntityCondition tmpConditonPre = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditonPre);*/
    	if (UtilValidate.isNotEmpty(parameters)) {
    		if (parameters.containsKey("dataSelected[]")) {
    			//String[] dataSelected = (String[]) parameters.get("dataSelected[]");
    			
    			//priceToDist
    			//priceToMarket
    			//priceToConsumer
    			
    			try {
    				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    				listIterator = delegator.find("OrderHeaderItemsPromosAndRoleAndSettle", tmpConditon, null, null, listSortFields, opts);
    			} catch (Exception e) {
    				String errMsg = "Fatal error calling jqGetListProductByCategoryCatalog service: " + e.toString();
    				Debug.logError(e, errMsg, module);
    			}
    		}
    	}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListOrderItem(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		//List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	//List<String> listSortFields = (List<String>) context.get("listSortFields");
    	//EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String orderId = "";
    	if (parameters.containsKey("orderId")) {
    		orderId = (String) parameters.get("orderId")[0];
    	}
    	try {
    		if (UtilValidate.isNotEmpty(orderId)) {
    			List<GenericValue> orderItems = new ArrayList<GenericValue>();
    			if (UtilValidate.isNotEmpty(orderId)) {
    				GenericValue orderHeader = delegator.findOne("OrderHeader", UtilMisc.toMap("orderId", orderId), false);
    				if (orderHeader != null) {
    					orderItems = delegator.findByAnd("OrderItemAndShipGroupAssoc", UtilMisc.toMap("orderId", orderId), null, false);
    					if (orderItems != null) {
    						// load products in order
    						for (GenericValue orderItem : orderItems) {
    							Map<String, Object> row = new HashMap<String, Object>();
        	    				/* [{ name: 'productId', type: 'string' }, { name: 'productName', type: 'string' },
    		               		{ name: 'quantityUomId', type: 'string'}, { name: 'productPackingUomId', type: 'string'},
    		               		{ name: 'expireDate', type: 'string' }, { name: 'quantity', type: 'number', formatter: 'integer'} */
    							GenericValue product = orderItem.getRelatedOne("Product", false);
    							if (product != null) {
    								row.put("shipGroupSeqId", orderItem.get("shipGroupSeqId"));
    								row.put("orderItemSeqId", orderItem.get("orderItemSeqId"));
    								row.put("productId", orderItem.get("productId"));
            	    				row.put("productName", product.get("productName"));
            	    				row.put("productPackingUomId", product.get("productPackingUomId"));
            	    				row.put("quantityUomId", product.getString("quantityUomId"));
            	    				row.put("quantity", orderItem.get("quantity"));
            	    				
            	    				// column: packingUomId
            	    				EntityCondition condsItem = EntityCondition.makeCondition(UtilMisc.toMap("productId", product.get("productId"), "uomToId", product.get("quantityUomId")));
            	    				EntityFindOptions optsItem = new EntityFindOptions();
            	    				optsItem.setDistinct(true);
            	    				List<GenericValue> listConfigPacking = FastList.newInstance();
            	    				listConfigPacking.addAll(delegator.findList("ConfigPackingAndUom", condsItem, null, null, optsItem, false));
        	    					List<Map<String, Object>> listQuantityUomIdByProduct = new ArrayList<Map<String, Object>>();
        	    					//List<String> listTmp = EntityUtil.getFieldListFromEntityList(listConfigPacking, "uomFromId", true);
        	    					//if (listTmp != null) listQuantityUomIdByProduct.addAll(listTmp);
        	    					//listQuantityUomIdByProduct.add(itemProd.getString("quantityUomId"));
            						for (GenericValue conPackItem : listConfigPacking) {
            							Map<String, Object> packingUomIdMap = FastMap.newInstance();
            							packingUomIdMap.put("description", conPackItem.getString("descriptionFrom"));
            							packingUomIdMap.put("uomId", conPackItem.getString("uomFromId"));
            							listQuantityUomIdByProduct.add(packingUomIdMap);
        	    					}
            						GenericValue quantityUom = delegator.findOne("Uom", UtilMisc.toMap("uomId", product.get("quantityUomId")), false);
            						if (quantityUom != null) {
            							Map<String, Object> packingUomIdMap = FastMap.newInstance();
            							packingUomIdMap.put("description", quantityUom.getString("description"));
            							packingUomIdMap.put("uomId", quantityUom.getString("uomId"));
            							listQuantityUomIdByProduct.add(packingUomIdMap);
            						}
            	    				row.put("packingUomId", listQuantityUomIdByProduct);
            	    				
            	    				// column: expireDate
            	    				List<Map<String, Object>> listExpireDateByProduct = new ArrayList<Map<String,Object>>();
            	    				List<EntityCondition> exConds = FastList.newInstance();
            	    				exConds.add(EntityCondition.makeCondition("productStoreId", orderHeader.get("productStoreId")));
            	    				exConds.add(EntityCondition.makeCondition("productId", product.getString("productId")));
            	    				// productStoreId, fromDate, thruDate, productId, statusId, expireDate, uomId, quantityOnHandTotal, availableToPromiseTotal
            	    				EntityListIterator iterQuantityInventorySum = delegator.find("ProductStoreFacilityInventorySumAtpqoh", EntityCondition.makeCondition(exConds, EntityOperator.AND), EntityCondition.makeCondition("quantityOnHandTotal", EntityOperator.GREATER_THAN, BigDecimal.ZERO), null, null, null);
            	    				if (iterQuantityInventorySum != null) {
            	    					List<GenericValue> listQuantityInventorySum = iterQuantityInventorySum.getCompleteList();
            	    					if (listQuantityInventorySum != null) {
            	    						listQuantityInventorySum = EntityUtil.filterByDate(listQuantityInventorySum);
            	    						for (GenericValue quantityInventoryItem : listQuantityInventorySum) {
            	    							Map<String, Object> mapItem = FastMap.newInstance();
            	    							mapItem.put("expireDate", quantityInventoryItem.getString("expireDate"));
            	    							mapItem.put("qohTotal", quantityInventoryItem.get("quantityOnHandTotal"));
            	    							mapItem.put("atpTotal", quantityInventoryItem.get("availableToPromiseTotal"));
            	    							listExpireDateByProduct.add(mapItem);
            	    						}
            	    					}
            	    					iterQuantityInventorySum.close();
            	    				}
            	    				row.put("expireDateList", listExpireDateByProduct);
            	    				
            	    				// columns: quantityUomId, quantity, expireDate
            	    				row.put("expireDate", "");
            	    				if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(orderItem.getString("productId"))) {
    	    							row.put("quantityUomId", orderItem.getString("quantityUomId"));
    	    							if (orderItem.get("alternativeQuantity") != null) row.put("quantity", orderItem.get("alternativeQuantity"));
    	    							row.put("expireDate", orderItem.getString("expireDate"));
									}
            	    				
            	    				row.put("qohTotal", "");
            	    				row.put("atpTotal", "");
            	    				listIterator.add(row);
    							}
    						}
    					}
    				}
    			}
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListOrderItem service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	
		successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListProductByCatalogAndStore(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String catalogId = (String) parameters.get("catalogId")[0];
    	String productStoreId = (String) parameters.get("productStoreId")[0];
    	try {
    		if (UtilValidate.isNotEmpty(catalogId) && UtilValidate.isNotEmpty(productStoreId)) {
    			GenericValue catalogObj = delegator.findOne("ProdCatalog", UtilMisc.toMap("prodCatalogId", catalogId), false);
    			if (catalogObj != null) {
    				List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> orConditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> mainConditionList = new ArrayList<EntityCondition>();
    	    		// do not include configurable products
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED_SERVICE"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGR_DIGSERV"));
    				conditionList.add(EntityCondition.makeCondition("prodCatalogId", EntityOperator.EQUALS, catalogId));
    				EntityCondition conditions = EntityCondition.makeCondition(conditionList, EntityOperator.AND);
    				// no virtual products: note that isVirtual could be null,
    				// we consider those products to be non-virtual and hence addable to the order in bulk
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, "N"));
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, null));
    				EntityCondition orConditions = EntityCondition.makeCondition(orConditionList, EntityOperator.OR);
    				mainConditionList.add(orConditions);
    				mainConditionList.add(conditions);
    	    		//delegator.findList("ProdCatalogCategoryAndProduct", mainConditions, ["productId", "brandName", "internalName"] as Set, ["productId"], null, false);
    				listAllConditions.addAll(mainConditionList);
    				
    				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    				if (UtilValidate.isEmpty(listSortFields)) {
    					listSortFields.add("sequenceNumCategory");
    					listSortFields.add("sequenceNumRollup");
    					listSortFields.add("sequenceNumProduct");
    				}
    				
    				List<GenericValue> listProdGeneric = delegator.findList("ProdCatalogCategoryAndProduct", tmpConditon, null, listSortFields, opts, false);
    	    		if (UtilValidate.isNotEmpty(listProdGeneric)) {
    	    			for (GenericValue itemProd : listProdGeneric) {
    	    				Map<String, Object> row = new HashMap<String, Object>();
    	    				row.put("productId", itemProd.get("productId"));
    	    				row.put("productName", itemProd.get("productName"));
    	    				row.put("productPackingUomId", itemProd.get("productPackingUomId"));
    	    				row.put("quantityUomId", itemProd.getString("productPackingUomId"));
    	    				
    	    				// column: packingUomId
    	    				EntityCondition condsItem = EntityCondition.makeCondition(UtilMisc.toMap("productId", itemProd.get("productId"), "uomToId", itemProd.get("quantityUomId")));
    	    				EntityFindOptions optsItem = new EntityFindOptions();
    	    				optsItem.setDistinct(true);
    	    				List<GenericValue> listConfigPacking = FastList.newInstance();
    	    				listConfigPacking.addAll(delegator.findList("ConfigPackingAndUom", condsItem, null, null, optsItem, false));
	    					List<Map<String, Object>> listQuantityUomIdByProduct = new ArrayList<Map<String, Object>>();
    						for (GenericValue conPackItem : listConfigPacking) {
    							Map<String, Object> packingUomIdMap = FastMap.newInstance();
    							packingUomIdMap.put("description", conPackItem.getString("descriptionFrom"));
    							packingUomIdMap.put("uomId", conPackItem.getString("uomFromId"));
    							listQuantityUomIdByProduct.add(packingUomIdMap);
	    					}
    						GenericValue quantityUom = delegator.findOne("Uom", UtilMisc.toMap("uomId", itemProd.get("quantityUomId")), false);
    						if (quantityUom != null) {
    							Map<String, Object> packingUomIdMap = FastMap.newInstance();
    							packingUomIdMap.put("description", quantityUom.getString("description"));
    							packingUomIdMap.put("uomId", quantityUom.getString("uomId"));
    							listQuantityUomIdByProduct.add(packingUomIdMap);
    						}
    	    				row.put("packingUomId", listQuantityUomIdByProduct);
    	    				
    	    				// column: expireDate
    	    				List<Map<String, Object>> listExpireDateByProduct = new ArrayList<Map<String,Object>>();
    	    				List<EntityCondition> exConds = FastList.newInstance();
    	    				exConds.add(EntityCondition.makeCondition("productStoreId", productStoreId));
    	    				exConds.add(EntityCondition.makeCondition("productId", itemProd.getString("productId")));
    	    				// productStoreId, fromDate, thruDate, productId, statusId, expireDate, uomId, quantityOnHandTotal, availableToPromiseTotal
    	    				EntityListIterator iterQuantityInventorySum = delegator.find("ProductStoreFacilityInventorySumAtpqoh", EntityCondition.makeCondition(exConds, EntityOperator.AND), EntityCondition.makeCondition("quantityOnHandTotal", EntityOperator.GREATER_THAN, BigDecimal.ZERO), null, null, null);
    	    				if (iterQuantityInventorySum != null) {
    	    					List<GenericValue> listQuantityInventorySum = iterQuantityInventorySum.getCompleteList();
    	    					if (listQuantityInventorySum != null) {
    	    						listQuantityInventorySum = EntityUtil.filterByDate(listQuantityInventorySum);
    	    						for (GenericValue quantityInventoryItem : listQuantityInventorySum) {
    	    							Map<String, Object> mapItem = FastMap.newInstance();
    	    							mapItem.put("expireDate", quantityInventoryItem.getString("expireDate"));
    	    							mapItem.put("qohTotal", quantityInventoryItem.get("quantityOnHandTotal"));
    	    							mapItem.put("atpTotal", quantityInventoryItem.get("availableToPromiseTotal"));
    	    							listExpireDateByProduct.add(mapItem);
    	    						}
    	    					}
    	    					iterQuantityInventorySum.close();
    	    				}
    	    				row.put("expireDateList", listExpireDateByProduct);
    	    				
    	    				/*<#-- NOTE: Delivered for serialized inventory means shipped to customer so they should not be displayed here any more -->
		            		<#assign productInventoryItems = delegator.findByAnd("InventoryItemFilterAtpQoh", {"productId" : productId}, ['facilityId', '-datetimeReceived', '-inventoryItemId'], false) />
		            		<#if productInventoryItems?exists && productInventoryItems?has_content && productInventoryItems?size &gt; 0>
		            			<select name="fromInventoryItemId_${cartLineIndex}" style="width:150px; margin-bottom:0px">
		            				<option value=""></option>
			            			<#list productInventoryItems as inventoryItem>
			            				<#if inventoryItem.inventoryItemTypeId?if_exists == "NON_SERIAL_INV_ITEM">
											<#if inventoryItem.curInventoryItemTypeId?exists>
					            				<option value="${(inventoryItem.inventoryItemId)?if_exists}" 
					            					<#if cartLine.getAttribute("fromInventoryItemId")?exists && cartLine.getAttribute("fromInventoryItemId") == inventoryItem.inventoryItemId>selected="selected"</#if>>
					            					<#if inventoryItem.expireDate?exists>${(inventoryItem.expireDate)?string("dd/MM/yyyy")}
					            					<#else>__/__/____</#if>
					            					, 
					            					<#if inventoryItem.inventoryItemTypeId?if_exists == "NON_SERIAL_INV_ITEM">
														${(inventoryItem.availableToPromiseTotal)?default("NA")}
														/ ${(inventoryItem.quantityOnHandTotal)?default("NA")}
													</#if>
													,
				            					 	<#if inventoryItem.facilityId?exists>
					            					 	${inventoryItem.facilityId}
				            					 	<#else>
					            					 	<#if inventoryItem.containerId?exists>
					            					 		${inventoryItem.containerId}
					            					 	</#if>
				            					 	</#if>
				            					 	
					            				</option>
				            				</#if>
			            				</#if>
			            			</#list>
			            		</select>
			            	<#else>
			            		<select name="fromInventoryItemId" style="width:150px; margin-bottom:0px" disabled>
		            				<option value=""></option>
		            			</select>
		            		</#if>
    	    				 */
    	    				
    	    				// columns: quantityUomId, quantity, expireDate
    	    				row.put("expireDate", "");
    	    				row.put("qohTotal", "");
    	    				row.put("atpTotal", "");
    	    				listIterator.add(row);
    	    			}
    	    		}
    			}
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductByCategoryCatalogLM service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	
		successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    public static Map<String, Object> createExhibitedAgreement(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	TimeZone timeZone = (TimeZone) context.get("timeZone");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	LocalDispatcher dispatcher = ctx.getDispatcher();
    	Locale locale = (Locale) context.get("locale");
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	String productPromoRegisterId = (String) context.get("productPromoRegisterId");
    	if (UtilValidate.isEmpty(productPromoRegisterId)) {
    		return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DARegisterIdCannotBeEmpty", locale));
    	}
    	try {
    		GenericValue productPromoRegister = delegator.findOne("ProductPromoRegister", UtilMisc.toMap("productPromoRegisterId", productPromoRegisterId), false);
    		if (UtilValidate.isEmpty(productPromoRegister)) {
    			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAThisRegisterNotAvaiable", locale));
    		}
    		
    		Map<String, Object> contextMap = ServiceUtil.setServiceFields(dispatcher, "createAgreement", context, userLogin, timeZone, locale);
			if (contextMap != null) {
				Map<String, Object> resultService = dispatcher.runSync("createAgreement", contextMap);
				if (ServiceUtil.isError(resultService)) {
    	            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DACreateAgreementNotSuccessful", locale));
				}
				String agreementId = (String) resultService.get("agreementId");
				
				// create agreement item
				String currencyUomId = EntityUtilProperties.getPropertyValue("general.properties", "currency.uom.id.default", "USD", delegator);
				String agreementText = UtilProperties.getMessage("DelysAdminUiLabels", "DAExhibitedPromotion", locale);
				Map<String, Object> resultService0 = dispatcher.runSync("createAgreementItem", UtilMisc.toMap("agreementId", agreementId, "agreementItemTypeId", "AGREEMENT_EXHIBIT", 
						"currencyUomId", currencyUomId, "agreementText", agreementText, "userLogin", userLogin));
				if (ServiceUtil.isError(resultService0)) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DACreateAgreementNotSuccessful", locale));
				}
				String agreementItemSeqId = (String) resultService0.get("agreementItemSeqId");
				dispatcher.runSync("createAgreementPromoAppl", UtilMisc.toMap("agreementId", agreementId, "agreementItemSeqId", agreementItemSeqId, 
						"productPromoId", productPromoRegister.get("productPromoId"), "fromDate", context.get("fromDate"), "userLogin", userLogin));
				
				// create agreement term
				List<GenericValue> allTerm = EmploymentServices.getAllTerm(ctx, "PROMO_EXHIBITED_TERM");
				if (allTerm != null) {
					for(GenericValue termType: allTerm){
						String termTypeId = termType.getString("termTypeId");
						// check whether text value of term type pass from context
						//String textValue0 = (String)context.get(termTypeId);
						// get defaultValue of termType's textValue
						// GenericValue termTypeAttr = delegator.findOne("TermTypeAttr", UtilMisc.toMap("termTypeId", termTypeId, "attrName", "defaultValue"), false);
						
						// get defaultValues of termType's textValue
						List<GenericValue> termTypeAttrs = FastList.newInstance();
						List<EntityCondition> listCond = FastList.newInstance();
						listCond.add(EntityCondition.makeCondition("termTypeId", termTypeId));
						listCond.add(EntityCondition.makeCondition("attrName", EntityOperator.LIKE, "defaultValue%"));
						EntityFindOptions findOpts = new EntityFindOptions();
						findOpts.setDistinct(true);
						termTypeAttrs = delegator.findList("TermTypeAttr", EntityCondition.makeCondition(listCond), null, UtilMisc.toList("attrName"), findOpts, false);
						if (termTypeAttrs != null) {
							for (GenericValue termTypeAttr : termTypeAttrs) {
								String textValue = termTypeAttr.getString("attrValue");
								/*if(textValue == null && termTypeAttr != null){
									textValue = termTypeAttr.getString("attrValue");
								}*/
								if(textValue != null){
									dispatcher.runSync("createAgreementTermHR", UtilMisc.toMap("agreementId", agreementId, "textValue", textValue, "termTypeId", termTypeId, 
														"fromDate", context.get("fromDate"), "thruDate", context.get("thruDate"), "userLogin", userLogin));
								}
							}
						}
					}
				}
				
				// create agreement role
				String partyToId = (String) context.get("partyToId");
				// get SUP of partyToId
				String supPartyId = getSUPByStoreCustomerId(ctx, partyToId);
				if (supPartyId != null) {
					dispatcher.runSync("createAgreementRole", UtilMisc.toMap("agreementId", agreementId, "partyId", supPartyId, "roleTypeId", "DELYS_SALESSUP_GT"));
				}
				
				// store agreementId to register
				productPromoRegister.put("agreementId", agreementId);
				delegator.store(productPromoRegister);
			}
		} catch (GeneralServiceException e) {
			String errMsg = "Fatal error calling createExhibitedAgreement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		} catch (GenericServiceException e) {
			String errMsg = "Fatal error calling createAgreement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error when get data in ProductPromoRegister entity: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	
    	return successResult;
    }
    
    public static String getSUPByStoreCustomerId (DispatchContext ctx, String storeCustomerId) {
    	String supPartyId = null;
    	Delegator delegator = ctx.getDelegator();
    	try {
	    	GenericValue distributor = EntityUtil.getFirst(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdTo", storeCustomerId, "roleTypeIdFrom", "DELYS_DISTRIBUTOR", 
	    			"roleTypeIdTo", "DELYS_CUSTOMER_GT", "partyRelationshipTypeId", "CUSTOMER"), null, false));
	    	if (UtilValidate.isNotEmpty(distributor)) {
	    		String distributorId = (String) distributor.get("partyIdFrom");
	    		GenericValue supPosition = EntityUtil.getFirst(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdTo", distributorId, "roleTypeIdFrom", "DELYS_SALESSUP_GT", 
		    			"roleTypeIdTo", "DELYS_DISTRIBUTOR", "partyRelationshipTypeId", "GROUP_ROLLUP"), null, false));
	    		if (UtilValidate.isNotEmpty(supPosition)) {
	    			GenericValue supParty = EntityUtil.getFirst(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdTo", supPosition.get("partyIdFrom"), "roleTypeIdFrom", "MANAGER", 
			    			"roleTypeIdTo", "INTERNAL_ORGANIZATIO", "partyRelationshipTypeId", "MANAGER"), null, false));
	    			if (UtilValidate.isNotEmpty(supParty)) {
	    				supPartyId = (String) supParty.get("partyIdFrom");
	    			}
	    		}
	    	}
	    } catch (GenericEntityException e) {
			String errMsg = "Fatal error when get data in getSUPByStoreCustomerId method: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	return supPartyId;
    }
    

    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListRequirement(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			if (parameters.containsKey("requirementTypeId") && UtilValidate.isNotEmpty(parameters.get("requirementTypeId"))) {
				String requirementTypeId = parameters.get("requirementTypeId")[0];
				if (UtilValidate.isNotEmpty(requirementTypeId)) {
					listAllConditions.add(EntityCondition.makeCondition("requirementTypeId", requirementTypeId));
				}
			}
			/*if (SecurityUtil.hasRole("DELYS_SALESADMIN_GT", (String) userLogin.get("partyId"), delegator)) {
				newStatus = "REG_PROMO_ACCEPTED";
			} else if (SecurityUtil.hasRole("DELYS_ASM_GT", (String) userLogin.get("partyId"), delegator)) {
				newStatus = "REGPR_ASM_ACCEPTED";
			} else if (SecurityUtil.hasRole("DELYS_SALESSUP_GT", (String) userLogin.get("partyId"), delegator)) {
				newStatus = "REGPR_SUP_ACCEPTED";
			}*/
			boolean isDistributor = false;
			//List<GenericValue> userLoginRole = delegator.findByAnd("PartyRole", UtilMisc.toMap("partyId", userLogin.get("partyId"), "roleTypeId", "DELYS_DISTRIBUTOR"), null, false);
			if (SalesPartyUtil.isDistributor(userLogin, delegator)) {
				isDistributor = true;
			}
			if (isDistributor) {
				listAllConditions.add(EntityCondition.makeCondition("partyId", userLogin.get("partyId")));
				listAllConditions.add(EntityCondition.makeCondition("roleTypeId", "DELYS_DISTRIBUTOR"));
				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
				listIterator = delegator.find("RequirementAndRole", tmpConditon, null, null, listSortFields, opts);
			} else {
				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
				listIterator = delegator.find("Requirement", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListRequirement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListRequirementSentToCompany(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			if (parameters.containsKey("requirementTypeId") && UtilValidate.isNotEmpty(parameters.get("requirementTypeId"))) {
				String requirementTypeId = parameters.get("requirementTypeId")[0];
				if (UtilValidate.isNotEmpty(requirementTypeId)) {
					listAllConditions.add(EntityCondition.makeCondition("requirementTypeId", requirementTypeId));
				}
			}
			/*if (SecurityUtil.hasRole("DELYS_SALESADMIN_GT", (String) userLogin.get("partyId"), delegator)) {
				newStatus = "REG_PROMO_ACCEPTED";
			} else if (SecurityUtil.hasRole("DELYS_ASM_GT", (String) userLogin.get("partyId"), delegator)) {
				newStatus = "REGPR_ASM_ACCEPTED";
			} else if (SecurityUtil.hasRole("DELYS_SALESSUP_GT", (String) userLogin.get("partyId"), delegator)) {
				newStatus = "REGPR_SUP_ACCEPTED";
			}*/
			if (UtilValidate.isNotEmpty(userLogin)) {
				if (SalesPartyUtil.isDistributor(userLogin, delegator)) {
					listAllConditions.add(EntityCondition.makeCondition("partyId", userLogin.get("partyId")));
					listAllConditions.add(EntityCondition.makeCondition("roleTypeId", "DELYS_DISTRIBUTOR"));
				} else {
					String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
					listAllConditions.add(EntityCondition.makeCondition("partyId", companyId));
					listAllConditions.add(EntityCondition.makeCondition("roleTypeId", "INTERNAL_ORGANIZATIO"));
					if (SalesPartyUtil.isSupervisorEmployee(userLogin, delegator)) {
						listAllConditions.add(EntityCondition.makeCondition("createdByUserLogin", userLogin.get("userLoginId")));
					}
				}
				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
				listIterator = delegator.find("RequirementAndRole", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListRequirementSentToCompany service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListCustomerBySup(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<GenericValue> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	listAllConditions.add(condStatusPartyDisable);
    	
    	String partyId = null;
    	opts.setDistinct(true);
    	try {
    		// get list distributor
        	if (parameters.containsKey("supPartyId") && UtilValidate.isNotEmpty(parameters.get("supPartyId"))) {
				partyId = parameters.get("supPartyId")[0];
        	}
        	if (UtilValidate.isEmpty(partyId)) {
        		partyId = userLogin.getString("partyId");
        	}
        	Map<String, String> mapCondition1 = new HashMap<String, String>();
        	mapCondition1.put("partyIdFrom", partyId);
        	mapCondition1.put("partyRelationshipTypeId", "MANAGER");
        	mapCondition1.put("roleTypeId", "INTERNAL_ORGANIZATIO");
        	mapCondition1.put("roleTypeIdTo", "INTERNAL_ORGANIZATIO");
        	EntityCondition tmpConditon1 = EntityCondition.makeCondition(mapCondition1);
        	List<EntityCondition> listConds1 = FastList.newInstance();
        	listConds1.add(condStatusPartyDisable);
        	listConds1.add(tmpConditon1);
        	
        	GenericValue listSupPosition = EntityUtil.getFirst(EntityUtil.filterByDate(delegator.findList("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds1, EntityOperator.AND), null, null, opts, false)));
        	if (listSupPosition != null) {
        		Map<String, String> mapCondition2 = new HashMap<String, String>();
            	mapCondition2.put("partyIdFrom", listSupPosition.getString("partyId"));
            	mapCondition2.put("partyRelationshipTypeId", "GROUP_ROLLUP");
            	mapCondition2.put("roleTypeId", "DELYS_DISTRIBUTOR");
            	mapCondition2.put("roleTypeIdTo", "DELYS_DISTRIBUTOR");
            	EntityCondition tmpConditon2 = EntityCondition.makeCondition(mapCondition2);
            	List<EntityCondition> listConds2 = FastList.newInstance();
            	listConds2.add(condStatusPartyDisable);
            	listConds2.add(tmpConditon2);
            	
            	List<GenericValue> listDistributor = EntityUtil.filterByDate(delegator.findList("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds2, EntityOperator.AND), null, null, opts, false));
            	if (UtilValidate.isNotEmpty(listDistributor)) {
            		for (GenericValue distributor : listDistributor) {
            			Map<String, String> mapCondition3 = new HashMap<String, String>();
                    	mapCondition3.put("partyIdFrom", distributor.getString("partyId"));
                    	mapCondition3.put("partyRelationshipTypeId", "CUSTOMER");
                    	mapCondition3.put("roleTypeId", "DELYS_CUSTOMER_GT");
                    	mapCondition3.put("roleTypeIdTo", "DELYS_CUSTOMER_GT");
                    	EntityCondition tmpConditon3 = EntityCondition.makeCondition(mapCondition3);
                    	List<EntityCondition> listConds3 = FastList.newInstance();
                    	listConds3.add(condStatusPartyDisable);
                    	listConds3.add(tmpConditon3);
                    	listConds3.addAll(listAllConditions);
            			List<GenericValue> listCustomer = EntityUtil.filterByDate(delegator.findList("PartyRoleNameDetailPartyRelTo", EntityCondition.makeCondition(listConds3, EntityOperator.AND), null, listSortFields, opts, false));
            			if (UtilValidate.isNotEmpty(listCustomer)) {
            				listIterator.addAll(listCustomer);
            			}
            		}
            	}
        	}
        	// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
        	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
        	/*
        	Map<String, String> mapCondition = new HashMap<String, String>();
	    	mapCondition.put("partyIdFrom", userLogin.getString("partyId"));
	    	mapCondition.put("partyRelationshipTypeId", "CUSTOMER");
	    	mapCondition.put("roleTypeId", "DELYS_CUSTOMER_GT");
	    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
	    	listAllConditions.add(tmpConditon);
	    	*/
    		//tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		//listIterator = delegator.find("PartyRoleNameDetailPartyRelTo", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListCustomerBySup service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListDistributorByCustomer(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	//List<GenericValue> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	listAllConditions.add(condStatusPartyDisable);
    	
    	String partyId = null;
    	String noUserlogin = null;
    	opts.setDistinct(true);
    	try {
    		// get list distributor
        	if (parameters.containsKey("customerId") && UtilValidate.isNotEmpty(parameters.get("customerId"))) {
				partyId = parameters.get("customerId")[0];
        	}
        	if (parameters.containsKey("noUserlogin") && UtilValidate.isNotEmpty(parameters.get("noUserlogin"))) {
        		noUserlogin = parameters.get("noUserlogin")[0];
        	}
        	if (UtilValidate.isEmpty(partyId) && UtilValidate.isEmpty(noUserlogin)) {
        		partyId = userLogin.getString("partyId");
        	}
        	// <PartyRelationship partyIdFrom="NPP_TUANMINH" partyIdTo="CUSTOMER1" roleTypeIdFrom="DELYS_DISTRIBUTOR" roleTypeIdTo="DELYS_CUSTOMER_GT" 
        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="CUSTOMER"/>
        	
        	Map<String, String> mapCondition = new HashMap<String, String>();
	    	mapCondition.put("partyIdTo", partyId);
	    	mapCondition.put("partyRelationshipTypeId", "CUSTOMER");
	    	mapCondition.put("roleTypeId", "DELYS_DISTRIBUTOR");
	    	mapCondition.put("roleTypeIdFrom", "DELYS_DISTRIBUTOR");
	    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
	    	listAllConditions.add(tmpConditon);
	    	listAllConditions.add(EntityUtil.getFilterByDateExpr());
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		listIterator = delegator.find("PartyRoleNameDetailPartyRelFrom", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListDistributorByCustomer service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListDistributorBySupervisor(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	//List<GenericValue> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	
    	List<EntityCondition> exprList = new ArrayList<EntityCondition>();
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "PARTY_DISABLED"));
    	exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, null));
    	List<EntityCondition> exprList2 = new ArrayList<EntityCondition>();
    	exprList2.add(EntityCondition.makeCondition(exprList, EntityOperator.AND));
    	exprList2.add(EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, null));
    	EntityCondition condStatusPartyDisable = EntityCondition.makeCondition(exprList2, EntityOperator.OR);
    	listAllConditions.add(condStatusPartyDisable);
    	
    	String partyId = null;
    	opts.setDistinct(true);
    	try {
    		// get list distributor
        	if (parameters.containsKey("supPartyId") && UtilValidate.isNotEmpty(parameters.get("supPartyId"))) {
				partyId = parameters.get("supPartyId")[0];
        	}
        	if (UtilValidate.isEmpty(partyId)) {
        		partyId = userLogin.getString("partyId");
        	}
        	listIterator = SalesPartyUtil.getListDistributorActiveBySupervisor(partyId, listSortFields, listAllConditions, opts, delegator);
        	
        	// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
        	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListDistributorBySupervisor service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    // Get the postal addresses of the party
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetPartyPostalAddresses(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	String partyId = null;
    	/*Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("partyIdTo", partyId);*/
    	try {
    		// get list distributor
        	if (parameters.containsKey("partyId") && UtilValidate.isNotEmpty(parameters.get("partyId"))) partyId = parameters.get("partyId")[0];
        	if (UtilValidate.isNotEmpty(partyId)) {
        		listAllConditions.add(EntityCondition.makeCondition("partyId", partyId));
        		listAllConditions.add(EntityCondition.makeCondition("contactMechTypeId", "POSTAL_ADDRESS"));
        		List<EntityCondition> condNoContactMechPurpose = FastList.newInstance();
        		condNoContactMechPurpose.addAll(listAllConditions);
        		if (parameters.containsKey("contactMechPurposeTypeId") && UtilValidate.isNotEmpty(parameters.get("contactMechPurposeTypeId"))) {
    				String contactMechPurposeTypeId = parameters.get("contactMechPurposeTypeId")[0];
    				listAllConditions.add(EntityCondition.makeCondition("contactMechPurposeTypeId", contactMechPurposeTypeId));
            	} else {
            		List<EntityCondition> listCondOr = FastList.newInstance();
            		listCondOr.add(EntityCondition.makeCondition("contactMechPurposeTypeId", "GENERAL_LOCATION"));
            		listCondOr.add(EntityCondition.makeCondition("contactMechPurposeTypeId", "BILLING_LOCATION"));
            		listCondOr.add(EntityCondition.makeCondition("contactMechPurposeTypeId", "PAYMENT_LOCATION"));
            		listCondOr.add(EntityCondition.makeCondition("contactMechPurposeTypeId", "SHIPPING_LOCATION"));
            		listAllConditions.add(EntityCondition.makeCondition(listCondOr, EntityOperator.OR));
            	}
            	
        		EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
        		List<GenericValue> listAddress = delegator.findList("PartyContactDetailByPurpose", tmpConditon, null, listSortFields, opts, false);
        		listAddress = EntityUtil.filterByDate(listAddress, null, "purposeFromDate", "purposeThruDate", true);
        		listAddress = EntityUtil.filterByDate(listAddress);
        		if (UtilValidate.isNotEmpty(listAddress)) {
        			for (GenericValue address : listAddress) {
                        Map<String, Object> newItem = FastMap.newInstance();
                        newItem.put("contactMechId", address.get("contactMechId"));
                        newItem.put("address1", address.get("address1"));
                        newItem.put("address2", address.get("address2"));
                        newItem.put("directions", address.get("directions"));
                        newItem.put("city", address.get("city"));
                        newItem.put("postalCode", address.get("postalCode"));
                        newItem.put("stateProvinceGeoId", address.get("stateProvinceGeoId"));
                        newItem.put("countyGeoId", address.get("countyGeoId"));
                        newItem.put("countryGeoId", address.get("countryGeoId"));
                        newItem.put("contactMechPurposeTypeId", address.get("contactMechPurposeTypeId"));
                        listIterator.add(newItem);
        			}
        		} else {
        			tmpConditon = EntityCondition.makeCondition(condNoContactMechPurpose,EntityJoinOperator.AND);
        			listAddress = delegator.findList("PartyAndContactMech", tmpConditon, null, listSortFields, opts, false);
        			listAddress = EntityUtil.filterByDate(listAddress);
        			for (GenericValue address : listAddress) {
                        Map<String, Object> newItem = FastMap.newInstance();
                        newItem.put("contactMechId", address.get("contactMechId"));
                        newItem.put("address1", address.get("paAddress1"));
                        newItem.put("address2", address.get("paAddress2"));
                        newItem.put("directions", address.get("paDirections"));
                        newItem.put("city", address.get("paCity"));
                        newItem.put("postalCode", address.get("paPostalCode"));
                        newItem.put("stateProvinceGeoId", address.get("paStateProvinceGeoId"));
                        newItem.put("countyGeoId", address.get("paCountyGeoId"));
                        newItem.put("countryGeoId", address.get("paCountryGeoId"));
                        listIterator.add(newItem);
        			}
        		}
        	}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetPartyPostalAddresses service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListProductSales(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			List<EntityCondition> listCondTypeOr = FastList.newInstance();
			listCondTypeOr.add(EntityCondition.makeCondition("productTypeId", "FINISHED_GOOD"));
			listAllConditions.add(EntityCondition.makeCondition(listCondTypeOr, EntityOperator.OR));
			EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			List<GenericValue> listProduct = delegator.findList("Product", tmpConditon, null, listSortFields, opts, false);
			if (UtilValidate.isNotEmpty(listProduct)) {
				for (GenericValue itemProd : listProduct) {
					Map<String, Object> row = FastMap.newInstance();
					row.put("productId", itemProd.get("productId"));
    				row.put("productName", itemProd.get("productName"));
    				row.put("productPackingUomId", itemProd.get("productPackingUomId"));
    				row.put("quantityUomId", itemProd.getString("productPackingUomId"));
    				row.put("internalName", itemProd.getString("internalName"));
    				
					// column: packingUomId
    				EntityCondition condsItem = EntityCondition.makeCondition(UtilMisc.toMap("productId", itemProd.get("productId"), "uomToId", itemProd.get("quantityUomId")));
    				EntityFindOptions optsItem = new EntityFindOptions();
    				
					List<GenericValue> listConfigPacking = FastList.newInstance();
    				listConfigPacking.addAll(delegator.findList("ConfigPackingAndUom", condsItem, null, null, optsItem, false));
					List<Map<String, Object>> listQuantityUomIdByProduct = new ArrayList<Map<String, Object>>();
					for (GenericValue conPackItem : listConfigPacking) {
						Map<String, Object> packingUomIdMap = FastMap.newInstance();
						packingUomIdMap.put("description", conPackItem.getString("descriptionFrom"));
						packingUomIdMap.put("uomId", conPackItem.getString("uomFromId"));
						listQuantityUomIdByProduct.add(packingUomIdMap);
					}
					GenericValue quantityUom = delegator.findOne("Uom", UtilMisc.toMap("uomId", itemProd.get("quantityUomId")), false);
					if (quantityUom != null) {
						Map<String, Object> packingUomIdMap = FastMap.newInstance();
						packingUomIdMap.put("description", quantityUom.getString("description"));
						packingUomIdMap.put("uomId", quantityUom.getString("uomId"));
						listQuantityUomIdByProduct.add(packingUomIdMap);
					}
    				row.put("packingUomId", listQuantityUomIdByProduct);
    				listIterator.add(row);
				}
			}
			
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductSales service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
	public static Map<String, Object> getListQuantityUomByProduct(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	String productId = (String) context.get("productId");
		try {
			GenericValue product = null;
			if (UtilValidate.isNotEmpty(productId)) {
        		product = delegator.findOne("Product", UtilMisc.toMap("productId", productId), false);
        	}
			if (UtilValidate.isNotEmpty(product)) {
				// column: packingUomId
				EntityCondition condsItem = EntityCondition.makeCondition(UtilMisc.toMap("productId", product.get("productId"), "uomToId", product.get("quantityUomId")));
				EntityFindOptions optsItem = new EntityFindOptions();
				
				List<GenericValue> listConfigPacking = FastList.newInstance();
				listConfigPacking.addAll(delegator.findList("ConfigPackingAndUom", condsItem, null, null, optsItem, false));
				for (GenericValue conPackItem : listConfigPacking) {
					Map<String, Object> packingUomIdMap = FastMap.newInstance();
					packingUomIdMap.put("description", conPackItem.getString("descriptionFrom"));
					packingUomIdMap.put("uomId", conPackItem.getString("uomFromId"));
					listIterator.add(packingUomIdMap);
				}
				GenericValue quantityUom = delegator.findOne("Uom", UtilMisc.toMap("uomId", product.get("quantityUomId")), false);
				if (quantityUom != null) {
					Map<String, Object> packingUomIdMap = FastMap.newInstance();
					packingUomIdMap.put("description", quantityUom.getString("description"));
					packingUomIdMap.put("uomId", quantityUom.getString("uomId"));
					listIterator.add(packingUomIdMap);
				}
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling getListQuantityUomByProduct service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listQuantityUom", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListProductSalesOnlyProduct(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	//List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			List<EntityCondition> listCondTypeOr = FastList.newInstance();
			listCondTypeOr.add(EntityCondition.makeCondition("productTypeId", "FINISHED_GOOD"));
			listAllConditions.add(EntityCondition.makeCondition(listCondTypeOr, EntityOperator.OR));
			EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			listIterator = delegator.find("Product", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductSalesOnlyProduct service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> createReturnRequirement(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException{
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		Locale locale = (Locale) context.get("locale");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		//String partyId = (String) userLogin.get("partyId");
		String customerId = (String) context.get("customerId");
		String distributorId = (String) context.get("distributorId");
		String contactMechId = (String) context.get("contactMechId");
		String description = (String) context.get("description");
		Timestamp requirementStartDate = (Timestamp) context.get("requirementStartDate");
		Timestamp requiredByDate = (Timestamp) context.get("requiredByDate");
		String requirementTypeId = (String) context.get("requirementTypeId");
		String reason = (String) context.get("reason");
		
		String currencyUomId = (String) context.get("currencyUomId");
		if (UtilValidate.isNotEmpty(currencyUomId)) {
			currencyUomId = EntityUtilProperties.getPropertyValue("general.properties", "currency.uom.id.default", "USD", delegator);
		}
		String requirementId = "";
		try {
			Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
			
			requirementId = delegator.getNextSeqId("Requirement");
			Map<String, Object> contextMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "requirementTypeId", requirementTypeId, "requirementStartDate", requirementStartDate, 
					"requiredByDate", requiredByDate, "currencyUomId", currencyUomId, "description", description, "reason", reason, 
					"contactMechId", contactMechId, "statusId", "RETURREQ_CREATED", "createdDate", nowTimestamp, "createdByUserLogin", userLogin.get("userLoginId"));
			
			GenericValue requirement = delegator.makeValue("Requirement", contextMap);
			delegator.create(requirement);
			
			Map<String, Object> contextMap2 = UtilMisc.<String, Object>toMap("requirementId", requirement.get("requirementId"), "statusId", requirement.get("statusId"), "statusDate", nowTimestamp, "statusUserLogin", userLogin.get("userLoginId"));
			delegator.create("RequirementStatus", contextMap2);
			
			// create roles in requirement
			// DELYS_SALESMAN_GT
			List<GenericValue> toBeStored = new LinkedList<GenericValue>();
			// Map<String, Object> contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", partyId, "roleTypeId", "OWNER", "fromDate", nowTimestamp);
			Map<String, Object> contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", distributorId, "roleTypeId", "OWNER", "fromDate", nowTimestamp);
			GenericValue requirementRoleOwner = delegator.makeValidValue("RequirementRole", contextRoleMap);
			toBeStored.add(requirementRoleOwner);
			contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", customerId, "roleTypeId", "DELYS_CUSTOMER_GT", "fromDate", nowTimestamp);
			GenericValue requirementRoleOwner2 = delegator.makeValidValue("RequirementRole", contextRoleMap);
			toBeStored.add(requirementRoleOwner2);
			contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", distributorId, "roleTypeId", "DELYS_DISTRIBUTOR", "fromDate", nowTimestamp);
			GenericValue requirementRoleOwner3 = delegator.makeValidValue("RequirementRole", contextRoleMap);
			toBeStored.add(requirementRoleOwner3);
			
			delegator.storeAll(toBeStored);
			
			// create requirement item
			List<Map<String, String>> listProducts = (List<Map<String, String>>)context.get("listProducts");
	    	for(Map<String, String> item: listProducts){
	    		String productId = item.get("productId");
	    		String quantity = item.get("quantity");
	    		String quantityUomId = item.get("quantityUomId");
	    		String expDateTmp = item.get("expireDate");
	    		Timestamp expireDate = null;
	    		if (UtilValidate.isNotEmpty(expDateTmp) && !"null".equals(expDateTmp)){
			        //DateTimeFormatter parser = ISODateTimeFormat.dateTime();
			        //DateTime dt = parser.parseDateTime(expDateTmp);
			        //expireDate = new Timestamp(dt.getMillis());
	    			expireDate = new Timestamp(Long.parseLong(expDateTmp, 10));
	    		}
	    		try {
	    			Map<String, Object> contextItemMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "requirementTypeId", requirementTypeId, "productId", productId,
		    				"quantity", quantity, "quantityUomId", quantityUomId, "currencyUomId", currencyUomId, "expireDate", expireDate, "statusId", "REQ_ITEM_CREATED", "userLogin", userLogin);
					dispatcher.runSync("addProductToRequirement", contextItemMap);
				} catch (GenericServiceException e) {
					e.printStackTrace();
				}
	    	}
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "createError", new Object[]{e.getMessage()}, locale));
		}
		
		result.put("requirementId", requirementId);
		return result;
	}
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> createReturnRequirementToCompany(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException{
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		Locale locale = (Locale) context.get("locale");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		//String partyId = (String) userLogin.get("partyId");
		String companyId = (String) context.get("companyId");
		String distributorId = (String) context.get("distributorId");
		String contactMechId = (String) context.get("contactMechId");
		String description = (String) context.get("description");
		Timestamp requirementStartDate = (Timestamp) context.get("requirementStartDate");
		Timestamp requiredByDate = (Timestamp) context.get("requiredByDate");
		String requirementTypeId = (String) context.get("requirementTypeId");
		String reason = (String) context.get("reason");
		
		String currencyUomId = (String) context.get("currencyUomId");
		if (UtilValidate.isNotEmpty(currencyUomId)) {
			currencyUomId = EntityUtilProperties.getPropertyValue("general.properties", "currency.uom.id.default", "USD", delegator);
		}
		String requirementId = "";
		try {
			Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
			
			requirementId = delegator.getNextSeqId("Requirement");
			Map<String, Object> contextMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "requirementTypeId", requirementTypeId, "requirementStartDate", requirementStartDate, 
					"requiredByDate", requiredByDate, "currencyUomId", currencyUomId, "description", description, "reason", reason, 
					"contactMechId", contactMechId, "statusId", "REREQCOM_CREATED", "createdDate", nowTimestamp, "createdByUserLogin", userLogin.get("userLoginId"));
			
			GenericValue requirement = delegator.makeValue("Requirement", contextMap);
			delegator.create(requirement);
			
			Map<String, Object> contextMap2 = UtilMisc.<String, Object>toMap("requirementId", requirement.get("requirementId"), "statusId", requirement.get("statusId"), "statusDate", nowTimestamp, "statusUserLogin", userLogin.get("userLoginId"));
			delegator.create("RequirementStatus", contextMap2);
			
			// create roles in requirement
			// DELYS_SALESMAN_GT
			List<GenericValue> toBeStored = new LinkedList<GenericValue>();
			Map<String, Object> contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", companyId, "roleTypeId", "OWNER", "fromDate", nowTimestamp);
			GenericValue requirementRoleOwner = delegator.makeValidValue("RequirementRole", contextRoleMap);
			toBeStored.add(requirementRoleOwner);
			contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", companyId, "roleTypeId", "INTERNAL_ORGANIZATIO", "fromDate", nowTimestamp);
			GenericValue requirementRoleOwner2 = delegator.makeValidValue("RequirementRole", contextRoleMap);
			toBeStored.add(requirementRoleOwner2);
			contextRoleMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "partyId", distributorId, "roleTypeId", "DELYS_DISTRIBUTOR", "fromDate", nowTimestamp);
			GenericValue requirementRoleOwner3 = delegator.makeValidValue("RequirementRole", contextRoleMap);
			toBeStored.add(requirementRoleOwner3);
			
			delegator.storeAll(toBeStored);
			
			// create requirement item
			List<Map<String, String>> listProducts = (List<Map<String, String>>)context.get("listProducts");
	    	for(Map<String, String> item: listProducts){
	    		String productId = item.get("productId");
	    		String quantity = item.get("quantity");
	    		String quantityUomId = item.get("quantityUomId");
	    		String expDateTmp = item.get("expireDate");
	    		Timestamp expireDate = null;
	    		if (UtilValidate.isNotEmpty(expDateTmp) && !"null".equals(expDateTmp)){
			        //DateTimeFormatter parser = ISODateTimeFormat.dateTime();
			        //DateTime dt = parser.parseDateTime(expDateTmp);
			        //expireDate = new Timestamp(dt.getMillis());
	    			expireDate = new Timestamp(Long.parseLong(expDateTmp, 10));
	    		}
	    		try {
	    			Map<String, Object> contextItemMap = UtilMisc.<String, Object>toMap("requirementId", requirementId, "requirementTypeId", requirementTypeId, "productId", productId,
		    				"quantity", quantity, "quantityUomId", quantityUomId, "currencyUomId", currencyUomId, "expireDate", expireDate, "statusId", "REQ_ITEM_CREATED", "userLogin", userLogin);
					dispatcher.runSync("addProductToRequirement", contextItemMap);
				} catch (GenericServiceException e) {
					e.printStackTrace();
				}
	    	}
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "createError", new Object[]{e.getMessage()}, locale));
		}
		
		/*String header = "";
    	String state = "open";
    	String action = "";
    	String targetLink = "";
    	Timestamp dateTime = UtilDateTime.nowTimestamp();
		// Send message to CEO
		String notiToId = "";
    	try {
    		notiToId = SalesPartyUtil.getPersonCEO(delegator);
    		header = UtilProperties.getMessage(resource, "DAApproveProductQuotation",locale) + " [" + productQuotationId +"]";
    		action = "viewQuotation";
    		targetLink = "productQuotationId="+productQuotationId;
    	} catch (Exception e) {
    		Debug.logError(e, "Error when set value for notify", module);
    	}
    	Map<String, Object> tmpResult = dispatcher.runSync("createNotification", UtilMisc.<String, Object>toMap("partyId", notiToId, "header", header, "state", state, "action", action, "targetLink", targetLink, "dateTime", dateTime, "userLogin", userLogin));
		if (ServiceUtil.isError(tmpResult)) {
			return ServiceUtil.returnError(ServiceUtil.getErrorMessage(tmpResult));
        }*/
		
		result.put("requirementId", requirementId);
		return result;
	}
    
    /*
     * jq get list inventory for SUP
     * @param dpct
     * @param context
     * @return
     * 
     * 
     * */
    
    @SuppressWarnings("unused")
	public static Map<String,Object> JQGetListInventoryHistory(DispatchContext dpct,Map<?,?> context){
    	Delegator delegator  = dpct.getDelegator();	
    	@SuppressWarnings("unchecked")
		List<EntityCondition> listAllConditions = (List<EntityCondition>)  context.get("listAllConditions");
    	@SuppressWarnings("unchecked")
		List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions otps = (EntityFindOptions) context.get("otps");
    	@SuppressWarnings("unchecked")
		Map<String,String[]> parameters = (Map<String,String[]>) context.get("parameters");
    	EntityListIterator listIterator = null;
    	Map<String,String> mapCondition = new HashMap<String, String>();
    	EntityCondition condition = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    	Map<String,Object> result = ServiceUtil.returnSuccess();
    	try {
    		listSortFields.add("fromDate DESC");
    		listIterator = delegator.find("InventoryOfCustomerDetail", condition, null,null , listSortFields, otps);
			if(UtilValidate.isNotEmpty(listIterator)){
				result.put("listIterator", listIterator);
			}
		} catch (Exception e) {
			String msg = "Error when get list Inventory  in  JQGetListInventoryHistory method : " + e.getMessage();
			Debug.logError(e, msg,module);
		}
    	return result;
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListRequirementItem(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	//List<GenericValue> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	
    	String requirementId = null;
    	try {
    		// get list distributor
        	if (parameters.containsKey("requirementId") && UtilValidate.isNotEmpty(parameters.get("requirementId"))) {
        		requirementId = parameters.get("requirementId")[0];
        	}
        	if (requirementId != null) {
        		listAllConditions.add(EntityCondition.makeCondition("requirementId", requirementId));
        		EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
        		listIterator = delegator.find("RequirementItem", tmpConditon, null, null, listSortFields, opts);
        	}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListRequirementItem service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }

    /*
     * get List Inventory
     * @dpct
     * @context
     * @return
     * 
     * 
     * */
    @SuppressWarnings("unused")
   	public static Map<String,Object> JQGetListInventory(DispatchContext dpct,Map<?,?> context){
       	Delegator delegator  = dpct.getDelegator();	
       	@SuppressWarnings("unchecked")
   		List<EntityCondition> listAllConditions = (List<EntityCondition>)  context.get("listAllConditions");
       	@SuppressWarnings("unchecked")
   		List<String> listSortFields = (List<String>) context.get("listSortFields");
       	EntityFindOptions otps = (EntityFindOptions) context.get("otps");
       	@SuppressWarnings("unchecked")
   		Map<String,String[]> parameters = (Map<String,String[]>) context.get("parameters");
       	EntityListIterator listIterator = null;
       	Map<String,String> mapCondition = new HashMap<String, String>();
       	EntityCondition condition = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
       	Map<String,Object> result = ServiceUtil.returnSuccess();
       	try {
       		listSortFields.add("fromDate DESC");
       		listIterator = delegator.find("InventoryOfCustomerDetail", condition, null,null , listSortFields, otps);
       		List<GenericValue> list  = listIterator.getCompleteList();
       		List<GenericValue> listFilterId  = FastList.newInstance();
       		//filter list 
       		for(GenericValue inven : list){
       			if(UtilValidate.isNotEmpty(listFilterId)){
       				boolean flag = false;
       				for(GenericValue filter : listFilterId){
       					if(filter.getString("orderId").equals(inven.getString("orderId"))){
       						flag = true;
       						break;
       					}
       				}
       				if(!flag){
       					listFilterId.add(inven);
       				}
       			}else{
       				listFilterId.add(inven);
       			}
       		}
   			if(UtilValidate.isNotEmpty(listFilterId)){
   				result.put("TotalRows", String.valueOf(listFilterId.size()));
   				result.put("listIterator", listFilterId);
   			}
   		} catch (Exception e) {
   			String msg = "Error when get list Inventory  in  JQGetListInventory method : " + e.getMessage();
   			Debug.logError(e, msg,module);
   		}
       	return result;
       }
    
    /**
     * get list inventory by total products in inventory
     * @param dpct
     * @param context
     * @return 
     * 
     * **/
    @SuppressWarnings("unused")
   	public static Map<String,Object> JQGetListInventoryByProducts(DispatchContext dpct,Map<?,?> context){
       	Delegator delegator  = dpct.getDelegator();	
       	@SuppressWarnings("unchecked")
   		List<EntityCondition> listAllConditions = (List<EntityCondition>)  context.get("listAllConditions");
       	@SuppressWarnings("unchecked")
   		List<String> listSortFields = (List<String>) context.get("listSortFields");
       	EntityFindOptions otps = (EntityFindOptions) context.get("otps");
       	@SuppressWarnings("unchecked")
   		Map<String,String[]> parameters = (Map<String,String[]>) context.get("parameters");
       	EntityListIterator listIterator = null;
       	Map<String,String> mapCondition = new HashMap<String, String>();
       	EntityCondition condition = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
       	Map<String,Object> result = ServiceUtil.returnSuccess();
       	try {
       		listSortFields.add("fromDate DESC");
       		listIterator = delegator.find("InventoryOfCustomerDetail", condition, null,null , listSortFields, otps);
       		List<GenericValue> list  = listIterator.getCompleteList();
       		List<GenericValue> listFilterId  = FastList.newInstance();
       		//filter list 
       		for(GenericValue inven : list){
       			if(UtilValidate.isNotEmpty(listFilterId)){
       				boolean flag = false;
       				for(GenericValue filter : listFilterId){
       					if(filter.getString("orderId").equals(inven.getString("orderId"))){
       						flag = true;
       						break;
       					}
       				}
       				if(!flag){
       					listFilterId.add(inven);
       				}
       			}else{
       				listFilterId.add(inven);
       			}
       		}
       		List<Map<String,Object>> listQtyOfProducts = FastList.newInstance();
       		//calculate total by products in inventory
       		for(GenericValue filter : listFilterId){
       			Map<String,Object> mapProduct =  FastMap.newInstance();
       			mapProduct.put("productId", filter.getString("productId"));
       			mapProduct.put("productName", filter.getString("productId"));
       			mapProduct.put("qtyInInventory", filter.getBigDecimal(("qtyInInventory")));
       			boolean checkIn = false;
       				if(!listQtyOfProducts.isEmpty()){
       					for(Map<String,Object> tmp : listQtyOfProducts){
       						if(tmp.get("productId").equals(mapProduct.get("productId"))){
       							checkIn = true;
       							BigDecimal bg = (BigDecimal) tmp.get("qtyInInventory");
       							BigDecimal bg1 = (BigDecimal) mapProduct.get("qtyInInventory");
       							tmp.put("qtyInInventory",bg.add(bg1));
       						}
       					}
       					if(!checkIn){
       						listQtyOfProducts.add(mapProduct);
       					}
       				}else{
       					listQtyOfProducts.add(mapProduct);
       				}
       		}
       		
   			if(UtilValidate.isNotEmpty(listQtyOfProducts)){
   				result.put("TotalRows", String.valueOf(listQtyOfProducts.size()));
   				result.put("listIterator", listQtyOfProducts);
   			}
   		} catch (Exception e) {
   			String msg = "Error when get list Inventory  in  JQGetListInventoryByProducts method : " + e.getMessage();
   			Debug.logError(e, msg,module);
   		}
       	return result;
   }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListRequirementAndItemDetail(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	// EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			if (parameters.containsKey("requirementTypeId") && UtilValidate.isNotEmpty(parameters.get("requirementTypeId")) && UtilValidate.isNotEmpty(userLogin)) {
				String requirementTypeId = parameters.get("requirementTypeId")[0];
				if (UtilValidate.isNotEmpty(requirementTypeId)) {
					String entityName = "Requirement";
					if ("RETURN_PRODCOM_REQ".equals(requirementTypeId)) {
						if (SalesPartyUtil.isDistributor(userLogin, delegator)) {
							// userLogin is distributor
							entityName = "RequirementAndRole";
							listAllConditions.add(EntityCondition.makeCondition("partyId", userLogin.get("partyId")));
							listAllConditions.add(EntityCondition.makeCondition("roleTypeId", "DELYS_DISTRIBUTOR"));
						}
					}
					listAllConditions.add(EntityCondition.makeCondition("requirementTypeId", requirementTypeId));
					String statusId = "";
					if (parameters.containsKey("statusId") && UtilValidate.isNotEmpty(parameters.get("statusId"))) {
						statusId = parameters.get("statusId")[0];
					}
					listAllConditions.add(EntityCondition.makeCondition("statusId", statusId));
					EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
					List<GenericValue> listRequirement = delegator.findList(entityName, tmpConditon, null, listSortFields, opts, false);
					if (UtilValidate.isNotEmpty(listRequirement)) {
						for (GenericValue requirement : listRequirement) {
							Map<String, Object> rowReq = FastMap.newInstance();
							rowReq.put("requirementId", requirement.get("requirementId"));
							rowReq.put("facilityId", requirement.get("facilityId"));
							rowReq.put("productStoreId", requirement.get("productStoreId"));
							rowReq.put("contactMechId", requirement.get("contactMechId"));
							rowReq.put("deliverableId", requirement.get("deliverableId"));
							rowReq.put("fixedAssetId", requirement.get("fixedAssetId"));
							rowReq.put("productId", requirement.get("productId"));
							rowReq.put("statusId", requirement.get("statusId"));
							rowReq.put("description", requirement.get("description"));
							rowReq.put("createdDate", requirement.get("createdDate"));
							rowReq.put("requirementStartDate", requirement.get("requirementStartDate"));
							rowReq.put("estimatedBudget", requirement.get("estimatedBudget"));
							rowReq.put("currencyUomId", requirement.get("currencyUomId"));
							rowReq.put("quantity", requirement.get("quantity"));
							rowReq.put("useCase", requirement.get("useCase"));
							rowReq.put("reason", requirement.get("reason"));
							rowReq.put("createdByUserLogin", requirement.get("createdByUserLogin"));
							List<Map<String, Object>> rowDetail = FastList.newInstance();
							List<GenericValue> listRequirementItem = delegator.findByAnd("RequirementItem", UtilMisc.toMap("requirementId", requirement.get("requirementId")), null, false);
							if (UtilValidate.isNotEmpty(listRequirementItem)) {
								for (GenericValue reqItem : listRequirementItem) {
									Map<String, Object> rowItem = FastMap.newInstance();
									rowItem.put("requirementId", reqItem.get("requirementId"));
									rowItem.put("reqItemSeqId", reqItem.get("reqItemSeqId"));
									rowItem.put("productId", reqItem.get("productId"));
									rowItem.put("expireDate", reqItem.get("expireDate"));
									rowItem.put("quantityUomId", reqItem.get("quantityUomId"));
									rowItem.put("quantity", reqItem.get("quantity"));
									rowItem.put("quantityAccepted", reqItem.get("quantityAccepted"));
									rowDetail.add(rowItem);
								}
							}
							rowReq.put("rowDetail", rowDetail);
							listIterator.add(rowReq);
						}
					}
				}
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListRequirementAndItemDetail service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    public static Map<String, Object> updateReturnProductReqItem(DispatchContext ctx, Map<String, ? extends Object> context) {
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale"); 
		String requirementId = (String) context.get("requirementId");
		String reqItemSeqId = (String) context.get("reqItemSeqId");
		String quantityAcceptedStr = (String) context.get("quantityAccepted");
		BigDecimal quantityAccepted = null;
		try {
			try {
				quantityAccepted = (BigDecimal) ObjectType.simpleTypeConvert(quantityAcceptedStr, "BigDecimal", null, locale);
	        } catch (Exception e) {
	            Debug.logWarning(e, "Problems parsing quantity string: " + quantityAcceptedStr, module);
	        }
			if (quantityAccepted == null) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAQuantityAcceptedNotValid", locale));
			}
			GenericValue requirementItem = delegator.findOne("RequirementItem", UtilMisc.toMap("requirementId", requirementId, "reqItemSeqId", reqItemSeqId), false);
			if (UtilValidate.isNotEmpty(requirementItem)) {
				BigDecimal quantity = requirementItem.getBigDecimal("quantity");
				if (quantity.compareTo(quantityAccepted) < 0) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAQuantityAcceptedCannotGreatThanQuantity", locale));
				}
				requirementItem.put("quantityAccepted", quantityAccepted);
				delegator.store(requirementItem);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling updateReturnProductReqItem service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		return successResult;
	}
    
    public static Map<String, Object> createReturnOrderFromRequirement(DispatchContext ctx, Map<String, ? extends Object> context) {
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		Locale locale = (Locale) context.get("locale");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String requirementId = (String) context.get("requirementId");
		String returnId = "";
		Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
		if (UtilValidate.isEmpty(requirementId)) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DARequirementIdCannotBeEmpty", locale));
		}
		try {
			GenericValue requirement = delegator.findOne("Requirement", UtilMisc.toMap("requirementId", requirementId), false);
			if (UtilValidate.isEmpty(requirement)) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAThisRequirementNotAvaiable", locale));
			}
			
			Map<String, Object> contextMapReturnHeader = FastMap.newInstance();
			contextMapReturnHeader.put("returnHeaderTypeId", "CUSTOMER_RETURN");
			
			if ("RETURN_PRODCOM_REQ".equals(requirement.getString("requirementTypeId"))) {
				String distributorId = null;
				List<GenericValue> listReqRoleDistributor = EntityUtil.filterByDate(delegator.findByAnd("RequirementRole", UtilMisc.toMap("roleTypeId", "DELYS_DISTRIBUTOR", "requirementId", requirement.get("requirementId")), null, false));
				if (UtilValidate.isNotEmpty(listReqRoleDistributor)) {
					GenericValue reqRoleDistributor = EntityUtil.getFirst(listReqRoleDistributor);
					distributorId = reqRoleDistributor.getString("partyId");
				}
				if (distributorId == null) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundDistributorInTheRequirement", locale));
				}
				contextMapReturnHeader.put("fromPartyId", distributorId);
				
				String companyId = null;
				List<GenericValue> listReqRoleCustomer = EntityUtil.filterByDate(delegator.findByAnd("RequirementRole", UtilMisc.toMap("roleTypeId", "INTERNAL_ORGANIZATIO", "requirementId", requirement.get("requirementId")), null, false));
				if (UtilValidate.isNotEmpty(listReqRoleCustomer)) {
					GenericValue reqRoleCustomer = EntityUtil.getFirst(listReqRoleCustomer);
					companyId = reqRoleCustomer.getString("partyId");
				}
				if (companyId == null) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundCompanyInTheRequirement", locale));
				}
				contextMapReturnHeader.put("toPartyId", companyId);
			} else {
				String customerId = null;
				List<GenericValue> listReqRoleCustomer = EntityUtil.filterByDate(delegator.findByAnd("RequirementRole", UtilMisc.toMap("roleTypeId", "DELYS_CUSTOMER_GT", "requirementId", requirement.get("requirementId")), null, false));
				if (UtilValidate.isNotEmpty(listReqRoleCustomer)) {
					GenericValue reqRoleCustomer = EntityUtil.getFirst(listReqRoleCustomer);
					customerId = reqRoleCustomer.getString("partyId");
				}
				if (customerId == null) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundCustomerInTheRequirement", locale));
				}
				contextMapReturnHeader.put("fromPartyId", customerId);
				String distributorId = null;
				List<GenericValue> listReqRoleDistributor = EntityUtil.filterByDate(delegator.findByAnd("RequirementRole", UtilMisc.toMap("roleTypeId", "DELYS_DISTRIBUTOR", "requirementId", requirement.get("requirementId")), null, false));
				if (UtilValidate.isNotEmpty(listReqRoleDistributor)) {
					GenericValue reqRoleDistributor = EntityUtil.getFirst(listReqRoleDistributor);
					distributorId = reqRoleDistributor.getString("partyId");
				}
				if (distributorId == null) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundDistributorInTheRequirement", locale));
				}
				contextMapReturnHeader.put("toPartyId", distributorId);
			}
			
			contextMapReturnHeader.put("createdBy", userLogin.get("userLoginId"));
			String currencyUomId = EntityUtilProperties.getPropertyValue("general.properties", "currency.uom.id.default", "VND", delegator);
			contextMapReturnHeader.put("currencyUomId", currencyUomId);
			contextMapReturnHeader.put("entryDate", nowTimestamp);
			contextMapReturnHeader.put("statusId", "RETURN_REQUESTED");
			contextMapReturnHeader.put("userLogin", userLogin);
			
			/* billingAccountId, destinationFacilityId, finAccountId, needsInventoryReceive, originContactMechId, paymentMethodId, returnHeaderTypeId, supplierRmaId */
			Map<String, Object> resultServiceRH = dispatcher.runSync("createReturnHeader", contextMapReturnHeader);
			if (ServiceUtil.isError(resultServiceRH)) {
				return resultServiceRH;
			}
			returnId = (String) resultServiceRH.get("returnId");
			
			// map requirementItem to returnItem
			List<GenericValue> listRequirementItem = delegator.findByAnd("RequirementItem", UtilMisc.toMap("requirementId", requirement.get("requirementId")), null, false);
			
			//List<GenericValue> tobeStored = new LinkedList<GenericValue>();
			if (UtilValidate.isNotEmpty(listRequirementItem)) {
				for (GenericValue requirementItem : listRequirementItem) {
					Map<String, Object> contextMapReturnItem = FastMap.newInstance();
					contextMapReturnItem.put("returnId", returnId);
					if (UtilValidate.isNotEmpty(requirementItem.get("productId"))) {
						String productId = requirementItem.getString("productId");
						GenericValue product = delegator.findOne("Product", UtilMisc.toMap("productId", productId), false);
						if (UtilValidate.isNotEmpty(product)) {
							contextMapReturnItem.put("productId", requirementItem.get("productId"));
							contextMapReturnItem.put("expireDate", requirementItem.get("expireDate"));
							if (UtilValidate.isNotEmpty(requirementItem.get("quantity")) && UtilValidate.isNotEmpty(requirementItem.get("quantityUomId"))) {
								BigDecimal alterQuantity = requirementItem.getBigDecimal("quantity");
								String alterQuantityUomId = requirementItem.getString("quantityUomId");
								contextMapReturnItem.put("alterQuantity", alterQuantity);
								contextMapReturnItem.put("alterQuantityUomId", alterQuantityUomId);
								
								BigDecimal productQuantityToDefault = BigDecimal.ZERO;
								Map<String, Object> resultValue2 = dispatcher.runSync("getConvertPackingNumber", UtilMisc.toMap("productId", productId, "uomFromId", alterQuantityUomId, "uomToId", product.get("quantityUomId"), "userLogin", userLogin));
								if (ServiceUtil.isSuccess(resultValue2)) {
									productQuantityToDefault = (BigDecimal) resultValue2.get("convertNumber");
								}
								if (productQuantityToDefault != null) {
									BigDecimal returnQuantity = alterQuantity.multiply(productQuantityToDefault);
									contextMapReturnItem.put("returnQuantity", returnQuantity);
									contextMapReturnItem.put("quantityUomId", product.get("quantityUomId"));
									
									contextMapReturnItem.put("createdByUserLogin", userLogin.get("userLoginId"));
									contextMapReturnItem.put("createdDate", nowTimestamp);
									contextMapReturnItem.put("lastModifiedByUserLogin", userLogin.get("userLoginId"));
									contextMapReturnItem.put("lastModifiedDate", nowTimestamp);
									
									if (UtilValidate.isNotEmpty(requirement.get("reason"))) {
										GenericValue returnReason = delegator.findOne("ReturnReason", UtilMisc.toMap("returnReasonId", requirement.get("reason")), false);
										if (UtilValidate.isNotEmpty(returnReason)) {
											contextMapReturnItem.put("returnReasonId", returnReason.get("returnReasonId"));
										}
									}
									contextMapReturnItem.put("returnTypeId", "RTN_REFUND");
									contextMapReturnItem.put("expectedItemStatus", "INV_PROMISED"); //INV_ON_ORDER
									contextMapReturnItem.put("returnItemTypeId", "RET_FPROD_ITEM");
									contextMapReturnItem.put("userLogin", userLogin);
									
									String serviceName = "createReturnItemLoose";
							        try {
							            Map<String, Object> inMap = ctx.makeValidContext(serviceName, "IN", contextMapReturnItem);
							            if ("createReturnItemLoose".equals(serviceName)) {
							                // we don't want to automatically include the adjustments
							                // when the return item is created because they are selectable by the user
							                inMap.put("includeAdjustments", "N");
							            }
							            Map<String, Object> resultService3 = dispatcher.runSync(serviceName, inMap);
							            if (ServiceUtil.isError(resultService3)) {
							            	resultService3.remove("returnItemSeqId");
							            	return resultService3;
							            }
							            String returnItemSeqId = (String) resultService3.get("returnItemSeqId");
							            
							            // create return requirement commitment
							            Map<String, Object> contextMapReturnCommitment = UtilMisc.<String, Object>toMap("returnId", returnId, "returnItemSeqId", returnItemSeqId, 
							            		"requirementId", requirement.get("requirementId"), "quantity", returnQuantity, "userLogin", userLogin);
							            Map<String, Object> resultService4 = dispatcher.runSync("createReturnRequirementCommitment", contextMapReturnCommitment);
							            if (ServiceUtil.isError(resultService4)) {
							            	return resultService4;
							            }
							        } catch (org.ofbiz.service.GenericServiceException e) {
							            Debug.logError(e, module);
							            return ServiceUtil.returnError(e.getMessage());
							        }
							        
									/*Map<String, Object> resultServiceRI = dispatcher.runSync("createReturnItemOrAdjustment", contextMapReturnItem);
									if (ServiceUtil.isError(resultServiceRI)) {
										return resultServiceRI;
									}*/
								}
							}
						}
					}
				}
				String nextStatusId = "";//RETURREQ_PROGRESS";
				if ("RETURN_PRODCOM_REQ".equals(requirement.getString("requirementTypeId"))) {
					nextStatusId = "REREQCOM_PROGRESS";
				} else {
					nextStatusId = "RETURREQ_PROGRESS";
				}
		        requirement.put("statusId", nextStatusId);
		        delegator.store(requirement);
		        Map<String, Object> contextMap2 = UtilMisc.<String, Object>toMap("requirementId", requirement.get("requirementId"), "statusId", nextStatusId, "statusDate", nowTimestamp, "statusUserLogin", userLogin.get("userLoginId"));
				delegator.create("RequirementStatus", contextMap2);
			}
			/*
			amount, comments, correspondingProductId, customerReferenceId, description, exemptAmount, expectedItemStatus 
			includeInShipping, includeInTax, orderAdjustmentId, orderId, orderItemSeqId, overrideGlAccountId, primaryGeoId 
			productFeatureId, productId, productPromoActionSeqId, productPromoId, productPromoRuleId, receivedQuantity 
			returnAdjustmentId, returnAdjustmentTypeId, returnId, returnItemResponseId, returnItemSeqId,  
			returnPrice, returnReasonId, returnTypeId, secondaryGeoId, shipGroupSeqId, sourcePercentage, sourceReferenceId 
			statusId, taxAuthGeoId, taxAuthPartyId, taxAuthorityRateSeqId 
			 */
		} catch (Exception e) {
			String errMsg = "Fatal error calling createReturnOrderFromRequirement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("returnId", returnId);
    	return successResult;
	}
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListReturnItem(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	//List<GenericValue> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String[]> parameters = (Map<String, String[]>)context.get("parameters");
    	
    	String returnId = null;
    	try {
    		// get list distributor
        	if (parameters.containsKey("returnId") && UtilValidate.isNotEmpty(parameters.get("returnId"))) {
        		returnId = parameters.get("returnId")[0];
        	}
        	if (returnId != null) {
        		listAllConditions.add(EntityCondition.makeCondition("returnId", returnId));
        		EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
        		listIterator = delegator.find("ReturnItem", tmpConditon, null, null, listSortFields, opts);
        	}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListReturnItem service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListReturnOrder(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//GenericValue userLogin = (GenericValue) context.get("userLogin");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			listIterator = delegator.find("ReturnHeader", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListReturnOrder service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListReturnOrderFromCustomer(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			if (UtilValidate.isNotEmpty(userLogin) && UtilValidate.isNotEmpty(userLogin.get("partyId"))) {
				listAllConditions.add(EntityCondition.makeCondition("toPartyId", userLogin.get("partyId")));
				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
				listIterator = delegator.find("ReturnHeader", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListReturnOrderFromCustomer service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListReturnOrderToCompany(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			if (UtilValidate.isNotEmpty(userLogin) && UtilValidate.isNotEmpty(userLogin)) {
				String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
				listAllConditions.add(EntityCondition.makeCondition("toPartyId", companyId));
				if (SalesPartyUtil.isDistributor(userLogin, delegator)) {
					listAllConditions.add(EntityCondition.makeCondition("fromPartyId", userLogin.getString("partyId")));
				} else if (SalesPartyUtil.isLogStoreKeeper(userLogin, delegator)) {
					listAllConditions.add(EntityCondition.makeCondition("statusId", "RETURN_ACCEPTED"));
				} else {
					listAllConditions.add(EntityCondition.makeCondition("createdBy", userLogin.get("userLoginId")));
				}
				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
				listIterator = delegator.find("ReturnHeader", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListReturnOrderToCompany service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    /*@SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListFacilityLocation(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
		try {
			if (parameters.containsKey("facilityId") && UtilValidate.isNotEmpty(parameters.get("facilityId")[0])) {
				listAllConditions.add(EntityCondition.makeCondition("facilityId", parameters.get("facilityId")[0]));
			}
			EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
			listIterator = delegator.find("FacilityLocation", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListFacilityLocation service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }*/
    
    public static Map<String, Object> getPartiesAndName(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<GenericValue> listParty = new ArrayList<GenericValue>();
    	
    	try {
    		listParty = delegator.findByAnd("PartyNameView", null, null, false);
    	} catch (Exception e) {
			String errMsg = "Fatal error calling getPartiesAndName service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listParty", listParty);
    	return successResult;
    }
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListDistributorOld(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	opts.setDistinct(true);
		try {
			if (UtilValidate.isNotEmpty(userLogin) && UtilValidate.isNotEmpty(userLogin.get("partyId"))) {
				if (SalesPartyUtil.isSupervisorEmployee(userLogin, delegator)) {
					// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
		        	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					
					EntityListIterator listIterator2 = SalesPartyUtil.getListDistributorActiveBySupervisor(userLogin.getString("partyId"), listSortFields, listAllConditions, opts, delegator);
					List<GenericValue> listDistributor = listIterator2.getCompleteList();
					if (UtilValidate.isNotEmpty(listDistributor)) {
						for (GenericValue distributor : listDistributor) {
							// get other data
							Map<String, Object> row = FastMap.newInstance();
							row.put("partyId", distributor.get("partyId"));
							row.put("groupName", distributor.get("groupName"));
							row.put("website", distributor.get("officeSiteName"));
							row.put("preferredCurrencyUomId", distributor.get("preferredCurrencyUomId"));
							row.put("statusId", distributor.get("statusId"));
							row.put("description", distributor.get("description"));
							row.put("createdDate", distributor.get("createdDate"));
							row.put("createdByUserLogin", distributor.get("createdByUserLogin"));
							
							String toName = null;
							String address = null;
							String phone = null;
							String email = null;
							String countryGeoId = null;
							String stateProvinceGeoId = null;
							String countyGeoId = null;
							
							List<GenericValue> listPartyContactMech = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMech", UtilMisc.toMap("partyId", distributor.get("partyId")), null, false));
							if (UtilValidate.isNotEmpty(listPartyContactMech)) {
								for (GenericValue partyContactMech : listPartyContactMech) {
									GenericValue contactMech = delegator.findOne("ContactMech", UtilMisc.toMap("contactMechId", partyContactMech.get("contactMechId")), false);
									if (UtilValidate.isNotEmpty(contactMech)) {
										String contactMechTypeId = contactMech.getString("contactMechTypeId");
										//ContactMechTypeIdEnum contactMechTypeIdEnum = ContactMechTypeIdEnum.valueOf(contactMechTypeId);
										//if (UtilValidate.isNotEmpty(contactMechTypeIdEnum)) {
											if ("POSTAL_ADDRESS".equals(contactMechTypeId)) {
												GenericValue postalAddress = delegator.findOne("PostalAddress", UtilMisc.toMap("contactMechId", contactMechTypeId), false);
												if (UtilValidate.isNotEmpty(postalAddress)) {
													address = postalAddress.getString("address1");
													toName = postalAddress.getString("toName");
													countryGeoId = postalAddress.getString("countryGeoId");
													stateProvinceGeoId = postalAddress.getString("stateProvinceGeoId");
													countyGeoId = postalAddress.getString("countyGeoId");
												}
											} else if ("EMAIL_ADDRESS".equals(contactMechTypeId)) {
												email = contactMech.getString("infoString");
											} else if ("TELECOM_NUMBER".equals(contactMechTypeId)) {
												GenericValue telecomNumber = delegator.findOne("TelecomNumber", UtilMisc.toMap("contactMechId", contactMechTypeId), false);
												if (UtilValidate.isNotEmpty(telecomNumber)) {
													phone = "(" + telecomNumber.getString("countryCode") + " - " + telecomNumber.getString("areaCode") + ") " + telecomNumber.getString("contactNumber");
												}
											}
										//}
									}
								}
							}
							row.put("address", address);
							row.put("phone", phone);
							row.put("email", email);
							row.put("countryGeoId", countryGeoId);
							row.put("stateProvinceGeoId", stateProvinceGeoId);
							row.put("countyGeoId", countyGeoId);
							row.put("toName", toName);
							listIterator.add(row);
						}
					}
				}
				//listIterator = delegator.find("FacilityLocation", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListDistributor service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
    
    @SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListDistributor(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	opts.setDistinct(true);
		try {
			if (UtilValidate.isNotEmpty(userLogin) && UtilValidate.isNotEmpty(userLogin.get("partyId"))) {
				if (SalesPartyUtil.isSupervisorEmployee(userLogin, delegator)) {
					// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
		        	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					
					listIterator = SalesPartyUtil.getListDistributorActiveBySupervisor(userLogin.getString("partyId"), listSortFields, listAllConditions, opts, delegator);
				} else if (SalesPartyUtil.isSalesAdminManagerEmployee(userLogin, delegator)) {
					String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
					
					listIterator = SalesPartyUtil.getListDistributorActiveByOrganization(companyId, listSortFields, listAllConditions, opts, delegator);
					// get DSA department
					/*List<String> dsaDepId = EntityUtil.getFieldListFromEntityList(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdFrom", companyId, "roleTypeIdTo", "DEPARTMENT", "partyRelationshipTypeId", "GROUP_ROLLUP"), null, false),
											"partyIdTo", true);
					List<EntityCondition> listCond1 = FastList.newInstance();
					listCond1.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_NBD"));
					listCond1.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond1.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, dsaDepId));
					List<String> nbdIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond1, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond2 = FastList.newInstance();
					listCond2.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_CSM_GT"));
					listCond2.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, nbdIds));
					List<String> csmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond2, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond3 = FastList.newInstance();
					listCond3.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_RSM_GT"));
					listCond3.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond3.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, csmIds));
					List<String> rsmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond3, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond4 = FastList.newInstance();
					listCond4.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_ASM_GT"));
					listCond4.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond4.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, rsmIds));
					List<String> asmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond4, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond5 = FastList.newInstance();
					listCond5.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_SALESSUP_GT"));
					listCond5.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond5.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, asmIds));
					List<String> supIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond5, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					listIterator = SalesPartyUtil.getListDistributorActiveBySupervisorDepartment(supIds, listSortFields, listAllConditions, opts, delegator);*/
					/*
					<PartyRelationship partyIdFrom="company" partyIdTo="DSA" roleTypeIdFrom="PARENT_ORGANIZATION" roleTypeIdTo="DEPARTMENT" fromDate="2014-03-21 16:07:33" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="DSA" partyIdTo="NBD" roleTypeIdFrom="DEPARTMENT" roleTypeIdTo="DELYS_NBD" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="NBD" partyIdTo="CSM_MT" roleTypeIdFrom="DELYS_NBD" roleTypeIdTo="DELYS_CSM_MT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="CSM_GT" partyIdTo="RSM_GT_VUNG1" roleTypeIdFrom="DELYS_CSM_GT" roleTypeIdTo="DELYS_RSM_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="RSM_GT_VUNG1" partyIdTo="ASM_GT_HANOI" roleTypeIdFrom="DELYS_RSM_GT" roleTypeIdTo="DELYS_ASM_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="ASM_GT_HANOI" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="DELYS_ASM_GT" roleTypeIdTo="DELYS_SALESSUP_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					 */
				} else if (SalesPartyUtil.isSalesAdminGTEmployee(userLogin, delegator)) {
					String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
					listIterator = SalesPartyUtil.getListDistributorActiveByOrganization(companyId, listSortFields, listAllConditions, opts, delegator);
				}
				//listIterator = delegator.find("FacilityLocation", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListDistributor service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
    
    @SuppressWarnings("unchecked")
   	public static Map<String, Object> jqGetListSalesmanByDist(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	EntityListIterator listIterator = null;
   		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
       	List<String> listSortFields = (List<String>) context.get("listSortFields");
       	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
       	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
       	opts.setDistinct(true);
   		try {
   			if (UtilValidate.isNotEmpty(parameters) && parameters.containsKey("partyId") && UtilValidate.isNotEmpty(parameters.get("partyId")[0])) {
				String partyId = parameters.get("partyId")[0];
				// <PartyRelationship partyIdFrom="NPP_TUANMINH" partyIdTo="salesman1" roleTypeIdFrom="DELYS_DISTRIBUTOR" roleTypeIdTo="DELYS_SALESMAN_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="SALES_EMPLOYMENT"/>
				
				// get salesman
				List<String> listSalesmanId = EntityUtil.getFieldListFromEntityList(
						EntityUtil.filterByDate(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdFrom", partyId, "roleTypeIdFrom", "DELYS_DISTRIBUTOR","roleTypeIdTo", "DELYS_SALESMAN_GT", "partyRelationshipTypeId", "SALES_EMPLOYMENT"), null, false)),
						"partyIdTo", true);
				listAllConditions.add(EntityCondition.makeCondition("partyId", EntityOperator.IN, listSalesmanId));
				EntityCondition tmpCondition = EntityCondition.makeCondition(listAllConditions, EntityOperator.AND);
				listIterator = delegator.find("PartyNameView", tmpCondition, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListSalesmanByDist service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
    
   	public static Map<String, Object> getGeneralInformationOfParty(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	
       	String partyId = (String) context.get("partyId");
       	GenericValue partyNameView = null;
       	List<GenericValue> postalAddress = new ArrayList<GenericValue>();
       	String phone = null;
       	String email = null;
   		try {
   			partyNameView = EntityUtil.getFirst(delegator.findByAnd("PartyNameView", UtilMisc.toMap("partyId", partyId), null, false));
   			List<GenericValue> listPartyContactMech = EntityUtil.filterByDate(delegator.findByAnd("PartyContactMech", UtilMisc.toMap("partyId", partyId), null, false));
			if (UtilValidate.isNotEmpty(listPartyContactMech)) {
				for (GenericValue partyContactMech : listPartyContactMech) {
					GenericValue contactMech = delegator.findOne("ContactMech", UtilMisc.toMap("contactMechId", partyContactMech.get("contactMechId")), false);
					if (UtilValidate.isNotEmpty(contactMech)) {
						String contactMechTypeId = contactMech.getString("contactMechTypeId");
						//ContactMechTypeIdEnum contactMechTypeIdEnum = ContactMechTypeIdEnum.valueOf(contactMechTypeId);
						//if (UtilValidate.isNotEmpty(contactMechTypeIdEnum)) {
							if ("POSTAL_ADDRESS".equals(contactMechTypeId)) {
								GenericValue postalAddress1 = delegator.findOne("PostalAddress", UtilMisc.toMap("contactMechId", contactMech.get("contactMechId")), false);
								if (UtilValidate.isNotEmpty(postalAddress1)) {
									postalAddress.add(postalAddress1);
								}
							} else if ("EMAIL_ADDRESS".equals(contactMechTypeId)) {
								email = contactMech.getString("infoString");
							} else if ("TELECOM_NUMBER".equals(contactMechTypeId)) {
								GenericValue telecomNumber = delegator.findOne("TelecomNumber", UtilMisc.toMap("contactMechId", contactMechTypeId), false);
								if (UtilValidate.isNotEmpty(telecomNumber)) {
									phone = "(" + telecomNumber.getString("countryCode") + " - " + telecomNumber.getString("areaCode") + ") " + telecomNumber.getString("contactNumber");
								}
							}
						//}
					}
				}
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling getGeneralInformationOfParty service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("partyId", partyId);
    	successResult.put("partyNameView", partyNameView);
    	successResult.put("postalAddress", postalAddress);
    	successResult.put("phone", phone);
    	successResult.put("email", email);
    	return successResult;
	}
   	
   	public static Map<String, Object> createPartyDistributor(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	LocalDispatcher dispatcher = ctx.getDispatcher();
       	Locale locale = (Locale) context.get("locale");
       	Security security = ctx.getSecurity();
       	GenericValue userLogin = (GenericValue) context.get("userLogin");
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	String partyId = (String) context.get("partyId");
       	
       	String organizationalUnitName = (String) context.get("organizationalUnitName");
       	String parentOrgId = (String) context.get("parentOrgId"); // party supervisor (SUP)
       	String functions = (String) context.get("functions");
       	String officeSiteName = (String) context.get("officeSiteName");
       	String address1 = (String) context.get("address1");
       	String emailAddress = (String) context.get("emailAddress");
       	String countryGeoId = (String) context.get("countryGeoId");
       	String stateProvinceGeoId = (String) context.get("stateProvinceGeoId");
       	String countryCode = (String) context.get("countryCode");
       	String areaCode = (String) context.get("areaCode");
       	String contactNumber = (String) context.get("contactNumber");
       	String currencyUomId = (String) context.get("currencyUomId");
       	String description = (String) context.get("description");
       	String countyGeoId = (String) context.get("countyGeoId");
       	String useForShippingAddress = (String) context.get("useForShippingAddress");
       	String userLoginIdStr = (String) context.get("userLoginIdStr");
       	String currentPassword = (String) context.get("currentPassword");
       	String currentPasswordVerify = (String) context.get("currentPasswordVerify");
       	String passwordHint = (String) context.get("passwordHint");
       	String requirePasswordChange = (String) context.get("requirePasswordChange");
       	
       	if (!security.hasPermission("PARTYDIST_CREATE", userLogin) && !security.hasPermission("PARTYDIST_ADMIN", userLogin)) {
       		return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAYouHavenotCreatePermission", locale));
       	}
       	
       	try {
       		if (UtilValidate.isEmpty(organizationalUnitName)) {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANameCannotEmpty", locale));
       		}
       		if (UtilValidate.isNotEmpty(parentOrgId)) {
       			GenericValue partyParentOrg = delegator.findOne("Party", UtilMisc.toMap("partyId", parentOrgId), false);
       			if (UtilValidate.isEmpty(partyParentOrg)) {
       				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundPartyWithId", locale));
       			}
       		} else {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DASupervisorCannotEmpty", locale));
       		}
       		if (UtilValidate.isEmpty(userLoginIdStr) || UtilValidate.isEmpty(currentPassword) || UtilValidate.isEmpty(currentPasswordVerify)) {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAUserLoginAndPasswordCannotEmpty", locale));
       		}
       		
       		Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
       		
       		// create Party Group
       		if (UtilValidate.isEmpty(partyId)) {
       			partyId = delegator.getNextSeqId("Party");
       		}
       		Map<String, Object> contextMapDistributor = UtilMisc.<String, Object>toMap("partyId", partyId, "partyTypeId", "PARTY_GROUP", "preferredCurrencyUomId", 
       				currencyUomId, "description", description, "statusId", "PARTY_ENABLED", "createdDate", nowTimestamp, "createdByUserLogin", userLogin.get("userLoginId"), 
       				"lastModifiedDate", nowTimestamp, "lastModifiedByUserLogin", userLogin.get("userLoginId"));
       		GenericValue distributor = delegator.makeValue("Party", contextMapDistributor);
       		delegator.create(distributor);
       		
       		GenericValue distParty = delegator.findOne("Party", UtilMisc.toMap("partyId", partyId), false);
       		if (distParty != null) {
       			GenericValue partyGroup = delegator.makeValue("PartyGroup");
        		partyGroup.set("partyId", partyId);
        		partyGroup.set("groupName", organizationalUnitName);
        		partyGroup.set("officeSiteName", officeSiteName);
        		partyGroup.set("comments", functions);
        		delegator.create(partyGroup);
        		
        		// create roles
        		List<GenericValue> partyRoles = new LinkedList<GenericValue>();
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "DELYS_DISTRIBUTOR")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "MANAGER"))); // role in productStore of it
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "CUSTOMER"))); // role in productStore of other store
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "DISTRIBUTOR")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "OWNER")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "CHILD_MEMBER")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "BILL_TO_CUSTOMER")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "END_USER_CUSTOMER")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "PLACING_CUSTOMER")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "SHIP_TO_CUSTOMER")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "BILL_FROM_VENDOR")));
        		delegator.storeAll(partyRoles);
        		
        		// create contactMech
        		if (UtilValidate.isNotEmpty(address1) || UtilValidate.isNotEmpty(countryGeoId) || UtilValidate.isNotEmpty(stateProvinceGeoId) || UtilValidate.isNotEmpty(countyGeoId)) {
        			String contactMechIdPA = delegator.getNextSeqId("ContactMech");
        			GenericValue contactMechPA = delegator.makeValue("ContactMech", UtilMisc.toMap("contactMechId", contactMechIdPA, "contactMechTypeId", "POSTAL_ADDRESS"));
        			delegator.create(contactMechPA);
        			
        			Map<String, Object> contextMapPostalAddress = UtilMisc.<String, Object>toMap("contactMechId", contactMechIdPA, 
        					"address1", address1, "countryGeoId", countryGeoId, "stateProvinceGeoId", stateProvinceGeoId, "countyGeoId", countyGeoId);
        			GenericValue postalAddress = delegator.makeValue("PostalAddress", contextMapPostalAddress);
        			delegator.create(postalAddress);
        			
        			GenericValue partyContactMech = delegator.makeValue("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdPA, "fromDate", nowTimestamp, "roleTypeId", "DELYS_DISTRIBUTOR", "allowSolicitation", "Y"));
        			delegator.create(partyContactMech);
        			
        			GenericValue partyContactMechPurpose = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdPA, "contactMechPurposeTypeId", "PRIMARY_LOCATION", "fromDate", nowTimestamp));
        			delegator.create(partyContactMechPurpose);
        			
        			if ("Y".equals(useForShippingAddress)) {
        				GenericValue partyContactMechPurposeShip = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdPA, "contactMechPurposeTypeId", "SHIPPING_LOCATION", "fromDate", nowTimestamp));
            			delegator.create(partyContactMechPurposeShip);
        			}
        		}
        		if (UtilValidate.isNotEmpty(countryCode) || UtilValidate.isNotEmpty(areaCode) || UtilValidate.isNotEmpty(contactNumber)) {
        			String contactMechIdTE = delegator.getNextSeqId("ContactMech");
        			GenericValue contactMechTE = delegator.makeValue("ContactMech", UtilMisc.toMap("contactMechId", contactMechIdTE, "contactMechTypeId", "TELECOM_NUMBER"));
        			delegator.create(contactMechTE);
        			
        			Map<String, Object> contextMapTelecom = UtilMisc.<String, Object>toMap("contactMechId", contactMechIdTE, 
        					"countryCode", countryCode, "areaCode", areaCode, "contactNumber", contactNumber);
        			GenericValue telecomNumber = delegator.makeValue("TelecomNumber", contextMapTelecom);
        			delegator.create(telecomNumber);
        			
        			GenericValue partyContactMech = delegator.makeValue("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdTE, "fromDate", nowTimestamp, "roleTypeId", "DELYS_DISTRIBUTOR", "allowSolicitation", "Y"));
        			delegator.create(partyContactMech);
        			
        			GenericValue partyContactMechPurpose = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdTE, "contactMechPurposeTypeId", "PRIMARY_PHONE", "fromDate", nowTimestamp));
        			delegator.create(partyContactMechPurpose);
        		}
        		if (UtilValidate.isNotEmpty(emailAddress)) {
        			String contactMechId = delegator.getNextSeqId("ContactMech");
        			GenericValue contactMech = delegator.makeValue("ContactMech", UtilMisc.toMap("contactMechId", contactMechId, "contactMechTypeId", "EMAIL_ADDRESS", "infoString", emailAddress));
        			delegator.create(contactMech);
        			
        			GenericValue partyContactMech = delegator.makeValue("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechId, "fromDate", nowTimestamp, "roleTypeId", "DELYS_DISTRIBUTOR", "allowSolicitation", "Y"));
        			delegator.create(partyContactMech);
        			
        			GenericValue partyContactMechPurpose = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechId, "contactMechPurposeTypeId", "PRIMARY_EMAIL", "fromDate", nowTimestamp));
        			delegator.create(partyContactMechPurpose);
        		}
        		
        		// create party relationship
        		String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
        		List<GenericValue> listPartyRel = new LinkedList<GenericValue>();
				GenericValue partyRel1 = delegator.makeValue("PartyRelationship", UtilMisc.toMap("partyIdFrom", companyId, "partyIdTo", partyId, 
						"roleTypeIdFrom", "INTERNAL_ORGANIZATIO", "roleTypeIdTo", "DELYS_DISTRIBUTOR", "fromDate", nowTimestamp, "partyRelationshipTypeId", "GROUP_ROLLUP"));
        		listPartyRel.add(partyRel1);
        		
        		GenericValue partyRel2 = delegator.makeValue("PartyRelationship", UtilMisc.toMap("partyIdFrom", partyId, "partyIdTo", "DELYS_DISTRIBUTOR", 
						"roleTypeIdFrom", "CHILD_MEMBER", "roleTypeIdTo", "PARENT_MEMBER", "fromDate", nowTimestamp, "partyRelationshipTypeId", "CHILD"));
        		listPartyRel.add(partyRel2);
        		
        		if (UtilValidate.isNotEmpty(parentOrgId)) {
        			GenericValue partyRel3 = delegator.makeValue("PartyRelationship", UtilMisc.toMap("partyIdFrom", parentOrgId, "partyIdTo", partyId, 
    						"roleTypeIdFrom", "DELYS_SALESSUP_GT", "roleTypeIdTo", "DELYS_DISTRIBUTOR", "fromDate", nowTimestamp, "partyRelationshipTypeId", "GROUP_ROLLUP"));
            		listPartyRel.add(partyRel3);
        		}
        		delegator.storeAll(listPartyRel);
        		
        		// create userLogin
        		GenericValue findUserLogin = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", userLoginIdStr), false);
        		if (UtilValidate.isNotEmpty(findUserLogin)) {
        			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAUserLoginHasExisted", locale));
        		}
        		
        		//GenericValue systemUser = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", "system"), false);
        		Map<String, Object> contextMapUserLogin = UtilMisc.<String, Object>toMap("userLoginId", userLoginIdStr, "currentPassword", currentPassword, "currentPasswordVerify", currentPasswordVerify, 
        				"passwordHint", passwordHint, "requirePasswordChange", requirePasswordChange, "partyId", partyId, "userLogin", userLogin);
        		Map<String, Object> resultValue = dispatcher.runSync("createUserLogin", contextMapUserLogin);
        		if (ServiceUtil.isError(resultValue)) {
        			return resultValue;
        		}
        		
        		GenericValue userLoginSecurityGroupDist = delegator.makeValue("UserLoginSecurityGroup", UtilMisc.toMap("userLoginId", userLoginIdStr, "groupId", "DELYS_DISTRIBUTOR", "fromDate", nowTimestamp));
        		delegator.create(userLoginSecurityGroupDist);
        		/*
				<entity-condition list="contactMechList" entity-name="PartyContactMechPurposeView">
					<condition-list combine="and">
						<condition-expr field-name="partyId" operator="equals"
							value="${partyId}" />
						<condition-expr field-name="contactMechPurposeTypeId"
							operator="equals" value="PRIMARY_EMAIL" />
					</condition-list>
				</entity-condition>
				
				<iterate entry="contactMech" list="contactMechList">
					<set field="sendTo" from-field="contactMech.infoString" />
				</iterate>
		
				<property-to-field resource="general" property="mail.smtp.auth.user"
					field="sendFrom" />
				<property-to-field resource="general"
					property="mail.smtp.auth.password" field="authPass" />
				<set field="url" value="https://192.168.0.11:28443/hrolbius/control/main"/>
				<set field="emailCtx.sendTo" value="${sendTo}" />
				<set field="emailCtx.sendFrom" value="${authUser}" />
				<set field="emailCtx.authPass" value="${authPass}" />
				<set field="emailCtx.authUser" value="${authUser}" />
				<set field="emailCtx.emailTemplateSettingId" value="USERLOGIN_NOTI" />
				<set field="emailCtx.partyId" from-field="parameters.partyId" />
				<set field="emailCtx.subject" value="[HRM-OLBIUS]Thông báo tài khoản đăng nhập hệ thống" />
				<set field="emailCtx.bodyParameters.url" from-field="url" />
				<set field="emailCtx.bodyParameters.partyId" from-field="parameters.partyId" />
				<set field="emailCtx.bodyParameters.userName" from-field="parameters.userLoginId" />
				<set field="emailCtx.bodyParameters.password" from-field="parameters.currentPassword" />
				<call-service service-name="sendMailFromTemplateSetting" in-map-name="emailCtx"></call-service>
        		 */
       		} else {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DACreatePartyNotSuccessful", locale));
       		}
       	} catch (Exception e) {
			String errMsg = "Fatal error calling createPartyDistributor service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
       	successResult.put("partyId", partyId);
    	return successResult;
	}
   	
   	@SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListSalesman(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	opts.setDistinct(true);
		try {
			if (UtilValidate.isNotEmpty(userLogin) && UtilValidate.isNotEmpty(userLogin.get("partyId"))) {
				if (SalesPartyUtil.isSupervisorEmployee(userLogin, delegator)) {
					// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
		        	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					
					listIterator = SalesPartyUtil.getListSalesmanActiveBySupervisor(userLogin.getString("partyId"), listSortFields, listAllConditions, opts, delegator);
				} else if (SalesPartyUtil.isSalesAdminManagerEmployee(userLogin, delegator) || SalesPartyUtil.isSalesAdminGTEmployee(userLogin, delegator)) {
					String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
					
					//listIterator = SalesPartyUtil.getListDistributorActiveByOrganization(companyId, listSortFields, listAllConditions, opts, delegator);
					// get DSA department
					List<String> dsaDepId = EntityUtil.getFieldListFromEntityList(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdFrom", companyId, "roleTypeIdTo", "DEPARTMENT", "partyRelationshipTypeId", "GROUP_ROLLUP"), null, false),
											"partyIdTo", true);
					List<EntityCondition> listCond1 = FastList.newInstance();
					listCond1.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_NBD"));
					listCond1.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond1.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, dsaDepId));
					List<String> nbdIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond1, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond2 = FastList.newInstance();
					listCond2.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_CSM_GT"));
					listCond2.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, nbdIds));
					List<String> csmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond2, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond3 = FastList.newInstance();
					listCond3.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_RSM_GT"));
					listCond3.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond3.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, csmIds));
					List<String> rsmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond3, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond4 = FastList.newInstance();
					listCond4.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_ASM_GT"));
					listCond4.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond4.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, rsmIds));
					List<String> asmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond4, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond5 = FastList.newInstance();
					listCond5.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_SALESSUP_GT"));
					listCond5.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond5.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, asmIds));
					List<String> supIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond5, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					listIterator = SalesPartyUtil.getListSalesmanActiveBySupervisorDepartment(supIds, listSortFields, listAllConditions, opts, delegator);
					/*
					<PartyRelationship partyIdFrom="company" partyIdTo="DSA" roleTypeIdFrom="PARENT_ORGANIZATION" roleTypeIdTo="DEPARTMENT" fromDate="2014-03-21 16:07:33" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="DSA" partyIdTo="NBD" roleTypeIdFrom="DEPARTMENT" roleTypeIdTo="DELYS_NBD" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="NBD" partyIdTo="CSM_MT" roleTypeIdFrom="DELYS_NBD" roleTypeIdTo="DELYS_CSM_MT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="CSM_GT" partyIdTo="RSM_GT_VUNG1" roleTypeIdFrom="DELYS_CSM_GT" roleTypeIdTo="DELYS_RSM_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="RSM_GT_VUNG1" partyIdTo="ASM_GT_HANOI" roleTypeIdFrom="DELYS_RSM_GT" roleTypeIdTo="DELYS_ASM_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="ASM_GT_HANOI" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="DELYS_ASM_GT" roleTypeIdTo="DELYS_SALESSUP_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					 */
				}
				//listIterator = delegator.find("FacilityLocation", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListSalesman service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
   	
   	@SuppressWarnings("unchecked")
	public static Map<String, Object> jqGetListSupervisorDepartmentInRel(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	//Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	opts.setDistinct(true);
		try {
			if (UtilValidate.isNotEmpty(userLogin) && UtilValidate.isNotEmpty(userLogin.get("partyId"))) {
				if (SalesPartyUtil.isSupervisorEmployee(userLogin, delegator)) {
					// <PartyRelationship partyIdFrom="salessup1" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="MANAGER" roleTypeIdTo="INTERNAL_ORGANIZATIO" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="MANAGER"/>
		        	// <PartyRelationship partyIdFrom="SUP1_GT_HANOI" partyIdTo="NPP_TUANMINH" roleTypeIdFrom="DELYS_SALESSUP_GT" roleTypeIdTo="DELYS_DISTRIBUTOR" 
		        	// fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					
					listIterator = SalesPartyUtil.getListSalesmanActiveBySupervisor(userLogin.getString("partyId"), listSortFields, listAllConditions, opts, delegator);
				} else if (SalesPartyUtil.isSalesAdminManagerEmployee(userLogin, delegator)) {
					String companyId = EntityUtilProperties.getPropertyValue("general.properties", "ORGANIZATION_PARTY", "company", delegator);
					
					//listIterator = SalesPartyUtil.getListDistributorActiveByOrganization(companyId, listSortFields, listAllConditions, opts, delegator);
					// get DSA department
					List<String> dsaDepId = EntityUtil.getFieldListFromEntityList(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdFrom", companyId, "roleTypeIdTo", "DEPARTMENT", "partyRelationshipTypeId", "GROUP_ROLLUP"), null, false),
											"partyIdTo", true);
					List<EntityCondition> listCond1 = FastList.newInstance();
					listCond1.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_NBD"));
					listCond1.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond1.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, dsaDepId));
					List<String> nbdIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond1, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond2 = FastList.newInstance();
					listCond2.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_CSM_GT"));
					listCond2.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond2.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, nbdIds));
					List<String> csmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond2, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond3 = FastList.newInstance();
					listCond3.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_RSM_GT"));
					listCond3.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond3.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, csmIds));
					List<String> rsmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond3, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					List<EntityCondition> listCond4 = FastList.newInstance();
					listCond4.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_ASM_GT"));
					listCond4.add(EntityCondition.makeCondition("partyRelationshipTypeId", EntityOperator.EQUALS, "GROUP_ROLLUP"));
					listCond4.add(EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, rsmIds));
					List<String> asmIds = EntityUtil.getFieldListFromEntityList(delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond4, EntityOperator.AND), null, null, null, false), 
										"partyIdTo", true);
					
					listIterator = SalesPartyUtil.getListSupDepartmentActiveByAsmDepartment(asmIds, listSortFields, listAllConditions, opts, delegator);
					/*
					<PartyRelationship partyIdFrom="company" partyIdTo="DSA" roleTypeIdFrom="PARENT_ORGANIZATION" roleTypeIdTo="DEPARTMENT" fromDate="2014-03-21 16:07:33" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="DSA" partyIdTo="NBD" roleTypeIdFrom="DEPARTMENT" roleTypeIdTo="DELYS_NBD" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="NBD" partyIdTo="CSM_MT" roleTypeIdFrom="DELYS_NBD" roleTypeIdTo="DELYS_CSM_MT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="CSM_GT" partyIdTo="RSM_GT_VUNG1" roleTypeIdFrom="DELYS_CSM_GT" roleTypeIdTo="DELYS_RSM_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="RSM_GT_VUNG1" partyIdTo="ASM_GT_HANOI" roleTypeIdFrom="DELYS_RSM_GT" roleTypeIdTo="DELYS_ASM_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					<PartyRelationship partyIdFrom="ASM_GT_HANOI" partyIdTo="SUP1_GT_HANOI" roleTypeIdFrom="DELYS_ASM_GT" roleTypeIdTo="DELYS_SALESSUP_GT" fromDate="2014-03-21 16:07:33.0" partyRelationshipTypeId="GROUP_ROLLUP"/>
					 */
				}
				//listIterator = delegator.find("FacilityLocation", tmpConditon, null, null, listSortFields, opts);
			}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListSalesman service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
   	
   	public static Map<String, Object> createPartySalesman(DispatchContext ctx, Map<String, ? extends Object> context) {
       	Delegator delegator = ctx.getDelegator();
       	LocalDispatcher dispatcher = ctx.getDispatcher();
       	Locale locale = (Locale) context.get("locale");
       	Security security = ctx.getSecurity();
       	GenericValue userLogin = (GenericValue) context.get("userLogin");
       	Map<String, Object> successResult = ServiceUtil.returnSuccess();
       	String partyId = (String) context.get("partyId");
       	
       	String firstName = (String) context.get("firstName");
       	String lastName = (String) context.get("lastName");
       	String middleName = (String) context.get("middleName");
       	String gender = (String) context.get("gender");
       	String roleTypeId = (String) context.get("roleTypeId");
       	String parentOrgId = (String) context.get("parentOrgId"); // party supervisor (SUP)
       	String functions = (String) context.get("functions");
       	Timestamp birthDateT = (Timestamp) context.get("birthDate");
       	String address1 = (String) context.get("address1");
       	String emailAddress = (String) context.get("emailAddress");
       	String countryGeoId = (String) context.get("countryGeoId");
       	String stateProvinceGeoId = (String) context.get("stateProvinceGeoId");
       	String countryCode = (String) context.get("countryCode");
       	String areaCode = (String) context.get("areaCode");
       	String contactNumber = (String) context.get("contactNumber");
       	String currencyUomId = (String) context.get("currencyUomId");
       	String description = (String) context.get("description");
       	String countyGeoId = (String) context.get("countyGeoId");
       	String useForShippingAddress = (String) context.get("useForShippingAddress");
       	String userLoginIdStr = (String) context.get("userLoginIdStr");
       	String currentPassword = (String) context.get("currentPassword");
       	String currentPasswordVerify = (String) context.get("currentPasswordVerify");
       	String passwordHint = (String) context.get("passwordHint");
       	String requirePasswordChange = (String) context.get("requirePasswordChange");
       	
       	if (!security.hasPermission("PARTYDIST_CREATE", userLogin) && !security.hasPermission("PARTYDIST_ADMIN", userLogin)) {
       		return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAYouHavenotCreatePermission", locale));
       	}
       	
       	try {
       		java.sql.Date birthDate = null;
       		if (UtilValidate.isNotEmpty(birthDateT)) {
       			birthDate = new java.sql.Date(birthDateT.getTime());
       		}
       		if (UtilValidate.isEmpty(firstName)) {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANameCannotEmpty", locale));
       		}
       		if (UtilValidate.isEmpty(lastName)) {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DALastNameCannotEmpty", locale));
       		}
       		if (UtilValidate.isNotEmpty(parentOrgId)) {
       			GenericValue partyParentOrg = delegator.findOne("Party", UtilMisc.toMap("partyId", parentOrgId), false);
       			if (UtilValidate.isEmpty(partyParentOrg)) {
       				return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundPartyWithId", locale));
       			}
       		} else {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DASupervisorCannotEmpty", locale));
       		}
       		if (UtilValidate.isEmpty(userLoginIdStr) || UtilValidate.isEmpty(currentPassword) || UtilValidate.isEmpty(currentPasswordVerify)) {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAUserLoginAndPasswordCannotEmpty", locale));
       		}
       		
       		Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
       		
       		// create Party Group
       		if (UtilValidate.isEmpty(partyId)) {
       			partyId = delegator.getNextSeqId("Party");
       		}
       		Map<String, Object> contextMapDistributor = UtilMisc.<String, Object>toMap("partyId", partyId, "partyTypeId", "PERSON", "preferredCurrencyUomId", 
       				currencyUomId, "description", description, "statusId", "PARTY_ENABLED", "createdDate", nowTimestamp, "createdByUserLogin", userLogin.get("userLoginId"), 
       				"lastModifiedDate", nowTimestamp, "lastModifiedByUserLogin", userLogin.get("userLoginId"));
       		GenericValue distributor = delegator.makeValue("Party", contextMapDistributor);
       		delegator.create(distributor);
       		
       		GenericValue distParty = delegator.findOne("Party", UtilMisc.toMap("partyId", partyId), false);
       		if (distParty != null) {
       			GenericValue person = delegator.makeValue("Person");
       			person.set("partyId", partyId);
       			person.set("firstName", firstName);
       			person.set("lastName", lastName);
       			person.set("middleName", middleName);
       			person.set("birthDate", birthDate);
       			person.set("gender", gender);
       			person.set("comments", functions);
        		delegator.create(person);
        		
        		// create roles
        		List<GenericValue> partyRoles = new LinkedList<GenericValue>();
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "EMPLOYEE")));
        		partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "SALES_REP")));
        		if (UtilValidate.isNotEmpty(roleTypeId)) {
        			partyRoles.add(delegator.makeValue("PartyRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", roleTypeId)));
        		}
        		delegator.storeAll(partyRoles);
        		
        		// create contactMech
        		if (UtilValidate.isNotEmpty(address1) || UtilValidate.isNotEmpty(countryGeoId) || UtilValidate.isNotEmpty(stateProvinceGeoId) || UtilValidate.isNotEmpty(countyGeoId)) {
        			String contactMechIdPA = delegator.getNextSeqId("ContactMech");
        			GenericValue contactMechPA = delegator.makeValue("ContactMech", UtilMisc.toMap("contactMechId", contactMechIdPA, "contactMechTypeId", "POSTAL_ADDRESS"));
        			delegator.create(contactMechPA);
        			
        			Map<String, Object> contextMapPostalAddress = UtilMisc.<String, Object>toMap("contactMechId", contactMechIdPA, 
        					"address1", address1, "countryGeoId", countryGeoId, "stateProvinceGeoId", stateProvinceGeoId, "countyGeoId", countyGeoId);
        			GenericValue postalAddress = delegator.makeValue("PostalAddress", contextMapPostalAddress);
        			delegator.create(postalAddress);
        			
        			GenericValue partyContactMech = delegator.makeValue("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdPA, "fromDate", nowTimestamp, "roleTypeId", "DELYS_DISTRIBUTOR", "allowSolicitation", "Y"));
        			delegator.create(partyContactMech);
        			
        			GenericValue partyContactMechPurpose = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdPA, "contactMechPurposeTypeId", "PRIMARY_LOCATION", "fromDate", nowTimestamp));
        			delegator.create(partyContactMechPurpose);
        			
        			if ("Y".equals(useForShippingAddress)) {
        				GenericValue partyContactMechPurposeShip = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdPA, "contactMechPurposeTypeId", "SHIPPING_LOCATION", "fromDate", nowTimestamp));
            			delegator.create(partyContactMechPurposeShip);
        			}
        		}
        		if (UtilValidate.isNotEmpty(countryCode) || UtilValidate.isNotEmpty(areaCode) || UtilValidate.isNotEmpty(contactNumber)) {
        			String contactMechIdTE = delegator.getNextSeqId("ContactMech");
        			GenericValue contactMechTE = delegator.makeValue("ContactMech", UtilMisc.toMap("contactMechId", contactMechIdTE, "contactMechTypeId", "TELECOM_NUMBER"));
        			delegator.create(contactMechTE);
        			
        			Map<String, Object> contextMapTelecom = UtilMisc.<String, Object>toMap("contactMechId", contactMechIdTE, 
        					"countryCode", countryCode, "areaCode", areaCode, "contactNumber", contactNumber);
        			GenericValue telecomNumber = delegator.makeValue("TelecomNumber", contextMapTelecom);
        			delegator.create(telecomNumber);
        			
        			GenericValue partyContactMech = delegator.makeValue("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdTE, "fromDate", nowTimestamp, "roleTypeId", "DELYS_DISTRIBUTOR", "allowSolicitation", "Y"));
        			delegator.create(partyContactMech);
        			
        			GenericValue partyContactMechPurpose = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechIdTE, "contactMechPurposeTypeId", "PRIMARY_PHONE", "fromDate", nowTimestamp));
        			delegator.create(partyContactMechPurpose);
        		}
        		if (UtilValidate.isNotEmpty(emailAddress)) {
        			String contactMechId = delegator.getNextSeqId("ContactMech");
        			GenericValue contactMech = delegator.makeValue("ContactMech", UtilMisc.toMap("contactMechId", contactMechId, "contactMechTypeId", "EMAIL_ADDRESS", "infoString", emailAddress));
        			delegator.create(contactMech);
        			
        			GenericValue partyContactMech = delegator.makeValue("PartyContactMech", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechId, "fromDate", nowTimestamp, "roleTypeId", "DELYS_DISTRIBUTOR", "allowSolicitation", "Y"));
        			delegator.create(partyContactMech);
        			
        			GenericValue partyContactMechPurpose = delegator.makeValue("PartyContactMechPurpose", UtilMisc.toMap("partyId", partyId, "contactMechId", contactMechId, "contactMechPurposeTypeId", "PRIMARY_EMAIL", "fromDate", nowTimestamp));
        			delegator.create(partyContactMechPurpose);
        		}
        		
        		// create party relationship
        		List<GenericValue> listPartyRel = new LinkedList<GenericValue>();
				GenericValue partyRel1 = delegator.makeValue("PartyRelationship", UtilMisc.toMap("partyIdFrom", parentOrgId, "partyIdTo", partyId, 
						"roleTypeIdFrom", "INTERNAL_ORGANIZATIO", "roleTypeIdTo", "EMPLOYEE", "fromDate", nowTimestamp, "partyRelationshipTypeId", "EMPLOYMENT"));
        		listPartyRel.add(partyRel1);
        		
        		GenericValue partyRel2 = delegator.makeValue("PartyRelationship", UtilMisc.toMap("partyIdFrom", partyId, "partyIdTo", parentOrgId, 
						"roleTypeIdFrom", roleTypeId, "roleTypeIdTo", "INTERNAL_ORGANIZATIO", "fromDate", nowTimestamp, "partyRelationshipTypeId", "SALES_EMPLOYEE"));
        		listPartyRel.add(partyRel2);
        		delegator.storeAll(listPartyRel);
        		
        		// create userLogin
        		GenericValue findUserLogin = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", userLoginIdStr), false);
        		if (UtilValidate.isNotEmpty(findUserLogin)) {
        			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAUserLoginHasExisted", locale));
        		}
        		
        		//GenericValue systemUser = delegator.findOne("UserLogin", UtilMisc.toMap("userLoginId", "system"), false);
        		Map<String, Object> contextMapUserLogin = UtilMisc.<String, Object>toMap("userLoginId", userLoginIdStr, "currentPassword", currentPassword, "currentPasswordVerify", currentPasswordVerify, 
        				"passwordHint", passwordHint, "requirePasswordChange", requirePasswordChange, "partyId", partyId, "userLogin", userLogin);
        		Map<String, Object> resultValue = dispatcher.runSync("createUserLogin", contextMapUserLogin);
        		if (ServiceUtil.isError(resultValue)) {
        			return resultValue;
        		}
        		
        		List<GenericValue> listPartyULSG = new LinkedList<GenericValue>();
        		GenericValue userLoginSecurityGroupDist = delegator.makeValue("UserLoginSecurityGroup", UtilMisc.toMap("userLoginId", userLoginIdStr, "groupId", roleTypeId, "fromDate", nowTimestamp));
        		listPartyULSG.add(userLoginSecurityGroupDist);
        		
        		GenericValue userLoginSecurityGroupDist2 = delegator.makeValue("UserLoginSecurityGroup", UtilMisc.toMap("userLoginId", userLoginIdStr, "groupId", "DELYS_EMPLOYEE", "fromDate", nowTimestamp));
        		listPartyULSG.add(userLoginSecurityGroupDist2);
        		
        		delegator.storeAll(listPartyULSG);
        		/*
				<entity-condition list="contactMechList" entity-name="PartyContactMechPurposeView">
					<condition-list combine="and">
						<condition-expr field-name="partyId" operator="equals"
							value="${partyId}" />
						<condition-expr field-name="contactMechPurposeTypeId"
							operator="equals" value="PRIMARY_EMAIL" />
					</condition-list>
				</entity-condition>
				
				<iterate entry="contactMech" list="contactMechList">
					<set field="sendTo" from-field="contactMech.infoString" />
				</iterate>
		
				<property-to-field resource="general" property="mail.smtp.auth.user"
					field="sendFrom" />
				<property-to-field resource="general"
					property="mail.smtp.auth.password" field="authPass" />
				<set field="url" value="https://192.168.0.11:28443/hrolbius/control/main"/>
				<set field="emailCtx.sendTo" value="${sendTo}" />
				<set field="emailCtx.sendFrom" value="${authUser}" />
				<set field="emailCtx.authPass" value="${authPass}" />
				<set field="emailCtx.authUser" value="${authUser}" />
				<set field="emailCtx.emailTemplateSettingId" value="USERLOGIN_NOTI" />
				<set field="emailCtx.partyId" from-field="parameters.partyId" />
				<set field="emailCtx.subject" value="[HRM-OLBIUS]Thông báo tài khoản đăng nhập hệ thống" />
				<set field="emailCtx.bodyParameters.url" from-field="url" />
				<set field="emailCtx.bodyParameters.partyId" from-field="parameters.partyId" />
				<set field="emailCtx.bodyParameters.userName" from-field="parameters.userLoginId" />
				<set field="emailCtx.bodyParameters.password" from-field="parameters.currentPassword" />
				<call-service service-name="sendMailFromTemplateSetting" in-map-name="emailCtx"></call-service>
        		 */
       		} else {
       			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DACreatePartyNotSuccessful", locale));
       		}
       	} catch (Exception e) {
			String errMsg = "Fatal error calling createPartyDistributor service: " + e.toString();
			Debug.logError(e, errMsg, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DACreatePartyNotSuccessful", locale));
		}
       	successResult.put("partyId", partyId);
    	return successResult;
	}
   	
   	public static Map<String, Object> sendNotifyChangeOrderStatus(DispatchContext ctx, Map<String, ? extends Object> context) {
   		Map<String, Object> successResult = ServiceUtil.returnSuccess();
   		Delegator delegator = ctx.getDelegator();
   		LocalDispatcher dispatcher = ctx.getDispatcher();
   		GenericValue userLogin = (GenericValue) context.get("userLogin");
   		Locale locale = (Locale) context.get("locale");
   		
   		String orderId = (String) context.get("orderId");
   		String ntfId = (String) context.get("ntfId");
        if (UtilValidate.isNotEmpty(ntfId)) {
        	try {
        		dispatcher.runSync("updateNotification", UtilMisc.toMap("ntfId", ntfId, "userLogin", userLogin));
	        } catch (Exception e) {
	     		Debug.logError(e, "Error when close notify", module);
	     		return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAErrorWhenCloseNotify", locale));
	     	}
        }
        
        if (UtilValidate.isEmpty(orderId)) {
        	return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAOrderIdCannotEmpty", locale));
        }
        GenericValue orderHeader = null;
        try {
	        orderHeader = delegator.findOne("OrderHeader", UtilMisc.toMap("orderId", orderId), false);
	        if (UtilValidate.isEmpty(orderHeader)) {
	        	return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundOrderWithId", UtilMisc.toMap("orderId", orderId), locale));
	        }
        } catch (Exception e) {
     		Debug.logError(e, "Error when get order", module);
     		return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DANotFoundOrderWithId", UtilMisc.toMap("orderId", orderId), locale));
     	}
        
        String statusId = orderHeader.getString("statusId");
        
        // TODOCHANGE: check new status of order, create notify to ...
        if (containsOrderStatus(statusId)) {
	        OrderStatusIdEnum statusIdEnum = OrderStatusIdEnum.valueOf(statusId);
	        if (statusIdEnum != null) {
	        	List<String> partiesList = new ArrayList<String>();
	         	String header = "";
	         	String state = "open";
	         	String action = "";
	         	String targetLink = "";
	         	String ntfType = "MANY";
	         	String sendToGroup = "N";
	         	String sendrecursive = "Y";
	         	Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
	         	try {
	         		if (statusIdEnum == OrderStatusIdEnum.ORDER_SUPAPPROVED) {
	         			// send to sales administrator approve (SalesAdmin of product store)
						String productStoreId = orderHeader.getString("productStoreId");
						if (UtilValidate.isNotEmpty(productStoreId)) {
							if ("SALES_GT_CHANNEL".equals(orderHeader.get("salesMethodChannelEnumId"))) {
								partiesList.addAll(SalesPartyUtil.getListSalesAdminGTIdByProductStore(productStoreId, delegator));
							} else if ("SALES_MT_CHANNEL".equals(orderHeader.get("salesMethodChannelEnumId"))) {
								partiesList.addAll(SalesPartyUtil.getListSalesAdminMTIdByProductStore(productStoreId, delegator));
							} else {
								partiesList.addAll(SalesPartyUtil.getListSalesAdminIdByProductStore(productStoreId, delegator));
							}
							header = UtilProperties.getMessage(resource, "DAApproveOrder", locale) + " [" + orderId +"]";
						}
	         		} else if (statusIdEnum == OrderStatusIdEnum.ORDER_SADAPPROVED) {
	         			// send to placing customer - distributor
						List<String> listDistributorId = EntityUtil.getFieldListFromEntityList(delegator.findByAnd("OrderRole", UtilMisc.toMap("orderId", orderId, "roleTypeId", "PLACING_CUSTOMER"), null, false), "partyId", true);
						if (UtilValidate.isNotEmpty(listDistributorId)) {
							partiesList.addAll(listDistributorId);
							sendToGroup = "Y";
							sendrecursive = "N";
						}
						header = UtilProperties.getMessage(resource, "DAApproveOrderAndAttachPaymentOrder", locale) + " [" + orderId + "]";
	         		} else if (statusIdEnum == OrderStatusIdEnum.ORDER_APPROVED) {
						// send to logistic
						/*List<String> listLogistic = SalesPartyUtil.getLogsSpecialist(delegator);
	        			if (UtilValidate.isNotEmpty(listLogistic)) {
	        				partiesList.addAll(listLogistic);
	        			}
	        			header = UtilProperties.getMessage(resource, "DAAccoutantWasApprovedOrder",locale) + " [" + orderId +"]";*/
	        			header = UtilProperties.getMessage(resource, "DAAccoutantWasApprovedOrder", locale) + " [" + orderId +"]";
	        			action = "orderView";
	             		targetLink = "orderId="+orderId;
	        			Map<String, Object> createNotification = UtilMisc.<String, Object>toMap("userLogin", userLogin, "state", state, "dateTime", nowTimestamp, 
	        					"header", header, "ntfType", ntfType, "action", action, "targetLink", targetLink, "roleTypeId", "LOG_SPECIALIST");
						try {
			         		Map<String, Object> tmpResult = dispatcher.runSync("createNotification", createNotification);
			         		if (ServiceUtil.isError(tmpResult)) {
			         			return ServiceUtil.returnError(ServiceUtil.getErrorMessage(tmpResult));
			         		}
			         	} catch (Exception e) {
			     			Debug.logError(e, "Error when create notify", module);
			     			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAErrorWhenCreateNotify", locale));
			     		}
					} else if (statusIdEnum == OrderStatusIdEnum.ORDER_COMPLETED) {
						// send to placing customer - distributor
						List<String> listDistributorId = EntityUtil.getFieldListFromEntityList(delegator.findByAnd("OrderRole", UtilMisc.toMap("orderId", orderId, "roleTypeId", "PLACING_CUSTOMER"), null, false), "partyId", true);
						if (UtilValidate.isNotEmpty(listDistributorId)) {
							partiesList.addAll(listDistributorId);
							sendToGroup = "Y";
							sendrecursive = "N";
						}
						ntfType = "ONE";
	         			header = UtilProperties.getMessage(resource, "DAOrderComplete", locale) + " [" + orderId +"]";
					} else if (statusIdEnum == OrderStatusIdEnum.ORDER_CANCELLED) {
						// send to placing customer - distributor
						List<String> listDistributorId = EntityUtil.getFieldListFromEntityList(delegator.findByAnd("OrderRole", UtilMisc.toMap("orderId", orderId, "roleTypeId", "PLACING_CUSTOMER"), null, false), "partyId", true);
						if (UtilValidate.isNotEmpty(listDistributorId)) {
							partiesList.addAll(listDistributorId);
							sendToGroup = "Y";
							sendrecursive = "N";
						}
						ntfType = "ONE";
						header = UtilProperties.getMessage(resource, "DAOrderIsCanceled",locale) + " [" + orderId +"]";
					} else if (statusIdEnum == OrderStatusIdEnum.ORDER_NPPAPPROVED) {
						// send to accountant
						header = UtilProperties.getMessage(resource, "DAApproveOrder", locale) + " [" + orderId +"]";
	        			action = "orderView";
	             		targetLink = "orderId="+orderId;
	        			Map<String, Object> createNotification = UtilMisc.<String, Object>toMap("userLogin", userLogin, "state", state, "dateTime", nowTimestamp, 
	        					"header", header, "ntfType", ntfType, "action", action, "targetLink", targetLink, "roleTypeId", "DELYS_ACCOUNTANTS");
						try {
			         		Map<String, Object> tmpResult = dispatcher.runSync("createNotification", createNotification);
			         		if (ServiceUtil.isError(tmpResult)) {
			         			return ServiceUtil.returnError(ServiceUtil.getErrorMessage(tmpResult));
			         		}
			         	} catch (Exception e) {
			     			Debug.logError(e, "Error when create notify", module);
			     			return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAErrorWhenCreateNotify", locale));
			     		}
					}
	         		action = "orderView";
	         		targetLink = "orderId=" + orderId;
	         		if (UtilValidate.isEmpty(partiesList)) {
	         			return ServiceUtil.returnSuccess();
	         		}
	         		Map<String, Object> tmpResult = dispatcher.runSync("createNotification", UtilMisc.<String, Object>toMap("partiesList", partiesList, "header", header, "state", state, "action", action, "targetLink", targetLink, "dateTime", nowTimestamp, "ntfType", ntfType, "sendToGroup", sendToGroup, "sendrecursive", sendrecursive, "userLogin", userLogin));
	         		if (ServiceUtil.isError(tmpResult)) {
	         			return ServiceUtil.returnError(ServiceUtil.getErrorMessage(tmpResult));
	         		}
	         	} catch (Exception e) {
	         		Debug.logError(e, "Error when set value for notify", module);
	         		return ServiceUtil.returnError(UtilProperties.getMessage(resource_error, "DAErrorWhenCreateNotify", locale));
	         	}
	        }
        }
        successResult.put("orderId", orderId);
    	return successResult;
   	}
   	
   	public static boolean containsOrderStatus(String test) {
		for (OrderStatusIdEnum c : OrderStatusIdEnum.values()) {
   	        if (c.name().equals(test)) {
   	            return true;
   	        }
   	    }
   	    return false;
   	}
}
