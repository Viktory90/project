package com.olbius.olap.party;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;

import com.olbius.datawarehouse.dimensions.Dimension;
import com.olbius.datawarehouse.dimensions.PartyDimension;
import com.olbius.olap.AbtractOlap;
import com.olbius.olap.OlapDate;

public class PartyOlapImpl extends AbtractOlap implements PartyOlap {

	private Map<String, List<Integer>> yAxis;
	private List<String> xAxis;
	private List<String> group;
	
	@Override
	public Map<String, List<Integer>> getYAxis() {
		return yAxis;
	}

	@Override
	public List<Integer> getYAxis(String key) {
		return yAxis.get(key);
	}

	@Override
	public List<String> getXAxis() {
		return xAxis;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setGroup(List<?> list, boolean olap, Delegator delegator) throws GenericEntityException {
		if(list == null || list.isEmpty()) {
			this.group = (List<String>) list;
		} else if(olap) {
			this.group = (List<String>) list;
		} else {
			this.group = new ArrayList<String>();
			for(Object obj : list) {
				List<GenericValue> values = null;

				List<EntityCondition> conditions = new ArrayList<EntityCondition>();
				
				conditions.add(EntityCondition.makeCondition(PartyDimension.PARTY_ID, EntityOperator.EQUALS, obj));
				
				try {
					values = delegator.findList(PartyDimension.PARTY_DIMENSION,
							EntityCondition.makeCondition(conditions, EntityOperator.OR), null,
							UtilMisc.toList(Dimension.DIMENSION_ID), null, false);
				} catch (GenericEntityException e) {
					throw new GenericEntityException(e);
				}
				if(values != null && !values.isEmpty()) {
					this.group.add(Long.toString(values.get(0).getLong(Dimension.DIMENSION_ID)));
				}
			}
		}
	}

	@Override
	public void gender() throws GenericDataSourceException, GenericEntityException, SQLException {
		String sql = "SELECT gender, %GROUP%, count(person_fact.party_dim_id) as count FROM person_fact"
				+ " INNER JOIN party_relationship_fact ON person_fact.party_dim_id = party_relationship_fact.party_dim_id"
				+ " INNER JOIN party_group_dimension ON party_relationship_fact.party_group_dim_id = party_group_dimension.dimension_id"
				+ "	INNER JOIN date_dimension AS from_date_dimension ON from_date_dim_id = from_date_dimension.dimension_id"
				+ " INNER JOIN date_dimension AS thru_date_dimension ON thru_date_dim_id = thru_date_dimension.dimension_id"
				+ " WHERE (thru_date_dimension.date_value ISNULL OR thru_date_dimension.date_value > ?) AND from_date_dimension.date_value <= ? %WHERE%"
				+ " GROUP BY %GROUP%, gender ORDER BY gender ASC";
		
		if(group != null && !group.isEmpty()) {
			sql = sql.replaceAll("%GROUP%", "party_group_dimension.party_group_dim_id, party_group_dimension.party_group");
//			sql = sql.replaceAll("%JOIN_GROUP%", "INNER JOIN party_relationship_fact ON person_fact.party_dim_id = party_relationship_fact.party_dim_id"
//					+ " INNER JOIN party_group_dimension ON party_relationship_fact.party_group_dim_id = party_group_dimension.dimension_id");
			String tmp = "";
			for(int i = 0; i < group.size(); i++) {
				tmp += "\'"+group.get(i)+"\'";
				if(i < group.size() - 1) {
					tmp += ", ";
				}
			}
			sql = sql.replaceAll("%WHERE%", "AND CAST(party_group AS TEXT[]) = array\\[" + tmp + "\\]");
		} else {
			sql = sql.replaceAll("%GROUP%, ", "");
//			sql = sql.replaceAll(" %JOIN_GROUP%", "");
			sql = sql.replaceAll(" %WHERE%", "");
		}
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Integer> map = new HashMap<String, Integer>();
		
		xAxis = new ArrayList<String>();
		
		while(resultSet.next()) {
			String gender = resultSet.getString("gender");
			if(gender == null) {
				gender = "others";
			}
			int count = resultSet.getInt("count");
			map.put(gender, count);
			xAxis.add(gender);
		}
		
		yAxis = new HashMap<String, List<Integer>>();
		
		for(String key : map.keySet()) {
			if(key != null) {
				yAxis.put(key, new ArrayList<Integer>());
				yAxis.get(key).add(map.get(key));
			}
		}
	}

	@Override
	public void personBirth(boolean gender) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		
		String sql = "SELECT extract(year from age(date_dimension.date_value)) as age, %GENDER%, %GROUP%, count(person_fact.party_dim_id) as count FROM person_fact"
				+ " INNER JOIN date_dimension ON birth_date_dim_id = date_dimension.dimension_id"
				+ " INNER JOIN party_relationship_fact ON person_fact.party_dim_id = party_relationship_fact.party_dim_id"
				+ " INNER JOIN party_group_dimension ON party_relationship_fact.party_group_dim_id = party_group_dimension.dimension_id"
				+ "	INNER JOIN date_dimension AS from_date_dimension ON from_date_dim_id = from_date_dimension.dimension_id"
				+ " INNER JOIN date_dimension AS thru_date_dimension ON thru_date_dim_id = thru_date_dimension.dimension_id"
				+ " WHERE (thru_date_dimension.date_value ISNULL OR thru_date_dimension.date_value > ?) AND from_date_dimension.date_value <= ? %AND_GROUP% %AND_GENDER%"
				+ " GROUP BY %GENDER%, %GROUP%, age ORDER BY age ASC";
		
		if(gender) {
			sql = sql.replaceAll("%GENDER%", "gender");
			sql = sql.replaceAll("%AND_GENDER%", "AND gender NOTNULL AND date_dimension.date_value NOTNULL");
		} else {
			sql = sql.replaceAll("%GENDER%, ", "");
			sql = sql.replaceAll("%AND_GENDER% ", "");
		}
		if(group != null && !group.isEmpty()) {
			sql = sql.replaceAll("%GROUP%", "party_group_dimension.party_group_dim_id, party_group_dimension.party_group");
//			sql = sql.replaceAll("%JOIN_GROUP%", "INNER JOIN party_relationship_fact ON person_fact.party_dim_id = party_relationship_fact.party_dim_id"
//					+ "	INNER JOIN party_group_dimension ON party_relationship_fact.party_group_dim_id = party_group_dimension.dimension_id");
			String tmp = "";
			for(int i = 0; i < group.size(); i++) {
				tmp += "\'"+group.get(i)+"\'";
				if(i < group.size() - 1) {
					tmp += ", ";
				}
			}
			sql = sql.replaceAll("%AND_GROUP%", "AND CAST(party_group AS TEXT[]) = array\\[" + tmp + "\\]");
		} else {
			sql = sql.replaceAll("%GROUP%, ", "");
//			sql = sql.replaceAll(" %JOIN_GROUP%", "");
			sql = sql.replaceAll(" %AND_GROUP%", "");
		}
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Map<String, Integer>> map = new HashMap<String, Map<String,Integer>>();
		
		Map<String, Integer> map2 = new HashMap<String, Integer>();
		
		xAxis = new ArrayList<String>();
		
		yAxis = new HashMap<String, List<Integer>>();
		
		if(gender) {
			while(resultSet.next()) {
				String _gender = resultSet.getString("gender");
				if(map.get(_gender)==null) {
					map.put(_gender, new HashMap<String, Integer>());
				}
				String age = Integer.toString(resultSet.getInt("age"));
				map.get(_gender).put(age, resultSet.getInt("count"));
				xAxis.add(age);
			}
			for(String key : map.keySet()) {
				if(key != null) {
					yAxis.put(key, new ArrayList<Integer>());
					for(String s: xAxis) {
						if(map.get(key).get(s) == null) {
							yAxis.get(key).add(new Integer(0));
						} else {
							if(key.equals("F")) {
								yAxis.get(key).add(-map.get(key).get(s));
							} else {
								yAxis.get(key).add(map.get(key).get(s));
							}
						}
					}
				}
			}
		} else {
			while(resultSet.next()) {
				String age = Integer.toString(resultSet.getInt("age"));
				if(age.equals("0")) {
					age = "others";
				}
				map2.put(age, resultSet.getInt("count"));
				xAxis.add(age);
			}
			for(String key : map2.keySet()) {
				if(key != null) {
					yAxis.put(key, new ArrayList<Integer>());
					yAxis.get(key).add(map2.get(key));
				}
			}
		}
	}

