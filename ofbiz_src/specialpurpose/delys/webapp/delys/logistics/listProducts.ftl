 <script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>
 <script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
			   
<script type="text/javascript">
	var myVar;
	function showMore(data, id) {
			$("#" + id).jqxTooltip('destroy');
			data = data.trim();
			var dataPart = data.replace("<p>", "");
			dataPart = dataPart.replace("</p>", "");
		    data = "<i onmouseenter='notDestroy()' onmouseleave='destroy(\"" + id + "\")'>" + dataPart + "</i>";
		    $("#" + id).jqxTooltip({ content: data, position: 'right', autoHideDelay: 3000, closeOnClick: false, autoHide: false});
		    myVar = setTimeout(function(){ 
				$("#" + id).jqxTooltip('destroy');
		    }, 2000);
	}
	function notDestroy() {
		clearTimeout(myVar);
	}
	function destroy(id) {
		clearTimeout(myVar);
		myVar = setTimeout(function(){
			$("#" + id).jqxTooltip('destroy');
		}, 2000);
	}
   function executeMyData(dataShow) {
	   	if (dataShow != null) {
		   var datalength = dataShow.length;
	        var dataShowShort = "";
	        if (datalength > 30) {
	        	dataShowShort = dataShow.substr(0, 30) + "...";
			}else {
				dataShowShort = dataShow;
			}
	        return dataShowShort;
		} else {
			 return '';
		}
   }
   
	<#assign weightUoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "WEIGHT_MEASURE"), null, null, null, false)>
	var weightUomData = new Array();
	<#list weightUoms as item>
		var row = {};
		<#assign abbreviation = StringUtil.wrapString(item.abbreviation?if_exists)/>
		row['weightUomId'] = '${item.uomId?if_exists}';
		row['description'] = '${abbreviation?if_exists}';
		weightUomData[${item_index}] = row;
	</#list>
	
	<#assign quantityUoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "PRODUCT_PACKING"), null, null, null, false)>
	var quantityUomData = new Array();
	<#list quantityUoms as item>
		var row = {};
		<#assign abbreviation = StringUtil.wrapString(item.abbreviation?if_exists)/>
		row['quantityUomId'] = '${item.uomId?if_exists}';
		row['description'] = '${abbreviation?if_exists}';
		quantityUomData[${item_index}] = row;
	</#list>
	
	function updateListProduct(){
		$("#jqxgrid").jqxGrid('updatebounddata');
	}
</script>
<#assign dataField="[{ name: 'productId', type: 'string'},
				   { name: 'internalName', type: 'string'},
				   { name: 'productCode', type: 'string'},
				   { name: 'description', type: 'string'},
				   { name: 'weight', type: 'string'},
				   { name: 'weightUomId', type: 'string'},
				   { name: 'quantityUomId', type: 'string'},
				   ]"/>

	<#assign columnlist="{ text: '${StringUtil.wrapString(uiLabelMap.ProductProductId)}', datafield: 'productId', width: 200, align: 'center', cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var dataShow = data.productId;
			        var link = 'EditProduct?productId=' + dataShow;
			        return '<span><a href=\"' + link + '\">' + dataShow + '</a></span>';
		        }},
		        { text: '${StringUtil.wrapString(uiLabelMap.ProductCode)}', datafield: 'productCode', editable:true, width: 150, align: 'center'},
			   { text: '${StringUtil.wrapString(uiLabelMap.DAInternalName)}', datafield: 'internalName', width: 200, align: 'center'},
			   { text: '${StringUtil.wrapString(uiLabelMap.description)}', datafield: 'description', width: 200, align: 'center', cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var dataShow = data.description;
			        var dataShort = executeMyData(dataShow);
			        var id = data.productId;
			        id = id.split('.')[0];
			        return '<span id=\"' + id + '\" onmouseenter=\"showMore(' + \"'\" + dataShow + \"'\" + ',' + \"'\" + id  + \"'\" + ')\" >' + dataShort + '</span>';
		        }},
			   { text: '${StringUtil.wrapString(uiLabelMap.QuantityUomId)}', datafield: 'quantityUomId', width: 150, align: 'center',
		        	cellsrenderer: function(row, colum, value){
		        		for(var i = 0; i < quantityUomData.length; i++){
		        			if(quantityUomData[i].quantityUomId == value){
		        				return '<span title= ' + value + '>' + quantityUomData[i].description +  '</span>';
		        			}
		        		}
					}
			   },
			   { text: '${StringUtil.wrapString(uiLabelMap.weight)}', datafield: 'weight', minwidth: 150, align: 'center',
				   cellsrenderer:
				       function(row, colum, value){
				        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
				        for(var i = 0; i < weightUomData.length; i++){
							if(weightUomData[i].weightUomId == data.weightUomId){
								return '<span>' + value +' (' + weightUomData[i].description +  ')</span>';
							}
						}
				   }
			   },
			   "/>
			   
<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" editrefresh="true"
	showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true" editColumns="productId;productCode" editmode="click" updateUrl="jqxGeneralServicer?sname=updateProduct&jqaction=U"
	url="jqxGeneralServicer?sname=JQGetListProduct" functionAfterUpdate="updateListProduct()"
/>
			  