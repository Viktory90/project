<#if requestAttributes.errorMessageList?has_content><#assign errorMessageList=requestAttributes.errorMessageList></#if>
<#if requestAttributes.eventMessageList?has_content><#assign eventMessageList=requestAttributes.eventMessageList></#if>
<#if requestAttributes.serviceValidationException?exists><#assign serviceValidationException = requestAttributes.serviceValidationException></#if>
<#if requestAttributes.uiLabelMap?has_content><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>

<#if !errorMessage?has_content>
  	<#assign errorMessage = requestAttributes._ERROR_MESSAGE_?if_exists>
</#if>
<#if !errorMessageList?has_content>
  	<#assign errorMessageList = requestAttributes._ERROR_MESSAGE_LIST_?if_exists>
</#if>
<#if !eventMessage?has_content>
  	<#assign eventMessage = requestAttributes._EVENT_MESSAGE_?if_exists>
</#if>
<#if !eventMessageList?has_content>
  	<#assign eventMessageList = requestAttributes._EVENT_MESSAGE_LIST_?if_exists>
</#if>

<#-- display the error messages -->
<#if (errorMessage?has_content || errorMessageList?has_content)>
  	<div id="content-messages" class="alert alert-error" onclick="document.getElementById('content-messages').parentNode.removeChild(this)">
    	<strong>${uiLabelMap.CommonFollowingErrorsOccurred}:</strong>
    	<#if errorMessage?has_content>
      		<strong>${errorMessage}</strong>
    	</#if>
    	<#if errorMessageList?has_content>
      		<#list errorMessageList as errorMsg>
        		<p>${errorMsg}</p>
      		</#list>
    	</#if>
  	</div>
</#if>
<#-- display the event messages -->
<#if (eventMessage?has_content || eventMessageList?has_content)>
  	<div id="content-messages" class="alert alert-info" onclick="document.getElementById('content-messages').parentNode.removeChild(this)">
    	<#--<strong>${uiLabelMap.CommonFollowingOccurred}:</strong>-->
    	<#if eventMessage?has_content>
      		<strong>${eventMessage}</strong>
    	</#if>
    	<#if eventMessageList?has_content>
      		<#list eventMessageList as eventMsg>
        		<p>${eventMsg}</p>
      		</#list>
    	</#if>
  	</div>
