package com.olbius.olap.order;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class StaticSalesOrderItem {
	public static final String module = StaticSalesOrderItem.class.getName();
	public static Map<String, Object> getToltalQuantityAmountProductSaled(Delegator delegator,String created, String bill, String fromdate, String thruDate, String productId,String salesType) throws ParseException, GenericEntityException{
		SimpleDateFormat sdf= new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		List<EntityCondition> xcon= FastList.newInstance();
		if(UtilValidate.isNotEmpty(fromdate)&&UtilValidate.isNotEmpty(thruDate)){
			Date fromDateFormat= sdf.parse(fromdate);
			Date thruDateFormat= sdf.parse(thruDate);
			EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(fromDateFormat.getTime()));
			EntityCondition condition2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(thruDateFormat.getTime()));
			xcon.add(EntityCondition.makeCondition(EntityJoinOperator.AND, condition1,condition2));
			
		}else if(UtilValidate.isEmpty(fromdate)&&UtilValidate.isNotEmpty(thruDate)){
			Date thruDateFormat= sdf.parse(thruDate);
			EntityCondition condition2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(thruDateFormat.getTime()));
			xcon.add(condition2);
		}else if(UtilValidate.isNotEmpty(fromdate)&&UtilValidate.isEmpty(thruDate)){
			Date fromDateFormat= sdf.parse(fromdate);
			EntityCondition condition1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(fromDateFormat.getTime()));
			xcon.add(condition1);
		}
		if(UtilValidate.isNotEmpty(productId)){
			EntityCondition condition3= EntityCondition.makeCondition("productProductId", productId);
			xcon.add(condition3);
		}
		if(UtilValidate.isNotEmpty(created)){
			if("SALES_OUT".equals(salesType)){
				EntityCondition condition4= EntityCondition.makeCondition("orderCreatedBy",created);
				xcon.add(condition4);
			}
			else if("SALES_IN".equals(salesType)){
				EntityCondition condition5= EntityCondition.makeCondition("placingCustomer",created);
				xcon.add(condition5);
			}
			
		}
		
