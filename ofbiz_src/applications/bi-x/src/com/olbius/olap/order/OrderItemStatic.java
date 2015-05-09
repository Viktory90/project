package com.olbius.olap.order;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.util.FastList;
import javolution.util.FastSet;

import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class OrderItemStatic {
	public static final String module = OrderItemStatic.class.getName();
	public  static Map<String,Object> OrderItemStaticWithRole(DispatchContext dcpx, Map<String, ?extends Object> context ) throws Exception{
		Delegator delegator= dcpx.getDelegator();
		GenericValue userLogin=(GenericValue)context.get("userLogin");
		String partyIdLogin= userLogin.getString("partyId");
		
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	
    	String department= CommonInternal.getOrgByManager(userLogin, delegator);
		List<String> listDistributor=  FastList.newInstance();
		List<String> listDepartment= FastList.newInstance();
		if(CommonInternal.hasRole("SALES_ADMIN", partyIdLogin, delegator)){
			listDepartment.add("NBD");
		}else if(UtilValidate.isNotEmpty(department)){
			listDepartment.add(department);
			
		}
		listDistributor=CommonInternal.getAllDepartmentChildWithRoleAndRoot(listDepartment, "DELYS_DISTRIBUTOR", delegator);
    	List<String> listRole=FastList.newInstance();

    	listRole.add("DELYS_NBD");
    	
    	listRole.add("DELYS_CSM_GT");
    	listRole.add("DELYS_RSM_GT");
    	listRole.add("DELYS_ASM_GT");
    	listRole.add("DELYS_SALESSUP_GT");
    	
    	listRole.add("DELYS_CSM_MT");
    	listRole.add("DELYS_RSM_MT");
    	listRole.add("DELYS_ASM_MT");
    	listRole.add("DELYS_SALESSUP_MT");
    	
    	listRole.add("DELYS_DISTRIBUTOR");
    	
		RelationshipDepartmentProduct  abc=  CommonInternal.getRelationDepartment(listRole,"ASM_GT_HANOI", "DELYS_DISTRIBUTOR", delegator);
		abc.calculatorSalesIn("", "", delegator);
		successResult.put("result", listDistributor);
    	return successResult;
	}
	
	public static void getDataSaleInWithRole(HttpServletRequest request, HttpServletResponse response) throws Exception{
		Delegator delegator= (Delegator)request.getAttribute("delegator");
		HttpSession session = request.getSession();
        GenericValue userLogin = (GenericValue) session.getAttribute("userLogin");
		
		String fromDate= (String)request.getParameter("fromDate");
		String thruDate= (String)request.getParameter("thruDate");
		
		String partyIdLogin= userLogin.getString("partyId");
		RelationshipDepartmentProduct  origin= new RelationshipDepartmentProduct(delegator);
		String department=null;
		if(CommonInternal.hasRole("SALES_ADMIN", partyIdLogin, delegator)){
			department="NBD";
		}else if(CommonInternal.hasRole("DELYS_DISTRIBUTOR", partyIdLogin, delegator)){
			department=partyIdLogin;
			
		}else{
			department=CommonInternal.getOrgByManager(userLogin, delegator);
		}
		
		List<String> listRole=FastList.newInstance();

    	listRole.add("DELYS_NBD");
    	
    	listRole.add("DELYS_CSM_GT");
    	listRole.add("DELYS_RSM_GT");
    	listRole.add("DELYS_ASM_GT");
    	listRole.add("DELYS_SALESSUP_GT");
    	
    	listRole.add("DELYS_CSM_MT");
    	listRole.add("DELYS_RSM_MT");
    	listRole.add("DELYS_ASM_MT");
    	listRole.add("DELYS_SALESSUP_MT");
    	
    	listRole.add("DELYS_DISTRIBUTOR");
		
    	ArrayList<Map<String,Object>> result= new ArrayList<Map<String,Object>>();
    	
		if(UtilValidate.isNotEmpty(department)){
			origin =  CommonInternal.getRelationDepartment(listRole,department, "DELYS_DISTRIBUTOR", delegator);
		
			origin.calculatorSalesIn(fromDate, thruDate, delegator);
			origin.setValueForAllChild();
			
			Map<String, Object> value= origin.getMapProduct();
			value.put("id", origin.getPartyId());
			value.put("grandTotal", origin.getGrandTotal());
			value.put("name", origin.getName());
			value.put("expanded", true);
			value.put("parentId", origin.getParentId());
			
			result=  getAllChild(origin, delegator);
			
			result.add(value);
			
		}
		
		CommonReportsServices.toJsonObjectList(result, response);
		
	}
	
	public static ArrayList<Map<String,Object>> getAllChild(RelationshipDepartmentProduct obj,Delegator delegator) throws GenericEntityException, ParseException{
		List<RelationshipDepartmentProduct> child= obj.getChildRd();
		ArrayList<Map<String,Object>> total= new ArrayList<Map<String,Object>>(); 
		if(UtilValidate.isNotEmpty(child)){
			for(RelationshipDepartmentProduct item:child){
				Map<String, Object> value= item.getMapProduct();
				value.put("id", item.getPartyId());
				value.put("grandTotal", item.getGrandTotal());
				value.put("name", item.getName());
				value.put("expanded", true);
				value.put("parentId", item.getParentId());
				total.add(value);
				
				ArrayList<Map<String,Object>> temp= new ArrayList<Map<String,Object>>();
				temp=getAllChild(item, delegator);
				
				if(UtilValidate.isNotEmpty(temp)){
					total.addAll(temp);
				}
				
			}
			
		}
		
		return total;
	}
	
	public Map<String,Object> getDataSalesGrowth(DispatchContext dpcx, Map<String,?extends Object> context) throws Exception{
		GenericValue userLogin=(GenericValue)context.get("userLogin");
		Delegator delegator= dpcx.getDelegator();
		String partyIdLogin= userLogin.getString("partyId");
		
		String year_one= (String)context.get("year_one");
		String year_two= (String)context.get("year_two");
		String productId= (String)context.get("productId");
		
		Map<String,Object> result= ServiceUtil.returnSuccess();
		
		BigDecimal _quantity_year_1= new BigDecimal(0);
		BigDecimal _quantity_year_2= new BigDecimal(0);
		
		BigDecimal _bill_year_1= new BigDecimal(0);
		BigDecimal _bill_year_2= new BigDecimal(0);
		
		
		
		if(UtilValidate.isNotEmpty(year_one)&&UtilValidate.isNotEmpty(year_two)&&UtilValidate.isNotEmpty(productId)){
			
			Calendar cal= Calendar.getInstance();
			int yearCurrent= cal.get(Calendar.YEAR);
			
			List<EntityCondition> timerCondition1= FastList.newInstance();
			List<EntityCondition> timerCondition2= FastList.newInstance();
			if(Integer.parseInt(year_two)==yearCurrent){
				Date today= new Date(cal.getTimeInMillis());
				EntityCondition pcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(today.getTime()));
				EntityCondition pcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_two));
				
				timerCondition2.add(pcon1);
				timerCondition2.add(pcon2);
				
				//set condition for year_one
				Calendar onCal= Calendar.getInstance();
				onCal.set(Calendar.YEAR, Integer.parseInt(year_one));
				
				EntityCondition qcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(onCal.getTimeInMillis()));
				EntityCondition qcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_one));
				
				
				timerCondition1.add(qcon2);
				timerCondition1.add(qcon1);
				
			}else if(Integer.parseInt(year_one)==yearCurrent){
				EntityCondition pcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(cal.getTimeInMillis()));
				EntityCondition pcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_one));
				
				timerCondition1.add(pcon1);
				timerCondition1.add(pcon2);
				
				//set condition for year_two
				Calendar onCal= Calendar.getInstance();
				onCal.set(Calendar.YEAR, Integer.parseInt(year_two));
				
				EntityCondition qcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(onCal.getTimeInMillis()));
				EntityCondition qcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_two));
				
				timerCondition2.add(qcon1);
				timerCondition2.add(qcon2);
				
			}else{
				EntityCondition pcon1= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_one));
				EntityCondition qcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_two));
				
				timerCondition1.add(pcon1);
				timerCondition2.add(qcon2);
			}
			
			EntityCondition prodductCon= EntityCondition.makeCondition("productProductId", productId);
			
			timerCondition1.add(prodductCon);
			timerCondition2.add(prodductCon);
			
			
			String department=null;
			if(CommonInternal.hasRole("SALES_ADMIN", partyIdLogin, delegator)){
				department="NBD";
			}else if(CommonInternal.hasRole("DELYS_DISTRIBUTOR", partyIdLogin, delegator)){
				department=partyIdLogin;
				
			}else{
				department=CommonInternal.getOrgByManager(userLogin, delegator);
			}
			
			List<String> listRole=FastList.newInstance();

	    	listRole.add("DELYS_NBD");
	    	
	    	listRole.add("DELYS_CSM_GT");
	    	listRole.add("DELYS_RSM_GT");
	    	listRole.add("DELYS_ASM_GT");
	    	listRole.add("DELYS_SALESSUP_GT");
	    	
	    	listRole.add("DELYS_CSM_MT");
	    	listRole.add("DELYS_RSM_MT");
	    	listRole.add("DELYS_ASM_MT");
	    	listRole.add("DELYS_SALESSUP_MT");
	    	
	    	listRole.add("DELYS_DISTRIBUTOR");
			
	    	
	    	EntityCondition _one_time= EntityCondition.makeCondition(timerCondition1, EntityOperator.AND);
	    	EntityCondition _two_time= EntityCondition.makeCondition(timerCondition2, EntityOperator.AND);
	    	
			RelationshipDepartmentProduct _ord_one= new RelationshipDepartmentProduct(delegator);
			
			RelationshipDepartmentProduct _ord_two= new RelationshipDepartmentProduct(delegator);
			if(UtilValidate.isNotEmpty(department)){
				
				_ord_one= CommonInternal.getRelationDepartment(listRole, department, "DELYS_DISTRIBUTOR", delegator);
				
				_ord_two= CommonInternal.getRelationDepartment(listRole, department, "DELYS_DISTRIBUTOR", delegator);
				
				// process year_one
				_ord_one.calculatorSalesOut(_one_time, delegator);
				_ord_one.setValueForAllChild();
				
				Map<String, Object> value_1= _ord_one.getMapProduct();
				value_1.put("id", _ord_one.getPartyId());
				value_1.put("grandTotal", _ord_one.getGrandTotal());
				value_1.put("name", _ord_one.getName());
				value_1.put("expanded", true);
				value_1.put("parentId", _ord_one.getParentId());
				
				_quantity_year_1=(BigDecimal)value_1.get(productId);
				_bill_year_1 = _ord_one.getGrandTotal();
				
				
				//process year_two
				_ord_two.calculatorSalesOut(_two_time, delegator);
				_ord_two.setValueForAllChild();
				
				Map<String, Object> value_2= _ord_two.getMapProduct();
				value_2.put("id", _ord_two.getPartyId());
				value_2.put("grandTotal", _ord_two.getGrandTotal());
				value_2.put("name", _ord_two.getName());
				value_2.put("expanded", true);
				value_2.put("parentId", _ord_two.getParentId());
			
				_quantity_year_2=(BigDecimal)value_2.get(productId);
				_bill_year_2 = _ord_two.getGrandTotal();
				
				
				ArrayList<Map<String,Object>> _result_one= new ArrayList<Map<String,Object>>();
				ArrayList<Map<String,Object>> _result_two= new ArrayList<Map<String,Object>>();
				
				_result_one= getAllChild(_ord_one, delegator);
				_result_one.add(value_1);
				
				_result_two= getAllChild(_ord_two, delegator);
				_result_two.add(value_2);
				
				for(Map<String,Object> item_1:_result_one){
					String partyId_1= (String)item_1.get("id");
					BigDecimal percent= new BigDecimal(0);
					BigDecimal item_val_1=(BigDecimal)item_1.get(productId);
					BigDecimal item_val_2= new BigDecimal(0);
					
					for(Map<String, Object> item_2:_result_two){
						String partyId_2= (String)item_2.get("id");
						if(partyId_1.equals(partyId_2)){
							
							
							item_val_2= (BigDecimal)item_2.get(productId);
							
							if(Integer.parseInt(year_one)>Integer.parseInt(year_two)){
								if(item_val_2.compareTo(BigDecimal.ZERO)>0){
									percent=item_val_1.divide(item_val_2,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
								}
								
								
							}else{
								if(item_val_1.compareTo(BigDecimal.ZERO)>0){
									percent=item_val_2.divide(item_val_1,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
								}
							}
						}
					}
					
					item_1.put(year_one, item_val_1);
					item_1.put(year_two, item_val_2);
					item_1.put("percent", percent);
					
					
				}
				result.put("result", _result_one);
				
			}
			
			
		}
		
		ArrayList<Map<String,Object>> data_colums_quan= new ArrayList<Map<String,Object>>();
		ArrayList<Map<String,Object>> data_colums_bill= new ArrayList<Map<String,Object>>();
		Map<String, Object> map_year_quan_1= new HashMap<String, Object>();
		Map<String, Object> map_year_quan_2= new HashMap<String, Object>();
		Map<String, Object> map_year_bill_1= new HashMap<String, Object>();
		Map<String, Object> map_year_bill_2= new HashMap<String, Object>();
		
		//quantity
		map_year_quan_1.put("name", year_one);
		BigDecimal quan_1[]= new BigDecimal[1];
		quan_1[0]=_quantity_year_1;
		map_year_quan_1.put("data", quan_1);
		
		
		map_year_quan_2.put("name", year_two);
		BigDecimal quan_2[]= new BigDecimal[1];
		quan_2[0]=_quantity_year_2;
		map_year_quan_2.put("data", quan_2);
		
		//bill
		
		map_year_bill_1.put("name", year_one);
		BigDecimal bill_1[]= new BigDecimal[1];
		bill_1[0]=_bill_year_1;
		map_year_bill_1.put("data", bill_1);
		
		map_year_bill_2.put("name", year_two);
		BigDecimal bill_2[]= new BigDecimal[1];
		bill_2[0]=_bill_year_2;
		map_year_bill_2.put("data", bill_2);
		
		
		if(Integer.parseInt(year_one)>Integer.parseInt(year_two)){
			data_colums_quan.add(map_year_quan_2);
			data_colums_quan.add(map_year_quan_1);
			data_colums_bill.add(map_year_bill_2);
			data_colums_bill.add(map_year_bill_1);
			
		}else{
			data_colums_quan.add(map_year_quan_1);
			data_colums_quan.add(map_year_quan_2);
			data_colums_bill.add(map_year_bill_1);
			data_colums_bill.add(map_year_bill_2);
		}
		
		result.put("dataColumsQuan", data_colums_quan);
		result.put("dataColumsBill", data_colums_bill);
		return result ;
	}
	
	public static Map<String, Object> getDataSalesGrowthOfDistributor(DispatchContext dpcx, Map<String,?extends Object> context) throws Exception{
		GenericValue userLogin=(GenericValue)context.get("userLogin");
		Delegator delegator= dpcx.getDelegator();
		String partyIdLogin= userLogin.getString("partyId");
		
		String year_one= (String)context.get("year_one");
		String year_two= (String)context.get("year_two");
		
		ArrayList<Map<String,Object>> _result_one= new ArrayList<Map<String,Object>>();
		ArrayList<Map<String,Object>> _result_two= new ArrayList<Map<String,Object>>();
		ArrayList<Map<String,Object>> _result_three= new ArrayList<Map<String,Object>>();
		
		if(UtilValidate.isNotEmpty(year_one)&&UtilValidate.isNotEmpty(year_two)){
			Calendar cal= Calendar.getInstance();
			int yearCurrent= cal.get(Calendar.YEAR);
			
			List<EntityCondition> timerCondition1= FastList.newInstance();
			List<EntityCondition> timerCondition2= FastList.newInstance();
			if(Integer.parseInt(year_two)==yearCurrent){
				Date today= new Date(cal.getTimeInMillis());
				EntityCondition pcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(today.getTime()));
				EntityCondition pcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_two));
				
				timerCondition2.add(pcon1);
				timerCondition2.add(pcon2);
				
				//set condition for year_one
				Calendar onCal= Calendar.getInstance();
				onCal.set(Calendar.YEAR, Integer.parseInt(year_one));
				
				EntityCondition qcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(onCal.getTimeInMillis()));
				EntityCondition qcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_one));
				
				
				timerCondition1.add(qcon2);
				timerCondition1.add(qcon1);
				
			}else if(Integer.parseInt(year_one)==yearCurrent){
				EntityCondition pcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(cal.getTimeInMillis()));
				EntityCondition pcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_one));
				
				timerCondition1.add(pcon1);
				timerCondition1.add(pcon2);
				
				//set condition for year_two
				Calendar onCal= Calendar.getInstance();
				onCal.set(Calendar.YEAR, Integer.parseInt(year_two));
				
				EntityCondition qcon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(onCal.getTimeInMillis()));
				EntityCondition qcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_two));
				
				timerCondition2.add(qcon1);
				timerCondition2.add(qcon2);
				
			}else{
				EntityCondition pcon1= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_one));
				EntityCondition qcon2= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year_two));
				
				timerCondition1.add(pcon1);
				timerCondition2.add(qcon2);
			}
			
			String department=null;
			if(CommonInternal.hasRole("SALES_ADMIN", partyIdLogin, delegator)){
				department="NBD";
			}else if(CommonInternal.hasRole("DELYS_DISTRIBUTOR", partyIdLogin, delegator)){
				department=partyIdLogin;
				
			}else{
				department=CommonInternal.getOrgByManager(userLogin, delegator);
			}
			
			List<String> listRole=FastList.newInstance();

	    	listRole.add("DELYS_NBD");
	    	
	    	listRole.add("DELYS_CSM_GT");
	    	listRole.add("DELYS_RSM_GT");
	    	listRole.add("DELYS_ASM_GT");
	    	listRole.add("DELYS_SALESSUP_GT");
	    	
	    	listRole.add("DELYS_CSM_MT");
	    	listRole.add("DELYS_RSM_MT");
	    	listRole.add("DELYS_ASM_MT");
	    	listRole.add("DELYS_SALESSUP_MT");
	    	
	    	listRole.add("DELYS_DISTRIBUTOR");
			
	    	
	    	EntityCondition _one_time= EntityCondition.makeCondition(timerCondition1, EntityOperator.AND);
	    	EntityCondition _two_time= EntityCondition.makeCondition(timerCondition2, EntityOperator.AND);
	    	
			RelationshipDepartmentProduct _ord_one= new RelationshipDepartmentProduct(delegator);
			
			RelationshipDepartmentProduct _ord_two= new RelationshipDepartmentProduct(delegator);
			
			RelationshipDepartmentProduct _ord_three= new RelationshipDepartmentProduct(delegator);
			
			if(UtilValidate.isNotEmpty(department)){
				
				_ord_one= CommonInternal.getRelationDepartment(listRole, department, "DELYS_DISTRIBUTOR", delegator);
				
				_ord_two= CommonInternal.getRelationDepartment(listRole, department, "DELYS_DISTRIBUTOR", delegator);
				
				_ord_three= CommonInternal.getRelationDepartment(listRole, department, "DELYS_DISTRIBUTOR", delegator);
				
				_ord_one.calculatorSalesOut(_one_time, delegator);
				_ord_two.calculatorSalesOut(_two_time, delegator);
				
				_ord_one.setValueForAllChild();
				_ord_two.setValueForAllChild();
				
				
				Map<String, Object> value_1= _ord_one.getMapProduct();
				value_1.put("id", _ord_one.getPartyId());
				value_1.put("grandTotal", _ord_one.getGrandTotal());
				value_1.put("name", _ord_one.getName());
				value_1.put("expanded", true);
				value_1.put("parentId", _ord_one.getParentId());
				
				
				Map<String, Object> value_2= _ord_two.getMapProduct();
				value_2.put("id", _ord_two.getPartyId());
				value_2.put("grandTotal", _ord_two.getGrandTotal());
				value_2.put("name", _ord_two.getName());
				value_2.put("expanded", true);
				value_2.put("parentId", _ord_two.getParentId());
			
				
				Map<String, Object> value_3= _ord_three.getMapProduct();
				value_3.put("id", _ord_three.getPartyId());
				value_3.put("grandTotal", _ord_three.getGrandTotal());
				value_3.put("name", _ord_three.getName());
				value_3.put("expanded", true);
				value_3.put("parentId", _ord_three.getParentId());
				
				_result_one= getAllChild(_ord_one, delegator);
				_result_one.add(value_1);
				
				_result_two= getAllChild(_ord_two, delegator);
				_result_two.add(value_2);
				
				_result_three= getAllChild(_ord_three, delegator);
				_result_three.add(value_3);
				
				
				//get list product id  is key in map
				Set<String> select= FastSet.newInstance();
				select.add("productId");
				List<GenericValue> productList=delegator.findList("ProductDimension", null,select , null, null, false);
				List<String> productIdList= FastList.newInstance();
				productIdList.add("grandTotal");
				if(UtilValidate.isNotEmpty(productList)){
					for(GenericValue product:productList){
						productIdList.add(product.getString("productId"));
					}
					
				}
				
				//calculator percent for _result_three
				for(Map<String,Object> item_1:_result_one){
					String partyId_1= (String)item_1.get("id");
					for(Map<String,Object> item_2:_result_two){
						String partyId_2= (String)item_2.get("id");
						if(partyId_1.equals(partyId_2)){
							
							for(Map<String, Object> item_3:_result_three){
								String partyId_3= (String)item_3.get("id");
								if(partyId_2.equals(partyId_3)){
									for(String key:productIdList){
										BigDecimal item_value_1= (BigDecimal)item_1.get(key);
										BigDecimal item_value_2 = (BigDecimal)item_2.get(key);
										BigDecimal percent= new BigDecimal(0);
										if(Integer.parseInt(year_one)>Integer.parseInt(year_two)){
											if(item_value_2.compareTo(BigDecimal.ZERO)>0){
												percent=item_value_1.divide(item_value_2,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
											}
											
											
										}else{
											if(item_value_1.compareTo(BigDecimal.ZERO)>0){
												percent=item_value_2.divide(item_value_1,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
											}
										}
										
										item_3.put(key, percent);
									}
								}
								
							}
						
						}
					
					}
				}
			}
			
		}
		Map<String,Object> result= ServiceUtil.returnSuccess();
		result.put("listOne_1", _result_one);
		result.put("listOne_2", _result_two);
		result.put("listOne_3", _result_three);
		return result;
	}
}
