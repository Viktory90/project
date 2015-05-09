package com.olbius.olap.order;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.util.FastList;
import javolution.util.FastSet;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityFunction;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;


public class JqxServices {
	public static final String module = JqxServices.class.getName();
	public static Map<String, Object> jqxSalesOrderItemFact(DispatchContext ctx, Map<String, ?extends Object> context){
		Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	Map<String, String[]> parameters= (Map<String, String[]>)context.get("parameters");
    	String[] starSchemaName= parameters.get("starSchemaName");
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	EntityCondition condition= EntityCondition.makeCondition(listAllConditions, EntityJoinOperator.OR);
    	try {
    		listIterator = delegator.find(starSchemaName[0], condition, null, null,listSortFields , opts);
    	
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling jqGetListProduct service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
		
	}
	public static Map<String, Object>jqxBiSalesOrderProduct(DispatchContext ctx, Map<String, ?extends Object> context) throws ParseException, GenericEntityException{
		Delegator delegator = ctx.getDelegator();
		Map<String, String[]> parameters= (Map<String,String[]>)context.get("parameters");
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	EntityCondition conditionx= EntityCondition.makeCondition(listAllConditions, EntityJoinOperator.OR);
    	HttpServletRequest request = (HttpServletRequest) context.get("request");
		HttpSession session = request.getSession();
		int pagesize = Integer.parseInt(parameters.get("pagesize")[0]);
	    int pageNum = Integer.parseInt(parameters.get("pagenum")[0]);
	    int start = pagesize * pageNum;
	    int end = start + pagesize;
	    int totalRows = 0;
		Map<String, Object> successResult= ServiceUtil.returnSuccess();
		List<Map<String,Object>> listIterator= FastList.newInstance();
		
		String search[]= parameters.get("search");
		String thruDate[] =parameters.get("thruDate");
		String fromDate[] =parameters.get("fromDate");
		
		List<EntityCondition> condition=FastList.newInstance();
		EntityCondition conditionProduct=null;
		SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");
		if(UtilValidate.isNotEmpty(fromDate) &&UtilValidate.isNotEmpty(thruDate)){
			session.setAttribute("thruDate", thruDate[0]);
			session.setAttribute("fromDate",fromDate[0]);
			Date newFrom= yearMonthDayFormat.parse(fromDate[0]);
			Date newThru= yearMonthDayFormat.parse(thruDate[0]);
			EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(newFrom.getTime()));
			EntityCondition condition2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(newThru.getTime()));
			condition.add(EntityCondition.makeCondition(EntityJoinOperator.AND, condition1,condition2));
			
		}else if (UtilValidate.isNotEmpty(fromDate)&&UtilValidate.isEmpty(thruDate)) {
			session.setAttribute("fromDate", fromDate[0]);
			session.setAttribute("thruDate","");
			Date newFrom= yearMonthDayFormat.parse(fromDate[0]);
			condition.add(EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO,new java.sql.Date(newFrom.getTime())));
		}else if (UtilValidate.isNotEmpty(thruDate)&&UtilValidate.isEmpty(fromDate)) {
			session.setAttribute("fromDate","");
			session.setAttribute("thruDate",thruDate[0]);
			Date newThru= yearMonthDayFormat.parse(thruDate[0]);
			condition.add(EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(newThru.getTime())));
		}else if(UtilValidate.isEmpty(fromDate) &&UtilValidate.isEmpty(thruDate)){
			if(UtilValidate.isNotEmpty(session.getAttribute("fromDate"))&&UtilValidate.isNotEmpty(session.getAttribute("thruDate"))){
				String xfromDate=(String)session.getAttribute("fromDate");
				String xthruDate=(String)session.getAttribute("thruDate");
				Date newFrom= yearMonthDayFormat.parse(xfromDate);
				Date newThru= yearMonthDayFormat.parse(xthruDate);
				EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(newFrom.getTime()));
				EntityCondition condition2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(newThru.getTime()));
				condition.add(EntityCondition.makeCondition(EntityJoinOperator.AND, condition1,condition2));
			
			}else if(UtilValidate.isNotEmpty(session.getAttribute("fromDate"))&&UtilValidate.isEmpty(session.getAttribute("thruDate"))){
				String xfromDate=(String)session.getAttribute("fromDate");
				Date newFrom= yearMonthDayFormat.parse(xfromDate);
				condition.add(EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO,new java.sql.Date(newFrom.getTime())));

			}else if(UtilValidate.isEmpty(session.getAttribute("fromDate"))&&UtilValidate.isNotEmpty(session.getAttribute("thruDate"))){
				String xthruDate=(String)session.getAttribute("thruDate");
				Date newThru= yearMonthDayFormat.parse(xthruDate);
				condition.add(EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO,new java.sql.Date(newThru.getTime())));

			}
		}
		
		if(UtilValidate.isNotEmpty(search)){
			EntityCondition condition1= EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("productProductId"), EntityOperator.LIKE, EntityFunction.UPPER("%" + search[0] + "%"));
			EntityCondition condition2= EntityCondition.makeCondition(EntityFunction.UPPER_FIELD("productInternalName"), EntityOperator.LIKE, EntityFunction.UPPER("%" + search[0] + "%"));
			conditionProduct= EntityCondition.makeCondition(EntityJoinOperator.OR, condition1, condition2);
			condition.add(conditionProduct);
		}
		
		List<GenericValue> salesOrderItems= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(condition, EntityJoinOperator.AND), null, null, null, false); 
		if(UtilValidate.isNotEmpty(salesOrderItems)){
			Map<String, Map<String, Object>> xresult= new HashMap<String, Map<String, Object>>();
			for(GenericValue item:salesOrderItems){
				String productId= item.getString("productProductId");
				String productType= item.getString("productProductType");
				BigDecimal quantity = (BigDecimal) item.getBigDecimal("quantity");
				BigDecimal extTaxAmount = (BigDecimal) item.getBigDecimal("extTaxAmount");
				BigDecimal extGrossAmount = (BigDecimal) item.getBigDecimal("extGrossAmount");
				if(UtilValidate.isEmpty(extTaxAmount)){
					extTaxAmount= new BigDecimal(0);
				}
				if(UtilValidate.isEmpty(extGrossAmount)){
					
					extGrossAmount= new BigDecimal(0);
				}
				if(xresult.containsKey(productId)){
					Map<String, Object> xvalue= new HashMap<String, Object>();
					xvalue= (Map<String, Object>)xresult.get(productId);
					BigDecimal xquatity= quantity.add((BigDecimal)xvalue.get("quantity"));
					BigDecimal xextTaxamount=extTaxAmount.add((BigDecimal)xvalue.get("extTaxAmount"));
					BigDecimal xextGrossAmount=extGrossAmount.add((BigDecimal)xvalue.get("extGrossAmount"));
					xvalue.put("quantity", xquatity);
					xvalue.put("extTaxAmount", xextTaxamount);
					xvalue.put("extGrossAmount", xextGrossAmount);
					xresult.put(productId,xvalue);
				}else {
					String productStoreId=item.getString("productStoreId");
					String inernalName= item.getString("productInternalName");
					Map<String, Object> xvalue= new HashMap<String, Object>();
					xvalue.put("internalName", inernalName);
					xvalue.put("productType", productType);
					xvalue.put("quantity", quantity);
					xvalue.put("extTaxAmount", extTaxAmount);
					xvalue.put("extGrossAmount", extGrossAmount);
					xvalue.put("productStoreId", productStoreId);
					xresult.put(productId,xvalue);
				}
				
			}
			
			
			Iterator<String> keyset = xresult.keySet().iterator();
			while(keyset.hasNext()){
				String key= keyset.next();
				Map<String, Object> value= xresult.get(key);
				value.put("productId", key);
				listIterator.add(value);
			}
		}
		
		
		List<Map<String, Object>> listAllCondMap = CommonReportsServices.getListAllMap(listAllConditions);
		List<Map<String,Object>> listReturn=FastList.newInstance();
		if(UtilValidate.isNotEmpty(listAllCondMap)){
			listReturn=CommonReportsServices.fillerConditionProduct(listAllCondMap, listIterator);
		}else{
			listReturn=listIterator;
		}
		List<Map<String,Object>> xfinal= FastList.newInstance();
		String sortFiled = listSortFields.toString();
    	if(sortFiled.contains("[")){
    		sortFiled = sortFiled.replace("[", "");
    	}
    	if(sortFiled.contains("]")){
    		sortFiled = sortFiled.replace("]", "");
    	}
    	if(UtilValidate.isNotEmpty(sortFiled)){
    		xfinal =  CommonReportsServices.sortList(listReturn, sortFiled);
    	}else{
    		xfinal=listReturn;
    	}
    	if(end > xfinal.size()){
    		end = xfinal.size();
    	}
    	totalRows = xfinal.size();
    	xfinal = xfinal.subList(start, end);
    	
		successResult.put("listIterator", xfinal);
		successResult.put("TotalRows", String.valueOf(totalRows));
    	
    	return successResult;
	}
	
	
	
	
	
	public static void getTopTenSalesBest(HttpServletRequest request, HttpServletResponse response) throws GenericEntityException, ParseException{
		Delegator delegator= (Delegator)request.getAttribute("delegator");
		String thruDate= (String)request.getParameter("thruDate");
		String fromDate= (String)request.getParameter("fromDate");
		EntityCondition condition= null;
		
		SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");
		if(UtilValidate.isNotEmpty(fromDate) &&UtilValidate.isNotEmpty(thruDate)){
			Date newFrom= yearMonthDayFormat.parse(fromDate);
			Date newThru= yearMonthDayFormat.parse(thruDate);
			EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(newFrom.getTime()));
			EntityCondition condition2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(newThru.getTime()));
			condition=EntityCondition.makeCondition(EntityJoinOperator.AND, condition1,condition2);
			
		}else if (UtilValidate.isNotEmpty(fromDate)&&UtilValidate.isEmpty(thruDate)) {
			Date newFrom= yearMonthDayFormat.parse(fromDate);
			condition=EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO,new java.sql.Date(newFrom.getTime()));
		}else if (UtilValidate.isNotEmpty(thruDate)&&UtilValidate.isEmpty(fromDate)) {
			Date newThru= yearMonthDayFormat.parse(thruDate);
			condition=EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(newThru.getTime()));
		}
		
		
		List<Map<String, Object>> result= FastList.newInstance();
		List<GenericValue> salesOrderItems= delegator.findList("SalesOrderItemStarSchema", condition, null, null, null, false); 
		if(UtilValidate.isNotEmpty(salesOrderItems)){
			Map<String, Map<String, Object>> xresult= new HashMap<String, Map<String, Object>>();
			for(GenericValue item:salesOrderItems){
				String productId= item.getString("productProductId");
				String productType= item.getString("productProductType");
				BigDecimal quantity = (BigDecimal) item.getBigDecimal("quantity");
				BigDecimal extTaxAmount = (BigDecimal) item.getBigDecimal("extTaxAmount");
				BigDecimal extGrossAmount = (BigDecimal) item.getBigDecimal("extGrossAmount");
				
				if(xresult.containsKey(productId)){
					Map<String, Object> xvalue= new HashMap<String, Object>();
					xvalue= (Map<String, Object>)xresult.get(productId);
					BigDecimal xquatity= quantity.add((BigDecimal)xvalue.get("quantity"));
					BigDecimal xextTaxamount=extTaxAmount.add((BigDecimal)xvalue.get("extTaxAmount"));
					BigDecimal xextGrossAmount=extGrossAmount.add((BigDecimal)xvalue.get("extGrossAmount"));
					xvalue.put("quantity", xquatity);
					xvalue.put("extTaxAmount", xextTaxamount);
					xvalue.put("extGrossAmount", xextGrossAmount);
					xresult.put(productId,xvalue);
				}else {
					String productStoreId=item.getString("productStoreId");
					String inernalName= item.getString("productInternalName");
					Map<String, Object> xvalue= new HashMap<String, Object>();
					xvalue.put("internalName", inernalName);
					xvalue.put("productType", productType);
					xvalue.put("quantity", quantity);
					xvalue.put("extTaxAmount", extTaxAmount);
					xvalue.put("extGrossAmount", extGrossAmount);
					xvalue.put("productStoreId", productStoreId);
					xresult.put(productId,xvalue);
				}
				
			}
			
			
			Iterator<String> keyset = xresult.keySet().iterator();
			while(keyset.hasNext()){
				String key= keyset.next();
				Map<String, Object> value= xresult.get(key);
				value.put("productId", key);
				result.add(value);
			}
			List<Map<String, Object>> xres= FastList.newInstance();
			xres=CommonReportsServices.sortList(result,"");
		}
		CommonReportsServices.toJsonObjectList(result, response);
		
	}
	
	 
	 public static Map<String, Object> jqxSalesOrderMonthly(DispatchContext dcpx, Map<String, ?extends Object> context) throws GenericEntityException{
	    Delegator delegator = dcpx.getDelegator();
		Map<String, String[]> parameters= (Map<String,String[]>)context.get("parameters");
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	HttpServletRequest request = (HttpServletRequest) context.get("request");
		HttpSession session = request.getSession();
		
		int pagesize = Integer.parseInt(parameters.get("pagesize")[0]);
	    int pageNum = Integer.parseInt(parameters.get("pagenum")[0]);
	    int start = pagesize * pageNum;
	    int end = start + pagesize;
	    int totalRows = 0;
		
    	List<Map<String,Object>> listIterator= FastList.newInstance();
    	
    	String role[]= parameters.get("chanelsales");
    	String department[]= parameters.get("department");
    	String month[] = parameters.get("month");
    	String year[]= parameters.get("year");
    	
    	String finalDepartment="";
    	String finalYear="";
    	String finalMonth="";
    	
		if(UtilValidate.isNotEmpty(department)&&UtilValidate.isNotEmpty(month)&&UtilValidate.isNotEmpty(year)){
			session.setAttribute("department", department[0]);
			session.setAttribute("month", month[0]);
			session.setAttribute("year", year[0]);
			
			finalDepartment=department[0];
			finalYear= year[0];
			finalMonth=month[0];
		}else{
			if(UtilValidate.isNotEmpty(session.getAttribute("department"))&&UtilValidate.isNotEmpty(session.getAttribute("month"))&&UtilValidate.isNotEmpty(session.getAttribute("year"))){
				finalDepartment=(String)session.getAttribute("department");
				finalYear=(String)session.getAttribute("year");
				finalMonth=(String)session.getAttribute("month");
			}
		}
		
		
    	
    	List<EntityCondition> xcon= FastList.newInstance();
    	
    	if(UtilValidate.isNotEmpty(finalDepartment)&& UtilValidate.isNotEmpty(finalYear)&&UtilValidate.isNotEmpty(finalMonth)){
    		int yearcurr= Integer.parseInt(finalYear);
    		int monthcurr= Integer.parseInt(finalMonth)-1;
    		Calendar cal= Calendar.getInstance();
    		cal.set(Calendar.YEAR, yearcurr);
    		cal.set(Calendar.MONTH, monthcurr);
    		cal.set(Calendar.HOUR,0);
    		cal.set(Calendar.MINUTE,0);
    		cal.set(Calendar.SECOND,0);
    		cal.set(Calendar.MILLISECOND,0);
    		cal.set(Calendar.DAY_OF_MONTH, 1);
    		int maxday= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    		Date fromDate=new Date(cal.getTimeInMillis());
    		cal.set(Calendar.DAY_OF_MONTH, maxday);
    		Date thruDate= cal.getTime();
    		
    		EntityCondition condition1= EntityCondition.makeCondition("fromDate",EntityOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(thruDate.getTime()));
    		EntityCondition condition2 = EntityCondition.makeCondition("thruDate",EntityOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(fromDate.getTime()));
    		EntityCondition condition21= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS, null);
    
    		EntityCondition condition22= EntityCondition.makeCondition(EntityOperator.OR,condition21,condition2);
    		
    		EntityCondition condition3 =EntityCondition.makeCondition("roleTypeIdFrom","INTERNAL_ORGANIZATIO");
    		EntityCondition condition4= EntityCondition.makeCondition("roleTypeIdTo","EMPLOYEE");
    		EntityCondition condition5= EntityCondition.makeCondition("partyIdFrom",finalDepartment);
    		
    		xcon.add(condition1);
    		xcon.add(condition22);
    		xcon.add(condition3);
    		xcon.add(condition4);
    		xcon.add(condition5);
    		/*--Begin get list enployee belong department---*/
    		EntityFindOptions find= new EntityFindOptions();
        	find.setDistinct(true);
        	Set<String> field= FastSet.newInstance();
        	field.add("partyIdTo");
        	List<GenericValue> partyList= delegator.findList("PartyRelationship", EntityCondition.makeCondition(xcon, EntityOperator.AND), field, null, find, false);
        	/*--End get list enployee belong department---*/
    		
        	/*--Begin get list party with role saleman ---*/
        	EntityCondition partyRoleConditon1= EntityCondition.makeCondition("roleTypeId","DELYS_SALESMAN_GT");
        	EntityCondition partyRoleConditon2= EntityCondition.makeCondition("roleTypeId","DELYS_SALESMAN_MT");
        	Set<String> partySelect= FastSet.newInstance();
        	partySelect.add("partyId");
        	List<GenericValue> partyRole= delegator.findList("PartyRole", EntityCondition.makeCondition(EntityOperator.OR, partyRoleConditon1, partyRoleConditon2), partySelect, null, find, false);
        	Map<String,Object> mapParyRole= new HashMap<String, Object>();
        	if(UtilValidate.isNotEmpty(partyRole)){
        		int i=0;
        		for(GenericValue prole:partyRole){
        			String partyId= prole.getString("partyId");
        			mapParyRole.put(partyId, i);
        			i++;
        		}
        	}
        	/*--/End get list party with role saleman ---*/
        	
    		/*--Begin get list product in dimension---*/
    		Set<String> select= FastSet.newInstance();
    		select.add("productId");
    		List<GenericValue> productList=delegator.findList("ProductDimension", null,select , null, null, false);
    		
    		Map<String, Object> mapProduct= new HashMap<String, Object>();
    		if(UtilValidate.isNotEmpty(productList)){
    			for(GenericValue product:productList){
    				mapProduct.put(product.getString("productId"), new BigDecimal(0));
    			}
    			
    		}
    		/*--End get list product in dimension---*/
    		
    		/*--Begin get list PersonName---*/
    		List<GenericValue> personList= delegator.findList("Person", null, null, null, null, false);
    		Map<String,Object> mapName= new HashMap<String, Object>();
    		if(UtilValidate.isNotEmpty(personList)){
    			for(GenericValue per:personList){
    				String partyId= per.getString("partyId");
    				String name="";
    				if(UtilValidate.isNotEmpty(per.getString("lastName"))){
    					name=per.getString("lastName");
    					if(UtilValidate.isNotEmpty(per.getString("middleName"))){
    						name= name+" "+per.getString("middleName")+" ";
    					}
    					if(UtilValidate.isNotEmpty(per.getString("firstName"))){
    						name=name+" "+per.getString("firstName");
    					}
    					
    				}
    				mapName.put(partyId, name);
    			}
    		}
    		/*--End get list PersonName---*/
    		
    		/*--Begin static total quanity productof employee---*/
        	if(UtilValidate.isNotEmpty(partyList)){
        		EntityCondition ordercon1= EntityCondition.makeCondition("orderDateDateValue",EntityOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(fromDate.getTime()));
    			EntityCondition ordercon2= EntityCondition.makeCondition("orderDateDateValue",EntityOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(thruDate.getTime()));
    			EntityCondition ordercon3 = EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
    			
    			Set<String> orderSelect= FastSet.newInstance();
    			orderSelect.add("orderId");
    			
    			for(GenericValue entry:partyList){
    				String partyId= entry.getString("partyIdTo");
    				if(mapParyRole.containsKey(partyId)){ //check if employee has role saleman
	        			EntityCondition ordercon4= EntityCondition.makeCondition("orderCreatedBy",partyId);
	        			
	        			List<GenericValue> oderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND, ordercon1, ordercon2, ordercon3,ordercon4), null, null, null, false);
	        			List<GenericValue> orderId = delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND, ordercon1, ordercon2, ordercon3,ordercon4), orderSelect, null, find, false); 
	        			
	        			BigDecimal grandTotal= new BigDecimal(0);
	    				Map<String, Object> mapResult= new HashMap<String, Object>();
	    	    		mapResult.putAll(mapProduct);
		    			if(UtilValidate.isNotEmpty(oderItem)){
		    				
		    				for(GenericValue item:oderItem){
		    					String productId= item.getString("productProductId");
		    					BigDecimal quantity = (BigDecimal) item.getBigDecimal("quantity");
		    					BigDecimal extGrossAmount = (BigDecimal) item.getBigDecimal("extGrossAmount");
		    					BigDecimal extTaxAmount= (BigDecimal)item.getBigDecimal("extTaxAmount");
		    					if(UtilValidate.isEmpty(extTaxAmount)){
		    						extTaxAmount= new BigDecimal(0);
		    					}
		    					if(UtilValidate.isEmpty(extGrossAmount)){
		    						
		    						extGrossAmount= new BigDecimal(0);
		    					}
	    						if(UtilValidate.isEmpty(quantity)){
		    						
	    							quantity= new BigDecimal(0);
		    					}
	    						
	    						BigDecimal total= extGrossAmount.add(extTaxAmount);
		    					grandTotal= grandTotal.add(total);
		    					if(mapResult.containsKey(productId)){
		    						
		    						BigDecimal quantiexist= (BigDecimal)mapResult.get(productId);
		    						BigDecimal itemTotalquantity= quantiexist.add(quantity);
		    						mapResult.put(productId, itemTotalquantity);
		    					}
		    				}
		    				
		    			}
		    			mapResult.put("totalOrder",new BigDecimal( orderId.size()));
		    			mapResult.put("grandTotal", grandTotal);
		    			mapResult.put("saleman", mapName.get(partyId));
		    			listIterator.add(mapResult);
	    			}
    			}
        		
        	}
        
    	}
    	
    	List<Map<String, Object>> listAllCondMap = CommonReportsServices.getListAllMap(listAllConditions);
		List<Map<String,Object>> listReturn=FastList.newInstance();
		if(UtilValidate.isNotEmpty(listAllCondMap)){
			listReturn=CommonReportsServices.fillerConditionProduct(listAllCondMap, listIterator);
		}else{
			listReturn=listIterator;
		}
		List<Map<String,Object>> xfinal= FastList.newInstance();
		String sortFiled = listSortFields.toString();
    	if(sortFiled.contains("[")){
    		sortFiled = sortFiled.replace("[", "");
    	}
    	if(sortFiled.contains("]")){
    		sortFiled = sortFiled.replace("]", "");
    	}
    	if(UtilValidate.isNotEmpty(sortFiled)){
    		xfinal =  CommonReportsServices.sortList(listReturn, sortFiled);
    	}else{
    		xfinal=listReturn;
    	}
    	
    	if(end > xfinal.size()){
    		end = xfinal.size();
    	}
    	totalRows = xfinal.size();
    	xfinal = xfinal.subList(start, end);
    	Map<String, Object> result= ServiceUtil.returnSuccess();
    	result.put("listIterator", xfinal);
    	result.put("TotalRows", String.valueOf(totalRows));
		 return result;
	 }
	
	 
	 public  static void getDataReportSalesOrderYear(HttpServletRequest request, HttpServletResponse respone) throws GenericEntityException{
	    	Delegator  delegator= (Delegator)request.getAttribute("delegator");
	    	String year= (String)request.getParameter("year");
	    	String department= (String)request.getParameter("department");
	    	List<Map<String,Object>> listIterator= FastList.newInstance();
	    	
	    	if(UtilValidate.isNotEmpty(year)&&UtilValidate.isNotEmpty(department)){
	    		Calendar cal= Calendar.getInstance();
	    		cal.set(Calendar.YEAR,Integer.parseInt(year));
	    		cal.set(Calendar.MONTH, 11);
	    		int maxDay= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	    		cal.set(Calendar.DAY_OF_MONTH, maxDay);
	    		Date thruDate= new Date(cal.getTimeInMillis());
	    		cal.set(Calendar.MONTH, 0);
	    		cal.set(Calendar.DAY_OF_MONTH, 1);
	    		Date fromDate= new Date(cal.getTimeInMillis());
	    		
	    		List<EntityCondition> xcon= FastList.newInstance();
	    		
	    		EntityCondition condition1= EntityCondition.makeCondition("fromDate",EntityOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(thruDate.getTime()));
	    		EntityCondition condition2 = EntityCondition.makeCondition("thruDate",EntityOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(fromDate.getTime()));
	    		EntityCondition condition21= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS, null);
	    		EntityCondition condition22= EntityCondition.makeCondition(EntityOperator.OR,condition21,condition2);
	    		
	    		EntityCondition condition3 =EntityCondition.makeCondition("roleTypeIdFrom","INTERNAL_ORGANIZATIO");
	    		EntityCondition condition4= EntityCondition.makeCondition("roleTypeIdTo","EMPLOYEE");
	    		EntityCondition condition5= EntityCondition.makeCondition("partyIdFrom",department);
	    		
	    		xcon.add(condition1);
	    		xcon.add(condition22);
	    		xcon.add(condition3);
	    		xcon.add(condition4);
	    		xcon.add(condition5);
	    		/*--Begin get list enployee belong department---*/
	    		EntityFindOptions find= new EntityFindOptions();
	        	find.setDistinct(true);
	        	Set<String> field= FastSet.newInstance();
	        	field.add("partyIdTo");
	        	List<GenericValue> partyList= delegator.findList("PartyRelationship", EntityCondition.makeCondition(xcon, EntityOperator.AND), field, null, find, false);
	        	/*--End get list enployee belong department---*/
	        	
	        	EntityCondition partyRoleConditon1= EntityCondition.makeCondition("roleTypeId","DELYS_SALESMAN_GT");
	        	EntityCondition partyRoleConditon2= EntityCondition.makeCondition("roleTypeId","DELYS_SALESMAN_MT");
	        	Set<String> partySelect= FastSet.newInstance();
	        	partySelect.add("partyId");
	        	List<GenericValue> partyRole= delegator.findList("PartyRole", EntityCondition.makeCondition(EntityOperator.OR, partyRoleConditon1, partyRoleConditon2), partySelect, null, find, false);
	        	Map<String,Object> mapParyRole= new HashMap<String, Object>();
	        	if(UtilValidate.isNotEmpty(partyRole)){
	        		int i=0;
	        		for(GenericValue prole:partyRole){
	        			String partyId= prole.getString("partyId");
	        			mapParyRole.put(partyId, i);
	        			i++;
	        		}
	        	}
	        	
	        	/*--Begin get list PersonName---*/
	    		List<GenericValue> personList= delegator.findList("Person", null, null, null, null, false);
	    		Map<String,Object> mapName= new HashMap<String, Object>();
	    		if(UtilValidate.isNotEmpty(personList)){
	    			for(GenericValue per:personList){
	    				String partyId= per.getString("partyId");
	    				String name="";
	    				if(UtilValidate.isNotEmpty(per.getString("lastName"))){
	    					name=per.getString("lastName");
	    					if(UtilValidate.isNotEmpty(per.getString("middleName"))){
	    						name= name+" "+per.getString("middleName")+" ";
	    					}
	    					if(UtilValidate.isNotEmpty(per.getString("firstName"))){
	    						name=name+" "+per.getString("firstName");
	    					}
	    					
	    				}
	    				mapName.put(partyId, name);
	    			}
	    		}
	    		/*--End get list PersonName---*/
	    		
	    		
	    		if(UtilValidate.isNotEmpty(partyList)){
	        		EntityCondition ordercon1= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year));
	    			EntityCondition ordercon2 = EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
	    			
	    			for(GenericValue entry:partyList){
	    				String partyId= entry.getString("partyIdTo");
	    				BigDecimal total[] = new BigDecimal[12];
	    				for(int i=0;i<total.length;i++){
	    					total[i]= new BigDecimal(0);
	    				}
	    				if(mapParyRole.containsKey(partyId)){
	    					EntityCondition ordercon3= EntityCondition.makeCondition("orderCreatedBy",partyId);
	    					List<GenericValue> oderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND, ordercon1, ordercon2, ordercon3), null, null, null, false);
	    					if(UtilValidate.isNotEmpty(oderItem)){
	    						for(GenericValue item:oderItem){
	    							Long monthOrder= item.getLong("orderDateMonthOfYear");
	    							int monint=0;
	    							if(monthOrder!=null){
	    								monint= monthOrder.intValue();
	    							}
	    							BigDecimal extGrossAmount = (BigDecimal) item.getBigDecimal("extGrossAmount");
	    							BigDecimal extTaxAmount = (BigDecimal) item.getBigDecimal("extTaxAmount");
			    					if(UtilValidate.isEmpty(extGrossAmount)){
			    						
			    						extGrossAmount= new BigDecimal(0);
			    					} 
			    					
		    						if(UtilValidate.isEmpty(extTaxAmount)){
			    						
		    							extTaxAmount= new BigDecimal(0);
			    					} 
			    					BigDecimal exNetMount= extGrossAmount.add(extTaxAmount);
	    							if(monint>0){
	    								total[monint-1]=total[monint-1].add(exNetMount);
	    							}
	    						}
	    					}
	    					Map<String, Object> result= new HashMap<String,Object>();
		    				result.put("name",mapName.get(partyId));
		    				result.put("data", total);
		    				listIterator.add(result);
	    				}
	    				
	    			}
	    		
	    		}
	    	}
	    	
	    	CommonReportsServices.toJsonObjectList(listIterator, respone);
	    }
	 
	 public static Map<String,Object>JQxSalesOrderProducts(DispatchContext dpcx, Map<String, ?extends Object>context) throws ParseException, GenericEntityException{
		Delegator delegator = dpcx.getDelegator();
		Map<String, String[]> parameters= (Map<String,String[]>)context.get("parameters");
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	HttpServletRequest request = (HttpServletRequest) context.get("request");
		HttpSession session = request.getSession();
		
		int pagesize = Integer.parseInt(parameters.get("pagesize")[0]);
	    int pageNum = Integer.parseInt(parameters.get("pagenum")[0]);
	    int start = pagesize * pageNum;
	    int end = start + pagesize;
	    int totalRows = 0;
		
    	List<Map<String,Object>> listIterator= FastList.newInstance();
		 
    	String typeReport[]= parameters.get("typeReport");
    	String chanelReport[]=parameters.get("chanelReport");
    	String typeTime[]=parameters.get("typeTime");
    	//defaut for first load
    	String commonTypeReport[]= parameters.get("commonTypeReport");
    	String commonChanelReport[]=parameters.get("commonChanelReport");
    	String commonTypeTime[]=parameters.get("commonTypeTime");
    	String commonYear[]=parameters.get("commonYear");
    	
    	String month="";
    	String year="";
    	String quater="";
    	String fromDate="";
    	String thruDate="";
    	String typeTimeFinal="";
    	String typeReportFinal="";
    	String chanelReportFinal="";
    	String roleTypeField="";
    	SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");
    	if(UtilValidate.isNotEmpty(typeReport)&&UtilValidate.isNotEmpty(chanelReport)&&UtilValidate.isNotEmpty(typeTime)){
    		session.setAttribute("typeReport", typeReport[0]);
    		session.setAttribute("chanelReport", chanelReport[0]);
    		session.setAttribute("typeTime", typeTime[0]);
    		
    		typeTimeFinal=typeTime[0];
    		typeReportFinal=typeReport[0];
    		chanelReportFinal=chanelReport[0];
			if("MONTH".equals(typeTimeFinal)){
				
				session.removeAttribute("fromDate");
        		session.removeAttribute("thruDate");
        		session.removeAttribute("quater");
        		
		        year=(String)parameters.get("year")[0];
		        month=(String)parameters.get("month")[0];
		        session.setAttribute("year", year);
		        session.setAttribute("month", month);
        	}else if("YEAR".equals(typeTimeFinal)){
        		session.removeAttribute("fromDate");
        		session.removeAttribute("thruDate");
        		session.removeAttribute("month");
        		session.removeAttribute("quater");
        		
    			year=(String)parameters.get("year")[0];
			    session.setAttribute("year", year);
        	}else if("QUATER".equals(typeTimeFinal)){
        		session.removeAttribute("fromDate");
        		session.removeAttribute("thruDate");
        		session.removeAttribute("month");
        		
    			quater=(String)parameters.get("quater")[0];
    			year=(String)parameters.get("year")[0];
    			session.setAttribute("year", year);
 		        session.setAttribute("quater", quater);
        	}else if("DATE".equals(typeTimeFinal)){
        		
        		session.removeAttribute("quater");
        		session.removeAttribute("year");
        		session.removeAttribute("month");
        		
        		fromDate=(String)parameters.get("fromDate")[0];
        		thruDate=(String)parameters.get("thruDate")[0];
        		session.setAttribute("fromDate", year);
 		        session.setAttribute("thruDate", quater);
        	}
    		
    	}else if(UtilValidate.isNotEmpty(session.getAttribute("typeReport"))&&UtilValidate.isNotEmpty(session.getAttribute("chanelReport"))&&UtilValidate.isNotEmpty("typeTime")){
    		typeTimeFinal=(String)session.getAttribute("typeTime");
    		typeReportFinal=(String)session.getAttribute("typeReport");
    		chanelReportFinal=(String)session.getAttribute("chanelReport");
    		
    		if("MONTH".equals(typeTimeFinal)){
    			month= (String)session.getAttribute("month");
    			year=(String)session.getAttribute("year");
        	}else if("YEAR".equals(typeTimeFinal)){
        		year=(String)session.getAttribute("year");
        	}else if("QUATER".equals(typeTimeFinal)){
    			quater=(String)session.getAttribute("quater");
    			year=(String)session.getAttribute("year");
        	}else if("DATE".equals(typeTimeFinal)){
        		
        		fromDate=(String)session.getAttribute("fromDate");
        		thruDate=(String)session.getAttribute("thruDate");
        	}
    	}else if(UtilValidate.isNotEmpty(commonTypeReport)&&UtilValidate.isNotEmpty(commonChanelReport)&&UtilValidate.isNotEmpty(commonTypeTime)&&UtilValidate.isNotEmpty(commonYear)){
    		session.setAttribute("typeReport", commonTypeReport[0]);
    		session.setAttribute("chanelReport", commonChanelReport[0]);
    		session.setAttribute("typeTime", commonTypeTime[0]);
    		
    		typeTimeFinal=commonTypeTime[0];
    		typeReportFinal=commonTypeReport[0];
    		chanelReportFinal=commonChanelReport[0];
    		
    		
    		session.removeAttribute("fromDate");
    		session.removeAttribute("thruDate");
    		session.removeAttribute("month");
    		session.removeAttribute("quater");
    		
			year=commonYear[0];
		    session.setAttribute("year", year);
    		
    	}
    	
    	
    	if(UtilValidate.isNotEmpty(typeTimeFinal)&&UtilValidate.isNotEmpty(typeReportFinal)&&UtilValidate.isNotEmpty(chanelReportFinal)){
    		List<EntityCondition> parentConditon= FastList.newInstance();
    		if("MONTH".equals(typeTimeFinal)){
    			EntityCondition con1= EntityCondition.makeCondition("orderDateYearName",Long.parseLong(year));
    			EntityCondition con2=EntityCondition.makeCondition("orderDateMonthOfYear",Long.parseLong(month));
    			parentConditon.add(con1);
    			parentConditon.add(con2);
        	}else if("YEAR".equals(typeTimeFinal)){
        		EntityCondition con1=EntityCondition.makeCondition("orderDateYearName",Long.parseLong(year));
        		parentConditon.add(con1);
        	}else if("QUATER".equals(typeTimeFinal)){
        		EntityCondition con1= EntityCondition.makeCondition("orderDateQuarterOfYear",Long.parseLong(quater));
    			EntityCondition con2=EntityCondition.makeCondition("orderDateYearName",Long.parseLong(year));
    			parentConditon.add(con1);
    			parentConditon.add(con2);
        		
        	}else if("DATE".equals(typeTimeFinal)){
        		if(UtilValidate.isNotEmpty(fromDate)){
        			Date fromDateFm= yearMonthDayFormat.parse(fromDate);
        			EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(fromDateFm.getTime()));
        			parentConditon.add(condition1);
        		}
        		
        		if(UtilValidate.isNotEmpty(thruDate)){
        			Date thruDateFm= yearMonthDayFormat.parse(thruDate);
        			EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(thruDateFm.getTime()));
        			parentConditon.add(condition1);
        		}
        	}
    		EntityCondition complete= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
    		parentConditon.add(complete);
    		EntityCondition condition= EntityCondition.makeCondition(parentConditon,EntityOperator.AND);
    		
    		if("SALES_IN".equals(typeReportFinal)){
    			roleTypeField="placingCustomer";
    		}else if("SALES_OUT".equals(typeReportFinal)){
    			roleTypeField="billFromVendor";
    		}
    		EntityCondition salesGT= EntityCondition.makeCondition("roleTypeIdFrom","DELYS_SALESSUP_GT");
    		EntityCondition salesMT= EntityCondition.makeCondition("roleTypeIdFrom","DELYS_SALESSUP_MT");
    		EntityCondition disCon= EntityCondition.makeCondition("roleTypeIdTo","DELYS_DISTRIBUTOR");
    		Set<String> fieldSelect= FastSet.newInstance();
    		fieldSelect.add("partyIdTo");
    		EntityFindOptions findOption= new EntityFindOptions();
    		findOption.setDistinct(true);
    		List<GenericValue> distributorGT= delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityOperator.AND,salesGT,disCon), fieldSelect, null, findOption, false);
    		List<GenericValue> distributorMT= delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityOperator.AND,salesMT,disCon), fieldSelect, null, findOption, false);
    		
    		Set<String> select= FastSet.newInstance();
    		select.add("productId");
    		List<GenericValue> productList=delegator.findList("ProductDimension", null,select , null, null, false);
    		
    		Map<String, Object> mapProduct= new HashMap<String, Object>();
    		if(UtilValidate.isNotEmpty(productList)){
    			for(GenericValue product:productList){
    				Map<String, Object> mapTotal= new HashMap<String, Object>();
    				mapTotal.put("quantity", new BigDecimal(0));
    				mapTotal.put("grandTotal", new BigDecimal(0));
    				if(UtilValidate.isNotEmpty(product.getString("internalName"))){
    					mapTotal.put("name", product.getString("internalName"));
    				}else{
    					mapTotal.put("name", product.getString("productId"));
    				}
    				
    				mapProduct.put(product.getString("productId"), mapTotal);
    			}
    			
    		}
    		
    		Map<String,Object> mapGT= new HashMap<String, Object>();
    		mapGT.putAll(mapProduct);
    		Map<String,Object> mapMT= new HashMap<String, Object>();
    		mapMT.putAll(mapProduct);
    		Map<String,Object> mapAll= new HashMap<String, Object>();
    		mapAll.putAll(mapProduct);
    		
    		
    		if(UtilValidate.isNotEmpty(distributorGT)){
    			List<EntityCondition> partyCondition= FastList.newInstance();
    			for(GenericValue entryGT:distributorGT){
    				String partyId= entryGT.getString("partyIdTo");
    				EntityCondition cond= EntityCondition.makeCondition(roleTypeField, partyId);
    				partyCondition.add(cond);
    			}
    			EntityCondition joinCondtion= EntityCondition.makeCondition(partyCondition,EntityOperator.OR);
    			List<GenericValue> orderGT= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND,joinCondtion,condition), null, null, null, false);
    			if(UtilValidate.isNotEmpty(orderGT)){
    				for(GenericValue entryOrderGT:orderGT){
    					String productId= entryOrderGT.getString("productProductId");
    					BigDecimal quantity = (BigDecimal) entryOrderGT.getBigDecimal("quantity");
    					BigDecimal extGrossAmount = (BigDecimal) entryOrderGT.getBigDecimal("extGrossAmount");
    					BigDecimal exTaxAmount=(BigDecimal) entryOrderGT.getBigDecimal("extTaxAmount");
    					BigDecimal realTotal= new BigDecimal(0);
    					if(UtilValidate.isEmpty(exTaxAmount)){
    						
    						exTaxAmount= new BigDecimal(0);
    					}
    					
    					if(UtilValidate.isEmpty(extGrossAmount)){
    						
    						extGrossAmount= new BigDecimal(0);
    					}
						if(UtilValidate.isEmpty(quantity)){
    						
							quantity= new BigDecimal(0);
    					}
						if("SALES_OUT".equals(typeReportFinal)){
							realTotal= extGrossAmount.add(exTaxAmount);
						}else{
							realTotal=extGrossAmount;
						}
						
						if(mapGT.containsKey(productId)){
							//map GT
							Map<String,Object> mapValue= new HashMap<String, Object>();
							mapValue= (Map<String,Object>)mapGT.get(productId);
							mapGT.remove(productId);
							
							String name =(String)mapValue.get("name");
							BigDecimal quantityHad= (BigDecimal)mapValue.get("quantity");
							BigDecimal grandTotal=(BigDecimal)mapValue.get("grandTotal");
							BigDecimal xquan= new BigDecimal(0);
							BigDecimal xgrand= new BigDecimal(0);
							
							Map<String,Object> tempMap= new HashMap<String, Object>();
							xquan= quantity.add(quantityHad);
							xgrand= grandTotal.add(realTotal);
							tempMap.put("quantity", xquan);
							tempMap.put("grandTotal", xgrand);
							tempMap.put("name", name);
							
							mapGT.put(productId, tempMap);
							
							//map all
							
							Map<String,Object> mapValueAll= new HashMap<String, Object>();
							mapValueAll= (Map<String,Object>)mapAll.get(productId);
							mapAll.remove(productId);
							
							BigDecimal quantityHadAll= (BigDecimal)mapValueAll.get("quantity");
							BigDecimal grandTotalAll=(BigDecimal)mapValueAll.get("grandTotal");
							BigDecimal allquanti= new BigDecimal(0);
							BigDecimal allgrand= new BigDecimal(0);
							allquanti= quantityHadAll.add(quantity);
							allgrand=grandTotalAll.add(realTotal);
							Map<String,Object> tempAll= new HashMap<String, Object>();
							
							tempAll.put("quantity", allquanti);
							tempAll.put("grandTotal", allgrand);
							tempAll.put("name", name);
							
							mapAll.put(productId, tempAll);
						}
    				}
    			}
    		
    		}
    		// caculator for MT
    		
    		if(UtilValidate.isNotEmpty(distributorMT)){
    			List<EntityCondition> partyCondition= FastList.newInstance();
    			for(GenericValue entryMT:distributorMT){
    				String partyId= entryMT.getString("partyIdTo");
    				EntityCondition cond= EntityCondition.makeCondition(roleTypeField, partyId);
    				partyCondition.add(cond);
    			}
    			EntityCondition joinCondtion= EntityCondition.makeCondition(EntityOperator.OR, partyCondition);
    			List<GenericValue> orderMT= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND,joinCondtion,condition), null, null, null, false);
    			if(UtilValidate.isNotEmpty(orderMT)){
    				for(GenericValue entryOrderMT:orderMT){
    					String productId= entryOrderMT.getString("productProductId");
    					BigDecimal quantity = (BigDecimal) entryOrderMT.getBigDecimal("quantity");
    					BigDecimal extGrossAmount = (BigDecimal) entryOrderMT.getBigDecimal("extGrossAmount");
    					BigDecimal exTaxAmount=(BigDecimal) entryOrderMT.getBigDecimal("extTaxAmount");
    					BigDecimal realTotal= new BigDecimal(0);
    					if(UtilValidate.isEmpty(exTaxAmount)){
    						
    						exTaxAmount= new BigDecimal(0);
    					}
    					if(UtilValidate.isEmpty(extGrossAmount)){
    						
    						extGrossAmount= new BigDecimal(0);
    					}
						if(UtilValidate.isEmpty(quantity)){
    						
							quantity= new BigDecimal(0);
    					}
						if("SALES_OUT".equals(typeReportFinal)){
							realTotal= extGrossAmount.add(exTaxAmount);
						}else{
							realTotal=extGrossAmount;
						}
						if(mapMT.containsKey(productId)){
							//map GT
							Map<String,Object> mapValue= new HashMap<String, Object>();
							mapValue= (Map<String,Object>)mapMT.get(productId);
							mapMT.remove(productId);
							
							String name =(String)mapValue.get("name");
							BigDecimal quantityHad= (BigDecimal)mapValue.get("quantity");
							BigDecimal grandTotal=(BigDecimal)mapValue.get("grandTotal");
							BigDecimal xquan= new BigDecimal(0);
							BigDecimal xgrand= new BigDecimal(0);
							
							Map<String,Object> tempMap= new HashMap<String, Object>();
							xquan= quantity.add(quantityHad);
							xgrand= grandTotal.add(realTotal);
							tempMap.put("quantity", xquan);
							tempMap.put("grandTotal", xgrand);
							tempMap.put("name", name);
							
							mapMT.put(productId, tempMap);
							
							//map all
							
							Map<String,Object> mapValueAll= new HashMap<String, Object>();
							mapValueAll= (Map<String,Object>)mapAll.get(productId);
							mapAll.remove(productId);
							
							BigDecimal quantityHadAll= (BigDecimal)mapValueAll.get("quantity");
							BigDecimal grandTotalAll=(BigDecimal)mapValueAll.get("grandTotal");
							BigDecimal allquanti= new BigDecimal(0);
							BigDecimal allgrand= new BigDecimal(0);
							allquanti= quantityHadAll.add(quantity);
							allgrand=grandTotalAll.add(realTotal);
							Map<String,Object> tempAll= new HashMap<String, Object>();
							
							tempAll.put("quantity", allquanti);
							tempAll.put("grandTotal", allgrand);
							tempAll.put("name", name);
							
							mapAll.put(productId, tempAll);
						}
    				}
    			}
    		
    		}
    		if("SALES_ALL".equals(chanelReportFinal)){
    			Iterator<String> keyset = mapAll.keySet().iterator();
    			while(keyset.hasNext()){
    				String key= keyset.next();
    				Map<String, Object> value= (Map<String,Object>)mapAll.get(key);
    				listIterator.add(value);
    			}
    		}else if("SALES_GT".equals(chanelReportFinal)){
    			Iterator<String> keyset = mapGT.keySet().iterator();
    			while(keyset.hasNext()){
    				String key= keyset.next();
    				Map<String, Object> value= (Map<String,Object>)mapGT.get(key);
    				listIterator.add(value);
    			}
    		}else if("SALES_MT".equals(chanelReportFinal)){
    			Iterator<String> keyset = mapMT.keySet().iterator();
    			while(keyset.hasNext()){
    				String key= keyset.next();
    				Map<String, Object> value= (Map<String,Object>)mapMT.get(key);
    				listIterator.add(value);
    			}
    		}
    		
    		
    	}
    	
    	List<Map<String, Object>> listAllCondMap = CommonReportsServices.getListAllMap(listAllConditions);
		List<Map<String,Object>> listReturn=FastList.newInstance();
		if(UtilValidate.isNotEmpty(listAllCondMap)){
			listReturn=CommonReportsServices.fillerConditionProduct(listAllCondMap, listIterator);
		}else{
			listReturn=listIterator;
		}
		List<Map<String,Object>> xfinal= FastList.newInstance();
		String sortFiled = listSortFields.toString();
    	if(sortFiled.contains("[")){
    		sortFiled = sortFiled.replace("[", "");
    	}
    	if(sortFiled.contains("]")){
    		sortFiled = sortFiled.replace("]", "");
    	}
    	if(UtilValidate.isNotEmpty(sortFiled)){
    		xfinal =  CommonReportsServices.sortList(listReturn, sortFiled);
    	}else{
    		xfinal=listReturn;
    	}
    	
    	if(end > xfinal.size()){
    		end = xfinal.size();
    	}
    	totalRows = xfinal.size();
    	xfinal = xfinal.subList(start, end);
    	Map<String, Object> result= ServiceUtil.returnSuccess();
    	result.put("listIterator", xfinal);
    	result.put("TotalRows", String.valueOf(totalRows));
    	
		 return result;
	 }
	 
	 public static Map<String,Object>getDataChartProductOrder(DispatchContext dcpt, Map<String,?extends Object> context) throws ParseException, GenericEntityException{
		 Delegator delegator= dcpt.getDelegator();
		 String typeReport= (String)context.get("typeReport");
		 String typeTime=(String)context.get("typeTime");
		 List<EntityCondition> conTime= FastList.newInstance();
		 ArrayList<Map<String,Object>> chanelSale= new ArrayList<Map<String,Object>>();
		 Map<String, Object> chanelGT= new HashMap<String, Object>();
		 Map<String, Object> chanelMT= new HashMap<String, Object>();
		 
		 chanelGT.put("name", "GT chanel");
		 chanelGT.put("drilldown", "GT");
		 chanelGT.put("visible", true);
		 chanelGT.put("y", 0);
		 
		 chanelMT.put("name", "MT chanel");
		 chanelMT.put("drilldown", "MT");
		 chanelMT.put("visible", true);
		 chanelMT.put("y", 0);
		 
		 ArrayList<Map<String,Object>> drillDowArray= new ArrayList<Map<String,Object>>();
 		 Map<String, Object> drillGT= new HashMap<String, Object>();
 		 Map<String,Object> drillMT= new HashMap<String, Object>();
 		 drillGT.put("name", "GT");
 		 drillGT.put("id", "GT");
 		 drillGT.put("data", "");
 		
 		 drillMT.put("name", "MT");
    	 drillMT.put("id", "MT");
		 drillMT.put("data", "");
 		
 		
		 if(UtilValidate.isNotEmpty(typeTime)&&UtilValidate.isNotEmpty(typeReport)){
			 if("DATE".equals(typeTime)){
				 SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");
				 String fromDate= (String)context.get("fromDate");
				 String thruDate= (String)context.get("thruDate");
				 if(UtilValidate.isNotEmpty(fromDate)){
					 Date xfromDate= yearMonthDayFormat.parse(fromDate);
					 EntityCondition con1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(xfromDate.getTime()));
					 conTime.add(con1);
				 }
				 
				 if(UtilValidate.isNotEmpty(thruDate)){
					 Date xthruDate= yearMonthDayFormat.parse(thruDate);
					 EntityCondition con2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(xthruDate.getTime()));
					 conTime.add(con2);
				 }
			 }else if("MONTH".equals(typeTime)){
				 	
				 	String year= (String)context.get("year");
				 	String month= (String)context.get("month");
				 	if(UtilValidate.isNotEmpty(year)&&UtilValidate.isNotEmpty(month)){
				 		EntityCondition con1= EntityCondition.makeCondition("orderDateYearName",Long.parseLong(year));
		    			EntityCondition con2=EntityCondition.makeCondition("orderDateMonthOfYear",Long.parseLong(month));
		    			conTime.add(con1);
		    			conTime.add(con2);
				 	}
				 	
			 }else if("YEAR".equals(typeTime)){
				 String year= (String)context.get("year");
				 if(UtilValidate.isNotEmpty(year)){
					 EntityCondition con1= EntityCondition.makeCondition("orderDateYearName",Long.parseLong(year));
					 conTime.add(con1);
				 }
			 }else if("QUARTER".equals(typeTime)){
				 String quarter= (String)context.get("quarter");
				 String year=(String)context.get("year");
				 if(UtilValidate.isNotEmpty(quarter)&&UtilValidate.isNotEmpty(year)){
					 EntityCondition con1= EntityCondition.makeCondition("orderDateQuarterOfYear",Long.parseLong(quarter));
					 EntityCondition con2=EntityCondition.makeCondition("orderDateYearName",Long.parseLong(year));
					 conTime.add(con1);
					 conTime.add(con2);
				 }
			 }
			 
			 EntityCondition complete= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
			 conTime.add(complete);
			 EntityCondition condition= EntityCondition.makeCondition(conTime,EntityOperator.AND);
			 String roleTypeField="";
			 if("SALES_IN".equals(typeReport)){
    			roleTypeField="placingCustomer";
    		}else if("SALES_OUT".equals(typeReport)){
    			roleTypeField="billFromVendor";
    		}
    		EntityCondition salesGT= EntityCondition.makeCondition("roleTypeIdFrom","DELYS_SALESSUP_GT");
    		EntityCondition salesMT= EntityCondition.makeCondition("roleTypeIdFrom","DELYS_SALESSUP_MT");
    		EntityCondition disCon= EntityCondition.makeCondition("roleTypeIdTo","DELYS_DISTRIBUTOR");
    		
    		Set<String> fieldSelect= FastSet.newInstance();
    		fieldSelect.add("partyIdTo");
    		EntityFindOptions findOption= new EntityFindOptions();
    		findOption.setDistinct(true);
    		
    		List<GenericValue> distributorGT= delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityOperator.AND,salesGT,disCon), fieldSelect, null, findOption, false);
    		List<GenericValue> distributorMT= delegator.findList("PartyRelationship", EntityCondition.makeCondition(EntityOperator.AND,salesMT,disCon), fieldSelect, null, findOption, false);
    		BigDecimal extGT= new BigDecimal(0);
    		BigDecimal extMT= new BigDecimal(0);
    		BigDecimal extTotal= new BigDecimal(0);
    		
    		
    		
    		List<GenericValue> groupList= delegator.findList("PartyGroup", null, null, null, null, false);
    		Map<String,Object> mapName= new HashMap<String, Object>();
    		if(UtilValidate.isNotEmpty(groupList)){
    			for(GenericValue per:groupList){
    				String partyId= per.getString("partyId");
    				String name="";
					name=per.getString("groupName");
    				mapName.put(partyId, name);
    			}
    		}
    		Map<String,Object> mapGT= new HashMap<String, Object>();
    		Map<String,Object> mapMT= new HashMap<String, Object>();
    		
    		if(UtilValidate.isNotEmpty(distributorGT)){
    			for(GenericValue entryGT:distributorGT){
    				BigDecimal exDistri= new BigDecimal(0);
    				
    				String partyId= entryGT.getString("partyIdTo");
    				EntityCondition cond= EntityCondition.makeCondition(roleTypeField, partyId);
        			List<GenericValue> orderGT= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND,cond,condition), null, null, null, false);
        			if(UtilValidate.isNotEmpty(orderGT)){
        				for(GenericValue entryOrderGT:orderGT){
        					BigDecimal extGrossAmount = (BigDecimal) entryOrderGT.getBigDecimal("extGrossAmount");
        					BigDecimal exTaxAmount=(BigDecimal)entryOrderGT.getBigDecimal("extTaxAmount");
        					BigDecimal extRealTotal= new BigDecimal(0);
        					
        					if(UtilValidate.isEmpty(extGrossAmount)){
        						extGrossAmount= new BigDecimal(0);
        					}
        					if(UtilValidate.isEmpty(exTaxAmount)){
        						exTaxAmount= new BigDecimal(0);
        					}
        					if("SALES_OUT".equals(typeReport)){
        						extRealTotal=extGrossAmount.add(exTaxAmount);
        					}else{
        						extRealTotal=extGrossAmount;
        					}
        					extGT=extGT.add(extRealTotal);
        					exDistri= exDistri.add(extRealTotal);
						}
    				}
    				mapGT.put(partyId, exDistri);
    			}
    			
			}
    		
    		
    		
    		if(UtilValidate.isNotEmpty(distributorMT)){
    			for(GenericValue entryGT:distributorMT){
    				BigDecimal exDistri= new BigDecimal(0);
    				
    				String partyId= entryGT.getString("partyIdTo");
    				EntityCondition cond= EntityCondition.makeCondition(roleTypeField, partyId);
        			List<GenericValue> orderMT= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityOperator.AND,cond,condition), null, null, null, false);
        			if(UtilValidate.isNotEmpty(orderMT)){
        				for(GenericValue entryOrderMT:orderMT){
        					BigDecimal extGrossAmount = (BigDecimal) entryOrderMT.getBigDecimal("extGrossAmount");
        					BigDecimal exTaxAmount=(BigDecimal)entryOrderMT.getBigDecimal("extTaxAmount");
        					BigDecimal extRealTotal= new BigDecimal(0);
        					
        					if(UtilValidate.isEmpty(extGrossAmount)){
        						extGrossAmount= new BigDecimal(0);
        					}
        					if(UtilValidate.isEmpty(exTaxAmount)){
        						exTaxAmount= new BigDecimal(0);
        					}
        					if("SALES_OUT".equals(typeReport)){
        						extRealTotal=extGrossAmount.add(exTaxAmount);
        					}else{
        						extRealTotal=extGrossAmount;
        					}
        					extMT=extMT.add(extRealTotal);
        					exDistri= exDistri.add(extRealTotal);
						}
    				}
    				mapMT.put(partyId, exDistri);
    			}
    			
			}
    	//caculator grandTotal GT and MT	
    	extTotal= extGT.add(extMT);	
    	
    	ArrayList<Object[]> dataGT= new ArrayList<Object[]>();
    	ArrayList<Object[]> dataMT= new ArrayList<Object[]>();
    	//load MapGT
    	
    	
    	Iterator<String> keysetGT = mapGT.keySet().iterator();
		while(keysetGT.hasNext()){
			String key= keysetGT.next();
			BigDecimal exdis=(BigDecimal)mapGT.get(key);
			Object[] value= new Object[2];
			value[0]=mapName.get(key);
			if(extGT.compareTo(BigDecimal.ZERO) > 0){
				value[1]=exdis.divide(extGT,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
			}else{
				value[1]=0;
			}
			
			dataGT.add(value);
		}	
		
		// load mapMT
		Iterator<String> keysetMT = mapMT.keySet().iterator();
		while(keysetMT.hasNext()){
			String key= keysetGT.next();
			BigDecimal exdis=(BigDecimal)mapMT.get(key);
			Object[] value= new Object[2];
			value[0]=mapName.get(key);
			if(extMT.compareTo(BigDecimal.ZERO) > 0){
				value[1]=exdis.divide(extMT,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
			}else{
				value[1]=0;
			}
			
			dataMT.add(value);
		}	
		
		drillGT.put("data", dataGT);
		drillMT.put("data", dataMT);
		 if(extTotal.compareTo(BigDecimal.ZERO)>0){
			 chanelGT.put("y", extGT.divide(extTotal,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
			 chanelMT.put("y", extMT.divide(extTotal,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100)));
		 }else{
			 chanelGT.put("y",0);
			 chanelMT.put("y",0);
		 }
		}
	  
	  drillDowArray.add(drillMT);
	  drillDowArray.add(drillGT);
	  chanelSale.add(chanelMT);
	  chanelSale.add(chanelGT);
	  
	  Map<String,Object> result= ServiceUtil.returnSuccess();
	  result.put("chanelSales", chanelSale);
	  result.put("drillChanelSales", drillDowArray);
		 return result;
	 }
}
