<#assign dataField="[{ name: 'productId', type: 'string'},
						   { name: 'contentId', type: 'string'},
						   { name: 'qualityPublicationName', type: 'string'},
						   { name: 'fromDate', type: 'date', other: 'Timestamp'},
						   { name: 'thruDate', type: 'date', other: 'Timestamp'},
						   { name: 'expireDate', type: 'number'},
						   ]"/>
<#assign columnlist="
			        { text: '${uiLabelMap.productQualityName}' ,filterable: true, sortable: true, datafield: 'qualityPublicationName', minwidth: 180, editable: false},
			        { text: '${uiLabelMap.ProductName}' ,filterable: true, sortable: true, datafield: 'productId', minwidth: 200, filtertype: 'checkedlist', editable: false, cellsrenderer:
     			       function(row, colum, value){
    			        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    			        var productId = data.productId;
    			        var product = getProductName(productId);
    			        return '<span>' + product + '</span>';
    		        },createfilterwidget: function (column, htmlElement, editor) {
    		        	editor.jqxDropDownList({ autoDropDownHeight: true, source: fixSelectAll(listProduct), displayMember: 'productId', valueMember: 'productId' ,
                            renderer: function (index, label, value) {
                            	if (index == 0) {
                            		return value;
								}
							    return getProductName(value);
			                } });
    		        	editor.jqxDropDownList('checkAll');
                    }},
			        { text: '${uiLabelMap.shelfLife}' ,filterable: false, sortable: true, datafield: 'expireDate', width: 190, editable: false, cellsrenderer:
					       function(row, colum, value){
						        var data = $('#jqxgrid').jqxGrid('getrowdata', row);
						        var expireDate = data.expireDate;
						        return '<span>' + expireDate + ' ${uiLabelMap.DayLowercase}' + '</span>';
			        }},
					{ text: '${uiLabelMap.fromDateOfPubich}', datafield: 'fromDate', width: 200, editable: false, filtertype: 'range', cellsformat: 'dd/MM/yyyy'},
					{ text: '${uiLabelMap.thruDateOfPubich}', datafield: 'thruDate', width: 200, editable: false, filtertype: 'range', cellsformat: 'dd/MM/yyyy'},
					{ text: \'${uiLabelMap.SaveFileScan}\',columntype: \'button\', align: 'center', editable: false, width: 170, filterable: false,
	                	   cellsrenderer: function(){
	                		return '${StringUtil.wrapString(uiLabelMap.CommonAdd)}';
	                	   }, buttonclick: function(row){
	                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	                		   saveFileScan(data.contentId);
	                	   }
	                   },
	                 { text: \'${uiLabelMap.ViewFileScan}\',columntype: \'button\', editable: false, width: 150, filterable: false,
	                	   cellsrenderer: function(row, column, value){
	                		   return '${StringUtil.wrapString(uiLabelMap.CommonView)}';
	                	   }, buttonclick: function(row){
	                		   var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	                		   viewFileScan(data.contentId);
	                	   }
	                   },
					"/>
					
    <@jqGrid filtersimplemode="true" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true"
						showtoolbar="true" addrow="false" deleterow="false" alternativeAddPopup="alterpopupWindow" editable="false" 
							customcontrol1="icon-plus-sign open-sans@${uiLabelMap.CreateProductQuality}@CreateProductQuality"
						url="jqxGeneralServicer?sname=JQGetListQualityPublication"
					/>
    		        
    		        <div id = "myEditor"></div>
    		        <div id = "myImage"></div>
    		        
    <#assign listProduct = delegator.findList("Product", null, null, null, null, false) />
    <script>
    		        var listProduct = new Array();
        			<#if listProduct?exists>
        			<#list listProduct as item>
        				var row = {};
        				row['internalName'] = '${item.internalName?if_exists}';
        				row['productId'] = '${item.productId?if_exists}';
        				listProduct[${item_index}] = row;
        			</#list>
        			</#if>
        			function getProductName(productId) {
        				if (productId != null) {
        					for ( var x in listProduct) {
            					if (productId == listProduct[x].productId) {
            						return listProduct[x].internalName;
            					}
            				}
    					} else {
    						return "";
    					}
        			}
        			
        			function viewFileScan(contentId) {
    		        	var path = '/DELYS/delys/QualityPublicationFile_' + contentId;
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
    		        	wd += "<div id='window01'><div>${uiLabelMap.ProductQualityScanFile}</div><div>";
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
    		        	$('#window01').on('close', function () {
	   		            	 listImage = [];
	   		            	 $('#window01').jqxWindow('destroy');
    		        	});
    		        }
    		        var listImage = [];
    		        function saveFileScan(contentId) {
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
//    		        		listImage = [];
    		        	});
    		        	 $("#alterSave5").click(function () {
    		        		 var newFolder = "/delys/" + 'QualityPublicationFile_' + contentId;
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
        				    	$("#myAlert").delay(3000).html(message);
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
    		        function hiddenClick() {
    		        	$('#contentMessages').css('display','none');
    		        }
    		        function fixSelectAll(dataList) {
			        	var sourceST = {
						        localdata: dataList,
						        datatype: "array"
						    };
		   				var filterBoxAdapter2 = new $.jqx.dataAdapter(sourceST, {autoBind: true});
		                var uniqueRecords2 = filterBoxAdapter2.records;
		   				uniqueRecords2.splice(0, 0, '(${StringUtil.wrapString(uiLabelMap.filterselectallstring)})');
					return uniqueRecords2;
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