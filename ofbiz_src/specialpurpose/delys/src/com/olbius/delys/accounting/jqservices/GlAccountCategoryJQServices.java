package com.olbius.delys.accounting.jqservices;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class GlAccountCategoryJQServices {
	public static final String module = GlAccountCategoryJQServices.class.getName();
	public static final String resource = "widgetUiLabels";
    public static final String resourceError = "widgetErrorUiLabels";
    public static Map<String, Object> jqListGlAccountCategory(DispatchContext ctx, Map<String, ? extends Object> context) {
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
    		listIterator = delegator.find("GlAccountCategory", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling jqListGlAccountCategory service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    
}
