package com.olbius.olap.facility;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.GenericEntityException;

import com.olbius.olap.AbtractOlap;
import com.olbius.olap.OlapDate;

public class FacilityOlapImpl extends AbtractOlap implements FacilityOlap {

	private String type;
	private Map<String, List<Integer>> yAxis;
	private List<String> xAxis;
	
	private void sqlProductQuery(String col, String facilityId, String productId, String inventoryType, String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException {
		
		dateType = dateType(dateType);
		
		String sql = "SELECT sum(%COL%) as total, %FACILITY%, product_id, %FACILITY_GEO%, %DATE_TYPE% FROM inventory_item_fact"
				+ " INNER JOIN date_dimension ON inventory_date_dim_id = date_dimension.dimension_id"
				+ " INNER JOIN product_dimension ON product_dim_id = product_dimension.dimension_id"
				+ " %JOIN_FACILITY%"
				+ " %JOIN_FACILITY_GEO%"
				+ " WHERE inventory_type=? AND (date_dimension.date_value BETWEEN ? AND ?)";
		
		sql = sql.replaceAll("%COL%", col);
		
		if(facilityId != null && !facilityId.isEmpty()) {
			sql = sql.replaceAll("%FACILITY%", "facility_id").replaceAll("%JOIN_FACILITY%", "INNER JOIN facility_dimension ON facility_dim_id = facility_dimension.dimension_id");
		} else {
			sql = sql.replaceAll(" %FACILITY%,", "").replaceAll(" %JOIN_FACILITY%", "");
		}
		
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			sql = sql.replaceAll("%FACILITY_GEO%", "geo_id").replaceAll("%JOIN_FACILITY_GEO%", "INNER JOIN facility_geo ON facility_dim_id = facility_geo.dimension_id");
		} else {
			sql = sql.replaceAll(" %FACILITY_GEO%,", "").replaceAll(" %JOIN_FACILITY_GEO%", "");
		}
		
		if(facilityId != null && !facilityId.isEmpty()) {
			sql += " AND facility_dimension.facility_id=?";
		}
		if(productId != null && !productId.isEmpty()) {
			sql += " AND product_dimension.product_id=?";
		}
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			sql += " AND facility_geo.geo_type=? AND facility_geo.geo_id=?";
		}
		
