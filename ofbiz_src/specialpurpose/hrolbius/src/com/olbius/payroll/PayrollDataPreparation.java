package com.olbius.payroll;

import java.sql.Timestamp;
import java.util.List;
import java.util.TimeZone;

import javolution.util.FastList;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityExpr;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.service.DispatchContext;

import com.olbius.payroll.entity.EntityEmplParameters;
import com.olbius.payroll.entity.EntityParameter;

public class PayrollDataPreparation {
	public static EntityEmplParameters getEmployeeParametersCache(DispatchContext dctx, GenericValue userLogin, 
				String strEmployeeId, Timestamp tFromDate, Timestamp tThruDate, TimeZone timeZone) throws Exception{
		// cache general parameters
		Delegator delegator = dctx.getDelegator();
		EntityExpr entityExpr1 = EntityCondition.makeCondition("defaultValue",EntityJoinOperator.NOT_EQUAL, "0"); // defaultValue != 0
		EntityExpr entityExprType = EntityCondition.makeCondition(EntityCondition.makeCondition("type",EntityOperator.EQUALS, "REF"), 
																	EntityOperator.OR,
																	EntityCondition.makeCondition("parentTypeId", "REF"));
		List<GenericValue> listParameterValue = delegator.findList("PayrollParametersAndType", 
						EntityCondition.makeCondition(UtilMisc.toList(entityExpr1, entityExprType), EntityJoinOperator.OR), null, null, null, false);
		
		// cache employee parameters and general parameters
		// check in rank fromDate, purpose: check if parameter is expired.
		EntityCondition conditionDate1 = PayrollUtil.makeLTEcondition("fromDate", tFromDate);// origin: PayrollUtil.makeGTEcondition, edit to PayrollUtil.makeLTEcondition
		EntityCondition conditionDate2 = PayrollUtil.makeLTEcondition("thruDate", tThruDate);	
		
		EntityCondition conditionDate3 = PayrollUtil.makeGTEcondition("thruDate", tFromDate);
		conditionDate3 = EntityCondition.makeCondition(conditionDate3, EntityOperator.AND, EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO,tThruDate));
		
		List<GenericValue> listData = null;
		EntityExpr entityExpr2 = EntityCondition.makeCondition("partyId", strEmployeeId);
		EntityExpr entityExpr3 = EntityCondition.makeCondition("periodTypeId","NA");
		EntityExpr entityExpr4 = EntityCondition.makeCondition("periodTypeId", EntityJoinOperator.NOT_EQUAL, "NA");
		EntityCondition condition1 = EntityCondition.makeCondition(UtilMisc.toList(entityExpr2,entityExpr3,conditionDate1,conditionDate2),EntityJoinOperator.AND);
		EntityCondition condition2 = EntityCondition.makeCondition(UtilMisc.toList(entityExpr2,entityExpr4,conditionDate3 ),EntityJoinOperator.AND);
		listData = delegator.findList("PayrollEmplParameters",EntityCondition.makeCondition(UtilMisc.toList(condition1, condition2), EntityJoinOperator.OR) , null, null, null, false);
		
		EntityEmplParameters result = new EntityEmplParameters();
		List<EntityParameter> parameters = FastList.newInstance();
		
		for(GenericValue genericPam: listParameterValue){
			String strDefaultValue = (String)genericPam.get("defaultValue");
			String strType = (String)genericPam.get("type");
			String parentTypeId = genericPam.getString("parentTypeId");
			String strCode = (String)genericPam.get("code");
			String strActualValue = (String)genericPam.get("actualValue");
			if(strActualValue != null && !strActualValue.isEmpty()){
				strDefaultValue = strActualValue;
			}
			if(strType.equals("REF") || "REF".equals(parentTypeId)){
				PayrollEngine.getRefPayrollParameter(parameters, userLogin, dctx, strEmployeeId, tFromDate, tThruDate, genericPam, timeZone);	
			}else{
				if(strType.equals("CONSTPERCENT")){
					strDefaultValue = PayrollUtil.evaluateStringExpression(strDefaultValue + "/100",false);
				} 
				
				EntityParameter parameter = new EntityParameter();
				parameter.setCode(strCode);
				parameter.setValue(strDefaultValue);
				parameters.add(parameter);
			}
		}
		// end 
		for(GenericValue genericValue:listData){
			String strTmpAP = genericValue.getString("actualPercent");// maybe delete field in database, base on "type" parameters is CONST OR CONSTPERCENT to evaluate  
			// check if parameter with CONSTPERCENT type
			if(genericValue.get("type").equals("CONSTPERCENT")){
				genericValue.setString("value", PayrollUtil.evaluateStringExpression(genericValue.getString("value") + "/100"));
			}
			// put code and value to map
			String strTMPValue = null;
			if(strTmpAP == null || strTmpAP.isEmpty()){ // check if actualPercent is null 
				strTMPValue = genericValue.getString("value");
			}else if(!strTmpAP.contains(".") && strTmpAP != null && strTmpAP.length() > 2){ // if actualPercent is greater than 100%
				throw new Exception("Wrong actual percent for employee: " + strEmployeeId);
			}
			else{
				strTMPValue = genericValue.getString("actualPercent") + "/100";
			}
			if(strTMPValue.matches(".*[a-zA-Z]+.*")){
				/*EntityParameter parameter= new EntityParameter();
				parameter.setCode(genericValue.getString("code"));
				parameter.setValue(PayrollEngine.getActualParameterValue(parameters, delegator, strTMPValue, strEmployeeId, tFromDate, tThruDate));
				parameter.setFromDate(genericValue.getTimestamp("fromDate"));
				parameters.add(parameter);*/
				PayrollEngine.getActualValueOfParameter(parameters, delegator, strTMPValue, strEmployeeId, genericValue.getString("code"), genericValue.getString("periodTypeId"),tFromDate, tThruDate);
			}else{
				EntityParameter parameter= new EntityParameter();
				parameter.setCode(genericValue.getString("code"));
				parameter.setValue(strTMPValue);
				parameter.setFromDate(genericValue.getTimestamp("fromDate"));
				parameter.setThruDate(genericValue.getTimestamp("thruDate"));
				parameter.setPeriodTypeId(genericValue.getString("periodTypeId"));
				parameters.add(parameter);
			}
		}
		result.setPartyId(strEmployeeId);
		result.setEmplParameters(parameters);
		return result;
	}
	
	public static String getParameterPeriod(Delegator delegator, String partyId, String parameter, Timestamp fromDate) throws GenericEntityException{
		GenericValue payrollParameter = null;
		payrollParameter = delegator.findOne("PayrollEmplParameters", false, UtilMisc.toMap("partyId", partyId, "code", parameter, "fromDate", fromDate));
		//Check if party haven't got this parameter
		if(payrollParameter == null){
			payrollParameter = delegator.findOne("PayrollParameters", false, UtilMisc.toMap("code", parameter));
		}
		return payrollParameter.getString("periodTypeId");
	}
}
