<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
<script>
	<#assign uom = delegator.findList("Uom", null, null, null, null, false) />
	var pptData = new Array();
	<#if uom?exists>
		<#list uom as item>
			var row = {};
			<#assign description = StringUtil.wrapString(item.description) />
			row['uomId'] = '${item.uomId?if_exists}';
			row['description'] = "${description}";
			pptData[${item_index}] = row;
		</#list>
	</#if>
	function getUom(uomFromId) {
		for ( var x in pptData) {
			if (uomFromId == pptData[x].uomId) {
				return pptData[x].description;
			}
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
	function getDateTimeStamp(fromDate) {
		if (fromDate != null) {
			fromDate =  new Date(fromDate);
			var date = fromDate.getDate();
			if (date < 10) {
				date = "0" + date;
			}
	        var month = fromDate.getMonth() + 1;
	        if (month < 10) {
	        	month = "0" + month;
			}
	        var year = fromDate.getFullYear();
	        var fullYear = date + '/' + month + '/' + year;
	        return fullYear;
		} else {
			 return "";
		}
	}
</script>
	<#assign dataField="[{ name: 'productId', type: 'string'},
			{ name: 'uomFromId', type: 'string'},
			{ name: 'uomToId', type: 'string'},
			{ name: 'quantityConvert', type: 'number', other: 'BigDecimal'},
			{ name: 'fromDate', type: 'string', other: 'Timestamp'},
			{ name: 'thruDate', type: 'string', other: 'Timestamp'},
			{ name: 'description', type: 'string'},
			{ name: 'lastUpdatedStamp', type: 'string', other: 'Timestamp'},
			{ name: 'createdTxStamp', type: 'string', other: 'Timestamp'},
			]"/>
	
	<#assign columnlist="
				{ text: '${uiLabelMap.uomFromId}', datafield: 'uomFromId', width: 90, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var uomFromId = data.uomFromId;
			        var uomFrom = getUom(uomFromId);
			        return '<span>' + uomFrom + '</span>';
		        }},
				{ text: '${uiLabelMap.uomToId}', datafield: 'uomToId', width: 90, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var uomToId = data.uomToId;
			        var uomTo = getUom(uomToId);
			        return '<span>' + uomTo + '</span>';
		        }},
				{ text: '${uiLabelMap.QuantityConvert}', datafield: 'quantityConvert', width: 140, editable: true, columntype: 'numberinput'},
				{ text: '${uiLabelMap.AvailableFromDate}',  datafield: 'fromDate', width: 140, editable: true, columntype: 'datetimeinput', cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var fromDate = data.fromDate;
			        var dateShow = getDateTimeStamp(fromDate);
			        return '<span>' + dateShow + '</span>';
		        }},
				{ text: '${uiLabelMap.ExpireDate}',  datafield: 'thruDate', width: 140, editable: true, columntype: 'datetimeinput', cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var thruDate = data.thruDate;
			        var dateShow = getDateTimeStamp(thruDate);
			        return '<span>' + dateShow + '</span>';
		        },validation: function (cell, value) {
		        	var thisRow = cell.row;
		        	var cellFD = $('#jqxgrid').jqxGrid('getCell', thisRow, 'fromDate');
		        	var thisFD = cellFD.value;
                    if (value == null){
                    	return true;
                    }
                     if (thisFD > value) {
                         return { result: false, message: 'Thru Date can not before From Date' };
                     }
                     return true;
                 }
               },
				{ text: '${uiLabelMap.description}',  datafield: 'description', minwidth: 250, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var dataShow = data.description;
			        var dataShort = executeMyData(dataShow);
			        var id = 'description' + row;
			        return '<span id=\"' + id + '\" onmouseenter=\"showMore(' + \"'\" + dataShow + \"'\" + ',' + \"'\" + id  + \"'\" + ')\" >' + dataShort + '</span>';
		        }},
				{ text: '${uiLabelMap.FormFieldTitle_lastUpdatedStamp}',  datafield: 'lastUpdatedStamp', width: 190, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var lastUpdatedStamp = data.lastUpdatedStamp;
			        var dateShow = getDateTimeStamp(lastUpdatedStamp);
			        return '<span>' + dateShow + '</span>';
		        }},
				{ text: '${uiLabelMap.FormFieldTitle_createdTxStamp}',  datafield: 'createdTxStamp', width: 140, editable: false, cellsrenderer:
			       function(row, colum, value){
			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
			        var createdTxStamp = data.createdTxStamp;
			        var dateShow = getDateTimeStamp(createdTxStamp);
			        return '<span>' + dateShow + '</span>';
		        }},
				"/>
	<@jqGrid filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="false" editmode="click"
				showtoolbar="true" addrow="true" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="true"
				url="jqxGeneralServicer?sname=JQGetListProductConfigPacking&productId=${productId}" updateUrl="jqxGeneralServicer?sname=UpdateProductConfigPacking&jqaction=U"
				createUrl="jqxGeneralServicer?sname=UpdateProductConfigPacking&jqaction=C"
				customcontrol1="icon-tasks@${uiLabelMap.CommonList}@EditProductConfigPacking?productId=${productId}"
				editColumns="quantityConvert;thruDate(java.sql.Timestamp);fromDate(java.sql.Timestamp);description;productId;uomFromId;uomToId"
				addColumns="quantityConvert;thruDate(java.sql.Timestamp);fromDate(java.sql.Timestamp);description;productId;uomFromId;uomToId"
				/>
		        <div id = "myEditor"></div>
		        <div id="hoanmCustom">
		        <div id="alterpopupWindow">
		        <div>${uiLabelMap.AddNewProductPacking}</div>
		        <div style="overflow-y: scroll;">
		        	<div class="row-fluid">
		        		<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.uomFromId}:</div>
		    	 			<div class="span3"><div id="uomFromId1"></div></div>
		    	 			<div class="span3">${uiLabelMap.uomToId}:</div>
		    	 			<div class="span3"><div id="uomToId1"></div></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.QuantityConvert}:</div>
		    	 			<div class="span3"><div id="quantityConvert1"></div></div>
		    	 			<div class="span3"></div>
		    	 			<div class="span3"></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		    	 			<div class="span3">${uiLabelMap.AvailableFromDate}:</div>
		        	 		<div class="span3"><div id="fromDate1"></div></div>
		        	 		<div class="span3">${uiLabelMap.ExpireDate}:</div>
		    	 			<div class="span3"><div id="thruDate1"></div></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		        	 		<div class="span3">${uiLabelMap.description}:</div>
		    	 			<div class="span9"><textarea  class="note-area no-resize" id="description1" autocomplete="off"></textarea></div>
	    	 			</div>
	    	 			<div class="span12 no-left-margin">
		                    <div class="span5"></div>
		                    <div class="span7"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></div>
		                </div>
		            </div>
		        </div>
		    </div>
		    </div>
		    <script>
		    	CKEDITOR.replace('description1', { skin: 'office2013'});
		    	var ck = CKEDITOR.instances;
		     	$.jqx.theme = 'olbius';
		    	theme = $.jqx.theme;
		    	var listUomPr = new Array();
		    	<#if listPrUoms?exists>
		    		<#list listPrUoms as item>
		    			var row = {};
		    			<#assign description = StringUtil.wrapString(item.description) />
		    			row['uomId'] = '${item.uomId?if_exists}';
		    			row['description'] = "${description}";
		    			listUomPr[${item_index}] = row;
		    		</#list>
		    	</#if>
		    	var listUomTo = new Array();
		    	<#if listUoms?exists>
		    		<#list listUoms as item>
		    		var row = {};
	    			<#assign description = StringUtil.wrapString(item.description) />
	    			row['uomId'] = '${item.uomId?if_exists}';
	    			row['description'] = "${description}";
	    			listUomTo[${item_index}] = row;
		    		</#list>
		    	</#if>
		    	$("#uomFromId1").jqxDropDownList({ source: listUomPr,displayMember: "description", valueMember: "uomId", selectedIndex: 0});
		    	$("#uomToId1").jqxDropDownList({ source: listUomTo,displayMember: "description", valueMember: "uomId", selectedIndex: 0});
		    	$("#quantityConvert1").jqxNumberInput({ inputMode: 'simple', spinButtons: true });
		    	$("#fromDate1").jqxDateTimeInput();
		    	$("#thruDate1").jqxDateTimeInput();
		    	$("#alterpopupWindow").jqxWindow({
		            width: 950, maxWidth: 1000, minHeight: 500, resizable: true,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7
		        });
		        $("#alterCancel").jqxButton();
		        $("#alterSave").jqxButton();
		        var checkFromDate = $('#fromDate1').val();
		        var dateFRM = checkFromDate.split('/');
		        checkFromDate = new Date(dateFRM[2], dateFRM[1] - 1, dateFRM[0], 0, 0, 0, 0);
		        $('#fromDate1').on('close', function (event)
		        		{
		        		    var jsDate = event.args.date;
		        		    checkFromDate = jsDate;
		        		});
		        $('#thruDate1').on('close', function (event)
		        		{
		        		    var jsDate = event.args.date;
		        		    if (checkFromDate < jsDate) {
							} else {
								 $('#inputthruDate1').val('');
							}
		        		});
		        $("#alterSave").click(function () {
		        	var row;
		        	var data = getDataEditor("description1");
        			var dataPart = data.replace("<em>", "<i>");
        			dataPart = dataPart.replace("</em>", "</i>");
        			dataPart = dataPart.trim();
        			var tempFrDate = $('#fromDate1').val();
        			var dateFRM1 = tempFrDate.split('/');
    		        var frmDate = new Date(dateFRM1[2], dateFRM1[1] - 1, dateFRM1[0], 0, 0, 0, 0);
    		        var tempThrDate = $('#thruDate1').val();
        			var dateTHR1 = tempThrDate.split('/');
    		        var thrDate = new Date(dateTHR1[2], dateTHR1[1] - 1, dateTHR1[0], 0, 0, 0, 0);
		            row = {
		            		quantityConvert:$('#quantityConvert1').val(),
		            		productId:'${productId}',
		            		uomFromId:$('#uomFromId1').val(),
		            		uomToId:$('#uomToId1').val(),
		            		description:dataPart,
		            		fromDate:frmDate,
		            		thruDate:thrDate,
		            	  };
		    	   	$("#jqxgrid").jqxGrid('addRow', null, row, "first");
		            $("#jqxgrid").jqxGrid('clearSelection');
		            $("#jqxgrid").jqxGrid('selectRow', 0);
		            $("#alterpopupWindow").jqxWindow('close');
		        });
		        $(document).ready(function() {
		        	var mytab = "<li><span class='divider'><i class='icon-angle-right'></i></span>${uiLabelMap.ListProductConfigPacking}</li>";
		        	$(".breadcrumb").append(mytab);
		        });
		        function getDataEditor(key) {
		        	if (ck[key]) {
		        		return ck[key].getData();
		        	}
		        	return "";
		        }
		        $("#jqxgrid").on("cellClick", function (event)
		        		{
		        		    var args = event.args;
		        		    var rowBoundIndex = args.rowindex;
		        		    var rowVisibleIndex = args.visibleindex;
		        		    var rightclick = args.rightclick;
		        		    var ev = args.originalEvent;
		        		    var columnindex = args.columnindex;
		        		    var dataField = args.datafield;
		        		    var value = args.value;
		        		    if (dataField == 'description') {
		        		    	$("#description" + rowBoundIndex).jqxTooltip('destroy'); 
		        		    	editDescription(value, rowBoundIndex);
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
		    </script>