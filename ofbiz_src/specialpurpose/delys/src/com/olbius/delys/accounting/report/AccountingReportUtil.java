package com.olbius.delys.accounting.report;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class AccountingReportUtil {
	
	public static List<Object> addAllChild(List<Object> listData){
		List<Object> listReturn = new ArrayList();
		for (Object object : listData) {
			listReturn.add(object);
			HashMap tmpMap = (HashMap)object;
			if(tmpMap.containsKey("children")){
				if(tmpMap.get("children") != null){
					listReturn.addAll(addAllChild((List<Object>)tmpMap.get("children")));
				}
			}
		}
		return listReturn;
	}
	public static BigDecimal calculateAndUpdate(HashMap chd, String strKey){
		List<HashMap> child = (List<HashMap>) chd.get("children");
		BigDecimal tmpValue = new BigDecimal(0);
		if(chd.get(strKey) != null){
			tmpValue = (BigDecimal) chd.get(strKey);
		}
		if(child != null && !child.isEmpty()){
			for (HashMap object : child) {
				tmpValue = tmpValue.add(calculateAndUpdate(object, strKey));
			}
		}
		chd.put(strKey, tmpValue);
		if(chd.containsKey("unionSign") && ("-").equals(chd.get("unionSign"))){
			return tmpValue.multiply(new BigDecimal(-1));
		}
		return tmpValue;
	}
	public static List getChildrenTree(String strParentId, String strPeriodId1, String strPeriodId2, Delegator delegator, String strOrganizationPartyId) throws Exception{
		List<GenericValue> tmpList = delegator.findList("AccReportTarget", EntityCondition.makeCondition("parentTargetId", EntityOperator.EQUALS, strParentId), null, null, null, false);
		if(tmpList == null || tmpList.isEmpty()){
			return null;
		}else{
			List listReturn = new ArrayList();
			for (GenericValue elm : tmpList) {
				Map tmpMap = new HashMap();
				tmpMap.put("targetId", elm.get("targetId"));
				tmpMap.put("name", elm.get("name"));
				tmpMap.put("code", elm.get("code"));
				tmpMap.put("demonstration", elm.get("demonstration"));
				tmpMap.put("displayStyle", elm.get("displayStyle"));
				tmpMap.put("orderIndex", elm.get("orderIndex"));
				tmpMap.put("formula", elm.get("formula"));
				tmpMap.put("unionSign", elm.get("unionSign"));
				tmpMap.put("displaySign", elm.get("displaySign"));
				List listChildren = getChildrenTree((String)elm.get("targetId"), strPeriodId1, strPeriodId2, delegator, strOrganizationPartyId);
				// check for leaf node
				if(listChildren == null){
					// calculate and update target value
					tmpMap.put("value1", buildAndCalculate((String)elm.get("formula"), strPeriodId1, delegator, strOrganizationPartyId));
					tmpMap.put("value2", buildAndCalculate((String)elm.get("formula"), strPeriodId2, delegator, strOrganizationPartyId));
				}else{
					listChildren = sortByOrderIndex(listChildren);
				}
				tmpMap.put("children", listChildren);
				listReturn.add(tmpMap);
			}
			return listReturn;
		}
	}
	// sort list by orderIndex
	public static List<HashMap> sortByOrderIndex(List<HashMap> listData){
		if(listData == null){
			return null;
		}
		for(int i = 0; i < listData.size();i++){
			for(int j = i + 1; j < listData.size(); j++){
				HashMap map1 = listData.get(i);
				HashMap map2 = listData.get(j);
				Long bd1 = (Long) map1.get("orderIndex");
				Long bd2 = (Long) map2.get("orderIndex");
				if(bd1.compareTo(bd2) > 0){
					java.util.Collections.swap(listData, i, j);
				}
			}
		}
		return listData;
	}
	// build and calculate 
	public static BigDecimal buildAndCalculate(String strFormula, String strPeriodId, Delegator delegator, String strOrganizationPartyId) throws Exception{
		if(strFormula == null || "".equals(strFormula)){
			return new BigDecimal(0);
		}
		BigDecimal bdResult = new BigDecimal(0);
		// calculate Plus sign
		String[] strPLus = strFormula.split("\\+");
		for(int i = 0; i < strPLus.length; i++){
			// calculate Subtract sign
			BigDecimal tmpBd;
			if(strPLus[i].contains("-")){
				String[] strSubtract = strPLus[i].split("-"); // FIXME can be removed
				tmpBd = evaluateValue(strSubtract[0], strPeriodId, delegator, strOrganizationPartyId);
				bdResult = bdResult.add(tmpBd);
				for(int j = 1; j < strSubtract.length; j++){
					tmpBd = evaluateValue(strSubtract[j], strPeriodId, delegator, strOrganizationPartyId);
					bdResult = bdResult.subtract(tmpBd);
				}
			}else{
				tmpBd = evaluateValue(strPLus[i], strPeriodId, delegator, strOrganizationPartyId);
				bdResult = bdResult.add(tmpBd);
			}
		}
		return bdResult;
	}                         
	// evaluate DuNoChiTietTheoTK and DuCoChiTietTheoTK
	public static BigDecimal evaluateDuChiTietTheoTK(String strAccountId, Timestamp fromDate, Timestamp thruDate, Delegator delegator, String strOrganizationPartyId, String strFlag) throws GenericEntityException{
		BigDecimal bdResult = new BigDecimal(0);
		// evaluate all DuNo or DuCo
		bdResult = bdResult.add(evaluateAccCreditOrDedit(strAccountId, strOrganizationPartyId, delegator, fromDate, thruDate, strFlag));
		// get list X of gl account have DuCo or DuNo
		List mainAndExprs = new ArrayList();
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		String strCD = "C";
		if("C".equals(strFlag)){
			strCD = "D";
		}
		mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strCD));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		List<GenericValue> listATECD = delegator.findList("AcctgTransEntryCD", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), null, null, null, false);
		List<String> listGlCD = new ArrayList();
		for (GenericValue generic : listATECD) {
			listGlCD.add((String)generic.get("glAccountId"));
		}
		// sum all DuCo or DuNo cause by X list
		bdResult = bdResult.subtract(evaluateAccCreditOrDedit(listGlCD, strOrganizationPartyId, delegator, fromDate, thruDate, strCD));
		// return value
		return bdResult;
	}
	// evaluate DuNoChiTietTheoTKDT and DuCoChiTietTheoTKDT
	public static BigDecimal evaluateDuChiTietTheoTKDT(String strAccountId, Timestamp fromDate, Timestamp thruDate, Delegator delegator, String strOrganizationPartyId, String strFlag) throws Exception{
		BigDecimal bdResult = new BigDecimal(0);
		Timestamp duaDate = null;
		// check for limit DueDate and TransDate
		if(strAccountId.toUpperCase().contains("MIN") || strAccountId.toUpperCase().contains("MAX")){
			if(strAccountId.contains("TransMax12[")){
				strAccountId = strAccountId.trim().substring(strAccountId.indexOf("[") + 1, strAccountId.length() - 1);
				//fromDate
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(thruDate.getTime());
				cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) - 1);
				fromDate = new Timestamp(cal.getTimeInMillis() + 1);
			}else if(strAccountId.contains("DueMin12[")){
				strAccountId = strAccountId.trim().substring(strAccountId.indexOf("[") + 1, strAccountId.length() - 1);
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(thruDate.getTime());
				cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) + 1);
				duaDate = new Timestamp(cal.getTimeInMillis());
			}else  if(strAccountId.contains("TransMin12[")){
				strAccountId = strAccountId.trim().substring(strAccountId.indexOf("[") + 1, strAccountId.length() - 1);
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(thruDate.getTime());
				cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) - 1);
				thruDate = new Timestamp(cal.getTimeInMillis());
				fromDate = null;
			}else{
				throw new Exception("Công thức chưa được hỗ trợ!");
			}
		}
		// evaluate all DuNo or DuCo
		bdResult = bdResult.add(evaluateAccCreditOrDedit(strAccountId, strOrganizationPartyId, delegator, fromDate, thruDate, strFlag));
		// get list X of party and Y of gl account have DuNo or DuCo
		List mainAndExprs = new ArrayList();
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strFlag));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		if(fromDate != null){
			mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		}
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		List<GenericValue> listATEP = delegator.findList("AcctgTransEntryParty", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), null, null, null, false);
		List<String> listPartyId = new ArrayList();
		List<String> listGl = new ArrayList();
		for (GenericValue generic : listATEP) {
			listPartyId.add(generic.getString("partyId"));
			listGl.add(generic.getString("glAccountId"));
		}
		// sum all DuCo or DuNo cause by X list
		String strCD = "C";
		if("C".equals(strFlag)){
			strCD = "D";
		}
		mainAndExprs = new ArrayList();
		mainAndExprs.add(EntityCondition.makeCondition("partyId", EntityOperator.IN, listPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.IN, listGl));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strCD));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		if(fromDate != null){
			mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		}
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		if(duaDate != null){
			mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, duaDate));
		}
		List<GenericValue> listSumDC = delegator.findList("AcctgTransEntrySumsByPartiesLimitDueDate", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
		for (GenericValue genericValue : listSumDC) {
			if(genericValue.getBigDecimal("amount") == null){
				continue;
			}
			bdResult = bdResult.subtract(genericValue.getBigDecimal("amount"));
		}
		// return value
		return bdResult;
	}
	// Update for cashflow and income
	public static BigDecimal evaluateValue(String strFunction, String strPeriodId, Delegator delegator, String strOrganizationPartyId) throws Exception{
		strFunction = strFunction.trim();
		// get fromDate and thruDate
		GenericValue customTime = delegator.findOne("CustomTimePeriod", UtilMisc.toMap("customTimePeriodId", strPeriodId), false);
		Date fromDate = (Date) customTime.get("fromDate");
		Date thruDate = (Date) customTime.get("thruDate");
		Timestamp tsThruDate = new Timestamp(thruDate.getTime() + 86400000 - 1);
		// 1. DuNo ok1
		// 2. DuCo
		// 3. PhatSinhDoiUng
		// 4. LuyKePhatSinhCo
		// 5. LuyKePhatSinhNo
		// 6. DuNoChiTiet
		// 7. DuCoChiTiet
		// 8. DuNoChiTietTheoTK
		// 9. DuCoChiTietTheoTK
		// 10. DuNoChiTietTheoTKDT
		// 11. DuCoChiTietTheoTKDT
		String strAccountId = strFunction.trim().substring(strFunction.indexOf("(") + 1, strFunction.length() - 1);
		// 1. DuNo
		if(strFunction.startsWith("DuNo(")){
			return evaluateSurplusCreditAndDebit(strAccountId, strPeriodId, strOrganizationPartyId, delegator, new Timestamp(fromDate.getTime()), tsThruDate, "D");
		}else 
		// 2. DuCo	
		if(strFunction.startsWith("DuCo(")){
			return evaluateSurplusCreditAndDebit(strAccountId, strPeriodId, strOrganizationPartyId, delegator, new Timestamp(fromDate.getTime()), tsThruDate, "C");
		}else 
		// 3. PhatSinhDoiUng
		if(strFunction.startsWith("PhatSinhDoiUng(")){
			String tmpCD = strFunction.trim().substring(strFunction.indexOf("(") + 1, strFunction.length() - 1);
			String[] arrCD = tmpCD.split(",");
			evaluatePhatSinhDoiUng(arrCD[0].trim(), arrCD[1].trim(), strOrganizationPartyId, delegator, new Timestamp(fromDate.getTime()), tsThruDate);
		}else 
		// 4. LuyKePhatSinhCo
		if(strFunction.startsWith("LuyKePhatSinhCo(")){
			return evaluateAccCreditOrDedit(strAccountId, strOrganizationPartyId, delegator, new Timestamp(fromDate.getTime()), tsThruDate, "C");
		}else 
		// 5. LuyKePhatSinhNo
		if(strFunction.startsWith("LuyKePhatSinhNo(")){
			return evaluateAccCreditOrDedit(strAccountId, strOrganizationPartyId, delegator, new Timestamp(fromDate.getTime()), tsThruDate, "D");
		}else
		// 6. DuNoChiTietTheoTK
		if(strFunction.startsWith("DuNoChiTietTheoTK(")){
			return evaluateDuChiTietTheoTK(strAccountId, new Timestamp(fromDate.getTime()), tsThruDate, delegator, strOrganizationPartyId, "D");
		}else
		// 7. DuCoChiTietTheoTK
		if(strFunction.startsWith("DuCoChiTietTheoTK(")){
			return evaluateDuChiTietTheoTK(strAccountId, new Timestamp(fromDate.getTime()), tsThruDate, delegator, strOrganizationPartyId, "C");
		}else
		// 8. DuNoChiTietTheoTKDT
		if(strFunction.startsWith("DuNoChiTietTheoTKDT(")){
			return evaluateDuChiTietTheoTKDT(strAccountId, new Timestamp(fromDate.getTime()), tsThruDate, delegator, strOrganizationPartyId, "D");
		}else
		// 9. DuCoChiTietTheoTKDT
		if(strFunction.startsWith("DuCoChiTietTheoTKDT(")){
			return evaluateDuChiTietTheoTKDT(strAccountId, new Timestamp(fromDate.getTime()), tsThruDate, delegator, strOrganizationPartyId, "C");
		}
		return new BigDecimal(0);
	}
	// evaluate PhatSinhDoiUng
	public static BigDecimal evaluatePhatSinhDoiUng(String strGlAccountIdC, String strGlAccountIdD, String strOrganizationPartyId, Delegator delegator, Timestamp fromDate, Timestamp thruDate) throws GenericEntityException{
		List mainAndExprs = new ArrayList();
		List<String> listGlAccountC = getAllGlAccountChildren(strGlAccountIdC, delegator);
		listGlAccountC.add(strGlAccountIdC);
		List<String> listGlAccountD = getAllGlAccountChildren(strGlAccountIdD, delegator);
		listGlAccountD.add(strGlAccountIdD);
		// Tính tổng dư Nợ phát sinh đối ứng
		mainAndExprs.add(EntityCondition.makeCondition("glAccountIdC", EntityOperator.IN, listGlAccountC));
		mainAndExprs.add(EntityCondition.makeCondition("glAccountIdD", EntityOperator.IN, listGlAccountD));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyIdC", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyIdD", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		List<GenericValue> listData = delegator.findList("AcctgTransEntrySumsByAccount", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
		if(listData != null){
			BigDecimal returnData = new BigDecimal(0);
				for (GenericValue genericValue : listData) {
					// FIXME get currency and convert 
					BigDecimal tmpBD = genericValue.getBigDecimal("amount");
					if(tmpBD == null){
						tmpBD = new BigDecimal(0);
					}
					returnData = returnData.add(tmpBD);
				}
		}
		// FIXME có thể bỏ đoạn dưới đây.
		// Phát sinh đối ứng = Tổng dự Nợ - Tính tổng dư Có
		mainAndExprs = new ArrayList();
		mainAndExprs.add(EntityCondition.makeCondition("glAccountIdC", EntityOperator.IN, listGlAccountD));
		mainAndExprs.add(EntityCondition.makeCondition("glAccountIdD", EntityOperator.IN, listGlAccountC));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyIdC", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyIdD", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		listData = delegator.findList("AcctgTransEntrySumsByAccount", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
		if(listData != null){
			BigDecimal returnData = new BigDecimal(0);
				for (GenericValue genericValue : listData) {
					// FIXME get currency and convert 
					BigDecimal tmpBD = genericValue.getBigDecimal("amount");
					if(tmpBD == null){
						tmpBD = new BigDecimal(0);
					}
					returnData = returnData.subtract(tmpBD);
				}
		}
		return new BigDecimal(0);
	}
	// evaluate DuNo and DuCo value
	public static BigDecimal evaluateSurplusCreditAndDebit(String strGlAccountId, String strPeriodId, String strOrganizationPartyId, Delegator delegator, Timestamp fromDate, Timestamp thruDate, String strFlag) throws Exception{
		// DuNo = postedDebit - postedCredit = endingBalance
		// DuCo = postedCredit - postedDebit = endingBalance
		// check for limit time
		BigDecimal returnValue = new BigDecimal(0);
		if(strGlAccountId.toUpperCase().contains("MIN") || strGlAccountId.toUpperCase().contains("MAX")){
			if(strGlAccountId.contains("DueMax12[")){
				strGlAccountId = strGlAccountId.trim().substring(strGlAccountId.indexOf("[") + 1, strGlAccountId.length() - 1);
				List mainAndExprs = new ArrayList();
				List<String> listGlAccount = getAllGlAccountChildren(strGlAccountId, delegator);
				listGlAccount.add(strGlAccountId);
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(thruDate.getTime());
				cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) + 1);
				Timestamp tsDueDate = new Timestamp(cal.getTimeInMillis());
				// FIXME fromDate can be less than current fromDate => fromDate and thruDate in conditions can be removed
				mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.IN, listGlAccount));
				mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
				mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strFlag));
				mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
				mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
				mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
				mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
				mainAndExprs.add(EntityCondition.makeCondition(Arrays.asList(EntityCondition.makeCondition("dueDate", EntityOperator.LESS_THAN_EQUAL_TO, tsDueDate), EntityCondition.makeCondition("dueDate", EntityOperator.EQUALS, null)), EntityOperator.OR));
				List<GenericValue> listData = delegator.findList("AcctgTransEntrySumsLimitDueDate", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
				for (GenericValue genericValue : listData) {
					BigDecimal tmpBD = genericValue.getBigDecimal("amount");
					if(tmpBD == null){
						continue;
					}
					returnValue = returnValue.add(tmpBD);
				}
			}else if(strGlAccountId.contains("DueMin12[")){
				strGlAccountId = strGlAccountId.trim().substring(strGlAccountId.indexOf("[") + 1, strGlAccountId.length() - 1);
				List mainAndExprs = new ArrayList();
				List<String> listGlAccount = getAllGlAccountChildren(strGlAccountId, delegator);
				listGlAccount.add(strGlAccountId);
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(thruDate.getTime());
				cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) + 1);
				Timestamp tsDueDate = new Timestamp(cal.getTimeInMillis());
				// FIXME fromDate can be less than current fromDate => fromDate and thruDate in conditions can be removed
				mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.IN, listGlAccount));
				mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
				mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strFlag));
				mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
				mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
				mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
				mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
				mainAndExprs.add(EntityCondition.makeCondition("dueDate", EntityOperator.GREATER_THAN_EQUAL_TO, tsDueDate));
				List<GenericValue> listData = delegator.findList("AcctgTransEntrySumsLimitDueDate", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
				for (GenericValue genericValue : listData) {
					BigDecimal tmpBD = genericValue.getBigDecimal("amount");
					if(tmpBD == null){
						continue;
					}
					returnValue = returnValue.add(tmpBD);
				}
			}else  if(strGlAccountId.contains("TransMax12[")){
				strGlAccountId = strGlAccountId.trim().substring(strGlAccountId.indexOf("[") + 1, strGlAccountId.length() - 1);
				//fromDate
				Calendar cal = Calendar.getInstance();
				cal.setTimeInMillis(thruDate.getTime());
				cal.set(Calendar.YEAR, cal.get(Calendar.YEAR) - 1);
				fromDate = new Timestamp(cal.getTimeInMillis() + 1);
				List mainAndExprs = new ArrayList();
				List<String> listGlAccount = getAllGlAccountChildren(strGlAccountId, delegator);
				mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.IN, listGlAccount));
				mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
				mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strFlag));
				mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
				mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
				mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
				mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
				List<GenericValue> listData = delegator.findList("AcctgTransEntrySumsByParties", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
				for (GenericValue genericValue : listData) {
					BigDecimal tmpBD = genericValue.getBigDecimal("amount");
					if(tmpBD == null){
						continue;
					}
					returnValue = returnValue.add(tmpBD);
				}
			}else{
				throw new Exception("Công thức chưa được hỗ trợ!");
			}
		}else{
			List mainAndExprs = new ArrayList();
			mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.EQUALS, strGlAccountId));
			mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
			mainAndExprs.add(EntityCondition.makeCondition("customTimePeriodId", EntityOperator.EQUALS, strPeriodId));
			GenericValue tmpValue = delegator.findOne("GlAccountHistory", UtilMisc.toMap("glAccountId", strGlAccountId, "organizationPartyId", strOrganizationPartyId, "customTimePeriodId", strPeriodId), false);
			if(tmpValue == null){
				return new BigDecimal(0);
			}
			returnValue = tmpValue.getBigDecimal("endingBalance");
			// get children value
			List<String> listGlAccount = getAllGlAccountChildren(strGlAccountId, delegator);
			for (String string : listGlAccount) {
				returnValue = returnValue.add(evaluateSurplusCreditAndDebit(string, strPeriodId, strOrganizationPartyId, delegator, fromDate, thruDate, strFlag));
			}
		}
		return returnValue;
	}
	
	// evaluate LuyKePhatSinhCo and LuyKePhatSinhNo value
	public static BigDecimal evaluateAccCreditOrDedit(String strGlAccountId, String strOrganizationPartyId, Delegator delegator, Timestamp fromDate, Timestamp thruDate, String strFlag) throws GenericEntityException{
		List mainAndExprs = new ArrayList();
		List<String> listGlAccount = getAllGlAccountChildren(strGlAccountId, delegator);
		listGlAccount.add(strGlAccountId);
		mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.IN, listGlAccount));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strFlag));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		if(fromDate != null){
			mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		}
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		List<GenericValue> listData = delegator.findList("AcctgTransEntrySums", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
		if(listData != null){
			BigDecimal returnData = new BigDecimal(0);
			for (GenericValue genericValue : listData) {
				// FIXME get currency and convert
				if(genericValue.get("amount") == null){
					continue;
				}
				returnData = returnData.add(genericValue.getBigDecimal("amount"));
			}
			return returnData;
		}
		return new BigDecimal(0);
	}
	// evaluate LuyKePhatSinhCo and LuyKePhatSinhNo value
	public static BigDecimal evaluateAccCreditOrDedit(List<String> listGlAccountId, String strOrganizationPartyId, Delegator delegator, Timestamp fromDate, Timestamp thruDate, String strFlag) throws GenericEntityException{
		List mainAndExprs = new ArrayList();
		mainAndExprs.add(EntityCondition.makeCondition("glAccountId", EntityOperator.IN, listGlAccountId));
		mainAndExprs.add(EntityCondition.makeCondition("organizationPartyId", EntityOperator.EQUALS, strOrganizationPartyId));
		mainAndExprs.add(EntityCondition.makeCondition("debitCreditFlag", EntityOperator.EQUALS, strFlag));
		mainAndExprs.add(EntityCondition.makeCondition("isPosted", EntityOperator.EQUALS, "Y"));
		mainAndExprs.add(EntityCondition.makeCondition("acctgTransTypeId", EntityOperator.NOT_EQUAL, "PERIOD_CLOSING"));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		mainAndExprs.add(EntityCondition.makeCondition("transactionDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		List<GenericValue> listData = delegator.findList("AcctgTransEntrySums", EntityCondition.makeCondition(mainAndExprs, EntityOperator.AND), UtilMisc.toSet("amount"), null, null, false);
		if(listData != null){
			BigDecimal returnData = new BigDecimal(0);
			for (GenericValue genericValue : listData) {
				// FIXME get currency and convert
				if(genericValue.get("amount") == null){
					continue;
				}
				returnData = returnData.add(genericValue.getBigDecimal("amount"));
			}
			return returnData;
		}
		return new BigDecimal(0);
	}
	// get all children of all levels
	public static List<String> getAllGlAccountChildren(String strGlAccountId, Delegator delegator) throws GenericEntityException{
		List<String> listData = new ArrayList<String>();
		List<GenericValue> listTmp = delegator.findList("GlAccount", EntityCondition.makeCondition("parentGlAccountId", EntityOperator.EQUALS, strGlAccountId), UtilMisc.toSet("glAccountId"), null, null, false);
		if(listTmp != null){
			for (GenericValue genericValue : listTmp) {
				listData.add((String)genericValue.get("glAccountId"));
				listData.addAll(getAllGlAccountChildren((String)genericValue.get("glAccountId"), delegator));
			}
		}
		return listData;
	}
	// calculate target value
	public static BigDecimal evalueTargetValue(Delegator delegator, String strTargetId, String strPeriodId, String strOrganizationPartyId) throws Exception{
		BigDecimal returnValue = new BigDecimal(0);
		List<GenericValue> tmpList = delegator.findList("AccReportTarget", EntityCondition.makeCondition("targetId", EntityOperator.EQUALS, strTargetId), null, null, null, false);
		if(tmpList == null || tmpList.isEmpty()){
			return returnValue;
		}
		for (GenericValue genericValue : tmpList) {
			List<GenericValue> tmpChildrenList = delegator.findList("AccReportTarget", EntityCondition.makeCondition("parentTargetId", EntityOperator.EQUALS, strTargetId), null, null, null, false);
			if(tmpChildrenList == null || tmpChildrenList.isEmpty()){
				String strTmp = (String)genericValue.get("formula");
				if(strTmp == null || strTmp.isEmpty()){
					returnValue = returnValue.add(new BigDecimal(0));
				}else{
					returnValue = returnValue.add(buildAndCalculate((String)genericValue.get("formula"), strPeriodId, delegator, strOrganizationPartyId));
				}
			}else{
				for (GenericValue genericValue2 : tmpChildrenList) {
					returnValue = returnValue.add(evalueTargetValue(delegator, (String)genericValue2.get("targetId"), strPeriodId, strOrganizationPartyId));
				}
			}
		}
		return returnValue;
	}
}
