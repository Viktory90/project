package com.olbius.delys.importServices;

import java.io.ByteArrayOutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import javax.xml.transform.stream.StreamSource;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

import org.apache.fop.apps.Fop;
import org.apache.fop.apps.MimeConstants;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilGenerics;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.base.util.collections.MapStack;
import org.ofbiz.base.util.string.FlexibleStringExpander;
import org.ofbiz.common.email.NotificationServices;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;
import org.ofbiz.webapp.view.ApacheFopWorker;
import org.ofbiz.widget.fo.FoScreenRenderer;
import org.ofbiz.widget.html.HtmlScreenRenderer;
import org.ofbiz.widget.screen.ScreenRenderer;

import com.olbius.delys.accounting.jqservices.UtilJQServices;

@SuppressWarnings({ "unused", "deprecation" })
public class ImportServices {
	
	public static Role ROLE = null;
	public static GenericValue USER_LOGIN = null;
	public static String PARTY_ID = null;
	public enum Role {
		DELYS_ADMIN, DELYS_ROUTE, DELYS_ASM_GT, DELYS_RSM_GT, DELYS_CSM_GT, DELYS_CUSTOMER_GT, DELYS_SALESSUP_GT;
	}
	public static final String module = ImportServices.class.getName();
	public static final String resource = "DelysUiLabels";
	public static final String resourceError = "DelysErrorUiLabels";
//	hoanmStart
	public static Map<String, Object> getlistQuotaItemsAjax(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String quotaId = (String)context.get("quotaId");
		Delegator delegator = ctx.getDelegator();
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("quotaItemSeqId");
		fieldToSelects.add("productName");
		fieldToSelects.add("quotaQuantity");
		fieldToSelects.add("quantityAvailable");
		fieldToSelects.add("quantityUomId");
		fieldToSelects.add("fromDate");
		fieldToSelects.add("thruDate");
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("quotaItemSeqId");
		List<GenericValue> listQuotaItems = delegator.findList("QuotaItem", EntityCondition.makeCondition("quotaId", quotaId), fieldToSelects, orderBy, null, false);
		for (GenericValue genericValue : listQuotaItems) {
			Date fromDate = (Date) genericValue.get("fromDate");
			String StrfromDate = fromDate.toString();
			genericValue.set("fromDate", StrfromDate);
			Date thruDate = (Date) genericValue.get("thruDate");
			String StrthruDate = thruDate.toString();
			genericValue.set("thruDate", StrthruDate);
		}
		result.put("listQuotaItems", listQuotaItems);
		return result;
	}
	public static Map<String, Object> getlistQuotaAjax(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String quotaTypeId = (String)context.get("quotaTypeId");
		Delegator delegator = ctx.getDelegator();
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("quotaId");
		fieldToSelects.add("quotaName");
		fieldToSelects.add("quotaTypeId");
		fieldToSelects.add("description");
		fieldToSelects.add("fromDate");
		fieldToSelects.add("thruDate");
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("quotaId");
		List<GenericValue> listQuotas = delegator.findList("QuotaHeader", EntityCondition.makeCondition("quotaTypeId", quotaTypeId), fieldToSelects, orderBy, null, false);
		for (GenericValue genericValue : listQuotas) {
			Date fromDate = (Date) genericValue.get("fromDate");
			String StrfromDate = fromDate.toString();
			genericValue.set("fromDate", StrfromDate);
			Date thruDate = (Date) genericValue.get("thruDate");
			String StrthruDate = thruDate.toString();
			genericValue.set("thruDate", StrthruDate);
		}
		result.put("listQuotas", listQuotas);
		return result;
	}
	public static Map<String, Object> getFromAndThruDateAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String customTimePeriodId = (String) context.get("customTimePeriodId");
		Delegator delegator = ctx.getDelegator();
		GenericValue genericValue = delegator.findOne("CustomTimePeriod", UtilMisc.toMap("customTimePeriodId", customTimePeriodId), false);
		genericValue.set("fromDate", String.valueOf(genericValue.get("fromDate")));
		genericValue.set("thruDate", String.valueOf(genericValue.get("thruDate")));
		result.put("fromAndThruDate", genericValue);
		return result;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map<String, Object> getPlanInThisMonthAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		List<String> customTimePeriodId = (List<String>)context.get("customTimePeriodId[]");
		String currencyUomId = "";
		List<GenericValue> listProducts = new ArrayList<GenericValue>();
		List<String> orderBy = new ArrayList<String>();
		String supplierPartyId = (String)context.get("supplierPartyId");
		Set<String> fieldToSelects = FastSet.newInstance();
		for (String string : customTimePeriodId) {
			supplierPartyId = "";
			orderBy = new ArrayList<String>();
			orderBy.add("customTimePeriodId");
			fieldToSelects.clear();
			fieldToSelects.add("productPlanId");
			fieldToSelects.add("parentProductPlanId");
			fieldToSelects.add("customTimePeriodId");
			fieldToSelects.add("internalPartyId");
			fieldToSelects.add("supplierPartyId");
			fieldToSelects.add("currencyUomId");
//			List<GenericValue> listProductPlanHeaders = delegator.findList("ProductPlanHeader", EntityCondition.makeCondition(UtilMisc.toMap("customTimePeriodId", string, "supplierPartyId", supplierPartyId)), fieldToSelects, orderBy, null, false);
			List<GenericValue> listProductPlanHeaders = delegator.findList("ProductPlanHeader", EntityCondition.makeCondition(UtilMisc.toMap("customTimePeriodId", string)), fieldToSelects, orderBy, null, false);
			orderBy = new ArrayList<String>();
			orderBy.add("productPlanId");
			fieldToSelects.clear();
			fieldToSelects.add("productPlanId");
			fieldToSelects.add("productPlanItemSeqId");
			fieldToSelects.add("productId");
			fieldToSelects.add("planQuantity");
			fieldToSelects.add("productWeight");
			fieldToSelects.add("weight");
			fieldToSelects.add("partyId");
			fieldToSelects.add("lastPrice");
			fieldToSelects.add("internalName");
			fieldToSelects.add("productPackingUomId");
			fieldToSelects.add("weightUomId");
			fieldToSelects.add("primaryProductCategoryId");
			for (GenericValue genericValue : listProductPlanHeaders) {
				String productPlanId = (String) genericValue.get("productPlanId");
				List<GenericValue> listProductPlanItem = delegator.findList("ProductPlanItemAndSupplierProductAndProductAndUom", EntityCondition.makeCondition(UtilMisc.toMap("productPlanId", productPlanId)), fieldToSelects, orderBy, null, false);
				listProducts.addAll(listProductPlanItem);
				currencyUomId = (String) genericValue.get("currencyUomId");
			}
		}
		Set<String> listProductId = new HashSet<String>();
		for (GenericValue gv : listProducts) {
			String productId = (String) gv.get("productId");
			listProductId.add(productId);
		}
		List<String> listProductIds = new ArrayList<String>();
		listProductIds.addAll(listProductId);
		Collections.sort(listProductIds);
		double totalWeightAll = 0;
		double totalPriceAll = 0;
		List<Map> listProductRelease = new ArrayList<Map>();
		for (String stProductId : listProductIds) {
			Map<String, Object> resultProduct = new FastMap<String, Object>();
			String internalName = "";
			String productPackingUomId = "";
			BigDecimal lastPrice = BigDecimal.ZERO;
			int quantityImport = 0;
			double totalWeight = 0;
			String weightUomId = "";
			String quantityUomId = "";
			StringBuilder messageInfo = new StringBuilder();
			String primaryProductCategoryId = "";
			double totalPrice = 0;
			String productIdRS = "";
			for (GenericValue gv : listProducts) {
				String productId = (String) gv.get("productId");
				if (stProductId.equals(productId)) {
					productIdRS = productId;
					primaryProductCategoryId = (String) gv.get("primaryProductCategoryId");
					internalName = (String) gv.get("internalName");
					productPackingUomId = (String) gv.get("productPackingUomId");
					GenericValue packing = delegator.findOne("Uom", UtilMisc.toMap("uomId", productPackingUomId), false);
					productPackingUomId = (String) packing.get("description");
					BigDecimal quantityImportBd = BigDecimal.ZERO;
					quantityImportBd = (BigDecimal) gv.get("planQuantity");
					int quantityImportInt = quantityImportBd.intValueExact();
					quantityImport += quantityImportInt;
					//them 10% tong so luong san pham theo yeu cau cua delys
					quantityImport = quantityImport + (quantityImport/10);
					lastPrice = (BigDecimal) gv.get("lastPrice");
					double lastPriceInt = lastPrice.doubleValue();
					BigDecimal productWeight = (BigDecimal) gv.get("weight");
					if (productWeight != null) {
						double productWeightInt = productWeight.doubleValue();
						totalWeight = productWeightInt * quantityImport;
					}else {
						messageInfo.append("Data of ").append(internalName).append(" not find value productWeight");
					}
					weightUomId = (String) gv.get("weightUomId");
					quantityUomId = weightUomId;
					GenericValue weight = delegator.findOne("Uom", UtilMisc.toMap("uomId", weightUomId), false);
					weightUomId = (String) weight.get("abbreviation");
					totalPrice = quantityImport * lastPriceInt;
				}
			}
			int totalWeightInt = (int) totalWeight;
			int totalPriceInt = (int) totalPrice;
			totalWeightAll += totalWeightInt;
			totalPriceAll += totalPriceInt;
			resultProduct.put("internalName", internalName);
			resultProduct.put("productId", productIdRS);
			resultProduct.put("quantityUomId", quantityUomId);
			resultProduct.put("primaryProductCategoryId", primaryProductCategoryId);
			resultProduct.put("productPackingUomId", productPackingUomId);
			resultProduct.put("quantityImport", quantityImport);
			resultProduct.put("lastPrice", lastPrice);
			resultProduct.put("totalWeight", totalWeightInt);
			resultProduct.put("weightUomId", weightUomId);
			resultProduct.put("totalPrice", totalPriceInt);
			resultProduct.put("messageInfo",  messageInfo.toString());
			listProductRelease.add(resultProduct);
		}
		result.put("totalWeightAll", totalWeightAll);
		result.put("totalPriceAll", totalPriceAll);
		result.put("listProductInMonths", listProductRelease);
		result.put("currencyUomId", currencyUomId);
		return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getMonthInPlanHeaderAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		List<String> customTimePeriodId = (List<String>)context.get("customTimePeriodId[]");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("parentPeriodId");
		fieldToSelects.add("periodName");
		Delegator delegator = ctx.getDelegator();
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("customTimePeriodId");
		GenericValue thisYear = new GenericValue();
		List<GenericValue> listMonths = new ArrayList<GenericValue>();
		for (String string : customTimePeriodId) {
			List<GenericValue> listMonth = delegator.findList("CustomTimePeriod", EntityCondition.makeCondition(UtilMisc.toMap("parentPeriodId", string, "periodTypeId", "IMPORT_MONTH")), fieldToSelects, orderBy, null, false);
			thisYear = delegator.findOne("CustomTimePeriod", UtilMisc.toMap("customTimePeriodId", string), false);
			String yearName = (String) thisYear.get("periodName");
			yearName = yearName.split(":")[1];
			for (GenericValue genericValue : listMonth) {
				String monthName = (String) genericValue.get("periodName");
				monthName = monthName.split(":")[1];
				monthName = monthName + "-" + yearName;
				genericValue.set("periodName", monthName);
			}
			listMonths.addAll(listMonth);
		}
		result.put("listMonths", listMonths);
		return result;
	}
	public static Map<String, Object> getYearInPlanHeaderAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String periodTypeId = (String)context.get("periodTypeId");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("parentPeriodId");
		fieldToSelects.add("periodTypeId");
		fieldToSelects.add("periodName");
		Delegator delegator = ctx.getDelegator();
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("customTimePeriodId");
		List<GenericValue> listYears = delegator.findList("CustomTimePeriod",EntityCondition.makeCondition(UtilMisc.toMap("periodTypeId", periodTypeId)), fieldToSelects, orderBy, null, false);	
		result.put("listYears", listYears);
		return result;
	}
	public static Map<String, Object> getUomUnit (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productId = (String)context.get("productId");
		if(productId != null){
			String uomId = null;
			Delegator delegator = ctx.getDelegator();
			GenericValue gen = delegator.findOne("Product", UtilMisc.toMap("productId", productId), false);
			if(UtilValidate.isNotEmpty(gen)){
				uomId = (String)gen.get("quantityUomId");
			}
			List<String> orderBy = new ArrayList<String>();
			orderBy.add("uomId");
			List<GenericValue> listUom = delegator.findList("Uom", EntityCondition.makeCondition(UtilMisc.toMap("uomId", uomId)), null, orderBy, null, false);
			result.put("listUom", listUom);
		}
		return result;
	}
	public static Map<String, Object> getTimeAndSalesForcast (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("parentPeriodId");
		fieldToSelects.add("periodTypeId");
		fieldToSelects.add("periodName");
		fieldToSelects.add("fromDate");
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listTime = delegator.findList("CustomTimePeriod", null, fieldToSelects, null, null, false);
		result.put("listTimeAndSalesForcast", listTime);
		return result;
	}
	public static Map<String, Object> getYear (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String periodTypeId = (String)context.get("periodTypeId");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("parentPeriodId");
		fieldToSelects.add("periodTypeId");
		fieldToSelects.add("periodName");
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listYears = delegator.findList("CustomTimePeriod",EntityCondition.makeCondition(UtilMisc.toMap("periodTypeId", periodTypeId)), fieldToSelects, null, null, false);	
		result.put("listYears", listYears);
		return result;
	}
	public static Map<String, Object> getMonth (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String customTimePeriodId = (String)context.get("customTimePeriodId");
		Delegator delegator = ctx.getDelegator();
		GenericValue thisYear = delegator.findOne("CustomTimePeriod", UtilMisc.toMap("customTimePeriodId", customTimePeriodId), false);
		String year = (String) thisYear.get("periodName");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("parentPeriodId");
		fieldToSelects.add("periodTypeId");
		fieldToSelects.add("periodName");
		List<GenericValue> listQuarter = delegator.findList("CustomTimePeriod",EntityCondition.makeCondition(UtilMisc.toMap("parentPeriodId", customTimePeriodId)), fieldToSelects, null, null, false);
		List<GenericValue> listMonths = new ArrayList<GenericValue>();
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("customTimePeriodId");
		for (GenericValue q : listQuarter) {
			String thisId = (String) q.get("customTimePeriodId");
			List<GenericValue> listTempMonth = delegator.findList("CustomTimePeriod",EntityCondition.makeCondition(UtilMisc.toMap("parentPeriodId", thisId)), fieldToSelects, orderBy, null, false);
			for (GenericValue m : listTempMonth) {
				listMonths.add(m);
			}
		}
		for (GenericValue t : listMonths) {
			String month = (String) t.get("periodName");
			String yearAndMonth = month + "-" + year;
			t.setString("periodName", yearAndMonth);			
		}
		result.put("listMonths", listMonths);
		return result;
	}
	@SuppressWarnings("rawtypes")
	public static Map<String, Object> getSalesForcast (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String customTimePeriodId = (String)context.get("customTimePeriodId");
		String productId = (String)context.get("productId");
		String thisMonth = (String)context.get("thisMonth");
		Integer quantityConvert = (Integer)context.get("quantityConvert");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("salesForecastId");
		fieldToSelects.add("customTimePeriodId");		
		fieldToSelects.add("parentSalesForecastId");
		fieldToSelects.add("internalPartyId");
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listSalesForecast = delegator.findList("SalesForecast",EntityCondition.makeCondition(UtilMisc.toMap("customTimePeriodId", customTimePeriodId, "internalPartyId", "RSM_GT_VUNG1")), fieldToSelects, null, null, false);	
		List<GenericValue> listSalesForecastDetails = new ArrayList<GenericValue>();
		fieldToSelects.clear();
		fieldToSelects.add("salesForecastId");
		fieldToSelects.add("salesForecastDetailId");		
		fieldToSelects.add("quantity");
		fieldToSelects.add("productId");
		for (GenericValue f : listSalesForecast) {
			String salesForecastId = (String) f.get("salesForecastId");
			List<GenericValue> listTempSalesForecastDetails = delegator.findList("SalesForecastDetail",EntityCondition.makeCondition(UtilMisc.toMap("salesForecastId", salesForecastId, "productId", productId)), fieldToSelects, null, null, false);
			for (GenericValue t : listTempSalesForecastDetails) {
				listSalesForecastDetails.add(t);
			}
		}
		List<Map> listMonthAndQuantity = new ArrayList<Map>();
		Map<String, Object> details = FastMap.newInstance();
		BigDecimal quantity = BigDecimal.ZERO;
		int importVolume = 0;
		int tonCuoiThang = 0;
		double ngayTon = 0;
		int quantt = 0;
		for (GenericValue rm : listSalesForecastDetails) {
			quantity = (BigDecimal) rm.get("quantity");
		}
		if (!quantity.equals(BigDecimal.ZERO)) {
			quantt = quantity.intValue();
			int min = (int) Math.ceil(quantt + ((double)quantt/30)*7);
			int result1 = (int) Math.ceil((double)min / quantityConvert);
			importVolume = result1*quantityConvert;
			tonCuoiThang = importVolume - quantt;
			ngayTon = ((double)tonCuoiThang / ((double)quantt/30));
			DecimalFormat twoDForm = new DecimalFormat("#.##"); 
			ngayTon =  Double.valueOf(twoDForm.format(ngayTon));
		}else {
			
		}
		details.put("productId", productId);
		details.put("quantity", quantity);
		details.put("thisMonth", thisMonth);
		details.put("importVolume", importVolume);
		details.put("tonCuoiThang", tonCuoiThang);
		details.put("ngayTon", ngayTon);
		listMonthAndQuantity.add(details);
		result.put("listSalesForcasts", listMonthAndQuantity);
		return result;
	}
	public static Map<String, Object> getThisquantityConvert (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productId = (String)context.get("productId");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("quantityConvert");
		Delegator delegator = ctx.getDelegator();
		BigDecimal quantityConvert = BigDecimal.ZERO;
		List<GenericValue> listPackings = delegator.findList("ConfigPacking",EntityCondition.makeCondition(UtilMisc.toMap("productId", productId)), fieldToSelects, null, null, false);	
		for (GenericValue p : listPackings) {
			quantityConvert = (BigDecimal) p.get("quantityConvert");
		}
		result.put("quantityConvert", quantityConvert);
		return result;
	}
	@SuppressWarnings("rawtypes")
	public static Map<String, Object> getMonthSalesForcast (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String customTimePeriodId = (String)context.get("customTimePeriodId");
		String thisMonth = (String)context.get("thisMonth");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("salesForecastId");
		fieldToSelects.add("internalPartyId");
		fieldToSelects.add("customTimePeriodId");		
		Delegator delegator = ctx.getDelegator();
		List<GenericValue> listSalesForecast = delegator.findList("SalesForecast",EntityCondition.makeCondition(UtilMisc.toMap("customTimePeriodId", customTimePeriodId, "internalPartyId", "RSM_GT_VUNG1")), fieldToSelects, null, null, false);
		List<GenericValue> listSalesForecastDetails = new ArrayList<GenericValue>();
		fieldToSelects.clear();
		fieldToSelects.add("salesForecastId");
		fieldToSelects.add("salesForecastDetailId");		
		fieldToSelects.add("quantity");
		fieldToSelects.add("productId");
		for (GenericValue f : listSalesForecast) {
			String salesForecastId = (String) f.get("salesForecastId");
			List<GenericValue> listTempSalesForecastDetails = delegator.findList("SalesForecastDetail",EntityCondition.makeCondition(UtilMisc.toMap("salesForecastId", salesForecastId)), fieldToSelects, null, null, false);
			for (GenericValue t : listTempSalesForecastDetails) {
				listSalesForecastDetails.add(t);
			}
		}
		Map<String, Object> quantityAndMonth = new FastMap<String, Object>();
		List<Map> listMonthAndQuantity = new ArrayList<Map>();
		quantityAndMonth.put("thisMonth", thisMonth);
		quantityAndMonth.put("thisSalesForecastDetails", listSalesForecastDetails);
		listMonthAndQuantity.add(quantityAndMonth);
		result.put("month", listMonthAndQuantity);
		return result;
	}
	public static Map<String, Object> getProductCategory (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productCategoryTypeId = (String)context.get("productCategoryTypeId");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("productCategoryId");
		fieldToSelects.add("categoryName");		
		Delegator delegator = ctx.getDelegator();
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("productCategoryId");
		List<GenericValue> listProductCategorys = delegator.findList("ProductCategory",EntityCondition.makeCondition(UtilMisc.toMap("productCategoryTypeId", productCategoryTypeId)), fieldToSelects, orderBy, null, false);
		result.put("listProductCategorys", listProductCategorys);
		return result;
	}
	public static Map<String, Object> getListOrderItemsAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String orderId = (String)context.get("orderId");
		Delegator delegator = ctx.getDelegator();
		List<String> sortBy = FastList.newInstance();
		sortBy.add("orderItemSeqId");
		List<GenericValue> listOrderItems = delegator.findList("OrderItem",EntityCondition.makeCondition(UtilMisc.toMap("orderId", orderId)), null, sortBy, null, false);
		result.put("listOrderItems", listOrderItems);
		return result;
	}
	@SuppressWarnings({ "rawtypes" })
	public static Map<String, Object> getAllMonthSalesForcast (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String productPlanId = (String)context.get("productPlanId");
		String productId2 = (String)context.get("productId");
		String uomToId = (String)context.get("uomToId");
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("quantityConvert");
		fieldToSelects.add("internalName");
		fieldToSelects.add("quantityUomId");
		List<GenericValue> listProducthn = delegator.findList("ConfigPackingAndProduct",EntityCondition.makeCondition(UtilMisc.toMap("productId", productId2, "quantityUomId", uomToId, "uomFromId", "PALLET", "uomToId", uomToId)), fieldToSelects, null, null, false);
		fieldToSelects.clear();
		fieldToSelects.add("productPlanId");
		fieldToSelects.add("parentProductPlanId");
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("productPlanName");
		fieldToSelects.add("customTimePeriodIdOfSales");
		fieldToSelects.add("internalPartyId");
		String areaPlan = "";
		String configEmpy = "";
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("fromDate");
		BigDecimal palet = BigDecimal.ZERO;
		List<GenericValue> listProductPlanHeader = delegator.findList("ProductPlanAndCustomTimePeriodForGroup",EntityCondition.makeCondition(UtilMisc.toMap("parentProductPlanId", productPlanId)), fieldToSelects, orderBy, null, false);
		List<GenericValue> listSalesForecast = new ArrayList<GenericValue>();
		fieldToSelects.clear();
		fieldToSelects.add("salesForecastId");
		fieldToSelects.add("internalPartyId");
		fieldToSelects.add("customTimePeriodId");
		List<List<Map>> listMonth = new ArrayList<List<Map>>();
		Set<String> fieldToSelects2 = FastSet.newInstance();
		fieldToSelects2.add("salesForecastId");
		fieldToSelects2.add("salesForecastDetailId");
		fieldToSelects2.add("quantity");
		fieldToSelects2.add("productId");
		Set<String> fieldToSelects1 = FastSet.newInstance();
		fieldToSelects1.add("quantityConvert");
		String isUpdate = "New";
		List<String> orderBy2 = new ArrayList<String>();
		orderBy2.add("salesForecastDetailId");
		int inventoryFocast = 0;
		int FirstInventoryFocast = 0;
		for (GenericValue xc : listProductPlanHeader) {
			String salesId = (String) xc.get("customTimePeriodIdOfSales");
			String thisMonth = (String) xc.get("productPlanName");
			String thisProductPlanId = (String) xc.get("productPlanId");
			areaPlan = (String) xc.get("internalPartyId");
			listSalesForecast = delegator.findList("SalesForecast",EntityCondition.makeCondition(UtilMisc.toMap("customTimePeriodId", salesId, "internalPartyId", areaPlan)), fieldToSelects, null, null, false);
			GenericValue customTimePeriodOfSales = delegator.findOne("CustomTimePeriod", UtilMisc.toMap("customTimePeriodId", salesId), false);
			List<GenericValue> listSalesForecastDetails = new ArrayList<GenericValue>();
			List<Map> listSalesForecastDetails2 = new ArrayList<Map>();
			for (GenericValue f : listSalesForecast) {
				String salesForecastId = (String) f.get("salesForecastId");
				List<GenericValue> listTempSalesForecastDetails = new ArrayList<GenericValue>();
				if (productId2 == null) {
					listTempSalesForecastDetails = delegator.findList("SalesForecastDetail",EntityCondition.makeCondition(UtilMisc.toMap("salesForecastId", salesForecastId)), fieldToSelects2, orderBy2, null, false);
				}else {
					listTempSalesForecastDetails = delegator.findList("SalesForecastDetail",EntityCondition.makeCondition(UtilMisc.toMap("salesForecastId", salesForecastId, "productId", productId2)), fieldToSelects2, orderBy2, null, false);
				}
				if (listTempSalesForecastDetails.size() > 1) {
					for (int i = listTempSalesForecastDetails.size(); i > 1; i--) {
						int r = i - 1;
						listTempSalesForecastDetails.remove(r);
					}
				}
				for (GenericValue t : listTempSalesForecastDetails) {
					listSalesForecastDetails.add(t);
					String productId = (String)t.get("productId");
					BigDecimal thisQuantity = (BigDecimal)t.get("quantity");
					Calendar calendar = Calendar.getInstance();
					calendar.set(Calendar.HOUR, 0);
				    calendar.set(Calendar.MINUTE, 0);
				    calendar.set(Calendar.SECOND, 0);
				    calendar.set(Calendar.MILLISECOND, 0);
				    calendar.setTime((java.sql.Date) customTimePeriodOfSales.get("fromDate"));
					calendar.add(Calendar.DATE, -1);
					//lay ton kho thang truoc lien ke thang nay
					java.sql.Date curentDate = new java.sql.Date(calendar.getTimeInMillis());
					Set<String> fieldDateDim = FastSet.newInstance();
					fieldDateDim.add("dimensionId");
					List<GenericValue> listDateDim = delegator.findList("DateDimension", EntityCondition.makeCondition("dateValue", curentDate), fieldDateDim, null, null, false);
					GenericValue dateDim = EntityUtil.getFirst(listDateDim);
					List<GenericValue> listProductDim = delegator.findList("ProductDimension", EntityCondition.makeCondition("productId", productId), null, null, null, false);
					GenericValue productDim = EntityUtil.getFirst(listProductDim);
					BigDecimal tonTruoc = BigDecimal.ZERO;
					long tempt = 8000;
					if(dateDim != null && productDim != null){
						long productDimId = (Long) productDim.get("dimensionId");
						long dateDimId = (Long) dateDim.get("dimensionId");
						List<GenericValue> listFacilityFact = delegator.findList("FacilityFact", EntityCondition.makeCondition(UtilMisc.toMap("facilityDimId", tempt, "productDimId", productDimId, "dateDimId", dateDimId)), null, null, null, false);
						GenericValue facilityFact = EntityUtil.getFirst(listFacilityFact);
						if(facilityFact != null){
							tonTruoc = (BigDecimal) facilityFact.get("inventoryTotal");
						}else{
							tonTruoc = BigDecimal.ZERO;
						}
					}
					GenericValue cfpacking = delegator.findOne("ConfigPacking", UtilMisc.toMap("productId", productId, "uomFromId", "PALLET", "uomToId", uomToId), false);
					boolean aCheck = true;
					if (cfpacking == null) {
						aCheck = false;
						configEmpy = "isEmpty";
					} else {
						palet = (BigDecimal)cfpacking.get("quantityConvert");
						if (palet.equals(BigDecimal.ZERO)) {
							configEmpy = "isEmpty";
						}
					}
					int planImport = 0;
					int tonCuoiThang = 0;
					double ngayTon = 0;
					int pallet = 0;
					String ngayTonS = "";
					String hoanm = "Save";
					List<GenericValue> listPlanItem1 = delegator.findList("ProductPlanItem", EntityCondition.makeCondition(UtilMisc.toMap("productPlanId", thisProductPlanId, "productId", productId2)), null, null, null, false);
					GenericValue planItem1 = new GenericValue();
					for (GenericValue grv : listPlanItem1) {
						if (grv != null) {
							planItem1 = grv;
						}else {
							aCheck = false;
						}
					}
					if (aCheck) {
						if(tonTruoc != BigDecimal.ZERO){
//							neu co ton thuc te cua thang truoc
							if (!planItem1.isEmpty()) {
//								neu da co du lieu ProductPlanItem
								BigDecimal planImportTemp = (BigDecimal) planItem1.get("planQuantity");
								String productPlanItemSeqId = (String) planItem1.get("productPlanItemSeqId");
//								delegator.storeByCondition("ProductPlanItem", UtilMisc.toMap("inventoryForecast", BigDecimal.ZERO), EntityCondition.makeCondition("productPlanItemSeqId", productPlanItemSeqId));
								planImport = planImportTemp.intValue() + tonTruoc.intValue();
								int thisQuantity2 = thisQuantity.intValue();
								tonCuoiThang = planImport - thisQuantity2;
								int quantityConvert2 = palet.intValue();
								ngayTon = ((double)tonCuoiThang / ((double)thisQuantity2/30));
								BigDecimal thisIventory = (BigDecimal) planItem1.get("inventoryForecast");
								FirstInventoryFocast = inventoryFocast;
								inventoryFocast = tonCuoiThang;
								planImport = planImportTemp.intValue();
								pallet = planImport / quantityConvert2;
								isUpdate = "StoredAndHaveInventory";
							}else {
//								neu chua co du lieu ProductPlanItem
								int quantityConvert = palet.intValue();
								int thisQuantity2 = thisQuantity.intValue();
								double min = (double) thisQuantity2 + ((double)thisQuantity2/30)*7;
								min = min - tonTruoc.doubleValue();
								int result2 = (int) Math.ceil((double)min / quantityConvert);
								planImport = result2*quantityConvert;
								tonCuoiThang = planImport - thisQuantity2 + tonTruoc.intValue();
								ngayTon = ((double)tonCuoiThang / ((double)thisQuantity2/30));
								FirstInventoryFocast = inventoryFocast;
								inventoryFocast = tonCuoiThang;
//								planImport = planImport - tonTruoc.intValue();
								isUpdate = "NewAndHaveInventory";
								pallet = planImport / quantityConvert;
							}
						}else {
//							neu khong co ton thuc te
							if (!planItem1.isEmpty()) {
//								neu da co du lieu ProductPlanItem
								BigDecimal planImportTemp = (BigDecimal) planItem1.get("planQuantity");
								planImport = planImportTemp.intValue()  + inventoryFocast;
								int thisQuantity2 = thisQuantity.intValue();
								tonCuoiThang = planImport - thisQuantity2;
								int quantityConvert2 = palet.intValue();
								ngayTon = ((double)tonCuoiThang / ((double)thisQuantity2/30));
								BigDecimal thisIventory = (BigDecimal) planItem1.get("inventoryForecast");
								FirstInventoryFocast = inventoryFocast;
								inventoryFocast = tonCuoiThang;
								planImport = planImportTemp.intValue();
								pallet = planImport / quantityConvert2;
								hoanm = "Save";
								isUpdate = "Stored";
							}else {
//								neu chua co du lieu ProductPlanItem
								if (palet != BigDecimal.ZERO && thisQuantity != BigDecimal.ZERO) {
									int quantityConvert = palet.intValue();
									int thisQuantity2 = thisQuantity.intValue();
									double min = (double) Math.ceil(thisQuantity2 + ((double)thisQuantity2/30)*7);
 									min = min - inventoryFocast;
									int result2 = (int) Math.ceil((double)min / quantityConvert);
									planImport = result2*quantityConvert;
									tonCuoiThang = planImport - thisQuantity2 + inventoryFocast;
									ngayTon = ((double)tonCuoiThang / ((double)thisQuantity2/30));
									isUpdate = "New";
//									planImport = planImport - inventoryFocast;
									pallet = planImport / quantityConvert;
									FirstInventoryFocast = inventoryFocast;
									inventoryFocast = tonCuoiThang;
								}
							}
						}
					}
					ngayTonS = String.valueOf(ngayTon);
					if (ngayTonS.length() > 4) {
						ngayTonS = ngayTonS.substring(0, 4);
					}
					Map<String, Object> render = new FastMap<String, Object>();
					render.put("inventoryOfMonth", tonTruoc);
					render.put("thisQuantity", thisQuantity);
					render.put("hoanm", hoanm);
					render.put("planImport", planImport);
					render.put("pallet", pallet);
					render.put("tonCuoiThang", tonCuoiThang);
					render.put("ngayTon", ngayTonS);
					render.put("inventoryFocast", FirstInventoryFocast);
					listSalesForecastDetails2.add(render);
				}
			}
			BigDecimal quantityConvertRS = BigDecimal.ZERO;
			String internalName = "";
			String quantityUomId = "";
			GenericValue thisProd = new GenericValue();
			if (listProducthn.isEmpty()) {
				configEmpy = "isEmpty";
			}else {
				thisProd = listProducthn.get(0);
				quantityConvertRS = (BigDecimal) thisProd.get("quantityConvert");
				internalName = (String) thisProd.get("internalName");
				quantityUomId = (String) thisProd.get("quantityUomId");
			}
			Map<String, Object> findUom = new FastMap<String, Object>();
			findUom.put("uomId", quantityUomId);
			GenericValue uom = delegator.findByPrimaryKey("Uom", findUom);
			if (uom != null) {
				quantityUomId = (String) uom.get("description");
			}
			Map<String, Object> quantityAndMonth = new FastMap<String, Object>();
			List<Map> listMonthAndQuantity = new ArrayList<Map>();
			quantityAndMonth.put("quantityConvertRS", palet);
			quantityAndMonth.put("internalName", internalName);
			quantityAndMonth.put("quantityUomId", quantityUomId);
			quantityAndMonth.put("thisMonth", thisMonth);
			quantityAndMonth.put("isUpdate", isUpdate);
			quantityAndMonth.put("thisProductPlanId", thisProductPlanId);
			quantityAndMonth.put("thisSalesForecastDetails", listSalesForecastDetails2);
			listMonthAndQuantity.add(quantityAndMonth);
			listMonth.add(listMonthAndQuantity);
		}
		Map<String, Object> listAndId = new FastMap<String, Object>();
		listAndId.put("listMonth", listMonth);
		listAndId.put("productId", productId2);
		listAndId.put("uomToId", uomToId);
		listAndId.put("configEmpy", configEmpy);
		result.put("month", listAndId);
		return result;
	}
	public static Map<String, Object> createPlanItemToDatabaseAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		String productPlanId = (String)context.get("productPlanId");
		String	productPlanItemSeqId = delegator.getNextSeqId("ProductPlanItem");
		String productId = (String)context.get("productId");
		BigDecimal planQuantity = (BigDecimal) context.get("planQuantity");
		BigDecimal inventoryForecast = (BigDecimal) context.get("inventoryForecast");
		if (planQuantity == null || inventoryForecast == null) {
			return ServiceUtil.returnError("Error");
		}
		String statusId = (String) context.get("statusId");
		String quantityUomId = (String)context.get("quantityUomId");
		Locale locale = (Locale) context.get("locale");
		Map<String, Object> fields = UtilMisc.toMap("productPlanItemSeqId", productPlanItemSeqId, "productPlanId", productPlanId, "productId", productId, "planQuantity", planQuantity, "statusId", statusId, "inventoryForecast", inventoryForecast, "quantityUomId", quantityUomId);
		Map<String, Object> fields2 = UtilMisc.toMap("planQuantity", planQuantity, "statusId", statusId, "inventoryForecast", inventoryForecast);
		List<GenericValue> checkInList = delegator.findList("ProductPlanItem", EntityCondition.makeCondition(UtilMisc.toMap("productPlanId", productPlanId, "productId", productId)), null, null, null, false);
		GenericValue planItem = EntityUtil.getFirst(checkInList);
		Map<String, String> fields41 =  UtilMisc.toMap("productPlanId", productPlanId);
		GenericValue thisPlanHeader = delegator.findOne("ProductPlanHeader", fields41, false);
		String thisPlanStatus = (String) thisPlanHeader.get("statusId");
		if ((thisPlanStatus != "PLAN_CREATED") || (thisPlanStatus == "")) {
			Map<String,String> fields4 = UtilMisc.toMap("statusId", "PLAN_CREATED");
			try {
				delegator.storeByCondition("ProductPlanHeader", fields4, EntityCondition.makeCondition("productPlanId", productPlanId));
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
			}
		}
		if (planItem == null) {
			try {
				GenericValue newValue = delegator.makeValue("ProductPlanItem", fields);
				delegator.create(newValue);
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
			}
		}else {
			for (GenericValue genericValue : checkInList) {
				String productPlanItemSeqId2 = (String) genericValue.get("productPlanItemSeqId");
				try {
					delegator.storeByCondition("ProductPlanItem", fields2, EntityCondition.makeCondition("productPlanItemSeqId", productPlanItemSeqId2));
				} catch (GenericEntityException e) {
					return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
				}
			}
		}
		Map<String, Object> result = new FastMap<String, Object>();
		result.put("mess", "Data Save Done!!");
		return result;
	}
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Map<String, Object> loadPlanAvailableAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		String productPlanId = (String)context.get("productPlanId");
		Set<String> fieldToSelects = FastSet.newInstance();
		List<String> orderBy = new ArrayList<String>();
		orderBy.add("productPlanId");
		fieldToSelects.add("productPlanId");
		fieldToSelects.add("parentProductPlanId");
		fieldToSelects.add("customTimePeriodId");
		fieldToSelects.add("productPlanName");
		fieldToSelects.add("internalPartyId");
		List<GenericValue> listProductPlanHeader = delegator.findList("ProductPlanHeader",EntityCondition.makeCondition(UtilMisc.toMap("parentProductPlanId", productPlanId)), fieldToSelects, orderBy, null, false);
		fieldToSelects.clear();
		fieldToSelects.add("productPlanId");
		fieldToSelects.add("productPlanItemSeqId");
		fieldToSelects.add("productId");
		fieldToSelects.add("recentPlanQuantity");
		fieldToSelects.add("planQuantity");
		fieldToSelects.add("primaryProductCategoryId");
		fieldToSelects.add("internalName");
		fieldToSelects.add("quantityUomId");
		fieldToSelects.add("productPackingUomId");
		fieldToSelects.add("productUomId");
		fieldToSelects.add("quantityConvert");
		orderBy.clear();
		orderBy.add("primaryProductCategoryId");
		orderBy.add("internalName");
		List<Map> listMonth = new ArrayList<Map>();
		List<List<GenericValue>> listHoanm = new ArrayList<List<GenericValue>>();
		for (GenericValue gen : listProductPlanHeader) {
			String productPlanId2 = (String)gen.get("productPlanId");
			String productPlanName = (String)gen.get("productPlanName");
			Map<String, Object> listMonthAndId = new FastMap<String, Object>();
			listMonthAndId.put("thisMonth", productPlanName);
			listMonthAndId.put("thisPlanId", productPlanId2);
			listMonth.add(listMonthAndId);
			List<GenericValue> listProduct = delegator.findList("ProductAndProductPlanItem",EntityCondition.makeCondition(UtilMisc.toMap("productPlanId", productPlanId2)), fieldToSelects, orderBy, null, false);
			listHoanm.add(listProduct);
		}
		List<GenericValue> listProducts = new ArrayList<GenericValue>();
		if (listHoanm != null) {
			listProducts = (List<GenericValue>) listHoanm.get(0);
			int max = listProducts.size();
			for (List<?> f : listHoanm) {
				int thisLength = f.size();
				if (max < thisLength) {
					listProducts = (List<GenericValue>) f;
					max = listProducts.size();
				}
			}
		}
		List<String> maxProducts = new ArrayList<String>();
		Set<String> listCatagory = new HashSet<String>();
		for (GenericValue d : listProducts) {
			String category = (String) d.get("primaryProductCategoryId");
			String maxProduct = (String) d.get("productId");
			listCatagory.add(category);
			maxProducts.add(maxProduct);
		}
		List<String> listCatagorys = new ArrayList<String>();
		List<Map> listProductInThisCatagorys2 = new ArrayList<Map>();
		listCatagorys.addAll(listCatagory);
		Collections.sort(listCatagorys);
		for (String str : listCatagorys) {
			List<Map> listProductInCatagory = new ArrayList<Map>();
			for (GenericValue gv : listProducts) {
				String thisCatalog = (String) gv.get("primaryProductCategoryId");
				if (thisCatalog.equals(str)) {
					String internalName = (String) gv.get("internalName");
					String productPlanIdS = productPlanId;
					String productIdS = (String) gv.get("productId");
					String quantityUomIdS = (String) gv.get("quantityUomId");
					Map<String, Object> ctlg = new FastMap<String, Object>();
					ctlg.put("internalName", internalName);
					ctlg.put("productPlanIdS", productPlanIdS);
					ctlg.put("productIdS", productIdS);
					ctlg.put("quantityUomIdS", quantityUomIdS);
					listProductInCatagory.add(ctlg);
				}
			}
			Map<String, Object> mapInThisCategory = new FastMap<String, Object>();
			mapInThisCategory.put("catagory", str);
			mapInThisCategory.put("listProductInCatagorys", listProductInCatagory);
			listProductInThisCatagorys2.add(mapInThisCategory);
		}
		Map<String, Object> listProductCategoryAndMonth = new FastMap<String, Object>();
		listProductCategoryAndMonth.put("listMonth", listMonth);
		listProductCategoryAndMonth.put("listProducts2", listHoanm);
		listProductCategoryAndMonth.put("listProductCategory", listProductInThisCatagorys2);
		result.put("listPlanAvailable", listProductCategoryAndMonth);
		return result;
	}
	public static Map<String, Object> StoreProductQuality(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		String	contentId = delegator.getNextSeqId("Content");
		Locale locale = (Locale) context.get("locale");
		String contentTypeId = "DOCUMENT_QA_PUBLISH";
		String statusId = "CTNT_AVAILABLE";
		String contentName =  (String)context.get("productQualityName");
		//data for insert to DataResource
		String dataResourceId = delegator.getNextSeqId("DataResource");
		String dataResourceTypeId = "IMAGE_OBJECT";
		String dataResourceName = "demo";
		String objectInfo = "ofbiz/imageDocumet/scanfile.jpg"; // this link just for fun.
		//check has data in ContentType
		GenericValue contentType = delegator.findOne("ContentType", UtilMisc.toMap("contentTypeId", contentTypeId), false);
		if (contentType == null) {
			Map<String, String> fieldsContentType = UtilMisc.toMap("contentTypeId", contentTypeId, "description", "ContentType for QA Quantity product publish");
			try {
				GenericValue newContentType = delegator.makeValue("ContentType", fieldsContentType);
				delegator.create(newContentType);
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
			}
		}
		Map<String, String> fields = UtilMisc.toMap("dataResourceId", dataResourceId, "dataResourceTypeId", dataResourceTypeId, "statusId", statusId, "dataResourceName", dataResourceName, "objectInfo", objectInfo);
		Map<String, String> fieldsContent = UtilMisc.toMap("contentId", contentId, "contentTypeId", contentTypeId, "dataResourceId", dataResourceId, "statusId", statusId, "contentName", contentName);
		try {
			GenericValue newValue = delegator.makeValue("DataResource",	fields);
			delegator.create(newValue);
			GenericValue newContent = delegator.makeValue("Content", fieldsContent);
			delegator.create(newContent);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource,
					"CommonNoteCannotBeUpdated",
					UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		List<String> needSave = Arrays.asList("productId", "shelfLife", "fromDate", "thruDate", "shelfLifeUnit");
		for (String string : needSave) {
			String fiel = (String)context.get(string);
			Map<String, String> fieldsContentAttribute = UtilMisc.toMap("contentId", contentId, "attrName", string, "attrValue", fiel);
			try {
				GenericValue newContentAttribute = delegator.makeValue("ContentAttribute", fieldsContentAttribute);
				delegator.create(newContentAttribute);
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
			}
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("contentId", contentId);
		result.put("dataResourceId", dataResourceId);
		return result;
	}
	public static Map<String, Object> createContentForQualityPublication(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String	contentId = delegator.getNextSeqId("Content");
		Map<String, String> fieldsContent = UtilMisc.toMap("contentId", contentId);
		try {
			GenericValue newContent = delegator.makeValue("Content", fieldsContent);
			delegator.create(newContent);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = FastMap.newInstance();
		result.put("contentId", contentId);
		return result;
	}
	public static Map<String, Object> createBillOfLading(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> result = FastMap.newInstance();
		Locale locale = (Locale) context.get("locale");
		String billNumber = (String)context.get("billNumber");
		List<GenericValue> listBillOfLading = delegator.findList("BillOfLading",EntityCondition.makeCondition(UtilMisc.toMap("billNumber", billNumber)), null, null, null, false);
		if (UtilValidate.isNotEmpty(listBillOfLading)) {
			GenericValue thisBillOfLading = EntityUtil.getFirst(listBillOfLading);
			result.put("billId", (String)thisBillOfLading.get("billId"));
			return result;
		}
		String billId = delegator.getNextSeqId("BillOfLading");
		String partyIdFrom = (String)context.get("partyIdFrom");
		String partyIdTo = (String)context.get("partyIdTo");
		Timestamp departureDate = (Timestamp) context.get("departureDate");
		Timestamp arrivalDate = (Timestamp) context.get("arrivalDate");
		Map<String, Object> fieldsBillOfLading = UtilMisc.toMap("billId", billId, "billNumber", billNumber, "partyIdFrom", partyIdFrom, "partyIdTo", partyIdTo, "departureDate", departureDate, "arrivalDate", arrivalDate);
		try {
			GenericValue newContent = delegator.makeValue("BillOfLading", fieldsBillOfLading);
			delegator.create(newContent);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		result.put("billId", billId);
		return result;
	}
	public static Map<String, Object> updateBillOfLading(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String billNumber = (String)context.get("billNumber");
		String billId = (String)context.get("billId");
		String partyIdFrom = (String)context.get("partyIdFrom");
		String partyIdTo = (String)context.get("partyIdTo");
		Timestamp departureDate = (Timestamp) context.get("departureDate");
		Timestamp arrivalDate = (Timestamp) context.get("arrivalDate");
		Map<String, ?> fieldsBillOfLading = UtilMisc.toMap("billNumber", billNumber, "partyIdFrom", partyIdFrom, "partyIdTo", partyIdTo, "departureDate", departureDate, "arrivalDate", arrivalDate);
		try {
			delegator.storeByCondition("BillOfLading", fieldsBillOfLading, EntityCondition.makeCondition("billId", billId));
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	public static Map<String, Object> updateQuotaItemAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String quotaId = (String)context.get("quotaId");
		String quotaItemSeqId = (String)context.get("quotaItemSeqId");
		BigDecimal quantityAvailable = (BigDecimal)context.get("quantityAvailable");
		Map<String, ?> fieldsQuotaItem = UtilMisc.toMap("quantityAvailable", quantityAvailable);
		try {
			delegator.storeByCondition("QuotaItem", fieldsQuotaItem, EntityCondition.makeCondition(UtilMisc.toMap("quotaId", quotaId, "quotaItemSeqId", quotaItemSeqId)));
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> updateStatusListAgreements(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String statusId = (String)context.get("statusId");
		List<String> listAgreementId = (List<String>) context.get("agreementId[]");
		Map<String, ?> fieldsAgreement = UtilMisc.toMap("statusId", statusId);
		try {
			for (String strAgreementId : listAgreementId) {
				delegator.storeByCondition("Agreement", fieldsAgreement, EntityCondition.makeCondition("agreementId", strAgreementId));
			}
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> updateStatusListAgreementsJava(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String statusId = (String)context.get("statusId");
		List<String> listAgreementId = (List<String>) context.get("agreementId");
		Map<String, ?> fieldsAgreement = UtilMisc.toMap("statusId", statusId);
		try {
			for (String strAgreementId : listAgreementId) {
				delegator.storeByCondition("Agreement", fieldsAgreement, EntityCondition.makeCondition("agreementId", strAgreementId));
			}
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	public static Map<String, Object> saveQuotaHeaderAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		String	quotaId = delegator.getNextSeqId("QuotaHeader");
		Locale locale = (Locale) context.get("locale");
		String quotaName = (String)context.get("quotaName");
		Timestamp fromDate =  (Timestamp)context.get("fromDate");
		Timestamp thruDate =  (Timestamp)context.get("thruDate");
		String quotaTypeId = "IMPORT_QUOTA";
		Map<String, Object> fields = UtilMisc.toMap("quotaId", quotaId, "quotaName", quotaName, "quotaTypeId", quotaTypeId, "description", quotaName, "fromDate", fromDate, "thruDate", thruDate);
		try {
			GenericValue newQuotaHeader = delegator.makeValue("QuotaHeader", fields);
			delegator.create(newQuotaHeader);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("quotaId", quotaId);
		return result;
	}
	public static Map<String, Object> saveQuotaItemAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		String	quotaItemSeqId = delegator.getNextSeqId("QuotaItem");
		Locale locale = (Locale) context.get("locale");
		String quotaId = (String)context.get("quotaId");
		String productId = (String)context.get("productId");
		String productName = (String)context.get("productName");
		BigDecimal quotaQuantity = (BigDecimal)context.get("quotaQuantity");
		String quantityUomId = (String)context.get("quantityUomId");
		Timestamp fromDate =  (Timestamp)context.get("fromDate");
		Timestamp thruDate =  (Timestamp)context.get("thruDate");
		BigDecimal quantityAvailable = BigDecimal.ZERO;
		Map<String, Object> fields = UtilMisc.toMap("quotaId", quotaId, "quotaItemSeqId", quotaItemSeqId, "productId", productId, "productName", productName, "quotaQuantity", quotaQuantity, "quantityUomId", quantityUomId, "fromDate", fromDate, "thruDate", thruDate, "quantityAvailable", quantityAvailable);
		try {
			GenericValue newQuotaItem = delegator.makeValue("QuotaItem", fields);
			delegator.create(newQuotaItem);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	public static Map<String, Object> updateDataSourceAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String dataResourceId = (String)context.get("dataResourceId");
		String dataResourceName = (String)context.get("dataResourceName");
		String objectInfo = (String)context.get("objectInfo");
		Map<String, ?> fields = UtilMisc.toMap("dataResourceName", dataResourceName, "objectInfo", objectInfo);
		try {
			delegator.storeByCondition("DataResource", fields, EntityCondition.makeCondition("dataResourceId", dataResourceId));
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	public static Map<String, Object> saveAgreementToBillAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String orderId = (String)context.get("orderId");
		String billId = (String)context.get("billId");
		Map<String, ?> fields = UtilMisc.toMap("orderId", orderId, "billId", billId);
		GenericValue newOrderAndContainer = delegator.makeValue("OrderAndContainer", fields);
		try {
			delegator.create(newOrderAndContainer);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError("can not create");
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	public static Map<String, Object> deleteAgreementFromBillAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String orderId = (String)context.get("orderId");
		String billId = (String)context.get("billId");
		Map<String, ?> fields = UtilMisc.toMap("orderId", orderId, "billId", billId);
		try {
			delegator.removeByCondition("OrderAndContainer", EntityCondition.makeCondition(fields));
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError("can not delete");
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	@SuppressWarnings("rawtypes")
	public static Map<String, Object> getlistProductQualityAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String contentTypeId = (String)context.get("contentTypeId");
		String contentId0 = (String)context.get("contentId");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("contentId");
		fieldToSelects.add("dataResourceId");
		fieldToSelects.add("statusId");
		fieldToSelects.add("contentName");
		Delegator delegator = ctx.getDelegator();
		List<String> oderBy = new ArrayList<String>();
		oderBy.add("contentId");
		List<Map> listProductQualitys = new ArrayList<Map>();
		List<GenericValue> listProductQuality = new ArrayList<GenericValue>();
		if (contentId0.equals("nodata")) {
			listProductQuality = delegator.findList("Content",EntityCondition.makeCondition(UtilMisc.toMap("contentTypeId", contentTypeId)), fieldToSelects, oderBy, null, false);
		} else {
			listProductQuality = delegator.findList("Content",EntityCondition.makeCondition(UtilMisc.toMap("contentTypeId", contentTypeId, "contentId", contentId0)), fieldToSelects, oderBy, null, false);
		}
		List<GenericValue> listContentAttribute = new ArrayList<GenericValue>();
		for (GenericValue g : listProductQuality) {
			Map<String, Object> map = new FastMap<String, Object>();
			String contentId = (String) g.get("contentId");
			String dataResourceId = (String) g.get("dataResourceId");
			String statusId = (String) g.get("statusId");
			GenericValue temp1 = delegator.findOne("StatusItem", UtilMisc.toMap("statusId", statusId), false);
			statusId = (String) temp1.get("description");
			String contentName = (String) g.get("contentName");
			listContentAttribute = delegator.findList("ContentAttribute",EntityCondition.makeCondition(UtilMisc.toMap("contentId", contentId)), null, null, null, false);
			for (GenericValue r : listContentAttribute) {
				String key = (String) r.get("attrName");
				String value = (String) r.get("attrValue");
				if (key.equals("productId")) {
					GenericValue temp2 = delegator.findOne("Product", UtilMisc.toMap("productId", value), false);
					value = (String) temp2.get("internalName");
				}
				map.put(key, value);
			}
			map.put("contentId", contentId);
			map.put("dataResourceId", dataResourceId);
			map.put("statusId", statusId);
			map.put("contentName", contentName);
			listProductQualitys.add(map);
		}
		result.put("listProductQuality", listProductQualitys);
		return result;
	}
	public static Map<String, Object> getPathFileScanAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String dataResourceId = (String)context.get("dataResourceId");
		Delegator delegator = ctx.getDelegator();
		GenericValue dataResource = delegator.findOne("DataResource", UtilMisc.toMap("dataResourceId", dataResourceId), false);
		String objectInfo = (String) dataResource.get("objectInfo");
		result.put("objectInfo", objectInfo);
		return result;
	}
	public static Map<String, Object> loadAgreementNotHasBillAjax (DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		List<String> orderBy = FastList.newInstance();
    	orderBy.add("+orderId");
		List<GenericValue> agreementNotHasBill = delegator.findList("OrderAndContainerAndAgreementAndOrderDetailAll", EntityCondition.makeCondition("billId",EntityOperator.EQUALS, null), null, orderBy, null, false);
		result.put("agreementNotHasBill", agreementNotHasBill);
		return result;
	}
	public static Map<String, Object> SaveQuotaService(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		String	contentId = delegator.getNextSeqId("Content");
		Locale locale = (Locale) context.get("locale");
		String contentTypeId = "DOCUMENT_QUOTA";
		String statusId = "CTNT_AVAILABLE";
		String contentName =  (String)context.get("quotaName");
		//data for insert to DataResource
		String dataResourceId = delegator.getNextSeqId("DataResource");
		String dataResourceTypeId = "IMAGE_OBJECT";
		String dataResourceName = "demo";
		String objectInfo = "ofbiz/imageDocumet/scanfile.jpg"; // this link just for fun.
		//check has data in ContentType
		GenericValue contentType = delegator.findOne("ContentType", UtilMisc.toMap("contentTypeId", contentTypeId), false);
		if (contentType == null) {
			Map<String, ?> fieldsContentType = UtilMisc.toMap("contentTypeId", contentTypeId, "description", "ContentType for QA Quantity product publish");
			try {
				GenericValue newContentType = delegator.makeValue("ContentType", fieldsContentType);
				delegator.create(newContentType);
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
			}
		}
		Map<String, ?> fields = UtilMisc.toMap("dataResourceId", dataResourceId, "dataResourceTypeId", dataResourceTypeId, "statusId", statusId, "dataResourceName", dataResourceName, "objectInfo", objectInfo);
		Map<String, ?> fieldsContent = UtilMisc.toMap("contentId", contentId, "contentTypeId", contentTypeId, "dataResourceId", dataResourceId, "statusId", statusId, "contentName", contentName);
		try {
			GenericValue newValue = delegator.makeValue("DataResource",	fields);
			delegator.create(newValue);
			GenericValue newContent = delegator.makeValue("Content", fieldsContent);
			delegator.create(newContent);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		List<String> needSave = Arrays.asList("supplier", "fromDate", "thruDate");
		for (String string : needSave) {
			String fiel = (String)context.get(string);
			Map<String, ?> fieldsContentAttribute = UtilMisc.toMap("contentId", contentId, "attrName", string, "attrValue", fiel);
			try {
				GenericValue newContentAttribute = delegator.makeValue("ContentAttribute", fieldsContentAttribute);
				delegator.create(newContentAttribute);
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
			}
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		result.put("contentId", contentId);
		result.put("dataResourceId", dataResourceId);
		return result;
	}
	public static Map<String, Object> updateStatusPlanAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		Locale locale = (Locale) context.get("locale");
		String productPlanId = (String)context.get("productPlanId");
		String check = (String) context.get("check");
		boolean check2 = Boolean.parseBoolean(check);
		String statusId = "PLAN_CREATED";
		if (check2) {
			statusId = "PLAN_APPROVED";
		}
		Map<String, ?> fields = UtilMisc.toMap("statusId", statusId);
		try {
			delegator.storeByCondition("ProductPlanHeader", fields, EntityCondition.makeCondition("productPlanId", productPlanId));
			delegator.storeByCondition("ProductPlanHeader", fields, EntityCondition.makeCondition("parentProductPlanId", productPlanId));
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = new FastMap<String, Object>();
		result.put("mess", "Data Save Done!!");
		return result;
	}
	public static Map<String, Object> getAgreementName(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String agreementId = (String)context.get("agreementId");
		Delegator delegator = ctx.getDelegator();
		GenericValue thisAgreement = delegator.findOne("AgreementAttribute", UtilMisc.toMap("agreementId", agreementId, "attrName", "AGREEMENT_NAME"), false);
		String agreementName = (String) thisAgreement.get("attrValue");
		result.put("agreementName", agreementName);
		return result;
	}
	public static Map<String, Object> createEmailAgrrement(DispatchContext dctx, Map<String, Object> context) throws GenericServiceException{
    	LocalDispatcher dispatcher = dctx.getDispatcher();
    	Timestamp fromDate = (Timestamp) context.get("fromDate");
    	Timestamp thruDate = (Timestamp) context.get("thruDate");
			Map<String, Object> bodyParameters = FastMap.newInstance();
			Map<String, Object> emailCtx = FastMap.newInstance();
			bodyParameters.put("fromDate", fromDate);
			bodyParameters.put("thruDate", thruDate);
			emailCtx.put("userLogin", context.get("userLogin"));
			emailCtx.put("locale", context.get("locale"));
			emailCtx.put("sendTo", "hoaminhit@gmail.com");
			emailCtx.put("partyIdTo", "importadmin");
			emailCtx.put("bodyParameters", bodyParameters);
			emailCtx.put("authUser", "hoaminhit@gmail.com");
			emailCtx.put("authPass", "abcdef");
			emailCtx.put("sendFrom", "hoaminhit@gmail.com");
			emailCtx.put("emailTemplateSettingId", "IMPORT_AGREEMENT");
		    dispatcher.runSync("sendMailFromTemplateSetting", emailCtx);
    	return ServiceUtil.returnSuccess();
    }
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map<String, Object> createBirtEmailAgrrement(DispatchContext dctx, Map<String, Object> context) throws GenericServiceException{
		 LocalDispatcher dispatcher = dctx.getDispatcher();
	        GenericValue userLogin = (GenericValue) context.get("userLogin");
//	        String emailType = (String) context.get("emailType");
	        List<String> agreementIdList = (List<String>) context.get("agreementId[]");
	        String bodyText = (String) context.get("bodyText");
	        String sendTo = (String) context.get("sendTo");
	        String subject = (String) context.get("subject");
	        String authUser = (String) context.get("authUser");
	        String authPass = (String) context.get("authPass");
	        List<String> listName = new ArrayList<String>();
	        List<Map> bodyParametersList = new ArrayList<Map>();
	        Map<String, Object> sendMap = FastMap.newInstance();
	        for (String string : agreementIdList) {
				String agreementId = string;
				listName.add("Agrrement_" + agreementId);
		        Map<String, Object> bodyParameters = UtilMisc.<String, Object>toMap("agreementId", agreementId, "userLogin", userLogin, "partyId", "importadmin");
		        bodyParametersList.add(bodyParameters);
			}
	        sendMap.put("xslfoAttachScreenLocation", "component://delys/widget/import/ImportScreens.xml#PrintPurchaseAgreementENG");
	        sendMap.put("attachmentNameList", listName);
	        sendMap.put("bodyParametersList", bodyParametersList);
	        sendMap.put("bodyText", bodyText);
	        sendMap.put("userLogin", userLogin);
	        sendMap.put("subject", subject);
	        sendMap.put("sendFrom", authUser);
	        sendMap.put("sendTo", sendTo);
	        sendMap.put("authUser", authUser);
	        sendMap.put("authPass", authPass);
	        Map<String, Object> sendResp = new FastMap<String, Object>();
	        try {
	        	sendResp = dispatcher.runSync("sendMailFromScreenCustom", sendMap);
	        } catch (Exception e) {
	        	return ServiceUtil.returnError("Can not sent Email");
	        }
	        if (sendResp != null && !ServiceUtil.isError(sendResp)) {
//	            sendResp.put("emailType", emailType);
	        }
//	        List<String> paramAgreemntUpdate = new ArrayList<String>();
//	        paramAgreemntUpdate.addAll(agreementIdList);
	        Map<String, Object> agreementParam = FastMap.newInstance();
	        agreementParam.put("userLogin", userLogin);
	        agreementParam.put("agreementId", agreementIdList);
	        agreementParam.put("statusId", "AGREEMENT_SENT");
	        Map<String, Object> updateAgreementStatus = new FastMap<String, Object>();
	        updateAgreementStatus = dispatcher.runSync("updateStatusListAgreementsJava", agreementParam);
	        return sendResp;
   }
	public static Map<String, Object> getContainerID(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String orderId = (String)context.get("orderId");
		Delegator delegator = ctx.getDelegator();
		String containerId = "";
		List<GenericValue> listContainer = delegator.findList("OrderAndContainer",EntityCondition.makeCondition(UtilMisc.toMap("orderId", orderId)), null, null, null, false);
		if (UtilValidate.isNotEmpty(listContainer)) {
			GenericValue thisContainer = listContainer.get(0);
			containerId = (String) thisContainer.get("containerId");
		}
		result.put("containerId", containerId);
		return result;
	}
	public static Map<String, Object> getProductStoreID(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		String orderId = (String)context.get("orderId");
		Delegator delegator = ctx.getDelegator();
		String productStoreId = "";
		GenericValue thisProductStore = delegator.findOne("OrderHeader", UtilMisc.toMap("orderId", orderId), false);
		if (UtilValidate.isNotEmpty(thisProductStore)) {
			productStoreId = (String) thisProductStore.get("productStoreId");
		}
		result.put("productStoreId", productStoreId);
		return result;
	}
	public static Map<String, Object> getImportPlanAjax(DispatchContext ctx, Map<String, Object> context) throws GenericEntityException {
		Map<String, Object> result = new FastMap<String, Object>();
		Delegator delegator = ctx.getDelegator();
		String date = (String)context.get("date");
		String productPlanId = "";
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("productPlanId");
		fieldToSelects.add("fromDate");
		List<GenericValue> listPlanHeader = delegator.findList("ProductPlanAndCustomTimePeriod", EntityCondition.makeCondition("parentProductPlanId", EntityOperator.EQUALS, null), fieldToSelects, null, null, false);
		for (GenericValue x : listPlanHeader) {
			java.sql.Date thisDate = (java.sql.Date) x.get("fromDate");
			String thisDateStr = String.valueOf(thisDate);
			String thisYear = thisDateStr.split("-")[0];
			if (date.equals(thisYear)) {
				productPlanId = (String) x.get("productPlanId");
				result.put("productPlanId", productPlanId);
				return result;
			}
		}
		result.put("productPlanId", "PlanNotFound");
		return result;
	}
	public static Map<String, Object> saveQualityPublicationAjax(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		Locale locale = (Locale) context.get("locale");
		String productId = (String)context.get("productId");
		String qualityPublicationName = (String)context.get("qualityPublicationName");
		Long expireDate = (Long) context.get("expireDate");
		Timestamp fromDate =  (Timestamp)context.get("fromDate");
		Timestamp thruDate =  (Timestamp)context.get("thruDate");
		List<GenericValue> listQualityPublications = delegator.findList("QualityPublication", EntityCondition.makeCondition("productId", productId), null, null, null, false);
		if (UtilValidate.isNotEmpty(listQualityPublications)) {
			GenericValue qualityPublication = listQualityPublications.get(0);
			fromDate = (Timestamp) qualityPublication.get("fromDate");
			expireDate = (Long) qualityPublication.get("expireDate");
			Map<String, Object> fields = UtilMisc.toMap("qualityPublicationName", qualityPublicationName, "thruDate", thruDate);
			try {
				delegator.storeByCondition("QualityPublication", fields, EntityCondition.makeCondition(UtilMisc.toMap("productId", productId, "fromDate", fromDate, "expireDate", expireDate)));
			} catch (GenericEntityException e) {
				return ServiceUtil.returnError("Can not update QualityPublication");
			}
			return ServiceUtil.returnSuccess();
		}
		Map<String, Object> res = FastMap.newInstance();
		Map<String, Object> req = FastMap.newInstance();
		req.put("userLogin", context.get("userLogin"));
		try {
			res = dispatcher.runSync("createContentForQualityPublication", req);
		} catch (GenericServiceException e1) {
			return ServiceUtil.returnError("Can not create Content");
		}
		String contentId = (String) res.get("contentId");
		Map<String, Object> fields = UtilMisc.toMap("productId", productId, "qualityPublicationName", qualityPublicationName, "expireDate", expireDate, "fromDate", fromDate, "thruDate", thruDate, "contentId", contentId);
		try {
			GenericValue newQualityPublication = delegator.makeValue("QualityPublication", fields);
			delegator.create(newQualityPublication);
		} catch (GenericEntityException e) {
			return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonNoteCannotBeUpdated", UtilMisc.toMap("errorString", e.getMessage()), locale));
		}
		Map<String, Object> result = ServiceUtil.returnSuccess();
		return result;
	}
	public static Map<String, Object> listProductShelfLife(DispatchContext ctx, Map<String, ?> context) throws GenericEntityException {
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		Locale locale = (Locale) context.get("locale");
		Set<String> fieldToSelects = FastSet.newInstance();
		fieldToSelects.add("productId");
		fieldToSelects.add("qualityPublicationName");
		fieldToSelects.add("fromDate");
		fieldToSelects.add("thruDate");
		fieldToSelects.add("expireDate");
		List<GenericValue> listQualityPublications = delegator.findList("QualityPublication", null, fieldToSelects, null, null, false);
		Map<String, Object> result = FastMap.newInstance();
		result.put("listProductShelfLife", listQualityPublications);
		return result;
	}
//	EmailService
	protected static final FoScreenRenderer foScreenRenderer = new FoScreenRenderer();
	protected static final HtmlScreenRenderer htmlScreenRenderer = new HtmlScreenRenderer();
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Map<String, Object> sendMailFromScreenCustom(DispatchContext dctx, Map<String, ? extends Object> rServiceContext) {
        Map<String, Object> serviceContext = UtilMisc.makeMapWritable(rServiceContext);
        LocalDispatcher dispatcher = dctx.getDispatcher();
        String webSiteId = (String) serviceContext.remove("webSiteId");
        String bodyText = (String) serviceContext.remove("bodyText");
        String xslfoAttachScreenLocationParam = (String) serviceContext.remove("xslfoAttachScreenLocation");
        String attachmentNameParam = (String) serviceContext.remove("attachmentName");
        List<String> attachmentNameListParam = UtilGenerics.checkList(serviceContext.remove("attachmentNameList"));
        List<String> attachmentNameList = FastList.newInstance();
        if (UtilValidate.isNotEmpty(attachmentNameParam)) attachmentNameList.add(attachmentNameParam);
        if (UtilValidate.isNotEmpty(attachmentNameListParam)) attachmentNameList.addAll(attachmentNameListParam);
        Locale locale = (Locale) serviceContext.get("locale");
        MapStack<String> screenContext = MapStack.create();
        String partyId = "";
        String orderId = "";
        boolean isMultiPart = false;
        String custRequestId = "";
        StringWriter bodyWriter = new StringWriter();
        Map<String, Object> bodyParameters = new FastMap<String, Object>();
        List<Map<String, ? extends Object>> bodyParts = FastList.newInstance();
        List<Map> bodyParametersList = UtilGenerics.checkList(serviceContext.remove("bodyParametersList"));
        if (bodyText != null) {
            bodyText = FlexibleStringExpander.expandString(bodyText, screenContext,  locale);
            bodyParts.add(UtilMisc.<String, Object>toMap("content", bodyText, "type", "text/html"));
        } else {
            bodyParts.add(UtilMisc.<String, Object>toMap("content", bodyWriter.toString(), "type", "text/html"));
        }
        for (int i = 0; i < bodyParametersList.size(); i++) {
        	bodyParameters = (Map) bodyParametersList.get(i);
        	if (bodyParameters == null) {
                bodyParameters = MapStack.create();
            }
            bodyParameters.put("locale", locale);
            partyId = (String) serviceContext.get("partyId");
            if (partyId == null) {
                partyId = (String) bodyParameters.get("partyId");
            }
            orderId = (String) bodyParameters.get("orderId");
            custRequestId = (String) bodyParameters.get("custRequestId");
            bodyParameters.put("communicationEventId", serviceContext.get("communicationEventId"));
            NotificationServices.setBaseUrl(dctx.getDelegator(), webSiteId, bodyParameters);
            String contentType = (String) serviceContext.remove("contentType");
            screenContext.put("locale", locale);
            ScreenRenderer screens = new ScreenRenderer(bodyWriter, screenContext, htmlScreenRenderer);
            screens.populateContextForService(dctx, bodyParameters);
            screenContext.putAll(bodyParameters);
            if (!xslfoAttachScreenLocationParam.isEmpty()) {
                    String xslfoAttachScreenLocation = xslfoAttachScreenLocationParam;
                    String attachmentName = "Details.pdf";
                    if (UtilValidate.isNotEmpty(attachmentNameList) && attachmentNameList.size() >= i) {
                        attachmentName = attachmentNameList.get(i);
                    }
                    isMultiPart = true;
                    try {
                        Writer writer = new StringWriter();
                        MapStack<String> screenContextAtt = MapStack.create();
                        ScreenRenderer screensAtt = new ScreenRenderer(writer, screenContext, foScreenRenderer);
                        screensAtt.populateContextForService(dctx, bodyParameters);
                        screenContextAtt.putAll(bodyParameters);
                        screensAtt.render(xslfoAttachScreenLocation);
                        StreamSource src = new StreamSource(new StringReader(writer.toString()));
                        ByteArrayOutputStream baos = new ByteArrayOutputStream();
                        Fop fop = ApacheFopWorker.createFopInstance(baos, MimeConstants.MIME_PDF);
                        ApacheFopWorker.transform(src, null, fop);
                        baos.flush();
                        baos.close();
                        bodyParts.add(UtilMisc.<String, Object> toMap("content", baos.toByteArray(), "type", "application/pdf", "filename", attachmentName));
                    } catch (Exception e) {
                        Debug.logError(e, "Error rendering PDF attachment for email: " + e.toString(), module);
                        return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonEmailSendRenderingScreenPdfError", UtilMisc.toMap("errorString", e.toString()), locale));
                    }
                    serviceContext.put("bodyParts", bodyParts);
            } else {
                isMultiPart = false;
                if (bodyText != null) {
                    bodyText = FlexibleStringExpander.expandString(bodyText, screenContext,  locale);
                    serviceContext.put("body", bodyText);
                } else {
                    serviceContext.put("body", bodyWriter.toString());
                }
                if (contentType != null && contentType.equalsIgnoreCase("text/plain")) {
                    serviceContext.put("contentType", "text/plain");
                } else {
                    serviceContext.put("contentType", "text/html");
                }
            }
		}
        String subject = (String) serviceContext.remove("subject");
        subject = FlexibleStringExpander.expandString(subject, screenContext, locale);
        Debug.logInfo("Expanded email subject to: " + subject, module);
        serviceContext.put("subject", subject);
        serviceContext.put("partyId", partyId);
        if (UtilValidate.isNotEmpty(orderId)) {
            serviceContext.put("orderId", orderId);
        }            
        if (UtilValidate.isNotEmpty(custRequestId)) {
            serviceContext.put("custRequestId", custRequestId);
        }            
        if (Debug.verboseOn()) Debug.logVerbose("sendMailFromScreen sendMail context: " + serviceContext, module);
        Map<String, Object> result = ServiceUtil.returnSuccess();
        Map<String, Object> sendMailResult;
        Boolean hideInLog = (Boolean) serviceContext.get("hideInLog");
        hideInLog = hideInLog == null ? false : hideInLog;
        try {
            if (!hideInLog) {
                if (isMultiPart) {
                    sendMailResult = dispatcher.runSync("sendMailMultiPart", serviceContext);
                } else {
                    sendMailResult = dispatcher.runSync("sendMail", serviceContext);
                }
            } else {
                if (isMultiPart) {
                    sendMailResult = dispatcher.runSync("sendMailMultiPartHiddenInLog", serviceContext);
                } else {
                    sendMailResult = dispatcher.runSync("sendMailHiddenInLog", serviceContext);
                }
            }
        } catch (Exception e) {
            Debug.logError(e, "Error send email:" + e.toString(), module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource, "CommonEmailSendError", UtilMisc.toMap("errorString", e.toString()), locale));
        }
        if (ServiceUtil.isError(sendMailResult)) {
            return ServiceUtil.returnError(ServiceUtil.getErrorMessage(sendMailResult));
        }
//        result.put("messageWrapper", sendMailResult.get("messageWrapper"));
//        result.put("body", bodyWriter.toString());
//        result.put("subject", subject);
//        result.put("communicationEventId", sendMailResult.get("communicationEventId"));
//        if (UtilValidate.isNotEmpty(orderId)) {
//            result.put("orderId", orderId);
//        }            
//        if (UtilValidate.isNotEmpty(custRequestId)) {
//            result.put("custRequestId", custRequestId);
//        }
        return result;
    }
//	EmailService
	
//	JQXServices
	@SuppressWarnings("unchecked")
    public static Map<String, Object> listReceiptRequirements(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	EntityCondition tmpConditon = EntityCondition.makeCondition("agreementId", EntityOperator.NOT_EQUAL, null);
    	listAllConditions.add(tmpConditon);
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	String statusId = null;
    	if (parameters.get("statusId") != null){
    		statusId = (String)parameters.get("statusId")[0];
    	}
    	if (statusId != null && !"".equals(statusId)){
    		mapCondition.put("statusId", statusId);
    		EntityCondition statusConditon = EntityCondition.makeCondition(mapCondition);
        	listAllConditions.add(statusConditon);
    	}
    	String requirementTypeId = null;
    	if (parameters.get("requirementTypeId") != null){
    		requirementTypeId = (String)parameters.get("requirementTypeId")[0];
    	}
    	if (requirementTypeId != null && !"".equals(requirementTypeId)){
    		mapCondition = new HashMap<String, String>();
    		mapCondition.put("requirementTypeId", requirementTypeId);
    		EntityCondition reqTypeConditon = EntityCondition.makeCondition(mapCondition);
        	listAllConditions.add(reqTypeConditon);
    	}
    	listSortFields.add("requirementId");
    	try {
    		listIterator = delegator.find("OrderRequirementDetail", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling listReceiptRequirements service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	@SuppressWarnings("unchecked")
	public static Map<String, Object> listQualityPublication(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		try {
			listIterator = delegator.find("QualityPublication", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling listReceiptRequirements service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> listProductQA(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		try {
			listIterator = delegator.find("QualityPublicationAndProductAndUom", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling QualityPublicationAndProduct service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		successResult.put("listIterator", listIterator);
		return successResult;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> listImportPlan(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
       	mapCondition.put("parentProductPlanId", null);
       	mapCondition.put("productPlanTypeId", "IMPORT_PLAN");
		EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
		listAllConditions.add(tmpConditon);
    	try {
    		listIterator = delegator.find("ProductPlanHeader", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling listReceiptRequirements service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
	@SuppressWarnings({ "unchecked" })
	public static Map<String, Object> listEditReceiptRequirement(DispatchContext ctx, Map<String, ? extends Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
		List<String> listSortFields = (List<String>) context.get("listSortFields");
		EntityFindOptions opts =(EntityFindOptions) context.get("opts");
		Map<String, String> mapCondition = new HashMap<String, String>();
       	mapCondition.put("statusId", "AGREEMENT_PROCESSING");
       	mapCondition.put("agreementTypeId", "PURCHASE_AGREEMENT");
		EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition, EntityOperator.AND);
		listAllConditions.add(tmpConditon);
		try {
			listIterator = delegator.find("AgreementAndOrderDetail", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling listEditReceiptRequirement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
		List<GenericValue> listOrderRequirementDetail = new ArrayList<GenericValue>();
		try {
			listOrderRequirementDetail = delegator.findList("OrderRequirementDetail", EntityCondition.makeCondition("agreementId",EntityOperator.NOT_EQUAL, null), null, null, null, false);
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		List<GenericValue> listAgreementAndOrderDetail = new ArrayList<GenericValue>();
		try {
			listAgreementAndOrderDetail = listIterator.getCompleteList();
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		List<GenericValue> listAgreementAndOrderDetailTemp = new ArrayList<GenericValue>();
		if (UtilValidate.isNotEmpty(listAgreementAndOrderDetail) && UtilValidate.isNotEmpty(listOrderRequirementDetail)) {
			for (GenericValue x : listAgreementAndOrderDetail) {
				String xAgreementId = (String) x.get("agreementId");
				for (GenericValue z : listOrderRequirementDetail) {
					String zAgreementId = (String) z.get("agreementId");
					if (xAgreementId.equals(zAgreementId)) {
						listAgreementAndOrderDetailTemp.add(x);
					}
				}
			}
		}
		listAgreementAndOrderDetail.removeAll(listAgreementAndOrderDetailTemp);
		successResult.put("listIterator", listAgreementAndOrderDetail);
		return successResult;
	}
	@SuppressWarnings("unchecked")
	public static Map<String, Object> listReceiveAgreement(DispatchContext ctx, Map<String, ? extends Object> context) throws ParseException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	List<GenericValue> listGe = new ArrayList<GenericValue>();
    	List<String> orderBy = FastList.newInstance();
    	orderBy.add("+billId");
    	try {
    		listGe = delegator.findList("BillOfLading", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		List<GenericValue> listBL = EntityUtil.filterByDate(listGe);
    		List<GenericValue> listDetailsHasBill = delegator.findList("OrderAndContainerAndAgreementAndOrderDetail", EntityCondition.makeCondition("billId",EntityOperator.NOT_EQUAL, null), null, orderBy, null, false);
    		if(!UtilValidate.isEmpty(listBL)){
    			for(GenericValue x : listBL){
    				Map<String, Object> row = new HashMap<String, Object>();
    				List<GenericValue> ListDetailEqualBillId = new ArrayList<GenericValue>();
    				row.putAll(x);
    				String billId = (String) x.get("billId");
    				for (GenericValue c : listDetailsHasBill) {
						String thisbillId = (String) c.get("billId");
						if (billId.equals(thisbillId)) {
							ListDetailEqualBillId.add(c);
						}
					}
    				row.put("rowDetail", ListDetailEqualBillId);
    				listIterator.add(row);
    			}
    		}
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling listReceiveAgreement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	@SuppressWarnings("unchecked")
	public static Map<String, Object> listQuotas(DispatchContext ctx, Map<String, ? extends Object> context) throws ParseException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	listSortFields.add("quotaId");
    	Map<String, String> mapCondition = new HashMap<String, String>();
       	mapCondition.put("quotaTypeId", "IMPORT_QUOTA");
		EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
		listAllConditions.add(tmpConditon);
    	try {
    		List<GenericValue> listQuotasHeader = delegator.findList("QuotaHeader", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
    		List<String> orderBy = FastList.newInstance();
    		orderBy.add("quotaItemSeqId");
    		for (GenericValue quotasHeader : listQuotasHeader) {
    			Map<String, Object> mapResult = FastMap.newInstance();
    			String quotaId = (String) quotasHeader.get("quotaId");
    			mapResult.putAll(quotasHeader);
    			List<GenericValue> listQuotaItem = delegator.findList("QuotaItem", EntityCondition.makeCondition(UtilMisc.toMap("quotaId", quotaId)), null, orderBy, null, false);
    			mapResult.put("rowDetail", listQuotaItem);
    			listIterator.add(mapResult);
			}
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling listReceiveAgreement service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
//	/JQXServices
//	hoanmEnd
}
