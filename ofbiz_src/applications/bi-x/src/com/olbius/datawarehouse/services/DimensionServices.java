package com.olbius.datawarehouse.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityConditionList;
import org.ofbiz.entity.condition.EntityExpr;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.jdbc.SQLProcessor;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.olbius.datawarehouse.dimensions.CurrencyDimension;
import com.olbius.datawarehouse.dimensions.DateDimension;
import com.olbius.datawarehouse.dimensions.Dimension;
import com.olbius.datawarehouse.dimensions.FacilityDimension;
import com.olbius.datawarehouse.dimensions.PartyDimension;
import com.olbius.datawarehouse.dimensions.ProductDimension;

public class DimensionServices {

	public final static String module = DimensionServices.class.getName();

	public static Map<String, Object> initProductDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();
		
		LocalDispatcher dispatcher = ctx.getDispatcher();

		List<GenericValue> values = null;

		try {
			values = delegator.findList(ProductDimension.PRODUCT, null, null, UtilMisc.toList(ProductDimension.PRODUCT_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			ProductDimension dimesion = new ProductDimension(dispatcher, delegator, (Locale) context.get("locale"));
			try {
				dimesion.load(value.getString(ProductDimension.PRODUCT_ID));
				dimesion.insert();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}

	public static Map<String, Object> updateProductDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		LocalDispatcher dispatcher = ctx.getDispatcher();

		List<GenericValue> values = null;

		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(ProductDimension.PRODUCT_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(ProductDimension.BRAND_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(ProductDimension.INTERNAL_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(ProductDimension.PRODUCT_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(ProductDimension.PRODUCT_TYPE, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(ProductDimension.DESCRIPTION, EntityOperator.EQUALS, null));
		
		try {
			values = delegator.findList(ProductDimension.PRODUCT_DIMENSION,
					EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			ProductDimension dimension = new ProductDimension(dispatcher, delegator, (Locale) context.get("locale"));
			dimension.addInfo(Dimension.DIMENSION_ID, value.get(Dimension.DIMENSION_ID));
			try {
				dimension.load(value.getString(ProductDimension.PRODUCT_ID));
				dimension.update();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> initDateDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		Date fromDate = (Date) context.get("fromDate");
        Date thruDate = (Date) context.get("thruDate");
		
		DateDimension dimension = new DateDimension(delegator);
		dimension.setDate(thruDate);
		try {
			dimension.load(fromDate);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		return ServiceUtil.returnSuccess();
	}

	public static Map<String, Object> updateDateDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(DateDimension.DAY_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.DAY_OF_MONTH, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.DAY_OF_WEEK, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.DAY_OF_YEAR, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.MONTH_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.MONTH_OF_YEAR, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.QUARTER_AND_YEAR, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.QUARTER_OF_YEAR, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.WEEK_OF_MONTH, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.WEEKDAY_TYPE, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.YEAR_MONTH, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.YEAR_MONTH_DAY, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.YEAR_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.DESCRIPTION, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(DateDimension.WEEK_AND_YEAR, EntityOperator.EQUALS, null));
		
		try {
			values = delegator.findList(DateDimension.DATE_DIMENSION,
					EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			DateDimension dimension = new DateDimension(delegator);
			Date date = value.getDate(DateDimension.DATE_VALUE);
			dimension.setDate(date);
			try {
				dimension.load(date);
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> initFacilityDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		try {
			values = delegator.findList(FacilityDimension.FACILITY, null, null, UtilMisc.toList(FacilityDimension.FACILITY_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			FacilityDimension dimesion = new FacilityDimension(delegator);
			try {
				dimesion.load(value.getString(FacilityDimension.FACILITY_ID));
				dimesion.insert();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}

	public static Map<String, Object> updateFacilityDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(FacilityDimension.FACILITY_NAME, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(FacilityDimension.DESCRIPTION, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(FacilityDimension.GEO_POINT, EntityOperator.EQUALS, null));
		conditions.add(EntityCondition.makeCondition(FacilityDimension.OWNER_PARTY, EntityOperator.EQUALS, null));
		
		try {
			values = delegator.findList(FacilityDimension.FACILITY_DIMENSION,
					EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			FacilityDimension dimension = new FacilityDimension(delegator);
			dimension.addInfo(Dimension.DIMENSION_ID, value.get(Dimension.DIMENSION_ID));
			try {
				dimension.load(value.getString(FacilityDimension.FACILITY_ID));
				dimension.update();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> initPartyDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		try {
			values = delegator.findList(PartyDimension.PARTY, null, null, UtilMisc.toList(PartyDimension.PARTY_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			PartyDimension dimesion = new PartyDimension(delegator);
			try {
				dimesion.load(value.getString(PartyDimension.PARTY_ID));
				dimesion.insert();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}

	public static Map<String, Object> updatePartyDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(PartyDimension.DESCRIPTION, EntityOperator.EQUALS, null));
		
		try {
			values = delegator.findList(PartyDimension.PARTY_DIMENSION,
					EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			PartyDimension dimension = new PartyDimension(delegator);
//			dimension.addInfo(Dimension.DIMENSION_ID, value.get(Dimension.DIMENSION_ID));
			try {
				dimension.load(value.getString(PartyDimension.PARTY_ID));
				dimension.update();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> initCurrencyDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		try {
			values = delegator.findList(CurrencyDimension.CURRENCY, null, null, UtilMisc.toList(CurrencyDimension.UOM_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			CurrencyDimension dimesion = new CurrencyDimension(delegator);
			try {
				dimesion.load(value.getString(CurrencyDimension.UOM_ID));
				dimesion.insert();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}

	public static Map<String, Object> updateCurrencyDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(Dimension.DESCRIPTION, EntityOperator.EQUALS, null));
		
		try {
			values = delegator.findList(CurrencyDimension.CURRENCY_DIMENSION,
					EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}

		for (GenericValue value : values) {
			PartyDimension dimension = new PartyDimension(delegator);
			dimension.addInfo(Dimension.DIMENSION_ID, value.get(Dimension.DIMENSION_ID));
			try {
				dimension.load(value.getString(CurrencyDimension.CURRENCY_ID));
				dimension.update();
			} catch (GenericEntityException e) {
				throw new GenericServiceException(e);
			}
		}

		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> testSQL(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		SQLProcessor processor = new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		
		try {
			processor.executeQuery("");
			processor.getResultSet();
		} catch (GenericDataSourceException e) {
			throw new GenericServiceException(e);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
}
