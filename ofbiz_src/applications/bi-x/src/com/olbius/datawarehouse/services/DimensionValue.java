package com.olbius.datawarehouse.services;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityExpr;
import org.ofbiz.entity.condition.EntityOperator;

import com.olbius.datawarehouse.dimensions.Dimension;

public class DimensionValue {

	public static Object getId(Delegator delegator, String entity, String key, Object value) throws GenericEntityException {
		
		List<GenericValue> values = null;

		try {
			values = delegator.findList(entity,
					EntityCondition.makeCondition(key, EntityOperator.EQUALS, value), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		
		return values.get(0).get(Dimension.DIMENSION_ID);
	}
	
	public static Object getId(Delegator delegator, String entity, Map<String, Object> map) throws GenericEntityException {
		
		List<GenericValue> values = null;

		List<EntityExpr> list = new ArrayList<EntityExpr>();
		
		for(String s : map.keySet()) {
			list.add(EntityCondition.makeCondition(s, EntityOperator.EQUALS, map.get(s)));
		}
		
		try {
			values = delegator.findList(entity,
					EntityCondition.makeCondition(list, EntityOperator.AND), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		
		return values.get(0).get(Dimension.DIMENSION_ID);
	}
	
	public static Date getDate(java.util.Date date) {
		
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR, 0);
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.MILLISECOND, 0);
		
		return new Date(calendar.getTimeInMillis());
	}
	
}
