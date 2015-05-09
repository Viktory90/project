package com.olbius.datawarehouse.dimensions;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;

public class CurrencyDimension extends AbstractDimension{

	public static final String CURRENCY_DIMENSION = "CurrencyDimension";
	public static final String CURRENCY_ID = "currencyId";
	public static final String CURRENCY = "Uom";
	public static final String UOM_ID = "uomId";
	public static final String UOM_TYPE = "uomTypeId";
	
	private boolean flag;
	
	public CurrencyDimension(Delegator delegator) {
		super(delegator);
	}

	@Override
	public void insert() throws GenericEntityException {
		
		if(flag) return;
		
		GenericValue value = delegator.makeValue(CURRENCY_DIMENSION);
		Long id = getMax(delegator, CURRENCY_DIMENSION);
		info.put(DIMENSION_ID, id + new Long(1));
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}
		try {
			value.create();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
	}

	@Override
	public void update() throws GenericEntityException {
		
		if(flag) return;
		
		GenericValue value = delegator.makeValue(CURRENCY_DIMENSION);
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}
		try {
			value.store();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
	}

	@Override
	public void load(Object id) throws GenericEntityException {
		String uomId = (String) id;

		GenericValue uom = null;
		try {
			uom = delegator.findOne(CURRENCY, UtilMisc.toMap(UOM_ID, uomId), false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}

		if(uom.getString(UOM_TYPE).equals("CURRENCY_MEASURE")) {
			
			addInfo(CURRENCY_ID, uom.get(UOM_ID));

			addInfo(DESCRIPTION, uom.get(DESCRIPTION));
			
			flag = false;
			
		} else {
			flag = true;
		}

	}

}
