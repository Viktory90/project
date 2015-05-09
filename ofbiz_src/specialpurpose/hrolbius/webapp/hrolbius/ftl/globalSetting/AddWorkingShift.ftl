
<div id="${dataToggleModalId}" class="modal hide fade" tabindex="-1" >
	<div class="modal-header no-padding">
		<div class="table-header">
			<button type="button" class="close" data-dismiss="modal">&times;</button>
			${uiLabelMap.AddWorkingShift}
		</div>
	</div>	
<div class="modal-body no-padding">
		<form action="<@ofbizUrl>${linkUrl}</@ofbizUrl>" id="${formId}" class="form-horizontal" method="post" name="${formId}">
			<div class="row-fluid">
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">${uiLabelMap.WorkingShiftName}</label>
					<div class="controls">
						<input type="text" name="description" class="required">
					</div>
				</div>					
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">${uiLabelMap.StartTime}</label>
					<div class="controls">
						<div id="${formId}_startTime" class="required"></div>
					</div>
				</div>
				
				<div class="control-group no-left-margin">
					<label class="control-label asterisk">${uiLabelMap.EndTime}</label>
					<div class="controls">
						<div id="${formId}_endTime" class="required"></div>
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
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdatetimeinput.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcalendar.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/globalization/globalize.js"></script>

<script type="text/javascript">
jQuery(document).ready(function() {
	jQuery("#${createNewLinkId}").attr("data-toggle", "modal");
	jQuery("#${createNewLinkId}").attr("role", "button");
	jQuery("#${createNewLinkId}").attr("href", "#${dataToggleModalId}");
	jQuery("#${formId}_startTime").jqxDateTimeInput({ width: 220, height: '25px', formatString: 'HH:mm:ss', showCalendarButton: false});
	jQuery("#${formId}_endTime").jqxDateTimeInput({ width: 220, height: '25px', formatString: 'HH:mm:ss', showCalendarButton: false});
	jQuery("#input${formId}_startTime").attr("name", "startTime");
	jQuery("#input${formId}_endTime").attr("name", "endTime");
});
</script>
