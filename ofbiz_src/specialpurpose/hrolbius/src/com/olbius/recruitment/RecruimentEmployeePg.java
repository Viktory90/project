package com.olbius.recruitment;

import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityJoinOperator;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.util.EntityUtil;
import org.ofbiz.party.party.PartyHelper;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GeneralServiceException;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;

import com.olbius.employee.helper.EmployeeHelper;
import com.olbius.employee.services.EmployeeServices;
import com.olbius.util.PartyUtil;

public class RecruimentEmployeePg {
	
	public static final String module = EmployeeServices.class.getName();
	
	public static final String resource = "hrolbiusUiLabels";
	public static final String inviteEmail = "InviteEmailLabels";
	public static final String resourceNoti = "NotificationUiLabels";
	
	/*public static Map<String, Object> createSalesmanPGApplicant(DispatchContext dpctx,
			Map<String, Object> context) throws GenericEntityException{
		 
		String idAdress=null;
		String idPhone=null;
		Map<String, Object> result = FastMap.newInstance();
		Date day= new Date();
		Timestamp time=new  Timestamp(day.getTime());
		Delegator delegator= dpctx.getDelegator();
		Locale locale= (Locale)context.get("locale");
		LocalDispatcher dispatcher = dpctx.getDispatcher();
		GenericValue userLogin= (GenericValue)context.get("userLogin");
		String firstName= (String)context.get("firstName");
		String lastName=(String)context.get("lastName");
		String name = null;
		String bankAcountNumber= (String)context.get("bankAcountNumber");
		String bankBrandId=(String)context.get("bankBrandId");
		String bankId=(String)context.get("bankId");		
		String jobRequestId = (String)context.get("jobRequestId");
		
		String geoid= (String)context.get("city");
		
		String namecity = null;		
		
		if(geoid != null){
			GenericValue cityn= delegator.findOne("Geo", UtilMisc.toMap("geoId",geoid), false);
			namecity= cityn.getString("geoName");
		}
		
		String countryGeoId=(String)context.get("countryGeoId");
		
		if((firstName!=null)&&(lastName!=null)){
			name = firstName+" "+lastName;
		}
		else if((firstName==null)&&(lastName!=null)){
			name = lastName;
		}
		else if((firstName!=null)&&(lastName==null)){
			name = firstName;
		}
		String partyId = null;
		try {			
			Map<String, Object> personMap = ServiceUtil.setServiceFields(dpctx.getDispatcher(), "createPerson", context, (GenericValue)context.get("userLogin"), (TimeZone)context.get("timeZone"), locale); 
			Map<String,Object> map= dpctx.getDispatcher().runSync("createPerson", personMap);
			partyId= (String)map.get("partyId");
			context.put("partyId", partyId);
			//create partyRole
			Map<String, Object> roleMap = FastMap.newInstance();
			roleMap.put("partyId", partyId);
			roleMap.put("roleTyeId", "APPLICANT");
			roleMap.put("userLogin", userLogin);
			dpctx.getDispatcher().runSync("createPartyRole", roleMap);						
			
			Map<String, Object> emplAppCtx = FastMap.newInstance();
			emplAppCtx.put("partyId", partyId);
			emplAppCtx.put("jobRequestId", jobRequestId);
			ApplicantServiceHelper.insertEmplApplication(dpctx, emplAppCtx);
			
			//create workEffort for recruitment salesman/PG
			Map<String, Object> workEffCtx = FastMap.newInstance();
			workEffCtx.put("description", "Tuyển dụng Salesman/PG");
			workEffCtx.put("workEffortName", "Tuyển dụng Salesman/PG");
			workEffCtx.put("workEffortTypeId", "RECR_TEST_PLAN");
			workEffCtx.put("userLogin", userLogin);
			workEffCtx.put("currentStatusId", "RTP_COMPLETED");
			Map<String, Object> resultService = dispatcher.runSync("createWorkEffort", workEffCtx);
			String workEffortId = (String)resultService.get("workEffortId");
			if(UtilValidate.isNotEmpty(workEffortId)){
				Map<String, Object> workEffPartyAss = FastMap.newInstance();
				workEffPartyAss.put("partyId", partyId);
				workEffPartyAss.put("workEffortId", workEffortId);
				workEffPartyAss.put("roleTypeId", "APPLICANT");
				workEffPartyAss.put("assignedByUserLoginId", userLogin.getString("userLoginId"));
				workEffPartyAss.put("statusId", "PA_PASS");
				workEffPartyAss.put("fromDate", UtilDateTime.nowTimestamp());
				workEffPartyAss.put("userLogin", userLogin);
				dispatcher.runSync("assignPartyToWorkEffort", workEffPartyAss);
				GenericValue workEffortReqFul = delegator.makeValue("WorkEffortRequestFulfillment");
				workEffortReqFul.put("jobRequestId", jobRequestId);
				workEffortReqFul.put("workEffortId", workEffortId);
				delegator.create(workEffortReqFul);
			}
			//========================= create person information=================================
			String address= (String)context.get("address");
			String phonenumber=(String)context.get("phoneNumber");
			if(bankAcountNumber!=null && bankBrandId !=null && bankId!=null){
				GenericValue bank= delegator.makeValidValue("PartyBank");
				bank.put("bankAcountNumber", bankAcountNumber);
				bank.put("partyId", partyId);
				bank.put("bankBrandId", bankBrandId);
				bank.put("bankId", bankId);
				bank.create();
				result.put("bankAcountNumberCurr", bankAcountNumber);
				result.put("bankBrandIdCurr", bankBrandId);
				result.put("bankIdCurr", bankId);
				result.put("bankId", bankId);
				result.put("bankBrandId", bankBrandId);
				result.put("bankAcountNumber", bankAcountNumber);
			}
			
			if(address != null){
				Map<String, Object> addrs= FastMap.newInstance();
				addrs.put("userLogin", userLogin);
				addrs.put("address1", address);
				addrs.put("partyId", partyId);
				addrs.put("fromDate", time);
				addrs.put("toName", name);
				if(geoid!=null){
					addrs.put("stateProvinceGeoId",geoid);
					addrs.put("city", namecity);
					result.put("city", geoid);
				}
				addrs.put("postalCode", "00000");
				addrs.put("countryGeoId", countryGeoId);
				
				Map<String, Object> admap= dpctx.getDispatcher().runSync("createPartyPostalAddress", addrs);
				idAdress =(String)admap.get("contactMechId");
				result.put("idAddress",idAdress);
				result.put("countryGeoId", countryGeoId);
			}
			if(phonenumber!=null){
				Map<String, Object> tele= FastMap.newInstance();
				tele.put("partyId", partyId);
				tele.put("fromDate", time);
				tele.put("contactNumber", phonenumber);
				tele.put("userLogin", userLogin);
				Map<String, Object> tlemap= dpctx.getDispatcher().runSync("createPartyTelecomNumber", tele);
				idPhone=(String)tlemap.get("contactMechId");
				result.put("idPhone", idPhone);
			}
			
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		//result.put("emplPositionTypeId",emplPositionId);
		result.put("applyingPartyId", partyId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "createSuccessfully", locale));
		return result;
	}*/
	
