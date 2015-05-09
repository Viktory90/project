package com.olbius.delys.services;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.util.FastList;
import javolution.util.FastMap;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
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
import org.ofbiz.order.order.OrderReadHelper;
import org.ofbiz.order.shoppingcart.ShoppingCart;
import org.ofbiz.product.catalog.CatalogWorker;
import org.ofbiz.product.category.CategoryContentWrapper;
import org.ofbiz.product.category.CategoryWorker;
import org.ofbiz.security.Security;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

public class DistributorServices {
	public static final String module = DistributorServices.class.getName();
	public static final String resource = "widgetUiLabels";
    public static final String resourceError = "widgetErrorUiLabels";
    public static final String resource_error = "OrderUiLabels";
    
    /** Method to get the list party_Id where party role type is RoleTypeId Variable .  */
    public static List<String> getListPartyIdWithRoleType(Delegator delegator, String mstrRoleTypeId) throws GenericEntityException {
        List<String> typeIds = FastList.newInstance();
        List<GenericValue> listPartyIdWithRoleTypes = delegator.findByAnd("PartyRole", UtilMisc.toMap("roleTypeId", mstrRoleTypeId), null, true);
        for (GenericValue listPartyIdWithRoleType : listPartyIdWithRoleTypes) {
            typeIds.add(listPartyIdWithRoleType.getString("partyId"));
        }
        return typeIds;
    }	
    
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListCDARInvoiceByUserLoginDis(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	String partyId = userLogin.getString("partyId");
    	/*Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("parentTypeId", "SALES_INVOICE");
    	mapCondition.put("roleTypeId", "DELYS_DISTRIBUTOR");
    	mapCondition.put("partyIdFrom", "company");
    	mapCondition.put("statusId", "INVOICE_IN_PROCESS");
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);
    	listAllConditions.add(tmpConditon);*/
    	List<String> statusIds = new ArrayList<String>();
    	statusIds.add("INVOICE_IN_PROCESS");
    	statusIds.add("INVOICE_READY");
    	if (UtilValidate.isNotEmpty(partyId)) {
    		try {
        		EntityCondition tmpConditon = 
                        EntityCondition.makeCondition(UtilMisc.<EntityCondition>toList(
                                EntityCondition.makeCondition("parentTypeId", EntityOperator.EQUALS, "PURCHASE_INVOICE"),
                                EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, "company"),
                                EntityCondition.makeCondition("statusId", EntityOperator.IN, statusIds), 
                                EntityCondition.makeCondition("partyIdFrom", EntityOperator.EQUALS, partyId)
                        ), EntityJoinOperator.AND);
        		listAllConditions.add(tmpConditon);
        		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
        		listIterator = delegator.find("InvoiceAndType", tmpConditon, null, null, listSortFields, opts);
    		} catch (Exception e) {
    			String errMsg = "Fatal error calling jqGetListCDARInvoice service: " + e.toString();
    			Debug.logError(e, errMsg, module);
    		}
    	}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListCDAPInvoiceByUserLoginDis(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	GenericValue userLogin = (GenericValue) context.get("userLogin");
    	String partyId = userLogin.getString("partyId");
    	/*Map<String, String> mapCondition = new HashMap<String, String>();
    	mapCondition.put("parentTypeId", "PURCHASE_INVOICE");
    	mapCondition.put("roleTypeId", "DELYS_DISTRIBUTOR");
    	mapCondition.put("partyId", "company");
    	mapCondition.put("statusId", "INVOICE_IN_PROCESS");
    	EntityCondition tmpConditon = EntityCondition.makeCondition(mapCondition);*/
    	List<String> statusIds = new ArrayList<String>();
    	statusIds.add("INVOICE_IN_PROCESS");
    	statusIds.add("INVOICE_READY");
    	if (UtilValidate.isNotEmpty(partyId)) {
    		try {
        		EntityCondition tmpConditon = 
                        EntityCondition.makeCondition(UtilMisc.<EntityCondition>toList(
                                EntityCondition.makeCondition("parentTypeId", EntityOperator.EQUALS, "SALES_INVOICE"),
                                EntityCondition.makeCondition("partyIdFrom", EntityOperator.EQUALS, "company"),
                                EntityCondition.makeCondition("statusId", EntityOperator.IN, statusIds), 
                                EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, partyId)
                        ), EntityJoinOperator.AND);
        		listAllConditions.add(tmpConditon);
        		tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
        		listIterator = delegator.find("InvoiceAndType", tmpConditon, null, null, listSortFields, opts);
    		} catch (Exception e) {
    			String errMsg = "Fatal error calling jqGetListCDAPInvoice service: " + e.toString();
    			Debug.logError(e, errMsg, module);
    		}
    	}
    	successResult.put("listIterator", listIterator);
    	return successResult;
    }
	/*public static Map<String, Object> getListCategoryProductDis(DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		List<GenericValue> listCategory = new ArrayList<GenericValue>();
		List<GenericValue> listProduct = new ArrayList<GenericValue>();
		List<String> listCategoryStr = new ArrayList<String>();
		List<String> listProductStr = new ArrayList<String>();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		Locale locale = (Locale) context.get("locale");
		String partyId = userLogin.getString("partyId");
		if (UtilValidate.isNotEmpty(partyId)) {
			try {
				List<GenericValue> listProductStoreOwner = delegator.findByAnd("ProductStoreRole", UtilMisc.toMap("partyId", partyId, "roleTypeId", "OWNER"), null, false);
				List<GenericValue> listProductStoreCatalog = new ArrayList<GenericValue>();
				List<GenericValue> listProductStoreCategoryProduct = new ArrayList<GenericValue>();
				if (listProductStoreOwner != null) {
					for (GenericValue storeItem : listProductStoreOwner) {
						List<GenericValue> listCatalogTemp = delegator.findByAnd("ProductStoreCatalog", UtilMisc.toMap("productStoreId", storeItem.getString("productStoreId")), null, false);
						if (listCatalogTemp != null) {
							listProductStoreCatalog.addAll(listCatalogTemp);
						}
					}
					for (GenericValue catalogItem : listProductStoreCatalog) {
						List<GenericValue> listCategoryProductTemp = delegator.findByAnd("ProdCatalogCategoryAndProduct", UtilMisc.toMap("prodCatalogId", catalogItem.getString("prodCatalogId")), null, false);
						listProductStoreCategoryProduct.addAll(listCategoryProductTemp);
					}
					for (GenericValue categoryProductItem : listProductStoreCategoryProduct) {
						if (!listCategoryStr.contains(categoryProductItem.getString("productCategoryId"))) {
							listCategoryStr.add(categoryProductItem.getString("productCategoryId"));
						}
						if (!listProductStr.contains(categoryProductItem.getString("productId"))) {
							listProductStr.add(categoryProductItem.getString("productId"));
						}
					}
					for (String categoryStrItem : listCategoryStr) {
						GenericValue categoryTemp = delegator.findOne("ProductCategory", UtilMisc.toMap("productCategoryId", categoryStrItem), false);
						listCategory.add(categoryTemp);
					}
					for (String productStrItem : listProductStr) {
						GenericValue productTemp = delegator.findOne("Product", UtilMisc.toMap("productId", productStrItem), false);
						listProduct.add(productTemp);
					}
				}
			} catch (GenericEntityException e) {
	            Debug.logWarning(e, module);
	            Map<String, String> messageMap = UtilMisc.toMap("errMessage", e.getMessage());
	            String errMsg = UtilProperties.getMessage("CommonUiLabels", "CommonDatabaseProblem", messageMap, locale);
	            return ServiceUtil.returnError(errMsg);
			}
		}
		successResult.put("listCategory", listCategory);
		successResult.put("listProduct", listProduct);
		return successResult;
	}*/
	
    @SuppressWarnings("rawtypes")
	public static void toJsonObjectList(List attrList, HttpServletResponse response){
        StringBuilder jsonBuilder = new StringBuilder("[");
        for (Object attrMap : attrList) {
            JSONObject json = JSONObject.fromObject(attrMap);
            jsonBuilder.append(json.toString());
            jsonBuilder.append(',');
        }
        jsonBuilder.append("{ } ]");
        String jsonStr = jsonBuilder.toString();
        if (UtilValidate.isEmpty(jsonStr)) {
            Debug.logError("JSON Object was empty; fatal error!",module);
        }
        // set the X-JSON content type
        response.setContentType("application/json");
        // jsonStr.length is not reliable for unicode characters
        try {
            response.setContentLength(jsonStr.getBytes("UTF8").length);
        } catch (UnsupportedEncodingException e) {
            Debug.logError("Problems with Json encoding",module);
        }
        // return the JSON String
        Writer out;
        try {
            out = response.getWriter();
            out.write(jsonStr);
            out.flush();
        } catch (IOException e) {
            Debug.logError("Unable to get response writer",module);
        }
    }
	
	// Please note : the structure of map in this function is according to the JSON data map of the jsTree
    @SuppressWarnings({ "unchecked", "rawtypes" })
    public static void getChildCategoryTree(HttpServletRequest request, HttpServletResponse response){
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        String productCategoryId = request.getParameter("productCategoryId");
        String isCatalog = request.getParameter("isCatalog");
        String isCategoryType = request.getParameter("isCategoryType");
        String onclickFunction = request.getParameter("onclickFunction");
        String additionParam = request.getParameter("additionParam");
        String hrefString = request.getParameter("hrefString");
        String hrefString2 = request.getParameter("hrefString2");
        String entityName = null;
        String primaryKeyName = null;
        
        if (isCatalog.equals("true")) {
            entityName = "ProdCatalog";
            primaryKeyName = "prodCatalogId";
        } else {
            entityName = "ProductCategory";
            primaryKeyName = "productCategoryId";
        }
        
        List categoryList = FastList.newInstance();
        List<GenericValue> childOfCats;
        List<String> sortList = org.ofbiz.base.util.UtilMisc.toList("sequenceNum", "title");
        
        try {
            GenericValue category = delegator.findOne(entityName ,UtilMisc.toMap(primaryKeyName, productCategoryId), false);
            if (UtilValidate.isNotEmpty(category)) {
                if (isCatalog.equals("true") && isCategoryType.equals("false")) {
                    CategoryWorker.getRelatedCategories(request, "ChildCatalogList", CatalogWorker.getCatalogTopCategoryId(request, productCategoryId), true);
                    childOfCats = EntityUtil.filterByDate((List<GenericValue>) request.getAttribute("ChildCatalogList"));
                    
                } else if(isCatalog.equals("false") && isCategoryType.equals("false")){
                    childOfCats = EntityUtil.filterByDate(delegator.findByAnd("ProductCategoryRollupAndChild", UtilMisc.toMap(
                            "parentProductCategoryId", productCategoryId ), null, false));
                } else {
                    childOfCats = EntityUtil.filterByDate(delegator.findByAnd("ProdCatalogCategory", UtilMisc.toMap("prodCatalogId", productCategoryId), null, false));
                }
                if (UtilValidate.isNotEmpty(childOfCats)) {
                        
                    for (GenericValue childOfCat : childOfCats ) {
                        
                        Object catId = null;
                        String catNameField = null;
                        int countProduct = 0;
                        
                        catId = childOfCat.get("productCategoryId");
                        catNameField = "CATEGORY_NAME";
                        
                        Map josonMap = FastMap.newInstance();
                        List<GenericValue> childList = null;
                        
                        // Get the child list of chosen category
                        childList = EntityUtil.filterByDate(delegator.findByAnd("ProductCategoryRollup", UtilMisc.toMap(
                                    "parentProductCategoryId", catId), null, false));
                        
                        // Get the chosen category information for the categoryContentWrapper
                        GenericValue cate = delegator.findOne("ProductCategory" ,UtilMisc.toMap("productCategoryId",catId), false);
                        
                        //Count product size in category
                        EntityFindOptions findOptions = new EntityFindOptions();
                        findOptions.setDistinct(true);
                        List<EntityCondition> allCondition = new ArrayList<EntityCondition>();
                        //List<EntityCondition> orCondition = new ArrayList<EntityCondition>();
                        allCondition.add(EntityCondition.makeCondition("productCategoryId", EntityOperator.EQUALS, cate.getString("productCategoryId")));
                        //orCondition.add(EntityCondition.makeCondition("thruDate", EntityOperator.LIKE, ""));
                        //orCondition.add(EntityCondition.makeCondition("thruDate", EntityOperator.GREATER_THAN, UtilDateTime.nowTimestamp()));
                        //allCondition.add(EntityCondition.makeCondition(orCondition, EntityOperator.OR));
                        //Long countProductLong = delegator.findCountByCondition("ProductCategoryMember", EntityCondition.makeCondition(allCondition, EntityOperator.AND), null, findOptions);
                        
                        List<GenericValue> listProduct = null;
                        listProduct = delegator.findList("ProductCategoryMember", EntityCondition.makeCondition(allCondition, EntityOperator.AND), null, null, findOptions, false);
                        if (listProduct != null) {
                        	listProduct = EntityUtil.filterByDate(listProduct);
                        	countProduct = listProduct.size();
                        }
                        
                        // If chosen category's child exists, then put the arrow before category icon
                        if (UtilValidate.isNotEmpty(childList)) {
                            josonMap.put("state", "closed");
                        }
                        Map dataMap = FastMap.newInstance();
                        Map dataAttrMap = FastMap.newInstance();
                        CategoryContentWrapper categoryContentWrapper = new CategoryContentWrapper(cate, request);
                        
                        String title = null;
                        if (UtilValidate.isNotEmpty(categoryContentWrapper.get(catNameField))) {
                            title = categoryContentWrapper.get(catNameField)+" "+"["+catId+"] (" + countProduct + ")";
                            dataMap.put("title", title);
                        } else {
                            title = catId.toString();
                            dataMap.put("title", catId);
                        }
                        dataAttrMap.put("onClick", onclickFunction + "('" + catId + "','" + countProduct + additionParam + "')");
                        
                        String hrefStr = hrefString + catId;
                        if (UtilValidate.isNotEmpty(hrefString2)) {
                            hrefStr = hrefStr + hrefString2;
                        }
                        dataAttrMap.put("href", hrefStr);
                        
                        dataMap.put("attr", dataAttrMap);
                        josonMap.put("data", dataMap);
                        Map attrMap = FastMap.newInstance();
                        attrMap.put("id", catId);
                        attrMap.put("isCatalog", false);
                        attrMap.put("rel", "CATEGORY");
                        josonMap.put("attr",attrMap);
                        josonMap.put("sequenceNum",childOfCat.get("sequenceNum"));
                        josonMap.put("title",title);
                        
                        categoryList.add(josonMap);
                    }
                    List<Map<Object, Object>> sortedCategoryList = UtilMisc.sortMaps(categoryList, sortList);
                    toJsonObjectList(sortedCategoryList,response);
                }
            }
        } catch (GenericEntityException e) {
            e.printStackTrace();
        }
    }
	
	public static Map<String, Object> getListSalesmanDis (DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = userLogin.getString("partyId");
		List<GenericValue> listSalesman = new ArrayList<GenericValue>();
		if (UtilValidate.isNotEmpty(partyId)) {
			try {
				listSalesman = EntityUtil.filterByDate(delegator.findByAnd("PartyRelationshipAndDetail", UtilMisc.toMap("partyIdFrom", partyId, "roleTypeIdFrom", "DELYS_DISTRIBUTOR", "roleTypeIdTo", "DELYS_SALESMAN_GT"), null, false));
			} catch (Exception e) {
				String errMsg = "Fatal error calling jqGetListCDARInvoice service: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
		}
		successResult.put("listSalesman", listSalesman);
		return successResult;
	}
	
	public static Map<String, Object> getListCustomerDis (DispatchContext ctx, Map<String, Object> context) {
		Delegator delegator = ctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = userLogin.getString("partyId");
		List<GenericValue> listCustomer = new ArrayList<GenericValue>();
		if (UtilValidate.isNotEmpty(partyId)) {
			try {
				List<GenericValue> listRouter = new ArrayList<GenericValue>();
				//get list salesman of Distributor. Is salesman = partyIdTo
				List<GenericValue> listSM = EntityUtil.filterByDate(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdFrom", partyId, "roleTypeIdFrom", "DELYS_DISTRIBUTOR", "roleTypeIdTo", "DELYS_SALESMAN_GT"), null, false));
				if (listSM != null) {
					for (GenericValue smItem : listSM) {
						//get list router of each salesman. Is router = partyIdFrom
						List<GenericValue> listRouterTemp = EntityUtil.filterByDate(delegator.findByAnd("PartyRelationship", UtilMisc.toMap("partyIdTo", smItem.getString("partyIdTo"), "roleTypeIdFrom", "DELYS_ROUTE", "roleTypeIdTo", "DELYS_SALESMAN_GT"), null, false));
						if (listRouterTemp != null) {
							listRouter.addAll(listRouterTemp);
						}
					}
				}
				for (GenericValue routerItem : listRouter) {
					// get list customer of each route. Is customer = partyIdTo
					List<GenericValue> listCustTemp = EntityUtil.filterByDate(delegator.findByAnd("PartyRelationshipAndDetail", UtilMisc.toMap("partyIdFrom", routerItem.getString("partyIdFrom"), "roleTypeIdFrom", "DELYS_ROUTE", "roleTypeIdTo", "DELYS_CUSTOMER_GT"), null, false));
					if (listCustTemp != null) {
						listCustomer.addAll(listCustTemp);
					}
				}
			} catch (Exception e) {
				String errMsg = "Fatal error calling jqGetListCDARInvoice service: " + e.toString();
				Debug.logError(e, errMsg, module);
			}
		}
		successResult.put("listCustomer", listCustomer);
		return successResult;
	}
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListProductByCategoryCatalog(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String catalogId = (String) parameters.get("catalogId")[0];
    	HttpServletRequest request = (HttpServletRequest) context.get("request");
    	List<GenericValue> listGenericValue = null;
    	try {
    		if (UtilValidate.isNotEmpty(catalogId)) {
    			GenericValue catalogObj = delegator.findOne("ProdCatalog", UtilMisc.toMap("prodCatalogId", catalogId), false);
    			if (catalogObj != null) {
    				List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> orConditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> mainConditionList = new ArrayList<EntityCondition>();
    	    		// do not include configurable products
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED_SERVICE"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGR_DIGSERV"));
    				conditionList.add(EntityCondition.makeCondition("prodCatalogId", EntityOperator.EQUALS, catalogId));
    				EntityCondition conditions = EntityCondition.makeCondition(conditionList, EntityOperator.AND);
    				// no virtual products: note that isVirtual could be null,
    				// we consider those products to be non-virtual and hence addable to the order in bulk
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, "N"));
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, null));
    				EntityCondition orConditions = EntityCondition.makeCondition(orConditionList, EntityOperator.OR);
    				mainConditionList.add(orConditions);
    				mainConditionList.add(conditions);
    	    		//delegator.findList("ProdCatalogCategoryAndProduct", mainConditions, ["productId", "brandName", "internalName"] as Set, ["productId"], null, false);
    				listAllConditions.addAll(mainConditionList);
    				
    				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    				if (UtilValidate.isEmpty(listSortFields)) {
    					listSortFields.add("sequenceNumCategory");
    					listSortFields.add("sequenceNumRollup");
    					listSortFields.add("sequenceNumProduct");
    				}
    				
    				listIterator = delegator.find("ProdCatalogCategoryAndProduct", tmpConditon, null, null, listSortFields, opts);
    				
    				if (request != null) {
    					listGenericValue = listIterator.getCompleteList();
    					HttpSession session = request.getSession();
    					ShoppingCart cart = (ShoppingCart) session.getAttribute("shoppingCart");
    					if (cart != null) {
	    					List<GenericValue> orderItems = cart.makeOrderItems();
	    					for (GenericValue orderItem : orderItems) {
								for (GenericValue itemValue : listGenericValue) {
									if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(itemValue.getString("productId"))) {
										itemValue.put("productPackingUomId", orderItem.getString("quantityUomId"));
									}
								}
							}
    					}
    					listIterator.close();
    				}
    			}
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductByCategoryCatalog service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	if (request != null) {
    		successResult.put("listIterator", listGenericValue);
    	} else {
    		successResult.put("listIterator", listIterator);
    	}
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListProductAndTaxByCatalog(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	EntityListIterator listIterator = null;
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String catalogId = (String) parameters.get("catalogId")[0];
    	HttpServletRequest request = (HttpServletRequest) context.get("request");
    	List<GenericValue> listGenericValue = null;
    	try {
    		if (UtilValidate.isNotEmpty(catalogId)) {
    			GenericValue catalogObj = delegator.findOne("ProdCatalog", UtilMisc.toMap("prodCatalogId", catalogId), false);
    			if (catalogObj != null) {
    				List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> orConditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> mainConditionList = new ArrayList<EntityCondition>();
    	    		// do not include configurable products
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED_SERVICE"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGR_DIGSERV"));
    				conditionList.add(EntityCondition.makeCondition("prodCatalogId", EntityOperator.EQUALS, catalogId));
    				EntityCondition conditions = EntityCondition.makeCondition(conditionList, EntityOperator.AND);
    				// no virtual products: note that isVirtual could be null,
    				// we consider those products to be non-virtual and hence addable to the order in bulk
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, "N"));
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, null));
    				EntityCondition orConditions = EntityCondition.makeCondition(orConditionList, EntityOperator.OR);
    				mainConditionList.add(orConditions);
    				mainConditionList.add(conditions);
    	    		//delegator.findList("ProdCatalogCategoryAndProduct", mainConditions, ["productId", "brandName", "internalName"] as Set, ["productId"], null, false);
    				listAllConditions.addAll(mainConditionList);
    				
    				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    				if (UtilValidate.isEmpty(listSortFields)) {
    					listSortFields.add("sequenceNumCategory");
    					listSortFields.add("sequenceNumRollup");
    					listSortFields.add("sequenceNumProduct");
    				}
    				
    				listIterator = delegator.find("ProdCatalogCategoryAndTaxAuthorityRate", tmpConditon, null, null, listSortFields, opts);
    				
    				if (request != null) {
    					listGenericValue = listIterator.getCompleteList();
    					HttpSession session = request.getSession();
    					ShoppingCart cart = (ShoppingCart) session.getAttribute("shoppingCart");
    					if (cart != null) {
	    					List<GenericValue> orderItems = cart.makeOrderItems();
	    					for (GenericValue orderItem : orderItems) {
								for (GenericValue itemValue : listGenericValue) {
									if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(itemValue.getString("productId"))) {
										itemValue.put("productPackingUomId", orderItem.getString("quantityUomId"));
									}
								}
							}
    					}
    					listIterator.close();
    				}
    			}
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductAndTaxByCatalog service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	if (request != null) {
    		successResult.put("listIterator", listGenericValue);
    	} else {
    		successResult.put("listIterator", listIterator);
    	}
    	return successResult;
    }
	
	// return List Map
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListProductByCategoryCatalogLM(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String catalogId = (String) parameters.get("catalogId")[0];
    	String productStoreId = "";
    	if (parameters.containsKey("productStoreId")) {
    		productStoreId = (String) parameters.get("productStoreId")[0];
    	}
    	HttpServletRequest request = (HttpServletRequest) context.get("request");
    	try {
    		if (UtilValidate.isNotEmpty(catalogId)) {
    			GenericValue catalogObj = delegator.findOne("ProdCatalog", UtilMisc.toMap("prodCatalogId", catalogId), false);
    			if (catalogObj != null) {
    				List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> orConditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> mainConditionList = new ArrayList<EntityCondition>();
    	    		// do not include configurable products
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED_SERVICE"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGR_DIGSERV"));
    				conditionList.add(EntityCondition.makeCondition("prodCatalogId", EntityOperator.EQUALS, catalogId));
    				EntityCondition conditions = EntityCondition.makeCondition(conditionList, EntityOperator.AND);
    				// no virtual products: note that isVirtual could be null,
    				// we consider those products to be non-virtual and hence addable to the order in bulk
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, "N"));
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, null));
    				EntityCondition orConditions = EntityCondition.makeCondition(orConditionList, EntityOperator.OR);
    				mainConditionList.add(orConditions);
    				mainConditionList.add(conditions);
    	    		//delegator.findList("ProdCatalogCategoryAndProduct", mainConditions, ["productId", "brandName", "internalName"] as Set, ["productId"], null, false);
    				listAllConditions.addAll(mainConditionList);
    				
    				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    				if (UtilValidate.isEmpty(listSortFields)) {
    					listSortFields.add("sequenceNumCategory");
    					listSortFields.add("sequenceNumRollup");
    					listSortFields.add("sequenceNumProduct");
    				}
    				
    				List<GenericValue> listProdGeneric = delegator.findList("ProdCatalogCategoryAndProduct", tmpConditon, null, listSortFields, opts, false);
    	    		if (UtilValidate.isNotEmpty(listProdGeneric)) {
    	    			boolean hasCart = false;
    	    			List<GenericValue> orderItems = new ArrayList<GenericValue>();
    	    			if (request != null) {
    	    				HttpSession session = request.getSession();
        					ShoppingCart cart = (ShoppingCart) session.getAttribute("shoppingCart");
        					if (cart != null) {
        						orderItems = cart.makeOrderItems();
        						hasCart = true;
        					}
    	    			}
    	    			for (GenericValue itemProd : listProdGeneric) {
    	    				Map<String, Object> row = new HashMap<String, Object>();
    	    				/* [{ name: 'productId', type: 'string' }, { name: 'productName', type: 'string' },
		               		{ name: 'quantityUomId', type: 'string'}, { name: 'productPackingUomId', type: 'string'},
		               		{ name: 'expireDate', type: 'string' }, { name: 'quantity', type: 'number', formatter: 'integer'} */
    	    				row.put("productId", itemProd.get("productId"));
    	    				row.put("productName", itemProd.get("productName"));
    	    				row.put("productPackingUomId", itemProd.get("productPackingUomId"));
    	    				row.put("quantityUomId", itemProd.getString("productPackingUomId"));
    	    				
    	    				// column: packingUomId
    	    				EntityCondition condsItem = EntityCondition.makeCondition(UtilMisc.toMap("productId", itemProd.get("productId"), "uomToId", itemProd.get("quantityUomId")));
    	    				EntityFindOptions optsItem = new EntityFindOptions();
    	    				optsItem.setDistinct(true);
    	    				List<GenericValue> listConfigPacking = FastList.newInstance();
    	    				listConfigPacking.addAll(delegator.findList("ConfigPackingAndUom", condsItem, null, null, optsItem, false));
	    					List<Map<String, Object>> listQuantityUomIdByProduct = new ArrayList<Map<String, Object>>();
	    					//List<String> listTmp = EntityUtil.getFieldListFromEntityList(listConfigPacking, "uomFromId", true);
	    					//if (listTmp != null) listQuantityUomIdByProduct.addAll(listTmp);
	    					//listQuantityUomIdByProduct.add(itemProd.getString("quantityUomId"));
    						for (GenericValue conPackItem : listConfigPacking) {
    							Map<String, Object> packingUomIdMap = FastMap.newInstance();
    							packingUomIdMap.put("description", conPackItem.getString("descriptionFrom"));
    							packingUomIdMap.put("uomId", conPackItem.getString("uomFromId"));
    							listQuantityUomIdByProduct.add(packingUomIdMap);
	    					}
    						GenericValue quantityUom = delegator.findOne("Uom", UtilMisc.toMap("uomId", itemProd.get("quantityUomId")), false);
    						if (quantityUom != null) {
    							Map<String, Object> packingUomIdMap = FastMap.newInstance();
    							packingUomIdMap.put("description", quantityUom.getString("description"));
    							packingUomIdMap.put("uomId", quantityUom.getString("uomId"));
    							listQuantityUomIdByProduct.add(packingUomIdMap);
    						}
    	    				row.put("packingUomId", listQuantityUomIdByProduct);
    	    				
    	    				// column: expireDate
    	    				List<Map<String, Object>> listExpireDateByProduct = new ArrayList<Map<String,Object>>();
    	    				List<EntityCondition> exConds = FastList.newInstance();
    	    				exConds.add(EntityCondition.makeCondition("productStoreId", productStoreId));
    	    				exConds.add(EntityCondition.makeCondition("productId", itemProd.getString("productId")));
    	    				// productStoreId, fromDate, thruDate, productId, statusId, expireDate, uomId, quantityOnHandTotal, availableToPromiseTotal
    	    				EntityListIterator iterQuantityInventorySum = delegator.find("ProductStoreFacilityInventorySumAtpqoh", EntityCondition.makeCondition(exConds, EntityOperator.AND), EntityCondition.makeCondition("quantityOnHandTotal", EntityOperator.GREATER_THAN, BigDecimal.ZERO), null, null, null);
    	    				if (iterQuantityInventorySum != null) {
    	    					List<GenericValue> listQuantityInventorySum = iterQuantityInventorySum.getCompleteList();
    	    					if (listQuantityInventorySum != null) {
    	    						listQuantityInventorySum = EntityUtil.filterByDate(listQuantityInventorySum);
    	    						for (GenericValue quantityInventoryItem : listQuantityInventorySum) {
    	    							Map<String, Object> mapItem = FastMap.newInstance();
    	    							mapItem.put("expireDate", quantityInventoryItem.getString("expireDate"));
    	    							mapItem.put("qohTotal", quantityInventoryItem.get("quantityOnHandTotal"));
    	    							mapItem.put("atpTotal", quantityInventoryItem.get("availableToPromiseTotal"));
    	    							listExpireDateByProduct.add(mapItem);
    	    						}
    	    					}
    	    					iterQuantityInventorySum.close();
    	    				}
    	    				row.put("expireDateList", listExpireDateByProduct);
    	    				
    	    				/*<#-- NOTE: Delivered for serialized inventory means shipped to customer so they should not be displayed here any more -->
		            		<#assign productInventoryItems = delegator.findByAnd("InventoryItemFilterAtpQoh", {"productId" : productId}, ['facilityId', '-datetimeReceived', '-inventoryItemId'], false) />
		            		<#if productInventoryItems?exists && productInventoryItems?has_content && productInventoryItems?size &gt; 0>
		            			<select name="fromInventoryItemId_${cartLineIndex}" style="width:150px; margin-bottom:0px">
		            				<option value=""></option>
			            			<#list productInventoryItems as inventoryItem>
			            				<#if inventoryItem.inventoryItemTypeId?if_exists == "NON_SERIAL_INV_ITEM">
											<#if inventoryItem.curInventoryItemTypeId?exists>
					            				<option value="${(inventoryItem.inventoryItemId)?if_exists}" 
					            					<#if cartLine.getAttribute("fromInventoryItemId")?exists && cartLine.getAttribute("fromInventoryItemId") == inventoryItem.inventoryItemId>selected="selected"</#if>>
					            					<#if inventoryItem.expireDate?exists>${(inventoryItem.expireDate)?string("dd/MM/yyyy")}
					            					<#else>__/__/____</#if>
					            					, 
					            					<#if inventoryItem.inventoryItemTypeId?if_exists == "NON_SERIAL_INV_ITEM">
														${(inventoryItem.availableToPromiseTotal)?default("NA")}
														/ ${(inventoryItem.quantityOnHandTotal)?default("NA")}
													</#if>
													,
				            					 	<#if inventoryItem.facilityId?exists>
					            					 	${inventoryItem.facilityId}
				            					 	<#else>
					            					 	<#if inventoryItem.containerId?exists>
					            					 		${inventoryItem.containerId}
					            					 	</#if>
				            					 	</#if>
				            					 	
					            				</option>
				            				</#if>
			            				</#if>
			            			</#list>
			            		</select>
			            	<#else>
			            		<select name="fromInventoryItemId" style="width:150px; margin-bottom:0px" disabled>
		            				<option value=""></option>
		            			</select>
		            		</#if>
    	    				 */
    	    				
    	    				// columns: quantityUomId, quantity, expireDate
    	    				row.put("expireDate", "");
    	    				if (hasCart) {
    	    					for (GenericValue orderItem : orderItems) {
    	    						if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(itemProd.getString("productId"))) {
    	    							row.put("quantityUomId", orderItem.getString("quantityUomId"));
    	    							row.put("quantity", orderItem.get("alternativeQuantity"));
    	    							row.put("expireDate", orderItem.getString("expireDate"));
									}
    	    					}
    	    				}
    	    				row.put("qohTotal", "");
    	    				row.put("atpTotal", "");
    	    				listIterator.add(row);
    	    			}
    	    		}
    				
    				//listIterator = delegator.find("ProdCatalogCategoryAndProduct", tmpConditon, null, null, listSortFields, opts);
    				/*if (request != null) {
    					listGenericValue = listIterator.getCompleteList();
    					HttpSession session = request.getSession();
    					ShoppingCart cart = (ShoppingCart) session.getAttribute("shoppingCart");
    					if (cart != null) {
	    					List<GenericValue> orderItems = cart.makeOrderItems();
	    					for (GenericValue orderItem : orderItems) {
								for (GenericValue itemValue : listGenericValue) {
									if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(itemValue.getString("productId"))) {
										itemValue.put("productPackingUomId", orderItem.getString("quantityUomId"));
									}
								}
							}
    					}
    					listIterator.close();
    				}*/
    			}
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductByCategoryCatalogLM service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	
		successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	@SuppressWarnings("unchecked")
    public static Map<String, Object> jqGetListProductByCategoryCatalogByOrder(DispatchContext ctx, Map<String, Object> context) {
    	Delegator delegator = ctx.getDelegator();
    	Map<String, Object> successResult = ServiceUtil.returnSuccess();
    	//EntityListIterator listIterator = null;
    	List<Map<String, Object>> listIterator = FastList.newInstance();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context.get("listAllConditions");
    	List<String> listSortFields = (List<String>) context.get("listSortFields");
    	EntityFindOptions opts =(EntityFindOptions) context.get("opts");
    	Map<String,String[]> parameters = (Map<String, String[]>) context.get("parameters");
    	String catalogId = (String) parameters.get("catalogId")[0];
    	String productStoreId = "";
    	String orderId = "";
    	if (parameters.containsKey("productStoreId")) {
    		productStoreId = (String) parameters.get("productStoreId")[0];
    	}
    	if (parameters.containsKey("orderId")) {
    		orderId = (String) parameters.get("orderId")[0];
    	}
    	try {
    		if (UtilValidate.isNotEmpty(catalogId)) {
    			GenericValue catalogObj = delegator.findOne("ProdCatalog", UtilMisc.toMap("prodCatalogId", catalogId), false);
    			if (catalogObj != null) {
    				List<EntityCondition> conditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> orConditionList = new ArrayList<EntityCondition>();
    	    		List<EntityCondition> mainConditionList = new ArrayList<EntityCondition>();
    	    		// do not include configurable products
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGREGATED_SERVICE"));
    				conditionList.add(EntityCondition.makeCondition("productTypeId", EntityOperator.NOT_EQUAL, "AGGR_DIGSERV"));
    				conditionList.add(EntityCondition.makeCondition("prodCatalogId", EntityOperator.EQUALS, catalogId));
    				EntityCondition conditions = EntityCondition.makeCondition(conditionList, EntityOperator.AND);
    				// no virtual products: note that isVirtual could be null,
    				// we consider those products to be non-virtual and hence addable to the order in bulk
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, "N"));
    				orConditionList.add(EntityCondition.makeCondition("isVirtual", EntityOperator.EQUALS, null));
    				EntityCondition orConditions = EntityCondition.makeCondition(orConditionList, EntityOperator.OR);
    				mainConditionList.add(orConditions);
    				mainConditionList.add(conditions);
    	    		//delegator.findList("ProdCatalogCategoryAndProduct", mainConditions, ["productId", "brandName", "internalName"] as Set, ["productId"], null, false);
    				listAllConditions.addAll(mainConditionList);
    				
    				EntityCondition tmpConditon = EntityCondition.makeCondition(listAllConditions,EntityJoinOperator.AND);
    				if (UtilValidate.isEmpty(listSortFields)) {
    					listSortFields.add("sequenceNumCategory");
    					listSortFields.add("sequenceNumRollup");
    					listSortFields.add("sequenceNumProduct");
    				}
    				
    				List<GenericValue> listProdGeneric = delegator.findList("ProdCatalogCategoryAndProduct", tmpConditon, null, listSortFields, opts, false);
    	    		if (UtilValidate.isNotEmpty(listProdGeneric)) {
    	    			boolean hasCart = false;
    	    			List<GenericValue> orderItems = new ArrayList<GenericValue>();
    	    			if (UtilValidate.isNotEmpty(orderId)) {
    	    				GenericValue orderHeader = delegator.findOne("OrderHeader", UtilMisc.toMap("orderId", orderId), false);
    	    				if (orderHeader != null) {
    	    					orderItems = delegator.findByAnd("OrderItem", UtilMisc.toMap("orderId", orderId), null, false);
    	    					if (orderItems != null) {
    	    						hasCart = true;
    	    					}
    	    				}
    	    			}
    	    			for (GenericValue itemProd : listProdGeneric) {
    	    				Map<String, Object> row = new HashMap<String, Object>();
    	    				/* [{ name: 'productId', type: 'string' }, { name: 'productName', type: 'string' },
		               		{ name: 'quantityUomId', type: 'string'}, { name: 'productPackingUomId', type: 'string'},
		               		{ name: 'expireDate', type: 'string' }, { name: 'quantity', type: 'number', formatter: 'integer'} */
    	    				row.put("productId", itemProd.get("productId"));
    	    				row.put("productName", itemProd.get("productName"));
    	    				row.put("productPackingUomId", itemProd.get("productPackingUomId"));
    	    				row.put("quantityUomId", itemProd.getString("productPackingUomId"));
    	    				
    	    				// column: packingUomId
    	    				EntityCondition condsItem = EntityCondition.makeCondition(UtilMisc.toMap("productId", itemProd.get("productId"), "uomToId", itemProd.get("quantityUomId")));
    	    				EntityFindOptions optsItem = new EntityFindOptions();
    	    				optsItem.setDistinct(true);
    	    				List<GenericValue> listConfigPacking = FastList.newInstance();
    	    				listConfigPacking.addAll(delegator.findList("ConfigPackingAndUom", condsItem, null, null, optsItem, false));
	    					List<Map<String, Object>> listQuantityUomIdByProduct = new ArrayList<Map<String, Object>>();
	    					//List<String> listTmp = EntityUtil.getFieldListFromEntityList(listConfigPacking, "uomFromId", true);
	    					//if (listTmp != null) listQuantityUomIdByProduct.addAll(listTmp);
	    					//listQuantityUomIdByProduct.add(itemProd.getString("quantityUomId"));
    						for (GenericValue conPackItem : listConfigPacking) {
    							Map<String, Object> packingUomIdMap = FastMap.newInstance();
    							packingUomIdMap.put("description", conPackItem.getString("descriptionFrom"));
    							packingUomIdMap.put("uomId", conPackItem.getString("uomFromId"));
    							listQuantityUomIdByProduct.add(packingUomIdMap);
	    					}
    						GenericValue quantityUom = delegator.findOne("Uom", UtilMisc.toMap("uomId", itemProd.get("quantityUomId")), false);
    						if (quantityUom != null) {
    							Map<String, Object> packingUomIdMap = FastMap.newInstance();
    							packingUomIdMap.put("description", quantityUom.getString("description"));
    							packingUomIdMap.put("uomId", quantityUom.getString("uomId"));
    							listQuantityUomIdByProduct.add(packingUomIdMap);
    						}
    	    				row.put("packingUomId", listQuantityUomIdByProduct);
    	    				
    	    				// column: expireDate
    	    				List<Map<String, Object>> listExpireDateByProduct = new ArrayList<Map<String,Object>>();
    	    				List<EntityCondition> exConds = FastList.newInstance();
    	    				exConds.add(EntityCondition.makeCondition("productStoreId", productStoreId));
    	    				exConds.add(EntityCondition.makeCondition("productId", itemProd.getString("productId")));
    	    				// productStoreId, fromDate, thruDate, productId, statusId, expireDate, uomId, quantityOnHandTotal, availableToPromiseTotal
    	    				EntityListIterator iterQuantityInventorySum = delegator.find("ProductStoreFacilityInventorySumAtpqoh", EntityCondition.makeCondition(exConds, EntityOperator.AND), EntityCondition.makeCondition("quantityOnHandTotal", EntityOperator.GREATER_THAN, BigDecimal.ZERO), null, null, null);
    	    				if (iterQuantityInventorySum != null) {
    	    					List<GenericValue> listQuantityInventorySum = iterQuantityInventorySum.getCompleteList();
    	    					if (listQuantityInventorySum != null) {
    	    						listQuantityInventorySum = EntityUtil.filterByDate(listQuantityInventorySum);
    	    						for (GenericValue quantityInventoryItem : listQuantityInventorySum) {
    	    							Map<String, Object> mapItem = FastMap.newInstance();
    	    							mapItem.put("expireDate", quantityInventoryItem.getString("expireDate"));
    	    							mapItem.put("qohTotal", quantityInventoryItem.get("quantityOnHandTotal"));
    	    							mapItem.put("atpTotal", quantityInventoryItem.get("availableToPromiseTotal"));
    	    							listExpireDateByProduct.add(mapItem);
    	    						}
    	    					}
    	    					iterQuantityInventorySum.close();
    	    				}
    	    				row.put("expireDateList", listExpireDateByProduct);
    	    				
    	    				/*<#-- NOTE: Delivered for serialized inventory means shipped to customer so they should not be displayed here any more -->
		            		<#assign productInventoryItems = delegator.findByAnd("InventoryItemFilterAtpQoh", {"productId" : productId}, ['facilityId', '-datetimeReceived', '-inventoryItemId'], false) />
		            		<#if productInventoryItems?exists && productInventoryItems?has_content && productInventoryItems?size &gt; 0>
		            			<select name="fromInventoryItemId_${cartLineIndex}" style="width:150px; margin-bottom:0px">
		            				<option value=""></option>
			            			<#list productInventoryItems as inventoryItem>
			            				<#if inventoryItem.inventoryItemTypeId?if_exists == "NON_SERIAL_INV_ITEM">
											<#if inventoryItem.curInventoryItemTypeId?exists>
					            				<option value="${(inventoryItem.inventoryItemId)?if_exists}" 
					            					<#if cartLine.getAttribute("fromInventoryItemId")?exists && cartLine.getAttribute("fromInventoryItemId") == inventoryItem.inventoryItemId>selected="selected"</#if>>
					            					<#if inventoryItem.expireDate?exists>${(inventoryItem.expireDate)?string("dd/MM/yyyy")}
					            					<#else>__/__/____</#if>
					            					, 
					            					<#if inventoryItem.inventoryItemTypeId?if_exists == "NON_SERIAL_INV_ITEM">
														${(inventoryItem.availableToPromiseTotal)?default("NA")}
														/ ${(inventoryItem.quantityOnHandTotal)?default("NA")}
													</#if>
													,
				            					 	<#if inventoryItem.facilityId?exists>
					            					 	${inventoryItem.facilityId}
				            					 	<#else>
					            					 	<#if inventoryItem.containerId?exists>
					            					 		${inventoryItem.containerId}
					            					 	</#if>
				            					 	</#if>
				            					 	
					            				</option>
				            				</#if>
			            				</#if>
			            			</#list>
			            		</select>
			            	<#else>
			            		<select name="fromInventoryItemId" style="width:150px; margin-bottom:0px" disabled>
		            				<option value=""></option>
		            			</select>
		            		</#if>
    	    				 */
    	    				
    	    				// columns: quantityUomId, quantity, expireDate
    	    				row.put("expireDate", "");
    	    				if (hasCart) {
    	    					for (GenericValue orderItem : orderItems) {
    	    						if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(itemProd.getString("productId"))) {
    	    							row.put("quantityUomId", orderItem.getString("quantityUomId"));
    	    							row.put("quantity", orderItem.get("alternativeQuantity"));
    	    							row.put("expireDate", itemProd.get("expireDate"));
									}
    	    					}
    	    				}
    	    				row.put("qohTotal", "");
    	    				row.put("atpTotal", "");
    	    				listIterator.add(row);
    	    			}
    	    		}
    				
    				//listIterator = delegator.find("ProdCatalogCategoryAndProduct", tmpConditon, null, null, listSortFields, opts);
    				/*if (request != null) {
    					listGenericValue = listIterator.getCompleteList();
    					HttpSession session = request.getSession();
    					ShoppingCart cart = (ShoppingCart) session.getAttribute("shoppingCart");
    					if (cart != null) {
	    					List<GenericValue> orderItems = cart.makeOrderItems();
	    					for (GenericValue orderItem : orderItems) {
								for (GenericValue itemValue : listGenericValue) {
									if (orderItem.getString("productId") != null && orderItem.getString("productId").equals(itemValue.getString("productId"))) {
										itemValue.put("productPackingUomId", orderItem.getString("quantityUomId"));
									}
								}
							}
    					}
    					listIterator.close();
    				}*/
    			}
    		}
		} catch (Exception e) {
			String errMsg = "Fatal error calling jqGetListProductByCategoryCatalogLM service: " + e.toString();
			Debug.logError(e, errMsg, module);
		}
    	
		successResult.put("listIterator", listIterator);
    	return successResult;
    }
	
	private static boolean hasPermission(String orderId, GenericValue userLogin, String action, Security security, Delegator delegator) {
        OrderReadHelper orh = new OrderReadHelper(delegator, orderId);
        String orderTypeId = orh.getOrderTypeId();
        String partyId = null;
        GenericValue orderParty = orh.getEndUserParty();
        if (UtilValidate.isEmpty(orderParty)) {
            orderParty = orh.getPlacingParty();
        }
        if (UtilValidate.isNotEmpty(orderParty)) {
            partyId = orderParty.getString("partyId");
        }
        boolean hasPermission = hasPermission(orderTypeId, partyId, userLogin, action, security);
        if (!hasPermission) {
            GenericValue placingCustomer = null;
            try {
                Map<String, Object> placingCustomerFields = UtilMisc.<String, Object>toMap("orderId", orderId, "partyId", userLogin.getString("partyId"), "roleTypeId", "PLACING_CUSTOMER");
                placingCustomer = delegator.findOne("OrderRole", placingCustomerFields, false);
            } catch (GenericEntityException e) {
                Debug.logError("Could not select OrderRoles for order " + orderId + " due to " + e.getMessage(), module);
            }
            hasPermission = (placingCustomer != null);
        }
        return hasPermission;
    }
	
	private static boolean hasPermission(String orderTypeId, String partyId, GenericValue userLogin, String action, Security security) {
        boolean hasPermission = security.hasEntityPermission("ORDERMGR", "_" + action, userLogin);
        if (!hasPermission) {
            if (orderTypeId.equals("SALES_ORDER")) {
                if (security.hasEntityPermission("ORDERMGR", "_SALES_" + action, userLogin)) {
                    hasPermission = true;
                } else {
                    // check sales agent/customer relationship
                    List<GenericValue> repsCustomers = new LinkedList<GenericValue>();
                    try {
                        repsCustomers = EntityUtil.filterByDate(userLogin.getRelatedOne("Party", false).getRelated("FromPartyRelationship", UtilMisc.toMap("roleTypeIdFrom", "AGENT", "roleTypeIdTo", "CUSTOMER", "partyIdTo", partyId), null, false));
                    } catch (GenericEntityException ex) {
                        Debug.logError("Could not determine if " + partyId + " is a customer of user " + userLogin.getString("userLoginId") + " due to " + ex.getMessage(), module);
                    }
                    if ((repsCustomers != null) && (repsCustomers.size() > 0) && (security.hasEntityPermission("ORDERMGR", "_ROLE_" + action, userLogin))) {
                        hasPermission = true;
                    }
                    if (!hasPermission) {
                        // check sales sales rep/customer relationship
                        try {
                            repsCustomers = EntityUtil.filterByDate(userLogin.getRelatedOne("Party", false).getRelated("FromPartyRelationship", UtilMisc.toMap("roleTypeIdFrom", "SALES_REP", "roleTypeIdTo", "CUSTOMER", "partyIdTo", partyId), null, false));
                        } catch (GenericEntityException ex) {
                            Debug.logError("Could not determine if " + partyId + " is a customer of user " + userLogin.getString("userLoginId") + " due to " + ex.getMessage(), module);
                        }
                        if ((repsCustomers != null) && (repsCustomers.size() > 0) && (security.hasEntityPermission("ORDERMGR", "_ROLE_" + action, userLogin))) {
                            hasPermission = true;
                        }
                    }
                }
            } else if ((orderTypeId.equals("PURCHASE_ORDER") && (security.hasEntityPermission("ORDERMGR", "_PURCHASE_" + action, userLogin)))) {
                hasPermission = true;
            }
        }
        return hasPermission;
    }
	
	/** Service for checking to see if an order is fully completed or canceled */
    public static Map<String, Object> checkItemStatus(DispatchContext ctx, Map<String, ? extends Object> context) {
        Delegator delegator = ctx.getDelegator();
        LocalDispatcher dispatcher = ctx.getDispatcher();
        Locale locale = (Locale) context.get("locale");

        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String orderId = (String) context.get("orderId");

        // check and make sure we have permission to change the order
        Security security = ctx.getSecurity();
        boolean hasPermission = DistributorServices.hasPermission(orderId, userLogin, "UPDATE", security, delegator);
        if (!hasPermission) {
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                    "OrderYouDoNotHavePermissionToChangeThisOrdersStatus",locale));
        }
        // get the order header
        GenericValue orderHeader = null;
        try {
            orderHeader = delegator.findOne("OrderHeader", UtilMisc.toMap("orderId", orderId), false);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get OrderHeader record", module);
        }
        if (orderHeader == null) {
            Debug.logError("OrderHeader came back as null", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                    "OrderCannotUpdateNullOrderHeader",UtilMisc.toMap("orderId",orderId),locale));
        }

        // get the order items
        List<GenericValue> orderItems = null;
        try {
            orderItems = delegator.findByAnd("OrderItem", UtilMisc.toMap("orderId", orderId), null, false);
        } catch (GenericEntityException e) {
            Debug.logError(e, "Cannot get OrderItem records", module);
            return ServiceUtil.returnError(UtilProperties.getMessage(resource_error,
                    "OrderProblemGettingOrderItemRecords", locale));
        }

        String orderHeaderStatusId = orderHeader.getString("statusId");
        String orderTypeId = orderHeader.getString("orderTypeId");

        boolean allCanceled = true;
        boolean allComplete = true;
        boolean allApproved = true;
        if (orderItems != null) {
            for (GenericValue item : orderItems) {
                String statusId = item.getString("statusId");
                //Debug.logInfo("Item Status: " + statusId, module);
                if (!"ITEM_CANCELLED".equals(statusId)) {
                    //Debug.logInfo("Not set to cancel", module);
                    allCanceled = false;
                	// Out of the box code
                    if (!"ITEM_COMPLETED".equals(statusId)) {
                        //Debug.logInfo("Not set to complete", module);
                        allComplete = false;
                        if (!"ITEM_APPROVED".equals(statusId)) {
                            //Debug.logInfo("Not set to approve", module);
                            allApproved = false;
                            break;
                        }
                    }
                }
            }

            // find the next status to set to (if any)
            
            String newStatus = null;
            if (allCanceled) {
                if (!"PURCHASE_ORDER".equals(orderTypeId)) {
                    newStatus = "ORDER_CANCELLED";
                }
            } else if (allComplete) {
                newStatus = "ORDER_COMPLETED";
            } else if (allApproved) {
                boolean changeToApprove = true;

                // NOTE DEJ20070805 I'm not sure why we would want to auto-approve the header... adding at least this one exeption so that we don't have to add processing, held, etc statuses to the item status list
                // NOTE2 related to the above: appears this was a weird way to set the order header status by setting all order item statuses... changing that to be less weird and more direct
                // this is a bit of a pain: if the current statusId = ProductStore.headerApprovedStatus and we don't have that status in the history then we don't want to change it on approving the items
                if (UtilValidate.isNotEmpty(orderHeader.getString("productStoreId"))) {
                    try {
                        GenericValue productStore = delegator.findOne("ProductStore", UtilMisc.toMap("productStoreId", orderHeader.getString("productStoreId")), false);
                        if (productStore != null) {
                            String headerApprovedStatus = productStore.getString("headerApprovedStatus");
                            if (UtilValidate.isNotEmpty(headerApprovedStatus)) {
                                if (headerApprovedStatus.equals(orderHeaderStatusId)) {
                                    Map<String, Object> orderStatusCheckMap = UtilMisc.<String, Object>toMap("orderId", orderId, "statusId", headerApprovedStatus, "orderItemSeqId", null);

                                    List<GenericValue> orderStatusList = delegator.findByAnd("OrderStatus", orderStatusCheckMap, null, false);
                                    // should be 1 in the history, but just in case accept 0 too
                                    if (orderStatusList.size() <= 1) {
                                        changeToApprove = false;
                                    }
                                }
                            }
                        }
                    } catch (GenericEntityException e) {
                        String errMsg = "Database error checking if we should change order header status to approved: " + e.toString();
                        Debug.logError(e, errMsg, module);
                        return ServiceUtil.returnError(errMsg);
                    }
                }

                if ("ORDER_SENT".equals(orderHeaderStatusId)) changeToApprove = false;
                if ("ORDER_COMPLETED".equals(orderHeaderStatusId)) {
                    if ("SALES_ORDER".equals(orderTypeId)) {
                        changeToApprove = false;
                    }
                }
                if ("ORDER_CANCELLED".equals(orderHeaderStatusId)) changeToApprove = false;

                if (changeToApprove) {
                    newStatus = "ORDER_APPROVED";
                }
            }

            // now set the new order status
            if (newStatus != null && !newStatus.equals(orderHeaderStatusId)) {
                Map<String, Object> serviceContext = UtilMisc.<String, Object>toMap("orderId", orderId, "statusId", newStatus, "userLogin", userLogin);
                Map<String, Object> newSttsResult = null;
                try {
                    newSttsResult = dispatcher.runSync("changeOrderStatusDis", serviceContext);
                } catch (GenericServiceException e) {
                    Debug.logError(e, "Problem calling the changeOrderStatus service", module);
                }
                if (ServiceUtil.isError(newSttsResult)) {
                    return ServiceUtil.returnError(ServiceUtil.getErrorMessage(newSttsResult));
                }
            }
        } else {
            Debug.logWarning(UtilProperties.getMessage(resource_error,
                    "OrderReceivedNullForOrderItemRecordsOrderId", UtilMisc.toMap("orderId",orderId),locale), module);
        }

        return ServiceUtil.returnSuccess();
    }
}