	@Override
	public void menber(String dateType, boolean child, boolean cur) throws GenericDataSourceException, GenericEntityException, SQLException {
		
		dateType = dateType(dateType);
		
		String sql = "SELECT DISTINCT ON(party_group_dimension.dimension_id, party_group_dimension.party_group, %DATE_TYPE%)"
				+ " party_group_dimension.dimension_id, party_group_dimension.party_group, %DATE_TYPE_%, member, party_id FROM person_group_fact"
				+ " INNER JOIN date_dimension ON date_dim_id = date_dimension.dimension_id"
				+ " INNER JOIN party_group_dimension ON person_group_fact.party_group_dim_id = party_group_dimension.dimension_id"
				+ "	INNER JOIN party_dimension ON party_group_dimension.party_group_dim_id = party_dimension.dimension_id"
				+ " WHERE (date_dimension.date_value BETWEEN ? AND ?) %AND_GROUP%"
				+ " ORDER BY party_group_dimension.dimension_id, party_group_dimension.party_group, %DATE_TYPE% ASC, date_dimension.date_value DESC";
		
		if(group != null && !group.isEmpty()) {
			String tmp = "";
			for(int i = 0; i < group.size(); i++) {
				tmp += "\'"+group.get(i)+"\'";
				if(i < group.size() - 1) {
					tmp += ", ";
				}
			}
			if(child) {
				sql = sql.replaceAll("%AND_GROUP%", "AND CAST(party_group_dimension.party_group AS TEXT[]) @> array\\[" + tmp + "\\]"
						+ " AND CAST(party_group_dimension.party_group AS TEXT[]) @> array['18'] AND array_length(CAST(party_group_dimension.party_group AS TEXT[]),1)="+Integer.toString(group.size()+1)
						+ " AND CAST(party_group_dimension.party_group AS TEXT[]) @> string_to_array(CAST(party_group_dimension.dimension_id AS TEXT), ',')");
			} else {
				sql = sql.replaceAll("%AND_GROUP%", "AND CAST(party_group_dimension.party_group AS TEXT[]) = array\\[" + tmp + "\\]"
						+ " AND CAST(party_group_dimension.party_group AS TEXT[]) @> string_to_array(CAST(party_group_dimension.dimension_id AS TEXT), ',')");
			}
		} else {
			sql = sql.replaceAll(" %AND_GROUP%", "");
		}
		
		if(cur && child) {
			sql = sql.replaceAll(", %DATE_TYPE%", "");
			dateType = "year_month_day";
		} else {
			sql = sql.replaceAll("%DATE_TYPE%", dateType);
		}
		sql = sql.replaceAll("%DATE_TYPE_%", dateType);
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(getSqlDate(fromDate));
		getSQLProcessor().setValue(getSqlDate(thruDate));
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Map<String, Integer>> map = new HashMap<String, Map<String,Integer>>();
		
		while(resultSet.next()) {
			String party = resultSet.getString("party_id");
			if(map.get(party)==null) {
				map.put(party, new HashMap<String, Integer>());
			}
			map.get(party).put(resultSet.getString(dateType), resultSet.getInt("member"));
		}
		if(cur && child) {
			
			xAxis = new ArrayList<String>();
			
			yAxis = new HashMap<String, List<Integer>>();
			
			yAxis.put("member", new ArrayList<Integer>());
			
			for(String key : map.keySet()) {
				xAxis.add(key);
				if(!map.get(key).isEmpty()) {
					for(String s : map.get(key).keySet()) {
						if(map.get(key).get(s)!= null) {
							yAxis.get("member").add(map.get(key).get(s));
						} else {
							yAxis.get("member").add(new Integer(0));
						}
					}
				}
			}
		} else {
			axis(map, dateType);
		}
		
	}
	
