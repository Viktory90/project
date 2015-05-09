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

public class PartyDimension extends AbstractDimension{

	public static final String PARTY_DIMENSION = "PartyDimension";
	public static final String PARTY_GROUP_DIMENSION = "PartyGroupDimension";
	public static final String PARTY_ID = "partyId";
	public static final String PARTY = "Party";
	public static final String PARTY_RELATIONSHIP = "PartyRelationship";
	public static final String PARTY_TYPE_ID = "partyTypeId";
	public static final String PARTY_GROUP_DIM_ID = "partyGroupDimId";
	public static final String PARTY_ID_FROM = "partyIdFrom";
	public static final String PARTY_ID_TO = "partyIdTo";
	public static final String PARTY_RELATIONSHIP_TYPE_ID = "partyRelationshipTypeId";
	public static final String PARTY_GROUP = "partyGroup";
	
	public PartyDimension(Delegator delegator) {
		super(delegator);
	}

	@Override
	public void insert() throws GenericEntityException {
		GenericValue value = delegator.makeValue(PARTY_DIMENSION);
		Long id = getMax(delegator, PARTY_DIMENSION);
		info.put(DIMENSION_ID, id + new Long(1));
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}
		try {
			value.create();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		if(((String)info.get(PARTY_TYPE_ID)).equals("PARTY_GROUP") || ((String)info.get(PARTY_TYPE_ID)).equals("LEGAL_ORGANIZATION")) {
			Map<String, List<String>> map = new HashMap<String, List<String>>();
			getGroup((String)info.get(PARTY_ID), map);
			List<List<String>> list = getList((String)info.get(PARTY_ID), map);
			list = getList(list);
			insertGroup(list);
		}
	}

