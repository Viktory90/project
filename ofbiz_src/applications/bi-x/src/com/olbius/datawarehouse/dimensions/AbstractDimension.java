package com.olbius.datawarehouse.dimensions;

import java.util.HashMap;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.util.EntityUtil;

public abstract class AbstractDimension implements Dimension {

	protected Delegator delegator;
	
	protected Map<String, Object> info;
	
	public AbstractDimension(Delegator delegator) {
		this.delegator = delegator;
		this.info = new HashMap<String, Object>();
	}
	
	@Override
	public String getId() {
		return (String) info.get(DIMENSION_ID);
	}

	@Override
	public Object getInfo() {
		return info;
	}

	@Override
	public Object getInfo(String text) {
		return info.get(text);
	}
	
	@Override
	public boolean isInfo() {
		return !info.isEmpty();
	}

	@Override
	public void addInfo(String key, Object value) {
		info.put(key, value);
	}
	
	
	public static Long getMax(Delegator delegator, String name) {
		
		GenericValue value = null;
		
		try {
			value = EntityUtil.getFirst(delegator.findByAnd(name, null, UtilMisc.toList("-"+DIMENSION_ID), false));
		} catch (GenericEntityException e) {
			return new Long(0);
		}
	
		if(value != null) {
			return value.getLong(DIMENSION_ID);
		}
		
		return new Long(0);
	}
}
