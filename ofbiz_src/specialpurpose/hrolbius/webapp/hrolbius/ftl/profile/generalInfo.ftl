<div id="personal-info" class="tab-pane active widget-body">
	<div id="personal-info-1" class="row-fluid mgt20">
		<div class="span2">
			<#if !personalImage?has_content>
				<#assign personalImage = "/aceadmin/assets/avatars/no-avatar.png">
			</#if>
			<img class="personal-image" id="personal-image" src="${personalImage}" alt="Avatar">
			<span class="personal-name"><a href="/hrolbius/control/editperson?partyId=${parameters.partyId}" title="${uiLabelMap.CommonUpdate}">${lookupPerson.lastName?if_exists} ${lookupPerson.middleName?if_exists} ${lookupPerson.firstName?if_exists}</a></span>
		</div>
		<div class="span4">
			<form class="form-horizontal">
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.EmployeeId}:</label>
					<div class="controls">
						<span>${lookupPerson.partyId}</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.FormFieldTitle_gender}:</label>
					<div class="controls">
						<#if lookupPerson.gender?exists>
							<#if lookupPerson.gender == "M">
								<span>${uiLabelMap.CommonMale}</span>
							<#elseif lookupPerson.gender == "F">
								<span>${uiLabelMap.CommonFemale}</span>
							<#else>
								<span>${uiLabelMap.CommonOther}</span>
							</#if>
						<#else>
							&nbsp;
						</#if>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.FormFieldTitle_birthDate}:</label>
					<div class="controls">
						<span>
							<#if lookupPerson.birthDate?exists>
								${lookupPerson.birthDate?date}
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.certProvisionId}:</label>
					<div class="controls">
						<span>${lookupPerson.idNumber?if_exists}&nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.HrolbiusidIssuePlace}:</label>
					<div class="controls">
						<span>${lookupPerson.idIssuePlace?if_exists}&nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.HrolbiusidIssueDate}:</label>
					<div class="controls">
						<span>${lookupPerson.idIssueDate?if_exists} &nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.MaritalStatus}:</label>
					<div class="controls">
						<span>
							<#if lookupPerson.maritalStatus?exists>
								<#assign marialStatus = delegator.findOne("MaritalStatus", Static["org.ofbiz.base.util.UtilMisc"].toMap("maritalStatusId", lookupPerson.maritalStatus), false)>
								${marialStatus.description}
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.NumberChildren}:</label>
					<div class="controls">
						<span>
							${lookupPerson.numberChildren?if_exists}&nbsp;
						</span>
					</div>
				</div>
			</form>
		</div>
		<div class="span6">
			<form class="form-horizontal pdl20">
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.NativeLand}:</label>
					<div class="controls">
						<span>${lookupPerson.nativeLand?if_exists}&nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.EthnicOrigin}:</label>
					<div class="controls">
						<#if lookupPerson.ethnicOrigin?exists && lookupPerson.ethnicOrigin?has_content>
							<#assign eth= delegator.findOne("EthnicOrigin",Static["org.ofbiz.base.util.UtilMisc"].toMap("ethnicOriginId",lookupPerson.ethnicOrigin), false) >
							<span>${eth.description}&nbsp;</span>
							<#else>
							<span>&nbsp;</span>
						</#if>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.HrolbiusReligion}:</label>
					<div class="controls">
						<span>
							<#if lookupPerson.religion?exists && lookupPerson.religion?has_content>
								<#assign religion= delegator.findOne("Religion",Static["org.ofbiz.base.util.UtilMisc"].toMap("religionId",lookupPerson.religion), false)>
								${religion.description}
							<#else>
								${uiLabelMap.CommonNo}
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.HrolbiusNationality}:</label>
					<div class="controls">
						<span>
							<#if lookupPerson.nationality?exists>
								<#assign nation = delegator.findOne("Nationality", Static["org.ofbiz.base.util.UtilMisc"].toMap("nationalityId", lookupPerson.nationality), false)>
								${nation.description}
							<#else>
							&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.FormFieldTitle_passportNumber}:</label>
					<div class="controls">
						<span>${lookupPerson.passportNumber?if_exists}&nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.PassPortIssuePlace}:</label>
					<div class="controls">
						<span>${lookupPerson.passportIssuePlace?if_exists}&nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.DateOfIssuePassport}:</label>
					<div class="controls">
						<span>${lookupPerson.passportIssueDate?if_exists}&nbsp;</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.PartyPassportExpireDate}:</label>
					<div class="controls">
						<span>
							<#if lookupPerson.passportExpiryDate?exists>
								${lookupPerson.passportExpiryDate?date}
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
			</form>
		</div>
	</div>
	<hr/>
	<div id="personal-info-2" class="row-fluid mgt20">
		<div class="span12 boder-all-profile">
			<span class="text-header">${uiLabelMap.HREmplFromPositionType}</span>
			<form class="form-horizontal">
				<!-- <div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">Công ty:</label>
					<div class="controls">
						<span>Delys</span>
					</div>
				</div> -->
				<!-- <div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">Chi nhánh:</label>
					<div class="controls">
						<span>Hà Nội</span>
					</div>
				</div> -->
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.Department}:</label>
					<div class="controls">
						<span>
							<#if employmentData.emplPosition?exists>
							<#assign department = delegator.findOne("PartyGroup", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", employmentData.emplPosition.partyId), false)>
							${department.groupName?if_exists}&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.FormFieldTitle_position}:</label>
					<div class="controls">
						<span>
							<#if employmentData.emplPositionType?exists>
								${employmentData.emplPositionType.description}
							</#if>
						</span>
					</div>
				</div>
			</form>
		</div>
	</div>
	<div id="personal-info-3" class="row-fluid mgt20">
		<div class="span12 boder-all-profile">
			<span class="text-header">${uiLabelMap.PartyContactMechs}</span>
			<form class="form-horizontal">
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.PermanentResidence}:</label>
					<div class="controls">
						<span>
							<#if permanentResidence.contactMechId?has_content>
								<#assign permanent = delegator.findOne("PostalAddress", Static["org.ofbiz.base.util.UtilMisc"].toMap("contactMechId", permanentResidence.contactMechId), false)>
								 ${permanent.address1}&#44;
								 <#if permanent.wardGeoId?exists>
									<#assign ward = delegator.findOne("Geo", Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId", permanent.wardGeoId), false)>
									<#if ward?exists && ward.geoId != "_NA_">
										${ward.geoName?if_exists}&#44;
									</#if>
								 </#if>
								 <#if permanent.districtGeoId?exists>
									<#assign district = delegator.findOne("Geo", Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId", permanent.districtGeoId), false)>
									<#if district?exists && district.geoId != "_NA_">
										${district.geoName?if_exists}&#44;
									</#if>
								 </#if>
								 <#if permanent.stateProvinceGeoId?exists>
									 <#assign stateProvince = delegator.findOne("Geo", Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId", permanent.stateProvinceGeoId), false)>
									 ${stateProvince.geoName?if_exists}&#46;
								 </#if>
							 <#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.ContactAddress}:</label>
					<div class="controls">
						<span><#if currentResidence.contactMechId?has_content>
								<#assign residence = delegator.findOne("PostalAddress", Static["org.ofbiz.base.util.UtilMisc"].toMap("contactMechId", currentResidence.contactMechId), false)>
								 ${residence.address1}&#44;
								 <#if residence.wardGeoId?exists>
									<#assign ward = delegator.findOne("Geo", Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId", residence.wardGeoId), false)>
									<#if ward?exists && ward.geoId != "_NA_">
										${ward.geoName?if_exists}&#44;
									</#if>
								 </#if>
								 <#if residence.districtGeoId?exists>
									<#assign district = delegator.findOne("Geo", Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId", residence.districtGeoId), false)>
									<#if district?exists && district.geoId != "_NA_">
										${district.geoName?if_exists}&#44;
									</#if>
								 </#if>
								 <#assign stateProvince = delegator.findOne("Geo", Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId", residence.stateProvinceGeoId), false)>
								 ${stateProvince.geoName?if_exists}&#46;
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.CommonEmail}:</label>
					<div class="controls">
						<span>
							${partyEmail.emailAddress?if_exists}&nbsp;
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.PhoneNumber}:</label>
					<div class="controls">
						<span>
							<#if phoneNumber?has_content>
								${phoneNumber.countryCode?if_exists} ${phoneNumber.areaCode?if_exists} ${phoneNumber.contactNumber?if_exists}&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.PhoneMobile}:</label>
					<div class="controls">
						<span>
							<#if mobileNumber?has_content>
								${mobileNumber.countryCode?if_exists} ${mobileNumber.areaCode?if_exists} ${mobileNumber.contactNumber?if_exists}&nbsp;
							</#if>
						</span>
					</div>
				</div>
			</form>
		</div>
		<#--<div class="span6 boder-all-profile">
			<span class="text-header">${uiLabelMap.InformationQualifications}</span>
			<form class="form-horizontal">
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.TrainingLevel}:</label>
					<div class="controls">
						<#if partyEducation?has_content>
							<#assign education = partyEducation.get(0)>
						<#else>
							&nbsp;
						</#if>
						<span>
							<#if education?exists>
								${education.description}
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.HRSpecialization}:</label>
					<div class="controls">
						<span>
							<#if education?exists>
								<#assign major = delegator.findOne("Major", Static["org.ofbiz.base.util.UtilMisc"].toMap("majorId", education.majorId), false)>
								${major.description?if_exists}
							 <#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.UniCertificateId}:</label>
					<div class="controls">
						<span>
							<#if education?exists>
								<#assign classificationType = delegator.findOne("DegreeClassificationType", Static["org.ofbiz.base.util.UtilMisc"].toMap("classificationTypeId", education.classificationTypeId), false)>
								${classificationType.description?if_exists}
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label" for="form-field-1">${uiLabelMap.HrolbiusGraduationYear}:</label>
					<div class="controls">
						<span>
							<#if education?exists>
								${education.thruDate?string.yyyy}
							<#else>
								&nbsp;
							</#if>
						</span>
					</div>
				</div>
			</form>
		</div>-->
	</div>
	<div id="personal-info-4" class="row-fluid mgt20">
		<div class="span12 boder-all-profile">
			<span class="text-header">${uiLabelMap.EmergencyContactInformation}</span>
			<form class="form-horizontal">
				<#if personFamilyBackgroundEmercy?has_content >
					<div class="control-group no-left-margin">
						<label class="control-label" for="form-field-1">${uiLabelMap.FullName}:</label>
						<div class="controls">
							<#assign familyPerson = delegator.findOne("Person", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", personFamilyBackgroundEmercy[0].partyFamilyId), false)>
							<span>
								${familyPerson.firstName?if_exists}
							${familyPerson.middleName?if_exists}
							${familyPerson.lastName?if_exists}
							&nbsp
						</span>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<label class="control-label" for="form-field-1">${uiLabelMap.HRRelationship}:</label>
						<div class="controls">
							<#assign partyRelationshipType = delegator.findOne("PartyRelationshipType", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyRelationshipTypeId", personFamilyBackgroundEmercy[0].partyRelationshipTypeId), false)>
							<span>${partyRelationshipType.partyRelationshipName?if_exists}&nbsp</span>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<label class="control-label" for="form-field-1">${uiLabelMap.PhoneNumber}:</label>
						<div class="controls">
							<#assign telecomNbr = dispatcher.runSync("getPartyTelephone", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", personFamilyBackgroundEmercy[0].partyFamilyId, "contactMechPurposeTypeId", "PHONE_MOBILE", "userLogin", systemUserLogin))>
							<span>${telecomNbr.contactNumber?if_exists}&nbsp</span>
						</div>
					</div>
					<#else>
					<div class="control-group no-left-margin">
						<label class="control-label" for="form-field-1">${uiLabelMap.FullName}:</label>
						<div class="controls">
							<span>&nbsp
						</span>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<label class="control-label" for="form-field-1">${uiLabelMap.HRRelationship}:</label>
						<div class="controls">
							<span>&nbsp</span>
						</div>
					</div>
					<div class="control-group no-left-margin">
						<label class="control-label" for="form-field-1">${uiLabelMap.PhoneNumber}:</label>
						<div class="controls">
							<span>
							&nbsp
							</span>
						</div>
					</div>
				</#if>
			</form>
		</div>
	</div>
</div>