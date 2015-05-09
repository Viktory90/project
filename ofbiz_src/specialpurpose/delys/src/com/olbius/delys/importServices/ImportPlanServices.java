package com.olbius.delys.importServices;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javolution.util.FastMap;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.olbius.delys.services.DelysServices;

public class ImportPlanServices {
	public static Role ROLE = null;
	public static GenericValue USER_LOGIN = null;
	public static String PARTY_ID = null;
	public enum Role {
		DELYS_ADMIN, DELYS_ROUTE, DELYS_ASM_GT, DELYS_RSM_GT, DELYS_CSM_GT, DELYS_CUSTOMER_GT, DELYS_SALESSUP_GT;
	}
	public static final String module = DelysServices.class.getName();
	public static final String resource = "DelysUiLabels";
	public static final String resourceError = "DelysErrorUiLabels";
	
	
	public static Map<String, Object> resetDevideContainer(DispatchContext ctx, Map<String,Object> context){
		Delegator delegator = ctx.getDelegator();
		Map<String,Object> result = new FastMap<String, Object>();
		String productPlanId =(String)context.get("productPlanId");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		LocalDispatcher dispatcher = ctx.getDispatcher();
		//neu stt # processing thi thuc hien
		
		GenericValue productPlan;
		String sttPlan = "";
		try {
			productPlan = delegator.findOne("ProductPlanHeader", UtilMisc.toMap("productPlanId", productPlanId), false);
			sttPlan = (String)productPlan.get("statusId");
			if(!sttPlan.equals("PLAN_COMPLETED") || !sttPlan.equals("PLAN_PROCESSING") || !sttPlan.equals("PLAN_ORDERED")){
				Map<String, Object> contextPlan = new HashMap<String, Object>();
				contextPlan.put("statusId", "PLAN_CREATED");
				contextPlan.put("productPlanId", productPlanId);
				contextPlan.put("userLogin", userLogin);
				try {
					dispatcher.runSync("updateSttPlanHeader", contextPlan);
				} catch (GenericServiceException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
					return ServiceUtil.returnError(e1.getMessage());
				}
				GenericValue lotIdGe;
				List<GenericValue> listProductPlanAndLot;
				List<GenericValue> listProductPlanAndOrder;
					listProductPlanAndLot = delegator.findList("ProductPlanAndLot", EntityCondition.makeCondition(UtilMisc.toMap("productPlanId", productPlanId)), null, null, null, false);
					for(GenericValue x : listProductPlanAndLot){
						lotIdGe = delegator.findOne("Lot", UtilMisc.toMap("lotId", (String)x.getString("lotId")), false);
						if(lotIdGe != null){
							delegator.removeValue(lotIdGe);
						}
						delegator.removeValue(x);
					}
					listProductPlanAndOrder = delegator.findList("ProductPlanAndOrder", EntityCondition.makeCondition(UtilMisc.toMap("productPlanId", productPlanId)), null, null, null, false);
					if(!UtilValidate.isEmpty(listProductPlanAndOrder)){
						for(GenericValue y : listProductPlanAndOrder){
							GenericValue temp;
							String orderId = (String)y.get("orderId");
							String agreementId = (String)y.get("agreementId");
							Map<String, Object> contextAgree = new HashMap<String, Object>();
							contextAgree.put("agreementId", agreementId);
							contextAgree.put("statusId", "AGREEMENT_CANCELLED");
							contextAgree.put("userLogin", userLogin);
							Map<String,Object> contextTmp = new HashMap<String, Object>();
							contextTmp.put("statusId", "ORDER_CANCELLED");
							contextTmp.put("setItemStatus", "Y");
							contextTmp.put("orderId", orderId);
							contextTmp.put("userLogin", userLogin);
							try {
								dispatcher.runSync("changeOrderStatus", contextTmp);
								dispatcher.runSync("cancelAgreement", contextAgree);
								delegator.removeValue(y);
//								return ServiceUtil.returnSuccess();
							} catch (GenericServiceException e) {
								e.printStackTrace();
								return ServiceUtil.returnError(e.getMessage());
							}
							//xoa productplanAndOrder
							//tim order Id, agreementId
							//cancel order
						}
					}
					
			}else{
				
			}
			
		} catch (GenericEntityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return ServiceUtil.returnError(e1.getMessage());
		}
		return ServiceUtil.returnSuccess();
		
	}
	
}
