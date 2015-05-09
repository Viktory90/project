<#macro renderComboxBox name id emplData container width=220 height=30 itemHeight=59 dropDownWidth=300 multiSelect="true" autoDropDownHeight="false">
    <script type="text/javascript">
        $(document).ready(function () {           
            // prepare the data
            var data = new Array();
            var firstNames = new Array();
            var lastNames = new Array();
            var middleName = new Array();
            var partyIds = new Array();
            var genders = new Array();
            var emplPosType = new Array();
            
            <#list emplData as empl>
            	
            	<#if empl?exists>
	            	firstNames[${empl_index?number}] = '${empl.firstName?if_exists}';
	            	lastNames[${empl_index?number}] = '${empl.lastName?if_exists}';
	            	partyIds[${empl_index?number}] = '${empl.partyId?if_exists}';
	            	middleName[${empl_index?number}] = '${empl.middleName?if_exists}';
	            	
	            	<#assign genderEmpl = delegator.findList("Gender", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("genderId", ((empl.gender)?if_exists)), null, null, null, false) />
	            	<#if genderEmpl?has_content>
	            		genders[${empl_index?number}] = '${(genderEmpl.get(0).get("description", locale))?if_exists}';
					<#else>genders[${empl_index?number}] = '';
					</#if>
					
					<#assign emplPosTypeList = Static["com.olbius.util.PartyUtil"].getCurrPositionTypeOfEmpl(delegator, empl.partyId)/>
					<#if emplPosTypeList?has_content>
						<#assign emplPosType = delegator.findOne("EmplPositionType", Static["org.ofbiz.base.util.UtilMisc"].toMap("emplPositionTypeId", emplPosTypeList.get(0).emplPositionTypeId), false)>
						emplPosType[${empl_index?number}] = '${(emplPosType.get("description", locale))?if_exists}';
					<#else>	
						emplPosType[${empl_index?number}] = '';
					</#if>
				</#if>
            </#list>
			
            var k = 0;
            for (var i = 0; i < ${emplData.size()}; i++) {
                var row = {};
                row["firstname"] = firstNames[k];
                row["lastname"] = lastNames[k];
                row["middleName"] = middleName[k];
                row["partyId"] = partyIds[k];
                row["gender"] = genders[k];
                row["emplPosType"] = emplPosType[k];
                row["displayEmpl"] = lastNames[k] + " " + middleName[k] + " " + firstNames[k];
                data[i] = row;
                k++;
            }
            var source =
            {
                localdata: data,
                datatype: "array"
            };
            var dataAdapter = new $.jqx.dataAdapter(source);
            $('#${container}').jqxComboBox({ 
            	autoDropDownHeight: ${autoDropDownHeight},  
            	multiSelect: ${multiSelect}, 
            	source: dataAdapter, 
            	displayMember: "displayEmpl",
            	valueMember: "partyId", 
            	height: ${height}, 
            	width: ${width},
            	itemHeight: ${itemHeight},
            	dropDownWidth: ${dropDownWidth},
                renderer: function (index, label, value) {
                    var datarecord = data[index];
					var img = '<img height="45" width="45" src="/aceadmin/assets/avatars/avatar.png"/>';
					var gender = "";
					if(!datarecord.emplPosType){
						datarecord.emplPosType = "${uiLabelMap.Title}: ${uiLabelMap.CommonNotDefined}";
					}
					if(datarecord.gender){
						gender = " - " + datarecord.gender;
					}
					var table = '<table style="min-width: 200px;">'+
								   '<tr>' + 
								   		'<td style="width: 55px;" rowspan="2">'+ img + '</td>' + 
								   		'<td>' + datarecord.lastname + " " + datarecord.middleName + " " + datarecord.firstname + gender + '</td>'+
								   '</tr>'+
								   '<tr>'+
								   		'<td>'+datarecord.emplPosType+'</td>'+'<td></td>' +								   		
								   	'</tr>' +
						   		 '</table>';
                    return table;
                }            
            });
             $('#${container}').on('select', function (event) {
       			var args = event.args;
       				if (args) {
          	 		// index represents the item's index.                          
           			var index = args.index;
           			var item = args.item;
           			if(!item) return;
           			// get item's label and value.
           			var value = item.value;
           			$('#${id}').append("<option selected='true' value=" + value + "></option>");
       			}
   			});
   		
   			$('#${container}').on('unselect', function (event) {
       			var args = event.args;
       				if (args) {
          	 		// index represents the item's index.                          
           			var index = args.index;
           			var item = args.item;
           			if(!item) return;
           			// get item's label and value.
           			var value = item.value;
           			var el = $('#${id}').children("option[value='"+value+"']");
           			el.remove();
       			}
   			});
     });
      
    </script>
    <div id="${container}" style="margin-bottom: 10px;">
    </div>
    <select <#if multiSelect == "true">multiple</#if> style="display: none;" name=${name} id="${id}">
    </select>
 </#macro>
 
 <#macro renderPayrollFormula name id payrollFormulaList divId height width>
 	<script type="text/javascript">
 		(function(){
 			$(document).ready(function() {
		     var data = new Array();
		     var  code= new Array();
		     var name= new Array();
		     var funct= new Array();
		     var container = $('#${divId}');
		     if(!container.is('[class*="jqx"]')){
		     	<#list payrollFormulaList as pf >
			  		code[${pf_index?number}]='${pf.code?if_exists}';
			  		name[${pf_index?number}]='${pf.name?if_exists}';
			  		funct[${pf_index?number}]='${pf.function?if_exists}';
			  	</#list>
			  	var k=0;
			  	for(var i=0; i<${payrollFormulaList.size()}; i++){
			  		var row={};
			  		row["code"]= code[k];
			  		row["name"]= name[k];
			  		row["funct"]= funct[k];
			  		data[i]=row;
			  		k++;
			  	}
			  	
			  	var source= {
			  		localdata: data,
			    	datatype: "array"
			  	}
			 	var dataAdapter = new $.jqx.dataAdapter(source);
			  	container.jqxListBox({ 
		            	multiple: true, 
		            	source: dataAdapter, 
		            	theme: 'energyblue',
		            	displayMember: "name",
		            	valueMember: "code", 
		            	height: "${height}", 
		            	width: "${width}",
		                renderer: function (index, label, value) {
		                    var datarecord = data[index];
		                    var table = '<table style="width: ${width};"><tr><td>' + '<b>'+datarecord.name+'</b>'+ '</br>'+'<i>'+ datarecord.funct+'</i>'+'</td></tr></table>';
		                    return table;
		                }            
		            });
		         container.on('select', function (event) {
	       			var args = event.args;
	       				if (args) {
	          	 		// index represents the item's index.                          
	           			var index = args.index;
	           			var item = args.item;
	           			// get item's label and value.
	           			var value = item.value;
	           			$('#${id}').append("<option selected='true' value=" + value + "></option>");
	       			}
	   			});
	   		
	   			container.on('unselect', function (event) {
	       			var args = event.args;
	       				if (args) {
	          	 		// index represents the item's index.                          
	           			var index = args.index;
	           			var item = args.item;
	           			// get item's label and value.
	           			var value = item.value;
	           			var el = $('#${id}').children("option[value='"+value+"']");
	           			el.remove();
	       			}
	   			});	
		     }
		  });
 		})();
 	</script>

  <div id="${divId}"> </div>
  <select multiple style="display: none" name=${name} id="${id}"> </select>
 </#macro>

