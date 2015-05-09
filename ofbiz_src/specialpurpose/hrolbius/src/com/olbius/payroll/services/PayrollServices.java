package com.olbius.payroll.services;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TimeZone;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityExpr;
import org.ofbiz.entity.condition.EntityFunction;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.entity.util.EntityUtilProperties;
import org.ofbiz.party.party.PartyHelper;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GeneralServiceException;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceAuthException;
import org.ofbiz.service.ServiceUtil;
import org.ofbiz.service.ServiceValidationException;
import org.ofbiz.service.calendar.RecurrenceRule;

import com.ibm.icu.text.DateFormat;
import com.olbius.accounting.invoice.InvoiceWorker;
import com.olbius.payroll.PayrollDataPreparation;
import com.olbius.payroll.PayrollEngine;
import com.olbius.payroll.PayrollUtil;
import com.olbius.payroll.PeriodEnum;
import com.olbius.payroll.PeriodWorker;
import com.olbius.payroll.entity.EntityEmployeeSalary;
import com.olbius.payroll.entity.EntitySalaryAmount;
import com.olbius.util.CommonUtil;
import com.olbius.util.DateUtil;
import com.olbius.util.Organization;
import com.olbius.util.PartyUtil;

@SuppressWarnings("unchecked")
public class PayrollServices {
	public static final String module = PayrollServices.class.getName();
    public static final String resource = "hrolbiusUiLabels";
    public static final String resourceNoti = "NotificationUiLabels";
    /*
     * Description: Create new parameter
     * */
    public static Map<String, Object> createPayrollParameters(DispatchContext ctx, Map<String, ? extends Object> context) {
    	String strCode = (String)context.get("code");
    	String strName = (String)context.get("name");
    	// Add Period Type
    	String strPeriodTypeId = (String)context.get("periodTypeId");
    	String strDefaultValue = (String)context.get("defaultValue");
    	String strType = (String)context.get("type");
    	String strActualValue = (String)context.get("actualValue");
    	String strPartyId = (String)context.get("partyId");
    	String strDescription = (String)context.get("description");
    	Map<String, Object> result = FastMap.newInstance();
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	try {
    		//check whiteSpace in code
    		if(!CommonUtil.containsValidCharacter(strCode)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CodeContainsInvalidLetters", locale));
    		}
    		GenericValue payrollParam = delegator.findOne("PayrollParameters", UtilMisc.toMap("code", strCode), false);
    		if(payrollParam != null){
    			return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "PayrollParametersHaveExists", UtilMisc.toMap("code", strCode), locale));
    		}
    		