	@Override
	public void update() throws GenericEntityException {
		GenericValue value = delegator.makeValue(PARTY_DIMENSION);
		for (String key : info.keySet()) {
			value.set(key, info.get(key));
		}
		try {
			value.store();
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		if(((String)info.get(PARTY_TYPE_ID)).equals("PARTY_GROUP") || ((String)info.get(PARTY_TYPE_ID)).equals("LEGAL_ORGANIZATION")) {
			Map<String, List<String>> map = new HashMap<String, List<String>>();
			getGroup((String)info.get(PARTY_ID), map);
			List<List<String>> list = getList((String)info.get(PARTY_ID), map);
			list = getList(list);
			insertGroup(list);
		}
	}

	@Override
	public void load(Object id) throws GenericEntityException {
		String partyId = (String) id;

		GenericValue party = null;
		try {
			party = delegator.findOne(PARTY, UtilMisc.toMap(PARTY_ID, partyId), false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}

		addInfo(PARTY_ID, party.get(PARTY_ID));

		addInfo(DESCRIPTION, party.get(DESCRIPTION));
		
		addInfo(PARTY_TYPE_ID, party.get(PARTY_TYPE_ID));

	}
	
	private GenericValue getDimension(String partyId) throws GenericEntityException {
		
		List<GenericValue> values = null;

		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(PartyDimension.PARTY_ID, EntityOperator.EQUALS, partyId));
		
		try {
			values = delegator.findList(PartyDimension.PARTY_DIMENSION,
					EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
					UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}

		if(values != null && !values.isEmpty()) {
			return values.get(0);
		}
		
		return null;
	}
	
	private void getGroup(String partyId, Map<String, List<String>> map) throws GenericEntityException {
		
		if(map.get(partyId) == null) {
			map.put(partyId, new ArrayList<String>());
		}
		
		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		conditions = new ArrayList<EntityCondition>();
		conditions.add(EntityCondition.makeCondition(PARTY_ID_TO, EntityOperator.EQUALS, partyId));
		conditions.add(EntityCondition.makeCondition(PARTY_RELATIONSHIP_TYPE_ID, EntityOperator.EQUALS, "GROUP_ROLLUP"));
		List<GenericValue> values = null;
		try {
			values = delegator.findList(PARTY_RELATIONSHIP, EntityCondition.makeCondition(conditions, EntityOperator.AND), null, UtilMisc.toList(PARTY_ID_TO), null, false);
		} catch (GenericEntityException e) {
			throw new GenericEntityException(e);
		}
		for(GenericValue value : values) {
			if(!map.get(partyId).contains(value.getString(PARTY_ID_FROM))) {
				map.get(partyId).add(value.getString(PARTY_ID_FROM));
				getGroup(value.getString(PARTY_ID_FROM), map);
			}
		}
	}

	private List<List<String>> getList(String s, Map<String, List<String>> map) {
		
		List<List<String>> list = new ArrayList<List<String>>();
		
		if(!map.get(s).isEmpty()) {
			List<String> strings = map.get(s);
			List<List<String>> tmp;
			for(String _s : strings) {
				tmp = getList(_s, map);
				for(int i = 0; i < tmp.size(); i++) {
					List<String> list2 = new ArrayList<String>();
					list2.add(s);
					for(String _ss : tmp.get(i)) {
						list2.add(_ss);
					}
					list.add(list2);
				}
			}
		} else {
			List<String> list2 = new ArrayList<String>();
			list2.add(s);
			list.add(list2);
		}
		
		return list;
	}
	
	private List<List<String>> getList(List<List<String>> list) {
		
		List<List<String>> _list = new ArrayList<List<String>>();
		
		for(int i = 0; i < list.size(); i++) {
			String _p = list.get(i).get(0);
			
			for(int j = 0; j < list.get(i).size(); j++) {
				List<String> __list = new ArrayList<String>();
				__list.add(_p);
				__list.add(list.get(i).get(j));
				for(int k = j ; k < list.get(i).size(); k++) {
					__list.add(list.get(i).get(k));
				}
				_list.add(__list);
			}
			
		}
		
		return _list;
	}
	
	private Long lookupAndUpdate(String s) throws GenericEntityException {
		
		GenericValue genericValue = getDimension(s);
		
		if(genericValue != null) {
			return genericValue.getLong(DIMENSION_ID);
		} else {
			PartyDimension partyDimension = new PartyDimension(delegator);
			try {
				partyDimension.load(s);
				partyDimension.insert();
			} catch (GenericEntityException e) {
				throw new GenericEntityException(e);
			}
			return (Long) partyDimension.getInfo(DIMENSION_ID);
		}
	}
	
	private void insertGroup(List<List<String>> list) throws GenericEntityException {
		
		Map<String, Long> _map = new HashMap<String, Long>();
		
		for(int i = 0; i < list.size(); i++) {
			String _p = list.get(i).get(0);
			String __p = list.get(i).get(1);
			Long _dimension;
			Long _dimension2;
			if(_map.get(_p) == null) {
				_dimension = lookupAndUpdate(_p);
				_map.put(_p, _dimension);
			} else {
				_dimension = _map.get(_p);
			}
			if(_map.get(__p) == null) {
				_dimension2 = lookupAndUpdate(__p);
				_map.put(__p, _dimension2);
			} else {
				_dimension2 = _map.get(__p);
			}
			String _group = "{";
			for(int j = 2; j < list.get(i).size(); j++) {
				String _tmp = list.get(i).get(j);
				Long _dimensionId;
				if(_map.get(_tmp) == null) {
					_dimensionId = lookupAndUpdate(_tmp);
					_map.put(_tmp, _dimensionId);
				} else {
					_dimensionId = _map.get(_tmp);
				}
				_group += Long.toString(_dimensionId);
				if(j < list.get(i).size() -1) {
					_group+=",";
				} else {
					_group+="}";
				}
			}
			List<EntityCondition> conditions = new ArrayList<EntityCondition>();
			conditions = new ArrayList<EntityCondition>();
			conditions.add(EntityCondition.makeCondition(DIMENSION_ID, EntityOperator.EQUALS, _dimension));
			conditions.add(EntityCondition.makeCondition(PARTY_GROUP_DIM_ID, EntityOperator.EQUALS, _dimension2));
			conditions.add(EntityCondition.makeCondition(PARTY_GROUP, EntityOperator.EQUALS, _group));
			List<GenericValue> values = null;
			try {
				values = delegator.findList(PARTY_GROUP_DIMENSION, EntityCondition.makeCondition(conditions, EntityOperator.AND), null, UtilMisc.toList(DIMENSION_ID), null, false);
			} catch (GenericEntityException e) {
				throw new GenericEntityException(e);
			}
			if(values == null || values.isEmpty()) {
				GenericValue value = delegator.makeValue(PARTY_GROUP_DIMENSION);
				value.set(DIMENSION_ID, _dimension);
				value.set(PARTY_GROUP_DIM_ID, _dimension2);
				value.set(PARTY_GROUP, _group);
				try {
					value.create();
				} catch (GenericEntityException e) {
					throw new GenericEntityException(e);
				}
			}
		}
			
	}
}
