<script type="text/javascript">
    var customButtonsDemo = (function () {
        var _collapsed = false;
        function _addEventListeners() {
            $('#showWindowButton').mousedown(function () {
                $('#customWindow').jqxWindow('open');
            });
            _addCustomButtonsHandlers();
            _addSearchInputEventHandlers();
        };
        function _addCustomButtonsHandlers() {

        };
        function _addSearchInputEventHandlers() {
            $('#searchTextInput').keydown(function () {
                _searchButtonHandle();
            });
            $('#searchTextInput').change(function () {
                _searchButtonHandle();
            });
            $('#searchTextInput').keyup(function () {
                _searchButtonHandle();
            });
            $(document).mousemove(function () {
                _searchButtonHandle();
            });
        };
        function _searchButtonHandle() {
        };
        function _createElements() {
            $('#showWindowButton').jqxButton({ width: '80px'});
            $('#customWindow').jqxWindow({
                autoOpen: false,
                width: 350,
                height: 270, resizable: false,
                cancelButton: $('#cancelButton'),
                initContent: function () {
                    $('#searchTextButton').jqxButton({ width: '80px', disabled: false });
                }
            });
        };
        return {
            init: function () {
                _createElements();
                _addEventListeners();
            }
        };
    } ());
    $(document).ready(function () {
        var department= $("#SearchSalesMan2_department").val();
        var type_time=$("#type_time").val();
        var year="";
        var month="";
        var quarter=""
        var fromDate="";
        var thruDate="";
        var title="Doanh số bán hàng phòng"+" "+$("#SearchSalesMan2_department").text();
        var subtitle=""

        if(type_time){
            if("DATE"==type_time){
                var b_date= $("#inputjqxDate").val();
                if(b_date){
                    var arr= b_date.split("-");
                    if(arr.length==2){
                        console.log(arr[0].trim());
                        fromDate= arr[0].trim();
                        thruDate=arr[1].trim();
                    }
                }
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByDate)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapFrom)} "+fromDate+ "${StringUtil.wrapString(uiLabelMap.OlapTo)} "+thruDate;
            }else if("QUARTER"==type_time){
                quarter= $("#quarter").val();
                year=$("#year").val();
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByQuarter)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.CommonQuarter)} "+quarter+" ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("MONTH"==type_time){
                month=$("#month").val();
                year=$("#year").val();
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByMonth)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.CommonMonth)} "+month+" ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("YEAR"==type_time){
                year=$("#year").val();
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByYear)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }
        }
        Highcharts.setOptions({
            colors: ['#999900', '#FF9655', '#FFF263', '#6AF9C4']
        });
        customButtonsDemo.init();
        var data= getData2(department, type_time, month, quarter,year,fromDate,thruDate);
            $('#container').highcharts({
                chart: {
                    type: 'column'
                },
                title: {
                    text: 'OLBIUS'
                },
                subtitle: {
                    text: 'Code by Viet Anh Nguyen'
                },
                xAxis: {
                    type: 'category',
                    labels: {
                        rotation: -45,
                        style: {
                            fontSize: '13px',
                            fontFamily: 'Verdana, sans-serif'
                        }
                    }
                },
                yAxis: {
                    min: 0,
                    title: {
                        text: 'Doanh số'
                    }
                },
                legend: {
                    enabled: false
                },
                tooltip: {
                    valueSuffix: ' VNĐ'
                },
                series: [{
                    name: 'Doanh số',
                    data:[],
                    dataLabels: {
                        enabled: false,
                        rotation: -90,
                        color: '#FF9900',
                        align: 'right',
                        y: 10, // 10 pixels down from the top
                        style: {
                            fontSize: '13px',
                            fontFamily: 'Verdana, sans-serif'
                        }
                    }
                }]
            });

        var chart = $('#container').highcharts();
        chart.setTitle({text:title},{text:subtitle},true);
        chart.series[0].setData(data.result);
    });

</script>
<div style="position: relative;">
    <div id="container" style="margin-top: 10px;">
    </div>
</div>
<div style="width: 100%; height: 650px;" id="jqxWidget2">
    <input type="button" value="Option" id="showWindowButton" />
    <div id="mainDemoContainer">
        <div id="customWindow">
            <div id="customWindowHeader">
                <span id="captureContainer" style="float: left">Find </span>
            </div>
            <div id="customWindowContent" style="overflow: hidden">
                <div style="margin: 10px">
                    <form id="SearchSalesMan2" name="SearchSalesMan2">
                        <table border="0">
                            <tr>
                                <td>
                                ${uiLabelMap.DASalesChannel}:
                                </td>
                                <td>
                                    <select name="chanelsales" id="SearchSalesMan2_chanelsales" size="1">
                                        <option  value ="DELYS_SALESSUP_GT">${uiLabelMap.DAGTChannel}</option>
                                        <option  value ="DELYS_SALESSUP_MT">${uiLabelMap.DAMTChannel}</option>
                                    </select></br>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                ${uiLabelMap.OlapDepartment}
                                </td>
                                <td>
                                    <select name="department" id="SearchSalesMan2_department" size="1"> </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Xem báo cáo theo
                                </td>
                                <td>
                                    <select name="type_time" id="type_time">
                                        <option value="YEAR"> ${uiLabelMap.CommonYear}</option>
                                        <option value="MONTH"> ${uiLabelMap.CommonMonth}</option>
                                        <option value="QUARTER">${uiLabelMap.CommonQuarter}</option>
                                        <option value="DATE">${uiLabelMap.CommonDate}</option>
                                    </select>
                                </td>
                            </tr>
                            <tr id="type_child">

                            </tr>
                        </table>
                        <div style="text-align: center">
                            <input type="button" value="Find Next" style="margin-bottom: 5px;" id="searchTextButton" /><br />
                        </div>

                    </form>

                </div>
            </div>
        </div>
    </div>
