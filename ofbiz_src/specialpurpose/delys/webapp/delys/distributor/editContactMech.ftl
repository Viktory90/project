<div class="widget-body">	 
	<div class="widget-main">
		<div class="row-fluid">
		<#if !mechMap.facilityContactMech?exists && mechMap.contactMech?exists>
			<div class="alert alert-info">
				<h4>${uiLabelMap.PartyContactInfoNotBelongToYou}.</h4>
			</div>
 			<a href="<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>" class="icon-arrow-left icon-on-left open-sans">${uiLabelMap.CommonBack}</a>
		<#else>
			<#if !mechMap.contactMech?exists>
				<#-- When creating a new contact mech, first select the type, then actually create -->
		    	<#if !preContactMechTypeId?has_content>
				    <form id="createcontactmechform" name="createcontactmechform" method="post" action="<@ofbizUrl>editContactMechDis</@ofbizUrl>" class="form-horizontal basic-custom-form form-decrease-padding">
						<input type='hidden' name='facilityId' value='${facilityId}' />
				      	<input type='hidden' name='DONE_PAGE' value='${donePage?if_exists}' />
						<div class="row">
							<div class="span12">
								<div class="control-group">
									<label class="control-label" for="preContactMechTypeId">${uiLabelMap.PartySelectContactType}</label>
									<div class="controls">
										<div class="span12">
											<select name="preContactMechTypeId" id="preContactMechTypeId">
							             	 	<#list mechMap.contactMechTypes as contactMechType>
								                	<option value='${contactMechType.contactMechTypeId}'>${contactMechType.get("description",locale)}</option>
								              	</#list>
								            </select>
										</div>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="orderId">
										<a href='<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>'><i class="fa-arrow-left"></i>&nbsp;${uiLabelMap.CommonGoBack}</a>
									</label>
									<div class="controls">
										<a href="javascript:document.createcontactmechform.submit()" class="btn btn-primary btn-small">${uiLabelMap.CommonCreate}&nbsp;<i class="fa-arrow-right icon-on-right"></i></a>
									</div>
								</div>
							</div>
						</div>
					</form>
			    </#if>
			</#if>
			
			<#if mechMap.contactMechTypeId?has_content>
				<#if !mechMap.contactMech?has_content>
			      	<#if contactMechPurposeType?exists>
			        	<div><span>(${uiLabelMap.PartyMsgContactHavePurpose}</span>"${contactMechPurposeType.get("description",locale)?if_exists}")</div>
			      	</#if>
			      	<#assign requestNameDis = mechMap.requestName + "Dis"/>
			      	<form id="editcontactmechform" name="editcontactmechform" method="post" action="<@ofbizUrl>${requestNameDis}</@ofbizUrl>" class="form-horizontal basic-custom-form form-decrease-padding">
						<input type='hidden' name='DONE_PAGE' value='${donePage}' />
		        		<input type='hidden' name='contactMechTypeId' value='${mechMap.contactMechTypeId}'/>
		        		<input type='hidden' name='facilityId' value='${facilityId}' />
		        		<#if preContactMechTypeId?exists><input type='hidden' name='preContactMechTypeId' value='${preContactMechTypeId}' /></#if>
		        		<#if contactMechPurposeTypeId?exists><input type='hidden' name='contactMechPurposeTypeId' value='${contactMechPurposeTypeId?if_exists}' /></#if>
						<#if paymentMethodId?exists><input type='hidden' name='paymentMethodId' value='${paymentMethodId}' /></#if>
						<#if !contactMechPurposeTypeId?exists>
						<div class="row-fluid">
							<div class="span6">
								<div class="control-group">
									<label class="control-label" for="contactMechPurposeTypeId">${uiLabelMap.PartyContactPurposes} (*)</label>
									<div class="controls">
										<div class="span12">
											<select name='contactMechPurposeTypeId' id="contactMechPurposeTypeId" class="required">
					              				<option></option>
					              				<#list mechMap.purposeTypes as contactMechPurposeType>
					                				<option value='${contactMechPurposeType.contactMechPurposeTypeId}'>${contactMechPurposeType.get("description",locale)}</option>
					               				</#list>
					            			</select>
										</div>
									</div>
								</div>
							</div><!--.span6-->
						</div><!--.row-fluid-->
						</#if>
					<!--</form>-->
			    <#else>
  					<#if mechMap.purposeTypes?has_content>
	  					<div class="form-horizontal basic-custom-form form-decrease-padding">
							<div class="row-fluid">
								<div class="span6">
									<div class="control-group">
										<label class="control-label">${uiLabelMap.PartyContactPurposes}</label>
										<div class="controls">
											<div class="span12" style="position:relative">
												<table class="basic-table" cellspacing="0">
			            							<#if mechMap.facilityContactMechPurposes?has_content>
			              								<#assign alt_row = false>
			              								<#list mechMap.facilityContactMechPurposes as facilityContactMechPurpose>
			        										<#assign contactMechPurposeType = facilityContactMechPurpose.getRelatedOne("ContactMechPurposeType", true)>
											                <tr valign="middle"<#if alt_row> class="alternate-row"</#if>>
											                  	<td>
											                      	<#if contactMechPurposeType?has_content>
											                        	<b>${contactMechPurposeType.get("description",locale)}</b>
											                      	<#else>
										                        		<b>${uiLabelMap.PartyMechPurposeTypeNotFound}: "${facilityContactMechPurpose.contactMechPurposeTypeId}"</b>
											                      	</#if>
											                      	(${uiLabelMap.CommonSince}: ${facilityContactMechPurpose.fromDate})
											                      	<#if facilityContactMechPurpose.thruDate?has_content>(${uiLabelMap.CommonExpires}: ${facilityContactMechPurpose.thruDate.toString()}</#if>
												                    <div class="action-buttons" style="display:inline-block; margin-left:5px">
												                      	<a href="javascript:document.getElementById('deleteFacilityContactMechPurpose_${facilityContactMechPurpose_index}').submit();" class="red"><i class="open-sans icon-trash"></i></a>
											                  		</div>
											                  	</td>
											                </tr>
			                								<#-- toggle the row color -->
											                <#assign alt_row = !alt_row>
											                <form id="deleteFacilityContactMechPurpose_${facilityContactMechPurpose_index}" method="post" action="<@ofbizUrl>deleteFacilityContactMechPurposeDis</@ofbizUrl>">
											                  	<input type="hidden" name="facilityId" value="${facilityId?if_exists}" />
											                  	<input type="hidden" name="contactMechId" value="${contactMechId?if_exists}" />
											                  	<input type="hidden" name="contactMechPurposeTypeId" value="${(facilityContactMechPurpose.contactMechPurposeTypeId)?if_exists}" />
											                  	<input type="hidden" name="fromDate" value="${(facilityContactMechPurpose.fromDate)?if_exists}" />
											                  	<input type="hidden" name="DONE_PAGE" value="${donePage?if_exists}" />
											                  	<input type="hidden" name="useValues" value="true" />
											                </form>
			              								</#list>
			          								</#if>
			            						</table>
			            						<div style="position:absolute; top:0; right:-340px">
			            							<form method="post" action='<@ofbizUrl>createFacilityContactMechPurposeDis?DONE_PAGE=${donePage}&amp;useValues=true</@ofbizUrl>' name='newpurposeform'>
								                  		<input type="hidden" name='facilityId' value='${facilityId}' />
								                  		<input type="hidden" name='contactMechId' value='${contactMechId?if_exists}' />
							                    		<select name='contactMechPurposeTypeId'>
								                      		<option></option>
								                      		<#list mechMap.purposeTypes as contactMechPurposeType>
								                        		<option value='${contactMechPurposeType.contactMechPurposeTypeId}'>${contactMechPurposeType.get("description",locale)}</option>
								                      		</#list>
							                    		</select>
							                    		&nbsp;<a href='javascript:document.newpurposeform.submit()' class='btn btn-mini btn-info'><i class="icon-plus open-sans"></i>${uiLabelMap.PartyAddPurpose}</a>
								                  	</form>
			            						</div>
											</div>
										</div>
									</div>
								</div><!--.span6-->
							</div><!--.row-fluid-->
					</#if><!--</form>-->
					<#assign requestNameDis = mechMap.requestName + "Dis"/>
    				<form method="post" action='<@ofbizUrl>${requestNameDis}</@ofbizUrl>' name="editcontactmechform" id="editcontactmechform">
    					<input type="hidden" name="contactMechId" value='${contactMechId}' />
				        <input type="hidden" name="contactMechTypeId" value='${mechMap.contactMechTypeId}' />
				        <input type="hidden" name='facilityId' value='${facilityId}' />
				</#if>
					
  				<#if "POSTAL_ADDRESS" = mechMap.contactMechTypeId?if_exists>
  					<div class="row-fluid">
						<div class="span6">
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyToName}</label>
								<div class="controls">
									<div class="span12">
										<input type="text" size="30" maxlength="60" name="toName" value="${(mechMap.postalAddress.toName)?default(request.getParameter('toName')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyAttentionName}</label>
								<div class="controls">
									<div class="span12">
										<input type="text" size="30" maxlength="60" name="attnName" value="${(mechMap.postalAddress.attnName)?default(request.getParameter('attnName')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyAddressLine1} (*)</label>
								<div class="controls">
									<div class="span12">
										<input type="text" class="required" size="30" maxlength="30" name="address1" value="${(mechMap.postalAddress.address1)?default(request.getParameter('address1')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyAddressLine2}</label>
								<div class="controls">
									<div class="span12">
										<input type="text" size="30" maxlength="30" name="address2" value="${(mechMap.postalAddress.address2)?default(request.getParameter('address2')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyCity} (*)</label>
								<div class="controls">
									<div class="span12">
										<input type="text" class="required" size="30" maxlength="30" name="city" value="${(mechMap.postalAddress.city)?default(request.getParameter('city')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyState}</label>
								<div class="controls">
									<div class="span12">
										<select name="stateProvinceGeoId" id="editcontactmechform_stateProvinceGeoId"></select>
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyZipCode}</label>
								<div class="controls">
									<div class="span12">
										<input type="text" class="required" size="12" maxlength="10" name="postalCode" value="${(mechMap.postalAddress.postalCode)?default(request.getParameter('postalCode')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">${uiLabelMap.CommonCountry}</label>
								<div class="controls">
									<div class="span12">
										<select name="countryGeoId" id="editcontactmechform_countryGeoId">
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
									</div>
								</div>
							</div>
						</div><!--.span6-->
					</div><!--.row-fluid-->
				<#elseif "TELECOM_NUMBER" = mechMap.contactMechTypeId?if_exists>
					<div class="row-fluid">
						<div class="span6">
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyPhoneNumber}</label>
								<div class="controls">
									<div class="span12">
										<input type="text" size="4" maxlength="10" name="countryCode" value="${(mechMap.telecomNumber.countryCode)?default(request.getParameter('countryCode')?if_exists)}" />
								        -&nbsp;<input type="text" size="4" maxlength="10" name="areaCode" value="${(mechMap.telecomNumber.areaCode)?default(request.getParameter('areaCode')?if_exists)}" />
								        -&nbsp;<input type="text" size="15" maxlength="15" name="contactNumber" value="${(mechMap.telecomNumber.contactNumber)?default(request.getParameter('contactNumber')?if_exists)}" />
								        &nbsp;ext&nbsp;<input type="text" size="6" maxlength="10" name="extension" value="${(mechMap.facilityContactMech.extension)?default(request.getParameter('extension')?if_exists)}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label"></label>
								<div class="controls">
									<div class="span12">
										[${uiLabelMap.CommonCountryCode}] [${uiLabelMap.PartyAreaCode}] [${uiLabelMap.PartyContactNumber}] [${uiLabelMap.PartyExtension}]
									</div>
								</div>
							</div>
						</div><!--.span6-->
					</div><!--.row-fluid-->
	  			<#elseif "EMAIL_ADDRESS" = mechMap.contactMechTypeId?if_exists>
	  				<div class="row-fluid">
						<div class="span6">
							<div class="control-group">
								<label class="control-label">${uiLabelMap.PartyEmailAddress} (*)</label>
								<div class="controls">
									<div class="span12">
										<input type="text" class="required" size="60" maxlength="255" name="emailAddress" value="${(mechMap.contactMech.infoString)?default(request.getParameter('emailAddress')?if_exists)}" />
									</div>
								</div>
							</div>
						</div><!--.span6-->
					</div><!--.row-fluid-->																																																					
			  	<#else>
			  		<div class="row-fluid">
						<div class="span6">
							<div class="control-group">
								<label class="control-label">${mechMap.contactMechType.get("description",locale)} (*)</label>
								<div class="controls">
									<div class="span12">
										<input type="text" class="required" size="60" maxlength="255" name="infoString" value="${(mechMap.contactMech.infoString)?if_exists}" />
									</div>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label"></label>
								<div class="controls">
									<div class="span12">
										[${uiLabelMap.CommonCountryCode}] [${uiLabelMap.PartyAreaCode}] [${uiLabelMap.PartyContactNumber}] [${uiLabelMap.PartyExtension}]
									</div>
								</div>
							</div>
						</div><!--.span6-->
					</div><!--.row-fluid-->
			  	</#if>
				  	<#--<div class="row-fluid wizard-actions">
						<button class="btn btn-prev btn-small"><i class="icon-arrow-left"></i> Prev</button>
						<button class="btn btn-success btn-next btn-small" data-last="Finish ">Next <i class="icon-arrow-right icon-on-right"></i></button>
					</div>-->
			  		<div class="row-fluid">
						<div class="span6">
							<div class="control-group">
								<label class="control-label">
									<#if !mechMap.contactMech?has_content>
							        	<a href='<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>'><i class="icon-arrow-left"></i>${uiLabelMap.CommonGoBack}</a>
								    <#else>
				    					<a href='<@ofbizUrl>authview/${donePage}?facilityId=${facilityId}</@ofbizUrl>'><i class='icon-arrow-left'></i>${uiLabelMap.CommonGoBack}</a>
								    </#if>
								</label>
								<div class="controls">
									<div class="span12">
										<a href="javascript:document.editcontactmechform.submit()" class="btn btn-small btn-primary"><i class="icon-save"></i>${uiLabelMap.CommonSave}</a>
									</div>
								</div>
							</div>
						</div><!--.span6-->
					</div><!--.row-fluid-->
				</form>
			</#if>
		</#if>
		</div>
	</div>
</div>