	private void axis(Map<String, Map<String, Integer>> map, String dateType) throws GenericDataSourceException, GenericEntityException, SQLException {
		OlapDate olapDate = new OlapDate();
		olapDate.SQLProcessor(getSQLProcessor());
		olapDate.setFromDate(fromDate);
		olapDate.setThruDate(thruDate);
		
		xAxis = olapDate.getValues(dateType);
		
		yAxis = new HashMap<String, List<Integer>>();
		
		if(map.isEmpty()) {
			map.put("Empty", new HashMap<String, Integer>());
		}
		
		for(String key : map.keySet()) {
			if(yAxis.get(key)==null) {
				yAxis.put(key, new ArrayList<Integer>());
			}
		}
		
		
		for(String s : xAxis) {
			
			for(String key : map.keySet()) {
				if(map.get(key).get(s)!= null) {
					yAxis.get(key).add(map.get(key).get(s));
				} else {
					yAxis.get(key).add(new Integer(0));
				}
			}
		}
	}

	@Override
	public void personOlap(String dateType, boolean child, boolean ft)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		
		dateType = dateType(dateType);
		
		String sql = "SELECT DISTINCT ON(party_group_dimension.dimension_id, party_group_dimension.party_group, %DATE_TYPE%)"
				+ " party_group_dimension.dimension_id, party_group_dimension.party_group, %DATE_TYPE%, member, party_id FROM (%SL%) AS person_group_fact"
				+ " INNER JOIN date_dimension ON date_dim_id = date_dimension.dimension_id"
				+ " INNER JOIN party_group_dimension ON person_group_fact.party_group_dim_id = party_group_dimension.dimension_id"
				+ "	INNER JOIN party_dimension ON party_group_dimension.party_group_dim_id = party_dimension.dimension_id"
				+ " WHERE (date_dimension.date_value BETWEEN ? AND ?) %AND_GROUP%"
				+ " ORDER BY party_group_dimension.dimension_id, party_group_dimension.party_group, %DATE_TYPE% ASC, date_dimension.date_value DESC";
		
