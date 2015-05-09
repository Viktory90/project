package com.olbius.olap.order;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Comparator;
import java.util.Map;

public class JqxUtilSort implements Comparator<Map<String,Object>> {
	private String sortField;
	
	public String getSortField() {
		return sortField;
	}

	public void setSortField(String sortField) {
		this.sortField = sortField;
	}

	@Override
	public int compare(Map<String, Object> o1, Map<String, Object> o2) {
		// TODO Auto-generated method stub
		String alterSortField = this.sortField;
		if(alterSortField.contains("-")){
			alterSortField = alterSortField.replace("-", "");
		}
		if(o1.get(alterSortField) instanceof String){
			if(sortField.contains("-")){
				/*sortField = sortField.replace("-", "");*/
				return ((String)o1.get(alterSortField)).compareTo((String)o2.get(alterSortField));
			}else{
				return ((String)o2.get(alterSortField)).compareTo((String)o1.get(alterSortField));
			}
		}else if(o1.get(alterSortField) instanceof BigDecimal){
			if(sortField.contains("-")){
				/*sortField = sortField.replace("-", "");*/
				return ((BigDecimal)o2.get(alterSortField)).compareTo((BigDecimal)o1.get(alterSortField));
				
			}else{
				return ((BigDecimal)o1.get(alterSortField)).compareTo((BigDecimal)o2.get(alterSortField));
			}
		}else{
			if(sortField.contains("-")){
				/*sortField = sortField.replace("-", "");*/
				return ((Timestamp)o1.get(alterSortField)).compareTo((Timestamp)o2.get(alterSortField));
			}else{
				return ((Timestamp)o2.get(alterSortField)).compareTo((Timestamp)o1.get(alterSortField));
			}

	
		}
	}
}