	public static Map<String, Object> createSalesmanPG(DispatchContext dctx, Map<String, Object> context){
		Locale locale = (Locale) context.get("locale");
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		String orgId = (String)context.get("orgId");
		Timestamp fromDate = (Timestamp) context.get("fromDate");
		TimeZone timeZone = (TimeZone) context.get("timeZone");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String recruitmentTypeId = (String)context.get("recruitmentTypeId");
		String partyId = null;
		try {
			//TODO check limit recruitment number
			Map<String, Object> checkRecruimentMap = RecruitmentDataPreparation.checkRecuitmentPlan(dctx, orgId, emplPositionTypeId, locale, fromDate, recruitmentTypeId, timeZone);
			if((Boolean)checkRecruimentMap.get("isAllowCreated")){
				
				Map<String, Object> personMap = ServiceUtil.setServiceFields(dctx.getDispatcher(), "createPerson", context, (GenericValue)context.get("userLogin"), (TimeZone)context.get("timeZone"), locale);
				Map<String,Object> results = dispatcher.runSync("createPerson", personMap);
				partyId = (String) results.get("partyId");
				Map<String, Object> partyRelMap = FastMap.newInstance();
				partyRelMap.put("partyId", partyId);
				partyRelMap.put("roleTypeId", "EMPLOYEE");
				partyRelMap.put("partyIdFrom", orgId);
				partyRelMap.put("partyIdTo", partyId);
				partyRelMap.put("roleTypeIdFrom", "INTERNAL_ORGANIZATIO");
				partyRelMap.put("roleTypeIdTo", "EMPLOYEE");
				partyRelMap.put("partyRelationshipTypeId", "EMPLOYMENT");
				partyRelMap.put("fromDate", fromDate);
				//partyRelMap.put("thruDate", thruDate);
				partyRelMap.put("userLogin", userLogin);
				dispatcher.runSync("createPartyRelationshipAndRole", partyRelMap);					
				dispatcher.runSync("createEmployment", ServiceUtil.setServiceFields(dispatcher, "createEmployment", partyRelMap, userLogin, timeZone, locale));
				String emplPositionId = null;
				if(recruitmentTypeId.equals("TUYENMOI")){
					results =  dispatcher.runSync("createEmplPosition", UtilMisc.toMap("partyId", orgId, "emplPositionTypeId", emplPositionTypeId, "actualFromDate", fromDate, "statusId", "EMPL_POS_ACTIVE","userLogin", userLogin));
					emplPositionId = (String)results.get("emplPositionId");
				}else if(recruitmentTypeId.equals("TUYENTHAYTHE")){
					emplPositionId = (String) checkRecruimentMap.get("emplPositionId");
				}
				String jobRequestId = (String) checkRecruimentMap.get("jobRequestId");
				if(UtilValidate.isNotEmpty(jobRequestId)){
					GenericValue partyJobRequest = delegator.makeValue("PartyJobRequest");
					partyJobRequest.set("jobRequestId", jobRequestId);
					partyJobRequest.set("partyId", partyId);
					delegator.create(partyJobRequest);
				}else{
					ServiceUtil.returnError(UtilProperties.getMessage("RecruitmentUiLabels", "ErrorCreateNewSalesmanPG", locale));
				}
				if(UtilValidate.isNotEmpty(emplPositionId)){
					dispatcher.runSync("createEmplPositionFulfillment", UtilMisc.toMap("partyId", partyId, "emplPositionId", emplPositionId, "fromDate", fromDate, "userLogin", userLogin));
				}else{
					return ServiceUtil.returnError(UtilProperties.getMessage("RecruitmentUiLabels", "ErrorCreateNewSalesmanPG", locale));
				}
				
			}else{
				return ServiceUtil.returnError((String)checkRecruimentMap.get("errorMessage"));
			}
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, Object> retMap = FastMap.newInstance();
		retMap.put("partyId", partyId);
		retMap.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage("RecruitmentUiLabels", "createSalesmanPGSuccessful", locale));
		return retMap;
	}
	