</#if>
<#if mechMap.contactMechTypeId?has_content>
  	<#if mechMap.contactMech?has_content>
		<div id="mech-purpose-types">
      		<table>
      			<#if mechMap.purposeTypes?has_content>
        			<tr>
          				<td align="right">${uiLabelMap.PartyContactPurposes}</td>
          				<td align="left">
            				<table class="basic-table" cellspacing="0">
				              	<#if mechMap.partyContactMechPurposes?has_content>
				                	<#list mechMap.partyContactMechPurposes as partyContactMechPurpose>
				                  		<#assign contactMechPurposeType = partyContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
			                  			<tr>
				                    		<td style="width:220px; max-width: 220px; min-width: 220px;">
				                      			<#if contactMechPurposeType?has_content>
				                        			${contactMechPurposeType.get("description",locale)}
				                      			<#else>
				                        			${uiLabelMap.PartyPurposeTypeNotFound}: "${partyContactMechPurpose.contactMechPurposeTypeId}"
				                      			</#if>
				                      			<br/>(${uiLabelMap.DAFromDate}: 
				                      			<#if partyContactMechPurpose.fromDate?has_content>${Static["org.ofbiz.base.util.UtilFormatOut"].formatDateTime(partyContactMechPurpose.fromDate, "dd/MM/yyyy HH:mm:ss", locale, timeZone)!}</#if>)
				                      			<#if partyContactMechPurpose.thruDate?has_content>(${uiLabelMap.CommonExpire}: ${partyContactMechPurpose.thruDate.toString()}</#if>
			                    			</td>
				                    		<td align="left">
				                      			<form name="deletePartyContactMechPurpose_${partyContactMechPurpose.contactMechPurposeTypeId}" method="post" action="<@ofbizUrl>deletePartyContactMechPurpose</@ofbizUrl>" >
				                         			<input type="hidden" name="partyId" value="${partyId}" />
				                         			<input type="hidden" name="contactMechId" value="${contactMechId}" />
				                         			<input type="hidden" name="contactMechPurposeTypeId" value="${partyContactMechPurpose.contactMechPurposeTypeId}" />
				                         			<input type="hidden" name="fromDate" value="${partyContactMechPurpose.fromDate.toString()}" />
				                         			<input type="hidden" name="DONE_PAGE" value="${donePage?replace("=","%3d")}" />
				                         			<input type="hidden" name="useValues" value="true" />
				                       			</form>
				                       			<a href="javascript:document.deletePartyContactMechPurpose_${partyContactMechPurpose.contactMechPurposeTypeId}.submit()" class="btn btn-mini btn-primary"><i class="open-sans icon-trash"></i>${uiLabelMap.CommonDelete}</a>
			                    			</td>
				                  		</tr>
				                	</#list>
				              	</#if>
            				</table>
            			</td>
      					<td align="right"></td>
      					<td align="left">
      						<form method="post" action="<@ofbizUrl>createPartyContactMechPurpose</@ofbizUrl>" name="newpurposeform">
          						<input type="hidden" name="partyId" value="${partyId}" />
          						<input type="hidden" name="DONE_PAGE" value="${donePage}" />
          						<input type="hidden" name="useValues" value="true" />
          						<input type="hidden" name="contactMechId" value="${contactMechId?if_exists}" />
        						<select name="contactMechPurposeTypeId">
          							<option></option>
			                      	<#list mechMap.purposeTypes as contactMechPurposeType>
				                        <option value="${contactMechPurposeType.contactMechPurposeTypeId}">${contactMechPurposeType.get("description",locale)}</option>
			                      	</#list>
       		 					</select>
       		 					<a class="btn btn-mini btn-primary" href="javascript:document.newpurposeform.submit()"><i class="open-sans icon-plus-sign"></i>${uiLabelMap.PartyAddPurpose}</a>
        					</form>
      					</td>
      				</tr>
				</#if>
			</table>
			<hr style="border-top: 1px solid #ddd; margin-top: 15px; margin-bottom: 15px;"/>
			<form method="post" action="<@ofbizUrl>${mechMap.requestName}</@ofbizUrl>" name="editcontactmechformUpdate" id="editcontactmechformUpdate">
				<input type="hidden" name="contactMechId" value="${contactMechId}" />
				<input type="hidden" name="contactMechTypeId" value="${mechMap.contactMechTypeId}" />
				<input type="hidden" name="partyId" value="${partyId}" />
				<input type="hidden" name="DONE_PAGE" value="${donePage?if_exists}" />
			<table>
	</#if>
	<#if "POSTAL_ADDRESS" = mechMap.contactMechTypeId?if_exists>
		<tr>
			<td align="right">${uiLabelMap.PartyToName}</td>
			<td align="left">
				<input type="text" size="50" maxlength="100" name="toName" value="${(mechMap.postalAddress.toName)?default(request.getParameter('toName')?if_exists)}" tabindex=1/>
			</td>
			
			<td align="right" class="required">${uiLabelMap.PartyAddressLine1}</td>
			<td align="left">
				<input type="text" size="100" maxlength="255" name="address1" value="${(mechMap.postalAddress.address1)?default(request.getParameter('address1')?if_exists)}" />
			</td>
		</tr>
		<tr>
			<td align="right">${uiLabelMap.PartyAttentionName}</td>
			<td align="left">
				<input type="text" size="50" maxlength="100" name="attnName" value="${(mechMap.postalAddress.attnName)?default(request.getParameter('attnName')?if_exists)}" />
			</td>
			
			<td align="right">${uiLabelMap.PartyAddressLine2}</td>
			<td align="left">
				<input type="text" size="100" maxlength="255" name="address2" value="${(mechMap.postalAddress.address2)?default(request.getParameter('address2')?if_exists)}" />
			</td>
		</tr>
		<tr>
			<td align="right" class="required">${uiLabelMap.PartyZipCode}</td>
			<td align="left">
				<input type="text" size="30" maxlength="60" name="postalCode" value="${(mechMap.postalAddress.postalCode)?default(request.getParameter('postalCode')?if_exists)}" />
			</td>
			
			<td align="right" class="required">${uiLabelMap.PartyCity}</td>
			<td align="left">
				<input type="text" size="50" maxlength="100" name="city" value="${(mechMap.postalAddress.city)?default(request.getParameter('city')?if_exists)}" />
			</td>
		</tr>
		<tr>
			<td align="right">${uiLabelMap.CommonCountry}</td>
			<td align="left">     
		        <select name="countryGeoId" id="editcontactmechformUpdate_countryGeoId">
		          	${screens.render("component://common/widget/CommonScreens.xml#countries")}        
		          	<#if (mechMap.postalAddress?exists) && (mechMap.postalAddress.countryGeoId?exists)>
		            	<#assign defaultCountryGeoId = mechMap.postalAddress.countryGeoId>
		          	<#else>
		           		<#assign defaultCountryGeoId = Static["org.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "country.geo.id.default")>
		          	</#if>
		          	<option selected="selected" value="${defaultCountryGeoId}">
		            	<#assign countryGeo = delegator.findOne("Geo",Static["org.ofbiz.base.util.UtilMisc"].toMap("geoId",defaultCountryGeoId), false)>
		            	${countryGeo.get("geoName",locale)}
		          	</option>
		        </select>
			</td>
			
			<td align="right">${uiLabelMap.PartyState}</td>
			<td align="left">
				<select name="stateProvinceGeoId" id="editcontactmechformUpdate_stateProvinceGeoId"></select>
			</td>
		</tr>
		<#--
		<tr>
			<#assign isUsps = Static["org.ofbiz.party.contact.ContactMechWorker"].isUspsAddress(mechMap.postalAddress)>
			<td align="right">${uiLabelMap.PartyIsUsps}</td>
			<td align="left"><#if isUsps>${uiLabelMap.CommonY}<#else>${uiLabelMap.CommonN}</#if></td>
			
			<td align="right"></td>
			<td align="left"></td>
		</tr>
		-->
	<#elseif "TELECOM_NUMBER" = mechMap.contactMechTypeId?if_exists>
		<tr>
			<td align="right">${uiLabelMap.PartyPhoneNumber}</td>
			<td align="left">
				<input type="text" size="4" maxlength="10" name="countryCode" value="${(mechMap.telecomNumber.countryCode)?default(request.getParameter('countryCode')?if_exists)}" />
				-&nbsp;<input type="text" size="4" maxlength="10" name="areaCode" value="${(mechMap.telecomNumber.areaCode)?default(request.getParameter('areaCode')?if_exists)}" />
				-&nbsp;<input type="text" size="15" maxlength="15" name="contactNumber" value="${(mechMap.telecomNumber.contactNumber)?default(request.getParameter('contactNumber')?if_exists)}" />
				&nbsp;${uiLabelMap.PartyContactExt}&nbsp;<input type="text" size="6" maxlength="10" name="extension" value="${(mechMap.partyContactMech.extension)?default(request.getParameter('extension')?if_exists)}" />
			</td>
			
			<td align="right"></td>
			<td align="left"></td>
		</tr>
		<tr>
			<td align="right"></td>
			<td align="left">[${uiLabelMap.CommonCountryCode}] [${uiLabelMap.PartyAreaCode}] [${uiLabelMap.PartyContactNumber}] [${uiLabelMap.PartyContactExt}]</td>
			
			<td align="right"></td>
			<td align="left"></td>
		</tr>
	<#elseif "EMAIL_ADDRESS" = mechMap.contactMechTypeId?if_exists>
		<tr>
			<td align="right">${mechMap.contactMechType.get("description",locale)}</td>
			<td align="left">
				<input type="text" size="60" maxlength="255" name="emailAddress" value="${(mechMap.contactMech.infoString)?default(request.getParameter('emailAddress')?if_exists)}" />
			</td>
			
			<td align="right"></td>
			<td align="left"></td>
		</tr>
	<#else>
		<tr>
			<td align="right">${mechMap.contactMechType.get("description",locale)}</td>
			<td align="left">
				<input type="text" size="60" maxlength="255" name="infoString" value="${(mechMap.contactMech.infoString)?if_exists}" />
			</td>
			
			<td align="right"></td>
			<td align="left"></td>
		</tr>
	</#if>
  				<tr>
    				<td align="right">${uiLabelMap.PartyContactAllowSolicitation}?</td>
    				<td align="left">
				      	<select name="allowSolicitation">
					        <#if (((mechMap.partyContactMech.allowSolicitation)!"") == "Y")><option value="Y">${uiLabelMap.CommonY}</option></#if>
					        <#if (((mechMap.partyContactMech.allowSolicitation)!"") == "N")><option value="N">${uiLabelMap.CommonN}</option></#if>
					        <option></option>
					        <option value="Y">${uiLabelMap.CommonY}</option>
					        <option value="N">${uiLabelMap.CommonN}</option>
				      	</select>
    				</td>
    				
    				<td align="right"></td>
					<td align="left"></td>
  				</tr>
  			</form>
  		</table>
  		
  		<table style="margin-bottom:15px">
  			<tr>
            	<td align="right"></td>
	 			<td align="left"></td>
	 			
                <td align="right">
                	<#--<a href="javascript:document.editcontactmechformUpdate.submit()" class="btn btn-small btn-primary"><i class="icon-ok open-sans"></i>${uiLabelMap.CommonSave}</a>-->
                	<a href="javascript:updateContactMech();" class="btn btn-small btn-primary"><i class="icon-ok open-sans"></i>${uiLabelMap.CommonSave}</a>
                </td>
                <td align="left">
                	<a href="javascript:closePopupWindow();" class="btn btn-small btn-primary"><i class="icon-remove open-sans"></i>${uiLabelMap.CommonClose}</a>
                </td>
            </tr>
  		</table>
  	</div>
  	<#--
  	<div class="button-bar">
    	<a href="<@ofbizUrl>backHome</@ofbizUrl>" class="btn btn-small btn-info icon-arrow-left open-sans"> ${uiLabelMap.CommonGoBack}</a>
    	<a href="javascript:document.editcontactmechformUpdate.submit()" class="btn btn-small btn-info icon-ok open-sans">${uiLabelMap.CommonSave}</a>
  	</div>
  	-->
  	<#--
  	<script type="text/javascript">
  		function closePopupWindow() {
  			if ($("#modal-table-edit-contact-mech") != undefined) {
  				$("#modal-table-edit-contact-mech").modal('hide');
  			}
  		}
  		
  		function updateContactMech() {
  			var data = $("#editcontactmechformUpdate").serialize();
	        jQuery.ajax({
	        	type: "POST",
	        	url: "${mechMap.requestName}InfoAjax",
	        	data: data,
	        	success: function (data) {
	        		$("#modal-body-edit-contact-mech").html(data);
  					updateCheckoutArea();
	        	},
	        	error: function () {
	        		//commit(false);
	        	}
	        });
  		}
  	</script>
  	-->
<#else>
  <a class="btn btn-small btn-primary icon-arrow-left open-sans" href="<@ofbizUrl>backHome</@ofbizUrl>">${uiLabelMap.CommonGoBack}</a>
</#if>
