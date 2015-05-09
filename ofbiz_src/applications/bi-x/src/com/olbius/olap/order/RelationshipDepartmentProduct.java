package com.olbius.olap.order;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javolution.util.FastList;
import javolution.util.FastSet;

import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;

public class RelationshipDepartmentProduct extends RelationshipDepartment {
	private Map<String,Object> mapProduct= new HashMap<String, Object>();
	private BigDecimal grandTotal=new BigDecimal(0);
	private List<RelationshipDepartmentProduct> childRd = FastList.newInstance();
	public BigDecimal getGrandTotal() {
		return grandTotal;
	
	}

	public void setGrandTotal(BigDecimal grandTotal) {
		this.grandTotal = grandTotal;
	}

	private void setMapProduct(Map<String, Object> mapProduct) {
		this.mapProduct.putAll(mapProduct);
	}
	
	public Map<String, Object> getMapProduct() {
		return mapProduct;
	}
	

	public List<RelationshipDepartmentProduct> getChildRd() {
		return childRd;
	}

	public void setChildRd(List<RelationshipDepartmentProduct> childRd) {
		this.childRd = childRd;
	}
	
	public void addChildRd(RelationshipDepartmentProduct childRd) {
		this.childRd.add(childRd);
	}

	public RelationshipDepartmentProduct(Delegator delegator) throws GenericEntityException {
		super();
		this.setMapProduct(delegator);
		// TODO Auto-generated constructor stub
	}
	
	public RelationshipDepartmentProduct(String partyId, String name,
			List<RelationshipDepartmentProduct> child, boolean flag, Delegator delegator) throws GenericEntityException {
		// TODO Auto-generated constructor stub
		this.setPartyId(partyId);
		this.setName(name);
		this.setFlag(flag);
		this.setChildRd(child);
		
		this.setMapProduct(delegator);
//		this.mapProduct.putAll(mapProduct);
	}


	public RelationshipDepartmentProduct(String partyId, String name,
			RelationshipDepartmentProduct child, boolean flag, Delegator delegator) throws GenericEntityException {
		// TODO Auto-generated constructor stub
		
		this.setPartyId(partyId);
		this.setName(name);
		this.setFlag(flag);
		this.addChildRd(child);
		
		this.setMapProduct(delegator);
//		this.mapProduct.putAll(mapProduct);
	}
	
	public List<RelationshipDepartmentProduct> getAllChildBelongFlagTrue(){
		List<RelationshipDepartmentProduct> child= FastList.newInstance();
		if(UtilValidate.isNotEmpty(this.getChildRd())){
			for(RelationshipDepartmentProduct item:this.getChildRd()){
				if(item.isFlag()){
					child.add(item);
				}else{
					List<RelationshipDepartmentProduct> temp = item.getAllChildBelongFlagTrue();
					if(UtilValidate.isNotEmpty(temp)){
						child.addAll(temp);
					}
				}
			}
		}
		
		
		return child;
	}

	private void setMapProduct(Delegator delegator) throws GenericEntityException{
		Set<String> select= FastSet.newInstance();
		select.add("productId");
		List<GenericValue> productList=delegator.findList("ProductDimension", null,select , null, null, false);
		
		Map<String, Object> mapProduct= new HashMap<String, Object>();
		if(UtilValidate.isNotEmpty(productList)){
			for(GenericValue product:productList){
				mapProduct.put(product.getString("productId"), new BigDecimal(0));
			}
			
		}
		
		this.setMapProduct(mapProduct);
		
	}
	
	
	public void calculatorSalesIn(String fromDate, String thruDate,Delegator delegator) throws GenericEntityException, ParseException{
		
		SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");
		List<EntityCondition> conTimer= FastList.newInstance();
		if(UtilValidate.isNotEmpty(fromDate)){
			Date wfrom= yearMonthDayFormat.parse(fromDate);
			EntityCondition xor1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(wfrom.getTime()));
			conTimer.add(xor1);
		}
		if(UtilValidate.isNotEmpty(thruDate)){
			Date wthru= yearMonthDayFormat.parse(thruDate);
			EntityCondition xor2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(wthru.getTime()));
			conTimer.add(xor2);
		}
		
		if(this.isFlag()){
			String partyId= this.getPartyId();
			List<EntityCondition> totalCon= FastList.newInstance();
			totalCon.addAll(conTimer);
			EntityCondition disCon1= EntityCondition.makeCondition("placingCustomer",partyId);
			EntityCondition disCon2= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
			totalCon.add(disCon1);
			totalCon.add(disCon2);
			List<GenericValue> orderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(totalCon,EntityJoinOperator.AND), null, null, null, false);
			
			
			if(UtilValidate.isNotEmpty(orderItem)){
				
				for(GenericValue item:orderItem){
					String productId= item.getString("productProductId");
					BigDecimal quantity = (BigDecimal) item.getBigDecimal("quantity");
					BigDecimal extGrossAmount = (BigDecimal) item.getBigDecimal("extGrossAmount");
					if(UtilValidate.isEmpty(extGrossAmount)){
						
						extGrossAmount= new BigDecimal(0);
					}
					if(UtilValidate.isEmpty(quantity)){
						
						quantity= new BigDecimal(0);
					}
					
					this.grandTotal=this.grandTotal.add(extGrossAmount);
					if(this.mapProduct.containsKey(productId)){
						
						BigDecimal quantiexist= (BigDecimal)this.mapProduct.get(productId);
						BigDecimal itemTotalquantity= quantiexist.add(quantity);
						this.mapProduct.put(productId, itemTotalquantity);
					}
				}
				
			
			}
			
		}else{
			if(UtilValidate.isNotEmpty(this.getChildRd())){
				List<RelationshipDepartmentProduct> listItemFlag= getAllChildBelongFlagTrue(); 
				if(UtilValidate.isNotEmpty(listItemFlag)){
					for(RelationshipDepartmentProduct item:listItemFlag){
						item.calculatorSalesIn(fromDate, thruDate, delegator);
					}
				}
				for(RelationshipDepartmentProduct itemChildRd:listItemFlag){
					Map<String,Object> mapChild= new HashMap<String, Object>();
					mapChild= itemChildRd.getMapProduct();
					BigDecimal itemGrand= itemChildRd.getGrandTotal();
					Iterator<String> keyset = mapChild.keySet().iterator();
					while(keyset.hasNext()){
						String key= keyset.next();
						BigDecimal quantityChild= (BigDecimal)mapChild.get(key);
						BigDecimal quantityThis=(BigDecimal)this.mapProduct.get(key);
						this.mapProduct.put(key, quantityChild.add(quantityThis));
					}
					this.grandTotal= this.grandTotal.add(itemGrand);
				}
			}
			
		}
	}
	
