package com.olbius.olap;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.GenericEntityException;

public class OlapDate extends AbtractOlap{
	
	private final static String sql = "SELECT DISTINCT ON (%TYPE%) * FROM date_dimension WHERE date_value BETWEEN ? AND ? ORDER BY %TYPE% ASC";

	public List<String> getValues(String s) throws GenericDataSourceException, GenericEntityException, SQLException {
		
		getSQLProcessor().prepareStatement(sql.replaceAll("%TYPE%", s));
		
		getSQLProcessor().setValue(getSqlDate(fromDate));
		getSQLProcessor().setValue(getSqlDate(thruDate));
		
		getSQLProcessor().executeQuery();
		
		ResultSet resultSet = getSQLProcessor().getResultSet();
		
		List<String> list = new ArrayList<String>();
		
		while(resultSet.next()) {
			list.add(resultSet.getString(s));
		}
		
		return list;
	}
}
