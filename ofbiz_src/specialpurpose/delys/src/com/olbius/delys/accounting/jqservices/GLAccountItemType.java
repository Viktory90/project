package com.olbius.delys.accounting.jqservices;

import groovy.lang.Binding;
import groovy.lang.GroovyShell;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
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

public class GLAccountItemType {
	public static final String module = GLAccountItemType.class.getName();
	public static final String resource = "widgetUiLabels";
    public static final String resourceError = "widgetErrorUiLabels";
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getGLAccountItemTypeSale(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	
    	List<Object> listReturn = null;
    	Map<String, String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	try {
    		Binding binding = new Binding();
    		binding.setVariable("organizationPartyId", (String)parameters.get("organizationPartyId")[0]);
    		binding.setVariable("context", context);
    		binding.setVariable("parameters", GLAccountItemType.convertMap(parameters));
    		binding.setVariable("delegator", ctx.getDelegator());
    		GroovyShell shell = new GroovyShell(binding);
    		listReturn = (List<Object>) shell.evaluate(new File("applications/accounting/webapp/accounting/WEB-INF/actions/admin/ListInvoiceItemTypesGlAccount.groovy"));
		} catch (Exception e) {
			String errMsg = "Fatal error calling getGLAccountItemTypeSale service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listReturn);
    	return successResult;
    }
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getGLAccountItemTypePO(DispatchContext ctx, Map<String, Object> context) {
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	
    	List<Object> listReturn = null;
    	Map<String, String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	try {
    		Object strPinv = "PINV";
    		context.put("invItemTypePrefix", strPinv);
    		Binding binding = new Binding();
    		binding.setVariable("organizationPartyId", (String)parameters.get("organizationPartyId")[0]);
    		binding.setVariable("context", context);
    		binding.setVariable("parameters", GLAccountItemType.convertMap(parameters));
    		binding.setVariable("delegator", ctx.getDelegator());
    		GroovyShell shell = new GroovyShell(binding);
    		listReturn = (List<Object>) shell.evaluate(new File("applications/accounting/webapp/accounting/WEB-INF/actions/admin/ListInvoiceItemTypesGlAccount.groovy"));
		} catch (Exception e) {
			String errMsg = "Fatal error calling getGLAccountItemTypePO service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listReturn);
    	return successResult;
    }
    @SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListInvoiceItemTypeGLA(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);
    	try {
    		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    		listIterator = delegator.find("InvoiceItemType", tmpConditon, null, null, listSortFields, opts);
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListInvoiceItemTypeGLA service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    @SuppressWarnings("rawtypes")
	private static Map<String, String> convertMap(Map<String, String[]> mapArray){
    	Map<String, String> returnValue = new HashMap<String, String>();
    	Iterator it = mapArray.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pairs = (Map.Entry)it.next();
            if(pairs.getValue() instanceof String[]){
            	returnValue.put(pairs.getKey().toString(), ((String[])pairs.getValue())[0]);
            }
            it.remove(); // avoids a ConcurrentModificationException
        }
    	return returnValue;
    }
}