	public static Map<String, Object> approvalRecruitmentSalesmanPG(DispatchContext dctx, Map<String, Object> context){
		String statusId = (String)context.get("statusId");
		String partyIdFrom = (String)context.get("partyIdFrom");
		String partyIdTo = (String)context.get("partyIdTo");
		String roleTypeIdFrom = (String)context.get("roleTypeIdFrom");
		String roleTypeIdTo = (String)context.get("roleTypeIdTo");
		Timestamp fromDate = (Timestamp)context.get("fromDate");
		String emplPositionId = (String)context.get("emplPositionId");
		Delegator delegator = dctx.getDelegator();
		if(statusId.equals("NOT_APPROVAL")){
			Map<String, Object> primaryKeys = FastMap.newInstance();
			primaryKeys.put("partyIdFrom", partyIdFrom);
			primaryKeys.put("partyIdTo", partyIdTo);
			primaryKeys.put("roleTypeIdFrom", roleTypeIdFrom);
			primaryKeys.put("roleTypeIdTo", roleTypeIdTo);
			primaryKeys.put("fromDate", fromDate);
			try {
				//expire salesman/PG in employment and partyRel
				GenericValue employment = delegator.findOne("Employment", primaryKeys, false);
				GenericValue partyRel = delegator.findOne("Employment", primaryKeys, false);
				Timestamp thruDate = employment.getTimestamp("thruDate");
				Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
				if(thruDate == null || thruDate.after(nowTimestamp)){
					employment.set("thruDate", nowTimestamp);					
				}
				partyRel.set("thruDate", nowTimestamp);
				partyRel.store();
				employment.set("terminationTypeId", "FIRE");
				employment.store();
				//expire emplPositionFulfillment
				//GenericValue emplPosition = delegator.findOne("EmplPosition", UtilMisc.toMap("emplPositionId", emplPositionId), false);
				GenericValue emplPositionFul = delegator.findOne("EmplPositionFulfillment", UtilMisc.toMap("emplPositionId", emplPositionId, "partyId", partyIdTo, "fromDate", fromDate), false);
				Timestamp emplPosThruDate = emplPositionFul.getTimestamp("thruDate");
				if(emplPosThruDate == null || emplPosThruDate.after(nowTimestamp)){
					emplPositionFul.set("thruDate", nowTimestamp);
					emplPositionFul.store();
				}
				
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> createNtfSalesmanPG(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		String partyIdFrom = (String) context.get("partyIdFrom");
		String partyIdTo = (String) context.get("partyIdTo");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		Map<String, Object> ntfMap = FastMap.newInstance();
		try {
			ntfMap.put("partyId", PartyUtil.getManagerbyOrg(partyIdFrom, delegator));
			ntfMap.put("dateTime", UtilDateTime.nowTimestamp());
			ntfMap.put("state", "open");
			ntfMap.put("action", "");
			ntfMap.put("targetLink", "");
			ntfMap.put("header", "Yêu cầu tuyển dụng salesman/PG " + PartyHelper.getPartyName(delegator, partyIdTo, false) + " không được chấp nhận");
			ntfMap.put("userLogin", userLogin);
			dispatcher.runSync("createNotification", ntfMap);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess();
	}
	
	public static Map<String, Object> sendReportRecruitSalesmanPG(DispatchContext dctx, Map<String, Object> context){
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		String partyId = userLogin.getString("partyId");
		Map<String, Object> ntfMap = FastMap.newInstance();
		try {
			GenericValue dept = PartyUtil.getDepartmentOfEmployee(delegator, partyId);
			GenericValue parentDept = PartyUtil.getParentOrgOfDepartmentCurr(delegator, dept.getString("partyIdFrom"));
			String asmId = PartyUtil.getManagerbyOrg(parentDept.getString("partyIdFrom"), delegator);
			ntfMap.put("partyId", asmId);
			ntfMap.put("header", "Phê duyệt đề xuất tuyển dụng salesman/PG trong tháng");
			ntfMap.put("dateTime", UtilDateTime.nowTimestamp());
			ntfMap.put("state", "open");
			ntfMap.put("action", "NewRecruitmentSalesmanPG");
			ntfMap.put("userLogin", userLogin);
			dispatcher.runSync("createNotification", ntfMap);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage("RecruitmentUiLabels", "sendReportSuccessful", (Locale)context.get("locale")));
	}
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> createRecruitmentDisable(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		Timestamp fromDate = (Timestamp) context.get("fromDate");
		Map<String, Object> ntfMap = FastMap.newInstance();
		String reasons = (String) context.get("reasons");
		Locale locale = (Locale)context.get("locale");
		List<String> partyIds = (List<String>) context.get("partyIds");
		String recruitmentDisableId = delegator.getNextSeqId("RecruitmentDisable");
		GenericValue recruitmentDisable = delegator.makeValidValue("RecruitmentDisable", context);
		recruitmentDisable.set("recruitmentDisableId", recruitmentDisableId);
		try {
			GenericValue emplPositionType = delegator.findOne("EmplPositionType", UtilMisc.toMap("emplPositionTypeId", emplPositionTypeId), false);
			Calendar cal = Calendar.getInstance();
			cal.setTime(fromDate);
			ntfMap.put("userLogin", userLogin);
			ntfMap.put("dateTime", UtilDateTime.nowTimestamp());
			ntfMap.put("state", "open");
			ntfMap.put("action", "");
			ntfMap.put("targetLink", "recruitmentDisableId=" + recruitmentDisableId);
			ntfMap.put("header", "Thông báo không tuyển dụng vị trí" + emplPositionType.getString("description") + " từ ngày " + cal.get(Calendar.DATE) + "/" + cal.get(Calendar.MONTH) + "/" + cal.get(Calendar.YEAR));
			delegator.create(recruitmentDisable);
			for(String partyId: partyIds){
				GenericValue recruitmentDisableApply = delegator.makeValue("RecruitmentDisableApply");
				recruitmentDisableApply.set("partyId", partyId);
				recruitmentDisableApply.set("recruitmentDisableId", recruitmentDisableId);
				recruitmentDisableApply.set("reasons", reasons);
				delegator.create(recruitmentDisableApply);
				ntfMap.put("partyId", PartyUtil.getManagerbyOrg(partyId, delegator));
				dispatcher.runSync("createNotification", ntfMap);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, Object> retMap = FastMap.newInstance();
		retMap.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage("RecruitmentUiLabels", "CreateRecruitmentDisableSuccessful", locale));
		retMap.put("recruitmentDisableId", recruitmentDisableId);
		return retMap;
	}
	
	public static Map<String, Object> updateEmployeePG(DispatchContext dpctx,
			Map<String, Object> context) throws GenericEntityException{
		Delegator delegator= dpctx.getDelegator();
		Locale locale= (Locale)context.get("locale");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		LocalDispatcher dispatcher = dpctx.getDispatcher();
		TimeZone timeZone = (TimeZone) context.get("timeZone");
		String workTrialProposalId=(String)context.get("workTrialProposalId");
		String bankAcountNumber= (String)context.get("bankAcountNumber");
		String bankBrandId=(String)context.get("bankBrandId");
		String bankId=(String)context.get("bankId");
		String emplPositionTypeId= (String) context.get("emplPositionTypeId");
		String partyId= (String)context.get("partyId");
		String bankAcountNumberCurr = (String)context.get("bankAcountNumberCurr");
		String bankBrandIdCurr = (String)context.get("bankBrandIdCurr");
		String bankIdCurr =  (String)context.get("bankIdCurr");
		String phoneNumber=(String)context.get("phoneNumber");
		String address=(String)context.get("address");
		String telContactmechId = (String) context.get("telContactmechId");
		String postalAddressContactmechId = (String) context.get("postalAddressContactmechId");
		String stateGeoId = (String)context.get("city");
		String countryGeoId = (String)context.get("countryGeoId");
		Map<String, Object> result = FastMap.newInstance();
		String namecity=null;
		
		if(stateGeoId != null){
			GenericValue cityn= delegator.findOne("Geo", UtilMisc.toMap("geoId",stateGeoId), false);
			namecity= cityn.getString("geoName");
		}
		
		 
		try {
			// Update Information Person	
			dpctx.getDispatcher().runSync("createUpdatePerson", ServiceUtil.setServiceFields(dispatcher, "createUpdatePerson", context, userLogin, timeZone, locale));
		
			//update BankAcount
			if(bankAcountNumber!=null&&bankBrandId!=null&&bankId!=null){
				if(bankAcountNumberCurr!=null&&bankBrandIdCurr!=null&&bankIdCurr!=null){
					GenericValue bank= delegator.findOne("PartyBank",UtilMisc.toMap("bankAcountNumber",bankAcountNumberCurr,"bankBrandId",bankBrandIdCurr,"partyId",partyId,"bankId",bankIdCurr), false);
					bank.remove();
					
				}
				GenericValue bank= delegator.makeValidValue("PartyBank");
				bank.put("bankId", bankId);
				bank.put("bankAcountNumber", bankAcountNumber);
				bank.put("bankBrandId", bankBrandId);
				bank.put("partyId", partyId);
				bank.create();
				
				result.put("bankAcountNumberCurr", bankAcountNumber);
				result.put("bankBrandIdCurr", bankBrandId);
				result.put("bankIdCurr", bankId);
				result.put("bankId", bankId);
				result.put("bankBrandId", bankBrandId);
				result.put("bankAcountNumber", bankAcountNumber);
			}
			
			GenericValue workTrialProposal = delegator.findOne("WorkTrialProposal", UtilMisc.toMap("workTrialProposalId", workTrialProposalId), false);
			if(UtilValidate.isNotEmpty(workTrialProposal)){
				if(UtilValidate.isNotEmpty(emplPositionTypeId)){
					workTrialProposal.set("emplPositionTypeId", emplPositionTypeId);
					delegator.store(workTrialProposal);
				}
			}
			
			if(UtilValidate.isNotEmpty(phoneNumber)&& UtilValidate.isNotEmpty(telContactmechId)){
				dispatcher.runSync("updatePartyTelecomNumber", UtilMisc.toMap("contactMechId", telContactmechId,
																			  "partyId", partyId,
																			  "contactNumber", phoneNumber));
			}
			if(UtilValidate.isNotEmpty(postalAddressContactmechId) && UtilValidate.isNotEmpty(countryGeoId)
					&& UtilValidate.isNotEmpty(stateGeoId) && UtilValidate.isNotEmpty(address)){
				dispatcher.runSync("updatePartyPostalAddress", UtilMisc.toMap("contactMechId", postalAddressContactmechId, 
																			  "partyId", partyId, "address1", address,
																			  "city", namecity,
																			  "stateProvinceGeoId", stateGeoId,
																			  "countryGeoId", countryGeoId,
																			  "postalCode", "10000"));	
			}
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		result.put("workTrialProposalId", workTrialProposalId);
		result.put("partyId", partyId);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		result.put(ModelService.SUCCESS_MESSAGE, UtilProperties.getMessage(resourceNoti, "UpdateSuccessful", locale));
		return result;
		
	}	
	
	public static Map<String, Object> getBankBrandName(DispatchContext dpctx, Map<String, Object> context){
		Delegator delegator= dpctx.getDelegator();
		String bankId=(String)context.get("bankId");
		List<GenericValue> listBankBrandName = FastList.newInstance();
		if(bankId!=null){
			List<EntityCondition> conditions = FastList.newInstance();
			conditions.add(EntityCondition.makeCondition("bankId", EntityOperator.EQUALS, bankId));
			//FIXME need filter by date
			//conditions.add(EntityUtil.getFilterByDateExpr());
			try {
				listBankBrandName = delegator.findList("BankBrandVn", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		Map<String, Object> retMap = FastMap.newInstance();
		retMap.put("listBankBrandName", listBankBrandName);
		return retMap;
	}
	
	public static Map<String, Object> getCityName(DispatchContext dpctx, Map<String, Object> context){
		Delegator delegator= dpctx.getDelegator();
		String countryGeoId= (String)context.get("countryGeoId");
		List<GenericValue> listCityName=FastList.newInstance();
		if(countryGeoId!=null){
			List<EntityCondition> conditions= FastList.newInstance();
			conditions.add(EntityCondition.makeCondition("geoId",EntityOperator.EQUALS,countryGeoId));
			try {
				listCityName =delegator.findList("GeoAssocView",EntityCondition.makeCondition(conditions,EntityJoinOperator.AND),null,null,null,false);
			} catch (GenericEntityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		Map<String, Object> retMap = FastMap.newInstance();
		retMap.put("listCityName", listCityName);
		return retMap;
	}
	
	/*public static Map<String, Object> createNtfSalesmanPgRecruitment(DispatchContext dctx, Map<String, Object> context){
		Delegator delegator = dctx.getDelegator();
		LocalDispatcher dispatcher = dctx.getDispatcher();
		String workTrialProposalId = (String) context.get("workTrialProposalId");
		String newStatusId = (String) context.get("statusId");
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		Map<String, Object> ntfCtx = FastMap.newInstance();
		Locale locale = (Locale)context.get("locale");
		ntfCtx.put("userLogin", userLogin);
		try {
			GenericValue workTrialProposal = delegator.findOne("WorkTrialProposal", UtilMisc.toMap("workTrialProposalId", workTrialProposalId), false);
			if(UtilValidate.isEmpty(workTrialProposal)){
				ServiceUtil.returnError(UtilProperties.getMessage("RecruitmentUiLabels", "NotFoundProposalSalesmanPG",UtilMisc.toMap("workTrialProposalId", workTrialProposalId), locale));
			}
			String workingPartyId = workTrialProposal.getString("workingPartyId");
			String mgrOfWorkingPartyId = PartyUtil.getManagerbyOrg(workingPartyId, delegator);
			if(newStatusId.equals("ASM_APPROVAL_WAIT")){
				//String partyId = userLogin.getString("partyId");
				//GenericValue dept = PartyUtil.getDepartmentOfEmployee(delegator, workingPartyId);
				GenericValue parentOfCurr = PartyUtil.getParentOrgOfDepartmentCurr(delegator, workingPartyId);
				List<GenericValue> workTrialPropWait = delegator.findByAnd("WorkTrialProposal", UtilMisc.toMap("statusId", newStatusId, "workingPartyId", workingPartyId), null, false);
				if(UtilValidate.isEmpty(workTrialPropWait)){
					ntfCtx.put("header", "Phê duyệt đề xuất tuyển dụng Salesman/PG");
					ntfCtx.put("dateTime", UtilDateTime.nowTimestamp());
					ntfCtx.put("state", "open");
					ntfCtx.put("action", "CheckProposeSalemanPg");
					String managerId = PartyUtil.getManagerbyOrg(parentOfCurr.getString("partyIdFrom"), delegator);
					ntfCtx.put("partyId", managerId);
					dispatcher.runSync("createNotification", ntfCtx);
				}
			}else if(newStatusId.equals("AWT_APPROVED") || newStatusId.equals("AWT_CANCELED")){
				ntfCtx.put("header", "Đề xuất tuyển dụng Salesman/PG đã được phê duyệt");
				ntfCtx.put("dateTime", UtilDateTime.nowTimestamp());
				ntfCtx.put("state", "open");
				ntfCtx.put("action", "FindSalesmanPg");
				ntfCtx.put("partyId", mgrOfWorkingPartyId);
				ntfCtx.put("targetLink", "workTrialProposalId=" + workTrialProposalId);
				dispatcher.runSync("createNotification", ntfCtx);
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return ServiceUtil.returnSuccess();
	}*/
	
	/*public static Map<String, Object> createSalesmanPgInOrg(DispatchContext dctx, Map<String, Object> context){
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		String workTrialProposalId = (String)context.get("workTrialProposalId");
		String emplPositionTypeId = (String)context.get("emplPositionTypeId");
		String workingPartyId = (String)context.get("workingPartyId");
		Locale locale = (Locale)context.get("locale");
		TimeZone timeZone = (TimeZone)context.get("timeZone");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		try {
			GenericValue wtp = delegator.findOne("WorkTrialProposal", UtilMisc.toMap("workTrialProposalId", workTrialProposalId), false);
			Timestamp fromDate = wtp.getTimestamp("fromDate");
			Long trialTime = wtp.getLong("trialTime");
			if(UtilValidate.isEmpty(trialTime)){
				//FIXME default trialTime should place in general.propeerties
				trialTime = 2L;
			}
			Timestamp monthTrialEnd = UtilDateTime.getMonthStart(fromDate, 0, trialTime.intValue(), timeZone, locale);
			Timestamp thruDate = UtilDateTime.getMonthEnd(monthTrialEnd, timeZone, locale);
			
			List<GenericValue> workTrialApp = delegator.findByAnd("WorkTrialApplicant", UtilMisc.toMap("workTrialProposalId", workTrialProposalId), null, false);
			//FIXME need improve WorkTrialApplicant entity
			if(UtilValidate.isNotEmpty(workTrialApp)){
				String emplPartyId = EntityUtil.getFirst(workTrialApp).getString("applicantId");
				if(UtilValidate.isNotEmpty(emplPartyId)){
					//create emplPosition and fulfillment
					Map<String, Object> ctx = FastMap.newInstance();
					ctx.put("emplPositionTypeId", emplPositionTypeId);
					ctx.put("internalOrgId", workingPartyId);
					ctx.put("partyId", emplPartyId);
					ctx.put("actualFromDate", fromDate);
					ctx.put("actualThruDate", thruDate);
					ctx.put("userLogin", userLogin);
					dispatcher.runSync("createEmplPositionAndFulfillment", ctx);
					//create Employment and PartyRel
					Map<String, Object> partyRelMap = FastMap.newInstance();
					partyRelMap.put("partyId", emplPartyId);
					partyRelMap.put("partyIdFrom", workingPartyId);
					partyRelMap.put("partyIdTo", emplPartyId);
					partyRelMap.put("roleTypeIdFrom", "INTERNAL_ORGANIZATIO");
					partyRelMap.put("roleTypeIdTo", "EMPLOYEE");
					partyRelMap.put("partyRelationshipTypeId", "EMPLOYMENT");
					partyRelMap.put("fromDate", fromDate);
					partyRelMap.put("thruDate", thruDate);
					partyRelMap.put("userLogin", userLogin);
					dispatcher.runSync("createPartyRelationshipAndRole", partyRelMap);					
					dispatcher.runSync("createEmployment", ServiceUtil.setServiceFields(dispatcher, "createEmployment", partyRelMap, userLogin, timeZone, locale));
				}
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (GeneralServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return ServiceUtil.returnSuccess();
	}*/
	
	public static  Map<String, Object> sendNotifyToHr(DispatchContext dpct, Map<String, Object> context) throws Exception{
		Delegator delegator= dpct.getDelegator();
		GenericValue user= (GenericValue)context.get("userLogin");
		Locale locale= (Locale)context.get("locale");
		Map<String, Object> result= FastMap.newInstance();
		String headHrr= PartyUtil.getHrmAdmin(delegator);
		String header= "Báo cáo danh sách nhân viên Salesman/PG đã tuyển dụng";
		String action="CheckListEmployeePGSalesMan";
		String state= "open";
		Timestamp  dateTime=new Timestamp(new Date().getTime());
		String targetLink="";
		result.put("partyId", headHrr);
		result.put("header", header);
		result.put("state",state );
		result.put("action",action );
		result.put("dateTime",dateTime );
		result.put("targetLink", targetLink);
		result.put("userLogin", user);
		dpct.getDispatcher().runSync("createNotification", result);
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(
				resourceNoti, "Send success", locale));
	}
	
	public static  Map<String, Object> checkedReportListApproved(DispatchContext dpct, Map<String, Object> context) throws Exception{
		Delegator delegator= dpct.getDelegator();
		Locale locale= (Locale)context.get("locale");
		String proposeId= (String)context.get("proposeId");
		String check= (String)context.get("check");
		if(check!=null&&check.equals("Y")){
			GenericValue propose= delegator.findOne("ProposeEmployeePg", UtilMisc.toMap("proposeId",proposeId), false);
			propose.put("reported", "Y");
			propose.store();
		}
		return ServiceUtil.returnSuccess(UtilProperties.getMessage(
				resourceNoti, "Send success", locale));
		
	}
	public static Map<String, Object> reportSalesmanPgRecruitment(DispatchContext dctx, Map<String, Object> context){
		LocalDispatcher dispatcher = dctx.getDispatcher();
		Delegator delegator = dctx.getDelegator();
		TimeZone timeZone = (TimeZone) context.get("timeZone");
		GenericValue userLogin = (GenericValue)context.get("userLogin");
		Locale locale = (Locale) context.get("locale");
		List<String> emplPosType = FastList.newInstance();
		Calendar cal = Calendar.getInstance(timeZone, locale);
		cal.setTime(UtilDateTime.nowDate());
		emplPosType.add("SALESMAN");
		emplPosType.add("PROMOTION_GIRL");
		Timestamp fromDate = UtilDateTime.getMonthStart(UtilDateTime.nowTimestamp(), 0, -1);
		Timestamp thruDate = UtilDateTime.getMonthEnd(fromDate, timeZone, locale);
		Map<String, Object> ctxNtf = FastMap.newInstance();
		List<EntityCondition> conditions = FastList.newInstance();
		conditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.GREATER_THAN_EQUAL_TO, fromDate));
		conditions.add(EntityCondition.makeCondition("fromDate", EntityOperator.LESS_THAN_EQUAL_TO, thruDate));
		conditions.add(EntityCondition.makeCondition("statusId", "AWT_APPROVED"));
		conditions.add(EntityCondition.makeCondition("emplPositionTypeId", EntityOperator.IN, emplPosType));
		try {
			List<GenericValue> workTrialProposalList = delegator.findList("WorkTrialProposal", EntityCondition.makeCondition(conditions, EntityOperator.AND), null, null, null, false);
			if(UtilValidate.isNotEmpty(workTrialProposalList)){
				ctxNtf.put("userLogin", userLogin);
				ctxNtf.put("header", "Salesman/PG được tuyển trong tháng " + (cal.get(Calendar.MONTH) + 1) + "/" + cal.get(Calendar.YEAR));
				ctxNtf.put("action", "FindSalesmanPg");
				ctxNtf.put("dateTime", UtilDateTime.nowTimestamp());
				ctxNtf.put("state", "open");
				String targetLink = "statusId=AWT_APPROVED;fromDate_fld0_op=greaterThanFromDayStart;fromDate_fld0_value=" 
									+ fromDate + ";fromDate_fld1_op=upThruDay;fromDate_fld1_value=" + thruDate;
				ctxNtf.put("targetLink", targetLink);
				List<String> workingPartyList = EntityUtil.getFieldListFromEntityList(workTrialProposalList, "workingPartyId", true);
				List<String> partyNtf = FastList.newInstance();
				partyNtf.add(PartyUtil.getHrmAdmin(delegator));
				for(String partyId: workingPartyList){
					//partyNtf.add(PartyUtil.getManagerbyOrg(partyId, delegator));
					GenericValue asmDept = PartyUtil.getParentOrgOfDepartmentCurr(delegator, partyId);					
					if(UtilValidate.isNotEmpty(asmDept)){
						GenericValue rsmDept = PartyUtil.getParentOrgOfDepartmentCurr(delegator, asmDept.getString("partyIdFrom"));
						if(UtilValidate.isNotEmpty(rsmDept)){
							partyNtf.add(PartyUtil.getManagerbyOrg(rsmDept.getString("partyIdFrom"), delegator));
							GenericValue csmDept = PartyUtil.getParentOrgOfDepartmentCurr(delegator, rsmDept.getString("partyIdFrom"));
							if(UtilValidate.isNotEmpty(csmDept)){
								partyNtf.add(PartyUtil.getManagerbyOrg(csmDept.getString("partyIdFrom"), delegator));
							}
						}
					}
				}
				for(String tempParty: partyNtf){
					ctxNtf.put("partyId", tempParty);
					dispatcher.runSync("createNotification", ctxNtf);
				}
			}
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ServiceUtil.returnSuccess();
	}
	
	public static String createEmplProfile(HttpServletRequest request, HttpServletResponse response){
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		LocalDispatcher dispatcher = (LocalDispatcher)request.getAttribute("dispatcher");
		HttpSession session = request.getSession();
		GenericValue userLogin = (GenericValue) session.getAttribute("userLogin");
		Locale locale = UtilHttp.getLocale(request);
		TimeZone timeZone = UtilHttp.getTimeZone(request);
		Map<String, Object> parameterMap = UtilHttp.getParameterMap(request);
		Map<String, Object> resultsService = FastMap.newInstance();
		//Map<String, Object> recruitmentResults = FastMap.newInstance();
		//int rowDelimiterLength = UtilHttp.MULTI_ROW_DELIMITER.length();
		String errorMsg = UtilProperties.getMessage("RecruitmentUiLabels", "ErrorCreateEmplInfo", locale);
		try {
			String hrmAdmin = PartyUtil.getHrmAdmin(delegator);
			GenericValue hrmUserLogin = EntityUtil.getFirst(delegator.findByAnd("UserLogin", UtilMisc.toMap("partyId", hrmAdmin), null, false));
			Map<String, Object> recruitmentIfoCtx = ServiceUtil.setServiceFields(dispatcher, "createRecruitmentInfo", parameterMap, userLogin, timeZone, locale);
			recruitmentIfoCtx.put("timeZone", timeZone);
			//Map<String, Object> personCtx = ServiceUtil.setServiceFields(dispatcher, "createPerson", parameterMap, userLogin, timeZone, locale);
			//Map<String, Object> personResults = dispatcher.runSync("createPerson", personCtx);
			resultsService = dispatcher.runSync("createRecruitmentInfo", recruitmentIfoCtx);
			if(ServiceUtil.isSuccess(resultsService)){
				String partyId = (String)resultsService.get("partyId");
				EmployeeHelper.createEmplRelatedInfo(dispatcher, partyId, parameterMap, hrmUserLogin, timeZone, locale);
				/*Map<String, Object> educationProcessMap = FastMap.newInstance();
				Map<String, Object> workingProcessMap = FastMap.newInstance();
				Map<String, Object> familyBackgroundMap = FastMap.newInstance();
				Map<String, Object> skillTypeMap = FastMap.newInstance();
				
				ModelService educationProcessService = dispatcher.getDispatchContext().getModelService("createPersonEducation");
				ModelService workingProcessService = dispatcher.getDispatchContext().getModelService("createPersonWorkingProcess");
				ModelService familyBackGroundService = dispatcher.getDispatchContext().getModelService("createPersonFamilyBackground");
				ModelService partySkillService = dispatcher.getDispatchContext().getModelService("HRCreatePartySkill");
				
				int educationCount = 0;
				int workingCount = 0;
				int familyBackgroundCount = 0;
				int skillTypeCount = 0;
				for(String parameterName: parameterMap.keySet()){
					int rowDelimiterIndex = (parameterName != null? parameterName.indexOf(UtilHttp.MULTI_ROW_DELIMITER): -1);
					if(rowDelimiterIndex > 0){
						String param = parameterName.substring(0, rowDelimiterIndex);
						if(partySkillService.getInParamNames().contains(param)){
							skillTypeMap.put(parameterName, parameterMap.get(parameterName));
						}else if(educationProcessService.getInParamNames().contains(param)){
							educationProcessMap.put(parameterName, parameterMap.get(parameterName));
						}else if(workingProcessService.getInParamNames().contains(param)){
							workingProcessMap.put(parameterName, parameterMap.get(parameterName));
						}else if (familyBackGroundService.getInParamNames().contains(param)) {
							familyBackgroundMap.put(parameterName, parameterMap.get(parameterName));
						}
					}
				}
				if(UtilValidate.isNotEmpty(educationProcessMap)){
					educationCount = UtilHttp.getMultiFormRowCount(educationProcessMap);
				}
				if(UtilValidate.isNotEmpty(workingProcessMap)){
					workingCount = UtilHttp.getMultiFormRowCount(workingProcessMap);
				}
				if(UtilValidate.isNotEmpty(familyBackgroundMap)){
					familyBackgroundCount = UtilHttp.getMultiFormRowCount(familyBackgroundMap);
				}
				if(UtilValidate.isNotEmpty(skillTypeMap)){
					skillTypeCount = UtilHttp.getMultiFormRowCount(skillTypeMap);
				}
				if(educationCount > 0){
					for(int i = 0; i < educationCount; i++){
						Map<String, Object> createEducationCtx = FastMap.newInstance();
						createEducationCtx.put("userLogin", userLogin);
						createEducationCtx.put("partyId", partyId);
						String currSuffix = UtilHttp.MULTI_ROW_DELIMITER + i;
						for(Entry<String, Object>entry: educationProcessMap.entrySet()){
							if(entry.getKey().endsWith(currSuffix)){
								createEducationCtx.put(entry.getKey().substring(0, entry.getKey().indexOf(currSuffix)), entry.getValue());
							}
						}
						dispatcher.runSync("createPersonEducation", educationProcessService.makeValid(createEducationCtx, ModelService.IN_PARAM, true, null, timeZone, locale));
					}
				}
				if(workingCount > 0){
					for(int i = 0; i < workingCount; i++){
						Map<String, Object> createWorkingCtx = FastMap.newInstance();
						createWorkingCtx.put("userLogin", userLogin);
						createWorkingCtx.put("partyId", partyId);
						String currSuffix = UtilHttp.MULTI_ROW_DELIMITER + i;
						for(Entry<String, Object>entry: workingProcessMap.entrySet()){
							if(entry.getKey().endsWith(currSuffix)){
								createWorkingCtx.put(entry.getKey().substring(0, entry.getKey().indexOf(currSuffix)), entry.getValue());
							}
						}
						dispatcher.runSync("createPersonWorkingProcess", workingProcessService.makeValid(createWorkingCtx, ModelService.IN_PARAM, true, null, timeZone, locale));
					}
				}
				if(familyBackgroundCount > 0){
					for(int i = 0; i < familyBackgroundCount; i++){
						Map<String, Object> familyBackgroundCtx = FastMap.newInstance();
						familyBackgroundCtx.put("partyId", partyId);
						familyBackgroundCtx.put("userLogin", userLogin);
						String currSuffix = UtilHttp.MULTI_ROW_DELIMITER + i;
						for(Entry<String, Object> entry: familyBackgroundMap.entrySet()){
							if(entry.getKey().endsWith(currSuffix)){
								familyBackgroundCtx.put(entry.getKey().substring(0, entry.getKey().indexOf(currSuffix)), entry.getValue());
							}
						}
						dispatcher.runSync("createPersonFamilyBackground", familyBackGroundService.makeValid(familyBackgroundCtx, ModelService.IN_PARAM, true, null, timeZone, locale));
					}
				}
				if(skillTypeCount > 0){
					for(int i = 0; i < skillTypeCount; i++){
						Map<String, Object> createSkillTypeCtx = FastMap.newInstance();
						createSkillTypeCtx.put("partyId", partyId);
						createSkillTypeCtx.put("userLogin", hrmUserLogin);
						String currSuffix = UtilHttp.MULTI_ROW_DELIMITER + i;
						for(Entry<String, Object> entry: skillTypeMap.entrySet()){
							if(entry.getKey().endsWith(currSuffix)){
								createSkillTypeCtx.put(entry.getKey().substring(0, entry.getKey().indexOf(currSuffix)), entry.getValue());
							}
						}
						dispatcher.runSync("HRCreatePartySkill", partySkillService.makeValid(createSkillTypeCtx, ModelService.IN_PARAM, true, null, timeZone, locale));
					}
				}*/
				Map<String, Object> emplContactInfoCtx = ServiceUtil.setServiceFields(dispatcher, "createEmplContactInfo", parameterMap, hrmUserLogin, timeZone, locale);
				emplContactInfoCtx.put("partyId", partyId);
				resultsService = dispatcher.runSync("createEmplContactInfo", emplContactInfoCtx);
				if(!ServiceUtil.isSuccess(resultsService)){
					request.setAttribute("_ERROR_MESSAGE_", resultsService.get(ModelService.ERROR_MESSAGE));
					return "error";
				}
			}else{
				request.setAttribute("_ERROR_MESSAGE_", resultsService.get(ModelService.ERROR_MESSAGE));
				return "error";
			}
			
		} catch (GeneralServiceException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
			String message = (String)resultsService.get(ModelService.ERROR_MESSAGE);
			if(UtilValidate.isEmpty(message)){
				message = errorMsg;
			}
			request.setAttribute("_ERROR_MESSAGE_", message);
			return "error";
		} catch (GenericServiceException e) {
			// TODO Auto-generated catch block
			String message = (String)resultsService.get(ModelService.ERROR_MESSAGE);
			if(UtilValidate.isEmpty(message)){
				message = errorMsg;
			}
			request.setAttribute("_ERROR_MESSAGE_", message);
			e.printStackTrace();
			return "error";
		} catch (GenericEntityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();			
			request.setAttribute("_ERROR_MESSAGE_", errorMsg);
			return "error";
		}
		request.setAttribute("_EVENT_MESSAGE_", UtilProperties.getMessage("RecruitmentUiLabels", "createEmployeeInfoSuccessful", locale));
		return "success";
	}
}
