package com.olbius.datawarehouse.dimensions;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;

public class FacilityDimension extends AbstractDimension {

	public static final String FACILITY_DIMENSION = "FacilityDimension";
	public static final String FACILITY_NAME = "facilityName";
	public static final String FACILITY_ID = "facilityId";
	public static final String GEO_POINT = "geoPointId";
	public static final String OWNER_PARTY = "ownerPartyId";
	public static final String FACILITY = "Facility";

	public static final String FACILITY_GEO = "FacilityGeo";
	public static final String FACILITY_LOCATION_GEO = "FacilityLocationGeo";
	public static final String GEO = "Geo";
	public static final String GEOASSOC = "GeoAssoc";
	public static final String GEO_NAME = "geoName";
	public static final String GEO_ID = "geoId";
	public static final String GEO_CODE = "geoCode";
	public static final String GEO_SECCODE = "geoSecCode";
	public static final String GEO_ABBREVIATION = "abbreviation";
	public static final String GEO_TYPE = "geoType";
	public static final String GEO_TYPE_ID = "geoTypeId";
	public static final String GEO_ID_TO = "geoIdTo";
	public static final String GEOASSOC_TYPE_ID = "geoAssocTypeId";

	public static final String REGIONS = "REGIONS";

	private Map<Object, Map<String, Object>> geo;

	public FacilityDimension(Delegator delegator) {
		super(delegator);
		geo = new HashMap<Object, Map<String, Object>>();
	}

	@Override
	public void insert() throws GenericEntityException {
		GenericValue value = delegator.makeValue(FACILITY_DIMENSION);
		Long id = getMax(delegator, FACILITY_DIMENSION);
		info.put(DIMENSION_ID, id + new Long(1));

		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}

		try {
			value.create();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		storeGeo();
	}

	@Override
	public void update() throws GenericEntityException {
		GenericValue value = delegator.makeValue(FACILITY_DIMENSION);
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}

		try {
			value.store();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		storeGeo();
	}

	private void storeGeo() throws GenericEntityException {
		try {
			if (!geo.isEmpty()) {
				for (Object key : geo.keySet()) {

					GenericValue value2 = null;

					value2 = delegator.findOne(FACILITY_GEO, UtilMisc.toMap(
							DIMENSION_ID, info.get(DIMENSION_ID), GEO_ID, key),
							false);

					boolean newValue = (value2 == null);

					if (newValue) {
						value2 = delegator.makeValue(FACILITY_GEO);
					}
					value2.set(GEO_ID, key);
					value2.set(DIMENSION_ID, info.get(DIMENSION_ID));
					for(String s : geo.get(key).keySet()) {
						value2.set(s, geo.get(key).get(s));
					}
					if (newValue) {
						value2.create();
					} else {
						value2.store();
					}
				}
			}
		} catch (GenericEntityException gee) {
			throw new GenericEntityException(gee);
		}
	}

	private void loadGeo(String facilityId) throws GenericEntityException {

		GenericValue geo = null;
		try {
			geo = delegator.findOne(FACILITY_LOCATION_GEO,
					UtilMisc.toMap(FACILITY_ID, facilityId), false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}

		if (geo == null) {
			return;
		}

		Map<Object, Boolean> map = new HashMap<Object, Boolean>();

		Object geoId = geo.get(GEO_ID);

		while (geoId != null) {
			try {
				geo = delegator.findOne(GEO, UtilMisc.toMap(GEO_ID, geoId),
						false);

				this.geo.put(geoId, new HashMap<String, Object>());
				this.geo.get(geoId).put(GEO_TYPE, geo.get(GEO_TYPE_ID));
				this.geo.get(geoId).put(GEO_NAME, geo.get(GEO_NAME));
				this.geo.get(geoId).put(GEO_CODE, geo.get(GEO_CODE));
				this.geo.get(geoId).put(GEO_SECCODE, geo.get(GEO_SECCODE));
				this.geo.get(geoId).put(GEO_ABBREVIATION, geo.get(GEO_ABBREVIATION));

				List<EntityCondition> conditions = new ArrayList<EntityCondition>();

				conditions.add(EntityCondition.makeCondition(GEO_ID_TO,
						EntityOperator.EQUALS, geoId));
				conditions.add(EntityCondition.makeCondition(GEOASSOC_TYPE_ID,
						EntityOperator.EQUALS, REGIONS));

				List<GenericValue> values = delegator.findList(GEOASSOC,
						EntityCondition.makeCondition(conditions,
								EntityOperator.AND), null, UtilMisc
								.toList(GEO_ID), null, false);

				for (GenericValue value : values) {
					if (map.get(value.get(GEO_ID)) == null) {
						map.put(value.get(GEO_ID), false);
					}
				}

				if (map.isEmpty()) {
					geoId = null;
				} else {
					geoId = null;
					for (Object key : map.keySet()) {
						if (!map.get(key)) {
							geoId = key;
							map.put(key, true);
							break;
						}
					}
				}

			} catch (GenericEntityException e) {
				throw new GenericEntityException(e);
			}
		}
	}

	@Override
	public void load(Object id) throws GenericEntityException {
		String facilityId = (String) id;

		GenericValue facility = null;
		try {
			facility = delegator.findOne(FACILITY,
					UtilMisc.toMap(FACILITY_ID, facilityId), false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}

		addInfo(FACILITY_ID, facility.get(FACILITY_ID));

		addInfo(DESCRIPTION, facility.get(DESCRIPTION));

		addInfo(FACILITY_NAME, facility.get(FACILITY_NAME));
		addInfo(GEO_POINT, facility.get(GEO_POINT));
		addInfo(OWNER_PARTY, facility.get(OWNER_PARTY));

		loadGeo(facilityId);
	}

}
