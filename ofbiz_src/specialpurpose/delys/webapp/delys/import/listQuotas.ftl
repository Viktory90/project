<script type="text/javascript" src="/delys/images/js/import/miscUtil.js"></script>
<script type="text/javascript" src="/delys/images/js/import/progressing.js"></script>
<script type="text/javascript" src="/delys/images/js/import/notify.js"></script>

<#assign initrowdetailsDetail = "function (index, parentElement, gridElement, datarecord) {
	var grid = $($(parentElement).children()[0]);
	$(grid).attr('id','jqxgridDetail'+index);
	if(datarecord.rowDetail == null || datarecord.rowDetail.length < 1){
		nestedGridAdapter = new Array();
	}else {
		var dataAdapter = new $.jqx.dataAdapter(datarecord.rowDetail, { autoBind: true });
	    var recordData = dataAdapter.records;
			var nestedGrids = new Array();
	         nestedGrids[index] = grid;
	         var recordDataById = [];
	         for (var ii = 0; ii < recordData.length; ii++) {
	             recordDataById.push(recordData[ii]);
	         }
	         var recordDataSource = { datafields: [	
						{ name: 'quotaId', type: 'string' },
						{ name: 'quotaItemSeqId', type: 'string' },
						{ name: 'productId', type: 'string' },
						{ name: 'productName', type: 'string'},
						{ name: 'quotaQuantity', type: 'string'},
						{ name: 'quantityAvailable', type: 'string'},
						{ name: 'quantityUomId', type: 'string'},
						{ name: 'fromDate', type: 'date', other: 'Timestamp'},
						{ name: 'thruDate', type: 'date', other: 'Timestamp'}
	         		],
	         		updaterow: function (rowid, rowdata, commit) {
	           			commit(true);
	           			var quotaId = rowdata.quotaId;
	           			var quotaItemSeqId = rowdata.quotaItemSeqId;
	           			var quantityAvailable = rowdata.quantityAvailable;
	           			if (quantityAvailable != null && quantityAvailable != undefined) {
	           				var data = {'quotaId': quotaId, 'quotaItemSeqId': quotaItemSeqId, 'quantityAvailable' : quantityAvailable};
		            		$.ajax({
		                        type: 'POST',
		                        url: 'updateQuotaItemAjax',
		                        data: data,
		                        success: function (res) {
		                        	res['_ERROR_MESSAGE_'] == undefined?saveSuccess=true:saveSuccess=false;
		                        },
		                        error: function () {
		                            commit(false);
		                        }
		                    }).done(function() {
						    	if (saveSuccess) {
						    		commit(true);
	                            	$('#notificationContent').text(\"${StringUtil.wrapString(uiLabelMap.DAUpdateSuccessful)}\");
	                            	$('#jqxNotification').jqxNotification(\"open\");
								}else {
									commit(false);
	                            	$('#jqxNotification').jqxNotification({ template: 'error'});
	                            	$('#notificationContent').text('${StringUtil.wrapString(uiLabelMap.DAUpdateError)}');
	                            	$('#jqxNotification').jqxNotification(\"open\");;
								}
							});
	           			} else {
	           				bootbox.dialog('${uiLabelMap.DAQuantityAcceptedNotValid}!', [{
								'label' : 'OK',
								'class' : 'btn-small btn-primary',
								}]
							);
							commit(false);
	           			}
	                },
	             	localdata: recordDataById
	         }
	         var nestedGridAdapter = new $.jqx.dataAdapter(recordDataSource);
	}
	
	 grid.jqxGrid({
	     source: nestedGridAdapter, 
	     width: '96%', 
	     autoheight: true,
	     showtoolbar:false,
		 editable:true,
		 pagesize: 5,
		 pageable: true,
		 editmode:\"click\",
		 showheader: true,
		 selectionmode:\"singlerow\",
		 theme: 'olbius',
	     columns: [
					{ text: '${uiLabelMap.accProductId}', datafield: 'productId', width: '250px', editable:false, align: 'center'},
					{ text: '${uiLabelMap.QuotaQuantity}', datafield: 'quotaQuantity', width: '300px', editable:false, align: 'center', cellsalign: 'right'},
					{ text: '${uiLabelMap.QuantityAvailable}', datafield: 'quantityAvailable', columntype: 'numberinput', align: 'center', cellsalign: 'right',
						 validation: function (cell, value) {
	                		   lastTimeChoice = value;
	                		   var thisRow = cell.row;
	                		   var data = grid.jqxGrid('getrowdata', thisRow);
	            		       var quotaQuantity = data.quotaQuantity;
	                           if (quotaQuantity < value) {
	                        	   return { result: false, message: '${uiLabelMap.QuantityAvailableBigerThanQuotaQuantity}' };
	                            }
	                	       return true;
	                }},
					{ text: '${uiLabelMap.Unit}', datafield: 'quantityUomId', width: '150px', align: 'center', editable:false, cellsrenderer:
						function(row, colum, value){
						var data = grid.jqxGrid('getrowdata', row);
						var quantityUomId = data.quantityUomId;
						var quantityUom = getUom(quantityUomId);
						return '<span>' + quantityUom + '</span>';
					}},
	     ]
	 });
 }"/>

<#assign dataField="[{ name: 'quotaId', type: 'string' },
					 { name: 'quotaName', type: 'string'},
					 { name: 'description', type: 'string'},
					 { name: 'fromDate', type: 'date', other: 'Timestamp'},
					 { name: 'thruDate', type: 'date', other: 'Timestamp'},
					 { name: 'rowDetail', type: 'string'}
					 ]"/>
<#assign columnlist="					 
						{ text: '${uiLabelMap.QuotaId}', datafield: 'quotaId', width: '150px', align: 'center'},
						{ text: '${uiLabelMap.QuotaName}', datafield: 'quotaName', width: '200px', align: 'center'},
						{ text: '${uiLabelMap.description}', datafield: 'description', width: '200px', align: 'center'},
						{ text: '${uiLabelMap.AvailableFromDate}', datafield: 'fromDate', columntype: 'datetimeinput', align: 'center', filtertype: 'range', width: '200px', cellsformat: 'dd/MM/yyyy'},
						{ text: '${uiLabelMap.AvailableThruDate}', datafield: 'thruDate', columntype: 'datetimeinput', align: 'center', filtertype: 'range', width: '200px', cellsformat: 'dd/MM/yyyy'},
						{ text: \'${uiLabelMap.SaveFileScan}\',columntype: \'button\', align: 'center', editable: false, width: 120, filterable: false,
		                	   cellsrenderer: function(){
		                		return '${StringUtil.wrapString(uiLabelMap.CommonAdd)}';
		                	   }, buttonclick: function(row){
		                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		                		   saveFileScan(data.quotaId);
		                	   }
		                   },
		             { text: \'${uiLabelMap.ViewFileScan}\',columntype: \'button\', editable: false, align: 'center', width: 120, filterable: false,
		                	   cellsrenderer: function(row, column, value){
		                		   return '${StringUtil.wrapString(uiLabelMap.CommonView)}';
		                	   }, buttonclick: function(row){
		                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
		                		   viewFileScan(data.quotaId);
		                	   }
		                   }
					 "/>

						
		<@jqGrid filtersimplemode="true" alternativeAddPopup="alterpopupWindow" initrowdetails = "true" dataField=dataField initrowdetailsDetail=initrowdetailsDetail editmode="selectedrow"
			editable="false" columnlist=columnlist clearfilteringbutton="true" showtoolbar="true" addrow="false"
				customcontrol1="icon-plus-sign open-sans@${uiLabelMap.AddQuotas}@AddQuotas"
		 	url="jqxGeneralServicer?sname=JQGetListQuotas" rowdetailsheight="247" 
		 		/>
		<div id = "myImage"></div>
		
		<div id="jqxNotification">
	        <div id="notificationContent"></div>
        </div>
		
		<#assign listUoms = delegator.findList("Uom", Static["org.ofbiz.entity.condition.EntityCondition"].makeCondition("uomTypeId", "WEIGHT_MEASURE"), null, null, null, false) />
<script>
		$("#jqxNotification").jqxNotification({ width: "100%", appendContainer: "#container", opacity: 0.9, autoClose: true, template: 'info'});
		var listUom = new Array();
		<#if listUoms?exists>
			<#list listUoms as item>
				var row = {};
				row['description'] = '${item.get("description", locale)?if_exists}';
				row['uomId'] = '${item.uomId?if_exists}';
				listUom[${item_index}] = row;
			</#list>
		</#if>
		function getUom(uomId) {
			if (uomId != null) {
				for ( var x in listUom) {
					if (uomId == listUom[x].uomId) {
						return listUom[x].description;
					}
				}
			} else {
				return "";
			}
		}
		var listImage = [];
        function saveFileScan(quotaId) {
        	var wd = "";
        	wd += "<div id='window01'><div>${uiLabelMap.SaveFileScan}</div><div>";
        	wd += "<h3>${uiLabelMap.FileScan}</h3><input multiple type='file' id='id-input-file-3'/>";
        	wd += "<div class='row-fluid'>" +
					"<div class='span12 no-left-margin'>" +
						"<div class='span4'></div>" +
						"<div class='span8'><input style='margin-right: 5px;' type='button' id='alterSave5' value='${uiLabelMap.CommonSave}' /><input id='alterCancel5' type='button' value='${uiLabelMap.CommonCancel}' /></div>" +
					"</div>";
        	wd += "</div></div>";
        	$("#myImage").html(wd);
        	$('#window01').jqxWindow({ height: 350, width: 450, isModal: true, modalOpacity: 0.7 });
        	$("#alterCancel5").jqxButton();
            $("#alterSave5").jqxButton();
        	$('#id-input-file-3').ace_file_input({
        		style:'well',
        		btn_choose:'Drop files here or click to choose',
        		btn_change:null,
        		no_icon:'icon-cloud-upload',
        		droppable:true,
        		onchange:null,
        		thumbnail:'small',
        		before_change:function(files, dropped) {
        			var count = files.length;
        			for (var int = 0; int < files.length; int++) {
        				var imageName = files[int].name;
        				var hashName = imageName.split(".");
        				var extended = hashName.pop();
        				if (extended == "jpg" || extended == "jpeg" || extended == "gif" || extended == "png") {
        					listImage.push(files[int]);
        				}
        			}
        			return true;
        		},
        		before_remove : function() {
        			listImage = [];
        			return true;
        		}

        	}).on('change', function(){
        	});
        	 $("#alterSave5").click(function () {
        		 var newFolder = "/delys/" + 'quotaFile_' + quotaId;
        			for ( var d in listImage) {
        				var file = listImage[d];
        				var dataResourceName = file.name;
        				var path = "";
        				var form_data= new FormData();
        				form_data.append("uploadedFile", file);
        				form_data.append("folder", newFolder);
        				jQuery.ajax({
        					url: "uploadDemo",
        					type: "POST",
        					data: form_data,
        					cache : false,
        					contentType : false,
        					processData : false,
        					success: function(res) {
        						path = res.path;
        			        }
        				}).done(function() {
        				});
        			}
        			$('#window01').jqxWindow('destroy');
					var message = "<div id='contentMessages' class='alert alert-success' onclick='hiddenClick()'>" +
					"<p id='thisP'>" + '${uiLabelMap.DAUpdateSuccessful}' + "</p></div>";
			    	$("#myAlert").html(message);
             });
             $("#alterCancel5").click(function () {
            	 listImage = [];
            	 $('#window01').jqxWindow('destroy');
             });
             $('#window01').on('close', function () {
            	 listImage = [];
            	 $('#window01').jqxWindow('destroy');
             });
        }
        function viewFileScan(quotaId) {
        	var path = '/DELYS/delys/quotaFile_' + quotaId;
        	getFileScan(path);
		}
        function getFileScan(path) {
        	var jsonObject = {nodePath : path,}
        	var fileUrl = [];
        	jQuery.ajax({
                url: "getFileScanAjax",
                type: "POST",
                data: jsonObject,
                success: function(res) {
                	fileUrl = res["childNodes"];
                }
            }).done(function() {
				viewImage(fileUrl, path);
        	});
        }
        function viewImage(fileUrl, path) {
        	var height = 0;
        	var wd = "";
        	wd += "<div id='window01'><div>${uiLabelMap.QuotaScanFile}</div><div>";
        	if (fileUrl == undefined) {
        		wd += "<h1><p style='color: #999999'>${uiLabelMap.FileNotFound}!</p></h1>";
        		height = 300;
			} else {
	        	for ( var er in fileUrl) {
	        		var link = "/webdav/repository/default" + path + "/" + fileUrl[er];
	        		wd += "<img src='" + link + "'><br/>";
	        		height = 650;
	        	}
			}
        	wd += "</div></div>";
        	$("#myImage").html(wd);
        	$('#window01').jqxWindow({ height: height, width: 700, maxWidth: 1200, isModal: true, modalOpacity: 0.7 });
        	$('#window01').on('close', function (event) {
            	 listImage = [];
            	 $('#window01').jqxWindow('destroy');
             }); 
        }
</script>
<style type="text/css">
.jqx-grid-cell-olbius input.jqx-button-olbius {
	width: 60px!important;
  text-align: center!important;
  margin: 0 auto!important;
  display: block!important;
  position: relative!important;
}
</style>