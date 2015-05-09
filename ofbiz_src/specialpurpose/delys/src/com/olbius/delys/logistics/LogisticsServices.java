package com.olbius.delys.logistics;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.GeneralException;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import javolution.util.FastMap;

public class LogisticsServices {

	public static final String module = LogisticsServices.class.getName();
	public static final String resource = "DelysUiLabels";
	public static final String resourceError = "DelysErrorUiLabels";

	public static Map<String, Object> acceptReceiptRequirements(DispatchContext ctx, Map<String, ? extends Object> context) {
		Map<String, Object> result = FastMap.newInstance();
		Delegator delegator = ctx.getDelegator();
		LocalDispatcher dispatcher = ctx.getDispatcher();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String tmp = (String) context.get("listReceiptRequirements");
		JSONArray listReceiptRequirements = JSONArray.fromObject(tmp);
		for (int i = 0; i < listReceiptRequirements.size(); i++) {
			JSONObject item = listReceiptRequirements.getJSONObject(i);
			String facilityId = item.getString("facilityId");
			String contactMechId = item.getString("contactMechId");
			String requirementId = item.getString("requirementId");
			String agreementId = item.getString("agreementId");
			String orderId = item.getString("orderId");

			Map<String, Object> mapReceiptReq = FastMap.newInstance();
			mapReceiptReq.put("facilityId", facilityId);
			mapReceiptReq.put("contactMechId", contactMechId);
			mapReceiptReq.put("agreementId", agreementId);
			mapReceiptReq.put("requirementId", requirementId);
			mapReceiptReq.put("orderId", orderId);
			mapReceiptReq.put("userLogin", userLogin);
			try {
				dispatcher.runSync("acceptReceiptRequirement", mapReceiptReq);
			} catch (GenericServiceException e) {
				e.printStackTrace();
			}
		}
		try {
			List<GenericValue> listImportAdmins = delegator.findList("PartyRelationship", EntityCondition.makeCondition(UtilMisc.toMap("partyIdTo", "IMPORT_SPECIALIST", "roleTypeIdTo", "INTERNAL_ORGANIZATIO", "roleTypeIdFrom", "MANAGER")), null, null, null, false);
			if(!listImportAdmins.isEmpty()){
				for (GenericValue managerParty : listImportAdmins){
					String sendToPartyId = (String)managerParty.get("partyIdFrom");
					Map<String, Object> mapContext = new HashMap<String, Object>();
					String header = UtilProperties.getMessage(resource, "ReceiptRequirementAccepted", (Locale)context.get("locale"));
					mapContext.put("partyId", sendToPartyId);
					mapContext.put("action", "getListReceiptRequirements");
					mapContext.put("header", header);
					mapContext.put("userLogin", userLogin);
					try {
						dispatcher.runSync("createNotification", mapContext);
					} catch (GenericServiceException e) {
						e.printStackTrace();
					}
				}
			}
		} catch (GeneralException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> getListReceipts(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	List<GenericValue> listReceipts = new ArrayList<GenericValue>();
    	try {
    		listReceipts = delegator.findList("Receipt", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, listSortFields, opts, false);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListReceipts service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listReceipts);
    	return successResult;
    }
}