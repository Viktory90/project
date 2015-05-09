<div class="row-fluid">
	<div class="span12 margin-top30" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px">
		<div class="title-border">
			<span>${uiLabelMap.ContactInformation}</span>
		</div>
		<table cellspacing="0">
	   		<tbody>
	   			<tr>
					<td><label class="padding-bottom5 padding-right15" for="">${uiLabelMap.PhoneMobile}</label></td>
					<td>
						<input type="text" name="phone_mobile" id="phone_mobile"/>
					</td>
					
					<td><label class="padding-bottom5 padding-right15 margin-left30" for="primaryEmailAddress">${uiLabelMap.PrimaryEmailAddress}</label></td>
   							<td>
    								<input type="text" size="60" maxlength="255" name="primaryEmailAddress" id="primaryEmailAddress" />
   							</td>
				</tr>
				<tr>	
					<td><label class="padding-bottom5 padding-right15" for="phone_home">${uiLabelMap.PhoneHome}</label></td>
					<td>
						<input type="text" name="phone_home" id="phone_home"/>
					</td>
					<td><label class="padding-bottom5 padding-right15 margin-left30" for="otherEmailAddress">${uiLabelMap.OtherEmailAddress}</label></td>
   							<td>
    							<input type="text" size="60" maxlength="255" name="otherEmailAddress" id="otherEmailAddress" />
   							</td>
				</tr>
				
			</tbody>
   		</table>
	</div>
</div>
<div class="row-fluid">
	<div class="span12 margin-top30">
		<div class="span6" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px; margin-left: 0px;">
			<div class="title-border">
				<span>${uiLabelMap.PermanentResidence}</span>
			</div>
			<table cellspacing="0">
			<tr>
				<td>
					<label class="padding-bottom5 padding-right15 asterisk" for="address1_PermanentResidence">
						${uiLabelMap.PartyAddressLine}
					</label>
				</td>
				<td>
					<input type="text" name="address1_PermanentResidence" id="address1_PermanentResidence"/>
				</td>
			</tr>
			<tr>   
  							<td><label class="padding-bottom5 padding-right15" for="permanentResidence_countryGeoId">
  								${uiLabelMap.CommonCountry}</label></td>
  							<td>     
    							<select name="permanentResidence_countryGeoId" id="permanentResidence_countryGeoId">
      								${screens.render("component://common/widget/CommonScreens.xml#countries")}        
       								<#assign defaultCountryGeoId = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "country.geo.id.default")>
      								<option selected="selected" value="${defaultCountryGeoId}">
        								<#assign countryGeo = delegator.findOne("Geo",Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
        								${countryGeo.get("geoName",locale)}
      								</option>
    							</select>
  							</td>
						</tr>
						<tr>
  							<td><label class="padding-bottom5 padding-right15" for="createEmployee_stateProvinceGeoId">${uiLabelMap.PartyState}</label></td>
  							<td>
   	 							<select name="permanentResidence_stateProvinceGeoId" id="permanentResidence_stateProvinceGeoId">
    							</select>
  							</td>
						</tr>
						<tr>
  							<td>
  								<label class="padding-bottom5 padding-right15" for="permanentResidence_districtGeoId">
  									${uiLabelMap.PartyDistrictGeoId}
  								</label>
 								</td>
  							<td>
   	 							<select name="permanentResidence_districtGeoId" id="permanentResidence_districtGeoId">
    							</select>
  							</td>
						</tr>
						<tr>
  							<td>
  								<label class="padding-bottom5 padding-right15" for="permanentResidence_wardGeoId">
  									${uiLabelMap.PartyWardGeoId}
  								</label>
 								</td>
  							<td>
   	 							<select name="permanentResidence_wardGeoId" id="permanentResidence_wardGeoId">
    							</select>
  							</td>
						</tr>
						</table>
		</div>
		<div class="span1" style="display: block; margin-top: 100px">
			<button class="btn btn-small btn-primary" id="copyContactInfo" type="button">
				<i class="icon-arrow-right"></i>
			</button>
		</div>
		<div class="span5" style="border: 1px solid #EEE; padding: 15px; border-radius: 5px; margin-right: 0px;">
			<div class="title-border">
				<span>${uiLabelMap.CurrentResidence}</span>
			</div>
			<table cellspacing="0">
			<tr>
				<td>
					<label class="padding-bottom5 padding-right15" for="address1_CurrResidence">
						${uiLabelMap.PartyAddressLine}
					</label>
				</td>
				<td>
					<input type="text" name="address1_CurrResidence" id="address1_CurrResidence"/>
				</td>
			</tr>
			<tr>   
  							<td><label class="padding-bottom5 padding-right15" for="currResidence_countryGeoId">${uiLabelMap.CommonCountry}</label></td>
  							<td>     
    							<select name="currResidence_countryGeoId" id="currResidence_countryGeoId">
      								${screens.render("component://common/widget/CommonScreens.xml#countries")}        
       								<#assign defaultCountryGeoId = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "country.geo.id.default")>
      								<option selected="selected" value="${defaultCountryGeoId}">
        								<#assign countryGeo = delegator.findOne("Geo",Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
        								${countryGeo.get("geoName",locale)}
      								</option>
    							</select>
  							</td>
						</tr>
						<tr>
  							<td><label class="padding-bottom5 padding-right15" for="currResidence_stateProvinceGeoId">${uiLabelMap.PartyState}</label></td>
  							<td>
   	 							<select name="currResidence_stateProvinceGeoId" id="currResidence_stateProvinceGeoId">
    							</select>
  							</td>
						</tr>
						<tr>
  							<td>
  								<label class="padding-bottom5 padding-right15" for="currResidence_districtGeoId">
  									${uiLabelMap.PartyDistrictGeoId}
  								</label>
 								</td>
  							<td>
   	 							<select name="currResidence_districtGeoId" id="currResidence_districtGeoId">
    							</select>
  							</td>
						</tr>
						<tr>
  							<td>
  								<label class="padding-bottom5 padding-right15" for="currResidence_wardGeoId">
  									${uiLabelMap.PartyWardGeoId}
  								</label>
 								</td>
  							<td>
   	 							<select name="currResidence_wardGeoId" id="currResidence_wardGeoId">
    							</select>
  							</td>
						</tr>
						</table>
		</div>
	</div>
</div>
					