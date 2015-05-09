<script type="text/javascript">
jQuery(document).ready(function() {
var settings=$('#${formId}').validate().settings;
	
	$.validator.addMethod('validateValueEntime',function(value,element,params){
		var end= value.split(":");
		var valueParams= $(params).val();
		var start= valueParams.split(":");
		if(start){
			if(end[0]&&start[0]&&end[0]<start[0]){
				return false;
			}
			if(end[2]&&start[2]&&end[1]&&start[1]&&end[0]&&start[0]&&(end[0]==start[0])&&(end[1]<start[1])&&(end[2]==start[2])){
				return false;
			}
			
			if(end[2]&&start[2]&&end[1]&&start[1]&&end[0]&&start[0]&&(end[0]==start[0])&&(end[1]==start[1])&&(end[2]<=start[2])){
				return false;
			}
		}	
		return true;
				
	},'${uiLabelMap.EndTimeWorkShift}');
	
	
	$.validator.addMethod('validateValueTime',function(value,element){
		var res= value.split(":");
		if(res[0]&&res[0]>23){
			return false;
		}
		if(res[1]&&res[1]>59){
			return false
		}	
		if(res[2]&&res[2]>59){
			return false
		}
		return true;
	},'${uiLabelMap.InputValueMustBeTimeValue}');
	$.extend(settings,{
		errorClass: "style-block",
		errorElement: "div",	
		rules:{
			startTime:{
				validateValueTime:true,
			},
			endTime:{
				validateValueTime:true,
				validateValueEntime:'#${formId}_startTime'
			}
		}
	});
});
</script>