		if(group != null && !group.isEmpty()) {
			String tmp = "";
			for(int i = 0; i < group.size(); i++) {
				tmp += "\'"+group.get(i)+"\'";
				if(i < group.size() - 1) {
					tmp += ", ";
				}
			}
			if(child) {
				sql = sql.replaceAll("%AND_GROUP%", "AND CAST(party_group_dimension.party_group AS TEXT[]) @> array\\[" + tmp + "\\]"
						+ " AND CAST(party_group_dimension.party_group AS TEXT[]) @> array['18'] AND array_length(CAST(party_group_dimension.party_group AS TEXT[]),1)="+Integer.toString(group.size()+1)
						+ " AND CAST(party_group_dimension.party_group AS TEXT[]) @> string_to_array(CAST(party_group_dimension.dimension_id AS TEXT), ',')");
			} else {
				sql = sql.replaceAll("%AND_GROUP%", "AND CAST(party_group_dimension.party_group AS TEXT[]) = array\\[" + tmp + "\\]"
						+ " AND CAST(party_group_dimension.party_group AS TEXT[]) @> string_to_array(CAST(party_group_dimension.dimension_id AS TEXT), ',')");
			}
		} else {
			sql = sql.replaceAll(" %AND_GROUP%", "");
		}
		
		sql = sql.replaceAll("%DATE_TYPE%", dateType);
		
