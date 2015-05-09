package com.olbius.datawarehouse.dimensions;

import java.util.Locale;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.product.product.ProductContentWrapper;
import org.ofbiz.service.LocalDispatcher;

public class ProductDimension extends AbstractDimension {

	public static final String PRODUCT_ID = "productId";
	public static final String PRODUCT_NAME = "productName";
	public static final String PRODUCT_TYPE = "productType";
	public static final String BRAND_NAME = "brandName";
	public static final String INTERNAL_NAME = "internalName";
	public static final String PRODUCT_DIMENSION = "ProductDimension";
	public static final String PRODUCT = "Product";

	private LocalDispatcher dispatcher;

	private Locale locale;

	public ProductDimension(LocalDispatcher dispatcher, Delegator delegator, Locale locale) {
		super(delegator);
		this.dispatcher = dispatcher;
		this.locale = locale;
	}

	@Override
	public void insert() throws GenericEntityException {
		GenericValue value = delegator.makeValue(PRODUCT_DIMENSION);
		Long id = getMax(delegator, PRODUCT_DIMENSION);
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

		GenericValue value = delegator.makeValue(PRODUCT_DIMENSION);
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
		String productId = (String) id;

		GenericValue product = null;
		try {
			product = delegator.findOne(PRODUCT, UtilMisc.toMap(PRODUCT_ID, productId), false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}

		ProductContentWrapper productContentWrapper = new ProductContentWrapper(dispatcher, product, locale,
				"text/html");

		addInfo(PRODUCT_ID, product.get(PRODUCT_ID));

		if (productContentWrapper.get("PRODUCT_NAME") != null) {
			addInfo(PRODUCT_NAME, productContentWrapper.get("PRODUCT_NAME").toString());
		} else {
			addInfo(PRODUCT_NAME, "");
		}
		if (productContentWrapper.get("DESCRIPTION") != null) {
			addInfo(DESCRIPTION, productContentWrapper.get("DESCRIPTION").toString());
		} else {
			addInfo(DESCRIPTION, "");
		}
	}

}
