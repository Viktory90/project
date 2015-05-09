package com.olbius.datawarehouse.services;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

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
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ModelService;

import com.olbius.datawarehouse.dimensions.PartyDimension;
import com.olbius.olap.party.PartyOlap;
import com.olbius.olap.party.PartyOlapFactory;

public class PartyServices {
	
	public final static String module = PartyServices.class.getName();
	
	public final static PartyOlapFactory PARTY = new PartyOlapFactory();
	
	public static Map<String, Object> personBirth(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<?> group = (List<?>) context.get("group[]");
		
		Boolean gender = (Boolean) context.get("gender");
		
		if(gender == null) {
			gender = false;
		}
		
		PartyOlap olap = PARTY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		try {
			olap.setGroup(group, false, delegator);
			olap.personBirth(gender);
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
	
	public static Map<String, Object> gender(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<?> group = (List<?>) context.get("group[]");
		
		PartyOlap olap = PARTY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		try {
			olap.setGroup(group, false, delegator);
			olap.gender();
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
	
	public static Map<String, Object> member(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<?> group = (List<?>) context.get("group[]");
		
		Date fromDate = (Date) context.get("fromDate");
		
		Date thruDate = (Date) context.get("thruDate");
		
		String dateType = (String) context.get("dateType");
		
		Boolean child = (Boolean) context.get("child");
		
		Boolean cur = (Boolean) context.get("cur");
		
		if(child == null) {
			child = false;
		}
		
		if(cur == null) {
			cur = false;
		}
		
		PartyOlap olap = PARTY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		olap.setFromDate(fromDate);
		
		olap.setThruDate(thruDate);
		
		try {
			olap.setGroup(group, false, delegator);
			olap.menber(dateType, child, cur);
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
	
	public static Map<String, Object> personOlap(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<?> group = (List<?>) context.get("group[]");
		
		Date fromDate = (Date) context.get("fromDate");
		
		Date thruDate = (Date) context.get("thruDate");
		
		String dateType = (String) context.get("dateType");
		
		Boolean child = (Boolean) context.get("child");
		
		Boolean ft = (Boolean) context.get("ft");
		
		if(child == null) {
			child = false;
		}
		
		PartyOlap olap = PARTY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		olap.setFromDate(fromDate);
		
		olap.setThruDate(thruDate);
		
		try {
			olap.setGroup(group, false, delegator);
			olap.personOlap(dateType, child, ft);
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
	
	public static Map<String, Object> school(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<?> group = (List<?>) context.get("group[]");
		
		String type = (String) context.get("type");
		
		PartyOlap olap = PARTY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		try {
			olap.setGroup(group, false, delegator);
			olap.school(type);
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
	
	public static Map<String, Object> position(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<?> group = (List<?>) context.get("group[]");
		
		Boolean child = (Boolean) context.get("child");
		
		if(child == null) {
			child = false;
		}
		
		PartyOlap olap = PARTY.newInstance();
		
		olap.SQLProcessor(new SQLProcessor(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap")));
		
		try {
			olap.setGroup(group, false, delegator);
			olap.position(child);;
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
	
	public static Map<String, Object> getAllPartyParent(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<GenericValue> values = null;
		
		Set<String> _set = new TreeSet<String>();
		
		Set<String> __set = new TreeSet<String>();
		
		try {
			values = delegator.findList(PartyDimension.PARTY_RELATIONSHIP, EntityCondition.makeCondition(PartyDimension.PARTY_RELATIONSHIP_TYPE_ID, EntityOperator.EQUALS, "GROUP_ROLLUP"), null, UtilMisc.toList(PartyDimension.PARTY_ID_TO), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		for(GenericValue value : values) {
			__set.add(value.getString("partyIdTo"));
		}
		
		try {
			values = delegator.findList(PartyDimension.PARTY, EntityCondition.makeCondition(PartyDimension.PARTY_TYPE_ID, EntityOperator.EQUALS, "PARTY_GROUP"), null, UtilMisc.toList(PartyDimension.PARTY_ID), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		for(GenericValue value : values) {
			_set.add(value.getString(PartyDimension.PARTY_ID));
		}
		
		Set<String> _pr = new TreeSet<String>();
		
		for(String s : _set) {
			if(!__set.contains(s)) {
				_pr.add(s);
			}
		}
		
		Map<String, Object> result = FastMap.newInstance();
		List<String> parent = new ArrayList<String>();
		parent.addAll(_pr);
		result.put("parent", parent);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;

	}
	
	public static Map<String, Object> getChildParty(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		List<GenericValue> values = null;
		
		String parent = (String) context.get("parent");
		
		Set<String> _set = new TreeSet<String>();
		
		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition(PartyDimension.PARTY_RELATIONSHIP_TYPE_ID, EntityOperator.EQUALS, "GROUP_ROLLUP"));
		conditions.add(EntityCondition.makeCondition(PartyDimension.PARTY_ID_FROM, EntityOperator.EQUALS, parent));
		
		try {
			values = delegator.findList(PartyDimension.PARTY_RELATIONSHIP, EntityCondition.makeCondition(conditions, EntityOperator.AND), null, UtilMisc.toList(PartyDimension.PARTY_ID_TO), null, false);
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		for(GenericValue value : values) {
			_set.add(value.getString("partyIdTo"));
		}
		
		Map<String, Object> result = FastMap.newInstance();
		List<String> child = new ArrayList<String>();
		child.addAll(_set);
		result.put("child", child);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;

	}
}
