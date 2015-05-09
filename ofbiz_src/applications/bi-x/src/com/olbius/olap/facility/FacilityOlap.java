package com.olbius.olap.facility;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.ofbiz.entity.GenericDataSourceException;
import org.ofbiz.entity.GenericEntityException;

import com.olbius.olap.OlapInterface;

public interface FacilityOlap extends OlapInterface {
	
	public static String TYPE_RECEIVE = "RECEIVE";
	public static String TYPE_EXPORT = "EXPORT";
	public static String TYPE_INVENTORY = "INVENTORY";
	public static String TYPE_BOOK = "BOOK";
	public static String TYPE_AVAILABLE = "AVAILABLE";
	
	void productReceiveQOH(String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productReceiveQOH(String facilityId, String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productReceiveQOH(String facilityId, String productId, String dateType) throws GenericDataSourceException, GenericEntityException, SQLException;

	void productReceiveQOH(String facilityId, String productId, String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productReceiveQOH() throws SQLException, GenericDataSourceException, GenericEntityException;
	
	void productExportQOH(String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productExportQOH(String facilityId, String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productExportQOH(String facilityId, String productId, String dateType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productExportQOH(String facilityId, String productId, String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productExportQOH() throws SQLException, GenericDataSourceException, GenericEntityException;
	
	void productInventoryQOH(String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryQOH(String facilityId, String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryQOH(String facilityId, String productId,  String dateType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryQOH(String facilityId, String productId,  String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryQOH() throws SQLException, GenericDataSourceException, GenericEntityException;
	
	Map<String, List<Integer>> getYAxis();
	
	List<Integer> getYAxis(String productId);
	
	List<String> getXAxis();
	
	String getType();
	
	void productBookATP(String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productBookATP(String facilityId, String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productBookATP(String facilityId, String productId, String dateType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productBookATP(String facilityId, String productId, String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException;

	void productBookATP() throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryATP(String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryATP(String facilityId, String productId) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryATP(String facilityId, String productId,  String dateType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryATP(String facilityId, String productId,  String dateType, String geoId, String geoType) throws GenericDataSourceException, GenericEntityException, SQLException;
	
	void productInventoryATP() throws SQLException, GenericDataSourceException, GenericEntityException;
	
}
