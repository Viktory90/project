package com.olbius.system;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javolution.util.FastMap;

import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ServiceUtil;

public class ProcessServices {
	private static Map<String,ProcessPentaho> excuted= new HashMap<String, ProcessPentaho>();
	public final static String module = ProcessServices.class.getName();
	
	public static Map<String, Object> inventoryLoad(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/inventory.ktr");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> facilityLoad(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/facility.ktr");
		
		try {
			pentaho.setDate(delegator , "date", System.currentTimeMillis());
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> createCurrencyDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/CurrencyDimension.ktr");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> createDateDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/DateDimension.ktr");
//		
//		try {
//			pentaho.setDate(delegator , "date", System.currentTimeMillis());
//		} catch (GenericEntityException e) {
//			throw new GenericServiceException(e);
//		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> createProductDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/ProductDimension.ktr");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> createPromotionDimension(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/PromotionDimension.ktr");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.addLogFile("test.log");
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> loadSalesOrderItemFact(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException {
		
		Delegator delegator = ctx.getDelegator();
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/SalesOrderItemFact.ktr");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.start();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> runSynCurrencyDimensionJob(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException, GenericEntityException {
		
		Delegator delegator = ctx.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Running");
		
		if(excuted.get("olbius/JobCurrencyDimension.kjb")!=null){
			return result;
		}
		ProcessPentaho pentaho = new ProcessPentaho("olbius/JobCurrencyDimension.kjb");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		
		try {
			
			pentaho.startKitchen();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		excuted.put("olbius/JobCurrencyDimension.kjb", pentaho);
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJob","runSynCurrencyDimensionJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Running");
			entits_load.store();
		}
		
		return result;
	}
	
	public static Map<String, Object> runSynPromotionDimensionJob(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException, GenericEntityException {
		
		Delegator delegator = ctx.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Running");
		
		if(excuted.get("olbius/JobPromotionDimension.kjb")!=null){
			return result;
		}
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/JobPromotionDimension.kjb");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.startKitchen();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		excuted.put("olbius/JobPromotionDimension.kjb", pentaho);
		
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJob","runSynPromotionDimensionJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Running");
			entits_load.store();
		}
		return result;
	}
	
	public static Map<String, Object> runSynProductDimensionJob(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException, GenericEntityException {
		
		Delegator delegator = ctx.getDelegator();
		
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Running");
		
		if(excuted.get("olbius/JobProductDimension.kjb")!=null){
			return result;
		}
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/JobProductDimension.kjb");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.startKitchen();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		
		excuted.put("olbius/JobProductDimension.kjb", pentaho);
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJob","runSynProductDimensionJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Running");
			entits_load.store();
		}
		return result;
	}
	
	public static Map<String, Object> runSynSalesOrderItemFactJob(DispatchContext ctx, Map<String, ? extends Object> context)
			throws GenericServiceException, GenericEntityException {
		
		Delegator delegator = ctx.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Running");
		
		if(excuted.get("olbius/JobSalesOrderFact.kjb")!=null){
			return result;
		}
		
		ProcessPentaho pentaho = new ProcessPentaho("olbius/JobSalesOrderFact.kjb");
		
		try {
			pentaho.setDate(delegator , "date");
		} catch (GenericEntityException e) {
			throw new GenericServiceException(e);
		}
		pentaho.setInfo(((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz"), ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz.olap"));
		try {
			pentaho.startKitchen();
		} catch (IOException e) {
			throw new GenericServiceException(e);
		}
		excuted.put("olbius/JobSalesOrderFact.kjb", pentaho);
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJob","runSynSalesOrderItemFactJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Running");
			entits_load.store();
		}
		
		return result;
	}
	
	public static Map<String, Object> stopCurrencyDimensionJob(DispatchContext dpct, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpct.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Avaiable");
		
		if(excuted.get("olbius/JobCurrencyDimension.kjb")==null){
			return result;
		}
		
		excuted.get("olbius/JobCurrencyDimension.kjb").destroy();
		
		excuted.remove("olbius/JobCurrencyDimension.kjb");
		
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJobDestroy","stopCurrencyDimensionJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Avaiable");
			entits_load.store();
		}
		
		return result;
	}
	
	public static Map<String, Object> stopProductDimensionJob(DispatchContext dpct, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpct.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Avaiable");
		
		if(excuted.get("olbius/JobProductDimension.kjb")==null){
			return result;
		}
		
		excuted.get("olbius/JobProductDimension.kjb").destroy();
		
		excuted.remove("olbius/JobProductDimension.kjb");
		
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJobDestroy","stopProductDimensionJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Avaiable");
			entits_load.store();
		}
		
		return result;
	}
	
	
	public static Map<String, Object> stopPromotionDimensionJob(DispatchContext dpct, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpct.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Avaiable");
		
		if(excuted.get("olbius/JobPromotionDimension.kjb")==null){
			return result;
		}
		
		excuted.get("olbius/JobPromotionDimension.kjb").destroy();
		
		excuted.remove("olbius/JobPromotionDimension.kjb");
		
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJobDestroy","stopPromotionDimensionJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Avaiable");
			entits_load.store();
		}
		
		return result;
	}
	
	public static Map<String, Object> stopSalesOrderItemFactJob(DispatchContext dpct, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator = dpct.getDelegator();
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("statusJob", "Avaiable");
		
		if(excuted.get("olbius/JobSalesOrderFact.kjb")==null){
			return result;
		}
		
		excuted.get("olbius/JobSalesOrderFact.kjb").destroy();
		
		excuted.remove("olbius/JobSalesOrderFact.kjb");
		
		GenericValue entits_load= EntityUtil.getFirst(delegator.findList("ServicesOlapLoad", EntityCondition.makeCondition("serviceNameJobDestroy","stopSalesOrderItemFactJob"), null, null, null, false));
		if(UtilValidate.isNotEmpty(entits_load)){
			entits_load.set("statusJob", "Avaiable");
			entits_load.store();
		}
		
		return result;
	}
	
}
