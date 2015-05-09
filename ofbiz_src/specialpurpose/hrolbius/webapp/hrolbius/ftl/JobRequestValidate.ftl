<script type="text/javascript">
		var setting=jQuery("#EditJobRequest").validate().settings;
			delete setting.rules.EditJobRequest_resourceNumber;
			jQuery.validator.addMethod("greaterThan", 
			function(value, element, params) {
			        return Date.parseExact(value,"dd/MM/yyyy") >= Date.parseExact($(params).val(),"dd/MM/yyyy");
			},'Must be greater than');
			
			$.validator.addMethod('validateToDay',function(value,element){
				var now = new Date();
				now.setHours(0,0,0,0);
				return Date.parseExact(value,"dd/MM/yyyy") >=now;
			},'Greather than today');
			
			$.extend(setting,{
				rules:{	
					fromDate_i18n:{
						validateToDay:true
					},
					thruDate_i18n:{
						greaterThan:'#EditJobRequest_fromDate_i18n'
					},
					resourceNumber:
					{
						min:0
					}
				}, 
				messages: {
					resourceNumber:
					{
						min:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValue)}"
					},
					fromDate_i18n:{
						validateToDay:"${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherToDay)}"
					},
					thruDate_i18n:{
						greaterThan:'${StringUtil.wrapString(uiLabelMap.HrolbiusRequiredValueGreatherFromDate)}'
					}
				}
			});
		 
</script>
