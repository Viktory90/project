
import java.util.*;

import org.ofbiz.entity.*;
import org.ofbiz.entity.condition.*;
import org.ofbiz.entity.util.*;
import org.ofbiz.base.util.*;
import org.ofbiz.service.ServiceUtil;

import javolution.util.FastMap;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.ofbiz.order.order.OrderReadHelper;
import org.ofbiz.order.order.OrderContentWrapper;

List<Map<String, Object>> listItemLine = new ArrayList<Map<String, Object>>();
BigDecimal taxTotalOrderItems = BigDecimal.ZERO;
BigDecimal subAmountExportOrder = BigDecimal.ZERO;
BigDecimal subAmountExportInvoice = BigDecimal.ZERO;
List<Map<String, Object>> listTaxTotal = new ArrayList<Map<String, Object>>();
Timestamp desiredDeliveryDate = null;
if (orderItemList != null) {
	for (GenericValue orderItem : orderItemList) {
		GenericValue orderItemType = orderItem.getRelatedOne("OrderItemType", false);
		OrderContentWrapper orderItemContentWrapper = OrderContentWrapper.makeOrderContentWrapper(orderItem, request);
		List<GenericValue> orderItemShipGrpInvResList = orderReadHelper.getOrderItemShipGrpInvResList(orderItem);
		if (orderHeader != null && orderHeader.orderTypeId == "SALES_ORDER") {
			BigDecimal pickedQty = orderReadHelper.getItemPickedQuantityBd(orderItem);
		}
		GenericValue product = orderItem.getRelatedOne("Product", false);
		
		String productId = orderItem.getString("productId");
		String seqId = orderItem.getString("orderItemSeqId");
		String itemDescription = orderItem.getString("itemDescription");;
		String supplierProductId = orderItem.getString("supplierProductId");
		GenericValue barcodeGeneric = delegator.findOne("GoodIdentification", ["goodIdentificationTypeId" : "SKU", "productId" : productId], false);
		String barcode = barcodeGeneric.idValue;
		Timestamp expireDate = orderItem.getTimestamp("expireDate");
		String displayPackingPerTray = "";
		
		boolean isNormal = true;
		BigDecimal alternativeQuantity = orderItem.getBigDecimal("alternativeQuantity");
		BigDecimal alternativeUnitPrice = orderItem.getBigDecimal("alternativeUnitPrice");
		if (alternativeQuantity != null && alternativeUnitPrice != null) {
			isNormal = false;
		}
		
		BigDecimal packingPerTray = null;
		Map<String, Object> resultValue = dispatcher.runSync("getConvertPackingNumber", ["productId" : productId, "uomFromId" : "DELYS_KHAY", "uomToId" : product.productPackingUomId, "userLogin" : userLogin]);
		if (ServiceUtil.isSuccess(resultValue)) {
			packingPerTray = resultValue.convertNumber;
		}
		
		String quantityUomDescription = "";
		GenericValue quantityUomGeneric = delegator.findOne("Uom", ["uomId" : orderItem.quantityUomId], false);
		if (quantityUomGeneric != null) {
			if (quantityUomGeneric.description != null) {
				quantityUomDescription = quantityUomGeneric.description;
			} else {
				quantityUomDescription = quantityUomGeneric.uomId;
			}
		}
		
		BigDecimal quantity = null;
		BigDecimal sumTray = null;
		BigDecimal unitPrice = null;
		BigDecimal productQuantityPerTray = null;
		if (isNormal) {
			if (product.productPackingUomId != null) {
				Map<String, Object> resultValue1 = dispatcher.runSync("getConvertPackingNumber", ["productId" : productId, "uomFromId" : "DELYS_KHAY", "uomToId" : product.productPackingUomId, "userLogin" : userLogin]);
				if (ServiceUtil.isSuccess(resultValue1)) {
					productQuantityPerTray = resultValue1.convertNumber;
				}
			}
			quantity = orderItem.quantity;
			if (quantity != null && productQuantityPerTray != null) {
				sumTray = quantity.divide(productQuantityPerTray, 2, RoundingMode.HALF_UP);
			}
			unitPrice = orderItem.unitPrice;
		} else {
			Map<String, Object> resultValue1 = dispatcher.runSync("getConvertPackingNumber", ["productId" : productId, "uomFromId" : "DELYS_KHAY", "uomToId" : orderItem.quantityUomId, "userLogin" : userLogin]);
			if (ServiceUtil.isSuccess(resultValue1)) {
				productQuantityPerTray = resultValue1.convertNumber;
			}
			quantity = orderItem.alternativeQuantity;
			if (quantity != null && productQuantityPerTray != null) {
				sumTray = quantity.divide(productQuantityPerTray, 2, RoundingMode.HALF_UP);
			}
			unitPrice = orderItem.alternativeUnitPrice;
		}
		
		BigDecimal adjustment = OrderReadHelper.getOrderItemAdjustmentsTotal(orderItem, orderAdjustments, true, false, false);
		
		// DASubTotalBeforeVAT
		BigDecimal subTotalBeVAT = OrderReadHelper.getOrderItemSubTotal(orderItem, orderAdjustments);
		if (orderItem.statusId != "ITEM_CANCELLED") {
			subAmountExportOrder = subAmountExportOrder.add(subTotalBeVAT);
		} else {
			subAmountExportOrder = subAmountExportOrder.add(subTotalBeVAT);
		}
		
		// Unit price after VAT
		BigDecimal unitPriceInvoiceAfVAT = null;
		BigDecimal subTotalInvoiceExport = null;
		List<GenericValue> listProductPriceInvoice = delegator.findByAnd("ProductPrice", ["productId" : productId, "productPriceTypeId" : "INVOICE_PRICE_GT"], null, false);
		listProductPriceInvoice = EntityUtil.filterByDate(listProductPriceInvoice);
		GenericValue productPriceInvoiceGeneric = EntityUtil.getFirst(listProductPriceInvoice);
		if (productPriceInvoiceGeneric != null) {
			unitPriceInvoiceAfVAT = productPriceInvoiceGeneric.getBigDecimal("price");
			if (subTotalBeVAT.compareTo(BigDecimal.ZERO) != 0) {
				subTotalInvoiceExport = quantity.multiply(unitPriceInvoiceAfVAT);
			}
		}
		
		if (subTotalInvoiceExport != null) {
			subAmountExportInvoice = subAmountExportInvoice.add(subTotalInvoiceExport);
		}
		
		/* Caculate tax prices sum from order items */
		List<GenericValue> orderItemAdjustments = OrderReadHelper.getOrderItemAdjustmentList(orderItem, orderAdjustments);
		if (orderItemAdjustments != null) {
			for (GenericValue itemAdjustment : orderItemAdjustments) {
				GenericValue adjustmentType = itemAdjustment.getRelatedOne("OrderAdjustmentType", true);
				if (adjustmentType.orderAdjustmentTypeId == "SALES_TAX") {
					BigDecimal taxValue = OrderReadHelper.calcItemAdjustment(itemAdjustment, orderItem);
					taxTotalOrderItems = taxTotalOrderItems.add(taxValue);
					boolean isExists = false;
					for (Map<String, Object> taxTotalItem : listTaxTotal) {
						if (taxTotalItem.sourcePercentage == itemAdjustment.sourcePercentage) {
							// exists item
							BigDecimal amount = (BigDecimal) taxTotalItem.get("amount");
							amount = amount.add(itemAdjustment.getBigDecimal("amount"));
							taxTotalItem.put("amount", amount);
							if (subTotalInvoiceExport != null && subTotalBeVAT != null) {
								BigDecimal amountForInvoicePrice = amount.multiply(subTotalInvoiceExport.divide(subTotalBeVAT, 2, RoundingMode.HALF_UP));
								taxTotalItem.put("amountForIXP", amountForInvoicePrice);
							}
							isExists = true;
						}
					}
					if (!isExists) {
						// not exists item
						Map<String, Object> taxTotalItemNew = FastMap.newInstance();
						BigDecimal amount = itemAdjustment.getBigDecimal("amount");
						taxTotalItemNew.put("sourcePercentage", itemAdjustment.getBigDecimal("sourcePercentage"));
						taxTotalItemNew.put("amount", amount);
						if (subTotalInvoiceExport != null && subTotalBeVAT != null) {
							BigDecimal amountForInvoicePrice = amount.multiply(subTotalInvoiceExport.divide(subTotalBeVAT, 2, RoundingMode.HALF_UP));
							taxTotalItemNew.put("amountForIXP", amountForInvoicePrice);
						}
						// add description in first (only 1 times)
						String description = UtilProperties.getMessage("OrderUiLabels", "OrderAdjustment", locale);
						description += " " + adjustmentType.get("description",locale);
						if (itemAdjustment.description != null) description += itemAdjustment.get("description",locale);
						if (itemAdjustment.comments != null) description += " (" + itemAdjustment.comments + ").&nbsp;";
						if (itemAdjustment.productPromoId != null) {
							description += "<a class='btn btn-mini btn-primary' href='/catalog/control/EditProductPromo?productPromoId=" + itemAdjustment.productPromoId + externalKeyParam + "'>";
							description += itemAdjustment.getRelatedOne("ProductPromo", false).getString("promoName") + "</a>";
						}
						if (itemAdjustment.primaryGeoId != null) {
							GenericValue primaryGeo = itemAdjustment.getRelatedOne("PrimaryGeo", true);
							if (primaryGeo.geoName != null) {
								String orderJurisdictionStr = UtilProperties.getMessage("OrderUiLabels", "OrderJurisdiction", locale);
								description += "<span>" + orderJurisdictionStr + "</span>&nbsp;" + primaryGeo.geoName + " [" + primaryGeo.abbreviation + "].&nbsp;";
							}
							if (itemAdjustment.secondaryGeoId != null) {
								GenericValue secondaryGeo = itemAdjustment.getRelatedOne("SecondaryGeo", true);
								String commonInStr = UtilProperties.getMessage("OrderUiLabels", "OrderJurisdiction", locale);
								description += "<span>" + commonInStr + "</span>&nbsp;" + secondaryGeo.geoName + " [" + secondaryGeo.abbreviation + "]).&nbsp;";
							}
						}
						if (itemAdjustment.sourcePercentage != null) {
							String orderRateStr = UtilProperties.getMessage("OrderUiLabels", "OrderRate", locale);
							String template = "#,##0.###";
							sourcePercentageStr = UtilFormatOut.formatDecimalNumber(itemAdjustment.sourcePercentage.doubleValue(), template, locale);
							description += "<span>" + orderRateStr + "</span>&nbsp;" + sourcePercentageStr + "%"; //?string("0.######")
						}
						if (itemAdjustment.customerReferenceId != null) {
							String orderCustomerTaxIdStr = UtilProperties.getMessage("OrderUiLabels", "OrderCustomerTaxId", locale);
							description += "<span>" + orderCustomerTaxIdStr + "</span>&nbsp;" + itemAdjustment.customerReferenceId;
						}
						if (itemAdjustment.exemptAmount != null) {
							String orderExemptAmountStr = UtilProperties.getMessage("OrderUiLabels", "OrderExemptAmount", locale);
							description += "<span>" + orderExemptAmountStr + "</span>&nbsp;" + itemAdjustment.exemptAmount;
						}
						taxTotalItemNew.put("description", description);
						listTaxTotal.add(taxTotalItemNew);
					}
				}
			}
		}
		
		Map<String, Object> itemLine = FastMap.newInstance();
		itemLine.put("seqId", seqId);
		itemLine.put("productId", productId);
		itemLine.put("productName", product.getString("productName"));
		itemLine.put("barcode", barcode);
		itemLine.put("expireDate", expireDate);
		itemLine.put("packingPerTray", packingPerTray);
		itemLine.put("quantityUomId", orderItem.getString("quantityUomId"));
		itemLine.put("quantityUomDescription", quantityUomDescription);
		itemLine.put("quantity", quantity);
		itemLine.put("sumTray", sumTray);
		itemLine.put("unitPriceBeVAT", unitPrice); //before VAT
		itemLine.put("adjustment", adjustment);
		itemLine.put("subTotalBeVAT", subTotalBeVAT);
		itemLine.put("invoicePrice", unitPriceInvoiceAfVAT);
		itemLine.put("invoiceSubTotal", subTotalInvoiceExport);
		itemLine.put("itemDescription", itemDescription);
		itemLine.put("supplierProductId", supplierProductId);
		itemLine.put("product", product);
		itemLine.put("orderItemType", orderItemType);
		listItemLine.add(itemLine);
		
		desiredDeliveryDate = orderItem.getTimestamp("estimatedDeliveryDate");
	}
}

