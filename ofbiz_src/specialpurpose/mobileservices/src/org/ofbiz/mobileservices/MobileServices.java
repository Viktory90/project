package org.ofbiz.mobileservices;

import java.math.BigDecimal;
import java.net.FileNameMap;
import java.net.URLConnection;
import java.nio.ByteBuffer;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.DateFormatSymbols;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.ibm.icu.util.Calendar;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.context.Context;
import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.primitives.adapters.IteratorShortIterator;
import org.ofbiz.accounting.payment.PaymentWorker;
import org.ofbiz.base.conversion.ConversionException;
import org.ofbiz.base.conversion.DateTimeConverters;
import org.ofbiz.base.conversion.DateTimeConverters.TimestampToString;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.GeneralException;
import org.ofbiz.base.util.ObjectType;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilFormatOut;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityConditionList;
import org.ofbiz.entity.condition.EntityExpr;
import org.ofbiz.entity.condition.EntityFieldMap;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.model.DynamicViewEntity;
import org.ofbiz.entity.model.ModelKeyMap;
import org.ofbiz.entity.transaction.TransactionUtil;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.entity.util.EntityUtilProperties;
import org.ofbiz.mobileUtil.MobileUtils;
import org.ofbiz.order.order.OrderChangeHelper;
import org.ofbiz.order.order.OrderListState;
import org.ofbiz.order.order.OrderReadHelper;
import org.ofbiz.order.shoppingcart.CheckOutHelper;
import org.ofbiz.order.shoppingcart.ShoppingCart;
import org.ofbiz.order.shoppingcart.ShoppingCartItem;
import org.ofbiz.order.shoppingcart.product.ProductPromoWorker;
import org.ofbiz.party.contact.ContactHelper;
import org.ofbiz.product.catalog.CatalogWorker;
import org.ofbiz.product.category.CategoryContentWrapper;
import org.ofbiz.product.category.CategoryWorker;
import org.ofbiz.product.store.ProductStoreWorker;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GeneralServiceException;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

import com.olbius.service.SalesmanServices;

public class MobileServices {
	public static final String module = MobileServices.class.getName();
	public static final String resource_error = "MobileServicesErrorUiLabels";
	public static final int NUMBER_OF_BEST_CUS = 4;
	public static String currencyUom = null;

	public static String getProductList(HttpServletRequest request,
			HttpServletResponse response) {

		Delegator delegator = (Delegator) request.getAttribute("delegator");

		List<Map<String, Object>> products = FastList.newInstance();
		try {
			List<GenericValue> gvList = delegator.findList("Product", null,
					null, null, null, false);

			for (GenericValue value : gvList) {
				Map<String, Object> product = FastMap.newInstance();
				product.put("productId", value.get("productId"));
				product.put("productName", value.get("productName"));
				product.put("quanlity", 0);
				products.add(product);
			}
			request.setAttribute("products", products);
		} catch (GenericEntityException ge) {
			return "error";
		}
		return "success";
	}

	/**
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getSalesmanRoads(HttpServletRequest request,
			HttpServletResponse response) {
		List<Map<String, Object>> roads = getRoads(request);
		request.setAttribute("roads", roads);
		return "success";
	}

	/* get salesman road function */
	public static List<Map<String, Object>> getRoads(HttpServletRequest request) {

		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");

		Map<?, ?> ctx = UtilMisc.toMap("userLogin", userLogin);
		Map<String, Object> context = (Map<String, Object>) ctx;

		List<Map<String, Object>> roads = FastList.newInstance();

		@SuppressWarnings("unchecked")
		List<GenericValue> gvList = (List<GenericValue>) SalesmanServices
				.getRoadOfSalesman(dispatcher.getDispatchContext(), context)
				.get("listRoute");
		EntityFindOptions findoptions = new EntityFindOptions();
		findoptions.setDistinct(true);
		for (GenericValue value : gvList) {
			Map<String, Object> road = FastMap.newInstance();
			road.put("roadId", value.get("partyIdFrom"));
			road.put("name", value.get("groupName"));
			roads.add(road);
		}
		return roads;
	}