		String tmp = "SELECT count(party_dim_id) as member, party_group_dimension.party_group_dim_id, party_group, date_dimension.date_value, date_dimension.dimension_id as date_dim_id FROM party_relationship_fact"
				+ "	INNER JOIN party_group_dimension ON party_relationship_fact.party_group_dim_id = party_group_dimension.dimension_id"
				+ " INNER JOIN date_dimension ON %DIM% = date_dimension.dimension_id"
				+ "	WHERE relationship=\\'EMPLOYMENT\\'"
				+ " GROUP BY party_group_dimension.party_group_dim_id, party_group, date_dimension.date_value, date_dimension.dimension_id"
				+ " ORDER BY party_group_dim_id ASC";
		
		if(ft) {
			tmp = tmp.replaceAll("%DIM%", "from_date_dim_id");
		} else {
			tmp = tmp.replaceAll("%DIM%", "thru_date_dim_id");
		}
		
		sql = sql.replaceAll("%SL%", tmp);
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(getSqlDate(fromDate));
		getSQLProcessor().setValue(getSqlDate(thruDate));
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Map<String, Integer>> map = new HashMap<String, Map<String,Integer>>();
		
		while(resultSet.next()) {
			String party = resultSet.getString("party_id");
			if(map.get(party)==null) {
				map.put(party, new HashMap<String, Integer>());
			}
			map.get(party).put(resultSet.getString(dateType), resultSet.getInt("member"));
		}
		