		if(facilityId != null && !facilityId.isEmpty()) {
			sql += " GROUP BY facility_id, product_id, %FACILITY_GEO%, %DATE_TYPE% ORDER BY product_id, %DATE_TYPE% ASC";
		} else {
			sql += " GROUP BY product_id, %FACILITY_GEO%, %DATE_TYPE% ORDER BY product_id, %DATE_TYPE% ASC";
		}
		
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			sql = sql.replaceAll("%FACILITY_GEO%", "geo_id");
		} else {
			sql = sql.replaceAll(" %FACILITY_GEO%,", "");
		}
		
		sql = sql.replaceAll("%DATE_TYPE%", dateType);
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(inventoryType);
		getSQLProcessor().setValue(getSqlDate(fromDate));
		getSQLProcessor().setValue(getSqlDate(thruDate));
		
		if(facilityId != null && !facilityId.isEmpty()) {
			getSQLProcessor().setValue(facilityId);
		}
		if(productId != null && !productId.isEmpty()) {
			getSQLProcessor().setValue(productId);
		}
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			getSQLProcessor().setValue(geoType);
			getSQLProcessor().setValue(geoId);
		}
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Map<String, Integer>> map = new HashMap<String, Map<String,Integer>>();
		
		while(resultSet.next()) {
			String product = resultSet.getString("product_id");
			if(map.get(product)==null) {
				map.put(product, new HashMap<String, Integer>());
			}
			if(inventoryType.equals(TYPE_RECEIVE)) {
				map.get(product).put(resultSet.getString(dateType), resultSet.getInt("total"));
			}
			if(inventoryType.equals(TYPE_EXPORT)) {
				map.get(product).put(resultSet.getString(dateType), -resultSet.getInt("total"));
			}
		}
		
		
		axis(map, productId, dateType);
		
		type = inventoryType;
	}
	
	private void axis(Map<String, Map<String, Integer>> map, String productId, String dateType) throws GenericDataSourceException, GenericEntityException, SQLException {
		OlapDate olapDate = new OlapDate();
		olapDate.SQLProcessor(getSQLProcessor());
		olapDate.setFromDate(fromDate);
		olapDate.setThruDate(thruDate);
		
		xAxis = olapDate.getValues(dateType);
		
		yAxis = new HashMap<String, List<Integer>>();
		
		if(map.isEmpty()) {
			map.put(productId, new HashMap<String, Integer>());
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
	public void productReceiveQOH(String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		
		productReceiveQOH(null, productId);
		
	}

	@Override
	public void productReceiveQOH() throws SQLException,
			GenericDataSourceException, GenericEntityException {
		productReceiveQOH(null);
	}

	@Override
	public void productExportQOH(String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		
		productExportQOH(null, productId);
		
	}

	@Override
	public void productExportQOH() throws SQLException,
			GenericDataSourceException, GenericEntityException {
		productExportQOH(null);
	}

	/*private String dateType(String dateType) {
		if(dateType == null || dateType.isEmpty() || dateType.equals(DAY)) {
			dateType = "year_month_day";
		}
		if(dateType.equals(MONTH)) {
			dateType = "year_and_month";
		}
		if(dateType.equals(YEAR)) {
			dateType = "year_name";
		}
		if(dateType.equals(WEEK)) {
			dateType = "week_and_year";
		}
		if(dateType.equals(QUARTER)) {
			dateType = "quarter_and_year";
		}
		return dateType;
	}*/
	
	private void sqlProductInventoryQOH(String col, String facilityId, String productId, String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException {
		
		dateType = dateType(dateType);
		
		String sql = "SELECT DISTINCT ON(%FACILITY%, product_id, %FACILITY_GEO%, %DATE_TYPE%) sum(%COL%) as total, %FACILITY%, product_id, %FACILITY_GEO%, %DATE_TYPE% FROM facility_fact"
				+ " INNER JOIN date_dimension ON date_dim_id = date_dimension.dimension_id"
				+ " INNER JOIN product_dimension ON product_dim_id = product_dimension.dimension_id"
				+ " %JOIN_FACILITY%"
				+ " %JOIN_FACILITY_GEO%"
				+ " WHERE (date_dimension.date_value BETWEEN ? AND ?)";
		
		sql = sql.replaceAll("%COL%", col);
		
		if(facilityId != null && !facilityId.isEmpty()) {
			sql = sql.replaceAll("%FACILITY%", "facility_id").replaceAll("%JOIN_FACILITY%", "INNER JOIN facility_dimension ON facility_dim_id = facility_dimension.dimension_id");
		} else {
			sql = sql.replaceAll("%FACILITY%, ", "").replaceAll(" %JOIN_FACILITY%", "");
		}
		
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			sql = sql.replaceAll("%FACILITY_GEO%", "geo_id").replaceAll("%JOIN_FACILITY_GEO%", "INNER JOIN facility_geo ON facility_dim_id = facility_geo.dimension_id");
		} else {
			sql = sql.replaceAll(" %FACILITY_GEO%,", "").replaceAll(" %JOIN_FACILITY_GEO%", "");
		}
		
		if(facilityId != null && !facilityId.isEmpty()) {
			sql += " AND facility_dimension.facility_id=?";
		}
		if(productId != null && !productId.isEmpty()) {
			sql += " AND product_dimension.product_id=?";
		}
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			sql += " AND facility_geo.geo_type=? AND facility_geo.geo_id=?";
		}
		
		if(facilityId != null && !facilityId.isEmpty()) {
			sql += " GROUP BY facility_id, product_id, %FACILITY_GEO%, %DATE_TYPE%, date_dimension.date_value";
			sql += " ORDER BY facility_id, product_id, %FACILITY_GEO%, %DATE_TYPE% ASC, date_dimension.date_value DESC";
		} else {
			sql += " GROUP BY product_id, %FACILITY_GEO%, %DATE_TYPE%, date_dimension.date_value";
			sql += " ORDER BY product_id, %FACILITY_GEO%, %DATE_TYPE% ASC, date_dimension.date_value DESC";
		}
		
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			sql = sql.replaceAll("%FACILITY_GEO%", "geo_id");
		} else {
			sql = sql.replaceAll(" %FACILITY_GEO%,", "");
		}
		
		sql = sql.replaceAll("%DATE_TYPE%", dateType);
		
		getSQLProcessor().prepareStatement(sql);
		
		getSQLProcessor().setValue(getSqlDate(fromDate));
		getSQLProcessor().setValue(getSqlDate(thruDate));
		
		if(facilityId != null && !facilityId.isEmpty()) {
			getSQLProcessor().setValue(facilityId);
		}
		if(productId != null && !productId.isEmpty()) {
			getSQLProcessor().setValue(productId);
		}
		if(geoId != null && !geoId.isEmpty() && geoType != null && !geoType.isEmpty()) {
			getSQLProcessor().setValue(geoType);
			getSQLProcessor().setValue(geoId);
		}
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		Map<String, Map<String, Integer>> map = new HashMap<String, Map<String,Integer>>();
		
		while(resultSet.next()) {
			String product = resultSet.getString("product_id");
			if(map.get(product)==null) {
				map.put(product, new HashMap<String, Integer>());
			}
			map.get(product).put(resultSet.getString(dateType), resultSet.getInt("total"));
		}
		
		axis(map, productId, dateType);
		
		type = TYPE_INVENTORY;
	}
	
	@Override
	public void productInventoryQOH(String facilityId, String productId, String dateType)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		
		productInventoryQOH(facilityId, productId, dateType, null, null);
		
	}

	@Override
	public void productInventoryQOH() throws SQLException,
			GenericDataSourceException, GenericEntityException {
		productInventoryQOH(null);
	}

	@Override
	public List<String> getXAxis() {
		return xAxis;
	}

	@Override
	public List<Integer> getYAxis(String productId) {
		return yAxis.get(productId);
	}

	@Override
	public Map<String, List<Integer>> getYAxis() {
		return yAxis;
	}

	@Override
	public String getType() {
		return type;
	}

	@Override
	public void productReceiveQOH(String facilityId, String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productReceiveQOH(facilityId, productId, null);
	}

	@Override
	public void productExportQOH(String facilityId, String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productExportQOH(facilityId, productId, null);
	}

	@Override
	public void productInventoryQOH(String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productInventoryQOH(null, productId);
	}

	@Override
	public void productReceiveQOH(String facilityId, String productId,
			String dateType) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		productReceiveQOH(facilityId, productId, dateType, null, null);
	}

	@Override
	public void productExportQOH(String facilityId, String productId,
			String dateType) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		productExportQOH(facilityId, productId, dateType, null, null);
	}

	@Override
	public void productInventoryQOH(String facilityId, String productId) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		productInventoryQOH(facilityId, productId, null);
	}

	@Override
	public void productReceiveQOH(String facilityId, String productId,
			String dateType, String geoId, String geoType)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		sqlProductQuery("quantity_on_hand_total", facilityId, productId, TYPE_RECEIVE, dateType, geoId, geoType);
	}

	@Override
	public void productExportQOH(String facilityId, String productId,
			String dateType, String geoId, String geoType)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		sqlProductQuery("quantity_on_hand_total", facilityId, productId, TYPE_EXPORT, dateType, geoId, geoType);
	}

	@Override
	public void productInventoryQOH(String facilityId, String productId,
			String dateType, String geoId, String geoType)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		sqlProductInventoryQOH("inventory_total", facilityId, productId, dateType, geoId, geoType);
	}

	@Override
	public void productBookATP(String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productBookATP(null, productId);
	}

	@Override
	public void productBookATP(String facilityId, String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productBookATP(facilityId, productId, null);
	}

	@Override
	public void productBookATP(String facilityId, String productId,
			String dateType) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		productBookATP(facilityId, productId, dateType, null, null);
	}

	@Override
	public void productBookATP(String facilityId, String productId,
			String dateType, String geoId, String geoType)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		sqlProductQuery("available_to_promise_total", facilityId, productId, TYPE_EXPORT, dateType, geoId, geoType);
	}

	@Override
	public void productInventoryATP(String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productInventoryATP(null, productId);
	}

	@Override
	public void productInventoryATP(String facilityId, String productId)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		productInventoryATP(facilityId, productId, null);
	}

	@Override
	public void productInventoryATP(String facilityId, String productId,
			String dateType) throws GenericDataSourceException,
			GenericEntityException, SQLException {
		productInventoryATP(facilityId, productId, dateType, null, null);
	}

	@Override
	public void productInventoryATP(String facilityId, String productId,
			String dateType, String geoId, String geoType)
			throws GenericDataSourceException, GenericEntityException,
			SQLException {
		sqlProductInventoryQOH("available_to_promise_total", facilityId, productId, dateType, geoId, geoType);
	}

	@Override
	public void productInventoryATP() throws SQLException,
			GenericDataSourceException, GenericEntityException {
		productInventoryATP(null);
	}

	@Override
	public void productBookATP() throws GenericDataSourceException,
			GenericEntityException, SQLException {
		productBookATP(null);
	}
	
}