<#macro loadingContainer id="default" lines=12 length=7 width=4 radius=10 corners=1 rotate=0 trail=60 speed=1 fixed="true" zIndex=9999>
    <style>
    	.loading-container{
			width: 100%;
			height: 100%;
			top: 0px;
			left: 0px;
			<#if fixed == "true">
				position: fixed;
			<#else>
				position: absolute;
			</#if>
			opacity: 0.7;
			background-color: #fff;
			z-index: ${zIndex};
			text-align: center;
		}
		.spinner-preview{
			margin-top: 0;
			position: absolute;
			left: 50%;
			top: 50%;
			margin-left: -50px;
			margin-top: -50px;
		}
    </style>
    <script src="/aceadmin/assets/js/spin.min.js"></script>
    <script>
    $.fn.spin = function(opts) {
	this.each(function() {
		var $this = $(this), data = $this.data();

		if (data.spinner) {
			data.spinner.stop();
			delete data.spinner;
		}
		if (opts !== false) {
			data.spinner = new Spinner($.extend({
				color : $this.css('color')
			}, opts)).spin(this);
		}
	});
	return this;
};
	var spinnerUpdate = function(opts, id) {
		$('#'+id).spin(opts);
	};
	var showLoading = function(id){
		$("#"+id).show();
	};
	var hideLoading = function(id){
		$("#"+id).hide();
	};
    $(document).ready(function(){
    	var id = "${loadingid?if_exists}";
		var opts = {
			"lines" : ${lines},
			"length" : ${length},
			"width" : ${width},
			"radius" : ${radius},
			"corners" : ${corners},
			"rotate" : ${rotate},
			"trail" : ${trail},
			"speed" : ${speed}
		};
		spinnerUpdate(opts, "spinner-preview${id}"); 	
		hideLoading("loading${id}");
    });

</script>
	<div class='loading-container' id="loading${id?if_exists}">
		<div class="spinner-preview" id="spinner-preview${id?if_exists}"></div>	
	</div>
 </#macro>
 <#global loadingContainer=loadingContainer />