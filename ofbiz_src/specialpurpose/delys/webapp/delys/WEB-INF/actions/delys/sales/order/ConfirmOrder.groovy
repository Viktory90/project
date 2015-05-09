import java.util.*;
import org.ofbiz.entity.*;
import org.ofbiz.entity.condition.*;
import org.ofbiz.entity.util.*;
import org.ofbiz.base.util.*;
import org.ofbiz.service.ServiceUtil;
import javolution.util.FastMap;
import java.math.BigDecimal;
import java.math.RoundingMode;

List<Map<String, Object>> listOrderItem = new ArrayList<Map<String, Object>>();
List<String> listWorkEffort = new ArrayList<String>();
List<Map<String, Object>> listItemAdjustment = new ArrayList<Map<String, Object>>();
boolean isFull = false;
if (orderItems != null) {
	/*
	 * DAProduct
	 * DAQuantity
	 * DAUnitPrice
	 * DAQuantityUomId
	 * DAAlternativeQuantity
	 * DAAlternativeUnitPrice
	 * DAAdjustment
	 * DAItemTotal
	 * */
	for (GenericValue orderItem : orderItems) {
		GenericValue itemType = orderItem.getRelatedOne("OrderItemType", false);
		
		String productId = "";
		String itemDescription = "";
		BigDecimal quantity = null;
		BigDecimal unitPrice = null;
		String quantityUomId = "";
		BigDecimal alternativeQuantity = null;
		BigDecimal alternativeUnitPrice = null;
		BigDecimal adjustment = null;
		BigDecimal subTotal = null;
		
		if (orderItem.productId != null && orderItem.productId == "_?_") {
			itemDescription = orderItem.itemDescription;
			isFull = true;
		} else {
			if (orderItem.productId != null) {
				itemDescription = orderItem.productId + "-" + orderItem.itemDescription;
			} else {
				itemDescription = "<b>" + itemType.description + "</b> : " + orderItem.itemDescription;
			}
			
			quantity = orderItem.quantity;
			unitPrice = orderItem.unitPrice;
			quantityUomId = orderItem.quantityUomId;
			alternativeQuantity = orderItem.alternativeQuantity;
			alternativeUnitPrice = orderItem.alternativeUnitPrice;
			adjustment = localOrderReadHelper.getOrderItemAdjustmentsTotal(orderItem);
			subTotal = localOrderReadHelper.getOrderItemSubTotal(orderItem);
		}
		
		Map<String, Object> itemMap = FastMap.newInstance();
		itemMap.put("isFull", isFull);
		itemMap.put("productId", productId);
		itemMap.put("productName", "");
		itemMap.put("itemDescription", itemDescription);
		itemMap.put("quantity", quantity);
		itemMap.put("unitPrice", unitPrice);
		itemMap.put("quantityUomId", quantityUomId);
		itemMap.put("alternativeQuantity", alternativeQuantity);
		itemMap.put("alternativeUnitPrice", alternativeUnitPrice);
		itemMap.put("adjustment", adjustment);
		itemMap.put("itemTotal", subTotal);
		listOrderItem.add(itemMap);
		
		// show info from workeffort if it was a rental item
		if (orderItem.orderItemTypeId != null && orderItem.orderItemTypeId == "RENTAL_ORDER_ITEM") {
			List<GenericValue> workOrderItemFulfillments = orderItem.getRelated("WorkOrderItemFulfillment", null, null, false);
			if (workOrderItemFulfillments != null) {
				GenericValue workOrderItemFulfillment = workOrderItemFulfillments.get(0);
				GenericValue workEffort =  workOrderItemFulfillment.getRelatedOne("WorkEffort", true);
				String workEffortStr = "" + UtilProperties.getMessage("CommonUiLabels", "CommonFrom", locale) + workEffort.estimatedStartDate 
											+ UtilProperties.getMessage("CommonUiLabels", "CommonTo", locale) + workEffort.estimatedCompletionDate 
											+ UtilProperties.getMessage("OrderUiLabels", "OrderNbrPersons", locale) + workEffort.reservPersons;
			}
		}
		
		// now show adjustment details per line item - listItemAdjustment
		List<GenericValue> itemAdjustments = localOrderReadHelper.getOrderItemAdjustments(orderItem);
		for (orderItemAdjustment in itemAdjustments) {
			String itemAdjStr = "<b><i>" + UtilProperties.getMessage("DelysAdminUiLabels", "DAAdjustment", locale) + "</i>:</b> ";
			itemAdjStr += localOrderReadHelper.getAdjustmentType(orderItemAdjustment) + ".&nbsp;";
			if (orderItemAdjustment.description != null) {
				itemAdjStr += ":&nbsp;" + orderItemAdjustment.get("description",locale) + ".&nbsp;";
			}
			if (orderItemAdjustment.orderAdjustmentTypeId == "SALES_TAX") {
				if (orderItemAdjustment.primaryGeoId != null) {
					primaryGeo = orderItemAdjustment.getRelatedOne("PrimaryGeo", true);
					if (primaryGeo.geoName != null) {
						itemAdjStr += "<b>" + UtilProperties.getMessage("OrderUiLabels", "OrderJurisdiction", locale) + ":</b>&nbsp;" + primaryGeo.geoName + "[" + primaryGeo.abbreviation + "].&nbsp;";
					}
					if (orderItemAdjustment.secondaryGeoId != null) {
						secondaryGeo = orderItemAdjustment.getRelatedOne("SecondaryGeo", true);
						itemAdjStr += "(<b>in:</b> "+ secondaryGeo.geoName +"&nbsp;[" + secondaryGeo.abbreviation + "]).&nbsp;";
					}
				}
				if (orderItemAdjustment.sourcePercentage != null) { 
					String template = "#,##0.###";
					sourcePercentageStr = UtilFormatOut.formatDecimalNumber(orderItemAdjustment.sourcePercentage.doubleValue(), template, locale);
					itemAdjStr += "<b>" + UtilProperties.getMessage("OrderUiLabels", "OrderRate", locale) + ":</b>&nbsp;" + sourcePercentageStr + "% &nbsp;";
				}
				if (orderItemAdjustment.customerReferenceId != null) itemAdjStr += "<b>" + UtilProperties.getMessage("OrderUiLabels", "OrderCustomerTaxId", locale) + ":</b> " + orderItemAdjustment.customerReferenceId + "&nbsp;";
				if (orderItemAdjustment.exemptAmount != null) itemAdjStr += "<b>" + UtilProperties.getMessage("OrderUiLabels", "OrderExemptAmount", locale) + ":</b> " + orderItemAdjustment.exemptAmount + "&nbsp;";
			}
			
			Map<String, Object> itemAdjMap = FastMap.newInstance();
			itemAdjMap.put("description", itemAdjStr);
			itemAdjMap.put("value", localOrderReadHelper.getOrderItemAdjustmentTotal(orderItem, orderItemAdjustment));
			listItemAdjustment.add(itemAdjMap);
		}
		
	}
}

context.listOrderItem = listOrderItem;
context.listWorkEffort = listWorkEffort;
context.listItemAdjustment = listItemAdjustment;
context.isFull = isFull;