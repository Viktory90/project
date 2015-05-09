<@jqGridMinimumLib/>
<div class="row-fluid">
    <div class="">
        <form method="post" class="basic-custom-form form-horizontal" name="staticProductOrder" id="staticProductOrder">
            <div class="control-group  no-left-margin">
                <label class="control-label" for="type_report">Kiểu báo cáo</label>
                <div class="controls">
                    <select name="type_report" id="type_report">
                        <option value="SALES_IN"> SALES IN</option>
                        <option value="SALES_OUT">SALES OUT</option>
                    </select>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="form-chanel_report-1">Kênh bán hàng</label>
                <div class="controls">
                    <select name="chanel_report" id="chanel_report">
                        <option value="SALES_ALL"> All Chanel</option>
                        <option value="SALES_GT"> SALES GT</option>
                        <option value="SALES_MT">SALES MT</option>
                    </select>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label" for="type_time">Xem báo cáo theo</label>
                <div class="controls">
                    <select name="type_time" id="type_time">
                        <option value="YEAR"> Năm</option>
                        <option value="MONTH"> Tháng</option>
                        <option value="QUARTER">Quý</option>
                        <option value="DATE">Ngày</option>
                    </select>
                </div>
            </div>
            <div class="control-group" id="child">

            </div>
            <div class="control-group no-left-margin ">
                <label class="">
                    &nbsp;  </label>
                <div class="controls">
                    <button id="staticButton" type="button" class="btn btn-small btn-primary" name="submitButton" ><i class="icon-ok"></i>${uiLabelMap.DAViewSalesStatement}</button>

                </div>
            </div>

        </form>

    </div>
</div>

<#assign currentYear = currentDateTime.get(Static["java.util.Calendar"].YEAR)>
<#assign currentMonth = currentDateTime.get(Static["java.util.Calendar"].MONTH) + 1>
<#assign minYear = currentYear-15>
<#assign maxYear = currentYear+15>
<script type="text/javascript">
    $("#type_time").change(function() {
        var str = "";
        $( "#type_time option:selected" ).each(function() {
            str= $( this ).val();
            $("#child").empty();
            if($("#before")){
                $("#before").remove();
            }
            if("MONTH"==str){
                var div="<label class=''>"
                        + "<label for='getInforDepartment_department' class='control-label' id='getInforDepartment_department_title'>"
                        + "${uiLabelMap.CommonMonth}" + "</label></label>"
                        + "<div class='controls'><input type='text' style='margin-bottom:0px;' name='month' class='input-mini' id='month' />"
                        + "<label style='display: inline;'>"+"${uiLabelMap.CommonYear}"+"</label>"
                        + "<input type='text' style='margin-bottom:0px;'class='input-mini' id='year' name='year'/>"
                        + "</div>";
                $("#child").append(div);
                jQuery('#month').ace_spinner({value:${currentMonth},min:1,max:12,step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
                jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});


            }else if("YEAR"==str){
                var div="<label class=''>"
                        + "<label for='getInforDepartment_department' class='control-label' id='getInforDepartment_department_title'>"
                        + "${uiLabelMap.CommonYear}" + "</label></label>"
                        + "<div class='controls'>"
                        + "<input type='text' style='margin-bottom:0px;'class='input-mini' id='year' name='year'/>"
                        + "</div>";
                $("#child").append(div);
                jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
            }else if("QUARTER"==str){
                var div="<label class=''>"
                        + "<label for='getInforDepartment_department' class='control-label' id='getInforDepartment_department_title'>"
                        + "${uiLabelMap.Quarter}" + "</label></label>"
                        + "<div class='controls'>"
                        + "<input type='text' style='margin-bottom:0px;'class='input-mini' id='quater' name='quater'/>"
                        + "<label style='display: inline;'>"+"${uiLabelMap.CommonYear}"+"</label>"
                        + "<input type='text' style='margin-bottom:0px;'class='input-mini' id='year' name='year'/>"
                        + "</div>";
                $("#child").append(div);
                jQuery('#quater').ace_spinner({value:1,min:1,max:4,step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
                jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});

            }else if("DATE"==str){
                 var divBefore= " <div class='control-group' id='before'>"
                                +"<label class=''>"
                                + "<label for='getInforDepartment_department' class='control-label' id='getInforDepartment_department_title'>"
                                + "${uiLabelMap.BiOlbiusFromDate}" + "</label></label>"
                                + "<div class='controls'>"
                                + "<div id='fromDate' style='display:inline-block; vertical-align:top'></div>"
                                + "</div>"
                                +"</div>";
                 var div= "<label class=''>"
                         + "<label for='getInforDepartment_department' class='control-label' id='getInforDepartment_department_title'>"
                         + "${uiLabelMap.BiOlbiusThruDate}" + "</label></label>"
                         + "<div class='controls'>"
                         + "<div id='thruDate' style='display:inline-block; vertical-align:top'></div>"
                         + "</div>";
                $("#child").before(divBefore);
                $("#child").append(div);
                $("#fromDate").jqxDateTimeInput({ width: '175px', height: '25px',  formatString: 'dd/MM/yyyy', theme:theme});
                $("#fromDate").jqxDateTimeInput('val','');
                $("#thruDate").jqxDateTimeInput({ width: '175px', height: '25px',  formatString: 'dd/MM/yyyy ', theme:theme});
                $("#thruDate").jqxDateTimeInput('val','');

            }



        });
    }).trigger( "change" );
    var alterData= new Object();

    $("#staticButton").on('click',function(){
        alterData.pagenum = "0";
        alterData.pagesize = "20";
        alterData.noConditionFind = "Y";
        alterData.conditionsFind = "N";
        var type_report= $("#type_report").val();
        var chanel_report=$("#chanel_report").val();
        var type_time=$("#type_time").val();
        var month="";
        var year="";
        var quater="";
        var fromDate="";
        var thruDate="";
        alterData.typeReport=type_report;
        alterData.chanelReport=chanel_report;
        alterData.typeTime=type_time;
        if("MONTH"==type_time){
            month=$("#month").val();
            year=$("#year").val();
            alterData.month=month;
            alterData.year=year;
       }else if("YEAR"==type_time){
            year=$("#year").val();
            alterData.year=year;
        }else if("QUARTER"==type_time){

            quater= $("#quater").val();
            year=$("#year").val();
            alterData.quater=quater;
            alterData.year=year;
        }else if("DATE"==type_time){
            fromDate=$("#fromDate").val();
            thruDate=$("#thruDate").val();
            if(fromDate){
                alterData.fromDate=fromDate;
            }
            if(thruDate){
                alterData.thruDate=thruDate;
            }
        }
        console.log(alterData);
        $('#jqxgrid').jqxGrid('updatebounddata');
    });

    $(window).bind('beforeunload',function(){

    <#if session.getAttribute("year")?has_content>
        <#assign tr= session.setAttribute("year","") />
    </#if>


    <#if session.getAttribute("month")?has_content>
        <#assign tr= session.setAttribute("month","") />
    </#if>

    <#if session.getAttribute("quater")?has_content>
        <#assign tr= session.setAttribute("quater","") />
    </#if>

    <#if session.getAttribute("fromDate")?has_content>
        <#assign tf= session.setAttribute("fromDate","") />
    </#if>

    <#if session.getAttribute("thruDate")?has_content>
        <#assign tf= session.setAttribute("thruDate","") />
    </#if>

    <#if session.getAttribute("typeReport")?has_content>
        <#assign tf= session.setAttribute("typeReport","") />
    </#if>
    <#if session.getAttribute("chanelReport")?has_content>
        <#assign tf= session.setAttribute("chanelReport","") />
    </#if>
    <#if session.getAttribute("typeTime")?has_content>
        <#assign tf= session.setAttribute("typeTime","") />
    </#if>
    });