String displayPartyNameResult = "";
String displaySUPsNameResult = "";
if (displayParty != null) {
	Map<String, Object> resultValue1 = dispatcher.runSync("getPartyNameForDate", UtilMisc.toMap("partyId", displayParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin));
	if (ServiceUtil.isSuccess(resultValue1)) {
		displayPartyNameResult = resultValue1.fullName;
		if (displayPartyNameResult == null || displayPartyNameResult == "") {
			displayPartyNameResult = UtilProperties.getMessage("OrderErrorUiLabels", "OrderPartyNameNotFound", locale);
		}
	}
	List<GenericValue> listEmployeeSUP = new ArrayList<GenericValue>();
	List<GenericValue> listRelationToSUP = delegator.findByAnd("PartyRelationship", ["partyIdTo" : displayParty.partyId, "roleTypeIdFrom" : "DELYS_SALESSUP_GT"], null, false);
	for (supItem in listRelationToSUP) {
		List<GenericValue> listEmployeeSUP0 = delegator.findByAnd("PartyRelationship", ["partyIdTo" : supItem.partyIdFrom, "partyRelationshipTypeId" : "MANAGER"], null, false);
		if (listEmployeeSUP0 != null) {
			listEmployeeSUP.addAll(listEmployeeSUP0);
		}
	}
	for (GenericValue employeeSUP : listEmployeeSUP) {
		Map<String, Object> resultValue2 = dispatcher.runSync("getPartyNameForDate", UtilMisc.toMap("partyId", employeeSUP.partyIdFrom, "userLogin", userLogin));
		if (ServiceUtil.isSuccess(resultValue2)) {
			if (displaySUPsNameResult == "") {
				displaySUPsNameResult = resultValue2.fullName;
			} else {
				displaySUPsNameResult += ", " + resultValue2.fullName;
			}
		}
	}
	if (displaySUPsNameResult == "") {
		displaySUPsNameResult = UtilProperties.getMessage("OrderErrorUiLabels", "OrderPartyNameNotFound", locale);
	}
}



context.listItemLine = listItemLine;
context.subAmountExportOrder = subAmountExportOrder;
context.subAmountExportInvoice = subAmountExportInvoice;
context.desiredDeliveryDate = desiredDeliveryDate;
context.displayPartyNameResult = displayPartyNameResult;
context.displaySUPsNameResult = displaySUPsNameResult;
context.taxTotalOrderItems = taxTotalOrderItems;
context.listTaxTotal = listTaxTotal;
