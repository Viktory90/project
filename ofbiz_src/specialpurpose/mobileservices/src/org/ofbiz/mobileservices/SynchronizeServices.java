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
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.model.DynamicViewEntity;
import org.ofbiz.entity.model.ModelKeyMap;
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
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

import com.olbius.service.SalesmanServices;

public class SynchronizeServices {
	public static final String module = SynchronizeServices.class.getName();
	public static final String resource_error = "SynchronizeServicesErrorUiLabels";

	public static Map<String, Object> getPromotions(DispatchContext ctx,
			Map<String, Object> context) {
		Map<String, Object> res = FastMap.newInstance();
		Delegator delegator = ctx.getDelegator();
		EntityFindOptions options = new EntityFindOptions();
		options.setDistinct(true);
		Timestamp cur = UtilDateTime.nowTimestamp();
		List<EntityCondition> allConditions = FastList.newInstance();
		allConditions.add(EntityCondition.makeCondition("productPromoTypeId",
				EntityOperator.EQUALS, "PROMOTION"));
		allConditions.add(EntityCondition.makeCondition("productPromoStatusId",
				EntityOperator.EQUALS, "PROMO_ACCEPTED"));
		allConditions.add(EntityCondition.makeCondition("showToCustomer",
				EntityOperator.EQUALS, "Y"));
		allConditions.add(EntityCondition.makeCondition("roleTypeId",
				EntityOperator.EQUALS, "DELYS_CUSTOMER_GT"));
		EntityCondition now = EntityUtil.getFilterByDateExpr(cur);
		allConditions.add(now);
		EntityCondition queryConditionsList = EntityCondition.makeCondition(
				allConditions, EntityOperator.AND);
		Set<String> fields = FastSet.newInstance();
		fields.add("productPromoId");
		fields.add("productId");
		fields.add("productPromoRuleId");
		fields.add("orderAdjustmentTypeId");
		fields.add("productPromoActionEnumId");
		fields.add("productPromoCondSeqId");
		fields.add("productPromoActionSeqId");
		fields.add("inputParamEnumId");
		fields.add("productPromoApplEnumId");
		fields.add("operatorEnumId");
		fields.add("otherValue");
		fields.add("quantity");
		fields.add("amount");
		fields.add("partyId");
		fields.add("fromDate");
		fields.add("thrudate");
		fields.add("condValue");
		fields.add("ruleName");
		try {
			List<GenericValue> promotions = delegator.findList("PromosEvents",
					queryConditionsList, null, UtilMisc.toList("fromDate"),
					options, true);
			res.put("promotions", promotions);
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}

}