</script>

    <#assign dataField="[{name:'name',type:'string'},{name:'quantity',type:'string'},{name:'grandTotal', type:'string'}]"/>
    <#assign columnlist="{text: 'STT', sortable: false, filterable: false, editable: false,
	                      groupable: false, draggable: false, resizable: false,
	                      datafield: '', columntype: 'number', width: 50,
	                      cellsrenderer: function (row, column, value) {
	                          return \"<div style='margin:4px;'>\" + (value + 1) + \"</div>\";
	                          }
                      	},
                      	{text: 'name product', datafield: 'name', cellsalign: 'left', editable: false},
                      	{text: 'quantity', datafield: 'quantity', cellsalign: 'left', editable: false},
                      	{text: 'Grand total', datafield: 'grandTotal', cellsalign: 'left', editable: false,
                      	cellsrenderer: function(row, column, value) {
					 		var data = $(\"#jqxgrid\").jqxGrid(\"getrowdata\", row);
					 		var str = \"<div style='text-align:right; width:95%; margin-left:0!important'>\";
							str += formatcurrency(value,data.currencyUom);
							str += \"</div>\";
							return str;
					 	},
						 	aggregates: [{ '<b></b>':
				                   function (aggregatedValue, currentValue, column, record) {
				                    return aggregatedValue + currentValue ;
				               		 }
	          					 }],
							aggregatesrenderer:
	        					function (aggregates, column, element, summaryData1){
		                           var renderstring = \"<div class='jqx-widget-content jqx-widget-content-\" + theme + \"' style='float: left; width: 100%; height: 100%;'>\";
		                             $.each(aggregates, function (key, value) {
		                                renderstring += '<div style=\"color: ' + 'red' + '; position: relative; margin: 6px; text-align: right; overflow: hidden;\">'
		                                 + formatcurrency(value)
		                                 + \"&nbsp;\" + '</div>';
		                               });
		                             renderstring += \"</div>\";
		                            return renderstring;
	                           }
                      	}
                      	"/>
<@jqGrid clearfilteringbutton="true" editable="false" alternativeAddPopup="alterpopupWindow" columnlist=columnlist dataField=dataField
viewSize="20" showtoolbar="true" sortdirection="desc" filtersimplemode="true" url="jqxGeneralServicer?sname=JQxSalesOrderProducts&hasrequest=Y&commonChanelReport=SALES_ALL&commonTypeReport=SALES_IN&commonTypeTime=YEAR&commonYear=${currentYear}" showstatusbar="true"/>
