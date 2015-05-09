package com.olbius.datawarehouse.services;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.jdbc.SQLProcessor;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;

import com.olbius.datawarehouse.dimensions.FacilityDimension;
import com.olbius.datawarehouse.dimensions.ProductDimension;
import com.olbius.olap.facility.FacilityOlap;
import com.olbius.olap.facility.FacilityOlapFactory;

public class FacilityServices {
	
	public final static String module = FacilityServices.class.getName();
	
	public final static FacilityOlapFactory FACTORY = new FacilityOlapFactory();
	
	public static Map<String, Object> facilityProduct(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {

		Delegator delegator = ctx.getDelegator();

		Date fromDate = (Date) context.get("fromDate");
		
		Date thruDate = (Date) context.get("thruDate");
		
		String facilityId = (String) context.get("facilityId");
		
		String productId = (String) context.get("productId");
		
		String olapType = (String) context.get("olapType");
		
		String dateType = (String) context.get("dateType");
		
		String geoId = (String) context.get("geoId");
		
		String geoType = (String) context.get("geoType");
		
		FacilityOlap olap = FACTORY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		olap.setFromDate(fromDate);
		
		olap.setThruDate(thruDate);
		
		
		try {
			
			if(olapType.equals(FacilityOlap.TYPE_RECEIVE)) {
				olap.productReceiveQOH(facilityId, productId, dateType, geoId, geoType);
			}
			if(olapType.equals(FacilityOlap.TYPE_EXPORT)) {
				olap.productExportQOH(facilityId, productId, dateType, geoId, geoType);
			}
			if(olapType.equals(FacilityOlap.TYPE_INVENTORY)) {
				olap.productInventoryQOH(facilityId, productId, dateType, geoId, geoType);
			}
			if(olapType.equals(FacilityOlap.TYPE_BOOK)) {
				olap.productBookATP(facilityId, productId, dateType, geoId, geoType);
			}
			if(olapType.equals(FacilityOlap.TYPE_AVAILABLE)) {
				olap.productInventoryATP(facilityId, productId, dateType, geoId, geoType);
			}
			
		} catch (GenericDataSourceException e) {
			throw new GenericServiceException(e);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		} catch (SQLException e) {
			throw new GenericServiceException(e);
		} finally {
			try {
				olap.close();
			} catch (GenericDataSourceException e) {
				throw new GenericServiceException(e);
			}
		}
		
		Map<String, Object> result = FastMap.newInstance();
		
		result.put("xAxis", olap.getXAxis());
		result.put("yAxis", olap.getYAxis());
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
	
	public static Map<String, Object> getFacilityId(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		try {
			values = delegator.findList(FacilityDimension.FACILITY_DIMENSION, null, null, UtilMisc.toList(FacilityDimension.FACILITY_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		List<String> facilityId = new ArrayList<String>();
		
		for (GenericValue value : values) {
			facilityId.add(value.getString(FacilityDimension.FACILITY_ID));
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("facility", facilityId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
	
	public static Map<String, Object> getProductId(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		try {
			values = delegator.findList(ProductDimension.PRODUCT_DIMENSION, null, null, UtilMisc.toList(ProductDimension.PRODUCT_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		List<String> productId = new ArrayList<String>();
		
		for (GenericValue value : values) {
			productId.add(value.getString(ProductDimension.PRODUCT_ID));
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("product", productId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
	
	public static Map<String, Object> getGeoType(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();

		List<GenericValue> values = null;

		try {
			EntityFindOptions options = new EntityFindOptions();
			options.setDistinct(true);
			values = delegator.findList(FacilityDimension.FACILITY_GEO, null, UtilMisc.toSet(FacilityDimension.GEO_TYPE), UtilMisc.toList(FacilityDimension.GEO_TYPE), options, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		List<String> geoType = new ArrayList<String>();
		
		for (GenericValue value : values) {
			geoType.add(value.getString(FacilityDimension.GEO_TYPE));
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("geoType", geoType);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
	
	public static Map<String, Object> getGeoId(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();

		String geoType = (String) context.get("geoType");
		
		List<GenericValue> values = null;

		try {
			EntityFindOptions options = new EntityFindOptions();
			options.setDistinct(true);
			values = delegator.findList(FacilityDimension.FACILITY_GEO, EntityCondition.makeCondition(FacilityDimension.GEO_TYPE, EntityOperator.EQUALS, geoType), UtilMisc.toSet(FacilityDimension.GEO_ID), UtilMisc.toList(FacilityDimension.GEO_ID), options, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		List<String> geoId = new ArrayList<String>();
		
		for (GenericValue value : values) {
			geoId.add(value.getString(FacilityDimension.GEO_ID));
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("geo", geoId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
}
