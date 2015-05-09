/*******************************************************************************
 * Licensed to the Ache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Ache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.ache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *******************************************************************************/

package com.olbius.delys.crm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javolution.util.FastList;
import javolution.util.FastMap;
import javolution.util.FastSet;

import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityFindOptions;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.party.party.PartyHelper;
import org.ofbiz.party.party.PartyWorker;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;

import com.meterware.pseudoserver.HttpRequest;

public class Contact {
	public static final String module = Contact.class.getName();
	public static final String resourceError = "MarketingUiLabels";

	//get customer person
	public static Map<String, Object> getListContacts(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		List<EntityCondition> listAllConditions = (List<EntityCondition>) context
				.get("listAllConditions");
		List<String> listSortFields = (List<String>) context
				.get("listSortFields");
		EntityFindOptions opts = (EntityFindOptions) context.get("opts");

		try {
			Set<String> fields = FastSet.newInstance();
			fields.add("partyId");
			fields.add("city");
			fields.add("infoString");
			fields.add("contactNumber");
			fields.add("address1");
			fields.add("firstName");
			fields.add("lastName");
			fields.add("middleName");
			fields.add("birthDate");
			opts.setDistinct(true);
			listSortFields.add("partyId ASC");
			List<EntityCondition> roletype = FastList.newInstance();
			roletype.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "CONTACT"));
			roletype.add(EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "END_USER_CUSTOMER"));
			EntityCondition tmprole = EntityCondition.makeCondition(
					roletype, EntityJoinOperator.OR);
			listAllConditions.add(tmprole);
			EntityCondition person = EntityCondition.makeCondition(
					"partyTypeId", EntityOperator.EQUALS, "PERSON");
			listAllConditions.add(person);
			EntityCondition tmpConditon = EntityCondition.makeCondition(
					listAllConditions, EntityJoinOperator.AND);
			List<GenericValue> tmpcontacts = delegator.findList(
					"PersonAndContactMechDetail", tmpConditon, fields,
					listSortFields, opts, false);
			List<Map<String, Object>> contacts = distinctContact(tmpcontacts);
			successResult.put("listIterator", contacts);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return successResult;
	}
	

	public static List<Map<String, Object>> distinctContact(List<GenericValue> input) {
		List<Map<String, Object>> contacts = FastList.newInstance();
		String currentPartyId = "";
		Map<String, Object> temp = FastMap.newInstance();
		for (GenericValue e : input) {
			String partyId = e.getString("partyId");
			if (currentPartyId == "" || !currentPartyId.equals(partyId)) {
				if (currentPartyId != "" && currentPartyId != partyId) {
					contacts.add(temp);
				}
				currentPartyId = partyId;
				GenericValue cur = (GenericValue) e.clone();
				Map<String, Object> tmpCt = cleanContact(cur);
				temp = tmpCt;
			} else if (currentPartyId.equals(partyId)) {
				setContact(temp, e);
			}
		}
		contacts.add(temp);
		return contacts;
	}

	public static Map<String, Object> cleanContact(GenericValue cur) {
		Map<String, Object> tmpCt = FastMap.newInstance();
		String partyId = cur.getString("partyId");
		String firstname = cur.getString("firstName");
		String middlename = cur.getString("middleName");
		String lastname = cur.getString("lastName");
		String groupname = cur.getString("groupName");
		String email = cur.getString("infoString");
		String pa = cur.getString("city");
		String ct = cur.getString("address1");
		String phone = cur.getString("contactNumber");
		String birth = cur.getString("birthDate");
		List<String> eli = new ArrayList<String>();
		List<String> pali = new ArrayList<String>();
		List<String> ctli = new ArrayList<String>();
		List<String> phli = new ArrayList<String>();
		if (email != null && email != "") {
			eli.add(email);
		}
		if (pa != null && pa != "") {
			pali.add(pa);
		}
		if (ct != null && ct != "") {
			ctli.add(ct);
		}
		if (phone != null && phone != "") {
			phli.add(phone);
		}
		if (firstname != null && firstname != "") {
			tmpCt.put("firstName", firstname);
		}
		if (middlename != null && middlename != "") {
			tmpCt.put("middleName", middlename);
		}
		if (lastname != null && lastname != "") {
			tmpCt.put("lastName", lastname);
		}
		if (groupname != null && groupname != "") {
			tmpCt.put("groupName", groupname);
		}

		tmpCt.put("partyId", partyId);
		tmpCt.put("birthDate", birth);
		tmpCt.put("infoString", eli);
		tmpCt.put("city", pali);
		tmpCt.put("address1", ctli);
		tmpCt.put("contactNumber", phli);
		return tmpCt;
	}

	public static void setContact(Map<String, Object> temp, GenericValue e) {
		String email = e.getString("infoString");
		String pa = e.getString("city");
		String ct = e.getString("address1");
		String phone = e.getString("contactNumber");
		List<String> eli = (ArrayList<String>) temp.get("infoString");
		List<String> pali = (ArrayList<String>) temp.get("city");
		List<String> ctli = (ArrayList<String>) temp.get("address1");
		List<String> phli = (ArrayList<String>) temp.get("contactNumber");
		if (email != null && email != "") {
			eli.add(email);
		}
		if (pa != null && pa != "") {
			pali.add(pa);

		}
		if (ct != null && ct != "") {
			ctli.add(ct);
		}
		if (phone != null && phone != "") {
			phli.add(phone);
		}
		temp.put("infoString", eli);
		temp.put("city", pali);
		temp.put("address1", ctli);
		temp.put("contactNumber", phli);
	}
	//get customer group delys
		public static Map<String, Object> getListGroupContacts(
				DispatchContext dctx, Map<String, ? extends Object> context) {
			Delegator delegator = dctx.getDelegator();
			Map<String, Object> successResult = ServiceUtil.returnSuccess();
			List<EntityCondition> listAllConditions = (List<EntityCondition>) context
					.get("listAllConditions");
			EntityFindOptions opts = (EntityFindOptions) context.get("opts");
			try {
				Set<String> fields = FastSet.newInstance();
				UtilMisc.toSet("partyId", "city", "address1", "infoString",
						"contactNumber", "groupName");
				opts.setDistinct(true);
				List<String> listSortFields = (List<String>) context
						.get("listSortFields");
				listSortFields.add("partyIdFrom ASC");
				listAllConditions.add(EntityCondition.makeCondition("roleTypeIdTo", EntityOperator.EQUALS, "DELYS_CUSTOMER_GT"));
				listAllConditions.add(EntityCondition.makeCondition("roleTypeIdFrom", EntityOperator.EQUALS, "OWNER"));
				EntityCondition tmpConditon = EntityCondition.makeCondition(
						listAllConditions, EntityJoinOperator.AND);
				List<GenericValue> tmpcontacts = delegator.findList(
						"PartyOwnerAndContactMechDetail", tmpConditon, fields,
						listSortFields, opts, false);
				List<Map<String, Object>> contacts = distinctContactGroup(tmpcontacts);
				successResult.put("listIterator", contacts);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return successResult;
		}
	//group
	public static List<Map<String, Object>> distinctContactGroup(List<GenericValue> input) {
		List<Map<String, Object>> contacts = FastList.newInstance();
		String currentPartyId = "";
		Map<String, Object> temp = FastMap.newInstance();
		for (GenericValue e : input) {
			String partyId = e.getString("partyIdFrom");
			if (currentPartyId == "" || !currentPartyId.equals(partyId)) {
				if (currentPartyId != "" && currentPartyId != partyId) {
					contacts.add(temp);
				}
				currentPartyId = partyId;
				GenericValue cur = (GenericValue) e.clone();
				Map<String, Object> tmpCt = cleanContactGroup(cur);
				temp = tmpCt;
			} else if (currentPartyId.equals(partyId)) {
				setContact(temp, e);
			}
		}
		contacts.add(temp);
		return contacts;
	}

	public static Map<String, Object> cleanContactGroup(GenericValue cur) {
		Map<String, Object> tmpCt = FastMap.newInstance();
		String partyIdFrom = cur.getString("partyIdFrom");
		String partyIdTo = cur.getString("partyIdTo");
		String firstname = cur.getString("firstName");
		String middlename = cur.getString("middleName");
		String lastname = cur.getString("lastName");
		String groupname = cur.getString("groupName");
		String email = cur.getString("infoString");
		String pa = cur.getString("city");
		String ct = cur.getString("address1");
		String phone = cur.getString("contactNumber");
		String birth = cur.getString("birthDate");
		List<String> eli = new ArrayList<String>();
		List<String> pali = new ArrayList<String>();
		List<String> ctli = new ArrayList<String>();
		List<String> phli = new ArrayList<String>();
		if (email != null && email != "") {
			eli.add(email);
		}
		if (pa != null && pa != "") {
			pali.add(pa);
		}
		if (ct != null && ct != "") {
			ctli.add(ct);
		}
		if (phone != null && phone != "") {
			phli.add(phone);
		}
		tmpCt.put("firstName", firstname);
		tmpCt.put("middleName", middlename);
		tmpCt.put("lastName", lastname);
		tmpCt.put("groupName", groupname);
		tmpCt.put("partyIdFrom", partyIdFrom);
		tmpCt.put("partyIdTo", partyIdTo);
		tmpCt.put("birthDate", birth);
		tmpCt.put("infoString", eli);
		tmpCt.put("city", pali);
		tmpCt.put("address1", ctli);
		tmpCt.put("contactNumber", phli);
		return tmpCt;
	}

}
