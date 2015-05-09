package com.olbius.olap.order;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class PromotionServices {
	public static final String module = PromotionServices.class.getName();
	public static Map<String, Object>jqxPromotionReport(DispatchContext dcpx,Map<String,?extends Object> context ){
		Delegator delegator = dcpx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
    	List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	EntityCondition condition= EntityCondition.makeCondition(listAllConditions, EntityJoinOperator.OR);
    	try {
    		listIterator = delegator.find("PromotionAndDate", condition, null, null,listSortFields , opts);
    	
		} catch (GenericEntityException e) {
			String errMsg = "Fatal error calling jqGetListProduct service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	successResult.put("listIterator", listIterator);
    	return successResult;
	}
	public static Map<String,Object> getAvaiableBudgetPromotion(DispatchContext dcpx, Map<String,?extends Object> context) throws GenericEntityException{
		Delegator delegator= dcpx.getDelegator();
		String promotionCode= (String)context.get("promotionCode");
		BigDecimal extNetAmount= new BigDecimal(0);
		BigDecimal extPromotionAmount= new BigDecimal(0);
		List<Map<String,Object>> resultMap= FastList.newInstance();
		Map<String,Object> totalProduct= new HashMap<String, Object>();
		Map<String,Object> dataComlumline= new HashMap<String, Object>();
		
		//set default value for average in ComlumLine chart
		BigDecimal average[]= new BigDecimal[12];
		for(int i=0;i<average.length;i++){
			average[i]= new BigDecimal(0);
		}
		int year=0;
		
		//when promotionCode has value?
		if(UtilValidate.isNotEmpty(promotionCode)){
			Set<String> field= FastSet.newInstance();
			field.add("productId");
			field.add("productName");
			EntityFindOptions find= new EntityFindOptions();
			find.setDistinct(true);
			EntityCondition promoCon= EntityCondition.makeCondition("productPromoId", promotionCode);
			
			List<GenericValue> productApplyList= delegator.findList("OlapProductPromotionAndPromoCode", promoCon, field, null, find, false);
			List<GenericValue> roleApplyList= delegator.findList("PromotionRoleTypeApplyAndPromoCode", promoCon, null, null, null, false);
			
			List<EntityCondition> roleCon= FastList.newInstance();
			List<EntityCondition> productCon= FastList.newInstance();
			
			//set condition product apply in promotion
			if(UtilValidate.isNotEmpty(productApplyList)){
				for(GenericValue productEntry:productApplyList){
					String productId= productEntry.getString("productId");
					EntityCondition xpro= EntityCondition.makeCondition("productProductId",productId);
					productCon.add(xpro);
				}
			}
			//get list role apply in promotion
			if(UtilValidate.isNotEmpty(roleApplyList)){
				
				for(GenericValue roleEntry:roleApplyList){
					String role= roleEntry.getString("roleTypeId");
					EntityCondition xrole1= EntityCondition.makeCondition("roleTypeId",role);
					roleCon.add(xrole1);
				}
				
				
			}
			
			//set year to draw Columline chart 
			
			GenericValue promo= EntityUtil.getFirst(delegator.findByAnd("PromotionAndDate", UtilMisc.toMap("productPromoId",promotionCode), null, false));
			Date promoFromDate= promo.getDate("fromDateValue");
			Date promoThruDate=promo.getDate("thruDateValue");
			List<EntityCondition> timeCon= FastList.newInstance();
			Calendar cal= Calendar.getInstance();
			if(UtilValidate.isNotEmpty(promoFromDate)){
				EntityCondition fromtime= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(promoFromDate.getTime() ));
				timeCon.add(fromtime);
				cal.setTime(promoThruDate);
				year=cal.get(Calendar.YEAR);
			}
			
			if(UtilValidate.isNotEmpty(promoThruDate)){
				EntityCondition thrutime= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(promoThruDate.getTime() ));
				timeCon.add(thrutime);
				
//				if(year==0){
					cal.setTime(promoThruDate);
					year=cal.get(Calendar.YEAR);
//				}
			}
			
			EntityCondition ontime= EntityCondition.makeCondition(timeCon,EntityOperator.AND);
			EntityCondition complete= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
			
			//get list party with role
			List<GenericValue> partyList= delegator.findList("PartyRole", EntityCondition.makeCondition(roleCon,EntityOperator.OR), null, null, find, false);
			
			List<EntityCondition> partyPlacingCon= FastList.newInstance();
			if(UtilValidate.isNotEmpty(partyList)){
				for(GenericValue party:partyList){
					String partyId= party.getString("partyId");
					EntityCondition xparty= EntityCondition.makeCondition("placingCustomer",partyId);
					partyPlacingCon.add(xparty);
				}
			}
			
			//get time promotion
			
			
			
			EntityCondition condition1= EntityCondition.makeCondition(productCon,EntityOperator.OR);
			EntityCondition condition2= EntityCondition.makeCondition(partyPlacingCon,EntityOperator.OR);
			
			if(year>0){// begin get data for columnLine Chart
				EntityCondition yearCon= EntityCondition.makeCondition("orderDateYearName",new Long(year));
				List<GenericValue> totalOrderList= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityJoinOperator.AND,condition1,condition2,complete,yearCon), null, null, null, false);
			if(UtilValidate.isNotEmpty(totalOrderList)){
				for(GenericValue item:totalOrderList){
					String itemProductId= item.getString("productProductId");
					Long monthOrder= item.getLong("orderDateMonthOfYear");
					int monint=0;
					if(monthOrder!=null){
						monint= monthOrder.intValue();
					}
					BigDecimal netAmount=item.getBigDecimal("extNetAmount");
					if(UtilValidate.isEmpty(netAmount)){
						
						netAmount= new BigDecimal(0);
					}
					
					if(monint>0){
						if(dataComlumline.containsKey(itemProductId)){
							Map<String,Object> newMap= new HashMap<String,Object>();
							newMap= (Map<String,Object>)dataComlumline.get(itemProductId);
							BigDecimal[] init= (BigDecimal[]) newMap.get("data");
							init[monint-1]=init[monint-1].add(netAmount);
							newMap.put("data", init);
							dataComlumline.put(itemProductId, newMap);
						}else{
							BigDecimal init[]= new BigDecimal[12];
							for(int i=0;i<init.length;i++){
								init[i]= new BigDecimal(0);
		    				}
							
							init[monint-1]=netAmount;
							
							Map<String, Object> newMap= new HashMap<String,Object>();
							newMap.put("data", init);
							dataComlumline.put(itemProductId, newMap);
						}
						
						average[monint-1]=average[monint-1].add(netAmount);
					}
				}
			}
			
			}//End get data for columnLine Chart
			
			
			//begin get data for comlum pie chart
			List<GenericValue> orderList= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityJoinOperator.AND,ontime,complete,condition1,condition2), null, null, null, false);
			
			if(UtilValidate.isNotEmpty(orderList)){
				for(GenericValue item:orderList){
					String productProductId= item.getString("productProductId");
					BigDecimal netAmount=item.getBigDecimal("extNetAmount");
					
					
					if(UtilValidate.isEmpty(netAmount)){
						netAmount= BigDecimal.ZERO;
					}
					
					extNetAmount=extNetAmount.add(netAmount);
					if(totalProduct.containsKey(productProductId)){
						Map<String,Object> itemProduct= (Map<String,Object>)totalProduct.get(productProductId);
						BigDecimal hasextNetAmount= netAmount.add((BigDecimal)itemProduct.get("extNetAmount"));
						itemProduct.put("extNetAmount", hasextNetAmount);
						
						totalProduct.put(productProductId, itemProduct);
						
					}else{
						Map<String,Object> itemProduct= new HashMap<String, Object>();
						itemProduct.put("extNetAmount", netAmount);
						totalProduct.put(productProductId, itemProduct);
						
					}
					
					
				}
			}
			//end get data for comlum pie chart
			
			//get value budget used in promotion
			EntityCondition promotionProductPromoId= EntityCondition.makeCondition("promotionProductPromoId",promotionCode);
			List<GenericValue> belongPro= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(EntityJoinOperator.AND,complete,promotionProductPromoId), null, null, null, false);
			
			if(UtilValidate.isNotEmpty(belongPro)){
				for(GenericValue item:belongPro){
					BigDecimal promotionAmount= (BigDecimal)item.getBigDecimal("extPromotionAmount");
					if(UtilValidate.isEmpty(promotionCode)){
						promotionAmount= new BigDecimal(0);
					}
					
					extPromotionAmount= extPromotionAmount.add(promotionAmount);
				}
			}
			
			
		}//End value budget used in promotion
		
		//get list name product
		List<GenericValue> productList=delegator.findList("ProductDimension", null,null , null, null, false);
		Map<String, Object> mapProduct= new HashMap<String, Object>();
		if(UtilValidate.isNotEmpty(productList)){
			for(GenericValue product:productList){
				if(UtilValidate.isNotEmpty(product.getString("internalName"))){
					mapProduct.put(product.getString("productId"), product.getString("internalName"));
				}else{
					mapProduct.put(product.getString("productId"), product.getString("productId"));
				}
				
			}
		}
			
		//prepare data to return for columeLine chart
		ArrayList< Map<String,Object>> columLine= new ArrayList<Map<String,Object>>();
		Iterator<String> colKeyset= dataComlumline.keySet().iterator();
		
		while(colKeyset.hasNext()){
			String key= colKeyset.next();
			Map<String,Object> newItem= new HashMap<String,Object>();
			newItem= (Map<String,Object>)dataComlumline.get(key);
			newItem.put("name", mapProduct.get(key));
			newItem.put("type", "column");
			columLine.add(newItem);
			
		}
		BigDecimal newAverage[]= new BigDecimal[12];
		BigDecimal size= new  BigDecimal(dataComlumline.size());
		if(size.compareTo(BigDecimal.ZERO)>0){
			for(int i=0; i<average.length;i++){
				newAverage[i]=average[i].divide(size,4,RoundingMode.HALF_UP);
			}
			
		}else{
			for(int i=0; i<newAverage.length;i++){
				newAverage[i]= new BigDecimal(0);
			}
		}
		
		Map<String,Object> lineData= new HashMap<String,Object>();
		lineData.put("type", "spline");
		lineData.put("name", "Average");
		lineData.put("data", newAverage);
		
		columLine.add(lineData);
		
		
		//prepare data to return for column Pie chart
		ArrayList<Map<String,Object>> rsult= new ArrayList<Map<String,Object>>();
		Iterator<String> keyset = totalProduct.keySet().iterator();
		Map<String,Object> pieData= new HashMap<String, Object>();
		pieData.put("type", "pie");
		pieData.put("name", "Total consumption");
		ArrayList<Map<String,Object>> datapie= new ArrayList<Map<String,Object>>();
		while(keyset.hasNext()){
			String key= keyset.next();
			Map<String,Object> pitem= new HashMap<String, Object>();
			Map<String,Object> nds= new HashMap<String, Object>();
			Map<String,Object> pieMap= new HashMap<String, Object>();
			
			BigDecimal promotion[]= new BigDecimal[1];
			BigDecimal praPie= new BigDecimal(0);
			nds.put("name", mapProduct.get(key));
			nds.put("type","column");
			pitem= (Map<String,Object>)totalProduct.get(key);
			promotion[0]=(BigDecimal)pitem.get("extNetAmount");
			
			praPie=((BigDecimal)pitem.get("extNetAmount")).divide(extNetAmount,4,RoundingMode.HALF_UP).multiply(new BigDecimal(100));
			
			pieMap.put("name",  mapProduct.get(key));
			pieMap.put("y", praPie);
			datapie.add(pieMap);
			nds.put("data", promotion);
			rsult.add(nds);
		}
		
		
		pieData.put("data", datapie);
		int[] center= new int[2];
		center[0]=20;
		center[1]=80;
		pieData.put("center", center);
		pieData.put("size", 100);
		pieData.put("showInLegend", false);
		rsult.add(pieData);
		
		Map<String, Object> allMap= ServiceUtil.returnSuccess();
		allMap.put("chartpie", rsult);
		allMap.put("extPromotionAmount", extPromotionAmount);
		allMap.put("extNetAmount", extNetAmount);
		allMap.put("dataColumLine", columLine);
		allMap.put("year",year);
		return allMap;
	}
	
}