		axis(map, dateType);
	}

	@Override
	public void school(String type) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		
		type = getType(type);
		
		String sql = "SELECT %SCH%, %GROUP%, count(person_fact.party_dim_id) as count FROM person_fact"
				+ " %JOIN_GROUP%"
				/*+ "	INNER JOIN date_dimension AS from_date_dimension ON from_date_dim_id = from_date_dimension.dimension_id"
				+ " INNER JOIN date_dimension AS thru_date_dimension ON thru_date_dim_id = thru_date_dimension.dimension_id"
				+ " WHERE (thru_date_dimension.date_value ISNULL OR thru_date_dimension.date_value > ?) AND from_date_dimension.date_value <= ? %WHERE%"*/
				+ " %WHERE%"
				+ " GROUP BY %GROUP%, %SCH% ORDER BY %SCH% ASC";
		
		if(group != null && !group.isEmpty()) {
			sql = sql.replaceAll("%GROUP%", "party_group_dimension.party_group_dim_id, party_group_dimension.party_group");
			sql = sql.replaceAll("%JOIN_GROUP%", "INNER JOIN party_relationship_fact ON person_fact.party_dim_id = party_relationship_fact.party_dim_id"
					+ " INNER JOIN party_group_dimension ON party_relationship_fact.party_group_dim_id = party_group_dimension.dimension_id");
			String tmp = "";
			for(int i = 0; i < group.size(); i++) {
				tmp += "\'"+group.get(i)+"\'";
				if(i < group.size() - 1) {
					tmp += ", ";
				}
			}
			sql = sql.replaceAll("%WHERE%", "WHERE CAST(party_group AS TEXT[]) = array\\[" + tmp + "\\]");
		} else {
			sql = sql.replaceAll("%GROUP%, ", "");
			sql = sql.replaceAll(" %JOIN_GROUP%", "");
			sql = sql.replaceAll(" %WHERE%", "");
		}
		
		sql = sql.replaceAll("%SCH%", type);
		
		getSQLProcessor().prepareStatement(sql);
		
		/*getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));*/
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Integer> map = new HashMap<String, Integer>();
		
		xAxis = new ArrayList<String>();
		
		while(resultSet.next()) {
			String tmp = resultSet.getString(type);
			if(tmp == null) {
				tmp = "others";
			}
			int count = resultSet.getInt("count");
			map.put(tmp, count);
			xAxis.add(tmp);
		}
		
		yAxis = new HashMap<String, List<Integer>>();
		
		for(String key : map.keySet()) {
			if(key != null) {
				yAxis.put(key, new ArrayList<Integer>());
				yAxis.get(key).add(map.get(key));
			}
		}
	}
	
	private String getType(String type) {
		if(type == null || type.isEmpty() || type.equals(SCHOOL)) {
			type = "school_id";
		}
		if(type.equals(EDU_SYS)) {
			type = "education_system_type_id";
		}
		if(type.equals(STUDY_MODE)) {
			type = "study_mode_type_id";
		}
		if(type.equals(MAJOR)) {
			type = "major_id";
		}
		if(type.equals(CLASSIFICATION)) {
			type = "classification_type_id";
		}
		return type;
	}

	@Override
	public void position(boolean child) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		
		String sql = "SELECT count(empl_position_fact.party_dim_id) AS member, empl_position_fact.empl_position_dim_id, empl_position_dimension.empl_position_type_id, %GROUP% FROM empl_position_fact"
				+ " INNER JOIN empl_position_dimension ON empl_position_dim_id = empl_position_dimension.dimension_id"
				+ " %JOIN_GROUP%"
				+ "	INNER JOIN date_dimension AS from_date_dimension ON from_date_dim_id = from_date_dimension.dimension_id"
				+ " INNER JOIN date_dimension AS thru_date_dimension ON thru_date_dim_id = thru_date_dimension.dimension_id"
				+ " WHERE (thru_date_dimension.date_value ISNULL OR thru_date_dimension.date_value > ?) AND from_date_dimension.date_value <= ? %WHERE%"
				+ " GROUP BY empl_position_fact.empl_position_dim_id, empl_position_dimension.empl_position_type_id, %GROUP%"
				+ " ORDER BY empl_position_fact.empl_position_dim_id ASC";
		
		if(group != null && !group.isEmpty()) {
			sql = sql.replaceAll("%GROUP%", "party_group_dimension.party_group_dim_id, party_group_dimension.party_group");
			sql = sql.replaceAll("%JOIN_GROUP%", "INNER JOIN party_group_dimension ON empl_position_dimension.party_dim_id = party_group_dimension.dimension_id"
					+ " INNER JOIN party_dimension ON party_group_dimension.dimension_id = party_dimension.dimension_id");
			String tmp = "";
			for(int i = 0; i < group.size(); i++) {
				tmp += "\'"+group.get(i)+"\'";
				if(i < group.size() - 1) {
					tmp += ", ";
				}
			}
			String _tmp = "AND CAST(party_group AS TEXT[]) = array\\[" + tmp + "\\]";
			if(child) {
				_tmp += " AND CAST(party_group_dimension.party_group AS TEXT[]) @> string_to_array(CAST(party_group_dimension.dimension_id AS TEXT), ',')";
			}
			sql = sql.replaceAll("%WHERE%", _tmp);
		} else {
			sql = sql.replaceAll(", %GROUP%", "");
			sql = sql.replaceAll(" %JOIN_GROUP%", "");
			sql = sql.replaceAll(" %WHERE%", "");
		}
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().setValue(getSqlDate(new Date(System.currentTimeMillis())));
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Integer> map = new HashMap<String, Integer>();
		
		xAxis = new ArrayList<String>();
		
		while(resultSet.next()) {
			String tmp = resultSet.getString("empl_position_type_id");
			if(tmp == null) {
				tmp = "others";
			}
			int count = resultSet.getInt("member");
			map.put(tmp, count);
			xAxis.add(tmp);
		}
		
		yAxis = new HashMap<String, List<Integer>>();
		
		for(String key : map.keySet()) {
			if(key != null) {
				yAxis.put(key, new ArrayList<Integer>());
				yAxis.get(key).add(map.get(key));
			}
		}
	}

}
