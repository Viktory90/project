package com.olbius.delys.accounting.jqservices;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class ChartOfAccountJQServices {
	public static final String module = ChartOfAccountJQServices.class.getName();
	public static final String resource = "widgetUiLabels";
    public static final String resourceError = "widgetErrorUiLabels";
    
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListChartOfAccount(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	Map<String, String> mapCondition = new HashMap<String, String>();
//    	mapCondition.put("organizationPartyId", (String)parameters.get("organizationPartyId")[0]);
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	try {
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		listIterator = delegator.find("GlAccount", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListChartOfAccount service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListChartOfAccountOrigination(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("organizationPartyId", (String)parameters.get("organizationPartyId")[0]);
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	try {
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		listIterator = delegator.find("GlAccountOrganizationAndClass", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListChartOfAccount service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }	
}
