import java.sql.Timestamp;
import java.util.List;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.base.util.UtilMisc;

import javolution.util.FastList.*;
import javolution.util.FastMap;
import javolution.util.FastList;
import java.sql.Date;
import org.ofbiz.entity.util.EntityUtil;


lastName=null;
firstName=null;
gender=null;
birthDate=null;
address=null;
trainingLevel=null;
experience=null;
countryGeoId=null;
/*workTrialProposalId= parameters.workTrialProposalId;*/
//emplApp= null;
idNumber=null;
city=null;
phoneNumber=null;

address1=null;
stateProvinceGeoId=null;
bankAcountNumber=null;
bankId=null;
bankBrandId=null;
size=null;
bankAcountNumberCurr=null;
bankIdCurr=null;
bankBrandIdCurr=null;
telephone=FastList.newInstance();
postal= FastList.newInstance();
bank=FastList.newInstance();
partyId = parameters.partyId;
/*if(workTrialProposalId!=null){
	workTrialProposal= delegator.findOne("WorkTrialProposal",UtilMisc.toMap("workTrialProposalId",workTrialProposalId),false );
	context.emplPositionTypeId = workTrialProposal.getString("emplPositionTypeId"); 
}*/

if(UtilValidate.isNotEmpty(partyId)){
		
	GenericValue person= delegator.findOne("Person",UtilMisc.toMap("partyId",partyId),false);
	lastName=person.getString("lastName");
	firstName=person.getString("firstName");
	gender= person.getString("gender");
	Date birthDate=(Date)person.get("birthDate");
	trainingLevel= person.getString("trainingLevel");
	experience=person.getString("experience");
	idNumber=person.getString("idNumber");
	size=person.getString("size");
	
	//List<GenericValue> contact= EntityUtil.filterByDate(delegator.findList("PartyContactMech",EntityCondition.makeCondition("partyId",partyId),null,null,null,false));
	Map<String, Object> partyPostalAddress = dispatcher.runSync("getPartyPostalAddress", UtilMisc.toMap("partyId", partyId, "contactMechPurposeTypeId", "POSTAL_ADDRESS", "userLogin", userLogin));
	postalAddressContactmechId = (String) partyPostalAddress.get("contactMechId");
	address1 = (String) partyPostalAddress.get("address1");	
	countryGeoId = (String) partyPostalAddress.get("countryGeoId");
	stateProvinceGeoId = (String) partyPostalAddress.get("stateProvinceGeoId");
	
	Map<String, Object> partyTelNbr = dispatcher.runSync("getPartyTelephone", UtilMisc.toMap("partyId", partyId, "contactMechPurposeTypeId", "TELECOM_NUMBER", "userLogin", userLogin));
	telContactmechId = (String)partyTelNbr.get("contactMechId");
	countryCode = (String) partyTelNbr.get("countryCode");
	areaCode = (String) partyTelNbr.get("areaCode");
	contactNumber = (String) partyTelNbr.get("contactNumber");
	extension = (String) partyTelNbr.get("extension");
	
	List<GenericValue>	bvn= delegator.findList("PartyBank",EntityCondition.makeCondition("partyId",partyId),null,null,null,false)
	
	if(UtilValidate.isNotEmpty(bvn)){
		for(GenericValue ptb:bvn){
			detail = FastMap.newInstance();
			detail.put("bankAcountNumber", ptb.getString("bankAcountNumber"));
			detail.put("partyId", ptb.getString("partyId"));
			detail.put("bankId", ptb.getString("bankId"));
			detail.put("bankBrandId", ptb.getString("bankBrandId"));
			bank.add(detail);
		}
		if(UtilValidate.isNotEmpty(bank)){
			bankAcountNumber=bank.get(0).bankAcountNumber;
			bankId=bank.get(0).bankId;
			bankBrandId=bank.get(0).bankBrandId;
		}
	}
	context.postalAddressContactmechId = postalAddressContactmechId;
	context.telContactmechId = telContactmechId;
	context.city=stateProvinceGeoId;
}
context.bankAcountNumberCurr=bankAcountNumber;
context.bankIdCurr=bankId;
context.bankBrandIdCurr=bankBrandId;
context.size=size;
context.bankAcountNumber=bankAcountNumber;
context.bankId=bankId;
context.bankBrandId=bankBrandId;
context.address=address1;
context.countryGeoId=countryGeoId;
context.stateProvinceGeoId=stateProvinceGeoId;
context.phoneNumber=phoneNumber;

context.idNumber=idNumber;
context.experience=experience;
context.trainingLevel=trainingLevel;
context.birthDate=birthDate;
context.gender=gender;
context.lastName=lastName;
context.firstName=firstName;
context.partyId=partyId;