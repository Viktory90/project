<#assign dataField="[{ name: 'quotaId', type: 'string'},
						   { name: 'quotaName', type: 'string'},
						   { name: 'quotaTypeId', type: 'string'},
						   { name: 'description', type: 'string'},
						   { name: 'fromDate', type: 'date', other: 'Timestamp'},
						   { name: 'thruDate', type: 'date', other: 'Timestamp'},
						   ]"/>
						   
						   
						   <#assign columnlist="
							{ text: '${uiLabelMap.QuotaId}', datafield: 'quotaId', width: 150, editable: false, cellsrenderer:
							       function(row, colum, value){
								        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
								        var quotaId = data.quotaId;
								        var link = 'editQuota?quotaId=' + quotaId;
								        return '<span><a href=\"' + link + '\">' + quotaId + '</a></span>';
					        }},
							{ text: '${uiLabelMap.QuotaName}', datafield: 'quotaName', width: 200, editable: true},
							{ text: '${uiLabelMap.QuotaType}', datafield: 'quotaTypeId', width: 150, editable: false, cellsrenderer:
		     			       function(row, colum, value){
		    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		    			        var quotaTypeId = data.quotaTypeId;
		    			        var quotaType = getQuotaType(quotaTypeId);
		    			        return '<span>' + quotaType + '</span>';
		    		        }},
							
							{ text: '${uiLabelMap.description}', datafield: 'description', minWidth: 150, editable: false, cellsrenderer:
							       function(row, colum, value){
						        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
						        var dataShow = data.description;
						        var dataShort = executeMyData(dataShow);
						        var id = data.quotaId;
						        id = 'description' + id;
						        return '<span id=\"' + id + '\" onmouseenter=\"showMore(' + \"'\" + dataShow + \"'\" + ',' + \"'\" + id  + \"'\" + ')\" >' + dataShort + '</span>';
					        }},
			    		    { text: '${uiLabelMap.AvailableFromDate}', datafield: 'fromDate', width: 200, editable: true, cellsformat: 'dd/MM/yyyy - hh:mm:ss', columntype: 'datetimeinput'},
			    		    { text: '${uiLabelMap.AvailableThruDate}', datafield: 'thruDate', width: 200, editable: true, cellsformat: 'dd/MM/yyyy - hh:mm:ss', columntype: 'datetimeinput'},
							"/>
							
		<@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false"
									showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" 
									url="jqxGeneralServicer?sname=JQGetListImportQuotas" updateUrl="jqxGeneralServicer?sname=updateQuota&jqaction=U"
									editColumns="quotaId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);description"
								/>
		    		        
		    		        <div id = "myEditor"></div>
		    		        
		    		        <script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>
		    		        <script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
		    		        <script type="text/javascript" src="/delys/images/js/ckeditor/ckeditor.js"></script>
		    <script>
		    var ck = CKEDITOR.instances;
		    			
		    			var quotaType = new Array();
		    			<#if quotaType?exists>
		    			<#list quotaType as item>
		    				var row = {};
		    				row['description'] = '${item.description?if_exists}';
		    				row['quotaTypeId'] = '${item.quotaTypeId?if_exists}';
		    				quotaType[${item_index}] = row;
		    			</#list>
		    			</#if>
		    			function getQuotaType(quotaTypeId) {
		    				if (quotaTypeId != null) {
		    					for ( var x in quotaType) {
		        					if (quotaTypeId == quotaType[x].quotaTypeId) {
		        						return quotaType[x].description;
		        					}
		        				}
							} else {
								return "";
							}
		    			}
		    			
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
							    }, 1000);
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
						        if (datalength > 40) {
						        	dataShowShort = dataShow.substr(0, 40) + "...";
								}else {
									dataShowShort = dataShow;
								}
							   return dataShowShort;
						} else {
							 return '';
						}
					   }
					   
					   $("#jqxgrid").on("cellDoubleClick", function (event)
				        		{
				        		    var args = event.args;
				        		    var rowBoundIndex = args.rowindex;
				        		    var rowVisibleIndex = args.visibleindex;
				        		    var rightclick = args.rightclick;
				        		    var ev = args.originalEvent;
				        		    var columnindex = args.columnindex;
				        		    var dataField = args.datafield;
				        		    var value = args.value;
				        		    var data = $('#jqxgrid').jqxGrid('getrowdata', rowBoundIndex);
							        var quotaId = data.quotaId;
				        		    if (dataField == 'description') {
				        		    	$("#description" + quotaId).jqxTooltip('destroy'); 
//				        		    	editDescription(value, rowBoundIndex);
									}
				        });
				        function editDescription(Value, rowBoundIndex) {
				        	var wd = "";
				        	wd += "<div id='window01'><div>Edit Description</div><div>";
				        	wd += "<textarea  class='note-area no-resize' id='myEDT' autocomplete='off'></textarea>";
				        	wd += "<input style='margin-right: 5px;' type='button' id='alterSave11' value='${uiLabelMap.CommonSave}' /><input id='alterCancel11' type='button' value='${uiLabelMap.CommonCancel}' />"
				        	wd += "</div></div>";
				        	$("#myEditor").html(wd);
				        	$("#alterCancel11").jqxButton();
					        $("#alterSave11").jqxButton();
					        $("#alterSave11").click(function () {
					        	var data = getDataEditor("myEDT");
			        			var dataPart = data.replace("<em>", "<i>");
			        			dataPart = dataPart.replace("</em>", "</i>");
			        			dataPart = dataPart.trim();
			        			$("#jqxgrid").jqxGrid('setCellValue', rowBoundIndex, "description", dataPart);
					            $("#jqxgrid").jqxGrid('clearSelection');
					            $("#jqxgrid").jqxGrid('selectRow', 0);
					            $("#window01").jqxWindow('destroy');
					        });
					        $("#alterCancel11").click(function () {
					            $("#window01").jqxWindow('destroy');
					        });
				        	CKEDITOR.replace('myEDT', {height: '100px', width: '440px', skin: 'office2013'});
				        	if (Value == null) {
				        		Value = "";
							}
				        	if (Value != "") {
				        		var dataPart = Value.replace("<i>", "<em>");
			        			dataPart = dataPart.replace("</i>", "</em>");
					        	setDataEditor("myEDT", dataPart);
							}
				        	$('#window01').jqxWindow({ height: 350, width: 450, isModal:true, modalOpacity: 0.7});
				        }
				        function setDataEditor(key, content) {
				        	if (ck[key]) {
				        		return ck[key].setData(content);
				        	}
				        }
				        function getDataEditor(key) {
				        	if (ck[key]) {
				        		return ck[key].getData();
				        	}
				        	return "";
				        }
		    </script>