//		if(UtilValidate.isNotEmpty(bill)){
//			if("SALES_IN".equals(salesType)){
//				EntityCondition condition5= EntityCondition.makeCondition("placingCustomer",bill);
//				xcon.add(condition5);
//			}
//		}
		
		EntityCondition condition6 = EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
		xcon.add(condition6);
		List<GenericValue> order = delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(xcon, EntityOperator.AND), null, null, null, false);
		BigDecimal quantity=  new BigDecimal(0);
		BigDecimal amount = new BigDecimal(0);
		if(UtilValidate.isNotEmpty(order)){
			for(GenericValue entry:order){
				quantity=quantity.add(entry.getBigDecimal("quantity"));
				amount=amount.add(entry.getBigDecimal("extGrossAmount"));	
			}
		}
		
		Map<String, Object> result = FastMap.newInstance();
		result.put("quantity", quantity);
		result.put("amount", amount);
		
		return result;
	}
    
	public static List<GenericValue>getChildDepartmentWithRole(Delegator delegator,String partyIdFrom,String roleFrom,String roleChild,String fromDate, String thruDate) throws GenericEntityException, ParseException{
		List<EntityCondition> xcon= FastList.newInstance();
		SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");

		if(UtilValidate.isNotEmpty(partyIdFrom)){
			EntityCondition condition1=EntityCondition.makeCondition("partyIdFrom",partyIdFrom);
			xcon.add(condition1);
		}
		
		if(UtilValidate.isNotEmpty(roleFrom)){
			EntityCondition condition2= EntityCondition.makeCondition("roleTypeIdFrom",roleFrom);
			xcon.add(condition2);
		}
		if(UtilValidate.isNotEmpty(roleChild)){
			EntityCondition condition3= EntityCondition.makeCondition("roleTypeIdTo",roleChild);
			xcon.add(condition3);
		}
		if(UtilValidate.isNotEmpty(fromDate)){
			Date xfrom= yearMonthDayFormat.parse(fromDate);
			EntityCondition x1= EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(xfrom.getTime()));
			xcon.add(x1);
		}
		if(UtilValidate.isNotEmpty(thruDate)){
			Date xthru= yearMonthDayFormat.parse(thruDate);
			EntityCondition x1= EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(xthru.getTime()));
			EntityCondition x2= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS,null);
			xcon.add(EntityCondition.makeCondition(EntityOperator.OR,x1,x2));
		}
		
		EntityCondition condition4= EntityCondition.makeCondition("partyRelationshipTypeId","GROUP_ROLLUP");
		xcon.add(condition4);
		List<GenericValue> listChild=EntityUtil.filterByDate(delegator.findList("PartyRelationship", EntityCondition.makeCondition(xcon, EntityOperator.AND), null, null, null, false));
		return listChild;
	}
	public static void getDataSalesIn(HttpServletRequest request, HttpServletResponse respone) throws GenericEntityException, ParseException{
		Delegator delegator= (Delegator)request.getAttribute("delegator");
		String dsa= (String)request.getParameter("dsaId");
		List<Map<String,Object>> result= FastList.newInstance();
		String fromDate= (String)request.getParameter("fromDate");
		String thruDate= (String)request.getParameter("thruDate");
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
		
		if(UtilValidate.isNotEmpty(dsa)){
			//Map name group
			List<GenericValue> personList= delegator.findList("PartyGroup", null, null, null, null, false);
    		Map<String,Object> mapName= new HashMap<String, Object>();
    		if(UtilValidate.isNotEmpty(personList)){
    			for(GenericValue per:personList){
    				String partyId= per.getString("partyId");
    				String name="";
					name=per.getString("groupName");
    				mapName.put(partyId, name);
    			}
    		}
			
			//Product List
			Set<String> select= FastSet.newInstance();
    		select.add("productId");
    		List<GenericValue> productList=delegator.findList("ProductDimension", null,select , null, null, false);
    		
    		Map<String, Object> mapProduct= new HashMap<String, Object>();
    		if(UtilValidate.isNotEmpty(productList)){
    			for(GenericValue product:productList){
    				mapProduct.put(product.getString("productId"), new BigDecimal(0));
    			}
    			
    		}
    		
			List<GenericValue> ndbGt= getChildDepartmentWithRole(delegator, dsa, "", "DELYS_NBD",fromDate, thruDate);
			if(UtilValidate.isNotEmpty(ndbGt)){
				
				for(GenericValue entryNbd:ndbGt){
					ArrayList<Map<String,Object>> childNsm= new ArrayList<Map<String,Object>>();
					BigDecimal nbdGrandTotal= new BigDecimal(0);
					Map<String,Object> NbdMap= new HashMap<String, Object>();
					NbdMap.putAll(mapProduct);
					
					String nbdPartyId= entryNbd.getString("partyIdTo");
					List<GenericValue> csmMtList= getChildDepartmentWithRole(delegator, nbdPartyId, "DELYS_NBD", "DELYS_CSM_MT",fromDate,thruDate);
					List<GenericValue> csmGtList= getChildDepartmentWithRole(delegator, nbdPartyId, "DELYS_NBD", "DELYS_CSM_GT",fromDate,thruDate);
					
					
					int i=0;
//					get csm Gt
					List<Map<String, Object>> distListMap= FastList.newInstance(); 
					if(UtilValidate.isNotEmpty(csmGtList)){
						for(GenericValue entryCsmGt:csmGtList){
							
							ArrayList<Map<String,Object>> childCsm= new ArrayList<Map<String,Object>>();
							BigDecimal csmGrandTotal= new BigDecimal(0);
							Map<String,Object> csmMap= new HashMap<String, Object>(); 
							csmMap.putAll(mapProduct);
							
							String csmGtPartyId=entryCsmGt.getString("partyIdTo");
							List<GenericValue> rsmGt= getChildDepartmentWithRole(delegator, csmGtPartyId, "DELYS_CSM_GT", "DELYS_RSM_GT",fromDate,thruDate);
							//get ASM GT
							if(UtilValidate.isNotEmpty(rsmGt)){
								for(GenericValue entryRsmGt:rsmGt){
									ArrayList<Map<String,Object>> childRsm= new ArrayList<Map<String,Object>>();
									BigDecimal rsmGrandTotal= new BigDecimal(0);
									Map<String,Object> rsmMap= new HashMap<String, Object>(); 
									rsmMap.putAll(mapProduct);
									
									String rsmGtPartyId= entryRsmGt.getString("partyIdTo");
									List<GenericValue> asmGt= getChildDepartmentWithRole(delegator, rsmGtPartyId, "DELYS_RSM_GT", "DELYS_ASM_GT",fromDate,thruDate);
									if(UtilValidate.isNotEmpty(asmGt)){
										//get salsup
										for(GenericValue entryAsmGt:asmGt){
											String asmGtPartyId= entryAsmGt.getString("partyIdTo");
											List<GenericValue> salesupList= getChildDepartmentWithRole(delegator, asmGtPartyId, "DELYS_ASM_GT", "DELYS_SALESSUP_GT",fromDate,thruDate);
											//get Distributor
											ArrayList<Map<String,Object>> childAsm= new ArrayList<Map<String,Object>>();
											BigDecimal asmGrandTotal= new BigDecimal(0);
											Map<String,Object> asmMap= new HashMap<String, Object>(); 
											asmMap.putAll(mapProduct);
											if(UtilValidate.isNotEmpty(salesupList)){
												for(GenericValue entrySaleGt:salesupList){
													
													Map<String,Object> mapSales= new HashMap<String, Object>();
													mapSales.putAll(mapProduct);
													BigDecimal saleGrandTotal= new BigDecimal(0);
													ArrayList<Map<String,Object>> childSale= new ArrayList<Map<String,Object>>();
													String salePartyId= entrySaleGt.getString("partyIdTo");
													
													List<GenericValue> disList= getChildDepartmentWithRole(delegator, salePartyId, "DELYS_SALESSUP_GT", "DELYS_DISTRIBUTOR",fromDate,thruDate);
													
													if(UtilValidate.isNotEmpty(disList)){
														for(GenericValue entryDis:disList){
															String disPartyId=entryDis.getString("partyIdTo");
															List<EntityCondition> totalCon= FastList.newInstance();
															totalCon.addAll(conTimer);
															EntityCondition disCon1= EntityCondition.makeCondition("placingCustomer",disPartyId);
															EntityCondition disCon2= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
															totalCon.add(disCon1);
															totalCon.add(disCon2);
															List<GenericValue> orderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(totalCon,EntityJoinOperator.AND), null, null, null, false);
															
															BigDecimal grandTotal= new BigDecimal(0);
										    				Map<String, Object> mapResult= new HashMap<String, Object>();
										    	    		mapResult.putAll(mapProduct);
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
											    					grandTotal= grandTotal.add(extGrossAmount);
											    					if(mapResult.containsKey(productId)){
											    						
											    						BigDecimal quantiexist= (BigDecimal)mapResult.get(productId);
											    						BigDecimal itemTotalquantity= quantiexist.add(quantity);
											    						mapResult.put(productId, itemTotalquantity);
											    						
											    						//update for salesup
											    						BigDecimal salesquanity=(BigDecimal)mapSales.get(productId);
											    						BigDecimal saleItemTotal=salesquanity.add(quantity);
											    						mapSales.put(productId, saleItemTotal);
											    						
											    						//update for asm
											    						BigDecimal asmquanity=(BigDecimal)asmMap.get(productId);
											    						BigDecimal asmItemTotal=asmquanity.add(quantity);
											    						asmMap.put(productId, asmItemTotal);
											    						
											    						//update RSM
											    						BigDecimal rsmquanity=(BigDecimal)rsmMap.get(productId);
											    						BigDecimal rsmItemTotal=rsmquanity.add(quantity);
											    						rsmMap.put(productId, rsmItemTotal);
											    						
											    						//update Csm
											    						
											    						BigDecimal csmquanity=(BigDecimal)csmMap.get(productId);
											    						BigDecimal csmItemTotal=csmquanity.add(quantity);
											    						csmMap.put(productId, csmItemTotal);
											    						
											    						//update ndb
											    						
											    						BigDecimal nsmquanity=(BigDecimal)NbdMap.get(productId);
											    						BigDecimal nsmItemTotal=nsmquanity.add(quantity);
											    						NbdMap.put(productId, nsmItemTotal);
											    						
											    					}
											    				}
											    				
											    			}
											    			saleGrandTotal= saleGrandTotal.add(grandTotal);
											    			mapResult.put("id", i);
											    			mapResult.put("grandTotal", grandTotal);
											    			mapResult.put("name", mapName.get(disPartyId));
											    			childSale.add(mapResult);
											    			i++;
														}
																												
														
													}
													asmGrandTotal= asmGrandTotal.add(saleGrandTotal);
													mapSales.put("grandTotal", asmGrandTotal);
													mapSales.put("id", i);
													mapSales.put("name", mapName.get(salePartyId));
													mapSales.put("child", childSale);
													mapSales.put("expanded", true);
													childAsm.add(mapSales);
													i++;
												}
											}
											rsmGrandTotal=rsmGrandTotal.add(asmGrandTotal);
											asmMap.put("id", i);
											asmMap.put("name", mapName.get(asmGtPartyId));
											asmMap.put("grandTotal", asmGrandTotal);
											asmMap.put("child", childAsm);
											asmMap.put("expanded", true);
											childRsm.add(asmMap);
											i++;
										}
										
									}
									
									csmGrandTotal= csmGrandTotal.add(rsmGrandTotal);
									rsmMap.put("id",i);
									rsmMap.put("grandTotal", rsmGrandTotal);
									rsmMap.put("name", mapName.get(rsmGtPartyId));
									rsmMap.put("child", childRsm);
									rsmMap.put("expanded", true);
									i++;
									childCsm.add(rsmMap);
									
								}
							}
							
							nbdGrandTotal= nbdGrandTotal.add(csmGrandTotal);
							csmMap.put("id", i);
							csmMap.put("grandTotal", csmGrandTotal);
							csmMap.put("name", mapName.get(csmGtPartyId));
							csmMap.put("child", childCsm);
							csmMap.put("expanded", true);
							childNsm.add(csmMap);
							i++;
						}
					}
					
					//get CSM MT
					
					if(UtilValidate.isNotEmpty(csmMtList)){
						for(GenericValue entryCsmMt:csmMtList){
							
							ArrayList<Map<String,Object>> childCsm= new ArrayList<Map<String,Object>>();
							BigDecimal csmGrandTotal= new BigDecimal(0);
							Map<String,Object> csmMap= new HashMap<String, Object>(); 
							csmMap.putAll(mapProduct);
							
							String csmMtPartyId=entryCsmMt.getString("partyIdTo");
							List<GenericValue> rsmMt= getChildDepartmentWithRole(delegator, csmMtPartyId, "DELYS_CSM_MT", "DELYS_RSM_MT",fromDate, thruDate);
							//get ASM GT
							if(UtilValidate.isNotEmpty(rsmMt)){
								for(GenericValue entryRsmMt:rsmMt){
									ArrayList<Map<String,Object>> childRsm= new ArrayList<Map<String,Object>>();
									BigDecimal rsmGrandTotal= new BigDecimal(0);
									Map<String,Object> rsmMap= new HashMap<String, Object>(); 
									rsmMap.putAll(mapProduct);
									
									String rsmMtPartyId= entryRsmMt.getString("partyIdTo");
									List<GenericValue> asmMt= getChildDepartmentWithRole(delegator, rsmMtPartyId, "DELYS_RSM_MT", "DELYS_ASM_MT",fromDate,thruDate);
									if(UtilValidate.isNotEmpty(asmMt)){
										//get salsup
										for(GenericValue entryAsmMt:asmMt){
											String asmMtPartyId= entryAsmMt.getString("partyIdTo");
											List<GenericValue> salesupList= getChildDepartmentWithRole(delegator, asmMtPartyId, "DELYS_ASM_MT", "DELYS_SALESSUP_MT",fromDate,thruDate);
											//get Distributor
											ArrayList<Map<String,Object>> childAsm= new ArrayList<Map<String,Object>>();
											BigDecimal asmGrandTotal= new BigDecimal(0);
											Map<String,Object> asmMap= new HashMap<String, Object>(); 
											asmMap.putAll(mapProduct);
											if(UtilValidate.isNotEmpty(salesupList)){
												for(GenericValue entrySaleMt:salesupList){
													
													Map<String,Object> mapSales= new HashMap<String, Object>();
													mapSales.putAll(mapProduct);
													BigDecimal saleGrandTotal= new BigDecimal(0);
													ArrayList<Map<String,Object>> childSale= new ArrayList<Map<String,Object>>();
													String salePartyId= entrySaleMt.getString("partyIdTo");
													
													List<GenericValue> disList= getChildDepartmentWithRole(delegator, salePartyId, "DELYS_SALESSUP_MT", "DELYS_DISTRIBUTOR",fromDate,thruDate);
													
													if(UtilValidate.isNotEmpty(disList)){
														for(GenericValue entryDis:disList){
															String disPartyId=entryDis.getString("partyIdTo");
															List<EntityCondition> totalCon2= FastList.newInstance();
															totalCon2.addAll(conTimer);
															EntityCondition disCon1= EntityCondition.makeCondition("placingCustomer",disPartyId);
															EntityCondition disCon2= EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
															totalCon2.add(disCon2);
															totalCon2.add(disCon1);
															List<GenericValue> orderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(totalCon2,EntityOperator.AND), null, null, null, false);
															
															BigDecimal grandTotal= new BigDecimal(0);
										    				Map<String, Object> mapResult= new HashMap<String, Object>();
										    	    		mapResult.putAll(mapProduct);
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
											    					grandTotal= grandTotal.add(extGrossAmount);
											    					if(mapResult.containsKey(productId)){
											    						
											    						BigDecimal quantiexist= (BigDecimal)mapResult.get(productId);
											    						BigDecimal itemTotalquantity= quantiexist.add(quantity);
											    						mapResult.put(productId, itemTotalquantity);
											    						
											    						//update for salesup
											    						BigDecimal salesquanity=(BigDecimal)mapSales.get(productId);
											    						BigDecimal saleItemTotal=salesquanity.add(quantity);
											    						mapSales.put(productId, saleItemTotal);
											    						
											    						//update for asm
											    						BigDecimal asmquanity=(BigDecimal)asmMap.get(productId);
											    						BigDecimal asmItemTotal=asmquanity.add(quantity);
											    						asmMap.put(productId, asmItemTotal);
											    						
											    						//update RSM
											    						BigDecimal rsmquanity=(BigDecimal)rsmMap.get(productId);
											    						BigDecimal rsmItemTotal=rsmquanity.add(quantity);
											    						rsmMap.put(productId, rsmItemTotal);
											    						
											    						//update Csm
											    						
											    						BigDecimal csmquanity=(BigDecimal)csmMap.get(productId);
											    						BigDecimal csmItemTotal=csmquanity.add(quantity);
											    						csmMap.put(productId, csmItemTotal);
											    						
											    						//update ndb
											    						
											    						BigDecimal nsmquanity=(BigDecimal)NbdMap.get(productId);
											    						BigDecimal nsmItemTotal=nsmquanity.add(quantity);
											    						NbdMap.put(productId, nsmItemTotal);
											    						
											    					}
											    				}
											    				
											    			}
											    			saleGrandTotal= saleGrandTotal.add(grandTotal);
											    			mapResult.put("id", i);
											    			mapResult.put("grandTotal", grandTotal);
											    			mapResult.put("name", mapName.get(disPartyId));
											    			childSale.add(mapResult);
											    			i++;
														}
																												
														
													}
													asmGrandTotal= asmGrandTotal.add(saleGrandTotal);
													mapSales.put("grandTotal", asmGrandTotal);
													mapSales.put("id", i);
													mapSales.put("name", mapName.get(salePartyId));
													mapSales.put("child", childSale);
													mapSales.put("expanded", true);
													childAsm.add(mapSales);
													i++;
												}
											}
											rsmGrandTotal=rsmGrandTotal.add(asmGrandTotal);
											asmMap.put("id", i);
											asmMap.put("name", mapName.get(asmMtPartyId));
											asmMap.put("grandTotal", asmGrandTotal);
											asmMap.put("child", childAsm);
											asmMap.put("expanded", true);
											childRsm.add(asmMap);
											i++;
										}
										
									}
									
									csmGrandTotal= csmGrandTotal.add(rsmGrandTotal);
									rsmMap.put("id",i);
									rsmMap.put("grandTotal", rsmGrandTotal);
									rsmMap.put("name", mapName.get(rsmMtPartyId));
									rsmMap.put("child", childRsm);
									rsmMap.put("expanded", true);
									i++;
									childCsm.add(rsmMap);
									
								}
							}
							
							nbdGrandTotal= nbdGrandTotal.add(csmGrandTotal);
							csmMap.put("id", i);
							csmMap.put("grandTotal", csmGrandTotal);
							csmMap.put("name", mapName.get(csmMtPartyId));
							csmMap.put("child", childCsm);
							csmMap.put("expanded", true);
							childNsm.add(csmMap);
							i++;
						}
						
					}
					NbdMap.put("grandTotal", nbdGrandTotal);
					NbdMap.put("name", mapName.get(nbdPartyId));
					NbdMap.put("child", childNsm);
					NbdMap.put("id", i);
					NbdMap.put("expanded", true);
					result.add(NbdMap);
					i++;
					
				}
			}
			
		}
		
		CommonReportsServices.toJsonObjectList(result, respone);
	}
	
	public static Map<String,Object> getDataReportTotalProducSalesMan(DispatchContext dcpx, Map<String,?extends Object>context) throws ParseException, GenericEntityException{
		Delegator delegator= dcpx.getDelegator();
		String typeTime= (String)context.get("typeTime");
		String department= (String)context.get("department");
		String year=(String)context.get("year");
		String month=(String)context.get("month");
		String fromDate=(String)context.get("fromDate");
		String thruDate=(String)context.get("thruDate");
		String quarter= (String)context.get("quarter");
		
		List<EntityCondition> prlsCon= FastList.newInstance();
		List<EntityCondition> sloiCon= FastList.newInstance();
		if("YEAR".equals(typeTime) &&UtilValidate.isNotEmpty(year)){
			
			Calendar cal= Calendar.getInstance();
    		cal.set(Calendar.YEAR,Integer.parseInt(year));
    		cal.set(Calendar.MONTH, 11);
    		int maxDay= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    		
    		cal.set(Calendar.DAY_OF_MONTH, maxDay);
    		cal.set(Calendar.HOUR, 0);
    		cal.set(Calendar.MINUTE, 0);
    		cal.set(Calendar.SECOND, 0);
    		
    		Date proThruDate= new Date(cal.getTimeInMillis());
    		cal.set(Calendar.MONTH, 0);
    		cal.set(Calendar.DAY_OF_MONTH, 1);
    		
    		Date proFromDate= new Date(cal.getTimeInMillis());
    		
    		EntityCondition pcon1= EntityCondition.makeCondition("fromDate", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(proThruDate.getTime()));
    		EntityCondition pcon2= EntityCondition.makeCondition("thruDate", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(proFromDate.getTime()));
    		EntityCondition pcon3= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS, null);
    		EntityCondition pcon23= EntityCondition.makeCondition(EntityOperator.OR,pcon2, pcon3);
    		prlsCon.add(pcon1);
    		prlsCon.add(pcon23);
    		
    		EntityCondition ordercon1= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year));
    		sloiCon.add(ordercon1);
    		
		}else if("MONTH".equals(typeTime)&&UtilValidate.isNotEmpty(month)&&UtilValidate.isNotEmpty(year)){
			int cuMont= Integer.parseInt(month)-1;
			Calendar cal= Calendar.getInstance();
			cal.set(Calendar.YEAR, Integer.parseInt(year));
			cal.set(Calendar.MONTH, cuMont);
			
			int maxDay= cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			
			cal.set(Calendar.HOUR, 0);
    		cal.set(Calendar.MINUTE, 0);
    		cal.set(Calendar.SECOND, 0);

    		cal.set(Calendar.DAY_OF_MONTH, 1);
			Date proFromDate= new Date(cal.getTimeInMillis());
			
			cal.set(Calendar.DAY_OF_MONTH, maxDay);
			Date proThruDate= new Date(cal.getTimeInMillis());
			
			EntityCondition pcon1= EntityCondition.makeCondition("fromDate", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(proThruDate.getTime()));
    		EntityCondition pcon2= EntityCondition.makeCondition("thruDate", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(proFromDate.getTime()));
    		EntityCondition pcon3= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS, null);
    		EntityCondition pcon23= EntityCondition.makeCondition(EntityOperator.OR,pcon2, pcon3);

    		prlsCon.add(pcon1);
    		prlsCon.add(pcon23);
    		
    		EntityCondition ordercon1= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year));
    		EntityCondition ordercon2= EntityCondition.makeCondition("orderDateMonthOfYear", Long.parseLong(month));
    		
    		sloiCon.add(ordercon1);
    		sloiCon.add(ordercon2);
    		
    		
		}else if("QUARTER".equals(typeTime)&&UtilValidate.isNotEmpty(quarter)&&UtilValidate.isNotEmpty(year)){
			
			Calendar cal= Calendar.getInstance();
			cal.set(Calendar.YEAR, Integer.parseInt(year));
			
			int beginMonth= Integer.parseInt(quarter)*3-2;
			int endMonth= Integer.parseInt(quarter)*3;
			
			cal.set(Calendar.HOUR, 0);
    		cal.set(Calendar.MINUTE, 0);
    		cal.set(Calendar.SECOND, 0);
    		
    		cal.set(Calendar.MONTH, beginMonth-1);
    		cal.set(Calendar.DAY_OF_MONTH, 1);
    		Date proFromDate= new Date(cal.getTimeInMillis());
    		
    		cal.set(Calendar.MONTH, endMonth-1);
    		int maxDay=cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    		cal.set(Calendar.DAY_OF_MONTH, maxDay);
    		
    		Date proThruDate= new Date(cal.getTimeInMillis());
    		
    		EntityCondition pcon1= EntityCondition.makeCondition("fromDate", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(proThruDate.getTime()));
    		EntityCondition pcon2= EntityCondition.makeCondition("thruDate", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(proFromDate.getTime()));
    		EntityCondition pcon3= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS, null);
    		EntityCondition pcon23= EntityCondition.makeCondition(EntityOperator.OR,pcon2, pcon3);

    		prlsCon.add(pcon1);
    		prlsCon.add(pcon23);
    		
    		EntityCondition ordercon1= EntityCondition.makeCondition("orderDateYearName", Long.parseLong(year));
    		EntityCondition ordercon2= EntityCondition.makeCondition("orderDateQuarterOfYear", Long.parseLong(quarter));
    		
    		sloiCon.add(ordercon1);
    		sloiCon.add(ordercon2);
			
		}else if("DATE".equals(typeTime)&& UtilValidate.isNotEmpty(fromDate)&&UtilValidate.isNotEmpty(thruDate)){
			SimpleDateFormat yearMonthDayFormat = new SimpleDateFormat("dd/MM/yyyy");
			
			Date proFromDate= yearMonthDayFormat.parse(fromDate);
			Date proThruDate= yearMonthDayFormat.parse(thruDate);
			
			EntityCondition pcon1= EntityCondition.makeCondition("fromDate", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Timestamp(proThruDate.getTime()));
    		EntityCondition pcon2= EntityCondition.makeCondition("thruDate", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Timestamp(proFromDate.getTime()));
    		EntityCondition pcon3= EntityCondition.makeCondition("thruDate",EntityOperator.EQUALS, null);
    		EntityCondition pcon23= EntityCondition.makeCondition(EntityOperator.OR,pcon2, pcon3);

    		prlsCon.add(pcon1);
    		prlsCon.add(pcon23);
    		
    		EntityCondition ordercon1= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.GREATER_THAN_EQUAL_TO, new java.sql.Date(proFromDate.getTime()));
			EntityCondition ordercon2= EntityCondition.makeCondition("orderDateDateValue", EntityJoinOperator.LESS_THAN_EQUAL_TO, new java.sql.Date(proThruDate.getTime()));
	
			sloiCon.add(ordercon1);
    		sloiCon.add(ordercon2);
		}
		
		EntityCondition condition3 =EntityCondition.makeCondition("roleTypeIdFrom","INTERNAL_ORGANIZATIO");
		EntityCondition condition4= EntityCondition.makeCondition("roleTypeIdTo","EMPLOYEE");
		EntityCondition condition5= EntityCondition.makeCondition("partyIdFrom",department);
		
		prlsCon.add(condition3);
		prlsCon.add(condition4);
		prlsCon.add(condition5);
		
		EntityFindOptions find= new EntityFindOptions();
    	find.setDistinct(true);
    	Set<String> field= FastSet.newInstance();
    	field.add("partyIdTo");
    	List<GenericValue> partyList= delegator.findList("PartyRelationship", EntityCondition.makeCondition(prlsCon, EntityOperator.AND), field, null, find, false);
    	
    	
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
		ArrayList<Object> result= new ArrayList<Object>();
		if(UtilValidate.isNotEmpty(partyList)){
			EntityCondition ordercon3 = EntityCondition.makeCondition("statusId","ITEM_COMPLETED");
			sloiCon.add(ordercon3);
			
			for(GenericValue entry:partyList){
				String partyId= entry.getString("partyIdTo");
				
				if(mapParyRole.containsKey(partyId)){
					EntityCondition ordercon4= EntityCondition.makeCondition("orderCreatedBy",partyId);
					List<EntityCondition> spCondi= FastList.newInstance();
					spCondi.addAll(sloiCon);
					spCondi.add(ordercon4);
					
					List<GenericValue> oderItem= delegator.findList("SaleOrderItemRelateDimension", EntityCondition.makeCondition(spCondi,EntityJoinOperator.AND), null, null, null, false);
					Object employee[]= new Object[2];
					BigDecimal grandTotal= new BigDecimal(0);
					
					if(UtilValidate.isNotEmpty(oderItem)){
						for(GenericValue item:oderItem){
							BigDecimal extGrossAmount = (BigDecimal) item.getBigDecimal("extGrossAmount");
	    					BigDecimal extTaxAmount= (BigDecimal)item.getBigDecimal("extTaxAmount");
	    					if(UtilValidate.isEmpty(extTaxAmount)){
	    						extTaxAmount= new BigDecimal(0);
	    					}
	    					if(UtilValidate.isEmpty(extGrossAmount)){
	    						
	    						extGrossAmount= new BigDecimal(0);
	    					}
	    					
	    					BigDecimal total= new BigDecimal(0);
	    					total= extGrossAmount.add(extTaxAmount);
	    					grandTotal= grandTotal.add(total);
						}
					}
					
					employee[0]=mapName.get(partyId);
					employee[1]=grandTotal;
					result.add(employee);
				}
			}
		}
		Map<String,Object> rmSult= ServiceUtil.returnSuccess();
		rmSult.put("result", result);
		return rmSult;
	}
	
	
}
