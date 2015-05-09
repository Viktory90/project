package org.ofbiz.mobileUtil;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Currency;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.PriorityQueue;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.template.FreeMarkerWorker;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.party.contact.ContactHelper;
import org.ofbiz.product.category.CategoryContentWrapper;
import org.ofbiz.webapp.ftl.OfbizAmountTransform;
import org.ofbiz.webapp.ftl.OfbizCurrencyTransform;

public class MobileUtils {
	public static List fillTree(List<GenericValue> rootCat, int level,
			String parentCategoryId, Delegator delegator,
			HttpServletRequest request) {
		if (rootCat != null) {
			List listTree = FastList.newInstance();
			for (GenericValue root : rootCat) {
				try {
					List<GenericValue> preCatChilds = delegator
							.findByAnd("ProductCategoryRollup", UtilMisc.toMap(
									"parentProductCategoryId",
									root.get("productCategoryId")), null, false);
					List<GenericValue> catChilds = EntityUtil
							.getRelated("CurrentProductCategory", null,
									preCatChilds, false);
					List childList = FastList.newInstance();
					if (catChilds != null) {
						if (level == 2)
							childList = fillTree(catChilds, level + 1,
									parentCategoryId.replaceAll("/", "") + '/'
											+ root.get("productCategoryId"),
									delegator, request);
						// replaceAll and '/' uses for fix bug in the breadcrum
						// for href of category
						else if (level == 1)
							childList = fillTree(
									catChilds,
									level + 1,
									parentCategoryId.replaceAll("/", "")
											+ root.get("productCategoryId"),
									delegator, request);
						else
							childList = fillTree(
									catChilds,
									level + 1,
									parentCategoryId + '/'
											+ root.get("productCategoryId"),
									delegator, request);
					}
					List<GenericValue> productsInCat = delegator
							.findByAnd(
									"ProductCategoryAndMember",
									UtilMisc.toMap("productCategoryId",
											root.get("productCategoryId")),
									null, false);
					if (productsInCat != null || childList != null) {
						Map rootMap = FastMap.newInstance();
						GenericValue category = delegator.findOne(
								"ProductCategory",
								UtilMisc.toMap("productCategoryId",
										root.get("productCategoryId")), false);
						CategoryContentWrapper categoryContentWrapper = new CategoryContentWrapper(
								category, request);
						if (categoryContentWrapper.get("CATEGORY_NAME") != null) {
							rootMap.put("categoryName",
									categoryContentWrapper.get("CATEGORY_NAME"));
						} else {
							rootMap.put("categoryName",
									root.getString("categoryName"));
						}
						if (categoryContentWrapper.get("DESCRIPTION") != null)
							rootMap.put("categoryDescription",
									categoryContentWrapper.get("DESCRIPTION"));
						else
							rootMap.put("categoryDescription",
									root.getString("description"));

						rootMap.put("productCategoryId",
								root.getString("productCategoryId"));
						rootMap.put("parentCategoryId", parentCategoryId);
						rootMap.put("child", childList);
						listTree.add(rootMap);
					}
				} catch (GenericEntityException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			return listTree;
		}
		return null;
	}
	
	public static String getPartyContent(HttpServletRequest request,
			HttpServletResponse response) throws GenericEntityException{
		GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		GenericValue party;		
		if(userLogin != null){
			party = userLogin.getRelatedOne("Party", false);
			String partyContent = null;
			List<GenericValue> partyContentList = delegator.findList(
					"PartyContent", EntityCondition.makeCondition("partyId",
							EntityOperator.EQUALS, party.get("partyId")), null,
					UtilMisc.toList("fromDate DESC"), null, false);
			if(partyContentList.size() > 0){
				String contentId = (String) partyContentList.get(0).get("contentId");
				if (contentId != null) {
					partyContent = request.getScheme() + "://"
							+ request.getServerName() + ":"
							+ request.getServerPort()
							+ "/content/control/stream?contentId=" + contentId;				
				}
			}
			
			return partyContent;
		}			
		return null;				
	}
	public static <K, V extends Comparable<? super V>> List<Entry<K, V>> findGreatest(Map<K, V> map, int n) {
		Comparator<? super Entry<K, V>> comparator = new Comparator<Entry<K, V>>() {
			@Override
			public int compare(Entry<K, V> e0, Entry<K, V> e1) {
				V v0 = e0.getValue();
				V v1 = e1.getValue();
				return v0.compareTo(v1);
			}
		};
		PriorityQueue<Entry<K, V>> highest = new PriorityQueue<Entry<K, V>>(n, comparator);
		for (Entry<K, V> entry : map.entrySet()) {
			highest.offer(entry);
			while (highest.size() > n) {
				highest.poll();
			}
		}

		List<Entry<K, V>> result = new ArrayList<Map.Entry<K, V>>();
		while (highest.size() > 0) {
			result.add(highest.poll());
		}
		return result;
	}
}
