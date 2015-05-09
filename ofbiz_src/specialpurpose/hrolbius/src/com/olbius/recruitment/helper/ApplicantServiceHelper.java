package com.olbius.recruitment.helper;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GeneralServiceException;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

public class ApplicantServiceHelper {
	public static String insertApplicant(DispatchContext dpctx,
			Map<String, Object> context)
			throws GenericEntityException, GenericServiceException, GeneralServiceException {

		Delegator delegator = dpctx.getDelegator();
		LocalDispatcher dispatcher = dpctx.getDispatcher();

		Map<String, Object> results = dispatcher.runSync("createPerson", ServiceUtil.setServiceFields(dispatcher, "createPerson", context, (GenericValue)context.get("userLogin"), (TimeZone)context.get("timeZone"), (Locale)context.get("locale")));
		String partyId = (String) results.get("partyId");
		GenericValue partyRole = delegator.makeValue("PartyRole");
		partyRole.set("partyId", partyId);
		partyRole.set("roleTypeId", "APPLICANT");
		partyRole.create();
		return partyId;
	}

	public static void insertPostalAddress(DispatchContext dpctx,
			Map<String, ? extends Object> context)
			throws GenericEntityException {

		Delegator delegator = dpctx.getDelegator();

		// Create PostalAddress
		String address1 = (String) context.get("address1");
		String partyId = (String) context.get("partyId");
		String countryGeoId = (String) context.get("countryGeoId");
		String stateProvinceGeoId = (String) context.get("stateProvinceGeoId");
		Date date = new Date();
		Timestamp currentTime = new Timestamp(date.getTime());
		String contactMechId = delegator.getNextSeqId("ContactMech");

		GenericValue partyContactMech = delegator.makeValue("PartyContactMech");
		GenericValue contactMech = delegator.makeValue("ContactMech");
		GenericValue postalAddress = delegator.makeValue("PostalAddress");

		partyContactMech.set("partyId", partyId);
		partyContactMech.set("contactMechId", contactMechId);
		partyContactMech.set("fromDate", currentTime);

		contactMech.set("contactMechId", contactMechId);
		contactMech.set("contactMechTypeId", "POSTAL_ADDRESS");

		postalAddress.set("contactMechId", contactMechId);
		postalAddress.set("address1", address1);
		postalAddress.set("countryGeoId", countryGeoId);
		postalAddress.set("stateProvinceGeoId", stateProvinceGeoId);

		contactMech.create();
		postalAddress.create();
		partyContactMech.create();

	}

	public static void insertTelecomAddress(DispatchContext dpctx,
			Map<String, ? extends Object> context)
			throws GenericEntityException {
		Delegator delegator = dpctx.getDelegator();

		GenericValue partyContactMech = delegator.makeValue("PartyContactMech");
		GenericValue contactMech = delegator.makeValue("ContactMech");
		GenericValue telecomNumber = delegator.makeValue("TelecomNumber");

		String countryCode = (String) context.get("countryCode");
		String areaCode = (String) context.get("areaCode");
		String contactNumber = (String) context.get("contactNumber");
		String partyId = (String) context.get("partyId");
		Date date = new Date();
		Timestamp currentTime = new Timestamp(date.getTime());

		String contactMechId = delegator.getNextSeqId("ContactMech");

		contactMech.set("contactMechId", contactMechId);
		contactMech.set("contactMechTypeId", "TELECOM_NUMBER");

		telecomNumber.set("contactMechId", contactMechId);
		telecomNumber.set("countryCode", countryCode);
		telecomNumber.set("areaCode", areaCode);
		telecomNumber.set("contactNumber", contactNumber);

		partyContactMech.set("partyId", partyId);
		partyContactMech.set("contactMechId", contactMechId);
		partyContactMech.set("fromDate", currentTime);

		contactMech.create();
		telecomNumber.create();
		partyContactMech.create();
	}

	public static void insertEmailAddress(DispatchContext dpctx,
			Map<String, Object> context) throws GenericEntityException {

		Delegator delegator = dpctx.getDelegator();

		GenericValue partyContactMech = delegator.makeValue("PartyContactMech");
		GenericValue contactMech = delegator.makeValue("ContactMech");

		String emailAddress = (String) context.get("emailAddress");
		String contactMechId = delegator.getNextSeqId("ContactMech");
		String partyId = (String) context.get("partyId");
		Date date = new Date();
		Timestamp currentTime = new Timestamp(date.getTime());

		contactMech.set("contactMechId", contactMechId);
		contactMech.set("contactMechTypeId", "EMAIL_ADDRESS");
		contactMech.set("infoString", emailAddress);

		partyContactMech.set("partyId", partyId);
		partyContactMech.set("contactMechId", contactMechId);
		partyContactMech.set("fromDate", currentTime);

		contactMech.create();
		partyContactMech.create();
	}

	public static void insertEmplApplication(DispatchContext dpctx,
			Map<String, Object> context) throws GenericEntityException {

		Delegator delegator = dpctx.getDelegator();

		GenericValue emplApp = delegator
				.makeValue("EmploymentApplication");

		String partyId = (String) context.get("partyId");
		String jobRequestId = (String) context.get("jobRequestId");
		
		String applicationId = delegator.getNextSeqId("EmploymentApplication");
		emplApp.set("applicationId", applicationId);
		emplApp.set("applyingPartyId", partyId);
		emplApp.set("jobRequestId", jobRequestId);
		emplApp.set("potential", "NO");
		emplApp.create();
	}
}
