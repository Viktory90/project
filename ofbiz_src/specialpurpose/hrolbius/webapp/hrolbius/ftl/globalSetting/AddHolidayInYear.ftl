<div id="${dataToggleModalId}" class="modal hide fade" tabindex="-1" >
	<div class="modal-header no-padding">
		<div class="table-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			${uiLabelMap.AddHolidayInYear}
		</div>
	</div>	
	<div class="modal-body no-padding">
		<form action="<@ofbizUrl>${linkUrl}</@ofbizUrl>" id="${formId}" class="form-horizontal" method="post" name="">
			<div class="row-fluid">
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">${uiLabelMap.HolidayType}</label>
					<div class="controls">
						<select name="holidayTypeId" id="EditHolidayInYear_holidayTypeId">
							<#list listHolidayType as holidayType>
								<option value="${holidayType.holidayTypeId}">${holidayType.description}</option>
							</#list>
						</select>
					</div>
				</div>					
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">${uiLabelMap.CommonFromDate}</label>
					<div class="controls">
						<@htmlTemplate.renderDateTimeField name="fromDate" event="" action="" value="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="fromDate" dateType="date" shortDateInput=true timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</div>
				</div>
				
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">${uiLabelMap.CommonThruDate}</label>
					<div class="controls">
						<@htmlTemplate.renderDateTimeField name="thruDate" event="" action="" value="" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="thruDate" dateType="date" shortDateInput=true timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
					</div>
				</div>
				
				<div class="control-group no-left-margin">
					<label class="control-label">${uiLabelMap.CommonDescription}</label>
					<div class="controls">
						<input type="text" name="description">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">
						&nbsp;  
					</label>
					<div class="controls">
						<button class="btn btn-small btn-primary"  type="submit">
							<i class="icon-ok"></i>
							${uiLabelMap.CommonSubmit}
						</button>
					</div>
				</div>
			</div>					
		</form>
	</div>
	
</div>



<script type="text/javascript">
	jQuery(document).ready(function() {
		jQuery("#${createNewLinkId}").attr("data-toggle", "modal");
		jQuery("#${createNewLinkId}").attr("role", "button");
		jQuery("#${createNewLinkId}").attr("href", "#${dataToggleModalId}");
	});
</script>