</div>
<#assign currentYear = currentDateTime.get(Static["java.util.Calendar"].YEAR)>
<#assign currentMonth = currentDateTime.get(Static["java.util.Calendar"].MONTH) + 1>
<#assign minYear = currentYear-15>
<#assign maxYear = currentYear+15>
<script type="text/javascript">
    $("#type_time").change(function() {
        str= $(this).val();
        $("#type_child").empty();
        if("DATE"==str){
            var div= "<td>"+"${uiLabelMap.PeriodTypeId}"+"</td><td id='jqxDate'></td>";
            $("#type_child").append(div);
            $("#jqxDate").jqxDateTimeInput({ width: 220, height: 25,  selectionMode: 'range' });

        }else if("MONTH"==str){
            var div="<td>"+"${uiLabelMap.CommonMonth}"+"</td><td><input type='text' style='margin-bottom:0px;' name='month' class='input-mini' id='month' />"+"${uiLabelMap.CommonYear}"+" <input type='text' style='margin-bottom:0px;' name='year' class='input-mini' id='year' /></td>";
            $("#type_child").append(div);
            jQuery('#month').ace_spinner({value:${currentMonth},min:1,max:12,step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
            jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});

        }else if("YEAR"==str){
            var div="<td>"+"${uiLabelMap.CommonYear}"+"</td><td><input type='text' style='margin-bottom:0px;' name='year' class='input-mini' id='year' /></td>";
            console.log(div);
            $("#type_child").append(div);
            jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
        }else if("QUARTER"==str){
            var div="<td>"+"${uiLabelMap.CommonQuarter}"+"</td><td><input type='text' style='margin-bottom:0px;' name='quarter' class='input-mini' id='quarter' />"+"${uiLabelMap.CommonYear}"+"<input type='text' style='margin-bottom:0px;' name='year' class='input-mini' id='year' /></td>";
            $("#type_child").append(div);
            jQuery('#quarter').ace_spinner({value:1,min:1,max:4,step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
            jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});

        }

    }).trigger( "change" );
    function getData2(department, typeTime, month, quarter,year,fromDate,thruDate){
        var jsc= new Array();
        $.ajax({
            url: '<@ofbizUrl>getDataReportTotalProducSalesMan</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            data:{department:department,typeTime:typeTime,month:month,quarter:quarter, year:year,fromDate:fromDate,thruDate:thruDate},
            async:false,
            success:function(data){
                jsc=data;
            }
        });
        return jsc;
    }

    $("#searchTextButton").on("click",function(){
        $('#customWindow').jqxWindow('close');
        var department= $("#SearchSalesMan2_department").val();
        var type_time=$("#type_time").val();
        var year="";
        var month="";
        var quarter=""
        var fromDate="";
        var thruDate="";
        var title="Doanh số bán hàng phòng"+" "+$("#SearchSalesMan2_department").text();
        var subtitle=""
        if(type_time){
            if("DATE"==type_time){
                var b_date= $("#inputjqxDate").val();
                if(b_date){
                    var arr= b_date.split("-");
                    if(arr.length==2){
                        console.log(arr[0].trim());
                        fromDate= arr[0].trim();
                        thruDate=arr[1].trim();
                    }
                }
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByDate)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapFrom)} "+fromDate+ " ${StringUtil.wrapString(uiLabelMap.OlapTo)} "+thruDate;
            }else if("QUARTER"==type_time){
                quarter= $("#quarter").val();
                year=$("#year").val();
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByQuarter)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.CommonQuarter)} "+quarter+" ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("MONTH"==type_time){
                month=$("#month").val();
                year=$("#year").val();
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByMonth)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.CommonMonth)} "+month+" ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("YEAR"==type_time){
                year=$("#year").val();
                title=title+" ${StringUtil.wrapString(uiLabelMap.OlapByYear)}"
                subtitle="${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }
        }
        var datax=getData2(department, type_time, month, quarter,year,fromDate,thruDate);
        var chart = $('#container').highcharts();
        chart.setTitle({text:title},{text:subtitle},true);
        chart.series[0].setData(datax.result);
    });
</script>