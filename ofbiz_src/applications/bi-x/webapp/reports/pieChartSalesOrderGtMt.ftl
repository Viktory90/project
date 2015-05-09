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
                height: 200, resizable: false,
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
        customButtonsDemo.init();
        var type_report= $("#type_report").val();
        console.log(type_report);
        var type_time=$("#type_time").val();
        var year="";
        var month="";
        var quarter=""
        var fromDate="";
        var thruDate="";
        var subtitle="";
        var title="";
        if("SALES_IN"==type_report){
            title= " Sales in ";
        }else if("SALES_OUT"==type_report){
            title=" Sales out";
        }
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

                    subtitle="${StringUtil.wrapString(uiLabelMap.OlapByDate)},"+"${StringUtil.wrapString(uiLabelMap.OlapFrom)} "+fromDate+"${StringUtil.wrapString(uiLabelMap.OlapTo)} "+thruDate;
                }

            }else if("QUARTER"==type_time){
                quarter= $("#quarter").val();
                year=$("#year").val();
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapByQuarter)}"+", ${StringUtil.wrapString(uiLabelMap.CommonQuarter)} "+quarter+" ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("MONTH"==type_time){
                month=$("#month").val();
                year=$("#year").val();
                subtitle="${uiLabelMap.OlapByMonth}, ${uiLabelMap.CommonMonth} "+month+" ${uiLabelMap.CommonYear} "+year;
            }else if("YEAR"==type_time){
                year=$("#year").val();
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapByYear)}, ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }
        }
        dataLoad= getDataChartProductOrder(type_report,type_time,month,year,quarter,fromDate,thruDate);
        var chanelLoad=[];
        var drillLoad=[];
        if(dataLoad){
            chanelLoad= dataLoad.chanelSales;
            drillLoad= dataLoad.drillChanelSales;

        }

        Highcharts.setOptions({
            colors: ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4']
        });
        $('#container').highcharts({
            chart: {
                type: 'pie'
            },
            title: {
                text: "${StringUtil.wrapString(uiLabelMap.OlapReportSalesOrder)} "+title
            },
            subtitle: {
                text: subtitle
            },
            plotOptions: {
                series: {
                    dataLabels: {
                        enabled: true,
                        format: '{point.name}: {point.y:.1f}%'
                    }
                }
            },

            tooltip: {
                headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
                pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
            },

            series: [{
                name: 'Brands',
                colorByPoint: true,
                data: chanelLoad
            }],
            drilldown: {
                series: drillLoad
            }
        });

    });

</script>
<div style="position: relative;">

    <div id="container" style="margin-top: 10px;">

    </div>
    <div id="demo" style="margin-top: 10px;">

    </div>
</div>
<div style="width: 100%; height: 650px;" id="jqxWidget">
    <input type="button" value="Option" id="showWindowButton" />
    <div id="mainDemoContainer">
        <div id="customWindow">
            <div id="customWindowHeader">
                <span id="captureContainer" style="float: left">Find </span>
            </div>
            <div id="customWindowContent" style="overflow: hidden">
                <div style="margin: 10px">
                    <form id="SearchSalesMan" name="SearchSalesMan">
                        <table border="0">
                            <tr>
                                <td>
                                    ${uiLabelMap.OlapTypeReport}
                                </td>
                                <td>
                                    <select name="type_report" id="type_report">
                                        <option value="SALES_IN"> Sales in</option>
                                        <option value="SALES_OUT">Sales out</option>
                                    </select></br>
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
                            <input type="button" value="${uiLabelMap.commonSearch}" style="margin-bottom: 5px;" id="searchTextButton" /><br />
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
            var div="<td>"+"${uiLabelMap.CommonYear}"+"</td><td><input type='text' style='margin-bottom:0px;' name='year' class='input-mini' id='year' />";
            $("#type_child").append(div);
            jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
        }else if("QUARTER"==str){
            var div="<td>"+"${uiLabelMap.CommonQuarter}"+"</td><td><input type='text' style='margin-bottom:0px;' name='quarter' class='input-mini' id='quarter' />"+"${uiLabelMap.CommonYear}"+"<input type='text' style='margin-bottom:0px;' name='year' class='input-mini' id='year' /></td>";
            $("#type_child").append(div);
            jQuery('#quarter').ace_spinner({value:1,min:1,max:4,step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});
            jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});

        }

    }).trigger( "change" );

    $("#searchTextButton").click(function(){
        $('#customWindow').jqxWindow('close');
        var type_report= $("#type_report").val();
        var type_time=$("#type_time").val();
        var year="";
        var month="";
        var quarter=""
        var fromDate="";
        var thruDate="";
        var title="";
        if("SALES_IN"==type_report){
            title= " Sales in ";
        }else if("SALES_OUT"==type_report){
            title=" Sales out";
        }
        var subtitle="";
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
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapByDate)},"+"${StringUtil.wrapString(uiLabelMap.OlapFrom)} "+fromDate+"${StringUtil.wrapString(uiLabelMap.OlapTo)} "+thruDate;

            }else if("QUARTER"==type_time){
                quarter= $("#quarter").val();
                year=$("#year").val();
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapByQuarter)}"+", ${StringUtil.wrapString(uiLabelMap.CommonQuarter)} "+quarter+"${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("MONTH"==type_time){
                month=$("#month").val();
                year=$("#year").val();
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapByMonth)}, ${StringUtil.wrapString(uiLabelMap.CommonMonth)} "+month+" ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }else if("YEAR"==type_time){
                year=$("#year").val();
                subtitle="${StringUtil.wrapString(uiLabelMap.OlapByYear)}, ${StringUtil.wrapString(uiLabelMap.CommonYear)} "+year;
            }
        }
        data= getDataChartProductOrder(type_report,type_time,month,year,quarter,fromDate,thruDate);
        if(data){
            var chanel= data.chanelSales;
            var drill= data.drillChanelSales;
            var chart = $('#container').highcharts();

//            chart.series[0].setData(chanel);
//            chart.addSeriesAsDrilldown(null, drill);
//            console.log(chart);
            if(chart){
                chart.destroy();
            }

           $('#container').highcharts({
                chart: {
                    type: 'pie'
                },
                title: {
                    text: "${StringUtil.wrapString(uiLabelMap.OlapReportSalesOrder)}"+title
                },
                subtitle: {
                    text: subtitle
                },
                plotOptions: {
                    series: {
                        dataLabels: {
                            enabled: true,
                            format: '{point.name}: {point.y:.1f}%'
                        }
                    }
                },

                tooltip: {
                    headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
                    pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
                },

                series: [{
                    name: 'Brands',
                    colorByPoint: true,
                    data: chanel
                }],
                drilldown: {
                    series: drill
                }
            });
        }
    });

    function getDataChartProductOrder(typeReport,typeTime,month,year,quarter,fromDate,thruDate){
        var jsc="";
        $.ajax({
            url: '<@ofbizUrl>getDataChartProductOrder</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            data:{typeReport:typeReport,typeTime:typeTime, year:year,month:month,quarter:quarter,fromDate:fromDate, thruDate:thruDate},
            async:false,
            success:function(data){
                jsc=data;
            }
        });
        return jsc;
    }
</script>