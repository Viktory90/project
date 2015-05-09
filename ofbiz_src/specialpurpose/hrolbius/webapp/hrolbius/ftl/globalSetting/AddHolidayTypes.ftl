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
					<label class="control-label asterisk">${uiLabelMap.HrolbiusHolidayTypeId}</label>
					<div class="controls">
						<input type="text" name="holidayTypeId" id="${formId}_holidayTypeId">
					</div>
				</div>					
				<div class="control-group no-left-margin">
					<label class="control-label">${uiLabelMap.HrolbiusPeriodHolidayTypeId}</label>
					<div class="controls">
						<select name="periodTypeId" id="${formId}_periodTypeId">
							<option></option>
							<#list periodTypeList as periodType>
								<option value="${periodType.periodTypeId}">${periodType.get("description", locale)}</option>
							</#list>
						</select>
					</div>
				</div>
				<div class="control-group no-left-margin">
					<label class="control-label">${uiLabelMap.CommonDescription}</label>
					<div class="controls">
						<input type="text" name="description" id="${formId}_description">
					</div>
				</div>
				
				<div class="control-group">
					<label class="control-label">
						&nbsp;  
					</label>
					<div class="controls">
						<button class="btn btn-small btn-primary"  type="submit" id="btnSubmit">
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
		
		jQuery(".editHolidayTypeBtn").attr("href", "javascript:void(0);");
	});
	 $("#${dataToggleModalId}").on("hide", function() { 
		 //alert("111");
		 var typeHolidayType = jQuery("#${formId}_holidayTypeId").attr("type");
		 if(typeHolidayType === "hidden"){
			 alert("1");
			 jQuery("#${formId}_holidayTypeId").prop("type", "text");
			 jQuery("#${formId}_holidayTypeId").val("");
			 jQuery("#${formId}_holidayTypeId").parent().find("span").remove();
			 jQuery("#${formId}_periodTypeId").val("");
			 jQuery("#${formId}_description").val("");
			 jQuery("#${formId}").attr("action", "<@ofbizUrl>${linkUrl}</@ofbizUrl>");
		 }
	 });
	function updateHolidayType(holidayTypeId, periodTypeId, desc){
		jQuery("#${formId}_holidayTypeId").prop("type", "hidden");
		jQuery("#${formId}_holidayTypeId").val(holidayTypeId);
		jQuery("#${formId}_holidayTypeId").parent().append("<span>" + holidayTypeId + "</span>");
		jQuery("#${formId}_periodTypeId").val(periodTypeId);
		jQuery("#${formId}_description").val(desc);
		jQuery("#${formId}").attr("action", "<@ofbizUrl>updateHolidayTypes</@ofbizUrl>");
		jQuery("#${dataToggleModalId}").modal("show");
	}
</script>