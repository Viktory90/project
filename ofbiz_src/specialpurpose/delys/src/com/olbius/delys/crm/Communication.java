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

import java.util.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

import net.sf.json.JSONArray;

public class Communication {
	public static final String module = Communication.class.getName();
	public static final String resourceError = "MarketingUiLabels";

	/* create an issue from customer */
	public static Map<String, Object> raiseCustomerIssue(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String partyId = (String) context.get("partyId");
		String eventType = (String) context.get("support");
		String content = (String) context.get("content");
		Date date = new Date();
		Timestamp currentDate = new Timestamp(date.getTime()); 
		Map<String, Object> tmp = FastMap.newInstance();
		try {
			tmp.put("communicationEventId",
					delegator.getNextSeqId("CommunicationEvent"));
			tmp.put("partyIdFrom", partyId);
			tmp.put("partyIdTo", userLogin.get("partyId"));
			tmp.put("communicationEventTypeId", eventType);
			tmp.put("content", content);
			tmp.put("entryDate", currentDate);
			delegator.create("CommunicationEvent", tmp);
			successResult.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			successResult.put("status", "error");
			return successResult;
		}
		return successResult;
	}

	/* get list of communication types */
	public static Map<String, Object> getCommunicationTypes(
			DispatchContext dctx, Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		List<GenericValue> listCommunications = FastList.newInstance();
		try {
			listCommunications = delegator.findList("CommunicationEventType",
					null, null, null, null, false);
		} catch (Exception e) {
			e.printStackTrace();
			successResult.put("status", "error");
			successResult.put("message", e.getMessage());
			return successResult;
		}
		successResult.put("status", "success");
		successResult.put("results", listCommunications);
		return successResult;
	}

	/* Change customer state from contact -> account -> lead */
	public static Map<String, Object> changeCustomerState(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		String state = (String) context.get("state");
		String previous = (String) context.get("previous");
		String listParty = (String) context.get("listParty");
		JSONArray listPartyJson = JSONArray.fromObject(listParty);
		int length = listPartyJson.size();
		try {
			for (int i = 0; i < length; i++) {
				String partyId = listPartyJson.getString(i);
				delegator.removeByAnd("PartyRole", UtilMisc.toMap("partyId",
						partyId, "roleTypeId", previous), false);
				delegator
						.create("PartyRole", UtilMisc.toMap("partyId", partyId,
								"roleTypeId", state));
			}
			successResult.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			successResult.put("status", "error");
			successResult.put("message", e.getMessage());
		}
		return successResult;
	}

	/* Change customer state from contact -> account -> lead */
	public static Map<String, Object> sendListEmail(DispatchContext dctx,
			Map<String, ? extends Object> context) {
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		String listEmail = (String) context.get("listEmail");
		String subject = (String) context.get("subject");
		String content = (String) context.get("content");
		JSONArray listEmailJson = JSONArray.fromObject(listEmail);
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		int length = listEmailJson.size();
		try {
			for (int i = 0; i < length; i++) {
				/* create communication event */
				String infoString = listEmailJson.getString(i);
				List<GenericValue> listCus = (List<GenericValue>) delegator.findByAnd(
						"PartyRoleAndContactMechDetail",
						UtilMisc.toMap("infoString", infoString), null, false);
				if (!listCus.isEmpty()) {
					GenericValue cus = listCus.get(0);
					String partyId = cus.getString("partyId");
					if (partyId != null) {
						Map<String, Object> tmp = FastMap.newInstance();
						String communicationEventId = delegator
								.getNextSeqId("CommunicationEvent");
						tmp.put("communicationEventId", communicationEventId);
						tmp.put("partyIdFrom",
								userLogin.getString("userLoginId"));
						tmp.put("partyIdTo", partyId);
						tmp.put("communicationEventTypeId",
								"EMAIL_COMMUNICATION");
						tmp.put("content", subject);
						tmp.put("content", content);
						delegator.create("CommunicationEvent", tmp);
						/* send email */
						Map<String, Object> emailCtx = FastMap.newInstance();
						emailCtx.put("contactListId", infoString);
						emailCtx.put("communicationEventId",
								communicationEventId);
						dispatcher.runAsync("sendEmailToContact", emailCtx);
					}
				}

			}
			successResult.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			successResult.put("status", "error");
			successResult.put("message", e.getMessage());
		}
		return successResult;
	}

	/* get all customer activity */
	public static Map<String, Object> getAllCommunicationOfCustomer(
			DispatchContext dctx, Map<String, ? extends Object> context) {
		Delegator delegator = dctx.getDelegator();
		Map<String, Object> successResult = ServiceUtil.returnSuccess();
		String partyId = (String) context.get("partyId");
		String startDate = (String) context.get("startDate");
		String endDate = (String) context.get("endDate");
		try {
			EntityCondition partyFrom = EntityCondition.makeCondition(
					"partyIdFrom", EntityOperator.EQUALS, partyId);
			EntityCondition partyTo = EntityCondition.makeCondition(
					"partyIdTo", EntityOperator.EQUALS, partyId);
			EntityCondition party = EntityCondition.makeCondition(
					UtilMisc.toList(partyFrom, partyTo), EntityOperator.OR);
			List<EntityCondition> listCondition = FastList.newInstance();
			listCondition.add(party);
			SimpleDateFormat dateFormat = new SimpleDateFormat(
					"dd/MM/yyyy hh:mm:ss aa");
			if (startDate != null) {
				Date startDateParse = new java.sql.Date(dateFormat.parse(
						startDate).getTime());
				Timestamp fieldValueStart = new java.sql.Timestamp(
						startDateParse.getTime());
				EntityCondition start = EntityCondition.makeCondition(
						"entryDate", EntityOperator.GREATER_THAN_EQUAL_TO,
						fieldValueStart);
				listCondition.add(start);
			}
			if (endDate != null) {
				Date endDateParse = new java.sql.Date(dateFormat.parse(endDate)
						.getTime());
				Timestamp fieldValueEnd = new java.sql.Timestamp(
						endDateParse.getTime());
				EntityCondition end = EntityCondition.makeCondition(
						"entryDate", EntityOperator.LESS_THAN_EQUAL_TO,
						fieldValueEnd);
				listCondition.add(end);
			}
			EntityCondition condition = EntityCondition.makeCondition(
					listCondition, EntityOperator.AND);
			List<GenericValue> listCom = delegator.findList(
					"CommunicationEventDetail", condition, null,
					UtilMisc.toList("entryDate DESC"), null, false);
			successResult.put("status", "success");
			successResult.put("results", listCom);
		} catch (Exception e) {
			e.printStackTrace();
			successResult.put("status", "error");
			successResult.put("message", e.getMessage());
		}
		return successResult;
	}
}
