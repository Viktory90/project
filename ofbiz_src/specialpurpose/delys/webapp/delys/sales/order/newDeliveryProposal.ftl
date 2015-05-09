<form class="form-horizontal basic-custom-form" id="newDeliveryProposal" name="newDeliveryProposal" method="post" action="<@ofbizUrl>showDeliveryProposal</@ofbizUrl>" style="display: block;">
	<div class="row-fluid">
		<div class="span5">
			<div class="control-group">
				<label class="control-label" for="deliveryReqId">${uiLabelMap.DADeliveryProposalId}</label>
				<div class="controls">
					<div class="span12">
						<input type="text" name="deliveryReqId" id="deliveryReqId" value="${parameters.deliveryReqId?if_exists}">
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label required" for="requirementStartDate">${uiLabelMap.DADeliveryDate}</label>
				<div class="controls">
					<div class="span12">
						<@htmlTemplate.renderDateTimeField name="requirementStartDate" id="requirementStartDate" value="" event="" action="" className="" alert="" 
							title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" dateType="date" shortDateInput=false 
							timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" 
							classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" 
							pmSelected="" compositeType="" formName=""/>
					</div>
				</div>
			</div>
		</div><!--.span6-->
		<div class="span7">
			<div class="control-group">
				<label class="control-label" for="deliveryReqDescription">${uiLabelMap.DADescription}</label>
				<div class="controls">
					<div class="span12">
						<textarea class="span12" name="deliveryReqDescription" id="deliveryReqDescription">${parameters.deliveryReqDescription?if_exists}</textarea>
					</div>
				</div>
			</div>
		</div><!--.span6-->
	</div><!--.row-->
	
	<div class="row-fluid wizard-actions">
		<button class="btn btn-prev btn-small" disabled="disabled"><i class="icon-arrow-left"></i> ${uiLabelMap.DAPrev}</button>
		<button class="btn btn-success btn-next btn-small" type="submit" data-last="Finish ">${uiLabelMap.DANext} <i class="icon-arrow-right icon-on-right"></i></button>
	</div>
</form>