	    	// defaultValue not set will have 0 value
	    	if(strDefaultValue == null || strDefaultValue.isEmpty()){
	    		strDefaultValue = "0";
	    	}
	    	// actualValue not set will have 0 value
	    	if(strActualValue == null || strActualValue.isEmpty()){
	    		strActualValue = "0";
	    	}
	    	GenericValue tempPayrollParameter = delegator.makeValue("PayrollParameters", UtilMisc.toMap("code", strCode, 
	    																								"name", strName,
	    																								"defaultValue", strDefaultValue,
	    																								"type", strType,
	    																								"actualValue", strActualValue,
	    																								"partyId", strPartyId, 
	    																								"description", strDescription,
	    																								"periodTypeId", strPeriodTypeId));
    		tempPayrollParameter.create();
    		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
    		result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "createError", new Object[] { e.getMessage() }, locale));
		}
		return result;
    }
    /*
     * Description: Update parameter
     * */
    public static Map<String, Object> updatePayrollParameters(DispatchContext ctx, Map<String, ? extends Object> context) {
    	String strCode = (String)context.get("code");
    	String strName = (String)context.get("name");
    	// Add Period Type
    	String strPeriodTypeId = (String)context.get("periodTypeId");
    	String strDefaultValue = (String)context.get("defaultValue");
    	String strType = (String)context.get("type");
    	String strActualValue = (String)context.get("actualValue");
    	String strPartyId = (String)context.get("partyId");
    	String strDescription = (String)context.get("description");
    	Map<String, Object> result = FastMap.newInstance();
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	// defaultValue not set will have 0 value
    	if(strDefaultValue == null || strDefaultValue.isEmpty()){
    		strDefaultValue = "0";
    	}
    	// actualValue not set will have 0 value
    	if(strActualValue == null || strActualValue.isEmpty()){
    		strActualValue = "0";
    	}
    	try {
    		if(strPeriodTypeId == null){
    			strPeriodTypeId = "NA";
    		}
    		List<GenericValue> refType = delegator.findList("PayrollEmplParameterType", EntityCondition.makeCondition(EntityCondition.makeCondition("code", "REF"),
    																												EntityOperator.OR,
    																												EntityCondition.makeCondition("parentTypeId", "REF")), null, null, null, false);
    		List<String> refTypeList = EntityUtil.getFieldListFromEntityList(refType, "code", true);
    		GenericValue tempPayrollParameter = delegator.findOne("PayrollParameters", UtilMisc.toMap("code", strCode),false);
    		String type = tempPayrollParameter.getString("type");
    		if(type != null && refTypeList.contains(type)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotUpdateRefParameters", locale));
    		}
    		tempPayrollParameter.put("name", strName);
    		tempPayrollParameter.put("defaultValue", strDefaultValue);
    		tempPayrollParameter.put("type", strType);
    		tempPayrollParameter.put("actualValue", strActualValue);
    		tempPayrollParameter.put("partyId", strPartyId);
    		tempPayrollParameter.put("description", strDescription);
    		tempPayrollParameter.put("periodTypeId", strPeriodTypeId);
    		tempPayrollParameter.store();
    		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
    		result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "updateSuccessfully", locale));
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "updateError", new Object[] { e.getMessage() }, locale));
		}
		return result;
    }
    
    public static Map<String, Object> deletePayrollParameter(DispatchContext dctx, Map<String, Object> context){
    	Locale locale = (Locale)context.get("locale");
    	Delegator delegator = dctx.getDelegator();
    	String code  = (String)context.get("code");
    	try {
			GenericValue payrollParam = delegator.findOne("PayrollParameters", UtilMisc.toMap("code", code), false);
			if(payrollParam == null){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToDelete", locale));
			}
			GenericValue payrollParamAndType = delegator.findOne("PayrollParametersAndType", UtilMisc.toMap("code", code), false);
			if("REF".equals(payrollParamAndType.getString("type")) || "REF".equals(payrollParamAndType.getString("parentTypeId"))){
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotDeletePayrollParam_RefType", locale));
			}
			
			String regEpx = "^"+ code + "[\\+\\-\\*/].*|" + code + "|.*[\\+\\-\\*/]" + code + "$" + "|.*[\\(@#\\+\\-\\*/\"]" + code + "[\\+\\-\\*/#;\\)\"].*";
			List<GenericValue> allFormula = delegator.findByAnd("PayrollFormula", null, null, false);
			boolean cannotUpdate = false;
			GenericValue formulaContainsParam = null;
			for(GenericValue tempGv: allFormula){
				String function = tempGv.getString("function");
				if(function != null){
					for(String operator: CommonUtil.listOperatorPayroll){
						function = function.replaceAll(operator, "#");
					}
					function = function.replaceAll("return", "@");
					function = function.replaceAll(" ", "");
					if(Pattern.matches(regEpx, function)){
						cannotUpdate = true;
						formulaContainsParam = tempGv;
						break;
					}
				}
			}
			if(cannotUpdate){
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotDeletePayrollParam_setFormula",
						UtilMisc.toMap("code", code, "formula", formulaContainsParam.getString("code"), "formulaName", formulaContainsParam.getString("name")), locale));
			}
			List<GenericValue> emplPayrollParam = delegator.findByAnd("PayrollEmplParameters", UtilMisc.toMap("code", code), null, false);
			if(UtilValidate.isNotEmpty(emplPayrollParam)){
				List<String> partyIdList = EntityUtil.getFieldListFromEntityList(emplPayrollParam, "partyId", true);
				StringBuffer buffer = new StringBuffer();
				buffer.append(PartyUtil.getPersonName(delegator, partyIdList.get(0)));
				for(int i = 1; i < partyIdList.size(); i++){
					buffer.append(", ");
					buffer.append(PartyUtil.getPersonName(delegator, partyIdList.get(i)));
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotDeletePayrollParam_emplPayrollParam", UtilMisc.toMap("listEmplParam", buffer.toString()), locale));
			}
			payrollParam.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", locale));
    }
    
    /*
     * Description: Create or update Tax Authority Rate
     * */
    // TODO change method name
    public static Map<String, Object> createTaxAuthorityRate(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	String strTaxAuthorityRateSeqId = (String)context.get("taxAuthorityRateSeqId");
    	String strTaxAuthGeoId = (String)context.get("taxAuthGeoId");
    	String strTaxAuthPartyId = (String)context.get("taxAuthPartyId");
    	String strName = (String)context.get("name");
    	String strFromValue = (String)context.get("fromValue");
    	String strThruValue = (String)context.get("thruValue");
    	String strTaxPercentage = (String)context.get("taxPercentage");
    	Timestamp ttFromDate = (Timestamp)context.get("fromDate");
    	Timestamp ttThruDate = (Timestamp)context.get("thruDate");
    	try {
       	// check update or create
    	GenericValue tempPayrollFormula = delegator.findOne("TaxAuthorityRatePayroll", UtilMisc.toMap("taxAuthorityRateSeqId", strTaxAuthorityRateSeqId),false);
    	if(tempPayrollFormula != null && !tempPayrollFormula.isEmpty()){
    		// update 
    		tempPayrollFormula.put("name", strName);
    		tempPayrollFormula.put("fromValue", strFromValue);
    		tempPayrollFormula.put("thruValue", strThruValue);
    		tempPayrollFormula.put("taxPercentage", strTaxPercentage);
    		tempPayrollFormula.put("fromDate", ttFromDate);
    		tempPayrollFormula.put("thruDate", ttThruDate);
    		tempPayrollFormula.store();
    		result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "updateSuccessfully", locale));
    	}else{
			// create
    		GenericValue tempTaxAuthorityRate = delegator.makeValue("TaxAuthorityRatePayroll", UtilMisc.toMap("taxAuthorityRateSeqId",delegator.getNextSeqId("PayrollTaxAuthority"),
    																							"taxAuthGeoId", strTaxAuthGeoId, 
																								"taxAuthPartyId", strTaxAuthPartyId,
																								"name", strName, 
																								"fromValue", strFromValue, 
																								"thruValue", strThruValue,
																								"taxPercentage", strTaxPercentage,
																								"fromDate", ttFromDate,
																								"thruDate", ttThruDate));
    	
    		tempTaxAuthorityRate.create();
    		result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
    	}
			result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "createError", new Object[] { e.getMessage() }, locale));
		}
    	return result;
    }
    
    public static Map<String, Object> deletePayrollFormula(DispatchContext dctx, Map<String, Object> context){
    	Locale locale = (Locale)context.get("locale");
    	String code = (String)context.get("code");
    	Delegator delegator = dctx.getDelegator();
    	try {
    		GenericValue formula = delegator.findOne("PayrollFormula", UtilMisc.toMap("code", code), false);
    		if(formula == null){
    			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToDelete", locale));
    		}
			List<GenericValue> allFormula = delegator.findList("PayrollFormula", EntityCondition.makeCondition("code", EntityOperator.NOT_EQUAL, code), null, null, null, false);
			String codeFunction = code + "()";
			for(GenericValue tempGv: allFormula){
				String function = tempGv.getString("function");
				if(function != null && function.contains(codeFunction)){
					return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotDeleteCodeExistsInAnotherCode", UtilMisc.toMap("code", code, "codeExists", tempGv.getString("code")), locale));
				}
			}
			List<GenericValue> payrollTableCodes = delegator.findByAnd("PayrollTableCode", UtilMisc.toMap("code", code), null, false);
			if(UtilValidate.isNotEmpty(payrollTableCodes)){
				GenericValue payrollTableCode = payrollTableCodes.get(0);
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotDeleteCodeExistInPayrollTable", UtilMisc.toMap("payrollTableId", payrollTableCode.getString("payrollTableId"), "code", code), locale));
			}
			formula.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", locale));
    }
    
    /*
     * Description: Create new formula
     * */
    public static Map<String, Object> createPayrollFormula(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	String strCode = (String)context.get("code");
    	String strName = (String)context.get("name");
    	//String strInvoiceItemTypeId = (String)context.get("invoiceItemTypeId");
    	String strFunctionJson = (String)context.get("functionJson");
    	String strFunctionType = (String)context.get("functionType");
    	String strMaxValue = (String)context.get("maxValue");
    	String strDescription = (String)context.get("description");
    	String functionRelated = (String)context.get("functionRelated");
    	String strFunction = (String)context.get("function");
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	try {
    		GenericValue checkFormula = delegator.findOne("PayrollFormula", UtilMisc.toMap("code", strCode), false);
    		if(UtilValidate.isNotEmpty(checkFormula)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels.xml", "CodeFormulaIsExists", locale));
    		}
    		if(!CommonUtil.containsValidCharacter(strCode)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CodeContainsInvalidLetters", locale));
    		}
    		if(functionRelated != null){
    			String[] functionRelateArr = functionRelated.split(",");
    			Set<String> functionRelateSet = new HashSet<String>();
    			if(Collections.addAll(functionRelateSet, functionRelateArr)){
    				functionRelated = StringUtils.join(functionRelateSet, ",");
    			}
    		}
	    	String function = "";
	    	if(UtilValidate.isNotEmpty(strFunctionJson)){
	    		JSONObject json = JSONObject.fromObject(strFunctionJson);
	    		String statement = json.getString("statement");
	    		Object conds_true = json.get("if_true");
	    		Object conds_false = json.get("if_false");
	    		function += "if(" + statement + "){";
	    		
	    		if(conds_true != null){
	    			if(conds_true instanceof JSONObject){
	    				function += getReturnValueFromJSON((JSONObject)conds_true);
	    			}	
	    			else{
	        			function += "return \"" + conds_true + "\";";
	        		}
	    		}
	    		function += "}";
	    		function += "else{";
	    		if(conds_false != null){
	    			if(conds_false instanceof JSONObject){
	    				function += getReturnValueFromJSON((JSONObject)conds_false);
	    			}else{
	    				function += "return \"" + conds_false + "\";";
	    			}
	    		}
	    		function += "}";
	    	}else if(UtilValidate.isNotEmpty(strFunction)){
	    		function = strFunction;
	    	}else{
	    		return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels.xml", 
	                    "formulaIsEmptyOrNotValid", locale));
	    	}
    	
    	 	GenericValue tempPayrollFormula = delegator.makeValue("PayrollFormula", UtilMisc.toMap("code", strCode, 
    																						"name", strName,
    																						/*"invoiceItemTypeId", strInvoiceItemTypeId,*/
    																						"function", function, 
    																						"functionType", strFunctionType,
    																						"maxValue", strMaxValue, 
    																						"description", strDescription,
    																						"functionRelated", functionRelated));
    		tempPayrollFormula.create();
			result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
			result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "createError", new Object[] { e.getMessage() }, locale));
		}
		return result;
    }
    
    private static String getReturnValueFromJSON(JSONObject json) {
		// TODO Auto-generated method stub
    	String retVal = "";
    	String statement = json.getString("statement");
		Object conds_true = json.get("if_true");
		Object conds_false = json.get("if_false");
		retVal += "if(" + statement + "){";
		if(conds_true != null){
			if(conds_true instanceof JSONObject){
				retVal += getReturnValueFromJSON((JSONObject)conds_true);
			}else{
				retVal += "return \"" + conds_true + "\";";
			}
		}
		retVal += "}";
		retVal += "else{";
		if(conds_false != null){
			if(conds_false instanceof JSONObject){
				retVal += getReturnValueFromJSON((JSONObject)conds_false);
			}else{
				retVal += "return \"" + conds_false + "\";";
			}
		}
		retVal += "}";
		return retVal;
	}
    
    
	/*
     * Description: Update formula
     * */
    public static Map<String, Object> updatePayrollFormula(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	String strCode = (String)context.get("code");
    	//String strName = (String)context.get("name");
    	//String strInvoiceItemTypeId = (String)context.get("invoiceItemTypeId");
    	//String strFunctionType = (String)context.get("functionType");
    	//String strMaxValue = (String)context.get("maxValue");
    	//String strDescription = (String)context.get("description");
    	String functionRelated = (String)context.get("functionRelated");
    	String strFunctionJson = (String)context.get("functionJson");
    	String strFunction = (String)context.get("function");
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	try {
    		GenericValue tempPayrollFormula = delegator.findOne("PayrollFormula", UtilMisc.toMap("code", strCode),false);
    		if(tempPayrollFormula == null){
    			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToUpdate", locale));
    		}
    		/*tempPayrollFormula.put("name", strName);
    		tempPayrollFormula.put("function", strFunction);
    		tempPayrollFormula.put("functionType", strFunctionType);
    		tempPayrollFormula.put("maxValue", strMaxValue);
    		tempPayrollFormula.put("description", strDescription);*/
    		if(functionRelated != null){
    			String[] functionRelateArr = functionRelated.split(",");
    			Set<String> functionRelateSet = new HashSet<String>();
    			if(Collections.addAll(functionRelateSet, functionRelateArr)){
    				functionRelated = StringUtils.join(functionRelateSet, ",");
    			}
    		}
    		String function = "";
	    	if(UtilValidate.isNotEmpty(strFunctionJson)){
	    		JSONObject json = JSONObject.fromObject(strFunctionJson);
	        	
	    		String statement = json.getString("statement");
	    		Object conds_true = json.get("if_true");
	    		Object conds_false = json.get("if_false");
	    		function += "if(" + statement + "){";
	    		
	    		if(conds_true != null){
	    			if(conds_true instanceof JSONObject){
	    				function += getReturnValueFromJSON((JSONObject)conds_true);
	    			}	
	    			else{
	        			function += "return \"" + conds_true + "\";";
	        		}
	    		}
	    		function += "}";
	    		function += "else{";
	    		if(conds_false != null){
	    			if(conds_false instanceof JSONObject){
	    				function += getReturnValueFromJSON((JSONObject)conds_false);
	    			}else{
	    				function += "return \"" + conds_false + "\";";
	    			}
	    		}
	    		function += "}";
	    	}else if(UtilValidate.isNotEmpty(strFunction)){
	    		function = strFunction;
	    	}else{
	    		return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels.xml", 
	                    "formulaIsEmptyOrNotValid", locale));
	    	}
	    	tempPayrollFormula.setNonPKFields(context);
	    	tempPayrollFormula.set("function", function);
    		tempPayrollFormula.store();
    		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
    		result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "updateSuccessfully", locale));
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "updateError", new Object[] { e.getMessage() }, locale));
		}
		return result;
    }
    
    /*
     * Description: Assign parameter to employee
     * */
    public static Map<String, Object> assignEmployeePayrollParameters(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	String strPartyId = (String)context.get("partyId");
    	String strCode = (String)context.get("code");
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	Timestamp thruDate = (Timestamp)context.get("thruDate");
    	String strValue = (String)context.get("value");
    	String strActualPercent = (String)context.get("actualPercent");
    	//Add period type
    	String strPeriodTypeId = (String)context.get("periodTypeId");
    	String strType = (String)context.get("type");
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale) context.get("locale");
    	try {
    		// Check if exist
    		GenericValue tempEmployeePayrollParameters = delegator.findOne("PayrollEmplParameters", UtilMisc.toMap("partyId",strPartyId,"code", strCode, "fromDate", fromDate),false);
    		if(tempEmployeePayrollParameters != null){
    			tempEmployeePayrollParameters.put("value", strValue);
    			tempEmployeePayrollParameters.put("actualPercent", strActualPercent);
    			tempEmployeePayrollParameters.put("periodTypeId", strPeriodTypeId);
    			tempEmployeePayrollParameters.put("fromDate", fromDate);
    			tempEmployeePayrollParameters.put("thruDate", thruDate);
    			tempEmployeePayrollParameters.put("type", strType);
    			tempEmployeePayrollParameters.store();
    		}else{
    			// get current timestamp
    			Date currDate = new Date();
    			Timestamp currentTimestamp = new Timestamp(currDate.getTime());
    			// if does not exist, create new
    			GenericValue tempEPPs = delegator.makeValue("PayrollEmplParameters", UtilMisc.toMap("code", strCode, 
						"partyId", strPartyId,
						"value", strValue, 
						"actualPercent", strActualPercent,
						"fromDate", fromDate,
						"thruDate", thruDate,
						"inputDate",currentTimestamp,
						"type",strType,
						"periodTypeId", strPeriodTypeId));
    			tempEPPs.create();
    		}
    		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
    		result.put(ModelService.SUCCESS_MESSAGE, 
                    UtilProperties.getMessage(resourceNoti, "updateSuccessfully", locale));
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "updateError", new Object[] { e.getMessage() }, locale));
		}
		return result;
    }
    
    public static Map<String, Object> createEmplPayrollParameters(DispatchContext dctx, Map<String, Object> context){
    	Locale locale = (Locale)context.get("locale");
    	LocalDispatcher dispatcher = dctx.getDispatcher();
    	Delegator delegator = dctx.getDelegator();
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	fromDate = UtilDateTime.getDayStart(fromDate);
    	String partyId = (String)context.get("partyId");
    	Timestamp thruDate = (Timestamp)context.get("thruDate");
    	String periodTypeId = (String)context.get("periodTypeId");
    	
    	if(thruDate != null){
    		thruDate = UtilDateTime.getDayEnd(thruDate);
    	}
    	String code = (String)context.get("code");
    	
    	List<EntityCondition> dateConds = FastList.newInstance();
    	if(thruDate == null){
    		dateConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null),
    													EntityOperator.OR,
    													EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)));
    	}else{
    		if(thruDate.before(fromDate)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
    		}
    		dateConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate)));
    		dateConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
    													EntityOperator.OR,
    													EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)));
    	}
    	EntityCondition conditions = EntityCondition.makeCondition(EntityCondition.makeCondition("partyId", partyId),
    																EntityOperator.AND, 
    																EntityCondition.makeCondition("code", code));
    	EntityCondition allConds = EntityCondition.makeCondition(EntityCondition.makeCondition(dateConds), EntityOperator.AND, conditions);
    	try {
    		GenericValue payrollParameter = delegator.findOne("PayrollParameters", UtilMisc.toMap("code", code), false);
			List<GenericValue> checkEmplPayrollParam = delegator.findList("PayrollEmplParameters", allConds, null, UtilMisc.toList("fromDate"), null, false);
			if(UtilValidate.isNotEmpty(checkEmplPayrollParam)){
				GenericValue entityErr = checkEmplPayrollParam.get(0);
				Timestamp fromDateErr = entityErr.getTimestamp("fromDate");
				Timestamp thruDateErr = entityErr.getTimestamp("thruDate");
				Calendar cal = Calendar.getInstance();
				cal.setTime(fromDateErr);
				String fromDateErrStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				cal.setTime(fromDate);
				String fromDateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateStr = "____";
				if(thruDate != null){
					cal.setTime(thruDate);
					thruDateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				String thruDateErrStr = "____";
				if(thruDateErr != null){
					cal.setTime(thruDateErr);
					thruDateErrStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotAssignParameter", 
																		UtilMisc.toMap("code", payrollParameter.getString("name"), "emplName", PartyUtil.getPersonName(delegator, partyId),
																						"fromDateSet", fromDateStr, "thruDateSet", thruDateStr,
																						"fromDate", fromDateErrStr, "thruDate", thruDateErrStr),locale));
			}
			context.put("fromDate", fromDate);
			context.put("thruDate", thruDate);
			context.put("type", payrollParameter.getString("type"));
			if(periodTypeId == null){
				context.put("periodTypeId", payrollParameter.getString("periodTypeId"));
			}
			dispatcher.runSync("assignEmployeePayrollParameters", context);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			//return ServiceUtil.returnError(e.getLocalizedMessage());
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("WidgetUiLabels", "wgaddsuccess", locale));
    }
    
    public static Map<String, Object> updateEmplPayrollParameters(DispatchContext dctx, Map<String, Object> context){
    	Timestamp thruDate = (Timestamp)context.get("thruDate");
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	String code = (String)context.get("code");
    	String partyId = (String)context.get("partyId");
    	Locale locale = (Locale)context.get("locale");
    	Delegator delegator = dctx.getDelegator();
    	String value = (String)context.get("value");
    	try {
			GenericValue emplPayrollParam = delegator.findOne("PayrollEmplParameters", UtilMisc.toMap("partyId", partyId, "code", code, "fromDate", fromDate), false);
			if(emplPayrollParam == null){
				return ServiceUtil.returnError(UtilProperties.getMessage("CommonUiLabels", "CommonNoRecordFound", locale));
			}
			
			List<EntityCondition> dateConds = FastList.newInstance();
			if(thruDate != null){
				if(thruDate.before(fromDate)){
					return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
				}
				dateConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
				dateConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN, fromDate));
			}else{
				dateConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
																EntityOperator.OR,
															EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, fromDate)));
			}
			EntityCondition conds = EntityCondition.makeCondition(EntityCondition.makeCondition("partyId", partyId), EntityOperator.AND, EntityCondition.makeCondition("code", code));
			conds = EntityCondition.makeCondition(conds, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.NOT_EQUAL, fromDate));
			List<GenericValue> checkEntityNotValid = delegator.findList("PayrollEmplParameters", EntityCondition.makeCondition(conds, EntityOperator.AND, EntityCondition.makeCondition(dateConds)), null, null, null, false);
			if(UtilValidate.isNotEmpty(checkEntityNotValid)){
				GenericValue entityNotValid = checkEntityNotValid.get(0);
				Timestamp fromDateErr = entityNotValid.getTimestamp("fromDate");
				Timestamp thruDateErr = entityNotValid.getTimestamp("thruDate");
				Calendar cal = Calendar.getInstance();
				cal.setTime(fromDateErr);
				String fromDateErrStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				cal.setTime(fromDate);
				String fromDateUpdateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateUpdateStr = "____";
				if(thruDate != null){
					cal.setTime(thruDate);
					thruDateUpdateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				String thruDateErrStr = "____";
				if(thruDateErr != null){
					cal.setTime(thruDateErr);
					thruDateErrStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotUpdatePayrolParamDateInvalid", 
																	UtilMisc.toMap("fromDateUpdate", fromDateUpdateStr, "thruDateUpdate", thruDateUpdateStr,
																					"fromDateError", fromDateErrStr, "thruDateErr", thruDateErrStr), locale));
			}
			if(value == null){
				context.put("value", "0");
			}
			emplPayrollParam.setNonPKFields(context);
			emplPayrollParam.store();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	 
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
    }
    
    public static Map<String, Object> deletePayrollEmplParameters(DispatchContext dctx, Map<String, Object> context){
    	Locale locale = (Locale)context.get("locale");
    	Delegator delegator = dctx.getDelegator();
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	String partyId = (String)context.get("partyId");
    	String code = (String)context.get("code");
    	try {
			GenericValue deleteEmplParam = delegator.findOne("PayrollEmplParameters", UtilMisc.toMap("partyId", partyId, "fromDate", fromDate, "code", code), false);
			if(deleteEmplParam == null){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToDelete", locale));
			}
			deleteEmplParam.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", locale));
    }
    
    public static Map<String, Object> calcPayrollTable(DispatchContext dctx, Map<String, Object> context){
    	LocalDispatcher dispatcher = dctx.getDispatcher();
    	Delegator delegator = dctx.getDelegator();
    	Locale locale = (Locale)context.get("locale");
    	String payrollTableId = (String)context.get("payrollTableId");
    	List<Map<String,Object>> listResult = FastList.newInstance();
    	try {
			GenericValue payrollTableRecord = delegator.findOne("PayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), false);
			if(UtilValidate.isEmpty(payrollTableRecord)){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundPayrollTable", locale));
			}
			String statusId = payrollTableRecord.getString("statusId");
			if(!("PYRLL_TABLE_CREATED".equals(statusId) || "PYRLL_TABLE_CALC".equals(statusId))){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "PayrollTabelHaveCalculated", locale));
			}
			List<GenericValue> formulaList = delegator.findByAnd("PayrollTableCode", UtilMisc.toMap("payrollTableId", payrollTableId), null, false);
			List<GenericValue> departmentList = delegator.findByAnd("PartyPayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), null, false);
			List<String> formulaListStr = EntityUtil.getFieldListFromEntityList(formulaList, "code", true);
			List<String> departmentListStr = EntityUtil.getFieldListFromEntityList(departmentList, "partyId", true);
			Map<String, Object> ctxMap = FastMap.newInstance();
			ctxMap.put("formulaList", formulaListStr);
			ctxMap.put("departmentList", departmentListStr);
			ctxMap.put("fromDate", payrollTableRecord.getTimestamp("fromDate"));
			ctxMap.put("thruDate", payrollTableRecord.getTimestamp("thruDate"));
			ctxMap.put("periodTypeId", payrollTableRecord.getString("periodTypeId"));
			ctxMap.put("userLogin", context.get("userLogin"));
			ctxMap.put("timeZone", context.get("timeZone"));
			ctxMap.put("payrollTableId", payrollTableId);
			Map<String, Object> results = dispatcher.runSync("calcSalaryInPeriod", ctxMap);
			if(ServiceUtil.isSuccess(results)){
				listResult = (List<Map<String,Object>>)results.get("listEmplSalaryInPeriod");
				if("PYRLL_TABLE_CREATED".equals(statusId)){
					payrollTableRecord.set("statusId", "PYRLL_TABLE_CALC");
					payrollTableRecord.store();	
				}
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	Map<String, Object> retMap = FastMap.newInstance();
    	retMap.put("payrollTableId", payrollTableId);
    	retMap.put("listEmplSalaryInPeriod", listResult);
    	return retMap;
    }
    
    public static Map<String, Object> getPayrollTableRecordTimestamp(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	String payrollTableId = (String)context.get("payrollTableId");    	
    	Locale locale = (Locale)context.get("locale");
    	Map<String, Object> retMap = FastMap.newInstance();
    	GenericValue payrollTableRecord;
    	List<Map<String, Timestamp>> listReturn = FastList.newInstance();
    	retMap.put("listTimestamp", listReturn);
		try {
			payrollTableRecord = delegator.findOne("PayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), false);
			if(UtilValidate.isEmpty(payrollTableRecord)){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundPayrollTable", locale));
			}
			String statusId = payrollTableRecord.getString("statusId");
			if(statusId == null || statusId.equals("PYRLL_TABLE_CREATED")){
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "PayrollTableNotCalc", locale));
			}
			EntityFindOptions findOption = new EntityFindOptions();
			findOption.setDistinct(true);
			List<GenericValue> payrollTable = delegator.findList("PayrollTable", EntityCondition.makeCondition("payrollTableId", payrollTableId), UtilMisc.toSet("fromDate"), null, findOption, false);
			List<Timestamp> fromDateList = EntityUtil.getFieldListFromEntityList(payrollTable, "fromDate", true);
			//Timestamp fromDate = fromDateList.get(0);
			//retMap.put("fromDate", fromDate);
			//Map<String, Object> resultSerive = dispatcher.runSync("getPayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", fromDate));
			/*retMap.put("listEntitySalaryAmount", resultSerive.get("listEntitySalaryAmount"));
			retMap.put("formulaList", resultSerive.get("formulaList"));
			retMap.put("thruDate", resultSerive.get("thruDate"));*/
			for(Timestamp tempFromDate : fromDateList){
				Map<String, Timestamp> tempMap = FastMap.newInstance();
				List<GenericValue> tempPayrollTable = delegator.findByAnd("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", tempFromDate), UtilMisc.toList("partyId", "code"), false);
				Timestamp temThruDate = tempPayrollTable.get(0).getTimestamp("thruDate");
				tempMap.put("fromDate", tempFromDate);
				tempMap.put("thruDate", temThruDate);
				listReturn.add(tempMap);
			}
			
			
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
    	return retMap;
    }
    
   /* public static Map<String, Object> getPayrollTableRecord(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	String payrollTableId = (String)context.get("payrollTableId");
    	Locale locale = (Locale)context.get("locale");
    	//Timestamp fromDate = (Timestamp)context.get("fromDate");
    	Map<String, Object> retMap = FastMap.newInstance();    	
    	try {
			GenericValue payrollTableRecord = delegator.findOne("PayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), false);
			if(UtilValidate.isEmpty(payrollTableRecord)){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundPayrollTable", locale));
			}
			String statusId = payrollTableRecord.getString("statusId");
			if(statusId == null || statusId.equals("PYRLL_TABLE_CREATED")){
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "PayrollTableNotCalc", locale));
			}
			EntityFindOptions findOption = new EntityFindOptions();
			findOption.setDistinct(true);
			List<GenericValue> payrollTable = delegator.findList("PayrollTable", EntityCondition.makeCondition("payrollTableId", payrollTableId), UtilMisc.toSet("fromDate"), null, findOption, false);
			List<Map<String,Object>> listEmplSalaryInPeriod = FastList.newInstance();
			List<Timestamp> fromDateList = EntityUtil.getFieldListFromEntityList(payrollTable, "fromDate", true);
			
			for(Timestamp tempFromDate : fromDateList){
				Map<String, Object> tempMap = FastMap.newInstance();
				List<EntityEmployeeSalary> listEntitySalaryAmount = new ArrayList<EntityEmployeeSalary>();
				List<GenericValue> tempPayrollTable = delegator.findByAnd("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", tempFromDate), UtilMisc.toList("partyId", "code"), false);
				List<String> formulaList = EntityUtil.getFieldListFromEntityList(tempPayrollTable, "code", true);
				List<String> partyIdList = EntityUtil.getFieldListFromEntityList(tempPayrollTable, "partyId", true);
				for(String tempPartyId: partyIdList){
					//List<GenericValue> tempPartyPayrollTabel = delegator.findByAnd("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", tempFromDate, "partyId", tempPartyId), null, false);
					EntityEmployeeSalary entityEmployeeSal = new EntityEmployeeSalary();					
					for(String formula: formulaList){
						GenericValue partyPayrollTable = delegator.findOne("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", tempFromDate, "partyId", tempPartyId, "code", formula), false);
						EntitySalaryAmount entitySalaryAmount = new EntitySalaryAmount();
						entitySalaryAmount.setPartyId(partyPayrollTable.getString("partyId"));
						entitySalaryAmount.setAmount(partyPayrollTable.getString("value"));
						entityEmployeeSal.getListSalaryAmount().add(entitySalaryAmount);
					}
					listEntitySalaryAmount.add(entityEmployeeSal);
				}
				retMap.put("fromDate", tempFromDate);
				retMap.put("thruDate", tempPayrollTable.get(0).getTimestamp("thruDate"));
				retMap.put("salaryAmountList", listEntitySalaryAmount);
				retMap.put("formulaList", formulaList);
				listEmplSalaryInPeriod.add(tempMap);
			}
			retMap.put("listEmplSalaryInPeriod", listEmplSalaryInPeriod);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	return retMap;
    }*/
    
    public static Map<String, Object> getPayrollTableRecord(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	List<Map<String, Object>> listReturn = FastList.newInstance();
    	Map<String, Object> retMap = FastMap.newInstance();
    	String payrollTableId = parameters.get("payrollTableId")[0];
    	String formulaList = parameters.get("formulaList")[0];
    	Long fromDateLong = Long.parseLong(parameters.get("fromDate")[0]);
    	Timestamp fromDate = new Timestamp(fromDateLong);
    	retMap.put("listIterator", listReturn);
    	try {
    		int totalRows = 0;
			List<GenericValue> payrollTable = delegator.findByAnd("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", fromDate), UtilMisc.toList("partyId", "code"), false);
			String[] formulaArr = formulaList.split(",SPLITARR,");
						
			List<String> partyList = EntityUtil.getFieldListFromEntityList(payrollTable, "partyId", true);
			int size = Integer.parseInt(parameters.get("pagesize")[0]);
			int page = Integer.parseInt(parameters.get("pagenum")[0]);
			int start = size * page;
			int end = start + size;	
			if(end > partyList.size()){
				end = partyList.size();
			}
			totalRows = partyList.size();
			retMap.put("TotalRows", String.valueOf(totalRows));
			partyList = partyList.subList(start, end);
			GenericValue tempParty;
			for(String partyId: partyList){
				Map<String, Object> tempMap = FastMap.newInstance();
				tempMap.put("partyId", partyId);
				tempParty = delegator.findOne("Person", UtilMisc.toMap("partyId", partyId), false);
				String partyName = "";
				if(tempParty.getString("firstName") != null){
					partyName += tempParty.getString("firstName") + " ";
				}
				if(tempParty.getString("middleName") != null){
					partyName += tempParty.getString("middleName") + " ";
				}
				if(tempParty.getString("lastName") != null){
					partyName += tempParty.getString("lastName");
				}
				tempMap.put("partyName", partyName);
				for(String formula: formulaArr){
					GenericValue tempGv = delegator.findOne("PayrollTable", UtilMisc.toMap("partyId", partyId, "code", formula, "payrollTableId", payrollTableId, "fromDate", fromDate), false);
					String value = tempGv.getString("value");
					tempMap.put(formula, Math.round(Double.parseDouble(value)));
				}
				listReturn.add(tempMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    	return retMap;
    }
    
    public static Map<String, Object> deletePayrollTable(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	Locale locale = (Locale)context.get("locale");
    	String payrollTableId = (String)context.get("payrollTableId");
    	GenericValue payrollTableRecord;
		try {
			payrollTableRecord = delegator.findOne("PayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), false);
			if(UtilValidate.isEmpty(payrollTableRecord)){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundPayrollTable", locale));
			}
			String statusId = payrollTableRecord.getString("statusId");
			if(statusId.equals("PYRLL_TABLE_INVOICED")){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "CannotDeletedPayrollTableHaveInvoiced", locale));
			}
			List<GenericValue> formulaList = delegator.findByAnd("PayrollTableCode", UtilMisc.toMap("payrollTableId", payrollTableId), null, false);
			List<GenericValue> departmentList = delegator.findByAnd("PartyPayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), null, false);
			List<GenericValue> payrollTable = delegator.findByAnd("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId), null, false);
			
			for(GenericValue temp: formulaList){
				temp.remove();
			}
			for(GenericValue temp: departmentList){
				temp.remove();
			}
			for(GenericValue temp: payrollTable){
				temp.remove();
			}
			payrollTableRecord.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", locale));
    }
    
    public static Map<String, Object> updatePayrollTableRecord(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	Locale locale = (Locale)context.get("locale");
    	String payrollTableId = (String)context.get("payrollTableId");
    	GenericValue payrollTableRecord;
		try {
			payrollTableRecord = delegator.findOne("PayrollTableRecord", UtilMisc.toMap("payrollTableId", payrollTableId), false);
			if(UtilValidate.isEmpty(payrollTableRecord)){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundPayrollTable", locale));
			}
			String statusId = payrollTableRecord.getString("statusId");
			if(!statusId.equals("PYRLL_TABLE_CREATED")){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "CannotUpdatePayrollTableHaveCalculated", locale));
			}
			payrollTableRecord.setNonPKFields(context);
			payrollTableRecord.store();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
    }
    
    public static Map<String, Object> calcSalaryInPeriod(DispatchContext dctx, Map<String, Object> context){
    	String periodTypeId = (String)context.get("periodTypeId");
    	LocalDispatcher dispatcher = dctx.getDispatcher();
    	Delegator delegator = dctx.getDelegator();
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	Timestamp thruDate = (Timestamp)context.get("thruDate");
    	TimeZone timeZone = (TimeZone)context.get("timeZone");
    	Locale locale = (Locale)context.get("locale");
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
    	List<String> departmentList = (List<String>)context.get("departmentList");
    	List<GenericValue> emplList = FastList.newInstance();
    	
    	PeriodEnum period = PeriodEnum.NA;
		if("YEARLY".equals(periodTypeId)){
			period = PeriodEnum.YEARLY;
		}else if("QUARTERLY".equals(periodTypeId)){
			period = PeriodEnum.QUARTERLY;
		}else if("MONTHLY".equals(periodTypeId)){
			period = PeriodEnum.MONTHLY;
		}else if("WEEKLY".equals(periodTypeId)){
			period = PeriodEnum.WEEKLY;
		}else if("DAILY".equals(periodTypeId)){
			period = PeriodEnum.DAILY;
		}
		fromDate = UtilDateTime.getDayStart(fromDate);
		thruDate = UtilDateTime.getDayEnd(thruDate);
		Timestamp tmpFromDate = fromDate;
		Timestamp tmpThruDate = null;
		Map<String, Object> resultService = FastMap.newInstance();
		List<Map<String,Object>> listResult = FastList.newInstance();
		try {
			Map<String, Object> ctxMap = ServiceUtil.setServiceFields(dispatcher, "getSalaryAmountList", context, userLogin, timeZone, locale);
			for(String tempId: departmentList){
	    		Organization org = PartyUtil.buildOrg(delegator, tempId);
	    		emplList.addAll(org.getDirectEmployee(delegator));
	    	}
			ctxMap.put("emplList", emplList);
			switch (period) {
				case YEARLY:
					tmpThruDate = UtilDateTime.getYearEnd(tmpFromDate, timeZone, locale);
					if(thruDate.after(tmpThruDate)){
						while(tmpFromDate.before(thruDate)){
							if(tmpThruDate.after(thruDate)){
								ctxMap.put("thruDate", thruDate);
							}else{
								ctxMap.put("thruDate", tmpThruDate);
							}
							ctxMap.put("fromDate", tmpFromDate);
							resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
							if(ServiceUtil.isSuccess(resultService)){
								listResult.add(resultService);
							}
							tmpFromDate = UtilDateTime.getYearStart(tmpFromDate, 0, 1);
							tmpThruDate = UtilDateTime.getYearEnd(tmpFromDate, timeZone, locale);
						}
					}else{
						resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
						if(ServiceUtil.isSuccess(resultService)){
							listResult.add(resultService);
						}
					}
					break;
				case QUARTERLY:
					tmpThruDate = DateUtil.getQuarterEnd(tmpFromDate, locale, timeZone);
					if(thruDate.after(tmpThruDate)){
						while(tmpFromDate.before(thruDate)){
							if(tmpThruDate.after(thruDate)){
								ctxMap.put("thruDate", thruDate);
							}else{
								ctxMap.put("thruDate", tmpThruDate);
							}
							ctxMap.put("fromDate", tmpFromDate);
							resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
							if(ServiceUtil.isSuccess(resultService)){
								listResult.add(resultService);
							}
							tmpFromDate = DateUtil.getQuarterStart(tmpFromDate, locale, timeZone, 1);
							tmpThruDate = DateUtil.getQuarterEnd(tmpFromDate, locale, timeZone);
						}
					}else{
						resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
						if(ServiceUtil.isSuccess(resultService)){
							listResult.add(resultService);
						}
					}
					break;	
				case MONTHLY:
					tmpThruDate = UtilDateTime.getMonthEnd(tmpFromDate, timeZone, locale);
					if(thruDate.after(tmpThruDate)){
						while(tmpFromDate.before(thruDate)){
							if(tmpThruDate.after(thruDate)){
								ctxMap.put("thruDate", thruDate);
							}else{
								ctxMap.put("thruDate", tmpThruDate);
							}
							ctxMap.put("fromDate", tmpFromDate);
							//ctxMap.put("thruDate", tmpThruDate);
							resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
							if(ServiceUtil.isSuccess(resultService)){
								listResult.add(resultService);
							}
							tmpFromDate = UtilDateTime.getMonthStart(tmpFromDate, 0, 1);
							tmpThruDate = UtilDateTime.getMonthEnd(tmpFromDate, timeZone, locale);
						}
					}else{
						resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
						if(ServiceUtil.isSuccess(resultService)){
							listResult.add(resultService);
						}
					}
					break;
				case WEEKLY:
					tmpThruDate = UtilDateTime.getWeekEnd(tmpFromDate, timeZone, locale);
					if(thruDate.after(tmpThruDate)){
						while(tmpFromDate.before(thruDate)){
							if(tmpThruDate.after(thruDate)){
								ctxMap.put("thruDate", thruDate);
							}else{
								ctxMap.put("thruDate", tmpThruDate);
							}
							ctxMap.put("fromDate", tmpFromDate);
							resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
							if(ServiceUtil.isSuccess(resultService)){
								listResult.add(resultService);
							}
							ctxMap.put("fromDate", tmpFromDate);
							tmpFromDate = UtilDateTime.getWeekStart(tmpFromDate, 0, 1);
							tmpThruDate = UtilDateTime.getWeekEnd(tmpFromDate);
						}
					}else{
						resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
						if(ServiceUtil.isSuccess(resultService)){
							listResult.add(resultService);
						}
					}
					break;
				case DAILY:
					tmpThruDate = UtilDateTime.getDayEnd(tmpFromDate, timeZone, locale);
					if(thruDate.after(tmpThruDate)){
						while(tmpFromDate.before(thruDate)){
							if(tmpThruDate.after(thruDate)){
								ctxMap.put("thruDate", thruDate);
							}else{
								ctxMap.put("thruDate", tmpThruDate);
							}
							ctxMap.put("fromDate", tmpFromDate);
							//ctxMap.put("thruDate", tmpThruDate);
							resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
							if(ServiceUtil.isSuccess(resultService)){
								listResult.add(resultService);
							}
							tmpFromDate = UtilDateTime.getDayStart(tmpFromDate, 1);
							tmpThruDate = UtilDateTime.getDayEnd(tmpFromDate);
						}
					}else{
						resultService = dispatcher.runSync("getSalaryAmountList", ctxMap);
						if(ServiceUtil.isSuccess(resultService)){
							listResult.add(resultService);
						}
					}
					break;
				default:
					break;
			}
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, Object> retMap = ServiceUtil.returnSuccess();
		retMap.put("listEmplSalaryInPeriod", listResult);
    	return retMap;
    }
    
    /*
     * Description: calculate and output salary for parties
     * */
    // TODO Cache parameters before calculating!
    public static Map<String, Object> getSalaryAmountList(DispatchContext ctx, Map<String, ? extends Object> context) {
    	Map<String, Object> result = FastMap.newInstance();
    	Delegator delegator = ctx.getDelegator();
    	List<EntityEmployeeSalary> listEntitySalaryAmount = null;
		List<String> listInputFormulas = (List<String>)context.get("formulaList");
    	Timestamp tThruDate = (Timestamp)context.get("thruDate");
    	Timestamp tFromDate = (Timestamp)context.get("fromDate");
    	String periodTypeId = (String)context.get("periodTypeId");
    	//String strEmployeeId = (String)context.get("pdfPartyId");
    	List<GenericValue> emplList = (List<GenericValue>)context.get("emplList");
    	Locale locale = (Locale) context.get("locale");
    	TimeZone timeZone = (TimeZone)context.get("timeZone");
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
    	// first access function
    	if((listInputFormulas == null) || (listInputFormulas.isEmpty())){
    		return ServiceUtil.returnSuccess();
    	}
    	
    	try {
    		//get all Function that related to function in listInputFormulas
    		List<String> formulaRelatedList = FastList.newInstance();
        	for(String formula: listInputFormulas){
        		GenericValue formulaGv = delegator.findOne("PayrollFormula", UtilMisc.toMap("code", formula), false);
        		if(formulaGv == null){
        			Debug.log("code null: " + formula);
        			//System.out.println("code null: " + formula);
        		}
        		String function = formulaGv.getString("function");
        		if(!function.contains("if")){
        			String[] functionArr = function.split("[\\+\\-\\*\\/\\%]");
        			for(String tempFunc: functionArr){
        				tempFunc = tempFunc.trim();
        				if(tempFunc.contains("()")){
        					tempFunc = tempFunc.replace("(","");
            				tempFunc = tempFunc.replace(")",""); 
            				if(!listInputFormulas.contains(tempFunc) && !formulaRelatedList.contains(tempFunc)){
            					formulaRelatedList.add(tempFunc);
            				}
        				}
        			}
        		}
        	}
        	listInputFormulas.addAll(formulaRelatedList);
        	
    		listEntitySalaryAmount = PayrollEngine.getSalaryList(ctx, userLogin, periodTypeId, emplList, listInputFormulas, tFromDate, tThruDate, locale, timeZone);
			result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		} catch (Exception e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "generalError", new Object[] { e.getMessage() }, locale));
		}
    	result.put("salaryAmountList", listEntitySalaryAmount); 
    	result.put("formulaList", listInputFormulas);
    	result.put("fromDate", tFromDate);
    	result.put("thruDate", tThruDate);
    	return result;
    }
    /*
     * Description: raise invoice and payment
     * */    
    public static Map<String, Object> PayrollInvoiceAndPayment(DispatchContext ctx, Map<String, ? extends Object> context) {
    	List<String> listInputs = (List<String>)context.get("formulaCode");
    	Map<String, Object> result = FastMap.newInstance();
    	Locale locale = (Locale) context.get("locale");
    	TimeZone timeZone = (TimeZone)context.get("timeZone");
    	LocalDispatcher dispatcher = ctx.getDispatcher();
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> invoiceMap;
    	String periodTypeId = (String)context.get("periodTypeId");
    	List<EntityEmployeeSalary>  listSalaryAmount = FastList.newInstance();
    	Timestamp tsFromDate = (Timestamp)context.get("fromDate");
    	Timestamp tsThruDate = (Timestamp)context.get("thruDate");
    	Map<String,String> mapFormulaItemType = new HashMap<String,String>();
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
    	// Get salaryAmountList
    	try {
    		EntityExpr entityExpr1 = EntityCondition.makeCondition("invoiceItemTypeId",EntityJoinOperator.NOT_EQUAL, "");
    		List<GenericValue> listFormula = delegator.findList("PayrollFormula", entityExpr1, UtilMisc.toSet("code","invoiceItemTypeId"), null, null, false);
        	for(GenericValue generic:listFormula){
        		mapFormulaItemType.put(generic.get("code").toString(), generic.get("invoiceItemTypeId").toString());
        	}
    		if(listInputs != null && !listInputs.isEmpty()){
//    			for(String str:listInputs){
//    				//listSalaryAmount.add(PayrollEngine.calculateParticipateFunction(ctx, PayrollEngine.buildFormula(ctx,str + "()",tsFromDate,tsThruDate,PayrollUtil.CallBuildFormulaType.NATIVE,"",mapFormulaCache),tsFromDate,tsThruDate,""));
//    			}
    			// TODO implement for input formulas
    			listSalaryAmount = PayrollEngine.getSalaryList(ctx, userLogin, periodTypeId, null, UtilMisc.toList("LUONG"), tsFromDate, tsThruDate, locale, timeZone);
    		}else{
    			listSalaryAmount = PayrollEngine.getSalaryList(ctx, userLogin, periodTypeId, null, UtilMisc.toList("LUONG"), tsFromDate, tsThruDate, locale, timeZone);
    		}
		} catch (Exception e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "generateInvoiceAndPaymentError", new Object[] { e.getMessage() }, locale));
		}
    	if(!listSalaryAmount.isEmpty()){
	    	for(EntityEmployeeSalary salaryEmployeeAmount:listSalaryAmount){
	    		try {
		    		String strEmployeeId = salaryEmployeeAmount.getListSalaryAmount().get(0).getPartyId();
		    		// create invoice assign Internal Organization to Employees 
		    		invoiceMap = FastMap.newInstance();
	    			invoiceMap.put("partyId", "company");
	    			invoiceMap.put("statusId",context.get("statusId"));
	    			invoiceMap.put("currencyUomId",context.get("currencyUomId"));
	    			invoiceMap.put("partyIdFrom",strEmployeeId);
	    			invoiceMap.put("invoiceTypeId","PAYROL_INVOICE");
	    			invoiceMap.put("partyIdFrom",strEmployeeId);
	    			invoiceMap.put("userLogin",context.get("userLogin"));
	    			Map<String, Object> tmpMap = dispatcher.runSync("createInvoice", invoiceMap);
	    			tmpMap.put("userLogin",context.get("userLogin"));
	    			tmpMap.put("description","Payment for payroll in HRMS for user: " + strEmployeeId);
	    			
	    			// TODO move the following code to PayrollEngine
	    		    for (Map.Entry<String, String> entry : salaryEmployeeAmount.getMapFormulaVqalue().entrySet()) {
	    		        String key = entry.getKey();
	    		        String value = entry.getValue();
	    		        if(key.contains("()") && !value.matches(".*[a-zA-Z]+.*")){
	    		        	// FIXME use global configuration 
	    		        	if(key.equals("LUONG_CO_BAN()")){
	    		        		tmpMap.put("amount",value);
	    		        	}else{
	    		        		tmpMap.put("amount","-" + value);
	    		        	}
		    		        if(mapFormulaItemType.containsKey(key.replace("()", ""))){
		    		        	tmpMap.put("invoiceItemTypeId",mapFormulaItemType.get(key.replace("()", "")));
		    		        }else{
		    		        	tmpMap.put("invoiceItemTypeId","PAYROL_SALARY");
		    		        }
			    			//createInvoiceItemPayrol event
			    			dispatcher.runSync("createInvoiceItem", tmpMap);
	    		        }else{
	    		        	EntitySalaryAmount ettTMPResult = PayrollEngine.calculateParticipateFunctionForEmployee(ctx, value,tsFromDate,tsThruDate,strEmployeeId,PeriodWorker.getParameterByPeriod(ctx, periodTypeId, PayrollDataPreparation.getEmployeeParametersCache(ctx, userLogin, strEmployeeId, tsFromDate, tsThruDate, timeZone), tsFromDate, tsThruDate, timeZone, locale));
	    		        	// FIXME use global configuration 
	    		        	if(!key.equals("LUONG()") && !key.equals("LUONG_CO_BAN()")){
	    		        		tmpMap.put("amount","-" + ettTMPResult.getAmount());
	    		        		if(mapFormulaItemType.containsKey(key.replace("()", ""))){
			    		        	tmpMap.put("invoiceItemTypeId",mapFormulaItemType.get(key.replace("()", "")));
			    		        }else{
			    		        	tmpMap.put("invoiceItemTypeId","PAYROL_SALARY");
			    		        }
				    			//createInvoiceItemPayrol event
				    			dispatcher.runSync("createInvoiceItem", tmpMap);
	    		        	}
	    		        }
	    		    }
		    		// Update invoice's state to INVOICE_APPROVED state  
	    			invoiceMap = FastMap.newInstance();
	    			invoiceMap.put("invoiceId",tmpMap.get("invoiceId"));
	    			invoiceMap.put("statusId","INVOICE_READY");
	    			invoiceMap.put("userLogin",context.get("userLogin"));
	    			dispatcher.runSync("setInvoiceStatus", invoiceMap);
	    			// Update invoice's state to INVOICE_PAID state to complete Invoice
//	    			invoiceMap.put("statusId","INVOICE_PAID");
//	    			dispatcher.runSync("setInvoiceStatus", invoiceMap);
//	        		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
//	        		result.put(ModelService.SUCCESS_MESSAGE, 
//	                        UtilProperties.getMessage(resourceNoti, "generateInvoiceAndPaymentSuccessfully", locale));
	    		} catch (Exception e) {
	    			Debug.logError(e, module);
	    			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
	                        "generateInvoiceAndPaymentError", new Object[] { e.getMessage() }, locale));
	    		}
	    	}
    	}
		return result;
    }
    /**
     * Create Invoice for a employee
     * @param ctx
     * @param context
     * @return
     * @throws GenericServiceException 
     * @throws GenericEntityException 
     */
    public static Map<String, Object> createPayrollInvoiceAndPayment(DispatchContext ctx, Map<String, ? extends Object> context) {
    	
    	//Get parameters
    	//Locale locale = (Locale) context.get("locale");
    	LocalDispatcher dispatcher = ctx.getDispatcher();
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> invoiceMap;
    	
    	//FIXME use global configuration 
    	String partyId = (String)context.get("partyId");
    	invoiceMap = FastMap.newInstance();
    	Properties generalProp = UtilProperties.getProperties("general");
    	String partyIdCompany = (String)generalProp.get("ORGANIZATION_PARTY");
    	//String codeFormula = (String) context.get("code");
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	//Timestamp thruDate = (Timestamp) context.get("thruDate");
    	String payrollTableId = (String)context.get("payrollTableId");
		invoiceMap.put("partyId",partyIdCompany);
		invoiceMap.put("statusId","INVOICE_IN_PROCESS");
		invoiceMap.put("currencyUomId", context.get("currencyUomId"));
		invoiceMap.put("partyIdFrom",partyId);
		invoiceMap.put("invoiceTypeId", "PAYROL_INVOICE");
		invoiceMap.put("userLogin",context.get("userLogin"));
		Map<String, Object> tmpMap = null;
		Map<String, Object> retMap = ServiceUtil.returnSuccess();
		
		//Create Invoice for employee		
		try {
			//get all function of code
			//GenericValue payrollFormula = delegator.findOne("PayrollFormula", UtilMisc.toMap("code", codeFormula), false);
			//GenericValue payrollTable =  delegator.findOne("PayrollTable", UtilMisc.toMap("code", codeFormula, "partyId", partyId, "fromDate", fromDate, "thruDate", thruDate), false);
			List<GenericValue> listPayrollFormula = delegator.findByAnd("PayrollTable", UtilMisc.toMap("payrollTableId", payrollTableId, "fromDate", fromDate,"partyId", partyId ,"statusId", "PAYR_APP"), null, false);
			Set<String> codeSetId = FastSet.newInstance();
			
			for(GenericValue payrollFormula: listPayrollFormula){
				String code = payrollFormula.getString("code");
				codeSetId.add(code);
				codeSetId.addAll(PayrollUtil.getAllRelatedFunction(delegator, delegator.findOne("PayrollFormula", UtilMisc.toMap("code", code), false)));
				/*String function = payrollFormula.getString("function");
				String[] functionArr = function.split("[\\+\\-\\*\\/\\%]");
				for(String tempFunc: functionArr){
					if(tempFunc.contains("()")){
						tempFunc = tempFunc.trim();
						tempFunc = tempFunc.replace("(","");
						tempFunc = tempFunc.replace(")","");
						codeSetId.add(tempFunc);
					}
				}*/
			}
			//check whether codeSetId have invoiceItemType, if not return and not create invoice
			GenericValue department = PartyUtil.getDepartmentOfEmployee(delegator, partyId);
    		String departmentId = department.getString("partyIdFrom");
    		List<EntityCondition> partyPayrollInvoiceItemTypeConds = FastList.newInstance();
    		partyPayrollInvoiceItemTypeConds.add(EntityCondition.makeCondition("partyId", departmentId));
    		partyPayrollInvoiceItemTypeConds.add(EntityCondition.makeCondition("code", EntityOperator.IN, codeSetId));
    		partyPayrollInvoiceItemTypeConds.add(EntityUtil.getFilterByDateExpr());
    		List<GenericValue> listInvoiceItemTypeOfCodes = delegator.findList("PartyPayrollFormulaInvoiceItemType", EntityCondition.makeCondition(partyPayrollInvoiceItemTypeConds), null, null, null, false);
    		if(UtilValidate.isNotEmpty(listInvoiceItemTypeOfCodes)){
    			tmpMap = dispatcher.runSync("createInvoice", invoiceMap);					
    			tmpMap.put("userLogin",context.get("userLogin"));
    			retMap.put("invoiceId", tmpMap.get("invoiceId"));	
    			for(String code: codeSetId){
    				//String code = codeGen.getString("code");
    	    		
    	    		GenericValue tempPayrollFormula = delegator.findOne("PayrollFormula", UtilMisc.toMap("code", code), false);
    	    		String desc = tempPayrollFormula.getString("description");
    	    		if(UtilValidate.isEmpty(desc)){
    	    			desc = tempPayrollFormula.getString("name");
    	    		}
    	    		tmpMap.put("description", desc);
    	    		
    	    		//String invoiceItemTypeId = tempPayrollFormula.getString("invoiceItemTypeId");
    	    		List<EntityCondition> conditions = FastList.newInstance();
    	    		conditions.add(EntityUtil.getFilterByDateExpr());
    	    		conditions.add(EntityCondition.makeCondition("partyId", departmentId));
    	    		conditions.add(EntityCondition.makeCondition("code", code));
    	    		List<GenericValue> invoiceItemTypeList = delegator.findList("PartyPayrollFormulaInvoiceItemType", EntityCondition.makeCondition(conditions), null, null, null, false);
    	    		
    	    		//FIXME use global configuration 
    	    		/*if(code.contains("LUONG")){
    	    			tmpMap.put("amount", codeGen.getString("value"));
    	    			
    	    		}else{
    	    			tmpMap.put("amount", "-" + codeGen.getString("value"));
    	    		}*/
    	    		/*tmpMap.put("invoiceItemTypeId","PAYROL_SALARY");*/
    	    		
    	    		//createInvoiceItemPayrol event
    	    		if(UtilValidate.isNotEmpty(invoiceItemTypeList)){
    	    			GenericValue invoiceItemType = EntityUtil.getFirst(invoiceItemTypeList);
    	    			String invoiceItemTypeId = invoiceItemType.getString("invoiceItemTypeId");
    	    			//GenericValue invoiceItemType = delegator.findOne("InvoiceItemType", UtilMisc.toMap("invoiceItemTypeId", invoiceItemTypeId), false);
    	    			//String parentTypeId = invoiceItemType.getString("parentTypeId");
    	    			GenericValue codeGen = delegator.findOne("PayrollTable", 
    	    														UtilMisc.toMap("payrollTableId", payrollTableId, "code", code, "partyId", partyId, "fromDate", fromDate), false);
    	    			//if("PAYROL_EARN_HOURS".equals(parentTypeId)){
    	    			tmpMap.put("amount", codeGen.getString("value"));
    	    			//}else if("PAYROL_TAXES".equals(parentTypeId) || "PAYROL_DD_FROM_GROSS".equals(parentTypeId)){
    	    				//tmpMap.put("amount", "-" + codeGen.getString("value"));
    	    			//}
    	    			tmpMap.put("invoiceItemTypeId", invoiceItemTypeId);
    	    			dispatcher.runSync("createInvoiceItem", tmpMap);
    	    			//Update payroll table's state to PAYR_PAID state
    	    			codeGen.put("statusId", "PAYR_PAID");
    					codeGen.store();
    	    		}
    			}
    		}
			//payrollTable.set("statusId", "PAYR_PAID");
			//payrollTable.store();
			// Update invoice's state to INVOICE_APPROVED state  
			/*invoiceMap = FastMap.newInstance();
			invoiceMap.put("invoiceId", tmpMap.get("invoiceId"));
			invoiceMap.put("statusId", "INVOICE_READY");
			invoiceMap.put("userLogin",context.get("userLogin"));
			dispatcher.runSync("setInvoiceStatus", invoiceMap);*/			
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();						
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
    }
    
    /**
     * 
     */
    public static Map<String, Object> activeSalaryPeriod(DispatchContext ctx, Map<String, ? extends Object> context) {
    	//Get parameters
    	String jobName = (String)context.get("jobName");
    	Long jobFrequency = (Long)context.get("jobFrequency");
    	Timestamp startTime = (Timestamp)context.get("startTime");
    	Timestamp expireTime = (Timestamp)context.get("expireTime");
    	String description = (String)context.get("description");
    	List<String> formulaList = (List<String>)context.get("formulaList");
    	Locale locale = (Locale)context.get("locale");
    	
    	Delegator delegator = ctx.getDelegator();
    	
    	//Insert into PayrollScheduleLog
    	GenericValue payrollScheduleLog = delegator.makeValue("PayrollScheduleLog");
    	payrollScheduleLog.set("jobName", jobName);
    	payrollScheduleLog.set("jobFrequency", jobFrequency);
    	payrollScheduleLog.set("startTime", startTime);
    	//Set first run time equal start time
    	payrollScheduleLog.set("runTime", startTime);
    	payrollScheduleLog.set("expireTime",expireTime);
    	payrollScheduleLog.set("description", description);
    	
    	try {
			payrollScheduleLog.create();
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
    	
    	//Insert into PayrollScheduleFormula
    	for(String formula : formulaList){
    		GenericValue payrollScheduleFormula = delegator.makeValue("PayrollScheduleFormula");
    		payrollScheduleFormula.set("jobName", jobName);
    		payrollScheduleFormula.set("code", formula);
    		try {
    			payrollScheduleFormula.create();
    		} catch (GenericEntityException e) {
    			Debug.log(e.getMessage(), module);
    			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
    		}
    	}
    	
    	//Active Schedule Salary
    	LocalDispatcher localDpc = ctx.getDispatcher();
    	Map<String, Object> scheduleSalaryCtx = UtilMisc.toMap("jobName", jobName,"formulaList", formulaList, "userLogin", (GenericValue)context.get("userLogin"));
    	try {
    		//FIXME Need config global
			localDpc.schedule(jobName, "pool", "perpareSalaryPeriod", scheduleSalaryCtx, startTime.getTime(), jobFrequency.intValue(), 1, -1, expireTime.getTime(), 5);
		} catch (GenericServiceException e) {
			Debug.log(e.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
		}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
    }
    /**
     * 
     *
     */
    //FIXME Context is not exist
    public static Map<String, Object> perpareSalaryPeriod(DispatchContext ctx, Map<String, ? extends Object> context) {
    	
    	Delegator delegator = ctx.getDelegator();
    	
    	//Get parameters
    	String jobName = (String)context.get("jobName");
    	Locale locale = (Locale)context.get("locale");
    	
    	List<GenericValue> payrollScheduleFormulaList = FastList.newInstance();
		try {
			payrollScheduleFormulaList = delegator.findList("PayrollScheduleFormula", EntityCondition.makeCondition("jobName", jobName), null, null, null, false);
		} catch (GenericEntityException e1) {
			Debug.log(e1.getMessage(), module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e1.getMessage()}, locale));
		}
    	
		List<String> formulaList = FastList.newInstance(); 
    	for(GenericValue item: payrollScheduleFormulaList){
    		formulaList.add(item.getString("code"));
    	}
    	
    	GenericValue payrollScheduleLog = null;
    	try {
			payrollScheduleLog = delegator.findOne("PayrollScheduleLog", false, UtilMisc.toMap("jobName", jobName));
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "findError", new Object[]{e.getMessage()}, locale));
		}
    	
    	Timestamp oldRuntime = payrollScheduleLog.getTimestamp("runTime");
    	Timestamp nowRuntime =  new Timestamp(new Date().getTime());
    	
    	payrollScheduleLog.put("runTime", nowRuntime);
    	try {
			payrollScheduleLog.store();
		} catch (GenericEntityException e) {
			Debug.log(e.getMessage(), module);
			ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "updateError", new Object[]{e.getMessage()}, locale));
		}
    	
    	Map<String, Object> result = FastMap.newInstance();
    	result.put("formulaList", formulaList);
    	result.put("fromDate", oldRuntime);
    	result.put("thruDate", nowRuntime);
    	result.put("userLogin", (GenericValue)context.get("userLogin"));
    	result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, 
                UtilProperties.getMessage(resourceNoti, "updateSuccessfully", locale));
		return result;
    }
    
    public static Map<String, Object> logPayrollTable(DispatchContext ctx, Map<String, ? extends Object> context) {
    	
    	Delegator delegator = ctx.getDelegator();
    	
    	//Get parameters
    	List<String> formulaList = (List<String>)context.get("formulaList");
    	List<EntityEmployeeSalary> listEntitySalaryAmount = (List<EntityEmployeeSalary>)context.get("salaryAmountList");
    	Timestamp fromDate = (Timestamp)context.get("fromDate");
    	Timestamp thruDate = (Timestamp)context.get("thruDate");
    	String payrollTableId = (String)context.get("payrollTableId");
    	Locale locale = (Locale) context.get("locale");
    	
    	//List payroll for all Employee in a payroll period
    	for(int i = 0; i < listEntitySalaryAmount.size(); i++){
    		for(int j = 0; j < formulaList.size(); j++){
    			GenericValue payrollTable = delegator.makeValue("PayrollTable");
    			payrollTable.set("payrollTableId", payrollTableId);
    			payrollTable.set("partyId", listEntitySalaryAmount.get(i).getListSalaryAmount().get(0).getPartyId());
    			payrollTable.set("code", formulaList.get(j));
    			payrollTable.set("fromDate", fromDate);
    			payrollTable.set("thruDate", thruDate);
    			payrollTable.set("value", listEntitySalaryAmount.get(i).getListSalaryAmount().get(j).getAmount());
    			payrollTable.set("statusId", "PAYR_APP");
    			try {
    				delegator.createOrStore(payrollTable);
					//payrollTable.create();
				} catch (GenericEntityException e) {
					Debug.log(e.getMessage(), module);
					ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, "createError", new Object[]{e.getMessage()}, locale));
				}
    		}
    	}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
    }
    
    public static Map<String, Object> activeCreatePayrollInvoiceAndPayment(DispatchContext ctx, Map<String, ? extends Object> context) {
    	
    	LocalDispatcher localDispatcher = ctx.getDispatcher();
    	Delegator delegator = ctx.getDelegator();
    	Locale locale = (Locale)context.get("locale");
    	String payrollTableId = (String)context.get("payrollTableId");
    	//Get paid employee
    	EntityCondition condition1 = EntityCondition.makeCondition("statusId", "PAYR_APP");
    	//FIXME code "LUONG" is now hard fix, need use global setting
    	//EntityCondition condition2 = EntityCondition.makeCondition("code", "LUONG");
    	EntityCondition condition2 = EntityCondition.makeCondition("payrollTableId", payrollTableId);
    	List<EntityCondition> conditions = FastList.newInstance();
    	conditions.add(condition1);
    	conditions.add(condition2);
    	List<GenericValue> paidEmployeeList = FastList.newInstance();
    	try {
    		paidEmployeeList = delegator.findList("PayrollTableGroupBy", EntityCondition.makeCondition(conditions, EntityOperator.AND), UtilMisc.toSet("payrollTableId", "partyId", "fromDate", "thruDate"), null, null, false);
		} catch (GenericEntityException e) {
			Debug.logError(e, module);
			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                    "generateInvoiceAndPaymentError", new Object[] { e.getMessage() }, locale));
		}
    	if(UtilValidate.isEmpty(paidEmployeeList)){
    		ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels.xml", "NoEmplCalcPayrollSalary", locale));
    	}
    	for(GenericValue paidEmployee : paidEmployeeList){
    		String partyId = paidEmployee.getString("partyId");
    		Map<String, Object> contextTmp = FastMap.newInstance();
    		contextTmp.put("partyId", partyId);
    		contextTmp.put("userLogin", context.get("userLogin"));
    		contextTmp.put("locale", context.get("locale"));
    		contextTmp.put("currencyUomId", context.get("currencyUomId"));
    		contextTmp.put("fromDate", paidEmployee.getTimestamp("fromDate"));
    		contextTmp.put("thruDate", paidEmployee.getTimestamp("thruDate"));
    		contextTmp.put("payrollTableId", payrollTableId);
    		try {
    			//String code = paidEmployee.getString("code");
    			//if("LUONG".equals(code)){
    				//contextTmp.put("code", code);
    				//localDispatcher.runAsync("createPayrollInvoiceAndPayment", contextTmp);
    				localDispatcher.schedule("pool", "createPayrollInvoiceAndPayment", contextTmp, UtilDateTime.nowTimestamp().getTime(), RecurrenceRule.DAILY, 1, 1, -1, 0);
    			//}
			}catch (ServiceAuthException e) {
				Debug.logError(e, module);
    			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                        "generateInvoiceAndPaymentError", new Object[] { e.getMessage() }, locale));
			} catch (ServiceValidationException e) {
				Debug.logError(e, module);
    			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                        "generateInvoiceAndPaymentError", new Object[] { e.getMessage() }, locale));
			} catch (GenericServiceException e) {
				Debug.logError(e, module);
    			return ServiceUtil.returnError(UtilProperties.getMessage(resourceNoti, 
                        "generateInvoiceAndPaymentError", new Object[] { e.getMessage() }, locale));
			}
    	}
    	return ServiceUtil.returnSuccess(UtilProperties.getMessage(resourceNoti, "generateInvoiceAndPaymentActived", locale));
    }
    
    public static Map<String, Object> createNtfAndEmailPartyPayroll(DispatchContext dctx, Map<String, Object> context){
    	Delegator delegator = dctx.getDelegator();
    	LocalDispatcher dispatcher = dctx.getDispatcher();
    	Timestamp fromDate = (Timestamp) context.get("fromDate");
    	Timestamp thruDate = (Timestamp) context.get("thruDate");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	String invoiceId = (String) context.get("invoiceId");
    	try {
			GenericValue invoiceGv = delegator.findOne("Invoice", UtilMisc.toMap("invoiceId", invoiceId), false);
			String emplPartyId = invoiceGv.getString("partyIdFrom");
			String companyId = invoiceGv.getString("partyId");
			Locale locale = (Locale) context.get("locale");
			Properties generalProp = UtilProperties.getProperties("general");
			String email = generalProp.getProperty("mail.smtp.auth.user");
			String password = generalProp.getProperty("lbqiacdmftrmdiad");
			//TimeZone timeZone = (TimeZone) context.get("timeZone");
			DateFormat df = DateFormat.getDateInstance(DateFormat.SHORT, locale);
			String header = UtilProperties.getMessage("PayrollUiLabels", "HRPayrollInformation", locale);
			String commonFromDate = UtilProperties.getMessage("HrCommonUiLabels", "CommonFromDate", locale);
			String commonThruDate = UtilProperties.getMessage("HrCommonUiLabels", "CommonThruDate", locale);
			Map<String, Object> ntfCtx = FastMap.newInstance();
			ntfCtx.put("header", header + " " + commonFromDate + " " + df.format(new Date(fromDate.getTime())) + " " + commonThruDate + " " + df.format(new Date(thruDate.getTime())));
			ntfCtx.put("partyId", emplPartyId);
			ntfCtx.put("dateTime", UtilDateTime.nowTimestamp());
			ntfCtx.put("state", "open");
			ntfCtx.put("userLogin", context.get("userLogin"));
			ntfCtx.put("ntfType", "ONE");
			ntfCtx.put("targetLink", "partyId=" + emplPartyId + ";fromDate=" + fromDate + ";thruDate=" + thruDate + ";statusId=PAYR_PAID");
			ntfCtx.put("action", "PayrollTablePartyHistory");
			dispatcher.runSync("createNotification", ntfCtx);
			
			//send email to employee
			Map<String, Object> emailAddress = dispatcher.runSync("getPartyEmail", UtilMisc.toMap("partyId", emplPartyId, "userLogin", context.get("userLogin"), "locale",context.get("userLogin") ));
			Map<String, Object> emailCtx = FastMap.newInstance();
			Map<String, Object> bodyParameters = FastMap.newInstance();
			List<GenericValue> emplPosition = PartyUtil.getCurrPositionTypeOfEmpl(delegator, emplPartyId);
			String emplPositionStr = "";
			if(UtilValidate.isNotEmpty(emplPosition)){
				GenericValue emplPos = EntityUtil.getFirst(emplPosition);
				String emplPositionTypeId = emplPos.getString("emplPositionTypeId");
				GenericValue emplPosType = delegator.findOne("EmplPositionType", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId), false);
				if(UtilValidate.isNotEmpty(emplPosType)){
					emplPositionStr = emplPosType.getString("description");
				}
			}			
			bodyParameters.put("companyName", PartyHelper.getPartyName(delegator, companyId, false));
			//bodyParameters.put("companyAddress", ContactMechWorker.getPartyPostalAddresses(request, partyId, curContactMechId));
			//bodyParameters.put("title", "Thông tin lương");
			bodyParameters.put("employeeId", emplPartyId);
			bodyParameters.put("employeeName", PartyHelper.getPartyName(delegator, emplPartyId, false));
			GenericValue dept = PartyUtil.getDepartmentOfEmployee(delegator, emplPartyId);
			
			bodyParameters.put("emplDept", PartyHelper.getPartyName(delegator, dept.getString("partyIdFrom"), false));
			bodyParameters.put("fromDate", fromDate);
			bodyParameters.put("thruDate", thruDate);
			bodyParameters.put("emplPosition", emplPositionStr);
			List<EntityCondition> conditions = FastList.newInstance();
			conditions.add(EntityUtil.getFilterByDateExpr());
			conditions.add(EntityCondition.makeCondition("contactMechTypeId", EntityOperator.EQUALS, "POSTAL_ADDRESS"));
			conditions.add(EntityCondition.makeCondition("contactMechPurposeTypeId", EntityOperator.EQUALS, "PRIMARY_LOCATION"));
			conditions.add(EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, companyId));
			GenericValue companyContactMech = EntityUtil.getFirst(delegator.findList("PartyContactMechPurposeView", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, UtilMisc.toList("-fromDate"), null, false));
			String companyAddressDetails = "";
			if(UtilValidate.isNotEmpty(companyContactMech)){
				GenericValue companyPostallAddr = delegator.findOne("PostalAddress", UtilMisc.toMap("contactMechId", companyContactMech.getString("contactMechId")), false);
				//List<GenericValue> companyAddr = d			
				String companyCountry = delegator.findOne("Geo", UtilMisc.toMap("geoId", companyPostallAddr.getString("countryGeoId")), false).getString("geoName");	
				String companyStateProvince = delegator.findOne("Geo", UtilMisc.toMap("geoId", companyPostallAddr.getString("stateProvinceGeoId")), false).getString("geoName");
				
				GenericValue companyDistrictGeo = delegator.findOne("Geo", UtilMisc.toMap("geoId", companyPostallAddr.getString("districtGeoId")), false);
				String companyDistrictGeoId = "";
				if(UtilValidate.isNotEmpty(companyDistrictGeo)){
					companyDistrictGeoId = companyDistrictGeo.getString("geoName"); 
				}
				GenericValue companyWardGeo = delegator.findOne("Geo", UtilMisc.toMap("geoId", companyPostallAddr.getString("wardGeoId")), false);
				String companyWardGeoId = "";
				if(UtilValidate.isNotEmpty(companyWardGeo)){
					companyWardGeoId = companyWardGeo.getString("geoName");
				}
				companyAddressDetails = companyPostallAddr.getString("address1") + ", " + companyWardGeoId + ", " + companyDistrictGeoId + ", " + companyStateProvince + ", " + companyCountry;
			}else{
				companyAddressDetails = UtilProperties.getMessage("HrCommonUiLabels", "AddressNotExists", locale);
			}
			
			conditions.clear();
			conditions.add(EntityUtil.getFilterByDateExpr());
			conditions.add(EntityCondition.makeCondition("partyId", companyId));
			List<GenericValue> partyTelecomNbr = delegator.findList("PartyAndTelecomNumber", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, UtilMisc.toList("-fromDate"), null, false);
			
			List<EntityCondition> incomeConditions = FastList.newInstance();
			incomeConditions.add(EntityCondition.makeCondition("invoiceId", invoiceId));
			incomeConditions.add(EntityCondition.makeCondition("parentTypeId", EntityOperator.IN, UtilMisc.toList("PAYROL_EARN_HOURS")));
			List<GenericValue> payrollIncomes = delegator.findList("InvoiceItemAndType", EntityCondition.makeCondition(incomeConditions, EntityOperator.AND),null, null, null, false);
			
			List<EntityCondition> deductionConditions = FastList.newInstance();
			deductionConditions.add(EntityCondition.makeCondition("invoiceId", invoiceId));
			deductionConditions.add(EntityCondition.makeCondition("parentTypeId", EntityOperator.IN, UtilMisc.toList("PAYROL_DD_FROM_GROSS", "PAYROL_TAXES")));
			List<GenericValue> payrollDeduction = delegator.findList("InvoiceItemAndType", EntityCondition.makeCondition(deductionConditions, EntityOperator.AND),null, null, null, false);
			
			
			bodyParameters.put("payrollIncomes", payrollIncomes);
			bodyParameters.put("dateJoin", dept.getTimestamp("fromDate"));
			bodyParameters.put("payrollDeductions", payrollDeduction);
			bodyParameters.put("uomId", invoiceGv.getString("currencyUomId"));
			bodyParameters.put("companyAddress", companyAddressDetails);
			bodyParameters.put("phoneNumber", partyTelecomNbr);
			bodyParameters.put("currencyUomId", invoiceGv.get("currencyUomId"));
			bodyParameters.put("actualReceipt", InvoiceWorker.getInvoiceTotal(delegator,invoiceId).multiply(InvoiceWorker.getInvoiceCurrencyConversionRate(delegator,invoiceId)));
			emailCtx.put("userLogin", context.get("userLogin"));
			emailCtx.put("locale", context.get("locale"));
			emailCtx.put("sendTo", emailAddress.get("emailAddress"));//emailAddress.get("emailAddress")
			emailCtx.put("partyIdTo", emplPartyId);
			emailCtx.put("bodyParameters", bodyParameters);
			emailCtx.put("authUser", email);
			emailCtx.put("authPass", password);
			emailCtx.put("sendFrom", email);
			//emailCtx.put("subject", subject);
			emailCtx.put("emailTemplateSettingId", "PARTY_PAYROLL_NOTIFY");
		    Map<String, Object> results = dispatcher.runSync("sendMailFromTemplateSetting", emailCtx);
		    if(ServiceUtil.isError(results)){
		    	ntfCtx.put("partyId", userLogin.getString("partyId"));
		    	ntfCtx.put("header", "Xảy ra lỗi khi gửi email phiếu lương đến " + PartyHelper.getPartyName(delegator, emplPartyId, false));
		    	dispatcher.runSync("createNotification", ntfCtx);
		    }
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
    	return ServiceUtil.returnSuccess();
    }
    
    public static Map<String, Object> notifyErrCreateInvoicePayment(DispatchContext dctx, Map<String, Object> context){
    	LocalDispatcher dispatcher = dctx.getDispatcher();
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
    	Delegator delegator = dctx.getDelegator();
    	String payrollTableId = (String)context.get("payrollTableId");
    	Timestamp fromDate = (Timestamp) context.get("fromDate");
    	Timestamp thruDate = (Timestamp) context.get("thruDate");
    	Calendar calFromDate = Calendar.getInstance();
    	calFromDate.setTime(fromDate);
    	Calendar calThruDate = Calendar.getInstance();
    	calThruDate.setTime(thruDate);
    	String partyId = (String)context.get("partyId");
    	String displayFromDate = calFromDate.get(Calendar.YEAR) + "-" + calFromDate.get(Calendar.MONTH) + "-" + calFromDate.get(Calendar.DATE);
    	String displayThruDate = calThruDate.get(Calendar.YEAR) + "-" + calThruDate.get(Calendar.MONTH) + "-" + calThruDate.get(Calendar.DATE);
    	Map<String, Object> ntfCtx = FastMap.newInstance();
    		
		ntfCtx.put("partyId", userLogin.getString("partyId"));
		ntfCtx.put("header", "Xảy ra lỗi khi tạo hóa đơn tính lương từ ngày " + displayFromDate + "đến ngày " + displayThruDate +" cho " + PartyHelper.getPartyName(delegator, partyId, false));
		ntfCtx.put("dateTime", UtilDateTime.nowTimestamp());
		ntfCtx.put("targetLink", "payrollTableId=" + payrollTableId);
		ntfCtx.put("state", "open");
		ntfCtx.put("ntfType", "ONE");
		ntfCtx.put("action", "ApprovalPayrollTable");
		ntfCtx.put("userLogin", userLogin);
		try {
			dispatcher.runSync("createNotification", ntfCtx);
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ServiceUtil.returnSuccess();
    }
    
	public static Map<String, Object> updatePartyRateAmount(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		TimeZone timeZone = (TimeZone)context.get("timeZone");
		String workEffortId = (String)context.get("workEffortId");
		String rateTypeId = (String)context.get("rateTypeId");
		String rateCurrencyUomId = (String)context.get("rateCurrencyUomId");
		String periodTypeId = (String)context.get("periodTypeId");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		Timestamp effectiveFromDate = (Timestamp)context.get("effectiveFromDate");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String partyId = (String)context.get("partyId");
		
		try {
			//expire current rateAmount of employee
			GenericValue rateAmount = delegator.findOne("RateAmount", UtilMisc.toMap("workEffortId", workEffortId, "rateTypeId", rateTypeId, 
																					"rateCurrencyUomId", rateCurrencyUomId, "periodTypeId", periodTypeId,
																					"fromDate", fromDate,
																					"emplPositionTypeId", emplPositionTypeId,
																					"partyId", partyId), false);
			Timestamp thruDate = UtilDateTime.getDayEnd(effectiveFromDate, -1L);
			rateAmount.set("thruDate", thruDate);
			rateAmount.store();
			context.put("fromDate", UtilDateTime.getDayStart(effectiveFromDate));
			//create new rateAmount employee
			Map<String, Object> ctxMap = ServiceUtil.setServiceFields(dispatcher, "createPartyRateAmount", context, userLogin, timeZone, locale);
			dispatcher.runSync("createPartyRateAmount", ctxMap);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
	}
	
	public static Map<String, Object> createPartyRateAmount(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String workEffortId = (String)context.get("workEffortId");
		String rateTypeId = (String)context.get("rateTypeId");
		Locale locale = (Locale)context.get("locale");
		
		try {
			//create new rateAmount 
			GenericValue rateAmount = delegator.makeValidValue("RateAmount", context);			
			rateAmount.setAllFields(context, false, null, null);
			if(UtilValidate.isEmpty(workEffortId)){
				rateAmount.set("workEffortId", "_NA_");
			}
			if(UtilValidate.isEmail(rateTypeId)){
				rateAmount.set("rateTypeId", "_NA_");
			}
			
			//rateAmount.set("fromDate", fromDate);
			delegator.create(rateAmount);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("CommonUiLabels", "CommonSuccessfullyCreated", locale));
	}
	
	public static Map<String, Object> createPartyRateAmountSalary(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		String fromDateStr = (String)context.get("fromDate");
		String thruDateStr = (String)context.get("thruDate");
		String uomId = (String)context.get("uomId");
		String periodTypeId = (String)context.get("periodTypeId");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String amount = (String)context.get("amount");
		Timestamp fromDate = new Timestamp(Long.parseLong(fromDateStr));
		fromDate = UtilDateTime.getDayStart(fromDate);
		Timestamp thruDate = null;
		Locale locale = (Locale)context.get("locale");
		if(thruDateStr != null){
			thruDate = UtilDateTime.getDayEnd(new Timestamp(Long.parseLong(thruDateStr)));
		}
		if(thruDate != null && fromDate.after(thruDate)){
			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
		}
		BigDecimal amountValue = new BigDecimal(amount);
		List<EntityCondition> conditions  = FastList.newInstance();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		conditions.add(EntityCondition.makeCondition("partyId", partyId));
		conditions.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
		List<EntityCondition> dateConds = FastList.newInstance();
		if(thruDate == null){
    		/*dateConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null),
    													EntityOperator.OR,
    													EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)));*/
			dateConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
    	}else{
    		if(thruDate.before(fromDate)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
    		}
    		EntityCondition condition1 = EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.NOT_EQUAL, null),
										EntityOperator.AND,
										EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
    		condition1 = EntityCondition.makeCondition(condition1, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
    		
    		EntityCondition condition2 = EntityCondition.makeCondition("thruDate", null);
    		condition2 = EntityCondition.makeCondition(condition2, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
    		dateConds.add(EntityCondition.makeCondition(condition1, EntityOperator.OR, condition2));
    		
    	}
		
		try {
			List<GenericValue> rateAmountList = delegator.findList("RateAmount", EntityCondition.makeCondition(EntityCondition.makeCondition(conditions), EntityOperator.AND, EntityCondition.makeCondition(dateConds)), null, UtilMisc.toList("fromDate"), null, false);
			if(UtilValidate.isNotEmpty(rateAmountList)){
				GenericValue rateAmountErr = EntityUtil.getFirst(rateAmountList);
				Timestamp rateAmountFromDate = rateAmountErr.getTimestamp("fromDate");
				Timestamp rateAmountThruDate = rateAmountErr.getTimestamp("thruDate");
				BigDecimal rateAmount = rateAmountErr.getBigDecimal("rateAmount");
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(rateAmountFromDate.getTime());
				String fromDateErr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateErr = null;
				if(rateAmountThruDate != null){
					cal.setTimeInMillis(rateAmountThruDate.getTime());
					thruDateErr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}else{
					thruDateErr = UtilProperties.getMessage("HrCommonUiLabels", "CommonAfterThat", locale);	
				}
				cal.setTimeInMillis(fromDate.getTime());
				String fromDateSub = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateSet = null;
				if(thruDate != null){
					cal.setTimeInMillis(thruDate.getTime());
					thruDateSet = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}else{
					thruDateSet = UtilProperties.getMessage("HrCommonUiLabels", "CommonAfterThat", locale);
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "SalaryInPeriodIsSet",  UtilMisc.toMap("fromDateSet", fromDateSub, "thruDateSet", thruDateSet, 
															"fromDate", fromDateErr, "thruDate", thruDateErr, "amount", rateAmount), locale));
			}
			
			EntityCondition expireConds = EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null), EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, fromDate));
			List<GenericValue> rateAmountExpired = delegator.findList("RateAmount", EntityCondition.makeCondition(EntityCondition.makeCondition(conditions), 
					EntityOperator.AND, 
								expireConds), null, UtilMisc.toList("fromDate"), null, false);
			Timestamp thruDateExpired = UtilDateTime.getDayEnd(fromDate, -1L);
			for(GenericValue tempGv: rateAmountExpired){
				tempGv.set("thruDate", thruDateExpired);
				tempGv.store();
			}
			
			
			dispatcher.runSync("createPartyRateAmount", UtilMisc.toMap("userLogin", userLogin, "partyId", partyId, 
																		"emplPositionTypeId", emplPositionTypeId,
																		"periodTypeId", periodTypeId,
																		"rateCurrencyUomId", uomId,
																		"rateAmount", amountValue,
																		"fromDate", fromDate,
																		"thruDate", thruDate));
		} catch (GenericEntityException e) { 
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
	}
	
	public static Map<String, Object> deletePartyRateAmount(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		String fromDateStr = (String)context.get("fromDate");
		Timestamp fromDate = new Timestamp(Long.parseLong(fromDateStr));
		context.put("fromDate", fromDate);
		GenericValue rateAmount = delegator.makeValidValue("RateAmount", context);
		try {
			rateAmount.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", locale));
	}
	
	public static Map<String, Object> createEmplPositionTypeRateConvertDate(DispatchContext dctx, Map<String, Object> context){
		String fromDateStr = (String)context.get("fromDate");
	    String thruDateStr = (String)context.get("thruDate");
	    LocalDispatcher dispatcher = dctx.getDispatcher();
	    Timestamp fromDate = new Timestamp(Long.parseLong(fromDateStr));
	    Timestamp thruDate = null;
	    if(thruDateStr != null){
	    	thruDate = new Timestamp(Long.parseLong(thruDateStr));
	    }
	    Map<String, Object> map = FastMap.newInstance();
	    map.putAll(context);
	    map.put("fromDate", fromDate);
	    map.put("thruDate", thruDate);
	    Map<String, Object> retMap = FastMap.newInstance();
	    try {
			retMap = dispatcher.runSync("createEmplPositionTypeRateAmount", map);
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return retMap;
	}
	
	public static Map<String, Object> createEmplPositionTypeRateAmount(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		//String fromDateStr = (String)context.get("fromDate");
		//String thruDateStr = (String)context.get("thruDate");
		String uomId = (String)context.get("uomId");
		String periodTypeId = (String)context.get("periodTypeId");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String amount = (String)context.get("rateAmount");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		fromDate = UtilDateTime.getDayStart(fromDate);
		Timestamp thruDate = (Timestamp)context.get("thruDate");
		Locale locale = (Locale)context.get("locale");
		if(thruDate!= null){
			thruDate = UtilDateTime.getDayEnd(thruDate);
		}
		if(thruDate != null && fromDate.after(thruDate)){
			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
		}
		BigDecimal amountValue = new BigDecimal(amount);
		List<EntityCondition> conditions  = FastList.newInstance();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		if(uomId == null){
			uomId = EntityUtilProperties.getPropertyValue("general.properties", "currency.uom.id.default", "USD", delegator);
		}
		conditions.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
		List<EntityCondition> dateConds = FastList.newInstance();
		if(thruDate == null){
    		/*dateConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.EQUALS, null),
    													EntityOperator.OR,
    													EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate)));*/
			dateConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
    	}else{
    		if(thruDate.before(fromDate)){
    			return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
    		}
    		EntityCondition condition1 = EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", EntityOperator.NOT_EQUAL, null),
					EntityOperator.AND,
					EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
			condition1 = EntityCondition.makeCondition(condition1, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
			
			EntityCondition condition2 = EntityCondition.makeCondition("thruDate", null);
			condition2 = EntityCondition.makeCondition(condition2, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
			dateConds.add(EntityCondition.makeCondition(condition1, EntityOperator.OR, condition2));
    	}
		List<GenericValue> emplPositionTypeRateList;
		try {
			emplPositionTypeRateList = delegator.findList("OldEmplPositionTypeRate", EntityCondition.makeCondition(EntityCondition.makeCondition(conditions), EntityOperator.AND, EntityCondition.makeCondition(dateConds)), null, UtilMisc.toList("fromDate"), null, false);
		
			if(UtilValidate.isNotEmpty(emplPositionTypeRateList)){
				GenericValue emplPosTypeRateErr = EntityUtil.getFirst(emplPositionTypeRateList);
				Timestamp emplPosTypeRateFromDate = emplPosTypeRateErr.getTimestamp("fromDate");
				Timestamp emplPosTypeRateThruDate = emplPosTypeRateErr.getTimestamp("thruDate");
				BigDecimal rateAmount = emplPosTypeRateErr.getBigDecimal("rateAmount");
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(emplPosTypeRateFromDate.getTime());
				String fromDateErr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateErr = null;
				if(emplPosTypeRateThruDate != null){
					cal.setTimeInMillis(emplPosTypeRateThruDate.getTime());
					thruDateErr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}else{
					thruDateErr = UtilProperties.getMessage("HrCommonUiLabels", "CommonAfterThat", locale);	
				}
				cal.setTimeInMillis(fromDate.getTime());
				String fromDateSub = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateSet = null;
				if(thruDate != null){
					cal.setTimeInMillis(thruDate.getTime());
					thruDateSet = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}else{
					thruDateSet = UtilProperties.getMessage("HrCommonUiLabels", "CommonAfterThat", locale);
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "SalaryInPeriodIsSet",  UtilMisc.toMap("fromDateSet", fromDateSub, "thruDateSet", thruDateSet, 
															"fromDate", fromDateErr, "thruDate", thruDateErr, "amount", rateAmount), locale));
			}
			EntityCondition expireConds = EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null), EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, fromDate));
			List<GenericValue> emplPosTypeRateExpired = delegator.findList("OldEmplPositionTypeRate", EntityCondition.makeCondition(EntityCondition.makeCondition(conditions), 
																			EntityOperator.AND, 
																			expireConds), null, UtilMisc.toList("fromDate"), null, false);
			Timestamp thruDateExpired = UtilDateTime.getDayEnd(fromDate, -1L);
			for(GenericValue tempGv: emplPosTypeRateExpired){
				tempGv.set("thruDate", thruDateExpired);
				tempGv.store();
			}
			
			dispatcher.runSync("createEmpPosTypeSalary",  UtilMisc.toMap("userLogin", userLogin, 
																		"emplPositionTypeId", emplPositionTypeId,
																		"periodTypeId", periodTypeId,
																		"rateCurrencyUomId", uomId,
																		"rateAmount", amountValue,
																		"fromDate", fromDate,
																		"thruDate", thruDate));
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, Object> retMap = ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
		retMap.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
		return retMap; 
	}
	
	public static Map<String, Object> getEmplPostionTypeNotSetSalary(DispatchContext dctx, Map<String, Object> context){
		Map<String, Object> retMap = FastMap.newInstance();
		Delegator delegator = dctx.getDelegator();
		List<Map<String, Object>> listReturn = FastList.newInstance();
		retMap.put("listEmplPositionTypeNotSet", listReturn);
		try {
			
			List<GenericValue> listEmplPosTypeSet = delegator.findList("OldEmplPositionTypeRate", EntityUtil.getFilterByDateExpr(), null, UtilMisc.toList("emplPositionTypeId"), null, false);
			//GenericValue tempPosType;
			List<GenericValue> emplPositionTypeList = FastList.newInstance();
			if(UtilValidate.isNotEmpty(listEmplPosTypeSet)){
				List<String> emplPositionTypes = EntityUtil.getFieldListFromEntityList(listEmplPosTypeSet, "emplPositionTypeId", true);
				emplPositionTypeList = delegator.findList("EmplPositionType", EntityCondition.makeCondition(EntityCondition.makeCondition("emplPositionTypeId", EntityOperator.NOT_IN, emplPositionTypes),
																											EntityOperator.AND,
																											EntityCondition.makeCondition("emplPositionTypeId", EntityOperator.NOT_EQUAL, "_NA_")),
																											null, UtilMisc.toList("emplPositionTypeId"), null, false);
			}else{
				emplPositionTypeList = delegator.findList("EmplPositionType", EntityCondition.makeCondition("emplPositionTypeId", EntityOperator.NOT_EQUAL, "_NA_"), null, UtilMisc.toList("emplPositionTypeId"), null, false);
			}
			
			for(GenericValue tempGv: emplPositionTypeList){
				Map<String, Object> tempMap = FastMap.newInstance();
				String emplPositionTypeId = tempGv.getString("emplPositionTypeId");
				tempMap.put("emplPositionTypeId", emplPositionTypeId);				
				tempMap.put("description", tempGv.getString("description"));				
				listReturn.add(tempMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> createEmpPosTypeSalary(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String periodTypeId = (String)context.get("periodTypeId");
		Locale locale = (Locale)context.get("locale");
		if(fromDate == null){
			fromDate = UtilDateTime.getDayStart(UtilDateTime.nowTimestamp());
		}
		try {
			GenericValue checkedEntity = delegator.findOne("OldEmplPositionTypeRate", UtilMisc.toMap("fromDate", fromDate, "periodTypeId", periodTypeId, "emplPositionTypeId", emplPositionTypeId), false);
			if(checkedEntity != null){
				GenericValue emplPosType = delegator.findOne("EmplPositionTypeId", UtilMisc.toMap("emplPositionTypeId", checkedEntity.getString("emplPositionTypeId")), false);
				Calendar cal = Calendar.getInstance();
				cal.setTime(checkedEntity.getTimestamp("fromDate"));
				String fromDateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateStr = "___";
				if(checkedEntity.getTimestamp("thruDate") != null){
					cal.setTime(checkedEntity.getTimestamp("thruDate"));
					thruDateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "EmplPositionTypeRateIsSet", UtilMisc.toMap("emplPositionType", emplPosType.getString("description"), 
																																		"fromDate", fromDateStr, "thruDate", thruDateStr), locale));
			}
			GenericValue newEntity = delegator.makeValidValue("OldEmplPositionTypeRate", context);
			newEntity.set("fromDate", fromDate);
			newEntity.create();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess();
	}
	
	/*public static Map<String, Object> createEmpPosTypeSalary(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		try {
			//check whether emplPositionType have setting
			List<GenericValue> checkEmplPosTypeRate = delegator.findList("OldEmplPositionTypeRate", EntityCondition.makeCondition(
																										EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr(),
																											EntityOperator.AND,
																											EntityCondition.makeCondition("emplPositionTypeId",emplPositionTypeId))), 
																			null, null, null, false);
			if(UtilValidate.isNotEmpty(checkEmplPosTypeRate)){
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "EmplPosTypeRateIsSet", locale));
			}
			//create new entity
			GenericValue emplPosTypeRate = delegator.makeValidValue("OldEmplPositionTypeRate", context);
			if(fromDate == null){
				fromDate = UtilDateTime.getDayStart(UtilDateTime.nowTimestamp());
			}
			emplPosTypeRate.set("fromDate", fromDate);
			emplPosTypeRate.create();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("CommonUiLabels", "CommonSuccessfullyCreated", locale));
	}*/
	public static Map<String, Object> updateEmpPosTypeSalary(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();	
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String periodTypeId = (String) context.get("periodTypeId");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		Timestamp thruDate = (Timestamp)context.get("thruDate");
		Locale locale = (Locale)context.get("locale");
		try {
			List<EntityCondition> commonConds = FastList.newInstance();
			commonConds.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
			commonConds.add(EntityCondition.makeCondition("periodTypeId", periodTypeId));
			commonConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.NOT_EQUAL, fromDate));
			EntityCondition dateConds;
			if(thruDate != null){
				if(thruDate.before(fromDate)){
					return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "DateEnterNotValid", locale));
				}
				dateConds = EntityCondition.makeCondition(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN, fromDate), 
							EntityOperator.AND, 
							EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
			}else{
				dateConds = EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
															EntityOperator.OR,
														EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, fromDate));
			}
			EntityCondition conds = EntityCondition.makeCondition(EntityCondition.makeCondition(commonConds), EntityOperator.AND, dateConds); 
			List<GenericValue> checkEntityNotValid = delegator.findList("OldEmplPositionTypeRate", EntityCondition.makeCondition(conds, EntityOperator.AND, EntityCondition.makeCondition(dateConds)), null, null, null, false);
			if(UtilValidate.isNotEmpty(checkEntityNotValid)){
				GenericValue entityNotValid = checkEntityNotValid.get(0);
				Timestamp fromDateErr = entityNotValid.getTimestamp("fromDate");
				Timestamp thruDateErr = entityNotValid.getTimestamp("thruDate");
				Calendar cal = Calendar.getInstance();
				cal.setTime(fromDateErr);
				String fromDateErrStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				cal.setTime(fromDate);
				String fromDateUpdateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				String thruDateUpdateStr = "____";
				if(thruDate != null){
					cal.setTime(thruDate);
					thruDateUpdateStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				String thruDateErrStr = "____";
				if(thruDateErr != null){
					cal.setTime(thruDateErr);
					thruDateErrStr = cal.get(Calendar.DATE) + "/" + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR);
				}
				return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "CannotUpdatePayrolParamDateInvalid", 
																	UtilMisc.toMap("fromDateUpdate", fromDateUpdateStr, "thruDateUpdate", thruDateUpdateStr,
																					"fromDateError", fromDateErrStr, "thruDateErr", thruDateErrStr), locale));
			}
			GenericValue emplPosTypeRate = delegator.findOne("OldEmplPositionTypeRate", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "periodTypeId", periodTypeId, "fromDate", fromDate), false);
			if(UtilValidate.isEmpty(emplPosTypeRate)){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToUpdate", locale));
			}
			emplPosTypeRate.setNonPKFields(context);
			if(thruDate != null){
				thruDate = UtilDateTime.getDayEnd(thruDate);
				emplPosTypeRate.set("thruDate", thruDate);
			}
			emplPosTypeRate.store();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
	}
	
	
	
	public static Map<String, Object> deleteEmpPosTypeSalary(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String periodTypeId = (String) context.get("periodTypeId");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		Locale locale = (Locale)context.get("locale");
		try {
			GenericValue emplPosTypeRate = delegator.findOne("OldEmplPositionTypeRate", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId, "periodTypeId", periodTypeId, "fromDate", fromDate), false);
			if(UtilValidate.isEmpty(emplPosTypeRate)){
				ServiceUtil.returnError(UtilProperties.getMessage("hrCommonUiLabels", "NotFoundRecordToDelete", locale));
			}
			/*emplPosTypeRate.set("thruDate", UtilDateTime.nowTimestamp());*/
			emplPosTypeRate.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", locale));
	}
	
	public static Map<String, Object> getSalaryAmountEmpl(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityUtil.getFilterByDateExpr());
		conditions.add(EntityCondition.makeCondition("partyId", partyId));
		//add conditions about emplPositionType
		Map<String, Object> retMap = FastMap.newInstance();
		try {
			List<GenericValue> emplPos = PartyUtil.getCurrPositionTypeOfEmpl(delegator, partyId);
			List<String> emplPositionTypes = EntityUtil.getFieldListFromEntityList(emplPos, "emplPositionTypeId", true);
			if(UtilValidate.isNotEmpty(emplPositionTypes)){
				conditions.add(EntityCondition.makeCondition("emplPositionTypeId", EntityOperator.IN, emplPositionTypes));
			}
			List<GenericValue> rateAmountList = delegator.findList("RateAmount", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, UtilMisc.toList("fromDate"), null, false);
			//check whether employee have set specific payroll, if not get payroll info base on emplPositionType
			//retMap.put("rateAmountList", rateAmountList);
			if(UtilValidate.isNotEmpty(rateAmountList)){
				GenericValue rateAmount = EntityUtil.getFirst(rateAmountList);
				retMap.put("workEffortId", rateAmount.getString("workEffortId")); 
				retMap.put("rateTypeId", rateAmount.getString("rateTypeId")); 
				retMap.put("rateCurrencyUomId", rateAmount.getString("rateCurrencyUomId"));
				retMap.put("periodTypeId", rateAmount.getString("periodTypeId"));
				retMap.put("fromDate", rateAmount.getTimestamp("fromDate"));
				retMap.put("thruDate", rateAmount.getTimestamp("thruDate"));
				retMap.put("rateAmount", rateAmount.getBigDecimal("rateAmount"));
				retMap.put("emplPositionTypeId", rateAmount.getString("emplPositionTypeId"));
			}else{				
				
				BigDecimal tempAmount = BigDecimal.ZERO;
				List<GenericValue> emplPosTypeRate;
				for(GenericValue tempPosType: emplPos){
					emplPosTypeRate = delegator.findList("OldEmplPositionTypeRate", EntityCondition.makeCondition(
																						EntityCondition.makeCondition("emplPositionTypeId", tempPosType.getString("emplPositionTypeId")),
																						EntityOperator.AND,
																						EntityUtil.getFilterByDateExpr()), null, null, null, false);
					if(UtilValidate.isNotEmpty(emplPosTypeRate)){
						GenericValue posTypeRate = EntityUtil.getFirst(emplPosTypeRate);
						BigDecimal tempRateAmount = posTypeRate.getBigDecimal("rateAmount");
						//TODO need convert value of rateAmount by period type to compare
						if(tempRateAmount.compareTo(tempAmount) > 0){
							retMap.put("emplPositionTypeId", posTypeRate.getString("emplPositionTypeId"));
							retMap.put("rateAmount", posTypeRate.getBigDecimal("rateAmount"));
							retMap.put("fromDate", posTypeRate.getTimestamp("fromDate"));
							retMap.put("periodTypeId", posTypeRate.getString("periodTypeId"));
							retMap.put("rateCurrencyUomId", posTypeRate.getString("rateCurrencyUomId"));
						}
					}else{
						retMap.put("emplPositionTypeId", tempPosType.getString("emplPositionTypeId"));
					}
				}
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> getListEmplSalaryBaseFlat(DispatchContext dctx, Map<String, Object> context){
		//HttpServletRequest request = (HttpServletRequest)context.get("request");
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		//Locale locale = (Locale)context.get("locale");
		//TimeZone timeZone = UtilHttp.getTimeZone(request);
		Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	List<Map<String, Object>> listReturn = FastList.newInstance();
    	GenericValue userLogin = (GenericValue)context.get("userLogin");
    	HttpServletRequest request = (HttpServletRequest)context.get("request");
    	String partyIdGroupId = request.getParameter("partyGroupId");
    	int totalRows = 0;
    	int size = Integer.parseInt(parameters.get("pagesize")[0]);
		int page = Integer.parseInt(parameters.get("pagenum")[0]);
		int start = size * page;
		int end = start + size;
		String partyIdParam = (String[])parameters.get("partyId") != null? ((String[])parameters.get("partyId"))[0] : null;
    	String partyNameParam = (String[])parameters.get("partyName") != null? ((String[])parameters.get("partyName"))[0]: null;
    	List<GenericValue> emplList;
    	Map<String, Object> retMap = FastMap.newInstance();
    	try {
	    	if(partyIdGroupId == null){
	    		emplList = PartyUtil.getEmployeeInOrg(delegator); 
	    	}else{
	    		Organization orgParty = PartyUtil.buildOrg(delegator, partyIdGroupId);
				emplList = orgParty.getEmployeeInOrg(delegator);
	    	}
			 
			if(partyIdParam != null){
				emplList = EntityUtil.filterByCondition(emplList, EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("partyId"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyIdParam + "%")));
			}
			if(partyNameParam != null){
				partyNameParam = partyNameParam.replaceAll("\\s", "");
				List<EntityCondition> tempConds = FastList.newInstance();
				tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("fullNameFirstNameFirst"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam.toUpperCase() + "%")));
				tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("fullNameLastNameFirst"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam .toUpperCase() + "%")));
				tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("lastNameFirstName"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam .toUpperCase() + "%")));
				tempConds.add(EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("firstNameLastName"), EntityOperator.LIKE, EntityFunction.UPPER("%" + partyNameParam .toUpperCase() + "%")));
				emplList = EntityUtil.filterByOr(emplList, tempConds);			
			}
			if(end > emplList.size()){
				end = emplList.size();
			}
			totalRows = emplList.size();
			emplList = emplList.subList(start, end);
			retMap.put("listIterator", listReturn);
			retMap.put("TotalRows", String.valueOf(totalRows));
		
			for(GenericValue tempGv: emplList){
				Map<String, Object> tempMap = FastMap.newInstance();
				String tempPartyId = tempGv.getString("partyId");
				tempMap = dispatcher.runSync("getSalaryAmountEmpl", UtilMisc.toMap("partyId", tempPartyId, "userLogin", userLogin));
				tempMap.remove("rateAmountList");
				//List<Map<String, Object>> rowDetails = FastList.newInstance();
				//tempMap.put("rowDetail", rowDetails);
				
				List<GenericValue> emplPos = PartyUtil.getCurrPositionTypeOfEmpl(delegator, tempPartyId);
				List<String> emplPosStr = EntityUtil.getFieldListFromEntityList(emplPos, "emplPositionTypeId", true);
				tempMap.put("partyId", tempPartyId);
				tempMap.put("partyName", PartyUtil.getPersonName(delegator, tempPartyId));
				tempMap.put("allEmplPositionTypeId", emplPosStr);
				if(UtilValidate.isNotEmpty(emplPos)){
					tempMap.put("emplPositionTypeId", emplPos.get(0).getString("emplPositionTypeId"));
				}
				GenericValue currDept = PartyUtil.getDepartmentOfEmployee(delegator, tempPartyId);
				if(currDept != null){
					tempMap.put("currDept", PartyHelper.getPartyName(delegator, currDept.getString("partyIdFrom"), false));
				}
				listReturn.add(tempMap);
			}
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ServiceUtil.returnError(e.getMessage());
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return retMap;
	}
	
	public static Map<String, Object> getListEmplPayrollParameters(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	List<Map<String, Object>> listReturn = FastList.newInstance();
    	//GenericValue userLogin = (GenericValue)context.get("userLogin");
    	//HttpServletRequest request = (HttpServletRequest)context.get("request");
    	String currDeptId = parameters.get("currDept") != null? parameters.get("currDept")[0]: null;
    	int totalRows = 0;
    	int size = Integer.parseInt(parameters.get("pagesize")[0]);
		int page = Integer.parseInt(parameters.get("pagenum")[0]);
		int start = size * page;
		int end = start + size;
		List<GenericValue> emplList = FastList.newInstance();
		//String[] emplPositionTypeId = parameters.get("emplPositionTypeId");
		Map<String, Object> retMap = FastMap.newInstance();
		try {
			if(currDeptId != null){
				emplList = PartyUtil.buildOrg(delegator, currDeptId).getEmployeeInOrg(delegator);
			}else{
				emplList = PartyUtil.getEmployeeInOrg(delegator);
			}
			
			if(end > emplList.size()){
				end = emplList.size();
			}
			totalRows = emplList.size();
			emplList = emplList.subList(start, end);
			retMap.put("listIterator", listReturn);
			retMap.put("TotalRows", String.valueOf(totalRows));
		
			for(GenericValue tmpGv: emplList){
				Map<String, Object> tempMap = FastMap.newInstance();
				listReturn.add(tempMap);
				String tempPartyId = tmpGv.getString("partyId");
				List<GenericValue> emplPayrollParameters = delegator.findList("PayrollEmplParameters", EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr(), EntityOperator.AND, EntityCondition.makeCondition("partyId", tempPartyId)), null, null, null, false);
				List<GenericValue> emplPos = PartyUtil.getCurrPositionTypeOfEmpl(delegator, tempPartyId);
				tempMap.put("partyId", tempPartyId);
				GenericValue tempParty = delegator.findOne("Person", UtilMisc.toMap("partyId", tempPartyId), false);
				StringBuffer emplName = new StringBuffer();
				if(tempParty.getString("firstName") != null){
					emplName.append(tempParty.getString("firstName"));
				}
				if(tempParty.getString("middleName") != null){
					emplName.append(" ");
					emplName.append(tempParty.getString("middleName"));
				}
				if(tempParty.getString("lastName") != null){
					emplName.append(" ");
					emplName.append(tempParty.getString("lastName"));
				}
				tempMap.put("emplName", emplName.toString());
				if(UtilValidate.isNotEmpty(emplPos)){
					tempMap.put("emplPositionTypeId", emplPos.get(0).getString("emplPositionTypeId"));
				}
				GenericValue currDept = PartyUtil.getDepartmentOfEmployee(delegator, tempPartyId);
				if(currDept != null){
					tempMap.put("currDept", PartyHelper.getPartyName(delegator, currDept.getString("partyIdFrom"), false));
				}	
				tempMap.put("totalParameters", emplPayrollParameters.size());
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> getListParameterEmpl(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts = (EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	HttpServletRequest request = (HttpServletRequest)context.get("request");
    	String partyId = request.getParameter("partyId");
    	listAllConditions.add(tmpConditon);
    	listAllConditions.add(EntityCondition.makeCondition("partyId", partyId));
    	listAllConditions.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null), EntityOperator.OR,
    			EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, UtilDateTime.nowTimestamp())));
    	try {
    		listIterator = delegator.find("EmplPayrollParameterAndParameters", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListParameterEmpl service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
	
	public static Map<String, Object> getListEmplPositionTypeRate(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts = (EntityFindOptions) context.get("opts");
    	Map<String, String> mapCondition = new HashMap<String, String>();
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	//HttpServletRequest request = (HttpServletRequest)context.get("request");
    	listAllConditions.add(tmpConditon);
    	listAllConditions.add(EntityUtil.getFilterByDateExpr());
    	if(UtilValidate.isEmpty(listSortFields)){
    		listSortFields = UtilMisc.toList("emplPositionTypeId");
    	}
    	try {
    		listIterator = delegator.find("OldEmplPositionTypeRate", EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND), null, null, listSortFields, opts);
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling getListEmplPositionTypeRate service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;		
	}
	
	public static Map<String, Object> getEmplPositionTypeRateHistory(DispatchContext dctx, Map<String, Object> context){
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		List<Map<String, Object>> listReturn = FastList.newInstance();
		Map<String, Object> retMap = FastMap.newInstance();
		retMap.put("listEmplPositionTypeRate", listReturn);
		Delegator delegator = dctx.getDelegator();
		try {
			List<GenericValue> listEmplPosTypeRate = delegator.findByAnd("OldEmplPositionTypeRate", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId), UtilMisc.toList("fromDate"), false);
			for(GenericValue tempGv: listEmplPosTypeRate){
				Map<String, Object> tempMap = FastMap.newInstance();
				tempMap.put("fromDateDetail", tempGv.getTimestamp("fromDate").getTime());
				tempMap.put("thruDateDetail", tempGv.getTimestamp("thruDate") != null ? tempGv.getTimestamp("thruDate").getTime(): null);
				tempMap.put("rateCurrencyUomIdDetail", tempGv.getString("rateCurrencyUomId"));
				tempMap.put("periodTypeIdDetail", tempGv.getString("periodTypeId"));
				tempMap.put("rateAmountDetail", tempGv.get("rateAmount"));
				listReturn.add(tempMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> getPartyPayrollHistoryDetails(DispatchContext dctx, Map<String, Object> context){
		Map<String, Object> resultService = FastMap.newInstance();
		//Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Map<String, Object> retMap = FastMap.newInstance();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String partyId = (String)context.get("partyId");
		try {
			resultService = dispatcher.runSync("getPartyPayrollHistory", UtilMisc.toMap("partyId", partyId, "userLogin", userLogin));
			List<Map<String, Object>> listRowDetails = (List<Map<String,Object>>)resultService.get("listPartyPayrollHistory");		
			List<Map<String, Object>> rowDetails = FastList.newInstance();
			retMap.put("rowDetail", rowDetails);
			Collections.sort(listRowDetails, new Comparator<Map<String, Object>>() {
				@Override
				public int compare(Map<String, Object> o1,
						Map<String, Object> o2) {
					// TODO Auto-generated method stub
					Timestamp obj1Time = (Timestamp)o1.get("fromDate");
					Timestamp obj2Time = (Timestamp)o2.get("fromDate");
					if(obj1Time.before(obj2Time)){
						return -1;
					}else if(obj1Time.after(obj2Time)){
						return 1;
					}
					return 0;
				}
			});
			for(Map<String, Object> entry: listRowDetails){
				Map<String, Object> childRowDetail = FastMap.newInstance();
				childRowDetail.put("fromDateDetail", ((Timestamp)entry.get("fromDate")).getTime());
				childRowDetail.put("thruDateDetail", entry.get("thruDate") != null? ((Timestamp)entry.get("thruDate")).getTime(): null);
				childRowDetail.put("workEffortIdDetail", entry.get("workEffortId")); 
				childRowDetail.put("rateTypeIdDetail", entry.get("rateTypeId")); 
				childRowDetail.put("rateCurrencyUomIdDetail", entry.get("rateCurrencyUomId"));
				childRowDetail.put("periodTypeIdDetail", entry.get("periodTypeId"));
				childRowDetail.put("rateAmountDetail", entry.get("rateAmount"));
				childRowDetail.put("emplPositionTypeIdDetail", entry.get("emplPositionTypeId"));
				childRowDetail.put("rateTypeIdDetail", entry.get("rateTypeId"));
				childRowDetail.put("workEffortIdDetail", entry.get("workEffortId"));
				childRowDetail.put("isBasedOnPosType", entry.get("isBasedOnPosType"));
				rowDetails.add(childRowDetail);
			}
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> getPartyPayrollHistory(DispatchContext dctx, Map<String, Object> context){
		String partyId = (String)context.get("partyId");
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Map<String, Object> retMap = FastMap.newInstance();
		List<Map<String, Object>> listReturn = FastList.newInstance();
		retMap.put("listPartyPayrollHistory", listReturn);
		Map<String, Object> resultService = FastMap.newInstance();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		/*Timestamp fromDateAttr = (Timestamp)context.get("fromDate");
		Timestamp thruDateAttr = (Timestamp)context.get("thruDate");*/
		
		try {
			EntityCondition commonConds = EntityCondition.makeCondition("partyId", partyId);
			/*if(thruDateAttr != null){
				commonConds = EntityCondition.makeCondition(commonConds, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDateAttr));
			}
			if(fromDateAttr != null){
				commonConds = EntityCondition.makeCondition(commonConds, EntityOperator.AND, EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
																															EntityOperator.OR,
																															EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, fromDateAttr)));
			}*/
			List<GenericValue> emplPositionFulList = delegator.findList("EmplPositionAndFulfillment", EntityCondition.makeCondition("employeePartyId", partyId), null, UtilMisc.toList("fromDate"), null, false);
			
			for(GenericValue tempGv: emplPositionFulList){
				Timestamp fromDate = tempGv.getTimestamp("fromDate");
				Timestamp thruDate = tempGv.getTimestamp("thruDate");
				String emplPositionTypeId = tempGv.getString("emplPositionTypeId");
				List<EntityCondition> tempConds = FastList.newInstance();
				tempConds.add(commonConds);
				if(thruDate != null){
					tempConds.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
				}
				tempConds.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
				tempConds.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
																EntityOperator.OR,
															EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, fromDate)));
				List<GenericValue> tempPartyRateAmount = delegator.findList("RateAmount", EntityCondition.makeCondition(commonConds, 
																												EntityOperator.AND, 
																												EntityCondition.makeCondition(tempConds)), 
																												null, UtilMisc.toList("fromDate"), null, false);
				if(UtilValidate.isNotEmpty(tempPartyRateAmount)){
					//if salary is set directly for employee, then get rate amount of employee 					 
					Timestamp minFromDateInRateAmount = tempPartyRateAmount.get(0).getTimestamp("fromDate");
					Timestamp maxThruDateInRateAmount = tempPartyRateAmount.get(tempPartyRateAmount.size() - 1).getTimestamp("thruDate");
					//In period time that salary is not set directly, get salary is set emplPositionTypeId
					List<Map<String, Timestamp>> listFromThruDateBaseOnEmplPosType = FastList.newInstance();
					if(minFromDateInRateAmount.after(fromDate)){
						Timestamp tmpThruDate = UtilDateTime.getDayEnd(minFromDateInRateAmount, -1L);
						Map<String, Timestamp> fromThruDateBaseOnEmplPosType = FastMap.newInstance(); 
						fromThruDateBaseOnEmplPosType.put("fromDate", fromDate);
						fromThruDateBaseOnEmplPosType.put( "thruDate", tmpThruDate);
						listFromThruDateBaseOnEmplPosType.add(fromThruDateBaseOnEmplPosType);
					}
					if(maxThruDateInRateAmount != null && (thruDate == null || maxThruDateInRateAmount.before(thruDate))){
						Timestamp tmpFromDate = UtilDateTime.getDayStart(maxThruDateInRateAmount, 1);
						Map<String, Timestamp> fromThruDateBaseOnEmplPosType = FastMap.newInstance(); 
						fromThruDateBaseOnEmplPosType.put("fromDate", tmpFromDate);
						fromThruDateBaseOnEmplPosType.put( "thruDate", thruDate);
						listFromThruDateBaseOnEmplPosType.add(fromThruDateBaseOnEmplPosType);
					}
					//rateAmount is set directly for employee
					for(int i = 0; i < tempPartyRateAmount.size(); i++){
						Map<String, Object> tempMap = FastMap.newInstance();
						Timestamp tempRateAmountFromDate = tempPartyRateAmount.get(i).getTimestamp("fromDate");
						Timestamp tempRateAmountThruDate = tempPartyRateAmount.get(i).getTimestamp("thruDate");
						String rateCurrencyUomId = tempPartyRateAmount.get(i).getString("rateCurrencyUomId");
						String periodTypeId = tempPartyRateAmount.get(i).getString("periodTypeId");
						BigDecimal rateAmount = tempPartyRateAmount.get(i).getBigDecimal("rateAmount");
						if(tempRateAmountFromDate.before(fromDate)){
							tempRateAmountFromDate = fromDate;
						}
						if(tempRateAmountThruDate == null || (thruDate != null && tempRateAmountThruDate.after(thruDate))){
							tempRateAmountThruDate = thruDate;
						}
						if(tempRateAmountThruDate != null && i < tempPartyRateAmount.size() - 1){
							//ex: if "tempRateAmountThruDate" is 02/04/2015 and next fromDate in "tempPartyRateAmount" is 10/04/2015 
							// => 03/04/2015 (nextFromDate) to 09/04/2015, salary is set base on emplPositionType
							Timestamp nextFromDate = UtilDateTime.getDayStart(tempRateAmountThruDate, 1);
							if(nextFromDate.before(tempPartyRateAmount.get(i + 1).getTimestamp("fromDate"))){
								Map<String, Timestamp> fromThruDateBaseOnEmplPosType = FastMap.newInstance(); 
								fromThruDateBaseOnEmplPosType.put("fromDate", nextFromDate);
								fromThruDateBaseOnEmplPosType.put( "thruDate", UtilDateTime.getDayEnd(tempPartyRateAmount.get(i + 1).getTimestamp("fromDate"), -1L));
								listFromThruDateBaseOnEmplPosType.add(fromThruDateBaseOnEmplPosType);
							}
						}
						tempMap.put("fromDate", tempRateAmountFromDate);
						tempMap.put("thruDate", tempRateAmountThruDate);
						tempMap.put("rateCurrencyUomId", rateCurrencyUomId);
						tempMap.put("periodTypeId", periodTypeId);
						tempMap.put("rateAmount", rateAmount);
						tempMap.put("emplPositionTypeId", tempPartyRateAmount.get(i).getString("emplPositionTypeId"));
						tempMap.put("rateTypeId", tempPartyRateAmount.get(i).getString("rateTypeId"));
						tempMap.put("workEffortId", tempPartyRateAmount.get(i).getString("workEffortId"));
						tempMap.put("isBasedOnPosType", "N");
						listReturn.add(tempMap);
					}
					for(Map<String, Timestamp> entry: listFromThruDateBaseOnEmplPosType){
						resultService = dispatcher.runSync("getEmplPositionTypeRateInPeriod", UtilMisc.toMap("fromDate", entry.get("fromDate"), "thruDate", entry.get("thruDate"), 
								"emplPositionTypeId", emplPositionTypeId,
								"userLogin", userLogin));
						List<GenericValue> emplPositionTypeRate = (List<GenericValue>)resultService.get("emplPositionTypeRate");
						for(GenericValue tmpGv: emplPositionTypeRate){
							Map<String, Object> tempMap = FastMap.newInstance();
							Timestamp tempFromDate = tmpGv.getTimestamp("fromDate");
							Timestamp tempThruDate = tmpGv.getTimestamp("thruDate");
							if(tempFromDate.before(entry.get("fromDate"))){
								tempFromDate = entry.get("fromDate");
							}
							if(tempThruDate == null || (entry.get("thruDate") != null && tempThruDate.after(entry.get("thruDate")))){
								tempThruDate = entry.get("thruDate");
							}
							tempMap.put("fromDate", entry.get("fromDate"));
							tempMap.put("thruDate", entry.get("thruDate"));
							tempMap.put("emplPositionTypeId", tmpGv.getString("emplPositionTypeId"));
							tempMap.put("rateAmount", tmpGv.getBigDecimal("rateAmount"));
							tempMap.put("periodTypeId", tmpGv.getString("periodTypeId"));
							tempMap.put("rateCurrencyUomId", tmpGv.getString("rateCurrencyUomId"));
							tempMap.put("isBasedOnPosType", "Y");
							listReturn.add(tempMap);
						}
					}
				}else{
					resultService = dispatcher.runSync("getEmplPositionTypeRateInPeriod", UtilMisc.toMap("fromDate", fromDate, "thruDate", thruDate, 
							"emplPositionTypeId", emplPositionTypeId,
							"userLogin", userLogin));
					List<GenericValue> emplPositionTypeRate = (List<GenericValue>)resultService.get("emplPositionTypeRate");
					for(GenericValue tmpGv: emplPositionTypeRate){
						Map<String, Object> tempMap = FastMap.newInstance();
						Timestamp tempFromDate = tmpGv.getTimestamp("fromDate");
						Timestamp tempThruDate = tmpGv.getTimestamp("thruDate");
						if(tempFromDate.before(fromDate)){
							tempFromDate = fromDate;
						}
						if(tempThruDate == null || (thruDate != null && tempThruDate.after(thruDate))){
							tempThruDate = thruDate;
						}
						tempMap.put("fromDate", tempFromDate);
						tempMap.put("thruDate", tempThruDate);
						tempMap.put("emplPositionTypeId", tmpGv.getString("emplPositionTypeId"));
						tempMap.put("rateAmount", tmpGv.getBigDecimal("rateAmount"));
						tempMap.put("periodTypeId", tmpGv.getString("periodTypeId"));
						tempMap.put("rateCurrencyUomId", tmpGv.getString("rateCurrencyUomId"));
						tempMap.put("isBasedOnPosType", "Y");
						listReturn.add(tempMap);
					}
				}
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> getEmplPositionTypeRateInPeriod(DispatchContext dctx, Map<String, Object> context){
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		Timestamp thruDate = (Timestamp)context.get("thruDate");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> retMap = FastMap.newInstance();
		List<EntityCondition> conditions = FastList.newInstance();
		if(thruDate != null){
			conditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN, thruDate));
		}
		conditions.add(EntityCondition.makeCondition(EntityCondition.makeCondition("thruDate", null),
						EntityOperator.OR,
						EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, fromDate)));
		conditions.add(EntityCondition.makeCondition("emplPositionTypeId", emplPositionTypeId));
		try {
			List<GenericValue> emplPositionTypeRate = delegator.findList("OldEmplPositionTypeRate", EntityCondition.makeCondition(conditions), null, UtilMisc.toList("fromDate"), null, false);
			retMap.put("emplPositionTypeRate", emplPositionTypeRate);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}
	
	public static Map<String, Object> createPayrollTableRecord(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String departmentListStr = (String)context.get("departmentList");
		String formulaListStr = (String)context.get("formulaList");
		GenericValue payrollTableRecord = delegator.makeValue("PayrollTableRecord");
		Timestamp fromDate = (Timestamp) context.get("fromDate");
		Timestamp thruDate = (Timestamp) context.get("thruDate");
		fromDate = UtilDateTime.getDayStart(fromDate);
		thruDate = UtilDateTime.getDayEnd(thruDate);
		payrollTableRecord.set("fromDate", fromDate);
		payrollTableRecord.set("thruDate", thruDate);
		payrollTableRecord.set("periodTypeId", (String) context.get("periodTypeId"));
		payrollTableRecord.set("payrollTableName", (String) context.get("payrollTableName"));
		payrollTableRecord.set("statusId", "PYRLL_TABLE_CREATED");
		String payrollTableId = delegator.getNextSeqId("PayrollTableRecord");
		payrollTableRecord.set("payrollTableId", payrollTableId);
		Locale locale = (Locale)context.get("locale");
		JSONArray departmentJson = JSONArray.fromObject(departmentListStr);
		JSONArray formulaListJson = JSONArray.fromObject(formulaListStr);
		List<String> formulaList = FastList.newInstance();
		List<String> departmentList = FastList.newInstance();
		for(int i = 0; i < departmentJson.size(); i++){
			departmentList.add(departmentJson.getString(i));
		}
		for(int i = 0; i < formulaListJson.size(); i++){
			formulaList.add(formulaListJson.getString(i));
		}
		try {
			payrollTableRecord.create();
			for(String formula: formulaList){
				GenericValue payrollTableCode = delegator.makeValue("PayrollTableCode");
				payrollTableCode.put("code", formula);
				payrollTableCode.put("payrollTableId", payrollTableId);
				payrollTableCode.create();
			}
			for(String department: departmentList){
				GenericValue partyPayrollTableRecord = delegator.makeValue("PartyPayrollTableRecord");
				partyPayrollTableRecord.set("partyId", department);
				partyPayrollTableRecord.set("payrollTableId", payrollTableId);
				partyPayrollTableRecord.create();
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("CommonUiLabels", "CommonSuccessfullyCreated", locale));
	}
	
	 
	/*create party formula invoice item type*/
	
	public static Map<String, Object> createPartyFormulaInvoiceItemType(DispatchContext dctx, Map<String, Object> context){
		Locale locale = (Locale)context.get("locale");
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		String invoiceItemTypeId = (String)context.get("invoiceItemTypeId");
		String code = (String)context.get("code");
		String partyListIdStr= (String)context.get("partyListId");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		
		if(partyId == null && partyListIdStr == null){
			return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "NoPartyFoundForFormulaInvoiceItemType", locale));
		}
		JSONArray partyIdListJson = JSONArray.fromObject(partyListIdStr);
		List<String> partyListId = FastList.newInstance();
		for(int i = 0; i < partyIdListJson.size(); i++){
			partyListId.add(partyIdListJson.getJSONObject(i).getString("partyId"));
		}
		if(fromDate == null){
			fromDate = UtilDateTime.nowTimestamp();
		}
		fromDate = UtilDateTime.getDayStart(fromDate);
		context.put("fromDate", fromDate);
		try {
			if(partyListId != null){
				for(String tempPartyId: partyListId){
					List<GenericValue> checkEntityValue =  delegator.findByAnd("PartyPayrollFormulaInvoiceItemType", UtilMisc.toMap("partyId", tempPartyId, "invoiceItemTypeId", invoiceItemTypeId, "code", code),null, false);
					if(UtilValidate.isNotEmpty(checkEntityValue)){
						GenericValue invoiceItemType = delegator.findOne("InvoiceItemType", UtilMisc.toMap("invoiceItemTypeId", invoiceItemTypeId), false);
						return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "PartyFormulaInvoiceItemTypeExists",UtilMisc.toMap("departmentName", PartyHelper.getPartyName(delegator, tempPartyId, false), "code", code, "invoiceItemType", invoiceItemType.getString("description")), locale));
					}
					GenericValue partyPayrollFormulaInvoiceItemType = delegator.makeValue("PartyPayrollFormulaInvoiceItemType");
					partyPayrollFormulaInvoiceItemType.setAllFields(context, false, null, null);
					partyPayrollFormulaInvoiceItemType.set("partyId", tempPartyId);
					partyPayrollFormulaInvoiceItemType.create();
				}
			}else if(partyId != null){
				List<GenericValue> checkEntityValue =  delegator.findByAnd("PartyPayrollFormulaInvoiceItemType", UtilMisc.toMap("partyId", partyId, "invoiceItemTypeId", invoiceItemTypeId, "code", code),null, false);
				if(checkEntityValue != null){
					GenericValue invoiceItemType = delegator.findOne("InvoiceItemType", UtilMisc.toMap("invoiceItemTypeId", invoiceItemTypeId), false);
					return ServiceUtil.returnError(UtilProperties.getMessage("PayrollUiLabels", "PartyFormulaInvoiceItemTypeExists",UtilMisc.toMap("departmentName", PartyHelper.getPartyName(delegator, partyId, false), "code", code, "invoiceItemType", invoiceItemType.getString("description")), locale));
				}
				GenericValue partyPayrollFormulaInvoiceItemType = delegator.makeValue("PartyPayrollFormulaInvoiceItemType");
				partyPayrollFormulaInvoiceItemType.setAllFields(context, false, null, null);
				partyPayrollFormulaInvoiceItemType.create();
			}
		//partyPayrollFormulaInvoiceItemType.set("fromDate", UtilDateTime.nowTimestamp());
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("CommonUiLabels", "CommonSuccessfullyCreated", locale));
	}
	
	public static Map<String, Object> updatePartyFormulaInvoiceItemType(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		Locale locale = (Locale)context.get("locale");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		String partyId =(String)context.get("partyId");
		String invoiceItemTypeId = (String)context.get("invoiceItemTypeId");
		String code = (String)context.get("code");
		try {
			GenericValue updateEntity = delegator.findOne("PartyPayrollFormulaInvoiceItemType", UtilMisc.toMap("partyId", partyId, 
															"code", code, "invoiceItemTypeId", invoiceItemTypeId, "fromDate", fromDate), false);
			if(updateEntity == null){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToUpdate", locale));
			}
			Timestamp thruDate = (Timestamp)context.get("thruDate");
			if(thruDate != null){
				thruDate = UtilDateTime.getDayEnd(thruDate);
				updateEntity.set("thruDate", thruDate);
				updateEntity.store();
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "updateSuccessfully", locale));
	}
	
	public static Map<String, Object> deletePartyFormulaInvoiceItemType(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		String partyId = (String)context.get("partyId");
		String invoiceItemTypeId = (String)context.get("invoiceItemTypeId");
		String code = (String)context.get("code");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		Locale locale = (Locale)context.get("locale");
		try {
			GenericValue deleteEntity = delegator.findOne("PartyPayrollFormulaInvoiceItemType", UtilMisc.toMap("partyId", partyId, "invoiceItemTypeId", invoiceItemTypeId, "code", code, "fromDate", fromDate), false);
			if(deleteEntity == null){
				return ServiceUtil.returnError(UtilProperties.getMessage("HrCommonUiLabels", "NotFoundRecordToDelete", locale));
			}
			deleteEntity.remove();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("HrCommonUiLabels", "deleteSuccessfully", (Locale)context.get("locale")));
	}
	
	/*get day leave of partyid */
	public static Map<String, Object> getDayLeaveApproved(DispatchContext dctx, Map<String, Object> context) {
		Delegator delegator = dctx.getDelegator();
		String partyId = (String) context.get("partyId");
		Map<String, Object> res = FastMap.newInstance();
		String monthStr = (String)context.get("month");
		String yearStr = (String)context.get("year");
		TimeZone timeZone = (TimeZone)context.get("timeZone");
		Locale locale = (Locale)context.get("locale");
		int month = Integer.parseInt(monthStr);
		int year = Integer.parseInt(yearStr);
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.YEAR, year);
		Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
		Timestamp startMonth = UtilDateTime.getMonthStart(timestamp);
		Timestamp endMonth = UtilDateTime.getMonthEnd(timestamp, timeZone, locale);
		try {
			List<EntityCondition> cond = FastList.newInstance();
			cond.add(EntityCondition.makeCondition("partyId", partyId));
			cond.add(EntityCondition.makeCondition("leaveStatus", "LEAVE_APPROVED"));
			List<GenericValue> data = delegator.findList(
					"EmplLeave",
					EntityCondition.makeCondition(cond, EntityOperator.AND), null,
					UtilMisc.toList("fromDate DESC"), null, true);
			res.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}
}