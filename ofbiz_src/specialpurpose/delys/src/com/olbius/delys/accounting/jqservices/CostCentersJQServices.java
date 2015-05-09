package com.olbius.delys.accounting.jqservices;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.party.party.PartyWorker;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import com.ibm.icu.math.BigDecimal;

public class CostCentersJQServices {
	public static final String module = CostCentersJQServices.class.getName();
	public static final String resource = "widgetUiLabels";
    public static final String resourceError = "widgetErrorUiLabels";
    public static Map<String, Object> jqListGlAcctgAndAmountPercentage(DispatchContext ctx, Map<String, ? extends Object> context) throws GenericEntityException {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	/*EntityListIterator listIterator = null;*/
    	List<Map<String, Object>> listIterator = FastList.newInstance();
    	List<String> glAccountCategoriesReturn = FastList.newInstance();
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String organizationPartyId = null;
    	String[] organizationPartyIds = parameters.get("organizationPartyId");
    	listAllConditions.add(tmpConditon);
    	List<GenericValue> glAccountOrganizations = FastList.newInstance();
    	
    	if(UtilValidate.isNotEmpty(organizationPartyIds)){
    		 organizationPartyId = organizationPartyIds[0];
    	}
    	List<String> partyIds = PartyWorker.getAssociatedPartyIdsByRelationshipType(delegator, organizationPartyId, "GROUP_ROLLUP");
    	partyIds.add(organizationPartyId);
    	if(UtilValidate.isNotEmpty(partyIds)){
    		EntityCondition glAccountOrgCond = EntityCondition.makeCondition("organizationPartyId", EntityOperator.IN, partyIds);
    		glAccountOrganizations = delegator.findList("GlAccountOrganization", glAccountOrgCond, null, UtilMisc.toList("glAccountId"), null, false);
    		    	
    	}
    	EntityCondition glAccountCategoryCond = EntityCondition.makeCondition("glAccountCategoryTypeId", EntityOperator.EQUALS, "COST_CENTER");
    	
    	List<GenericValue> glAccountCategories = delegator.findList("GlAccountCategory", glAccountCategoryCond, null, UtilMisc.toList("glAccountCategoryId"), null, false);
    	if(UtilValidate.isNotEmpty(organizationPartyIds) && UtilValidate.isNotEmpty(glAccountCategories)){
    		for (GenericValue glAccountOrganization : glAccountOrganizations) {
    			Map<String, Object> glAcctgOrgAndCostCenterMap = new HashMap<String, Object>();
				for (GenericValue glAccountCategory : glAccountCategories) {
					GenericValue organizationParty = delegator.findOne("PartyGroup", UtilMisc.toMap("partyId", glAccountOrganization.get("organizationPartyId")), false);
						
					List<EntityCondition> listAllCondReal = FastList.newInstance();
					listAllCondReal.addAll(listAllConditions);
					listAllCondReal.add(EntityCondition.makeCondition("glAccountId", EntityOperator.EQUALS, glAccountOrganization.getString("glAccountId")));
					listAllCondReal.add(EntityCondition.makeCondition("glAccountCategoryId", EntityOperator.EQUALS, glAccountCategory.getString("glAccountCategoryId")));
					listAllCondReal.add(EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null));
					
					listSortFields.add("fromDate");
					List<GenericValue> glAccountCategoryMembers  = delegator.findList("GlAccountAndGlAccountCategoryMember", EntityCondition.makeCondition(listAllCondReal,EntityJoinOperator.AND), null, listSortFields, opts, false);
					if(UtilValidate.isNotEmpty(glAccountCategoryMembers) && glAccountCategoryMembers.size() > 0){
						GenericValue glAccountCategoryMember = glAccountCategoryMembers.get(0);
//						Map<String, Object> glAcctgOrgAndCostCenterMap = new HashMap<String, Object>();
						
						
						
						if(UtilValidate.isEmpty(glAcctgOrgAndCostCenterMap) && glAcctgOrgAndCostCenterMap.size() == 0){
							glAcctgOrgAndCostCenterMap.put(glAccountCategory.getString("glAccountCategoryId"), glAccountCategoryMember.getBigDecimal("amountPercentage"));
							glAcctgOrgAndCostCenterMap.put("glAccountId", glAccountCategoryMember.getString("glAccountId"));
							glAcctgOrgAndCostCenterMap.put("accountCode", glAccountCategoryMember.getString("accountCode"));
							glAcctgOrgAndCostCenterMap.put("accountName", glAccountCategoryMember.getString("accountName"));
							String organizationValue = organizationParty.getString("groupName") + "[" + glAccountOrganization.getString("organizationPartyId") +"]";
							glAcctgOrgAndCostCenterMap.put("organizationPartyId", glAccountOrganization.getString("organizationPartyId"));
							glAcctgOrgAndCostCenterMap.put("organizationPartyName", organizationValue);
						}else{
							glAcctgOrgAndCostCenterMap.put(glAccountCategory.getString("glAccountCategoryId"), glAccountCategoryMember.getBigDecimal("amountPercentage"));
							listIterator.add(glAcctgOrgAndCostCenterMap);
						}
						
						
					}
					
				}
			}
    	}
    	/*for (GenericValue glAccountCategory : glAccountCategories) {
			String glAccoutCategoryName = glAccountCategory.getString("description");
			glAccountCategoriesReturn.add(glAccoutCategoryName);
		}*/
    	successResult.put("glAccountCategories", glAccountCategories);
    
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
    public static String updateCostCenters(HttpServletRequest request, HttpServletResponse reponse) throws GenericEntityException{
    	Delegator delegator =  (Delegator) request.getAttribute("delegator");
		LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
        String params = request.getParameter("costCenters");
    	JSONArray costCenters = JSONArray.fromObject(params);
    	if(UtilValidate.isNotEmpty(costCenters)){
    		for (int i = 0; i < costCenters.size(); i++) {
				JSONObject costCenter = costCenters.getJSONObject(i);
				if(UtilValidate.isNotEmpty(costCenter)){
					Map<String, Object> costCenterMapService = new HashMap<String, Object>();
					if(UtilValidate.isNotEmpty(costCenter.getString("glAccountId")) && !costCenter.getString("glAccountId").equalsIgnoreCase("null")){
						costCenterMapService.put("glAccountId", costCenter.getString("glAccountId"));
					}else{
						costCenterMapService.put("glAccountId", null);
					}
					Map<String, Object> costCenterMap = new HashMap<String, Object>();
					EntityCondition glAccountCategoryCond = EntityCondition.makeCondition("glAccountCategoryTypeId", EntityOperator.EQUALS, "COST_CENTER");
			    	
			    	List<GenericValue> glAccountCategories = delegator.findList("GlAccountCategory", glAccountCategoryCond, null, UtilMisc.toList("glAccountCategoryId"), null, false);
			    	for (GenericValue glAccountCategory : glAccountCategories) {
						String glAccountCategoryId = glAccountCategory.getString("glAccountCategoryId");
						String percentAmount = costCenter.getString(glAccountCategoryId);
						costCenterMap.put(glAccountCategoryId, percentAmount);
					}
			    	costCenterMapService.put("userLogin", userLogin);
			    	costCenterMapService.put("amountPercentageMap", costCenterMap);
			    	try {
						dispatcher.runSync("createUpdateCostCenter", costCenterMapService);
					} catch (GenericServiceException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			    	
							
				}
				
			}
    	}
    	
        
        
    	return "success";
    }
}
