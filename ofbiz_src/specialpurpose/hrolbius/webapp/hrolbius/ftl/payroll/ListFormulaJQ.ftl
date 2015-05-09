<#assign dataField="[{ name: 'code', type: 'string' },
					 { name: 'name', type: 'string' },
					 { name: 'function', type: 'string'},
					 {name: 'editAction', type: 'string'}]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.formulaCode}', datafield: 'code', width: 180},
 					 { text: '${uiLabelMap.formulaName}', datafield: 'name', width: 300},
					 { text: '${uiLabelMap.formulaDescription}', datafield: 'function', 
					 	cellsrenderer: function(row, column, value){
                     		 return '<div><code style=\"white-space: normal;\">' + value + '</code></div>';
                     	}
					 },
					 {text: '', width: '50', columntype: 'template', editable: false, filterable: false, datafield: 'editAction',
					 	cellsrenderer: function(row, columnfield, value, defaulthtml, columnproperties){
					 		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	                		return '<div style=\"text-align: center; margin-bottom: 2px\"><a href=\"EditFormula?code='+ data.code +'\" class=\"btn btn-mini btn-primary icon-edit\" ></a></div>';
	                	   }
					 }"/>
					 
<@jqGrid url="jqxGeneralServicer?sname=JQGetFormula" dataField=dataField columnlist=columnlist
	clearfilteringbutton="true" deleterow="true"
	editable="false" removeUrl="jqxGeneralServicer?sname=deletePayrollFormula&jqaction=D"
	customcontrol1="icon-plus-sign open-sans@${uiLabelMap.NewFormula}@EditFormula" 
	deleteColumn="code"
	editrefresh ="true"
	editmode="click"
	showtoolbar = "true"
	autorowheight = "true"
/>
<!-- <div class="controls clearfix margin-top-10">
	<div class="pull-right">
		<button id="addNew" class="btn btn-primary btn-small"><i class="fa fa-plus-circle"></i>&nbsp;${uiLabelMap.NewFormula}</button>
	</div>
</div> -->
<script type="text/javascript">
	$(document).ready(function(){
	   	$("#addNew").click(function(){
	   		window.location.href= "EditFormula";
	   	});	
	});
   
</script>