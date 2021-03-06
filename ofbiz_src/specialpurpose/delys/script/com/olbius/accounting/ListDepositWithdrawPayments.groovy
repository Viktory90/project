/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.service.ServiceUtil;
result = ServiceUtil.returnSuccess();
	
List exprListForParameters = [];
finAccountId = context.parameters.parameters.finAccountId.getAt(0);
organizationPartyId = context.parameters.parameters.organizationPartyId.getAt(0);
finAcctCond = EntityCondition.makeCondition([EntityCondition.makeCondition("finAccountId", EntityOperator.EQUALS, finAccountId),
                                             EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "DIVISION")], EntityOperator.AND);
finAccountRoles = EntityUtil.filterByDate(delegator.findList("FinAccountRole", finAcctCond, null, null, null, false));
finAccountPartyIds = EntityUtil.getFieldListFromEntityList(finAccountRoles, "partyId", true);
finAccountPartyIds.add(organizationPartyId);
partyCond = EntityCondition.makeCondition([EntityCondition.makeCondition("partyIdTo", EntityOperator.IN, finAccountPartyIds),
                                           EntityCondition.makeCondition("partyIdFrom", EntityOperator.IN, finAccountPartyIds)], EntityOperator.OR);
statusCond = EntityCondition.makeCondition([EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "PMNT_RECEIVED"),
                                            EntityCondition.makeCondition("statusId", EntityOperator.EQUALS, "PMNT_SENT")], EntityOperator.OR);

exprListForParameters.add(EntityCondition.makeCondition("finAccountTransId", EntityOperator.EQUALS, null));
paramCond = EntityCondition.makeCondition(exprListForParameters, EntityOperator.AND);
combinedPaymentCond = EntityCondition.makeCondition([partyCond, statusCond, paramCond], EntityOperator.AND);
payments = delegator.findList("PaymentAndTypePartyNameView", combinedPaymentCond, null, null, null, false);
result.listIterator = payments;
return result;