public void calculatorSalesOut(EntityCondition condition,Delegator delegator) throws GenericEntityException, ParseException{
		if(this.isFlag()){
			String partyId= this.getPartyId();
			List<EntityCondition> totalCon= FastList.newInstance();
			EntityCondition disCon1= EntityCondition.makeCondition("billFromVendor",partyId);
			EntityCondition disCon2= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
			
			totalCon.add(condition);
			totalCon.add(disCon1);
			totalCon.add(disCon2);
			List<GenericValue> orderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(totalCon,EntityJoinOperator.AND), null, null, null, false);
			
			
			if(UtilValidate.isNotEmpty(orderItem)){
				
				for(GenericValue item:orderItem){
					String productId= item.getString("productProductId");
					BigDecimal quantity = (BigDecimal) item.getBigDecimal("quantity");
					BigDecimal extNetAmount = (BigDecimal) item.getBigDecimal("extNetAmount");
					BigDecimal extTaxAmount=(BigDecimal)item.get("extTaxAmount");
					
					if(UtilValidate.isEmpty(extNetAmount)){
						
						extNetAmount= new BigDecimal(0);
					}
					if(UtilValidate.isEmpty(quantity)){
						
						quantity= new BigDecimal(0);
					}
					
					if(UtilValidate.isEmpty(extTaxAmount)){
						
						extTaxAmount= new BigDecimal(0);
					}
					
					this.grandTotal=this.grandTotal.add(extNetAmount).add(extTaxAmount);
					if(this.mapProduct.containsKey(productId)){
						
						BigDecimal quantiexist= (BigDecimal)this.mapProduct.get(productId);
						BigDecimal itemTotalquantity= quantiexist.add(quantity);
						this.mapProduct.put(productId, itemTotalquantity);
					}
				}
				
			
			}
			
		}else{
			if(UtilValidate.isNotEmpty(this.getChildRd())){
				List<RelationshipDepartmentProduct> listItemFlag= getAllChildBelongFlagTrue(); 
				if(UtilValidate.isNotEmpty(listItemFlag)){
					for(RelationshipDepartmentProduct item:listItemFlag){
						item.calculatorSalesOut(condition, delegator);
					}
				}
				for(RelationshipDepartmentProduct itemChildRd:listItemFlag){
					Map<String,Object> mapChild= new HashMap<String, Object>();
					mapChild= itemChildRd.getMapProduct();
					BigDecimal itemGrand= itemChildRd.getGrandTotal();
					Iterator<String> keyset = mapChild.keySet().iterator();
					while(keyset.hasNext()){
						String key= keyset.next();
						BigDecimal quantityChild= (BigDecimal)mapChild.get(key);
						BigDecimal quantityThis=(BigDecimal)this.mapProduct.get(key);
						this.mapProduct.put(key, quantityChild.add(quantityThis));
					}
					this.grandTotal= this.grandTotal.add(itemGrand);
				}
			}
			
		}
	}
	
	public void setValueForAllChild(){
		if(UtilValidate.isNotEmpty(this.childRd)){
			for(RelationshipDepartmentProduct item:this.childRd){
				List<RelationshipDepartmentProduct> listItemFlag= item.getAllChildBelongFlagTrue();
				
				if(UtilValidate.isNotEmpty(listItemFlag)){
					for(RelationshipDepartmentProduct itemChildRd:listItemFlag){
						Map<String,Object> mapChild= new HashMap<String, Object>();
						mapChild= itemChildRd.getMapProduct();
						BigDecimal itemGrand= itemChildRd.getGrandTotal();
						Iterator<String> keyset = mapChild.keySet().iterator();
						while(keyset.hasNext()){
							String key= keyset.next();
							BigDecimal quantityChild= (BigDecimal)mapChild.get(key);
							BigDecimal quantityThis=(BigDecimal)item.mapProduct.get(key);
							item.mapProduct.put(key, quantityChild.add(quantityThis));
						}
						item.grandTotal= item.grandTotal.add(itemGrand);
						item.setValueForAllChild();
					}
				}
			}
		}
	}
	
}