	/*
	 * Get store by road id
	 */
	public static String getStoreByRoad(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		try {
			String roadId = (String) request.getParameter("id");
			List<EntityCondition> allConditions = FastList.newInstance();
			if (roadId != null) {
				allConditions.add(EntityCondition.makeCondition("partyIdFrom",
						EntityOperator.EQUALS, roadId));
			}
			EntityCondition queryConditionsList = EntityCondition
					.makeCondition(allConditions, EntityOperator.AND);
			EntityFindOptions options = new EntityFindOptions(true,
					EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
					EntityFindOptions.CONCUR_READ_ONLY, true);
			String sizeStr = request.getParameter("viewSize");
			String pageStr = request.getParameter("viewIndex");
			int size = 10;
			if (sizeStr.isEmpty()) {
				size = Integer.parseInt(sizeStr);
			}
			int page = 0;
			if (pageStr.isEmpty()) {
				page = Integer.parseInt(pageStr);
			}
			options.setMaxRows(size * (page + 1));
			EntityListIterator iterator = delegator.find("PartyGroupGeoView",
					queryConditionsList, null, UtilMisc.toSet("partyIdTo",
							"groupName", "latitude", "longitude", "address1",
							"city"), UtilMisc.toList("fromDate DESC"), options);
			List<GenericValue> customers = iterator.getPartialList(size * page,
					size);
			Integer total = iterator.getResultsSizeAfterPartialList();
			iterator.close();
			request.setAttribute("customers", customers);
			Map<String, Object> paging = getPaging(page, size, total);
			request.setAttribute("paging", paging);

		} catch (GenericEntityException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}

	@SuppressWarnings("unchecked")
	public static Map<String,Object> getStoreByRoad(DispatchContext dpct,Map<String,Object> context){
		Delegator delegator = dpct.getDelegator();
		LocalDispatcher dispatcher = dpct.getDispatcher();
		String roadId = "ROUTE1";
		String isGetInventory = (String) context.get("isGetInventory");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		List<EntityCondition> allConditions = FastList.newInstance();
		Map<String,Object> rs = FastMap.newInstance();
	try{
		if (roadId != null) {
			allConditions.add(EntityCondition.makeCondition("partyIdFrom",
					EntityOperator.EQUALS, roadId));
		}
		EntityCondition queryConditionsList = EntityCondition
				.makeCondition(allConditions, EntityOperator.AND);
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
//		EntityFindOptions options = new EntityFindOptions(true,
//				EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
//				EntityFindOptions.CONCUR_READ_ONLY, true);
//		String sizeStr = (String) context.get("viewSize");
//		String pageStr = (String) context.get("viewIndex");
//		int size = 10;
//		if (sizeStr.isEmpty()) {
//			size = Integer.parseInt(sizeStr);
//		}
//		int page = 0;
//		if (pageStr.isEmpty()) {
//			page = Integer.parseInt(pageStr);
//		}
//		options.setMaxRows(size * (page + 1));
//		EntityListIterator iterator = delegator.find("PartyGroupGeoView",
//				queryConditionsList, null, UtilMisc.toSet("partyIdTo",
//						"groupName", "latitude", "longitude", "address1",
//						"city"), UtilMisc.toList("fromDate DESC"), options);
//		List<GenericValue> customers = iterator.getPartialList(size * page,
//				size);
		Set<String> fieldsToSelect =  UtilMisc.toSet("partyIdTo",
				"groupName", "latitude", "longitude", "address1",
				"city", "fromDate", "geoPointId");
		List<GenericValue> customers = delegator.findList("PartyGroupGeoView",queryConditionsList, fieldsToSelect,  UtilMisc.toList("fromDate DESC"), options, false);
		List<Map<String,Object>> listInventory  = FastList.newInstance();
		if(isGetInventory.equals("Y") && !customers.isEmpty()){
			for(GenericValue cus : customers){
				Map<String,Object> resultRunSync = FastMap.newInstance();
				resultRunSync = dispatcher.runSync("getInventoryOfCusInfo", UtilMisc.toMap("userLogin",userLogin,"partyId",cus.getString("partyIdTo")));
				if(ServiceUtil.isSuccess(resultRunSync) && UtilValidate.isNotEmpty(resultRunSync.get("inventoryCusInfo"))){
					listInventory.add(resultRunSync);
				}else continue;
			}
		}
//		Integer total = iterator.getResultsSizeAfterPartialList();
//		iterator.close();
//		Map<String, Object> paging = getPaging(page, size, total);
		rs.put("customers", customers);
//		rs.put("paging",paging);
		rs.put("listInventory", listInventory);
	}catch (GenericEntityException e) {
		e.printStackTrace();
	}catch(Exception e){
		e.printStackTrace();
	}
		return rs;
	}
	
	/*
	 * get store of salesman
	 */
	public static String getAllStore(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		List<Map<String, Object>> roads = getRoads(request);
		try {
			List<EntityCondition> allConditions = FastList.newInstance();
			for (int i = 0; i < roads.size(); i++) {
				Map<String, Object> temp = roads.get(i);
				EntityCondition ro = EntityCondition.makeCondition(UtilMisc
						.toMap("partyIdFrom", temp.get("roadId")));
				allConditions.add(ro);
			}
			EntityCondition queryConditionsList = EntityCondition
					.makeCondition(allConditions, EntityOperator.OR);
			EntityFindOptions options = new EntityFindOptions(true,
					EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
					EntityFindOptions.CONCUR_READ_ONLY, true);
			String sizeStr = request.getParameter("viewSize");
			String pageStr = request.getParameter("viewIndex");
			int size = 100;
			if (sizeStr != null && !sizeStr.isEmpty()) {
				size = Integer.parseInt(sizeStr);
			}
			int page = 0;
			if (pageStr != null && !pageStr.isEmpty()) {
				page = Integer.parseInt(pageStr);
			}
			options.setMaxRows(size * (page + 1));
			Set<String> fields = FastSet.newInstance();
			fields.add("partyIdTo");
			fields.add("partyIdFrom");
			fields.add("groupName");
			fields.add("latitude");
			fields.add("longitude");
			fields.add("address1");
			fields.add("city");
			List<String> order = FastList.newInstance();
			order.add("partyIdFrom ASC");
			EntityListIterator iterator = delegator.find("PartyGroupGeoView",
					queryConditionsList, null, fields, order, options);
			// List<GenericValue> full = iterator.getCompleteList();
			List<GenericValue> customers = iterator.getPartialList(size * page,
					size);
			iterator.close();
			Integer totalSize = iterator.getResultsSizeAfterPartialList();
			Integer total = (int) Math.ceil((double) totalSize / (double) size);
			request.setAttribute("customers", customers);
			request.setAttribute("size", totalSize);
			request.setAttribute("total", total);
			request.setAttribute("road", roads);
		} catch (GenericEntityException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}

	protected static Map<String, Object> getPaging(int viewIndex, int viewSize,
			int totalSize) {
		Map<String, Object> paging = FastMap.newInstance();
		if (hasNext(viewIndex, viewSize, totalSize)) {
			Map<?, ?> tempMap = UtilMisc.toMap("viewIndex", viewIndex + 1,
					"viewSize", viewSize);
			Map<String, Object> hasNext = (Map<String, Object>) tempMap;
			paging.put("hasNext", hasNext);
		}

		if (hasPrevious(viewIndex)) {
			Map<?, ?> tempMap = UtilMisc.toMap("viewIndex", viewIndex - 1,
					"viewSize", viewSize);
			Map<String, Object> hasPre = (Map<String, Object>) tempMap;
			paging.put("hasPre", hasPre);
		}
		return paging;
	}

	protected static boolean hasNext(int viewIndex, int viewSize, int totalSize) {
		return (viewIndex < totalSize / viewSize);
	}

	public static boolean hasPrevious(int viewIndex) {
		return (viewIndex > 0);
	}

	public static String getCustomersonRoead(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");

		String routeId = (String) request.getAttribute("partyId");
		try {
			List<GenericValue> customer = delegator.findByAnd(
					"PartyRelationshipToPartyOlbius", UtilMisc.toMap(
							"partyIdFrom", routeId, "roleTypeIdTo",
							"DELYS_CUSTOMER_GT"), null, true);
			request.setAttribute("customers", customer);
		} catch (GenericEntityException e) {
			return "error";
		}

		return "success";
	}

	@SuppressWarnings("unchecked")
	public static String submitOrder(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		Map<?, ?> tempMap = UtilMisc.toMap("userLogin", userLogin);
		Map<String, Object> context = (Map<String, Object>) tempMap;
		Locale locale = (Locale) context.get("locale");
		String latOrder = new String(request.getParameter("latitude"));
		String longOrder = new String(request.getParameter("longitude"));
		
		//get Promotions Store
		// String productCategoryId = (String) context.get("productCategoryId");
		// List stores
		List<EntityExpr> exprs = FastList.newInstance();
		exprs.add(EntityCondition.makeCondition("partyId",
				EntityOperator.EQUALS, userLogin.get("partyId")));
		List<GenericValue> listProductStore = null;

		try {
			listProductStore = delegator.findList("ProductStorePartyView",
					EntityCondition.makeCondition(exprs, EntityOperator.AND),
					null, null, null, false);
		} catch (GenericEntityException e) {
			e.printStackTrace();
			// return "error";
		}

		String productStoreId = "";
		if (listProductStore.size() > 0) {
			productStoreId = (String) listProductStore.get(0).get(
					"productStoreId");
		}
		if (currencyUom == null) { // (String) context.get("currencyUomId");
			currencyUom = EntityUtilProperties.getPropertyValue(
					"general.properties", "currency.uom.id.default", "VND",
					delegator);
		}

		String partyId = (String) request.getParameter("customerId");

		String salesChannel = "WEB_SALES_CHANNEL";

		ShoppingCart cart = new ShoppingCart(delegator, productStoreId, locale,
				currencyUom);
		cart.setOrderType("SALES_ORDER");
		cart.setChannelType(salesChannel);
		cart.setProductStoreId(productStoreId);

		cart.setBillFromVendorPartyId((String) listProductStore.get(0).get(
				"payToPartyId"));
		cart.setBillToCustomerPartyId(partyId);
		cart.setPlacingCustomerPartyId(partyId);
		cart.setShipToCustomerPartyId(partyId);
		cart.setEndUserCustomerPartyId(partyId);
		try {
			cart.setUserLogin(userLogin, dispatcher);
		} catch (Exception exc) {
			Debug.logWarning(
					"Error setting userLogin in the cart: " + exc.getMessage(),
					module);
			// return "error";
		}
		String productsStr = new String(request.getParameter("products"));
		String[] products = productsStr.split("\\|\\|");
		String[] product;
		// for (String key : (Set<String>) request.getParameterMap().keySet()) {
		for (int i = 0; i < products.length; i++) {
			product = products[i].split("%%");
			try {
				cart.addOrIncreaseItem(product[0], null,
						BigDecimal.valueOf(Integer.valueOf(product[1])), null,
						null, null, null, null, null, null,
						null /* catalogId */, null, null/* itemType */,
						null/* itemGroupNumber */, null, dispatcher);
			} catch (Exception exc) {
				Debug.logWarning("Error adding product with id " + products[i]
						+ " to the cart: " + exc.getMessage(), module);
			}
		}
		product = null;
		cart.setDefaultCheckoutOptions(dispatcher);
		cart.setShipmentMethodTypeId(0, "NO_SHIPPING");
		CheckOutHelper checkout = new CheckOutHelper(dispatcher, delegator,
				cart);

		/** add cash on delivery to payment of order */
		Map<String, Map<String, Object>> selectedPaymentMethods = new HashMap<String, Map<String, Object>>();
		Map<String, Object> paymentMethodInfo = FastMap.newInstance();
		paymentMethodInfo.put("amount", null);
		selectedPaymentMethods.put("EXT_COD", paymentMethodInfo);
		// List<String> singleUsePayments = new ArrayList<String>();
		Map<String, Object> callResult = checkout.setCheckOutPayment(
				selectedPaymentMethods, null, null);
		if (callResult.get(ModelService.RESPONSE_MESSAGE).equals(
				ModelService.RESPOND_ERROR)) {
			// errors so push the user onto the next page
			request.setAttribute("error", "payment method error");
			return "error";
		}
		/** end add cash on delivery to payment */
		try {
			Map<String, Object> orderCreateResult = checkout
					.createOrder(userLogin);
			List<ShoppingCartItem> items = cart.items(); 
			List<Map<String, Object>> ListPromotions = FastList.newInstance();
			Map<String,Object> QuantityTotal = FastMap.newInstance();
			BigDecimal quantity = BigDecimal.ZERO;
			for(ShoppingCartItem item : items)
				{
				quantity = quantity.add(item.getQuantity());
				Map<String,Object> itemTmp = FastMap.newInstance();
					if(item.getIsPromo()){
						itemTmp.put("productPrice", item.getBasePrice());
						itemTmp.put("productName", item.getName());
						itemTmp.put("productId", item.getProductId());
						itemTmp.put("productQuantity", item.getQuantity());
						ListPromotions.add(itemTmp);
					}
				}
		QuantityTotal.put("quantityTotal", quantity);
		System.out.println("items in cart " + items + " " + items.size());
		String orderId = (String) orderCreateResult.get("orderId");
		//create Order Geo Point 
		if(UtilValidate.isNotEmpty(latOrder) && UtilValidate.isNotEmpty(longOrder)){
			//create GeoPoint Of Order
			try {
				String code = "OSM";
				String idGeoPoint = delegator.getNextSeqId("GeoPoint");
				GenericValue geoPointOrder = delegator.makeValue("GeoPoint");
				geoPointOrder.set("geoPointId", code + idGeoPoint);
				geoPointOrder.set("latitude", Double.parseDouble(latOrder));
				geoPointOrder.set("longitude", Double.parseDouble(longOrder));
				geoPointOrder.create();
				GenericValue GeoPointOrderSM  = delegator.makeValue("OrderAndGeoPointSalesMan");
				GeoPointOrderSM.set("geoPointId", code + idGeoPoint);
				GeoPointOrderSM.set("orderId", orderId);
				GeoPointOrderSM.create();
			} catch (Exception e) {
				e.printStackTrace();
				return ("Fatal Error when create GeoPoint Order" + e.getMessage());
				// TODO: handle exception
			}
		}
		
		request.setAttribute("orderId", orderId);
		Map<String,Object> res = FastMap.newInstance();
		res.put("PaymenTotal", cart.getPaymentTotal());
		res.put("OrderInfo", ListPromotions);
		request.setAttribute("res",res);
		} catch (Exception e) {
			return "error";
		}
		return "success";
	}
	/* update Order */

	public static String updateOrder(HttpServletRequest request,
			HttpServletResponse response) {
		return "success";
	}

	/*
	 * get detail information of an order input: id of order output: json type
	 */

	public static String getOrderDetail(HttpServletRequest request,
			HttpServletResponse response) {
		String orderId = (String) request.getParameter("id");
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		try {
			GenericValue orderHeader = delegator.findOne("OrderHeader",
					UtilMisc.toMap("orderId", orderId), false);
			String[] fields = { "orderId", "orderDate", "statusId" };
			Map<String, Object> orderHeaderFilter = getFieldsObject(
					orderHeader, fields);
			OrderReadHelper orderHelper = OrderReadHelper
					.getHelper(orderHeader);
			// GenericValue billToParty = orderHelper.getBillToParty();
			List<GenericValue> orderDetail = orderHelper.getOrderItems();
			String[] fields2 = { "itemDescription", "quantity", "unitPrice",
					"productId" };
			List<Map<String, Object>> orderDetailFilter = getListObjectWithFields(
					orderDetail, fields2);
			GenericValue productStore = delegator.findOne(
					"ProductStore",
					UtilMisc.toMap("productStoreId",
							orderHelper.getProductStoreId()), false);
			request.setAttribute("orderHeader", orderHeaderFilter);
			String[] fields3 = { "productStoreId", "storeName" };
			Map<String, Object> productStoreFilter = getFieldsObject(
					productStore, fields3);
			// request.setAttribute("orderBill", billToParty);
			OrderReadHelper orderReadHelper = OrderReadHelper
					.getHelper(orderHeader);
			request.setAttribute("orderShipment",
					orderReadHelper.getShippingAddress());
			request.setAttribute("orderDetail", orderDetailFilter);
			request.setAttribute("productStore", productStoreFilter);
			request.setAttribute("data", "success");
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			request.setAttribute("data", "error");
			return "error";
		}

		return "success";
	}

	/**
	 * finish payment order
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	public static String paymentFinish(HttpServletRequest request,
			HttpServletResponse response) {
		String orderId = request.getParameter("orderId");
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		// HttpServletRequest request = (HttpServletRequest)
		// context.get("request");
		HttpSession session = request.getSession();
		GenericValue userLogin = (GenericValue) session
				.getAttribute("userLogin");

		// ShoppingCart cart = (ShoppingCart)session.getAttribute(orderId);
		// CheckOutHelper checkout = new CheckOutHelper(dispatcher, delegator,
		// cart);
		Locale locale = UtilHttp.getLocale(request);
		List<GenericValue> orderRoles = null;
		GenericValue orderHeader = null;
		try {
			orderHeader = delegator.findOne("OrderHeader",
					UtilMisc.toMap("orderId", orderId), false);
			orderRoles = delegator.findList("OrderRole", EntityCondition
					.makeCondition("orderId", EntityOperator.EQUALS, orderId),
					null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.logError(e, "Problems reading order header from datasource.",
					module);
			request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(
					resource_error,
					"OrderProblemsReadingOrderHeaderInformation", locale));
			return "error";
		}
		String partyId = orderRoles.get(0).getString("partyId");
		BigDecimal grandTotal = BigDecimal.ZERO;
		if (orderHeader != null) {
			grandTotal = orderHeader.getBigDecimal("grandTotal");
		}

		// get the payment methods to receive
		/*
		 * List<GenericValue> paymentMethods = null; try { EntityExpr ee =
		 * EntityCondition.makeCondition("partyId", EntityOperator.EQUALS,
		 * partyId); paymentMethods = delegator.findList("PaymentMethod", ee,
		 * null, null, null, false); } catch (GenericEntityException e) {
		 * Debug.logError(e, "Problems getting payment methods", module);
		 * request.setAttribute("_ERROR_MESSAGE_",
		 * UtilProperties.getMessage(resource_error
		 * ,"OrderProblemsWithPaymentMethodLookup", locale)); return "error"; }
		 */
		// String paymentMethodTypeId =
		// paymentMethodType.getString("paymentMethodTypeId");
		String paymentMethodTypeId = "EXT_COD";
		String amountStr = grandTotal.toString();
		String paymentReference = "";// request.getParameter("paymentMethodTypeId"
										// + "_reference");//edit
		GenericValue placingCustomer = null;
		try {
			List<GenericValue> pRoles = delegator.findByAnd("OrderRole",
					UtilMisc.toMap("orderId", orderId, "roleTypeId",
							"PLACING_CUSTOMER"), null, false);
			if (UtilValidate.isNotEmpty(pRoles))
				placingCustomer = EntityUtil.getFirst(pRoles);
		} catch (GenericEntityException e) {
			Debug.logError(e, "Problems looking up order payment preferences",
					module);
			request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(
					resource_error, "OrderErrorProcessingOfflinePayments",
					locale));
			return "error";
		}

		List<GenericValue> toBeStored = FastList.newInstance();

		if (!UtilValidate.isEmpty(amountStr)) {
			BigDecimal paymentTypeAmount = BigDecimal.ZERO;
			try {
				paymentTypeAmount = (BigDecimal) ObjectType.simpleTypeConvert(
						amountStr, "BigDecimal", null, locale);
			} catch (GeneralException e) {
				request.setAttribute("_ERROR_MESSAGE_", UtilProperties
						.getMessage(resource_error,
								"OrderProblemsPaymentParsingAmount", locale));
				return "error";
			}
			if (paymentTypeAmount.compareTo(BigDecimal.ZERO) > 0) {
				// create the OrderPaymentPreference
				// TODO: this should be done with a service
				Map<String, String> prefFields = UtilMisc
						.<String, String> toMap("orderPaymentPreferenceId",
								delegator
										.getNextSeqId("OrderPaymentPreference"));
				GenericValue paymentPreference = delegator.makeValue(
						"OrderPaymentPreference", prefFields);
				paymentPreference.set("paymentMethodTypeId",
						paymentMethodTypeId);
				paymentPreference.set("maxAmount", paymentTypeAmount);
				paymentPreference.set("statusId", "PAYMENT_RECEIVED");
				paymentPreference.set("orderId", orderId);
				paymentPreference.set("createdDate",
						UtilDateTime.nowTimestamp());
				if (userLogin != null) {
					paymentPreference.set("createdByUserLogin",
							userLogin.getString("userLoginId"));
				}

				try {
					delegator.create(paymentPreference);
				} catch (GenericEntityException ex) {
					Debug.logError(ex,
							"Cannot create a new OrderPaymentPreference",
							module);
					request.setAttribute("_ERROR_MESSAGE_", ex.getMessage());
					return "error";
				}

				// create a payment record
				Map<String, Object> results = null;
				try {
					Map<String, Object> context = UtilMisc.toMap("userLogin",
							userLogin, "orderPaymentPreferenceId",
							paymentPreference.get("orderPaymentPreferenceId"),
							"paymentRefNum", paymentReference, "comments",
							"Payment received offline and manually entered.");
					if (placingCustomer != null) {
						context.put("paymentFromId",
								placingCustomer.getString("partyId"));
					}
					results = dispatcher.runSync("createPaymentFromPreference",
							context);
				} catch (GenericServiceException e) {
					Debug.logError(
							e,
							"Failed to execute service createPaymentFromPreference",
							module);
					request.setAttribute("_ERROR_MESSAGE_", e.getMessage());
					return "error";
				}

				if ((results == null)
						|| (results.get(ModelService.RESPONSE_MESSAGE)
								.equals(ModelService.RESPOND_ERROR))) {
					Debug.logError(
							(String) results.get(ModelService.ERROR_MESSAGE),
							module);
					request.setAttribute("_ERROR_MESSAGE_",
							results.get(ModelService.ERROR_MESSAGE));
					return "error";
				}
			}
		}
		// get the current payment prefs
		GenericValue offlineValue = null;
		List<GenericValue> currentPrefs = null;
		BigDecimal paymentTally = BigDecimal.ZERO;
		try {
			EntityConditionList<EntityExpr> ecl = EntityCondition
					.makeCondition(UtilMisc.toList(EntityCondition
							.makeCondition("orderId", EntityOperator.EQUALS,
									orderId), EntityCondition.makeCondition(
							"statusId", EntityOperator.NOT_EQUAL,
							"PAYMENT_CANCELLED")), EntityOperator.AND);
			currentPrefs = delegator.findList("OrderPaymentPreference", ecl,
					null, null, null, false);
		} catch (GenericEntityException e) {
			Debug.logError(
					e,
					"ERROR: Unable to get existing payment preferences from order",
					module);
		}
		if (UtilValidate.isNotEmpty(currentPrefs)) {
			for (GenericValue cp : currentPrefs) {
				String paymentMethodType = cp.getString("paymentMethodTypeId");
				if ("EXT_OFFLINE".equals(paymentMethodType)) {
					offlineValue = cp;
				} else {
					BigDecimal cpAmt = cp.getBigDecimal("maxAmount");
					if (cpAmt != null) {
						paymentTally = paymentTally.add(cpAmt);
					}
				}
			}
		}

		// now finish up
		boolean okayToApprove = false;
		if (paymentTally.compareTo(grandTotal) >= 0) {
			// cancel the offline preference
			okayToApprove = true;
			if (offlineValue != null) {
				offlineValue.set("statusId", "PAYMENT_CANCELLED");
				toBeStored.add(offlineValue);
			}
		}

		// store the status changes and the newly created payment preferences
		// and payments
		// TODO: updating order payment preference should be done with a service
		try {
			delegator.storeAll(toBeStored);
		} catch (GenericEntityException e) {
			Debug.logError(e, "Problems storing payment information", module);
			request.setAttribute("_ERROR_MESSAGE_", UtilProperties.getMessage(
					resource_error,
					"OrderProblemStoringReceivedPaymentInformation", locale));
			return "error";
		}

		if (okayToApprove) {
			// update the status of the order and items
			OrderChangeHelper.approveOrder(dispatcher, userLogin, orderId);
			request.setAttribute("statusOrder", "ORDER_APPROVED");
		}
		/** Complete order */
		try {
			userLogin = delegator.findOne("UserLogin",
					UtilMisc.toMap("userLoginId", "system"), false);

			Map<String, Object> result = dispatcher.runSync(
					"quickShipEntireOrder",
					UtilMisc.toMap("orderId", orderId, "userLogin", userLogin));
			if (result.get("shipmentShipGroupFacilityList") != null) {
				request.setAttribute("statusOrder", "ORDER_COMPLETED");
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "success";
	}

	/**
	 * thong tin salesman
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getCustomerInfo(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		DateTimeConverters.TimestampToString converts = new DateTimeConverters.TimestampToString();

		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		Map<String, Object> cusMap = FastMap.newInstance();
		try {
			GenericValue party = userLogin.getRelatedOne("Party", false);
			GenericValue contactMech = EntityUtil.getFirst(ContactHelper
					.getContactMech(party, "SHIPPING_LOCATION",
							"POSTAL_ADDRESS", false));
			
			String partyContent = MobileUtils
					.getPartyContent(request, response);
			if (partyContent != null) {
				cusMap.put("contentImageUrl", partyContent);
			}
			cusMap.put("createdTxStamp", converts.convert(
					userLogin.getTimestamp("createdTxStamp"),
					Locale.getDefault(), TimeZone.getDefault(),
					UtilDateTime.DATE_FORMAT));
			cusMap.put("lastUpdatedTxStamp", converts.convert(
					userLogin.getTimestamp("lastUpdatedTxStamp"),
					Locale.getDefault(), TimeZone.getDefault(),
					UtilDateTime.DATE_FORMAT));
			if ("PERSON".equals(party.get("partyTypeId"))) {
				GenericValue person = delegator.findOne("Person",
						UtilMisc.toMap("partyId", party.get("partyId")), false);
				if (person != null) {
					cusMap.put("firstName", person.get("firstName"));
					cusMap.put("middleName", person.get("middleName"));
					cusMap.put("lastName", person.get("lastName"));
				}
			}
			if (contactMech != null) {
				GenericValue postalAddress = contactMech.getRelatedOne(
						"PostalAddress", false);
				cusMap.put("address1", postalAddress.get("address1"));
				// cusMap.put("address2", postalAddress.get("address2"));
			} else {
				cusMap.put("address1", "No_Address");
				// cusMap.put("address2", "No Address");
			}
			request.setAttribute("customerInfo", cusMap);
			return "success";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	/**
	 * get avatar in header.html
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getImageAvatar(HttpServletRequest request,
			HttpServletResponse response) {
		String partyContent;
		try {
			partyContent = MobileUtils.getPartyContent(request, response);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			request.setAttribute("error", e.getMessage());
			return "error";
		}
		request.setAttribute("contentImageUrl", partyContent);
		return "success";
	}

	/*
	 * public static String getOrderToday(HttpServletRequest request,
	 * HttpServletResponse response) {
	 * 
	 * Delegator delegator = (Delegator) request.getAttribute("delegator");
	 * GenericValue userLogin =
	 * (GenericValue)request.getSession().getAttribute("userLogin"); //String
	 * partyId = (String)userLogin.get("partyId"); try {
	 * 
	 * } catch (GenericEntityException e) { // TODO Auto-generated catch block
	 * e.printStackTrace(); } return "success"; }
	 */
	public static String getNotification(HttpServletRequest request,
			HttpServletResponse response) {
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		Map<String, Object> result = null;
		try {
			GenericValue userLogin = (GenericValue) request.getSession()
					.getAttribute("userLogin");
			if (userLogin != null) {
				result = dispatcher.runSync("getLastSystemInfoNoteMobile",
						UtilMisc.toMap("userLogin", userLogin));
				GenericValue lastSystemInfoNote1 = (GenericValue) result
						.get("lastSystemInfoNote1");
				GenericValue lastSystemInfoNote2 = (GenericValue) result
						.get("lastSystemInfoNote2");
				GenericValue lastSystemInfoNote3 = (GenericValue) result
						.get("lastSystemInfoNote3");
				String middleTopMessage1 = lastSystemInfoNote1 != null ? lastSystemInfoNote1
						.get("noteDateTime").toString().substring(0, 16)
						+ " " + lastSystemInfoNote1.get("noteInfo")
						: "";
				String middleTopMessage2 = lastSystemInfoNote2 != null ? lastSystemInfoNote2
						.get("noteDateTime").toString().substring(0, 16)
						+ " " + lastSystemInfoNote2.get("noteInfo")
						: "";
				String middleTopMessage3 = lastSystemInfoNote3 != null ? lastSystemInfoNote3
						.get("noteDateTime").toString().substring(0, 16)
						+ " " + lastSystemInfoNote3.get("noteInfo")
						: "";
				// "${lastSystemInfoNote1.moreInfoUrl}${groovy: if (lastSystemInfoNote1&amp;&amp;lastSystemInfoNote1.moreInfoItemName&amp;&amp;lastSystemInfoNote1.moreInfoItemId)&quot;?&quot; + lastSystemInfoNote1.moreInfoItemName + &quot;=&quot; + lastSystemInfoNote1.moreInfoItemId + &quot;&amp;id=&quot; + lastSystemInfoNote1.moreInfoItemId;}"
				String middleTopLink1 = lastSystemInfoNote1 != null ?
				/*
				 * * lastSystemInfoNote1 .get( "moreInfoUrl" ) .toString ()
				 */

				"mobileservices/control/taskView" : "";
				if ((lastSystemInfoNote1 != null)
						&& (lastSystemInfoNote1.get("moreInfoItemName") != null)
						&& (lastSystemInfoNote1.get("moreInfoItemId") != null)) {
					middleTopLink1 += "?"
							+ lastSystemInfoNote1.get("moreInfoItemName")
									.toString() + "="
							+ lastSystemInfoNote1.getString("moreInfoItemId")
							+ "&id="
							+ lastSystemInfoNote1.getString("moreInfoItemId");
				}
				String middleTopLink2 = lastSystemInfoNote2 != null ?
				/**
				 * lastSystemInfoNote2 .get( "moreInfoUrl" ) .toString ()
				 */

				"mobileservices/control/taskView" : "";
				if ((lastSystemInfoNote2 != null)
						&& (lastSystemInfoNote2.get("moreInfoItemName") != null)
						&& (lastSystemInfoNote2.get("moreInfoItemId") != null)) {
					middleTopLink2 += "?"
							+ lastSystemInfoNote2.get("moreInfoItemName")
									.toString() + "="
							+ lastSystemInfoNote2.getString("moreInfoItemId")
							+ "&id="
							+ lastSystemInfoNote2.getString("moreInfoItemId");
				}
				String middleTopLink3 = lastSystemInfoNote3 != null ?
				/**
				 * lastSystemInfoNote3 .get( "moreInfoUrl" ) .toString ()
				 */

				"mobileservices/control/taskView" : "";
				if ((lastSystemInfoNote3 != null)
						&& (lastSystemInfoNote3.get("moreInfoItemName") != null)
						&& (lastSystemInfoNote3.get("moreInfoItemId") != null)) {
					middleTopLink3 += "?"
							+ lastSystemInfoNote3.get("moreInfoItemName")
									.toString() + "="
							+ lastSystemInfoNote3.getString("moreInfoItemId")
							+ "&id="
							+ lastSystemInfoNote3.getString("moreInfoItemId");
				}
				request.setAttribute("middleTopMessage1", middleTopMessage1);
				request.setAttribute("middleTopMessage2", middleTopMessage2);
				request.setAttribute("middleTopMessage3", middleTopMessage3);
				request.setAttribute("middleTopLink1", middleTopLink1);
				request.setAttribute("middleTopLink2", middleTopLink2);
				request.setAttribute("middleTopLink3", middleTopLink3);
			}
			return "success";
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	public static String getProjectTask(HttpServletRequest request,
			HttpServletResponse response) {
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");

		String taskId = request.getParameter("workEffortId");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		Map<String, Object> combineMap = UtilHttp.getCombinedMap(request);
		combineMap.put("taskId", taskId);
		try {
			if (userLogin != null) {
				Map<String, Object> resultMap = dispatcher.runSync(
						"getProjectTask", combineMap);
				Map<String, Object> projectIdAndNameFromTask = dispatcher
						.runSync("getProjectIdAndNameFromTask", combineMap);
				request.setAttribute("taskResult", resultMap);
				request.setAttribute("projectIdAndName",
						projectIdAndNameFromTask);
			}
			return "success";
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	public static String getAllProductPromotion(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		Map<String, Object> promotionInfoMap = FastMap.newInstance();
		Set<String> productIdsCond = new HashSet<String>();
		Set<String> productIdsAction = new HashSet<String>();
		List<String> productIds;
		DateTimeConverters.TimestampToString converter = new TimestampToString();
		List<GenericValue> productPromos = ProductPromoWorker
				.getStoreProductPromos(delegator, dispatcher, request);
		for (GenericValue productPromo : productPromos) {
			productIds = null;
			String productPromoId = productPromo.getString("productPromoId");
			try {
				ProductPromoWorker.makeProductPromoCondActionIdSets(
						productPromoId, productIdsCond, productIdsAction,
						delegator, null);
				productIds = UtilMisc.toList(productIdsCond);
				productIds.addAll(productIdsAction);
				List<GenericValue> products = delegator.findList("Product",
						EntityCondition.makeCondition("productId",
								EntityOperator.IN, productIds), UtilMisc.toSet(
								"productId", "productName"), null, null, false);
				String promoText = (productPromo.getString("promoText") != null) ? productPromo
						.getString("promoText") : productPromoId;
				// lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½
				// ngÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y bÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¯t
				// ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â§u
				// vÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â  ngÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y
				// kÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¿t thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Âºc
				// cÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â§a CTKM
				EntityCondition ec = EntityCondition
						.makeCondition("productPromoId", EntityOperator.EQUALS,
								productPromoId);
				List<GenericValue> productStorePromoAppls = delegator.findList(
						"ProductStorePromoAppl", ec, null,
						UtilMisc.toList("productPromoId"), null, false);
				String fromDate = converter.convert(
						productStorePromoAppls.get(0).getTimestamp("fromDate"),
						Locale.getDefault(), TimeZone.getDefault(),
						UtilDateTime.DATE_FORMAT);
				String thruDate = converter.convert(
						productStorePromoAppls.get(0).getTimestamp("thruDate"),
						Locale.getDefault(), TimeZone.getDefault(),
						UtilDateTime.DATE_FORMAT);
				// lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½
				// ngÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y bÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¯t
				// ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â§u
				// vÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â  ngÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y
				// kÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¿t thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Âºc
				// cÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â§a CTKM
				promotionInfoMap.put(productPromoId, UtilMisc.toMap(
						"promoName", productPromo.getString("promoName"),
						"promoText", promoText, "productIdsCond",
						productIdsCond, "productIdsAction", productIdsAction,
						"products", products, "fromDate", fromDate, "thruDate",
						thruDate));

			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ConversionException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		request.setAttribute("productPromosInfo", promotionInfoMap);
		return "success";
	}

	/*
	 * begin dashboard screen
	 */
	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getReportProduct(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String StoreId = (String) request.getParameter("partyId");
		GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
		
		try {
			List<EntityCondition> list = FastList.newInstance();
			if(UtilValidate.isNotEmpty(userLogin)&&UtilValidate.isNotEmpty(StoreId))
			{
				list.add(EntityCondition.makeCondition("createdBy",EntityJoinOperator.EQUALS,(String)userLogin.get("partyId")));
				list.add(EntityCondition.makeCondition("partyId",EntityJoinOperator.EQUALS,(String)StoreId));
			}
			List<GenericValue> productQuantityList = delegator.findList(
					"OrderReportSalesMan", EntityCondition.makeCondition(list,EntityJoinOperator.AND), null, null, null, false);
			Map<String, Map<String, Object>> sumQtyOfProductId = FastMap
					.newInstance();
			if(UtilValidate.isNotEmpty(productQuantityList))
			{
				for (GenericValue product : productQuantityList) {
					String productId = product.getString("productId");
					if (sumQtyOfProductId.containsKey(productId)) {
						BigDecimal quantity = (BigDecimal) sumQtyOfProductId.get(
								productId).get("quantity");
						quantity = quantity.add(product.getBigDecimal("quantity"));
						sumQtyOfProductId.get(productId).put("quantity", quantity);
					} else {
						sumQtyOfProductId.put(productId, UtilMisc.toMap("quantity",
								product.getBigDecimal("quantity"), "internalName",
								product.get("internalName")));
					}
				}
			}
			request.setAttribute("quantityIfo", sumQtyOfProductId);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	/**
	 * thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â´ng tin
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â¡n hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng
	 * trong ngÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getOrderAmount(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		TimeZone timeZone = TimeZone.getDefault();
		Date date = new Date();
		Locale locale = Locale.getDefault();
		Timestamp nowTimeStamp = new Timestamp(date.getTime());
		Timestamp dayBegin = UtilDateTime.getDayStart(nowTimeStamp);
		Timestamp dayEnd = UtilDateTime.getDayEnd(nowTimeStamp);
		try {
			EntityConditionList<EntityExpr> ecl = EntityCondition
					.makeCondition(
							UtilMisc.toList(
									EntityCondition.makeCondition(
											"orderItemSeqId",
											EntityOperator.EQUALS, null),
									EntityCondition.makeCondition(
											"orderPaymentPreferenceId",
											EntityOperator.EQUALS, null),
									EntityCondition
											.makeCondition(
													"statusDatetime",
													EntityOperator.GREATER_THAN_EQUAL_TO,
													dayBegin),
									EntityCondition.makeCondition(
											"statusDatetime",
											EntityOperator.LESS_THAN_EQUAL_TO,
											dayEnd)), EntityOperator.AND);

			List<GenericValue> dayList = delegator.findList("OrderStatus", ecl,
					null, null, null, false);
			request.setAttribute(
					"dayOrder",
					EntityUtil.filterByAnd(dayList,
							UtilMisc.toMap("statusId", "ORDER_CREATED")).size());
			request.setAttribute(
					"dayApprove",
					EntityUtil.filterByAnd(dayList,
							UtilMisc.toMap("statusId", "ORDER_APPROVED"))
							.size());
			request.setAttribute(
					"dayComplete",
					EntityUtil.filterByAnd(dayList,
							UtilMisc.toMap("statusId", "ORDER_COMPLETED"))
							.size());
			request.setAttribute(
					"dayCancelled",
					EntityUtil.filterByAnd(dayList,
							UtilMisc.toMap("statusId", "ORDER_CANCELLED"))
							.size());

			/*
			 * ecl =
			 * EntityCondition.makeCondition(UtilMisc.toList(EntityCondition
			 * .makeCondition("itemStatusId", EntityOperator.NOT_EQUAL,
			 * "ITEM_REJECTED"), EntityCondition.makeCondition("itemStatusId",
			 * EntityOperator.NOT_EQUAL, "ITEM_CANCELLED"),
			 * EntityCondition.makeCondition("orderDate",
			 * EntityOperator.GREATER_THAN_EQUAL_TO, dayBegin),
			 * EntityCondition.makeCondition("orderDate",
			 * EntityOperator.LESS_THAN_EQUAL_TO, dayEnd),
			 * EntityCondition.makeCondition("orderTypeId",
			 * EntityOperator.EQUALS, "SALES_ORDER")), EntityOperator.AND);
			 * List<GenericValue> dayItems = delegator.findList(
			 * "OrderHeaderAndItems", ecl, null, null, null, false); List
			 * dayItemPending = EntityUtil.filterByAnd(dayItems,
			 * UtilMisc.toMap("itemStatusId", "ITEM_ORDERED"));
			 */
			List<GenericValue> waitingPayment = delegator.findByAnd(
					"OrderHeader", UtilMisc.toMap("statusId", "ORDER_CREATED",
							"orderTypeId", "SALES_ORDER"), null, false);
			List<GenericValue> waitingComplete = delegator.findByAnd(
					"OrderHeader", UtilMisc.toMap("statusId", "ORDER_APPROVED",
							"orderTypeId", "SALES_ORDER"), null, false);
			request.setAttribute("waitingPayment", waitingPayment.size());
			request.setAttribute("waitingComplete", waitingComplete.size());

			// int month = UtilDateTime.getMonth(new Timestamp(date.getTime()),
			// timeZone, locale);

			Calendar cal = Calendar.getInstance();
			Timestamp timestamp = UtilDateTime.nowTimestamp();
			Timestamp monthBegin;
			Timestamp monthEnd;
			if (userLogin != null) {
				Map<String, Object> monthMap = FastMap.newInstance();
				// DateFormatSymbols dfs = new DateFormatSymbols();

				// Timestamp startMonth =
				// UtilDateTime.getMonthStart(UtilDateTime.nowTimestamp(), 0,
				// -6, timeZone, locale);
				// 5 thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ng gÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â§n
				// nhÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥t
				for (int i = 5; i >= 0; i--) {
					// cal.set(Calendar.MONTH, i);
					monthBegin = UtilDateTime.getMonthStart(timestamp, 0, -i,
							timeZone, locale);
					monthEnd = UtilDateTime.getMonthEnd(monthBegin, timeZone,
							locale);
					cal.setTimeInMillis(monthBegin.getTime());
					ecl = EntityCondition
							.makeCondition(UtilMisc.toList(
									EntityCondition.makeCondition("statusId",
											EntityOperator.NOT_EQUAL,
											"ORDER_REJECTED"),
									EntityCondition.makeCondition("statusId",
											EntityOperator.NOT_EQUAL,
											"ORDER_CANCELLED"),
									EntityCondition
											.makeCondition(
													"orderDate",
													EntityOperator.GREATER_THAN_EQUAL_TO,
													monthBegin),
									EntityCondition.makeCondition("orderDate",
											EntityOperator.LESS_THAN_EQUAL_TO,
											monthEnd), EntityCondition
											.makeCondition("orderTypeId",
													EntityOperator.EQUALS,
													"SALES_ORDER"),
									EntityCondition.makeCondition("createdBy",
											EntityOperator.EQUALS,
											userLogin.get("userLoginId"))));

					List<GenericValue> monthList = delegator.findList(
							"OrderHeader", ecl, UtilMisc.toSet("grandTotal"),
							null, null, false);
					BigDecimal total = BigDecimal.ZERO;
					for (GenericValue grandTotal : monthList) {
						total = total.add(grandTotal
								.getBigDecimal("grandTotal"));
					}
					monthMap.put(
							(cal.get(Calendar.MONTH) + 1) + "-"
									+ cal.get(Calendar.YEAR), total);
				}
				request.setAttribute("monthAmount", monthMap);
			}
		} catch (GenericEntityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		return "success";
	}

	/**
	 * 5 sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â£n phÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â©m
	 * cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³ sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“
	 * lÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â£ng bÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡n ra
	 * nhiÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½u nhÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥t
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	public static Map<String, Object> getBestProductInMonth(
			DispatchContext dctx, Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");

		String month = (String) context.get("month");
		if (userLogin != null) {
			Timestamp monthStart = UtilDateTime.monthBegin();
			Timestamp monthEnd = UtilDateTime.getMonthEnd(
					UtilDateTime.nowTimestamp(), TimeZone.getDefault(),
					Locale.getDefault());
			if (month == null || month.equalsIgnoreCase("thisMonth")) {
				monthStart = UtilDateTime.monthBegin();
				monthEnd = UtilDateTime.getMonthEnd(
						UtilDateTime.nowTimestamp(), TimeZone.getDefault(),
						Locale.getDefault());
			} else if (month.equalsIgnoreCase("lastMonth")) {
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.MONTH, -1);
				Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
				monthStart = UtilDateTime.getMonthStart(timestamp);
				monthEnd = UtilDateTime.getMonthEnd(timestamp,
						TimeZone.getDefault(), Locale.getDefault());
			}

			EntityConditionList<EntityExpr> ecl = EntityCondition
					.makeCondition(UtilMisc.toList(EntityCondition
							.makeCondition("orderDate",
									EntityOperator.GREATER_THAN_EQUAL_TO,
									monthStart), EntityCondition.makeCondition(
							"orderDate", EntityOperator.LESS_THAN_EQUAL_TO,
							monthEnd)), EntityOperator.AND);

			DynamicViewEntity dynamicView = new DynamicViewEntity();
			dynamicView.addMemberEntity("OI", "OrderHeaderAndItems");

			dynamicView.addAlias("OI", "quantity", "quantity", "quantity",
					Boolean.FALSE, Boolean.FALSE, "sum");
			dynamicView.addAlias("OI", "productId", "productId", "productId",
					Boolean.FALSE, Boolean.TRUE, null);
			dynamicView.addAlias("OI", "orderDate");
			EntityFindOptions findOpts = new EntityFindOptions(true,
					EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
					EntityFindOptions.CONCUR_READ_ONLY, true);
			findOpts.setLimit(5);
			// dynamicView.setGroupBy(UtilMisc.toList("productId"));
			try {
				EntityListIterator listBestProduct = delegator
						.findListIteratorByCondition(dynamicView, ecl, null,
								null, UtilMisc.toList("quantity DESC"),
								findOpts);
				List<GenericValue> result = listBestProduct.getCompleteList();
				Map<String, Object> data = FastMap.newInstance();
				for (GenericValue bestProduct : result) {
					data.put(bestProduct.getString("productId"),
							bestProduct.getBigDecimal("quantity"));
				}

				listBestProduct.close();
				Map<?, ?> retMap = UtilMisc.toMap("bestProduct", data);
				return (Map<String, Object>) retMap;
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		Map<?, ?> retMap = UtilMisc.toMap("bestProduct",
				ServiceUtil.returnError("error"));
		return (Map<String, Object>) retMap;
	}

	/**
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½ 4
	 * khÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ch hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³
	 * tÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ng giÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡
	 * trÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¹
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â¡n hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Âºn nhÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥t
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getCustomerAmount(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();

		String month = (String) context.get("month");
		Timestamp monthBegin;
		Timestamp monthEnd;
		if (month != null && month.equalsIgnoreCase("lastMonth")) {
			Calendar c = Calendar.getInstance();
			c.add(Calendar.MONTH, -1);
			Timestamp lastMonth = new Timestamp(c.getTimeInMillis());
			monthBegin = UtilDateTime.getMonthStart(lastMonth);
			monthEnd = UtilDateTime.getMonthEnd(lastMonth,
					TimeZone.getDefault(), Locale.getDefault());
		} else {
			monthBegin = UtilDateTime
					.getMonthStart(UtilDateTime.nowTimestamp());
			monthEnd = UtilDateTime.getMonthEnd(UtilDateTime.nowTimestamp(),
					TimeZone.getDefault(), Locale.getDefault());
		}
		EntityConditionList<EntityExpr> ecl = EntityCondition.makeCondition(
				UtilMisc.toList(EntityCondition.makeCondition("createdStamp",
						EntityOperator.GREATER_THAN_EQUAL_TO, monthBegin),
						EntityCondition.makeCondition("createdStamp",
								EntityOperator.LESS_THAN_EQUAL_TO, monthEnd),
						EntityCondition.makeCondition("roleTypeId",
								EntityOperator.EQUALS, "BILL_TO_CUSTOMER")),
				EntityOperator.AND);
		DynamicViewEntity dynamicViewEntity = new DynamicViewEntity();
		dynamicViewEntity.addMemberEntity("OrderRole", "OrderRole");
		dynamicViewEntity.addMemberEntity("OH", "OrderHeader");
		dynamicViewEntity.addMemberEntity("PS", "Person");
		dynamicViewEntity.addAlias("OrderRole", "orderId");
		dynamicViewEntity.addAlias("OrderRole", "partyId", "partyId",
				"partyId", Boolean.FALSE, Boolean.TRUE, null);
		dynamicViewEntity.addAlias("OH", "grandTotal", "grandTotal",
				"grandTotal", Boolean.FALSE, Boolean.FALSE, "sum");
		dynamicViewEntity.addAlias("OrderRole", "roleTypeId");
		dynamicViewEntity.addAlias("OrderRole", "createdStamp");
		dynamicViewEntity.addViewLink("OH", "OrderRole", Boolean.FALSE,
				UtilMisc.toList(new ModelKeyMap("orderId", "orderId")));
		EntityFindOptions findOpts = new EntityFindOptions(true,
				EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
				EntityFindOptions.CONCUR_READ_ONLY, true);
		EntityListIterator eli;
		try {
			eli = delegator.findListIteratorByCondition(dynamicViewEntity, ecl,
					null, UtilMisc.toList("partyId", "grandTotal"),
					UtilMisc.toList("grandTotal DESC"), findOpts);
			List<GenericValue> bestCusInMonthList = eli.getCompleteList();
			eli.close();
			BigDecimal sum = new BigDecimal(0);// sum of all grand total in
												// bestCusInMonthList
			BigDecimal sumOfGrandTotalInData = new BigDecimal(0); // sum of
																	// grand
																	// total
																	// that add
																	// to data
																	// Map
			Map<String, Object> data = FastMap.newInstance();
			GenericValue partyGroupName = null;
			int sizeOfdata = NUMBER_OF_BEST_CUS;
			for (GenericValue bestCusInMonth : bestCusInMonthList) {
				partyGroupName = delegator
						.findOne(
								"PartyGroup",
								UtilMisc.toMap("partyId",
										bestCusInMonth.get("partyId")), false);

				// TODO please check

				if (partyGroupName != null) {
					String partyName = partyGroupName.getString("groupName");
					sum = sum.add(bestCusInMonth.getBigDecimal("grandTotal"));
					if (data.size() < sizeOfdata) {
						data.put(partyName, bestCusInMonth.get("grandTotal"));
						sumOfGrandTotalInData = sumOfGrandTotalInData
								.add(bestCusInMonth.getBigDecimal("grandTotal"));
					}
				}
			}
			if (sum.subtract(sumOfGrandTotalInData).compareTo(BigDecimal.ZERO) > 0) {
				data.put("others", sum.subtract(sumOfGrandTotalInData));
			}
			Map<?, ?> retMap = UtilMisc.toMap("bestCus", data);
			return (Map<String, Object>) retMap;
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<?, ?> retMap = UtilMisc.toMap("bestCus",
				ServiceUtil.returnError("error"));
		return (Map<String, Object>) retMap;
	}

	/*
	 * end dashboard screen
	 */

	/**
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½ danh
	 * sÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ch cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡c
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â¡n hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getOrderHeaderListView(HttpServletRequest request,
			HttpServletResponse response) {
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		String viewIndex = request.getParameter("viewIndex");
		String viewSize = request.getParameter("viewSize");
		String current = request.getParameter("current");
		String month = request.getParameter("month");
		try {
			Map<String, Object> cond = FastMap.newInstance();
			cond.put("userLogin", userLogin);
			cond.put("viewIndex", viewIndex);
			cond.put("viewSize", viewSize);
			cond.put("current", current);
			cond.put("month", month);
			Map<String, Object> result = dispatcher.runSync(
					"getOrderHeaderListView", cond);
			if (result.get("reponses_messages") != null
					&& result.get("reponses_messages").equals("success")) {
				request.setAttribute("orderHeaderList",
						result.get("orderHeaderList"));
				request.setAttribute("total", result.get("total"));
				request.setAttribute("size", result.get("size"));
			}

		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
		return "success";
	}

	/**
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> orderHeaderListView(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String page = (String) context.get("viewIndex");
		Integer pg = Integer.parseInt(page);
		String size = (String) context.get("viewSize");
		String current = (String) context.get("current");
		String month = (String) context.get("month");
		Integer sz = Integer.parseInt(size);
		Delegator delegator = dctx.getDelegator();
		String optionSelect = month;
		Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
		Timestamp End = null;
		Timestamp Start = null;
		EntityCondition condStart = null;
		EntityCondition condEnd = null;
		if(UtilValidate.isEmpty(optionSelect) || optionSelect == null){
			optionSelect = "thismonth";
		}
		
		if(optionSelect.equals("thismonth")){
			 End = UtilDateTime.getMonthEnd(nowTimestamp, TimeZone.getDefault(),Locale.getDefault());
			 Start  = UtilDateTime.getMonthStart(nowTimestamp);
			condStart = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,Start);
			condEnd = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,End);
		}else if(optionSelect.equals("thisweek")){
			End = UtilDateTime.getWeekEnd(nowTimestamp);
			Start = UtilDateTime.getWeekStart(nowTimestamp);
			condStart = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,Start);
			condEnd = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,End);
		}
		if (currencyUom == null) {
			currencyUom = EntityUtilProperties.getPropertyValue(
					"general.properties", "currency.uom.id.default", "USD",
					delegator);
		}
		List<Map<String, Object>> orderList = FastList.newInstance();
		Map<String, Object> res = FastMap.newInstance();
		try {
			List<GenericValue> orderHeaderList = FastList.newInstance();
			EntityCondition createBy = EntityCondition.makeCondition(
					"createdBy", EntityOperator.EQUALS,
					userLogin.getString("userLoginId"));
			EntityCondition roleTypeId = EntityCondition.makeCondition(
					"roleTypeId", EntityOperator.EQUALS, "PLACING_CUSTOMER");
			List<EntityCondition> lc = FastList.newInstance();
			lc.add(createBy);
			lc.add(roleTypeId);
			lc.add(condStart);
			lc.add(condEnd);
//			if (current != null && current != "") {
//				EntityCondition partyId = EntityCondition.makeCondition(
//						"partyId", EntityOperator.EQUALS, current);
//				lc.add(partyId);
//			}
			EntityConditionList<EntityCondition> listCondition = EntityCondition
					.makeCondition(lc, EntityOperator.AND);
			Set<String> fields = UtilMisc.toSet("orderId", "orderDate",
					 "grandTotal", "roleTypeId", "groupName","statusId");
			List<String> orderBy = UtilMisc.toList("orderDate DESC");
			EntityFindOptions options = new EntityFindOptions();
			options.setDistinct(true);
			orderHeaderList = delegator.findList("OrderHeaderDetail",
					listCondition, fields, orderBy, options, false);
			int from = pg * sz;
			int to = from + sz;
			Integer length = orderHeaderList.size();
			if (length > from) {
				int end = to;
				if (length < to) {
					end = length;
				}
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat(
						"dd-MM-yyyy");
				for (int i = from; i < end; i++) {
					GenericValue cur = orderHeaderList.get(i);
					String e = simpleDateFormat.format((Timestamp) cur
							.getTimestamp("orderDate"));
					Map<String, Object> obj = FastMap.newInstance();
					obj.put("orderId", cur.getString("orderId"));
					obj.put("orderDate", e);
					obj.put("grandTotal", cur.getBigDecimal("grandTotal"));
					obj.put("roleTypeId", cur.getString("roleTypeId"));
					obj.put("groupName", cur.getString("groupName"));
					obj.put("statusId", cur.getString("statusId"));
					orderList.add(obj);
				}
			}
			Integer total = (int) Math.ceil((double) length / (double) sz);
			res.put("total", total.toString());
			res.put("size", length.toString());
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError("error");
		}

		res.put("reponses_messages", "success");
		res.put("orderHeaderList", orderList);
		return res;
		// "orderStatusState", statusState
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static String getAllCategories(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		CategoryWorker.getRelatedCategories(
				request,
				"topLevelList",
				CatalogWorker.getCatalogTopCategoryId(request,
						CatalogWorker.getCurrentCatalogId(request)), true);
		List<GenericValue> categoryList = (List<GenericValue>) request
				.getAttribute("topLevelList");
		if (categoryList != null) {
			Map<String, CategoryContentWrapper> catContentWrappers = FastMap
					.newInstance();
			try {
				CategoryWorker.getCategoryContentWrappers(catContentWrappers,
						categoryList, request);
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		List<GenericValue> completedTree = MobileUtils.fillTree(categoryList,
				1, "", delegator, request);
		request.setAttribute("completedTreeCat", completedTree);
		return "success";
	}

	/*
	 * get all category of producer store
	 */
	public static List<Map<String, Object>> getCategories(
			HttpServletRequest request) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		CategoryWorker.getRelatedCategories(
				request,
				"topLevelList",
				CatalogWorker.getCatalogTopCategoryId(request,
						CatalogWorker.getCurrentCatalogId(request)), true);
		List<GenericValue> categoryList = (List<GenericValue>) request
				.getAttribute("topLevelList");
		if (categoryList != null) {
			Map<String, CategoryContentWrapper> catContentWrappers = FastMap
					.newInstance();
			try {
				CategoryWorker.getCategoryContentWrappers(catContentWrappers,
						categoryList, request);
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		List<Map<String, Object>> completedTree = MobileUtils.fillTree(
				categoryList, 1, "", delegator, request);
		return completedTree;
	};

	/*
	 * get all products
	 */
	public static String getAllProducts(HttpServletRequest request,
			HttpServletResponse response) throws GenericEntityException {
		List<Map<String, Object>> categoryList = getCategories(request);
		List<Map<String, Object>> resultList = FastList.newInstance();
		if(categoryList == null) {
			return "success";
		}
		String catId = "";
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		// DecimalFormat format = new DecimalFormat("###,###.###");
		String currency = request.getParameter("currencyUomId");
		if (currency == null || currency.isEmpty()) {
			currency = UtilProperties.getPropertyValue("general",
					"currency.uom.id.default");
		}
		EntityFindOptions options = new EntityFindOptions(true,
				EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
				EntityFindOptions.CONCUR_READ_ONLY, true);
		
		for (Map<String, Object> category : categoryList) {
			catId = (String) category.get("productCategoryId");
			EntityCondition ec = EntityCondition.makeCondition(
					"productCategoryId", EntityOperator.EQUALS, catId);
			EntityCondition cr = EntityCondition.makeCondition(
					"priceCurrencyUomId", EntityOperator.EQUALS, currency);
			List<EntityCondition> allConditions = FastList.newInstance();
			allConditions.add(ec);
			allConditions.add(cr);
			allConditions.add(EntityCondition.makeCondition(
					"priceProductPriceTypeId", EntityOperator.EQUALS,
					"LIST_PRICE"));
			EntityCondition queryConditionsList = EntityCondition
					.makeCondition(allConditions, EntityOperator.AND);
			String viewSize = request.getParameter("viewSize");
			String viewIndex = request.getParameter("viewIndex");
			int page = 0;
			int size = 10;
			if (viewSize != null) {
				size = Integer.parseInt(viewSize);
			}
			if (viewIndex != null) {
				page = Integer.parseInt(viewIndex);
			}
			EntityListIterator iterator = null;
			List<GenericValue> listProduct;
			try {
				LocalDispatcher dispatcher = (LocalDispatcher) request
						.getAttribute("dispatcher");
				Map<String, Object> tmpMap = new HashMap<String, Object>();
				tmpMap.put("inputParams", queryConditionsList);
				Map<String, Object> tmpMap2 = dispatcher.runSync("TempGetAllProduct", tmpMap);
				iterator = (EntityListIterator) tmpMap2.get("outputParams");
				listProduct = iterator.getPartialList(size * page, size);
				for (GenericValue product : listProduct) {
					Map<String, Object> res = FastMap.newInstance();
					res.put("productId", product.get("productId"));
					res.put("productName", product.get("productInternalName"));
					// res.put("productCategoryId",
					// product.get("productCategoryId"));
					res.put("uom", product.get("priceCurrencyUomId"));
					res.put("unitPrice", product.get("pricePrice"));
					res.put("productCategoryId", product.get("productCategoryId"));
					resultList.add(res);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			finally{
				if(iterator!= null){
					iterator.close();
				}
			}
		}
		request.setAttribute("listProduct", resultList);
		return "success";
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getProductOfCat(HttpServletRequest request,
			HttpServletResponse response) {
		String prodCatId = (String) request.getParameter("productCategoryId");
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		List<EntityCondition> allConditions = FastList.newInstance();
		allConditions.add(EntityCondition.makeCondition("productCategoryId",
				EntityOperator.EQUALS, prodCatId));
		allConditions
				.add(EntityCondition.makeCondition("priceProductPriceTypeId",
						EntityOperator.EQUALS, "LIST_PRICE"));
		EntityCondition temp = EntityCondition.makeCondition(allConditions,
				EntityOperator.AND);
		DecimalFormat format = new DecimalFormat("###,###.###");
		List<Map<String, Object>> resultList = FastList.newInstance();
		try {
			String viewSize = request.getParameter("viewSize");
			String viewIndex = request.getParameter("viewIndex");
			int page = 0;
			int size = 10;
			if (viewSize != null) {
				size = Integer.parseInt(viewSize);
			}
			if (viewIndex != null) {
				page = Integer.parseInt(viewIndex);
			}
			EntityFindOptions options = new EntityFindOptions(true,
					EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
					EntityFindOptions.CONCUR_READ_ONLY, true);
			EntityListIterator iterator = delegator.find(
					"ProductCategoryMemberAndPrice", temp, null, UtilMisc
							.toSet("productId", "productInternalName",
									"productCategoryId", "pricePrice",
									"priceCurrencyUomId"), null, options);
			List<GenericValue> listProduct = iterator.getPartialList(size
					* page, size);
			Integer total = iterator.getResultsSizeAfterPartialList();
			for (GenericValue product : listProduct) {
				resultList.add(UtilMisc.toMap("productId",
						product.get("productId"), "productName",
						product.get("productInternalName"),
						"productCategoryId", product.get("productCategoryId"),
						"unitPrice", product.getBigDecimal("pricePrice"),
						"uom", product.get("priceCurrencyUomId")));
			}
			request.setAttribute("listProduct", resultList);
			request.setAttribute("total", total);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
		return "success";
	}

	/**
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½
	 * thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â´ng tin 1
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â¡n hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getOrderStatus(HttpServletRequest request,
			HttpServletResponse response) {
		String orderId = (String) request.getParameter("orderId");
		String statusUserLogin = null;
		GenericValue orderHeader = null;
		Map<String, Object> ctxMap = FastMap.newInstance();
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		DecimalFormat format = new DecimalFormat("###,###.###");
		if (currencyUom == null) {
			currencyUom = EntityUtilProperties.getPropertyValue(
					"general.properties", "currency.uom.id.default", "USD",
					delegator);
		}
		try {
			if (userLogin != null) {
				if (orderId != null) {
					orderHeader = delegator.findOne("OrderHeader",
							UtilMisc.toMap("orderId", orderId), false);
					List<GenericValue> orderStatuses = orderHeader.getRelated(
							"OrderStatus", null, null, false);
					List<GenericValue> filteredOrderStatusList = FastList
							.newInstance();
					boolean extOfflineModeExists = false;
					List<GenericValue> orderPaymentPreferences = orderHeader
							.getRelated(
									"OrderPaymentPreference",
									null,
									UtilMisc.toList("orderPaymentPreferenceId"),
									false);
					List<GenericValue> filteredOrderPaymentPreferences = EntityUtil
							.filterByCondition(orderPaymentPreferences,
									EntityCondition.makeCondition(
											"paymentMethodTypeId",
											EntityOperator.IN,
											UtilMisc.toList("EXT_OFFLINE")));
					if (filteredOrderPaymentPreferences != null) {
						extOfflineModeExists = true;
					}

					if (extOfflineModeExists) {
						filteredOrderStatusList = EntityUtil.filterByCondition(
								orderStatuses, EntityCondition.makeCondition(
										"statusId", EntityOperator.IN, UtilMisc
												.toList("ORDER_COMPLETED",
														"ORDER_APPROVED",
														"ORDER_CREATED")));
					} else {
						filteredOrderStatusList = EntityUtil.filterByCondition(
								orderStatuses, EntityCondition.makeCondition(
										"statusId", EntityOperator.IN, UtilMisc
												.toList("ORDER_COMPLETED",
														"ORDER_APPROVED")));

					}
					if (UtilValidate.isNotEmpty(filteredOrderStatusList)) {
						if (filteredOrderStatusList.size() < 2) {
							statusUserLogin = EntityUtil.getFirst(
									filteredOrderStatusList).getString(
									"statusUserLogin");
						} else {
							for (GenericValue orderStatus : filteredOrderStatusList) {
								if ("ORDER_COMPLETED".equals(orderStatus
										.get("statusId"))) {
									statusUserLogin = orderStatus
											.getString("statusUserLogin");
									userLogin = delegator.findOne("UserLogin",
											UtilMisc.toMap("userLoginId",
													statusUserLogin), false);
								}
							}
						}
					}
				}
			}
			// context.userLogin = userLogin;
			// String partyId = (String) request.getParameter("customerId");
			String roleTypeId = null;
			if (orderId != null) {
				orderHeader = delegator.findOne("OrderHeader",
						UtilMisc.toMap("orderId", orderId), false);
				if ("PURCHASE_ORDER".equals(orderHeader.get("orderTypeId"))) {
					roleTypeId = "SUPPLIER_AGENT";
				} else {
					roleTypeId = "PALCING_CUSTOMER";
				}
				ctxMap.put("roleTypeId", roleTypeId);

			}
			if (orderHeader != null) {
				GenericValue productStore = orderHeader.getRelatedOne(
						"ProductStore", true);
				OrderReadHelper orderReadHelper = new OrderReadHelper(
						orderHeader);
				List<GenericValue> orderItems = orderReadHelper.getOrderItems();
				List<GenericValue> orderAdjustments = orderReadHelper
						.getAdjustments();
				List<GenericValue> orderHeaderAdjustments = orderReadHelper
						.getOrderHeaderAdjustments();
				BigDecimal orderSubTotal = orderReadHelper
						.getOrderItemsSubTotal();
				List<GenericValue> orderItemShipGroups = orderReadHelper
						.getOrderItemShipGroups();
				List<GenericValue> headerAdjustmentsToShow = orderReadHelper
						.getOrderHeaderAdjustments();
				List<GenericValue> ajustments = orderReadHelper
						.getAdjustments();
				// GenericValue billAddr = orderReadHelper.getBillingAddress();
				GenericValue endUserParty = orderReadHelper.getEndUserParty();
				Map<String, BigDecimal> orderItemReturnedQuantities = orderReadHelper
						.getOrderItemReturnedQuantities();
				List<GenericValue> orderReturnedItems = orderReadHelper
						.getOrderReturnItems();
				boolean rejectedOrderItems = orderReadHelper
						.getRejectedOrderItems();
				GenericValue shipToParty = orderReadHelper.getShipToParty();
				BigDecimal shippableQuantity = orderReadHelper
						.getShippableQuantity();
				List<BigDecimal> shippableSizes = orderReadHelper
						.getShippableSizes();
				GenericValue shippingAddress = orderReadHelper
						.getShippingAddress();
				List<GenericValue> shippingLocations = orderReadHelper
						.getShippingLocations();
				BigDecimal shippingTotal = orderReadHelper.getShippingTotal();

				BigDecimal orderShippingTotal = OrderReadHelper
						.getAllOrderItemsAdjustmentsTotal(orderItems,
								orderAdjustments, false, false, true);
				orderShippingTotal = orderShippingTotal.add(OrderReadHelper
						.calcOrderAdjustments(orderHeaderAdjustments,
								orderSubTotal, false, false, true));

				BigDecimal orderTaxTotal = OrderReadHelper
						.getAllOrderItemsAdjustmentsTotal(orderItems,
								orderAdjustments, false, true, false);
				orderTaxTotal = orderTaxTotal.add(OrderReadHelper
						.calcOrderAdjustments(orderHeaderAdjustments,
								orderSubTotal, false, true, false));

				List<GenericValue> placingCustomerOrderRoles = delegator
						.findByAnd("OrderRole", UtilMisc.toMap("orderId",
								orderId, "roleTypeId", roleTypeId), null, false);
				GenericValue placingCustomerOrderRole = EntityUtil
						.getFirst(placingCustomerOrderRoles);
				GenericValue placingCustomerPerson = placingCustomerOrderRole == null ? null
						: delegator
								.findOne("Person", UtilMisc
										.toMap("partyId",
												placingCustomerOrderRole
														.get("partyId")), false);

				GenericValue billingAccount = orderHeader.getRelatedOne(
						"BillingAccount", false);

				List<GenericValue> orderPaymentPreferences = EntityUtil
						.filterByAnd(orderHeader.getRelated(
								"OrderPaymentPreference", null, null, false),
								UtilMisc.toList(EntityCondition.makeCondition(
										"statusId", EntityOperator.NOT_EQUAL,
										"PAYMENT_CANCELLED")));
				List<GenericValue> paymentMethods = FastList.newInstance();
				for (GenericValue opp : orderPaymentPreferences) {
					GenericValue paymentMethod = opp.getRelatedOne(
							"PaymentMethod", false);
					if (paymentMethod != null) {
						paymentMethods.add(paymentMethod);
					} else {
						GenericValue paymentMethodType = opp.getRelatedOne(
								"PaymentMethodType", false);
						if (paymentMethodType != null) {
							ctxMap.put("paymentMethodType", paymentMethodType);
						}
					}
				}
				String payToPartyId = productStore.getString("payToPartyId");
				GenericValue paymentAddress = PaymentWorker.getPaymentAddress(
						delegator, payToPartyId);
				if (paymentAddress != null) {
					ctxMap.put("paymentAddress", paymentAddress);
				}
				// get Shipment tracking info
				EntityFieldMap osisCond = EntityCondition.makeCondition(
						UtilMisc.toMap("orderId", orderId), EntityOperator.AND);
				List<String> osisOrder = UtilMisc.toList("shipmentId",
						"shipmentRouteSegmentId", "shipmentPackageSeqId");
				Set<String> osisFields = UtilMisc.toSet("shipmentId",
						"shipmentRouteSegmentId", "carrierPartyId",
						"shipmentMethodTypeId");
				osisFields.add("shipmentPackageSeqId");
				osisFields.add("trackingCode");
				osisFields.add("boxNumber");
				EntityFindOptions osisFindOptions = new EntityFindOptions();
				osisFindOptions.setDistinct(true);
				List<GenericValue> orderShipmentInfoSummaryList = delegator
						.findList("OrderShipmentInfoSummary", osisCond,
								osisFields, osisOrder, osisFindOptions, false);
				Set<String> customerPoNumberSet = new TreeSet<String>();
				for (GenericValue orderItemPo : orderItems) {
					String correspondingPoId = orderItemPo
							.getString("correspondingPoId");
					if (correspondingPoId != null
							&& !"(none)".equals(correspondingPoId)) {
						customerPoNumberSet.add(correspondingPoId);
					}
				}
				// check if there are returnable items
				BigDecimal returned = new BigDecimal("0.00");
				BigDecimal totalItems = new BigDecimal("0.00");
				for (GenericValue oitem : orderItems) {
					totalItems = totalItems
							.add(oitem.getBigDecimal("quantity"));
					List<GenericValue> ritems = oitem.getRelated("ReturnItem",
							null, null, false);
					for (GenericValue ritem : ritems) {
						GenericValue rh = ritem.getRelatedOne("ReturnHeader",
								false);
						if (!rh.get("statusId").equals("RETURN_CANCELLED")) {
							returned = returned.add(ritem
									.getBigDecimal("returnQuantity"));
						}
					}
					if (!orderReadHelper.getOrderItemAdjustments(oitem)
							.isEmpty()) {
						ctxMap.put(
								orderId + "_"
										+ oitem.getString("orderItemSeqId"),
								orderReadHelper.getOrderItemAdjustments(oitem));
					}
					ctxMap.put(
							orderId + "_" + oitem.getString("orderItemSeqId")
									+ "_adjustmentsTotal",
							format.format(orderReadHelper
									.getOrderItemAdjustmentsTotal(oitem))
									+ " "
									+ currencyUom);
					ctxMap.put(
							orderId + "_" + oitem.getString("orderItemSeqId")
									+ "_total",
							format.format(orderReadHelper
									.getOrderItemTotal(oitem))
									+ " "
									+ currencyUom);
				}
				if (totalItems.compareTo(returned) > 0) {
					ctxMap.put("returnLink", "Y");
				}
				if (ajustments.size() > 0) {
					Map<String, Object> productPromo = FastMap.newInstance();
					for (GenericValue ajusment : ajustments) {
						productPromo.put(ajusment.getString("productPromoId"),
								ajusment.getString("description"));
					}
					ctxMap.put("ajustment", orderReadHelper.getAdjustments());// maybe
																				// delete
					ctxMap.put("productPromo", productPromo);
				}

				ctxMap.put("statusId", orderHeader.getString("statusId"));

				ctxMap.put("orderId", orderId);
				ctxMap.put("orderHeader", orderHeader);

				ctxMap.put("endUserParty", endUserParty);
				ctxMap.put("orderItemReturnedQuantities",
						orderItemReturnedQuantities);
				ctxMap.put("rejectedOrderItems", rejectedOrderItems);
				ctxMap.put("shipToParty", shipToParty);
				ctxMap.put("shippableQuantity", shippableQuantity);
				ctxMap.put("orderReturnedItems", orderReturnedItems);
				ctxMap.put("shippableSizes", shippableSizes);
				ctxMap.put("shippingAddress", shippingAddress);
				ctxMap.put("shippingLocations", shippingLocations);
				ctxMap.put("shippingTotal", format.format(shippingTotal) + " "
						+ currencyUom);
				ctxMap.put("billToParty", orderReadHelper.getBillToParty());

				// ctxMap.put("localOrderReadHelper", orderReadHelper);
				ctxMap.put("orderItems", orderItems);
				ctxMap.put("orderAdjustments", orderAdjustments);
				ctxMap.put("orderHeaderAdjustments", orderHeaderAdjustments);
				ctxMap.put("orderSubTotal", format.format(orderSubTotal) + " "
						+ currencyUom);
				ctxMap.put("orderItemShipGroups", orderItemShipGroups);
				ctxMap.put("headerAdjustmentsToShow", headerAdjustmentsToShow);
				ctxMap.put("currencyUomId", orderReadHelper.getCurrency());

				ctxMap.put("orderShippingTotal", orderShippingTotal);
				ctxMap.put("orderTaxTotal", orderTaxTotal);
				ctxMap.put(
						"orderGrandTotal",
						format.format(OrderReadHelper.getOrderGrandTotal(
								orderItems, orderAdjustments))
								+ " "
								+ currencyUom);
				ctxMap.put("placingCustomerPerson", placingCustomerPerson);

				ctxMap.put("billingAccount", billingAccount);
				ctxMap.put("paymentMethods", paymentMethods);

				ctxMap.put("productStore", productStore);
				// ctxMap.put("isDemoStore", isDemoStore);

				ctxMap.put("orderShipmentInfoSummaryList",
						orderShipmentInfoSummaryList);
				ctxMap.put("customerPoNumberSet", customerPoNumberSet);
				List<GenericValue> orderItemChangeReasons = delegator
						.findByAnd("Enumeration", UtilMisc.toMap("enumTypeId",
								"ODR_ITM_CH_REASON"), UtilMisc
								.toList("sequenceId"), false);
				ctxMap.put("orderItemChangeReasons", orderItemChangeReasons);
				request.setAttribute("orderStatus", ctxMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	/**
	 * get customer detail information
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getCustomerDetailInfo(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String customerId = request.getParameter("customerId");
		// String time = request.getParameter("time");
		Map<String, Object> retMap = FastMap.newInstance();
		if (customerId != null) {
			try {
				GenericValue party = delegator.findOne("Party",
						UtilMisc.toMap("partyId", customerId), false);
				List<GenericValue> partyGeoView = delegator.findByAnd(
						"PartyGroupGeoView",
						UtilMisc.toMap("partyIdTo", customerId), null, true);
				GenericValue contactMech = EntityUtil.getFirst(ContactHelper
						.getContactMech(party, null, "POSTAL_ADDRESS", false));
				String city = "";
				if (contactMech != null) {
					GenericValue postalAddress = contactMech.getRelatedOne(
							"PostalAddress", false);
					if (postalAddress.get("city") != null) {
						city = postalAddress.getString("city");
					}
					retMap.put("address1", postalAddress.get("address1"));
					retMap.put("contactMechId",
							contactMech.get("contactMechId"));
					retMap.put("city", city);
					retMap.put("contactMechTypeId", "POSTAL_ADDRESS");
					retMap.put("postalCode", postalAddress.get("postalCode"));
					if (postalAddress.get("address2") != null)
						retMap.put("address2", postalAddress.get("address2"));
				}
				if (partyGeoView != null && !partyGeoView.isEmpty()) {
					retMap.put("groupName", partyGeoView.get(0)
							.get("groupName"));
					retMap.put("latitude", partyGeoView.get(0).get("latitude"));
					retMap.put("longitude", partyGeoView.get(0)
							.get("longitude"));
				}

			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "error";
			}
		}
		request.setAttribute("cusDetailsInfo", retMap);
		return "success";
	}

	/**
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½
	 * sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“
	 * lÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â£ng cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡c
	 * sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â£n phÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â©m
	 * mÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â  KH
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â·t trong
	 * thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ng nÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y hoÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â·c
	 * thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ng
	 * trÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Âºc
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getCusQtyProductInfo(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String customerId = request.getParameter("customerId");
		String time = request.getParameter("time");
		Map<String, Object> retMap = FastMap.newInstance();
		if (customerId != null) {
			try {
				Timestamp timeStart = UtilDateTime.getMonthStart(UtilDateTime
						.nowTimestamp());
				Timestamp timeEnd = UtilDateTime.getMonthEnd(
						UtilDateTime.nowTimestamp(), TimeZone.getDefault(),
						Locale.getDefault());
				if (time.equalsIgnoreCase("thisWeek")) {
					timeStart = UtilDateTime.getWeekStart(UtilDateTime
							.nowTimestamp());
					timeEnd = UtilDateTime.getWeekEnd(UtilDateTime
							.nowTimestamp());
				} else if (time.equalsIgnoreCase("lastMonth")) {
					Calendar cal = Calendar.getInstance();
					cal.add(Calendar.MONTH, -1);
					Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
					timeStart = UtilDateTime.getMonthStart(timestamp);
					timeEnd = UtilDateTime.getMonthEnd(timestamp,
							TimeZone.getDefault(), Locale.getDefault());
				}
				EntityConditionList<EntityExpr> ecl = EntityCondition
						.makeCondition(UtilMisc.toList(EntityCondition
								.makeCondition("partyId",
										EntityOperator.EQUALS, customerId),
								EntityCondition.makeCondition("createdStamp",
										EntityOperator.GREATER_THAN_EQUAL_TO,
										timeStart),
								EntityCondition.makeCondition("createdStamp",
										EntityOperator.LESS_THAN_EQUAL_TO,
										timeEnd)), EntityOperator.AND);
				EntityFindOptions findOptions = new EntityFindOptions();
				findOptions.setDistinct(true);
				List<GenericValue> orderIdList = delegator.findList(
						"OrderRole", ecl, UtilMisc.toSet("orderId"), null,
						findOptions, false);
				List<String> orderIdListStr = FastList.newInstance();
				for (GenericValue orderId : orderIdList) {
					orderIdListStr.add(orderId.getString("orderId"));
				}

				List<GenericValue> quantityProductOrderedList = delegator
						.findList("OrderItemAndProduct", EntityCondition
								.makeCondition("orderId", EntityOperator.IN,
										orderIdListStr), UtilMisc.toSet(
								"orderId", "orderItemSeqId", "productId",
								"quantity"), null, findOptions, false);
				Map<String, BigDecimal> totalQtyProductMap = FastMap
						.newInstance();
				for (GenericValue qtyProductOrder : quantityProductOrderedList) {
					String productId = qtyProductOrder.getString("productId");
					if (totalQtyProductMap.containsKey(productId)) {
						totalQtyProductMap.get(productId).add(
								qtyProductOrder.getBigDecimal("quantity"));
					} else {
						totalQtyProductMap.put(productId,
								qtyProductOrder.getBigDecimal("quantity"));
					}
				}
				if (orderIdList.size() > 0)
					retMap.put("topProductQty", totalQtyProductMap);
				request.setAttribute("cusQtyProductInfo", retMap);
			} catch (Exception e) {
			}
		}
		return "success";
	}

	/**
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½
	 * thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â´ng tin cÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â§a
	 * sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“
	 * lÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â£ng
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â¡n
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â·t
	 * hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng, tÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢ng
	 * sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ tiÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½n
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â¡n hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng
	 * trong thÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½i gian:
	 * tuÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â§n hiÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¡n
	 * tÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¡i, thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ng
	 * hiÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¡n tÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¡i
	 * hoÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â·c thÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ng
	 * trÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Âºc
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String getCusOrderInfo(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String customerId = request.getParameter("customerId");
		String time = request.getParameter("time");
		Map<String, Object> retMap = FastMap.newInstance();
		DecimalFormat format = new DecimalFormat("###,###.###");
		if (customerId != null) {
			try {
				Timestamp timeStart = UtilDateTime.getMonthStart(UtilDateTime
						.nowTimestamp());
				Timestamp timeEnd = UtilDateTime.getMonthEnd(
						UtilDateTime.nowTimestamp(), TimeZone.getDefault(),
						Locale.getDefault());
				if (time.equalsIgnoreCase("thisWeek")) {
					timeStart = UtilDateTime.getWeekStart(UtilDateTime
							.nowTimestamp());
					timeEnd = UtilDateTime.getWeekEnd(UtilDateTime
							.nowTimestamp());
				} else if (time.equalsIgnoreCase("lastMonth")) {
					Calendar cal = Calendar.getInstance();
					cal.add(Calendar.MONTH, -1);
					Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
					timeStart = UtilDateTime.getMonthStart(timestamp);
					timeEnd = UtilDateTime.getMonthEnd(timestamp,
							TimeZone.getDefault(), Locale.getDefault());
				}
				EntityConditionList<EntityExpr> ecl = EntityCondition
						.makeCondition(UtilMisc.toList(EntityCondition
								.makeCondition("partyId",
										EntityOperator.EQUALS, customerId),
								EntityCondition.makeCondition("createdStamp",
										EntityOperator.GREATER_THAN_EQUAL_TO,
										timeStart),
								EntityCondition.makeCondition("createdStamp",
										EntityOperator.LESS_THAN_EQUAL_TO,
										timeEnd)), EntityOperator.AND);
				EntityFindOptions findOptions = new EntityFindOptions();
				findOptions.setDistinct(true);
				List<GenericValue> orderIdList = delegator.findList(
						"OrderRole", ecl, UtilMisc.toSet("orderId"), null,
						findOptions, false);
				List<String> orderIdListStr = FastList.newInstance();
				for (GenericValue orderId : orderIdList) {
					orderIdListStr.add(orderId.getString("orderId"));
				}
				List<GenericValue> cusOrderInfoList = delegator.findList(
						"OrderHeader", EntityCondition.makeCondition("orderId",
								EntityOperator.IN, orderIdListStr), UtilMisc
								.toSet("orderId", "grandTotal"), null,
						findOptions, false);
				BigDecimal totalAmount = BigDecimal.ZERO;
				for (GenericValue cusOrderInfo : cusOrderInfoList) {
					totalAmount = totalAmount.add(cusOrderInfo
							.getBigDecimal("grandTotal"));
				}
				retMap.put("totalAmountOrders", format.format(totalAmount));
				retMap.put("totalOfNumberOrders", orderIdList.size());
				request.setAttribute("cusOrderInfo", retMap);
			} catch (Exception e) {
			}
		}
		return "success";
	}

	/*
	 * 
	 */
	/*
	 * public static String editGroupNameCus(HttpServletRequest request,
	 * HttpServletResponse response){ String groupName =
	 * request.getParameter("groupName"); String name =
	 * request.getParameter("name"); String pk = request.getParameter("pk");
	 * String partyId = request.getParameter("partyId"); Map parameters =
	 * request.getParameterMap(); return "success"; }
	 */

	/**
	 * cÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â­p nhÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â­p
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¹a
	 * chÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â° vÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â 
	 * tuyÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¿n
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ
	 * ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½ng cÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â§a
	 * KhÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡ch hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â ng sau khi
	 * ÃƒÆ’Ã¢â‚¬Å¾ÃƒÂ¢Ã¢â€šÂ¬Ã‹Å“ÃƒÆ’Ã¢â‚¬Â Ãƒâ€šÃ‚Â°ÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â£c
	 * tÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¡o
	 */
	public static Map<String, ? extends Object> updateAddressCustomer(
			DispatchContext dctx, Map<String, ? extends Object> context) {
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		String address1 = (String) context.get("address1");
		String partyId = (String) context.get("partyId");
		String city = (String) context.get("city");
		String roadId = (String) context.get("roadId");
		String latitude = (String) context.get("latitude");
		String longitude = (String) context.get("longitude");
		GenericValue userLogin = null;

		try {
			userLogin = delegator.findOne("UserLogin",
					UtilMisc.toMap("userLoginId", "system"), false);
		} catch (GenericEntityException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// GenericValue userLogin = (GenericValue)context.get("userLogin");
		Map<String, Object> ctxMap = FastMap.newInstance();
		ctxMap.put("address1", address1);
		ctxMap.put("partyId", partyId);
		if (latitude.isEmpty() && longitude.isEmpty()) {
			ctxMap.put("latitude", Double.parseDouble(latitude));
			ctxMap.put("longitude", Double.parseDouble(longitude));
		}
		ctxMap.put("contactMechTypeId", "POSTAL_ADDRESS");
		ctxMap.put("preContactMechTypeId", "POSTAL_ADDRESS");
		ctxMap.put("userLogin", userLogin);
		ctxMap.put("city", city);
		ctxMap.put("countryGeoId", "VNM");
		ctxMap.put("stateProvinceGeoId", "VN-HN");
		ctxMap.put("dataSourceId", "GEOPT_GOOGLE");
		// ctxMap.put("groupNameLocal", context.get("groupNameLocal"));
		// ctxMap.put("officeSiteName", context.get("officeSiteName"));
		// ctxMap.put("contactMechPurposeTypeId", "GENERAL_LOCATION");
		Map<String, Object> retMap = FastMap.newInstance();
		Map<String, Object> result = null;
		try {
			retMap = dispatcher.runSync("createPartyGeoAddress", ctxMap);
			String contactMechId = (String) retMap.get("contactMechId");
			if (contactMechId != null) {
				Map<String, Object> mapPartyRole = UtilMisc.toMap("partyId",
						partyId, "userLogin", userLogin);
				mapPartyRole.put("roleTypeId", "DELYS_CUSTOMER_GT");
				result = dispatcher.runSync("createPartyRole", mapPartyRole);

				String responeMessage = (String) result.get("responseMessage");
				if (!responeMessage.equalsIgnoreCase("success")) {
					return ServiceUtil.returnError("createPartyRole error");
				}
				Map<String, Object> partyRelationship = UtilMisc.toMap(
						"partyIdFrom", roadId, "partyIdTo", partyId,
						"roleTypeIdFrom", "DELYS_ROUTE", "roleTypeIdTo",
						"DELYS_CUSTOMER_GT", "userLogin", userLogin,
						"partyRelationshipTypeId", "GROUP_ROLLUP");
				result = dispatcher.runSync("createPartyRelationship",
						partyRelationship);

				responeMessage = (String) result.get("responseMessage");
				if (!responeMessage.equalsIgnoreCase("success")) {
					return ServiceUtil
							.returnError("createPartyRelationship error");
				}
				/**
				 * add purpose
				 */
				result = dispatcher.runSync("createPartyContactMechPurpose",
						UtilMisc.toMap("partyId", partyId, "contactMechId",
								contactMechId, "contactMechPurposeTypeId",
								"SHIPPING_LOCATION", "userLogin", userLogin));
				responeMessage = (String) result.get("responseMessage");
				if (!responeMessage.equalsIgnoreCase("success")) {
					return ServiceUtil
							.returnError("createPartyContactMechPurpose error");
				}

				result = dispatcher.runSync("createPartyContactMechPurpose",
						UtilMisc.toMap("partyId", partyId, "contactMechId",
								contactMechId, "contactMechPurposeTypeId",
								"SHIP_ORIG_LOCATION", "userLogin", userLogin));
				responeMessage = (String) result.get("responseMessage");
				if (!responeMessage.equalsIgnoreCase("success")) {
					return ServiceUtil
							.returnError("createPartyContactMechPurpose error");
				}
				/** End add purpose */

			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return ServiceUtil.returnError("createCustomer error");
		}
		return retMap;
	}

	/**
	 * update password for salesman
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String updatePassword(HttpServletRequest request,
			HttpServletResponse response) {
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String newPassword = (String) request.getParameter("newPassword");
		String currentPass = (String) request.getParameter("currentPassword");
		String verifyPass = (String) request.getParameter("newPasswordVerify");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");

		try {
			GenericValue system = delegator.findOne("UserLogin",
					UtilMisc.toMap("userLoginId", "system"), false);
			Map<String, Object> contextMap = FastMap.newInstance();
			contextMap.put("currentPassword", currentPass);
			contextMap.put("newPasswordVerify", verifyPass);
			contextMap.put("newPassword", newPassword);
			contextMap.put("userLoginId", userLogin.get("userLoginId"));
			contextMap.put("userLogin", system);
			Map<String, Object> resultMap = dispatcher.runSync(
					"updatePassword", contextMap);
			request.setAttribute("responseMessage",
					resultMap.get("responseMessage"));
			if (resultMap.get("responseMessage").equals("error")) {
				request.setAttribute("errorMessageList",
						resultMap.get("errorMessageList"));
			}
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			request.setAttribute("responseMessage", "error");
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	/**
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> updatePersonSalesman(
			DispatchContext dctx, Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Map<String, Object> ctxMap = FastMap.newInstance();
		Map<String, Object> retMap = FastMap.newInstance();
		try {
			GenericValue systemUserLogin = delegator.findOne("UserLogin",
					UtilMisc.toMap("userLoginId", "system"), false);
			ctxMap.put("firstName", context.get("firstName"));
			ctxMap.put("lastName", context.get("lastName"));
			ctxMap.put("partyId",
					((GenericValue) context.get("userLogin")).get("partyId"));
			ctxMap.put("userLogin", systemUserLogin);
			if (context.get("middleName") != null) {
				ctxMap.put("middleName", context.get("middleName"));
			}
			retMap = dispatcher.runSync("updatePerson", ctxMap);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<?, ?> tempMap = UtilMisc.toMap("updateMessage", retMap);
		return (Map<String, Object>) tempMap;
	}

	/**
	 * edit avatar salesman
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	public static Map<String, Object> editAvatarSalesman(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		// Map requestMap = UtilHttp.getParameterMap(request);
		// request.getParameter("formData");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		// String dataImge = request.getParameter("uploadedFile");
		String fileName = (String) context.get("filename");
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> retMap = FastMap.newInstance();
		try {
			GenericValue system = delegator.findOne("UserLogin",
					UtilMisc.toMap("userLoginId", "system"), false);

			ByteBuffer uploadedFile = (ByteBuffer) context.get("uploadedFile");
			GenericValue userLogin = (GenericValue) context.get("userLogin");
			FileNameMap fileNameMap = URLConnection.getFileNameMap();
			String contentType = fileNameMap.getContentTypeFor(fileName);

			Map<String, Object> contextMap = FastMap.newInstance();
			contextMap.put("dataCategoryId", "PERSONAL");
			contextMap.put("contentTypeId", "DOCUMENT");
			contextMap.put("statusId", "CTNT_PUBLISHED");
			contextMap.put("userLogin", system);
			contextMap.put("partyId", userLogin.get("partyId"));
			contextMap.put("isPublic", "Y");
			contextMap.put("roleTypeId", "_NA_");
			contextMap.put("partyContentTypeId", "LGOIMGURL");
			contextMap.put("uploadedFile", uploadedFile);
			contextMap.put("_uploadedFile_fileName", fileName);
			contextMap.put("_uploadedFile_contentType", contentType);
			// contextMap.put("mimeTypeId", contentType);

			Map<String, Object> result = null;

			result = dispatcher.runSync("uploadPartyContentFile", contextMap);
			retMap.put("resultUpdate", result);
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retMap;
	}

	/**
	 * lÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â¥y vÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¯Ã‚Â¿Ã‚Â½
	 * cÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡c sÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â£n
	 * phÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚ÂºÃƒâ€šÃ‚Â©m mÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»ÃƒÂ¢Ã¢â€šÂ¬Ã‚Âºi
	 * dÃƒÆ’Ã‚Â¡Ãƒâ€šÃ‚Â»Ãƒâ€šÃ‚Â±a theo ngÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â y
	 * phÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¡t hÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â nh (release date)
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	public static String getNewProducts(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -31);
		Timestamp oneMonthAgo = new Timestamp(cal.getTimeInMillis());
		Map<String, Object> productList = FastMap.newInstance();
		DateTimeConverters.TimestampToString converter = new TimestampToString();
		try {
			EntityConditionList<EntityExpr> ecl = EntityCondition
					.makeCondition(UtilMisc.toList(EntityCondition
							.makeCondition("releaseDate",
									EntityOperator.GREATER_THAN_EQUAL_TO,
									oneMonthAgo), EntityCondition
							.makeCondition("releaseDate",
									EntityOperator.LESS_THAN_EQUAL_TO,
									UtilDateTime.nowTimestamp())),
							EntityOperator.AND);

			List<GenericValue> newProductList = delegator.findList("Product",
					ecl,
					UtilMisc.toSet("productId", "productName", "releaseDate"),
					UtilMisc.toList("releaseDate"), null, false);
			for (GenericValue newProduct : newProductList) {
				productList.put(newProduct.getString("productId"), UtilMisc
						.toMap("productName", newProduct
								.getString("productName"), "releaseDate",
								converter.convert(
										newProduct.getTimestamp("releaseDate"),
										Locale.getDefault(),
										TimeZone.getDefault(),
										UtilDateTime.DATE_FORMAT)));
			}
			request.setAttribute("numberNewProduct", newProductList.size());
			request.setAttribute("newProduct", productList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return "success";
	}

	@SuppressWarnings("unchecked")
	public static String getCalendarEventByMonth(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String startParam = request.getParameter("start");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		TimeZone timeZone = TimeZone.getDefault();
		Locale locale = Locale.getDefault();
		Map<String, Object> context = FastMap.newInstance();
		Timestamp start = null;
		if (UtilValidate.isNotEmpty(startParam)) {
			start = new Timestamp(Long.parseLong(startParam));
		}
		if (start == null) {
			start = UtilDateTime.getMonthStart(UtilDateTime.nowTimestamp(),
					timeZone, locale);
		} else {
			start = UtilDateTime.getMonthStart(start, timeZone, locale);
		}
		Calendar tempCal = UtilDateTime.toCalendar(new Date(start.getTime()),
				timeZone, locale);
		int numDays = tempCal.getActualMaximum(Calendar.DAY_OF_MONTH);
		Timestamp prev = UtilDateTime
				.getMonthStart(start, -1, timeZone, locale);
		context.put("prevMillis", new Long(prev.getTime()).toString());
		Timestamp next = UtilDateTime.getDayStart(start, numDays + 1, timeZone,
				locale);
		context.put("nextMillis", new Long(next.getTime()).toString());
		Timestamp end = UtilDateTime.getMonthEnd(start, timeZone, locale);
		Timestamp getFrom = null;
		int prevMonthDays = tempCal.get(Calendar.DAY_OF_WEEK)
				- tempCal.getFirstDayOfWeek();
		if (prevMonthDays < 0)
			prevMonthDays += 7;
		tempCal.add(Calendar.DATE, -prevMonthDays);
		numDays += prevMonthDays;
		getFrom = new Timestamp(tempCal.getTimeInMillis());
		int firstWeekNum = tempCal.get(Calendar.WEEK_OF_YEAR);
		context.put("firstWeekNum", firstWeekNum);
		// also get days until the end of the week at the end of the month
		Calendar lastWeekCal = UtilDateTime.toCalendar(end, timeZone, locale);
		int monthEndDay = lastWeekCal.get(Calendar.DAY_OF_WEEK);
		Timestamp getTo = UtilDateTime.getWeekEnd(end, timeZone, locale);
		lastWeekCal = UtilDateTime.toCalendar(getTo, timeZone, locale);
		int followingMonthDays = lastWeekCal.get(Calendar.DAY_OF_WEEK)
				- monthEndDay;
		if (followingMonthDays < 0) {
			followingMonthDays += 7;
		}

		numDays += followingMonthDays;
		Map<String, Object> serviceCtx;
		try {
			serviceCtx = dispatcher.getDispatchContext().makeValidContext(
					"getWorkEffortEventsByPeriod", "IN",
					UtilHttp.getCombinedMap(request));
			serviceCtx.putAll(UtilMisc.toMap("userLogin", userLogin, "start",
					getFrom, "calendarType", "VOID", "numPeriods", numDays,
					"periodType", Calendar.DATE, "locale", locale, "timeZone",
					timeZone));
			if (context.get("entityExprList") != null) {
				serviceCtx.put("entityExprList", context.get("entityExprList"));
			}
			Map<String, Object> result = dispatcher.runSync(
					"getWorkEffortEventsByPeriod", serviceCtx);

			// context.put("periods", result.get("periods"));
			List<Map<String, Object>> periods = (List<Map<String, Object>>) result
					.get("periods");
			Map<String, Object> entry = FastMap.newInstance();
			for (Map<String, Object> period : periods) {
				List<Map<String, Object>> calendarEntries = (List<Map<String, Object>>) period
						.get("calendarEntries");
				for (Map<String, Object> calEntry : calendarEntries) {
					Timestamp startedDate = null;
					Timestamp completionDate = null;
					if (calEntry.get("workEffort") != null) {
						GenericValue workEffort = (GenericValue) calEntry
								.get("workEffort");
						if (workEffort.getString("currentStatusId")
								.equalsIgnoreCase("CAL_TENTATIVE")) {
							if (workEffort.getTimestamp("actualStartDate") != null) {
								startedDate = workEffort
										.getTimestamp("actualStartDate");
							} else {
								startedDate = workEffort
										.getTimestamp("estimatedStartDate");
							}
							if (workEffort.getTimestamp("actualCompletionDate") != null) {
								completionDate = workEffort
										.getTimestamp("actualCompletionDate");
							} else {
								completionDate = workEffort
										.getTimestamp("estimatedCompletionDate");
							}
							if (completionDate == null
									&& workEffort
											.getDouble("actualMilliSeconds") != null) {
								completionDate = new Timestamp(
										(long) (workEffort.getTimestamp(
												"actualStartDate").getTime() + workEffort
												.getDouble("actualMilliSeconds")));
							}
							if (completionDate == null
									&& workEffort
											.getDouble("estimatedMilliSeconds") != null) {
								completionDate = new Timestamp(
										(long) (workEffort.getTimestamp(
												"estimatedStartDate").getTime() + workEffort
												.getDouble("estimatedMilliSeconds")));
							}
							GenericValue workEffortEntity = delegator.findOne(
									"WorkEffort",
									UtilMisc.toMap("workEffortId", workEffort
											.getString("workEffortId")), false);

							entry.put(
									"workEffortId_"
											+ workEffort
													.getString("workEffortId"),
									UtilMisc.toMap(
											"startedDate",
											startedDate,
											"completionDate",
											completionDate,
											"workEffortName",
											workEffortEntity
													.getString("workEffortName"),
											"workEffortId", workEffort
													.getString("workEffortId")));
						}
					}
				}
			}
			context.put("periods", entry);
			context.put("maxConcurrentEntries",
					result.get("maxConcurrentEntries"));
			context.put("start", start);
			context.put("end", end);
			context.put("prev", prev);
			context.put("next", next);

		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		request.setAttribute("partyId", userLogin.get("partyId"));
		request.setAttribute("calendarEventsMonth", context);
		return "success";
	}

	@SuppressWarnings("unchecked")
	public static Map<String, Object> getInventoryOfCusInfo(
			DispatchContext dctx, Map<String, Object> context) {
		Delegator delegator = dctx.getDelegator();
		String customerId = (String) context.get("partyId");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		List<GenericValue> inventoryCusInfo = null;
		List<GenericValue> productOrders = null;
		List<Map<String, Object>> res = FastList.newInstance();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
		try {
			EntityCondition party = EntityCondition.makeCondition("partyId",
					EntityOperator.EQUALS, customerId);
			EntityCondition created = EntityCondition.makeCondition(
					"createdBy", EntityOperator.EQUALS,
					userLogin.getString("userLoginId"));
			EntityCondition qty = EntityCondition.makeCondition(
					"qtyInInventory", EntityOperator.GREATER_THAN,
					BigDecimal.ZERO);
			Set<String> fields = UtilMisc.toSet("productId", "qtyInInventory",
					"productName", "orderDate", "orderId", "fromDate");
			List<String> orderBy = UtilMisc.toList("fromDate DESC");
			EntityCondition invenCon = EntityCondition.makeCondition(
					UtilMisc.toList(party, created, qty), EntityOperator.AND);
			inventoryCusInfo = delegator.findList("InventoryOfCustomerDetail",
					invenCon, fields, orderBy, null, false);
			if (!inventoryCusInfo.isEmpty()) {
				long newest = 0;
				Timestamp temp = null;
				for (GenericValue inventory : inventoryCusInfo) {
					String productId = inventory.getString("productId");
					GenericValue product = delegator.findOne("Product",
							UtilMisc.toMap("productId", productId), false);
					String productName = product.getString("productName");
					String orderId = inventory.getString("orderId");
					Timestamp orderDate = inventory.getTimestamp("orderDate");
					String orderStr = simpleDateFormat.format(orderDate);
					Timestamp fromDateTime = inventory.getTimestamp("fromDate");
					long fromDate = fromDateTime.getTime();
					if (newest == 0 && fromDate != 0) {
						newest = fromDate;
						temp = fromDateTime;
					}
					if (newest == fromDate) {
						Map<String, Object> tempMap = FastMap.newInstance();
						tempMap.put("productId", productId);
						tempMap.put("productName", productName);
						tempMap.put("orderId", orderId);
						tempMap.put("orderDate", orderStr);
						tempMap.put("qtyInInventory",
									inventory.getBigDecimal("qtyInInventory"));
						tempMap.put("partyId", customerId);
						res.add(tempMap);
					} else {
						break;
					}
				}
				/* get new order from recent check inventory */
				productOrders = getNewOrder(delegator, customerId, temp);
				for(GenericValue pro : productOrders){
					Map<String,Object> proTmp  = FastMap.newInstance();
					proTmp.put("productId", pro.getString("productId"));
					proTmp.put("productName", pro.getString("productName"));
					proTmp.put("orderId", pro.getString("orderId"));
					Timestamp orderDt =  pro.getTimestamp("orderDate");
					String orderTmp = simpleDateFormat.format(orderDt);
					proTmp.put("orderDate", orderTmp);
					proTmp.put("qtyInInventory", pro.getBigDecimal("quantity"));
					proTmp.put("partyId",customerId );
					res.add(proTmp);
				}
//				List<Map<String, Object>> tempMap = FastList.newInstance();
//				res.addAll(productOrders);
			} else {
				/* get inventory first time */
				productOrders = getNewOrder(delegator, customerId, null);
				res = initListInventoryObject(productOrders);
			}
		} catch (GenericEntityException e) {
			e.printStackTrace();
		}
		Map<String, Object> tempMap = FastMap.newInstance();
		tempMap.put("inventoryCusInfo", res);
		return tempMap;
	}

	/* get new order */
	public static List<GenericValue> getNewOrder(Delegator delegator,
			String customerId, Timestamp fromDateTime)
			throws GenericEntityException {
		EntityCondition party = EntityCondition.makeCondition("partyId",
				EntityOperator.EQUALS, customerId);

		Set<String> fields = UtilMisc.toSet("productId", "productName",
				"quantity", "orderDate", "orderId");
		EntityCondition orderStatus = EntityCondition.makeCondition("statusId",
				EntityOperator.EQUALS, "ORDER_COMPLETED");
		List<EntityCondition> conditionList = UtilMisc.toList(party,
				orderStatus);
		if (fromDateTime != null) {
			EntityCondition greaterOrderDate = EntityCondition
					.makeCondition("statusDatetime",
							EntityOperator.GREATER_THAN, fromDateTime);
			conditionList.add(greaterOrderDate);
		}
		EntityCondition orderCon = EntityCondition.makeCondition(conditionList,
				EntityOperator.AND);
		List<String> orderBy = UtilMisc.toList("orderDate DESC");
		List<GenericValue> productOrders = delegator.findList(
				"OrderProductDetail", orderCon, fields, orderBy, null, false);
		return productOrders;
	}

	/* init array of inventory object */
	public static List<Map<String, Object>> initListInventoryObject(
			List<GenericValue> productOrders) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
		List<Map<String, Object>> res = FastList.newInstance();
		for (GenericValue inventory : productOrders) {
			String productId = inventory.getString("productId");
			String productName = inventory.getString("productName");
			String orderId = inventory.getString("orderId");
			Timestamp orderDate = inventory.getTimestamp("orderDate");
			String orderStr = simpleDateFormat.format(orderDate);
			BigDecimal quantity = inventory.getBigDecimal("quantity");
			Map<String, Object> tempMap = initInventoryObject(productId,
					productName, orderId, orderStr, quantity);
			res.add(tempMap);
		}
		return res;
	}

	/* init inventory object */
	public static Map<String, Object> initInventoryObject(String productId,
			String productName, String orderId, String orderStr,
			BigDecimal quantity) {
		Map<String, Object> tempMap = FastMap.newInstance();
		tempMap.put("productId", productId);
		tempMap.put("productName", productName);
		tempMap.put("orderId", orderId);
		tempMap.put("orderDate", orderStr);
		tempMap.put("qtyInInventory", quantity);
		return tempMap;
	}

	/*
	 * submit inventory item of each customer update into database
	 */
	@SuppressWarnings("deprecation")
	public static String updateInventoryCus(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String party_id = request.getParameter("party_id");
		String checkInventoryList = request.getParameter("inventory");
		String lastCheck = request.getParameter("lastCheck");
		Timestamp fromDate = null;
		if(UtilValidate.isNotEmpty(lastCheck)){
			 fromDate  = new Timestamp(Long.parseLong(lastCheck));
		}
		JSONArray json = new JSONArray();
		if(UtilValidate.isNotEmpty(checkInventoryList)){
			 json = JSONArray.fromObject(checkInventoryList);
		}
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		int length = json.size();
		Date date = new Date();
		if(UtilValidate.isEmpty(fromDate)){
			 fromDate = new Timestamp(date.getTime());
		}
		if (userLogin != null && length != 0) {
			int error = 1;
			for (int i = 0; i < length; i++) {
					JSONObject inventory = json.getJSONObject(i);
					String productId = inventory.getString("productId");
					String quantity = inventory.getString("qtyInInventory");
					String orderId = inventory.getString("orderId");
					BigDecimal qttBig = new BigDecimal(quantity);
					try {
						Map<String, Object> ctxMap = FastMap.newInstance();
						ctxMap.put("productId", productId);
						ctxMap.put("partyId", party_id);
						ctxMap.put("orderId", orderId);
						ctxMap.put("qtyInInventory", qttBig);
						ctxMap.put("fromDate", fromDate);
						ctxMap.put("createdBy", userLogin.get("partyId"));
						delegator.create("ProductInventoryOfCustomer", ctxMap);
					} catch (GenericEntityException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						error++;
					}
					
				
			}
			if (error != 1) {
				request.setAttribute("retMsg", "Some error importing detect");
				return "error";
			}
			request.setAttribute("retMsg", "update_success");
			return "success";
		}

		request.setAttribute("retMsg", "login_required");
		return "error";
	}

	/*
	 * public static Map<String, Object>
	 * checkInventoryOfCustomer(DispatchContext dctx, Map<String, Object>
	 * context){ String checkInventory = (String)context.get("checkInventory");
	 * JSONObject json = JSONObject.fromObject(checkInventory); Iterator<String>
	 * prouductIdIt = json.keys(); return ServiceUtil.returnSuccess(); }
	 */

	/**
	 * kieu nghi phep
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	public static String employeeLeaveType(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		try {
			List<GenericValue> leaveType = delegator.findList("EmplLeaveType",
					null, UtilMisc.toSet("leaveTypeId", "description"), null,
					null, false);
			request.setAttribute("leaveType", leaveType);
			return "success";
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	/**
	 * ly do nghi phep
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	public static String employeeLeaveReason(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		try {
			List<GenericValue> leaveTypeReason = delegator.findList(
					"EmplLeaveReasonType", null,
					UtilMisc.toSet("emplLeaveReasonTypeId"), null, null, false);
			request.setAttribute("leaveTypeReason", leaveTypeReason);
			return "success";
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
	}

	/**
	 * gui don xin nghi phep
	 * 
	 * @param dctx
	 * @param context
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static String createEmplLeave(HttpServletRequest request,
			HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		String leaveTypeId = (String) request.getParameter("leaveTypeId");
		String fromDate = (String) request.getParameter("fromDate");
		String thruDate = (String) request.getParameter("thruDate");
		String emplLeaveReasonTypeId = (String) request
				.getParameter("emplLeaveReasonTypeId");
		String partyId = userLogin.getString("partyId");
		SimpleDateFormat formate = new SimpleDateFormat("dd-MM-yyyy");
		try {
			// GenericValue permissionUserLogin = delegator.findOne("UserLogin",
			// UtilMisc.toMap("userLoginId", "system"), false);
			Map<String, Object> ctxMap = FastMap.newInstance();
			// ctxMap.put("userLogin", permissionUserLogin);
			ctxMap.put("partyId", partyId);
			ctxMap.put("leaveTypeId", leaveTypeId);
			ctxMap.put("fromDate", new Timestamp(formate.parse(fromDate)
					.getTime()));
			ctxMap.put("thruDate", new Timestamp(formate.parse(thruDate)
					.getTime()));
			ctxMap.put("leaveStatus", "LEAVE_CREATED");

			if (emplLeaveReasonTypeId != null) {
				ctxMap.put("emplLeaveReasonTypeId", emplLeaveReasonTypeId);
			}
			delegator.create("EmplLeave", ctxMap);
		}
		catch (ParseException e) {
			// TODO Auto-generated catch block
			request.setAttribute("retMsg", "error");
			e.printStackTrace();
			return "error";
		} catch (Exception e) {
			if(e.getMessage().contains("Duplicate")){
				request.setAttribute("retMsg", "dupplicate");
			}
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
		request.setAttribute("retMsg", "success");
		return "success";
	}

	public static String getEmpLeaveStatus(HttpServletRequest request,
			HttpServletResponse respone) {
		GenericValue userLogin = (GenericValue) request.getSession()
				.getAttribute("userLogin");
		LocalDispatcher dispatcher = (LocalDispatcher) request
				.getAttribute("dispatcher");
		Map<String, Object> ctxMap = FastMap.newInstance();
		ctxMap.put("entityName", "EmplLeave");
		ctxMap.put("inputFields", UtilMisc.toMap("partyId",
				userLogin.get("partyId"), "noConditionFind", "Y"));
		ctxMap.put("orderBy", "fromDate DESC");
		Map<String, Object> result = null;
		try {
			result = dispatcher.runSync("performFind", ctxMap);
			request.setAttribute("emlLeaveStatus", result);
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "error";
		}
		return "success";
	}

	/* get specify fields in an generic object */
	public static Map<String, Object> getFieldsObject(GenericValue input,
			String[] fields) {
		Map<String, Object> res = FastMap.newInstance();
		String temp = "";
		for (int i = 0; i < fields.length; i++) {
			temp = fields[i];
			res.put(fields[i], input.get(temp));
		}
		return res;
	}

	/* return list object with specify fields of object */
	public static List<Map<String, Object>> getListObjectWithFields(
			List<GenericValue> input, String[] fields) {
		ArrayList<Map<String, Object>> res = new ArrayList<Map<String, Object>>();
		String temp = "";
		for (int x = 0; x < input.size(); x++) {
			Map<String, Object> obj = FastMap.newInstance();
			GenericValue objtemp = input.get(x);
			for (int i = 0; i < fields.length; i++) {
				temp = fields[i];
				obj.put(fields[i], objtemp.get(temp));
			}
			res.add(obj);
		}
		return res;
	}

	
	/*get Policy*/
	public static String getPolicyOfSalesMan(HttpServletRequest request,HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		List<Map<String,Object>> Policys = FastList.newInstance();
		SimpleDateFormat formate = new SimpleDateFormat("dd-MM-yyyy");
		try {
		List<GenericValue>	ListPolicy = delegator.findList("SalesPolicy", null, null,null, null, false);
			
			for(GenericValue pol : ListPolicy){
				Map<String,Object> polTmp = FastMap.newInstance();
				polTmp.put("salesPolicyId", pol.get("salesPolicyId"));
				List<GenericValue>	ListPolicyAction = delegator.findList("SalesPolicyAction", EntityCondition.makeCondition("salesPolicyId",pol.get("salesPolicyId")), null,null, null, false);
				polTmp.put("policyName", pol.get("policyName"));
				if(UtilValidate.isNotEmpty(pol.get("fromDate"))){
					polTmp.put("fromDate", formate.format((Timestamp) pol.getTimestamp("fromDate")));
				}
				if(UtilValidate.isNotEmpty(pol.get("thruDate"))){
					polTmp.put("thruDate", formate.format((Timestamp) pol.getTimestamp("thruDate")));	
				}
				polTmp.put("salesPolicyId", pol.get("salesPolicyId"));
				for(GenericValue polAct : ListPolicyAction){
						polTmp.put("amount", polAct.get("amount"));
					}
				Policys.add(polTmp);
				}
			request.setAttribute("Policys", Policys);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
	
	/*		getTotalOrderDetail 
	 * @param DispatchContext dpct,context
	 * 
	 * 
	 * */
	public static Map<String,Object> getTotalOrderDetail(DispatchContext dpct,Map<String, ?extends Object> context)
		{
		int countOrderNotPayment = 0;
		int grandTotal = 0 ;
		int remainingSubTotal = 0;
		String customerId = (String ) context.get("customerId");
		String checkDay = (String) context.get("month");
		EntityCondition checkDayCond =null;
		EntityCondition checkDayCon =null;
		Date date = new Date();
		TimeZone time = TimeZone.getDefault();
		Locale local = Locale.getDefault();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = (String) userLogin.get("partyId");
		Delegator delegator = dpct.getDelegator();
		EntityCondition cond1 = EntityCondition.makeCondition("partyId",EntityJoinOperator.EQUALS,customerId);
		EntityCondition cond2 = EntityCondition.makeCondition("statusId", EntityOperator.NOT_IN, UtilMisc.toList("ORDER_CANCELLED", "ORDER_REJECTED"));
		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		conditions.add(cond1);
		conditions.add(cond2);
		Set<String> fields = UtilMisc.toSet("orderId","statusId","partyId","remainingSubTotal","grandTotal");
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		Map<String,Object> result = FastMap.newInstance();
		Map<String,Object> res = FastMap.newInstance();
		Timestamp nowTime = new Timestamp(date.getTime()); 
		if(checkDay.equalsIgnoreCase("thisWeek")){
			Timestamp WeekEnd = UtilDateTime.getWeekEnd(nowTime);
			Timestamp WeekStart = UtilDateTime.getWeekStart(nowTime);
			checkDayCond = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,WeekStart);
			checkDayCon = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,WeekEnd);
		}else if(checkDay.equalsIgnoreCase("thisMonth")){
			Timestamp DayStartOfMonth = UtilDateTime.getMonthStart(nowTime, time, local);
			Timestamp DayEndOfMonth = UtilDateTime.getMonthEnd(nowTime, time, local);
			checkDayCond = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,DayStartOfMonth);
			checkDayCon = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,DayEndOfMonth);
		}else if(checkDay.equalsIgnoreCase("lastMonth")){
			Timestamp DayStartOfLastMonth = UtilDateTime.getMonthStart(nowTime, 0, -1);
			Timestamp DayEndOfLastMonth = UtilDateTime.getMonthEnd(DayStartOfLastMonth, time, local);
			checkDayCond = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,DayStartOfLastMonth);
			checkDayCon = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,DayEndOfLastMonth);
		}else checkDayCond = null;
		conditions.add(checkDayCond);
		conditions.add(checkDayCon);
		try { 
			List<GenericValue> totalOrder  = delegator.findList("OrderHeaderDetail", 
					EntityCondition.makeCondition(conditions,EntityJoinOperator.AND)
					, fields, null, options, false);
			for(GenericValue order : totalOrder){
				if(order.getString("statusId").equalsIgnoreCase("ORDER_CREATED")){
					countOrderNotPayment ++;
				}
				grandTotal += order.getBigDecimal("grandTotal").intValue();
				remainingSubTotal +=  order.getBigDecimal("remainingSubTotal").intValue();
			}
			if(UtilValidate.isNotEmpty(totalOrder)){
				result.put("totalOrder", totalOrder.size());
				result.put("totalOrderNotPayment", countOrderNotPayment);
				result.put("totalOrderPayment", totalOrder.size() - countOrderNotPayment);
				result.put("grandTotal", grandTotal);
				result.put("remainingSubTotal", remainingSubTotal);
				result.put("TotalAmountPaid", grandTotal - remainingSubTotal);
			}
			res.put("res", result);
		} catch (Exception e) {
			// TODO: handle exception
			Debug.logError("Could not get list Order Detail" +e.getMessage() , module);
			e.printStackTrace();
		}
		
		
		
		return res;
	}
	
	/**
	 * 
	 * get Product Order  Detail of Customer 
	 * @param DispatchContext dpct,context
	 * 
	 * **/
	public static Map<String,Object> getOrderProductDetailOfCustomer(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		String partyId = (String) context.get("partyId");
		EntityCondition statusCond = EntityCondition.makeCondition("statusId",EntityJoinOperator.NOT_IN,UtilMisc.toList("ORDER_CANCELLED", "ORDER_REJECTED"));
		EntityCondition partyCond = EntityCondition.makeCondition("partyId",EntityJoinOperator.EQUALS,partyId);
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		Map<String,Object> res = FastMap.newInstance();
		Map<String,Map<String,Object>> inFo = FastMap.newInstance();
		String checkDay = (String) context.get("month");
		EntityCondition checkDayCond =null;
		EntityCondition checkDayCon =null;
		List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		Date date = new Date();
		Timestamp nowTime = new Timestamp(date.getTime()); 
		TimeZone time = TimeZone.getDefault();
		Locale local = Locale.getDefault();
		Set<String> fields = UtilMisc.toSet("orderId","orderDate","partyId","quantity","productId","productName");
		try {
			if(checkDay.equalsIgnoreCase("thisWeek")){
				Timestamp WeekEnd = UtilDateTime.getWeekEnd(nowTime);
				Timestamp WeekStart = UtilDateTime.getWeekStart(nowTime);
				checkDayCond = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,WeekStart);
				checkDayCon = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,WeekEnd);
			}else if(checkDay.equalsIgnoreCase("thisMonth")){
				Timestamp DayStartOfMonth = UtilDateTime.getMonthStart(nowTime, time, local);
				Timestamp DayEndOfMonth = UtilDateTime.getMonthEnd(nowTime, time, local);
				checkDayCond = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,DayStartOfMonth);
				checkDayCon = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,DayEndOfMonth);
			}else if(checkDay.equalsIgnoreCase("lastMonth")){
				Timestamp DayStartOfLastMonth = UtilDateTime.getMonthStart(nowTime, 0, -1);
				Timestamp DayEndOfLastMonth = UtilDateTime.getMonthEnd(DayStartOfLastMonth, time, local);
				checkDayCond = EntityCondition.makeCondition("orderDate",EntityJoinOperator.GREATER_THAN_EQUAL_TO,DayStartOfLastMonth);
				checkDayCon = EntityCondition.makeCondition("orderDate",EntityJoinOperator.LESS_THAN_EQUAL_TO,DayEndOfLastMonth);
			}else checkDayCond = null;
			conditions.add(checkDayCond);
			conditions.add(checkDayCon);
			conditions.add(statusCond);
			conditions.add(partyCond);
			List<GenericValue> listProductDetail = delegator.findList("OrderProductDetail", EntityCondition.makeCondition(conditions,EntityJoinOperator.AND), fields, null, options, false);
			
			if(UtilValidate.isNotEmpty(listProductDetail)){
			for(GenericValue item : listProductDetail){
				Map<String,Object> tmp = FastMap.newInstance();
				if(UtilValidate.isEmpty(item.getString("productId"))||UtilValidate.isEmpty(item.getString("productName"))||UtilValidate.isEmpty(item.getString("quantity")))
				{
					continue;
				}else {
					if(inFo.containsKey(item.get("productId")))
						{
						tmp = inFo.get(item.get("productId"));
						int quantity = 0;
						quantity = Integer.valueOf((tmp.get(item.getString("productName"))).toString());
						tmp.put(item.getString("productName"),quantity + item.getBigDecimal("quantity").intValue());
						inFo.put(item.getString("productId"), tmp);
					}else {
						tmp.put(item.getString("productName"), item.getBigDecimal("quantity").intValue());
						inFo.put(item.getString("productId"),tmp);
						}
					}
				}
			}
			res.put("res", inFo);
		} catch (Exception e) {
			Debug.logError("Could not get list product Detail" +e.getMessage() , module);
			e.printStackTrace();
		}
		return res;
	}
	
	/* func update Location for Customer 
	 * @param DispatchContext dptc,context
	 * 
	 * */
	public static Map<String,Object> updateLocationCustomer(DispatchContext dpct,Map<String,? extends Object> context){
			Delegator delegator = dpct.getDelegator();
			String customerId = (String) context.get("customerId");
			
			Double latitude = Double.parseDouble((String) context.get("latitude"));
			Double longitude  =  Double.parseDouble((String) context.get("longitude"));
			
			String status = "error";
			Map<String,Object> Notifcation = FastMap.newInstance();
			Map<String,Object> object = FastMap.newInstance();
			Set<String> field =  UtilMisc.toSet("geoPointId");
		try {
			List<GenericValue> listPtyGeoView = delegator.findList("PartyGroupGeoView", EntityCondition.makeCondition(UtilMisc.toMap("partyIdTo",customerId)), field, null, null, false);
			if(UtilValidate.isNotEmpty(listPtyGeoView)){
					String geoPointId = listPtyGeoView.get(0).getString("geoPointId");
					GenericValue geo = delegator.findOne("GeoPoint", UtilMisc.toMap("geoPointId",geoPointId), false);
					geo.set("latitude", latitude);
					geo.set("longitude", longitude);
					geo.store();
					status = "success";
			
			}
			
			
		} catch (Exception e) {
			// TODO: handle exception
			Debug.logError("Could not get list party Geo Points" +e.getMessage() , module);
			e.printStackTrace();
		}	
		
		Notifcation.put("status", object);
		return Notifcation;
	}
	/*
	 * updateCustomer
	 * 
	 * */
	public static Map<String,Object> updateCustomer(DispatchContext dpct,Map<String,?extends Object> context){
			Delegator delegator = dpct.getDelegator();
			GenericValue userLogin = (GenericValue) context.get("userLogin");
			String createById = userLogin.getString("userLogin");
 			String  groupName = (String) context.get("groupName");
			String partyId = (String) context.get("partyId");
			String statusId = "UPDATED";
		
		try {
			if(UtilValidate.isNotEmpty(partyId)){
				GenericValue customer = delegator.findOne("PartySalesMan", UtilMisc.toMap("customerId",partyId), false);
				if(UtilValidate.isNotEmpty(customer)){
					customer.set("groupName", groupName);
					customer.set("statusId", statusId);
					customer.store();
				}else {
					
					String customerId = delegator.getNextSeqId("PartySalesMan");
					GenericValue cusTmp = delegator.makeValue("PartySalesMan");
					cusTmp.set("createdBy", createById);
					cusTmp.set("customerId", customerId);
					cusTmp.set("statusId", statusId);
					cusTmp.set("partyId", partyId);
					cusTmp.set("groupName", groupName);
					cusTmp.create();
				}	
			}
		} catch (Exception e) {
			// TODO: handle exception
			Debug.logError("Can't update Customer Info " + e.getMessage(), module);
			e.printStackTrace();
		}
		Map<String,Object> contact = FastMap.newInstance();
		contact.put("partyId", partyId);
		contact.put("groupName", groupName);
		contact.put("statusId", statusId);
		Map<String,Object> Map = FastMap.newInstance();
		Map.put("contact", contact);
		return Map;
	}
	/*
	 * createCustomerSalesMan
	 * @param DispathContext dpct,context
	 * 
	 * */
	public static Map<String,Object> createCustomerSalesMan(DispatchContext dpct,Map<String,?extends Object> context){
		
		Delegator delegator = dpct.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String createById = (String) userLogin.getString("partyId");
		String groupName = (String) context.get("groupName");
		String mobile = (String) context.get("mobile");
		String sex = (String) context.get("sex");
		Timestamp birthDay = (Timestamp) context.get("birthDay");
 		String roadId = (String )context.get("roadId");
		Double longitude = Double.parseDouble((String) context.get("longitude"));
		Double latitude = Double.parseDouble((String) context.get("latitude"));
		String city  = (String ) context.get("city");
		String address = (String) context.get("address1");
		Timestamp startDate =  (Timestamp) context.get("startDate");
		Timestamp fromDate = UtilDateTime.nowTimestamp();
		String customerId = delegator.getNextSeqId("PartySalesMan");
		try {
			GenericValue initCustomer = delegator.makeValue("PartySalesMan");
			String statusId = "CREATED";
			initCustomer.set("statusId", statusId);
			initCustomer.set("customerId", customerId);
			initCustomer.set("groupName", groupName);
			initCustomer.set("mobile", mobile);
			initCustomer.set("birthDay", birthDay);
			initCustomer.set("sex", sex);
			initCustomer.set("createdBy", createById);
			initCustomer.set("roadId", roadId);
			initCustomer.set("longitude", longitude);
			initCustomer.set("latitude", latitude);
			initCustomer.set("city", city);
			initCustomer.set("address", address);
			initCustomer.set("startDate", startDate);
			initCustomer.set("fromDate", fromDate);
			initCustomer.create();
		}catch(GenericEntityException e){
			e.printStackTrace();
		} catch (Exception e) {
			// TODO: handle exception
			Debug.logError("Can't create or update for this Customer" +e.getMessage(),module);
			e.printStackTrace();
		}
		Map<String,Object> put = FastMap.newInstance();
		put.put("customerId", customerId);
		put.put("groupName",groupName);
		put.put("createdBy",createById);
		put.put("roadId",roadId);
		put.put("startDate",startDate);
		put.put("fromDate",fromDate);
		Map<String,Object> result = FastMap.newInstance();
		result.put("result", put);
		return result;
		
	}
	/*
	 * @param DispathContext dpct,context
	 * submitFbCustomer
	 * 
	 * */
	public static Map<String,Object> submitFbCustomer(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		String partyId = (String) context.get("customerName");
		String comment = (String) context.get("comment");
		Map<String,Object> status = FastMap.newInstance();
		Timestamp nowtimestamp = UtilDateTime.nowTimestamp();
		try {
			String communicationEventId = delegator.getNextSeqId("CommunicationEvent");
			GenericValue com  = delegator.makeValue("CommunicationEvent");
			com.set("communicationEventId", communicationEventId);
			com.set("partyIdFrom", partyId);
			com.set("content",comment);
			com.set("entryDate", nowtimestamp);
			com.create();
			Map<String,Object> temp = FastMap.newInstance();
			temp.put("partyId", partyId);
			status.put("status", temp);
		} catch (Exception e) {
			Debug.logError("can't not create Communication Event for Customer" + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		
		return status;
	}
	/*
	 * @param DispatchContext dpct,context
	 * submitInfoOpponent
	 * 
	 * */
	public static Map<String,Object> submitInfoOpponent(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		String opponentEventId = (String) context.get("opponentEventId");
		String promos = (String) context.get("promos");
		String otherInfo = (String) context.get("otherInfo");
		String linkImage = (String) context.get("linkImage");
		Map<String,Object> status= FastMap.newInstance(); 
		try { 
			GenericValue opp = delegator.makeValue("InformationOpponentEvent");
			String opponentInfoId = delegator.getNextSeqId("InformationOpponentEvent");
			opp.set("opponentInfoId", opponentInfoId);
			opp.set("opponentEventId", opponentEventId);
			opp.set("opponentPromos", promos);
			opp.set("otherInfo", otherInfo);
			opp.set("opponentImage", linkImage);
			opp.create();
			Map<String,Object> result = FastMap.newInstance();
			result.put("opponentEventId", opponentEventId);
			result.put("promos", promos);
			status.put("status", result);
		} catch (Exception e) {
			Debug.logError("can't not create Infomartion of Opponent in DB" + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		};
		
		return status;
	};
	public static String getListOpponent(HttpServletRequest request,HttpServletResponse response){
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		List<GenericValue> listOpp = null;
		Map<String,Object> opp = FastMap.newInstance();
		List<Map<String,Object>> resultList = FastList.newInstance();
		Set<String> fields = UtilMisc.toSet("opponentEventId","opponentName");
		try {
			listOpp = delegator.findList("Opponent", null, fields, null , null, false);
			if(!listOpp.isEmpty()){
				request.setAttribute("listOpponent", listOpp);
			}
		} catch (Exception e) {
			Debug.logError("can't not get  Infomartion of Opponent in DB" + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		return "success";
	}
	/*	getListPromotionsEvent
	 * @param  DispatchContext dpct,context
	 * 
	 * 
	 * */
	public static Map<String,Object> getListPromotionsEvent(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		String promoType = "PROMOTION";
		String partyId = (String) context.get("partyId");
		Set<String> fields = UtilMisc.toSet("productPromoId","ruleName","roleTypeId","fromDate","thruDate","ruleName","promoName","showToCustomer");
		Set<String> fieldsRole = UtilMisc.toSet("partyId","roleTypeId");
		List<GenericValue> listPromoEvent = FastList.newInstance();
		List<GenericValue> listRole = FastList.newInstance();
		List<Map<String,Object>> listResult = FastList.newInstance();
		Map<String,Object> result = FastMap.newInstance();
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		SimpleDateFormat formate = new SimpleDateFormat("dd-MM-yyyy");
		try {
				listRole = delegator.findList("PartyRole", EntityCondition.makeCondition("partyId",EntityJoinOperator.EQUALS,partyId),fieldsRole , null, null, false);
				for(GenericValue role : listRole){
					if(role.getString("roleTypeId").equalsIgnoreCase("DELYS_CUSTOMER_GT")){
						EntityCondition cond1 =	EntityCondition.makeCondition("productPromoTypeId",EntityJoinOperator.EQUALS,promoType);
						EntityCondition cond2 =	EntityCondition.makeCondition("roleTypeId",EntityJoinOperator.EQUALS,"DELYS_CUSTOMER_GT");
						EntityCondition cond3 =	EntityCondition.makeCondition("showToCustomer",EntityJoinOperator.EQUALS,"Y");
						EntityCondition cond4 =EntityCondition.makeCondition("productPromoStatusId",EntityJoinOperator.EQUALS,"PROMO_ACCEPTED");
						List<EntityCondition> list = FastList.newInstance();
						list.add(cond1);
						list.add(cond2);
						list.add(cond3);
						list.add(cond4);
						listPromoEvent  = delegator.findList("PromosEventRole",EntityCondition.makeCondition(list,EntityJoinOperator.AND) , fields, null, options, false);	
					}
				};
			if(UtilValidate.isNotEmpty(listPromoEvent)){
				for(GenericValue promoEvent : listPromoEvent){
					Map<String,Object> tmp = FastMap.newInstance();
					if(UtilValidate.isNotEmpty(promoEvent.getTimestamp("fromDate"))){
						tmp.put("fromDate", formate.format((Timestamp)promoEvent.getTimestamp("fromDate")));
					}
					if(UtilValidate.isNotEmpty(promoEvent.getTimestamp("thruDate"))){
						tmp.put("thruDate", formate.format((Timestamp)promoEvent.getTimestamp("thruDate")));
					}
					tmp.put("promoName", promoEvent.getString("promoName"));
					tmp.put("ruleName", promoEvent.getString("ruleName"));
					listResult.add(tmp);
				}
				result.put("listPromoEvent", listResult);
			};	
		} catch (Exception e) {
			Debug.logError("can't not get  list Promotion Event in DB" + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		return result;
	}
	/*
	 * @param DispatchContext dpct,context
	 * register accumulate for Store
	 * 
	 * 
	 * */
	public static Map<String,Object> accumulateRegister(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = (Delegator) dpct.getDelegator();
		String storeId = (String) context.get("customerId");
		String promoId = (String) context.get("productPromoId");
		String revenue = (String) context.get("promoSalesTargets");
		String productPromoRuleId = (String) context.get("productPromoRuleId");
		Timestamp createDate = (Timestamp) context.get("createdDate");
		Map<String,Object> result  = FastMap.newInstance();
		String registerStatus = "PROMO_CREATED" ;
		Timestamp nowtimestamp = UtilDateTime.nowTimestamp();
		String createdBy = ((GenericValue) context.get("userLogin")).getString("partyId");
		Map<String,Object> accumulate = FastMap.newInstance();
		try {
			List<GenericValue> listAcc = delegator.findList("ProductPromoRegister", null, null, null, null, false);
			if(UtilValidate.isNotEmpty(listAcc)){
				boolean checkIn = false;
				for(GenericValue acc : listAcc){
						if(acc.getString("partyId").equals(storeId) && acc.getString("productPromoId").equals(promoId) && acc.getString("productPromoRuleId").equals(productPromoRuleId)){
							checkIn = true;
							accumulate.put("duplicate", "duplicate");
							result.put("accumulate", accumulate);
							return result;
						}
					}
				if(!checkIn){
					String productPromoRegisterId = delegator.getNextSeqId("ProductPromoRegister");
					GenericValue acc  = delegator.makeValue("ProductPromoRegister");
					acc.set("partyId", storeId);
					acc.set("productPromoId", promoId);
					acc.set("productPromoRuleId", productPromoRuleId);
					acc.set("registerStatus", registerStatus);
					if(createDate == null){
						acc.set("createdDate",nowtimestamp);
					}else acc.set("createdDate",createDate);
					acc.set("createdBy", createdBy);
					acc.set("productPromoRegisterId", productPromoRegisterId);
					acc.create();
					accumulate.put("storeRegisterId", storeId);
					accumulate.put("productPromoId", promoId);
					result.put("accumulate",accumulate);
				}
			}else {
				String productPromoRegisterId = delegator.getNextSeqId("ProductPromoRegister");
				GenericValue acc  = delegator.makeValue("ProductPromoRegister");
				acc.set("partyId", storeId);
				acc.set("productPromoId", promoId);
				acc.set("productPromoRuleId", productPromoRuleId);
				acc.set("registerStatus", registerStatus);
				if(createDate == null){
					acc.set("createdDate",nowtimestamp);
				}else acc.set("createdDate",createDate);
				acc.set("createdBy", createdBy);
				acc.set("productPromoRegisterId", productPromoRegisterId);
				acc.create();
				accumulate.put("storeRegisterId", storeId);
				accumulate.put("productPromoId", promoId);
				result.put("accumulate",accumulate);
			}
		} catch (Exception e) {
			Debug.logError("Can't register accumulate " + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		return result;
	}
	
	
	/* get Accumulate Store */
	public static Map<String,Object> getAccumulateStore(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = (Delegator) dpct.getDelegator();
		List<GenericValue> listAcc = FastList.newInstance();
		List<Map<String,Object>> listRS = FastList.newInstance();
		String partyId = (String) context.get("partyId");
//		Set<String> fields = UtilMisc.toSet("promoName","fromDate","thruDate","promoSalesTargets","productPromoId","productPromoRuleId");
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		SimpleDateFormat formate = new SimpleDateFormat("dd-MM-yyyy");
		try {
			if(partyId != null) {
				List<GenericValue> listRole = delegator.findList("PartyRole", EntityCondition.makeCondition("partyId",EntityJoinOperator.EQUALS,partyId), null,null, null, false);
				for(GenericValue role : listRole){
					if(role.getString("roleTypeId").equalsIgnoreCase("DELYS_CUSTOMER_GT")){
						listAcc = delegator.findList("ProductAccumulateDetail", null, null, null,options, false);
					};
				}
			}else {
				listAcc = delegator.findList("ProductAccumulateDetail", null, null, null,options, false);
			}
			if(UtilValidate.isNotEmpty(listAcc)){
				for(GenericValue acc : listAcc){
					Map<String,Object> mapctx = FastMap.newInstance();
					mapctx.put("promoName", acc.getString("promoName"));
					mapctx.put("productPromoId",acc.getString("productPromoId"));
					mapctx.put("productPromoRuleId", acc.getString("productPromoRuleId"));
					mapctx.put("quantity", acc.getString("quantity"));
					mapctx.put("productName", acc.getString("productName"));
					if(UtilValidate.isNotEmpty(acc.getTimestamp("fromDate"))){
						mapctx.put("fromDate", formate.format((Timestamp)acc.getTimestamp("fromDate")));
					}
					if(UtilValidate.isNotEmpty(acc.getTimestamp("thruDate"))){
						mapctx.put("thruDate", formate.format((Timestamp)acc.getTimestamp("thruDate")));
					}
//					UtilDateTime.getInterval(acc.getTimestamp("fromDate"), acc.getTimestamp("thruDate"));
					int Day =  UtilDateTime.getIntervalInDays(acc.getTimestamp("fromDate"), acc.getTimestamp("thruDate"));
					int month = Day / 30 ;
					mapctx.put("DayInterval", Day);
					mapctx.put("monthInterval", month);
					mapctx.put("promoSalesTargets", acc.getBigDecimal("promoSalesTargets").intValue());
					listRS.add(mapctx);
				}
			}
			
		} catch (Exception e) {
			Debug.logError("Can't register accumulate " + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		Map<String,Object> result = FastMap.newInstance();
		if(UtilValidate.isNotEmpty(listRS)){
			result.put("listAccumulate", listRS);
		}
		return result;
	}
	/*
	 * getExhibitedDetail
	 * @param DispathcContext dpct,context
	 * 
	 * */
	public static Map<String,Object> getExhibitedDetail(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		String partyId = (String) context.get("partyId");
		Set<String> fieldsRole = UtilMisc.toSet("partyId","roleTypeId");
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		List<GenericValue> listExhibited = FastList.newInstance();
		
		try {
		if(partyId != null){
			List<GenericValue> listRole = delegator.findList("PartyRole", EntityCondition.makeCondition(UtilMisc.toMap("partyId",partyId)), fieldsRole, null, null, false);	
			if(UtilValidate.isNotEmpty(listRole)){
				for(GenericValue role : listRole){
					if(role.getString("roleTypeId").equalsIgnoreCase("DELYS_CUSTOMER_GT")){
						 listExhibited = delegator.findList("ProductExhibitionDetail", null, null, null, options, false);
					}
				}
			}
		}else {
			 listExhibited = delegator.findList("ProductExhibitionDetail", null, null, null, options, false);
		}
		} catch (Exception e) {
			Debug.logError("Can't get list Exhibited " + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		Map<String,Object> result = FastMap.newInstance();
		result.put("listExhibited", listExhibited);
		return result;
	}
	/*
	 * exhibited Register
	 * @param DispatchContext dpct,context
	 * */
	public static Map<String,Object> exhibitedRegister(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = (Delegator) dpct.getDelegator();
		String createdBy = ((GenericValue) context.get("userLogin")).getString("partyId");
		String customerId = (String) context.get("customerId");
		String productPromoId = (String) context.get("productPromoId");
		String ruleId = (String) context.get("ruleId");
		String registerStatus = "PROMO_CREATED";
		Timestamp createdDate = (Timestamp) context.get("createdDate");
		Timestamp nowtimestamp = UtilDateTime.nowTimestamp();
		Map<String,Object> result  = FastMap.newInstance();
		Map<String,Object> tmp = FastMap.newInstance();
		try {
			List<GenericValue> listRegistered = delegator.findList("ProductPromoRegister", null, null, null, null, false);
			if(UtilValidate.isNotEmpty(listRegistered)){
				boolean checkIn = false;
				for(GenericValue regis : listRegistered){
						if(regis.getString("productPromoId").equals(productPromoId) && regis.getString("productPromoRuleId").equals(ruleId) && regis.getString("partyId").equals(customerId)){
							tmp.put("duplicate", "duplicate");
							result.put("result", tmp);
							checkIn = true;
							return result;
						}else {
							continue;
						}
					}
				if(!checkIn){
					GenericValue ex = delegator.makeValue("ProductPromoRegister");
					String productPromoRegisterId = delegator.getNextSeqId("ProductPromoRegister");
					ex.set("productPromoRegisterId", productPromoRegisterId);
					ex.set("createdBy", createdBy);
					ex.set("partyId", customerId);
					ex.set("productPromoId", productPromoId);
					ex.set("productPromoRuleId", ruleId);
					ex.set("registerStatus", registerStatus);
					if(createdDate == null){
						ex.set("createdDate", nowtimestamp);
					}else ex.set("createdDate", createdDate); 
					ex.create();
					tmp.put("productPromoId", productPromoId);
					tmp.put("customerId", customerId);
					tmp.put("registerStatus", registerStatus);
				}
			}else{
				GenericValue ex = delegator.makeValue("ProductPromoRegister");
				String productPromoRegisterId = delegator.getNextSeqId("ProductPromoRegister");
				ex.set("productPromoRegisterId", productPromoRegisterId);
				ex.set("createdBy", createdBy);
				ex.set("partyId", customerId);
				ex.set("productPromoId", productPromoId);
				ex.set("productPromoRuleId", ruleId);
				ex.set("registerStatus", registerStatus);
				if(createdDate == null){
					ex.set("createdDate", nowtimestamp);
				}else ex.set("createdDate", createdDate); 
				ex.create();
				tmp.put("productPromoId", productPromoId);
				tmp.put("customerId", customerId);
				tmp.put("registerStatus", registerStatus);
			}
		} catch (Exception e) {
			Debug.logError("Can't create register for exhibited " + e.getMessage(), module);
			e.printStackTrace();
		}
		result.put("result", tmp);
		return result;
	}
	public static Map<String,Object> getExhibitedForMark(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		String customerId = (String) context.get("customerId");
		Map<String,Object> result = FastMap.newInstance();
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		List<GenericValue> listExhibited = FastList.newInstance();
		try {
			if(customerId.equals("getData")){
				listExhibited = delegator.findList("ExhibitedsOfStores",null,null,null,options,false);
			}else {
				 listExhibited = delegator.findList("ExhibitedsOfStores",EntityCondition.makeCondition("partyId",customerId),null,null,options,false);
			}
			
			result.put("result", listExhibited);
		}catch(GenericEntityException e){
			e.printStackTrace();
		} catch (Exception e) {
			Debug.logError("Can't create register for exhibited " + e.getMessage(), module);
			e.printStackTrace();
			// TODO: handle exception
		}
		return result;
	}
	public static Map<String,Object> createMarkResult(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = (Delegator) dpct.getDelegator();
		String productPromoRegisterId = (String) context.get("promoRegisterId");
		Timestamp createdDate = (Timestamp) context.get("createdDate");
		String createdBy = (String) context.get("createdBy");
		String isSequency = (String) context.get("isSequency");
		String result = (String) context.get("result");
		Map<String,Object> res = FastMap.newInstance();
		Map<String,Object> tmp = FastMap.newInstance();
		try {
			if(createdDate == null){
				createdDate = UtilDateTime.nowTimestamp();
			}
			GenericValue mark = delegator.makeValue("ProductPromoMarking");
			mark.set("productPromoRegisterId", productPromoRegisterId);
			mark.set("createdDate", createdDate);
			mark.set("createdBy", createdBy);
			mark.set("isSequency", isSequency);
			mark.set("result", result);
			mark.create();
			tmp.put("productPromoRegisterId", productPromoRegisterId);
		}catch(GenericEntityException e)
		{
			e.printStackTrace();
		} catch (Exception e) {
			Debug.logError("Can't create marking result " + e.getMessage(), module);
			e.printStackTrace();
			if(e.getMessage().contains("Duplicate")){
				tmp.put("Duplicate", productPromoRegisterId);
				res.put("res", tmp);
				return ServiceUtil.returnError("duplicate");
			}
			
			// TODO: handle exception
		}
		res.put("res", tmp);
		return res;
	}
	/*
	 * method get Data Detail info of SalesMan
	 * @param DispatchContext,Map<?,?>
	 * 
	 * */
	public static Map<String,Object> getInfoSalesMan(DispatchContext dpct,Map<String,?extends Object> context){
		Delegator delegator = dpct.getDelegator();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = userLogin.getString("partyId");
		Map<String,Object> data  = FastMap.newInstance();
		List<GenericValue> listData = FastList.newInstance();
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		Timestamp nowtimestamp = UtilDateTime.nowTimestamp();
		try {
			EntityCondition cond1 = EntityCondition.makeCondition(UtilMisc.toMap("partyId", partyId));
			EntityCondition cond2 = EntityCondition.makeCondition(EntityUtil.getFilterByDateExpr(nowtimestamp));
			List<EntityCondition> listCond = FastList.newInstance();
			listCond.add(cond1);
			listCond.add(cond2);
			listData = delegator.findList("DetailInfoSalesMan",EntityCondition.makeCondition(listCond,EntityJoinOperator.AND), null, UtilMisc.toList("-fromDate"), options, false);
			if(UtilValidate.isNotEmpty(listData))
			{//
				List<GenericValue> result = FastList.newInstance();
				result.add(listData.get(0));
				data.put("listInfo", result);
			}else {
				return ServiceUtil.returnError("empty");
			}
		}catch (GenericEntityException e) {
			e.printStackTrace();
		}catch (Exception e) {
			Debug.log("can't get Data from entity " + e.getMessage(),module);
			e.printStackTrace();
		}
		return data;
	}
	
	
	/*@param DispatchContext dpct,Map<?,?>
	 * updateSalesMan
	 * */
	public static Map<String,Object> updateSalesMan(DispatchContext dpct,Map<String,?extends Object> context){
		LocalDispatcher dispatcher = dpct.getDispatcher();
		String firstName = (String) context.get("firstName");
		String middleName = (String) context.get("middleName");
		String lastName = (String) context.get("lastName");
		String address1_PermanentResidence = (String) context.get("address1");
		String permanentResidence_stateProvinceGeoId = (String) context.get("city");
		String permanentResidenceContactmechId = (String) context.get("contactMechId");
		String partyId = ((GenericValue) context.get("userLogin")).getString("partyId");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		try{
			if(UtilValidate.isNotEmpty(firstName) && (UtilValidate.isNotEmpty(lastName))){
				 dispatcher.runSync("updatePersonOlbius", UtilMisc.toMap("userLogin",userLogin,"firstName", firstName,"middleName",middleName,"lastName",lastName));
			}
			if(UtilValidate.isNotEmpty(partyId) && UtilValidate.isNotEmpty(permanentResidenceContactmechId)){
				 dispatcher.runSync("updatePermanentResidence", UtilMisc.toMap("userLogin",userLogin,"partyId",partyId,"permanentResidenceContactmechId", permanentResidenceContactmechId,"permanentResidence_stateProvinceGeoId",permanentResidence_stateProvinceGeoId,"address1_PermanentResidence",address1_PermanentResidence));
			}
		}catch(GenericServiceException e){
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
			Debug.logError("Can't update Information SalesMan"+e.getMessage(), module);
		}
		return ServiceUtil.returnSuccess();
	}
	/*
	 * update Password for SalesMan
	 * 
	 * */
	public static Map<String,Object> updatePasswordSalesMan(DispatchContext dpct,Map<String,?extends Object> context){
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		LocalDispatcher dispatcher = dpct.getDispatcher();
		String currentPassword = (String) context.get("CurrentPassword");
		String newPassword = (String) context.get("NewPassword");
		String newPasswordVerify = (String) context.get("PasswordVerify");
		try {
			Map<String,Object> result = FastMap.newInstance();	
			result = dispatcher.runSync("updatePassword", UtilMisc.toMap("userLogin", userLogin,"userLoginId",userLogin.getString("userLoginId"),"currentPassword",currentPassword,"newPassword",newPassword,"newPasswordVerify",newPasswordVerify));
			if(ServiceUtil.isError(result)){
				return ServiceUtil.returnError("errorChangePassword");
			} 
		}catch(GenericServiceException e){
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
			Debug.logError("Can't update password SalesMan"+e.getMessage(), module);
			// TODO: handle exception
		}
		return ServiceUtil.returnSuccess();
	}
	
	/*
	 * getListMarkedBySalesMan
	 * @param DispatchContext,Map<?,?>
	 * 
	 * */
	public static Map<String,Object> getListMarkedBySalesMan(DispatchContext dpct,Map<?,?> context){
			Delegator delegator = dpct.getDelegator();
			List<GenericValue> listMarked  = FastList.newInstance();
			EntityFindOptions options = new EntityFindOptions();
			options.setDistinct(true);
			List<String> orderBy = UtilMisc.toList("createdDate DESC");
			Map<String,Object> map = FastMap.newInstance();
			Set<String> fieldsToSelect = UtilMisc.toSet("promoName","productPromoRuleId","createdBy","isSequency","result","productPromoRegisterId","createdDate","groupName");
			try {
					listMarked = delegator.findList("ResultSalesManMarkingView", null, fieldsToSelect, orderBy, options, false);
				if(UtilValidate.isNotEmpty(listMarked)){
					map.put("list", listMarked);
				}
			}catch(GenericEntityException e){
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		return map;
	}
	
	/*
	 * createRoute
	 *  @param DispatchContext,Map<?,?> 
	 * 
	 * 
	 * */
	@SuppressWarnings("unchecked")
	public static Map<String,Object> createRoute(DispatchContext dpct,Map<?,?> context){
		Delegator delegator = (Delegator) dpct.getDelegator();
		String routeName  = (String) context.get("routeName");
		String infoRoute = (String) context.get("infoRoute");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String[] day = null;
		String tmp = "";
		if(UtilValidate.isNotEmpty(infoRoute)){
			day = infoRoute.split(",");
		}
		try {
			//create Party Group
			Map<String,Object> map = FastMap.newInstance();
			map.put("userLogin", userLogin);
			map.put("groupName",routeName);
			String partyId = "";
			try {
				 partyId = (String) dpct.getDispatcher().runSync("createPartyGroup",map).get("partyId");	
			} catch (Exception e) {
				e.printStackTrace();
				return ServiceUtil.returnError(e.getMessage());
				// TODO: handle exception
			}
			if(UtilValidate.isNotEmpty(partyId)){
				try {
					Map<String,Object> mapRole = FastMap.newInstance();
					mapRole.put("userLogin",userLogin);
					mapRole.put("partyId", partyId);
					mapRole.put("roleTypeId", "DELYS_ROUTE");
					dpct.getDispatcher().runSync("createPartyRole", mapRole);
				} catch (Exception e) {
					e.printStackTrace();
					return ServiceUtil.returnError(e.getMessage());
					// TODO: handle exception
				}
			}
			if(UtilValidate.isNotEmpty(day)){
				String routeId = partyId;
				GenericValue schedule = delegator.makeValue("RouteSchedule");
				
				for(int i = 0 ;i<day.length; i++){
					if(day[i].equals("T2")){
						tmp = "MONDAY";
					}else if(day[i].equals("T3")){
						tmp = "TUESDAY";
					}else if(day[i].equals("T4")){
						tmp = "WEDNESDAY";
					}
					else if(day[i].equals("T5")){
						tmp = "THURSDAY";
					}
					else if(day[i].equals("T6")){
						tmp = "FRIDAY";
					}
					else if(day[i].equals("T7")){
						tmp = "SATURDAY";
					}else continue;
					schedule.set("routeId", routeId);
					schedule.set("scheduleRoute",tmp);
					schedule.create();
				}
				GenericValue route = delegator.makeValue("RouteInformation");
				route.set("routeId", routeId);
				route.set("description", routeName);
				route.create();
			}
		} catch(GenericEntityException e){
			e.printStackTrace();
			return ServiceUtil.returnError("Failed when create route");
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError("Failed when create route");
		}
		return ServiceUtil.returnSuccess();
	}
	
	/*
	 * get List Route and list SalesMan
	 * @param DispatchContext dpct,Map<?,?>
	 * */
	public static Map<String,Object> getListRouteAndSalesMan(DispatchContext dpct,Map<?,?> context){
		Delegator delegator = dpct.getDelegator();
		List<GenericValue> listSalesMan  = FastList.newInstance();
		List<GenericValue> listCustomers  = FastList.newInstance();
		List<GenericValue> listDistributionCustomers  = FastList.newInstance();
		List<GenericValue> listRoute = FastList.newInstance();
		List<GenericValue> listDistribution = FastList.newInstance();
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		Map<String,Object> obj  = FastMap.newInstance();
		Set<String> fieldsSelect = UtilMisc.toSet("routeId","description");
		try {
			listSalesMan  = delegator.findList("PartyPersonPartyRole", EntityCondition.makeCondition(UtilMisc.toMap("roleTypeId","DELYS_SALESMAN_GT")), null, null, options, false);
			listCustomers  = delegator.findList("PartyRoleAndPartyDetail", EntityCondition.makeCondition(UtilMisc.toMap("roleTypeId","DELYS_CUSTOMER_GT")), null, null, options, false);
			listRoute = delegator.findList("RouteInformation", null, fieldsSelect, null, options, false);
//			listDistribution = delegator.findList("DistributionRoutesSalesMan", null, null, null, null, false);
//			listDistributionCustomers = delegator.findList("DistributionRoutesStore", null, null, null, null, false);
			EntityCondition cond1 = EntityCondition.makeCondition(UtilMisc.toMap("roleTypeIdTo","DELYS_CUSTOMER_GT","roleTypeIdFrom","DELYS_ROUTE"));
			EntityCondition cond2 = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE1");
			EntityCondition cond3 = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE2");
			EntityCondition cond4 = EntityCondition.makeCondition("thruDate",EntityJoinOperator.EQUALS,null);
			List<EntityCondition> list = FastList.newInstance();
			list.add(cond1);
			list.add(cond2);
			list.add(cond3);
			list.add(cond4);
			listDistributionCustomers = delegator.findList("PartyRelationship",EntityCondition.makeCondition(list,EntityJoinOperator.AND), null, null, null, false);
			EntityCondition cond5 = EntityCondition.makeCondition(UtilMisc.toMap("roleTypeIdFrom","DELYS_SALESMAN_GT","roleTypeIdTo","DELYS_ROUTE"));
			EntityCondition cond6 = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE1");
			EntityCondition cond7 = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE2");
			EntityCondition cond8 = EntityCondition.makeCondition("thruDate",EntityJoinOperator.EQUALS,null);
			List<EntityCondition> listCond = FastList.newInstance();
			listCond.add(cond5);
			listCond.add(cond6);
			listCond.add(cond7);
			listCond.add(cond8);
			listDistribution = delegator.findList("PartyRelationship",EntityCondition.makeCondition(listCond,EntityJoinOperator.AND), null, null, null, false);
			if(UtilValidate.isNotEmpty(listRoute)) {
				obj.put("listRoute", listRoute);
			}
			if(UtilValidate.isNotEmpty(listSalesMan)){
				obj.put("listSalesMan", listSalesMan);
			}
			if(UtilValidate.isNotEmpty(listDistribution)){
				obj.put("listDistribution", listDistribution);
			}
			if(UtilValidate.isNotEmpty(listCustomers)){
				obj.put("listCustomer", listCustomers);
			}
			if(UtilValidate.isNotEmpty(listDistributionCustomers)){
				obj.put("listDistributionCustomers", listDistributionCustomers);
			}
			
		} catch	(GenericEntityException e){
			e.printStackTrace();
			return ServiceUtil.returnError("Failed");
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError("Failed");
			// TODO: handle exception
		}
		Map<String,Object> result = FastMap.newInstance();
		result.put("result", obj);
		return result;
	}
	
	
	/*
	 * Distribution Route for SalesMan
	 * @param DispatchContext dpct,Map<?,?>
	 * 
	 * */
	@SuppressWarnings("unchecked")
	public static Map<String,Object> distributionRouteStores(DispatchContext dpct,Map<?,?> context){
		Delegator delegator = dpct.getDelegator();
		String listDistribution = (String) context.get("listDistributionStores");
		JSONArray arr = new JSONArray();
		List<GenericValue> list = FastList.newInstance();	
		Map<String,Object> result = FastMap.newInstance();
		Map<String,Object> mapRelationship = FastMap.newInstance();
		Map<String,Object> tmp = FastMap.newInstance();
		EntityCondition condRole = EntityCondition.makeCondition(UtilMisc.toMap("roleTypeIdTo","DELYS_CUSTOMER_GT","roleTypeIdFrom","DELYS_ROUTE"));
		EntityCondition condFrom = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE1");
		EntityCondition condTo = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE2");
		EntityCondition condDate = EntityCondition.makeCondition("thruDate",EntityJoinOperator.EQUALS,null);
		List<EntityCondition> listCond = FastList.newInstance();
		
		try {
			listCond.add(condRole);
			listCond.add(condFrom);
			listCond.add(condTo);	
			listCond.add(condDate);
			if(UtilValidate.isNotEmpty(listDistribution)){
				arr = JSONArray.fromObject(listDistribution);
			}
			if(UtilValidate.isNotEmpty(arr)){
						for(int i = 0 ; i< arr.size() ; i++){
							JSONObject obj = arr.getJSONObject(i);
							String routeId = obj.getString("routeId");
							String partyId = obj.getString("partyId");
							mapRelationship.put("userLogin", (GenericValue) context.get("userLogin"));
							mapRelationship.put("partyIdFrom", routeId);
							mapRelationship.put("partyIdTo", partyId);
							mapRelationship.put("fromDate", UtilDateTime.nowTimestamp());
							mapRelationship.put("roleTypeIdFrom", "DELYS_ROUTE");
							mapRelationship.put("roleTypeIdTo", "DELYS_CUSTOMER_GT");
							mapRelationship.put("partyRelationshipTypeId", "GROUP_ROLLUP");
								List<GenericValue> listRelationShip = delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond,EntityJoinOperator.AND), null, null, null, false);
								if(UtilValidate.isNotEmpty(listRelationShip)){
									boolean checked = false;
									for(GenericValue r : listRelationShip){
										if(r.getString("partyIdTo").equals(partyId)){
											try {
												checked = true;
												Map<String,Object> oldRelationship  = FastMap.newInstance();
												oldRelationship.put("userLogin", (GenericValue) context.get("userLogin"));
												oldRelationship.put("partyIdFrom", r.getString("partyIdFrom"));
												oldRelationship.put("partyIdTo", r.getString("partyIdTo"));
												oldRelationship.put("roleTypeIdFrom", r.getString("roleTypeIdFrom"));
												oldRelationship.put("roleTypeIdTo", r.getString("roleTypeIdTo"));
												oldRelationship.put("fromDate", r.getString("fromDate"));
												oldRelationship.put("thruDate", UtilDateTime.nowTimestamp());
												dpct.getDispatcher().runSync("updatePartyRelationship", oldRelationship);
												dpct.getDispatcher().runSync("createPartyRelationship", mapRelationship);
											} catch (Exception e) {
												e.printStackTrace();
												return ServiceUtil.returnError(e.getMessage());
												// TODO: handle exception
											}
									}
							}
							if(!checked){
								try {
									dpct.getDispatcher().runSync("createPartyRelationship", mapRelationship);
								} catch (Exception e) {
									e.printStackTrace();
									return ServiceUtil.returnError(e.getMessage());
									// TODO: handle exception
								}
							}
						}else{
							try {
								dpct.getDispatcher().runSync("createPartyRelationship", mapRelationship);
							} catch (Exception e) {
								e.printStackTrace();
								return ServiceUtil.returnError(e.getMessage());
								// TODO: handle exception
							}
						}
					}
			}		
			//update distribution list newest
			list = delegator.findList("PartyRelationship",EntityCondition.makeCondition(listCond,EntityJoinOperator.AND), null, null, null, false);
			if(list.size() > 0) result.put("result", list);
		} catch (GenericEntityException e) {
			e.printStackTrace();
			return ServiceUtil.returnError(e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError(e.getMessage());
			// TODO: handle exception
		}
		return result;		
	}
	
	/*
	 * Distribution Route for SalesMan
	 * @param DispatchContext dpct,Map<?,?>
	 * 
	 * */
	@SuppressWarnings("unchecked")
	public static Map<String,Object> distributionRouteSalesMan(DispatchContext dpct,Map<?,?> context){
		Delegator delegator = dpct.getDelegator();
		String listDistribution = (String) context.get("listDistribution");
		JSONArray arr = new JSONArray();
		List<GenericValue> list = FastList.newInstance();	
		Map<String,Object> result = FastMap.newInstance();
		Map<String,Object> mapRelationship = FastMap.newInstance();
		EntityCondition condRole = EntityCondition.makeCondition(UtilMisc.toMap("roleTypeIdFrom","DELYS_SALESMAN_GT","roleTypeIdTo","DELYS_ROUTE"));
		EntityCondition condFrom = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE1");
		EntityCondition condTo = EntityCondition.makeCondition("partyIdFrom",EntityJoinOperator.NOT_EQUAL,"ROUTE2");
		EntityCondition condDate = EntityCondition.makeCondition("thruDate",EntityJoinOperator.EQUALS,null);
		List<EntityCondition> listCond = FastList.newInstance();
		try {
			listCond.add(condRole);
			listCond.add(condFrom);
			listCond.add(condTo);
			listCond.add(condDate);
			if(UtilValidate.isNotEmpty(listDistribution)){
				arr = JSONArray.fromObject(listDistribution);
			}
			if(UtilValidate.isNotEmpty(arr)){
						for(int i = 0 ; i< arr.size() ; i++){
							JSONObject obj = arr.getJSONObject(i);
							String routeId = obj.getString("routeId");
							String partyId = obj.getString("partyId");
							mapRelationship.put("userLogin", (GenericValue) context.get("userLogin"));
							mapRelationship.put("partyIdFrom", partyId);
							mapRelationship.put("partyIdTo", routeId);
							mapRelationship.put("fromDate", UtilDateTime.nowTimestamp());
							mapRelationship.put("roleTypeIdFrom", "DELYS_SALESMAN_GT");
							mapRelationship.put("roleTypeIdTo", "DELYS_ROUTE");
							mapRelationship.put("partyRelationshipTypeId", "GROUP_ROLLUP");
								List<GenericValue> listRelationShip = delegator.findList("PartyRelationship", EntityCondition.makeCondition(listCond,EntityJoinOperator.AND), null, null, null, false);
								if(UtilValidate.isNotEmpty(listRelationShip)){
									for(GenericValue r : listRelationShip){
										if(r.getString("partyIdTo").equals(routeId)){
											try {
												Map<String,Object> oldRelationship  = FastMap.newInstance();
												oldRelationship.put("userLogin", (GenericValue) context.get("userLogin"));
												oldRelationship.put("partyIdFrom", r.getString("partyIdFrom"));
												oldRelationship.put("partyIdTo", r.getString("partyIdTo"));
												oldRelationship.put("roleTypeIdFrom", r.getString("roleTypeIdFrom"));
												oldRelationship.put("roleTypeIdTo", r.getString("roleTypeIdTo"));
												oldRelationship.put("fromDate", r.getString("fromDate"));
												oldRelationship.put("thruDate", UtilDateTime.nowTimestamp());
												dpct.getDispatcher().runSync("updatePartyRelationship", oldRelationship);
												dpct.getDispatcher().runSync("createPartyRelationship", mapRelationship);
											} catch (Exception e) {
												e.printStackTrace();
												return ServiceUtil.returnError(e.getMessage());
												// TODO: handle exception
											}
									}else{
										try {
											if(r.getString("partyIdFrom").equals(partyId)){
												r.remove();
											}
											dpct.getDispatcher().runSync("createPartyRelationship", mapRelationship);
										} catch (Exception e) {
											e.printStackTrace();
											return ServiceUtil.returnError(e.getMessage());
											// TODO: handle exception
										}
									}
							}
						}else{
							try {
								dpct.getDispatcher().runSync("createPartyRelationship", mapRelationship);
							} catch (Exception e) {
								e.printStackTrace();
								return ServiceUtil.returnError(e.getMessage());
								// TODO: handle exception
							}
						}
					}
			}		
			//update distribution list newest
			list = delegator.findList("PartyRelationship",EntityCondition.makeCondition(listCond,EntityJoinOperator.AND), null, null, null, false);
			if(list.size() > 0) result.put("result", list);
		} catch (GenericEntityException e) {
			e.printStackTrace();
			return ServiceUtil.returnError(e.getMessage());
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError(e.getMessage());
			// TODO: handle exception
		}
		return result;		
	}
	
	/*
	 * loginSup 
	 * @param DispatchContext ,Map<?,?> context
	 * */
	public static Map<String,Object> loginSup(DispatchContext dpct,Map<?,?> context){
		Delegator delegator = dpct.getDelegator();
		String credentials = (String) context.get("credentials");
		JSONArray arr  = new JSONArray();
		Map<String,Object> mapLogin = FastMap.newInstance();
		Map<String,Object> result = FastMap.newInstance();
		try {
				arr = JSONArray.fromObject(credentials);
				JSONObject tmp  = arr.getJSONObject(0);
				String userLoginId = tmp.getString("USERNAME");
				Map<String,Object> ctx = FastMap.newInstance();
				ctx.put("userLoginId", userLoginId);
				GenericValue user = delegator.findOne("UserLogin", false, ctx);
				if(UtilValidate.isNotEmpty(user)){
					String partyId = user.getString("partyId");
					Map<String,Object> map = FastMap.newInstance();
					map.put("partyId", partyId);
					List<GenericValue> listRole = delegator.findList("PartyRole", EntityCondition.makeCondition(map),null,null, null, false);
					if(UtilValidate.isNotEmpty(listRole)){
						boolean flag = false;
						for(GenericValue role : listRole){
							if(role.getString("roleTypeId").equals("DELYS_SALESSUP_GT")){
								flag = true;
							}
						}
						mapLogin.put("checked", flag);
					}
				}
		} catch (Exception e) {
			e.printStackTrace();
			return ServiceUtil.returnError(e.getMessage());
			// TODO: handle exception
		}
		result.put("result", mapLogin);
		return result;
	}
	public static Map<String,Object> tempGetAllProduct(DispatchContext dpct,Map<?,?> context){
		Delegator delegator = dpct.getDelegator();
		org.ofbiz.entity.condition.EntityCondition cond = (org.ofbiz.entity.condition.EntityCondition) context.get("inputParams");
		EntityFindOptions options = new EntityFindOptions(true,
				EntityFindOptions.TYPE_SCROLL_INSENSITIVE,
				EntityFindOptions.CONCUR_READ_ONLY, true);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			org.ofbiz.entity.util.EntityListIterator returnValue = delegator.find("ProductCategoryMemberAndPrice",
					cond, null, UtilMisc.toSet("productId",
							"productInternalName", "pricePrice", "productCategoryId"), null,
					options);
			returnMap.put("outputParams", returnValue);
		} catch (Exception e) {
			Debug.logError(e.toString(), module);
		}
		return returnMap;
	}
}

