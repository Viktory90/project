<script type="text/javascript">
    var customButtonsDemo = (function () {
        var _collapsed = false;
        function _addEventListeners() {
            $('#oder_year_showWindowButton').mousedown(function () {
                $('#oder_year_customWindow').jqxWindow('open');
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
            $('#oder_year_showWindowButton').jqxButton({ width: '80px'});
            $('#oder_year_customWindow').jqxWindow({
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
        $('#oder_year_container').highcharts({
            chart: {
                type: 'line'
            },
            title: {
                text: 'OLBIUS'
            },
            subtitle: {
                text: '2015'
            },
            xAxis: {
                categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
            },
            yAxis: {
                title: {
                    text: 'Doanh số (VNĐ)'
                }
            },
           
            tooltip: {
                valueSuffix: 'VNĐ'
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: []
        });
        customButtonsDemo.init();
        department= $("#SearchSalesMan_department").val();
        year= $("#year").val();
        var datalist= getDataSalesOrderYear(department,year);
        if(datalist){
            var chart = $('#oder_year_container').highcharts();
            chart.setTitle({text:"Doanh số bán hàng phòng"+" "+$("#SearchSalesMan_department").text()},{text:"${StringUtil.wrapString(uiLabelMap.CommonYear)}"+" "+year},true);
            for(i=0;i<datalist.length;i++){
                    chart.addSeries({name: datalist[i].name, data: datalist[i].data}, true);
            }
        }
    });

</script>
<div style="position: relative;">
    <div id="oder_year_container" style="margin-top: 10px;">
    </div>
</div>
<input type="button" value="Option" id="oder_year_showWindowButton" />
<div style="width: 100%; height: 650px;display:none;" id="jqxWidget">

    <div id="mainDemoContainer">
        <div id="oder_year_customWindow">
            <div id="customWindowHeader">
                <span id="captureContainer" style="float: left">Find </span>
            </div>
            <div id="customWindowContent" style="overflow: hidden">
                <div style="margin: 10px">
                    <form id="SearchSalesMan" name="SearchSalesMan">
                        <table border="0">
                            <tr>
                                <td>
                                    ${uiLabelMap.DASalesChannel}:
                                </td>
                                <td>
                                    <select name="chanelsales" id="SearchSalesMan_chanelsales" size="1">
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
                                    <select name="department" id="SearchSalesMan_department" size="1"> </select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                 ${uiLabelMap.CommonYear}
                                </td>
                                <td>
                                   <#assign currentYear = currentDateTime.get(Static["java.util.Calendar"].YEAR)>
                                   <input type="text" style="margin-bottom:0px;"class="input-mini" id="year" name="year"/>
                                </td>
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
    <#assign minYear = currentYear-15>
    <#assign maxYear = currentYear+15>
    <script type="text/javascript">
        function getDataSalesOrderYear(department, year){
            var jsc= new Array();
            $("#checkoutInfoLoader").show();
            setTimeout( $.ajax({
                url: '<@ofbizUrl>getDataReportSalesOrderYear</@ofbizUrl>',
                type: 'POST',
                dataType: 'json',
                data:{department:department,year:year},
                async:false,
                beforeSend: function () {
						$("#checkoutInfoLoader").show();
				}, 
                success:function(data){
                    jsc=data;
                },
                complete: function() {
				        $("#checkoutInfoLoader").hide();
			    }
            }),5000);
            return jsc;
        }
         jQuery('#year').ace_spinner({value:${currentYear},min:${minYear},max:${maxYear},step:1, icon_up:'icon-caret-up', icon_down:'icon-caret-down'});

        $("#searchTextButton").on("click",function(){
            $('#oder_year_customWindow').jqxWindow('close');
            department= $("#SearchSalesMan_department").val();
            year= $("#year").val();
            var dataclick= getDataSalesOrderYear(department,year);
            if(dataclick){
                var chart = $('#oder_year_container').highcharts();
                while (chart.series.length > 0) {
                    chart.series[0].remove(true);
                }
                for(i=0;i<dataclick.length;i++){
                    chart.addSeries({name: dataclick[i].name, data: dataclick[i].data}, true);
                }
                chart.setTitle({text:"Doanh số bán hàng phòng"+" "+$("#SearchSalesMan_department").text()},{text:"${StringUtil.wrapString(uiLabelMap.CommonYear)}"+" "+year},true);
            }

        });
    </script>