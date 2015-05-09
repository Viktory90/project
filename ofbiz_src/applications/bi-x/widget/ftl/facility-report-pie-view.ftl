<script type="text/javascript" src="/highcharts/assets/js/highcharts.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-3d.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-more.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/exporting.js"></script>

<@jqGridMinimumLib/>
<div id="window" style="display: none;">
    <div id="windowHeader">
        <span>
            Configuration
        </span>
    </div>
    <div style="overflow: hidden;" id="windowContent">
        <div class="span6" style="margin-left: 20px">
            <div style="float:left;">
                <div id="objectType" style='float: left;margin-left:-12px;width: 100px;'></div>
                <div id='objectId' style="float: right;"></div>
            </div>
            <div style="float:left;margin-left:20px;">
                <div style='margin-top: 5px;float: left;width: 90px;'>
                ${uiLabelMap._facility_olapType}
                </div>
                <div id='olapType' style="float: right"></div>
            </div>
        </div>
        <div class="span6" style="margin-top:10px;margin-bottom:10px;margin-left: 20px">
            <div style="float:left;">
                <div style='margin-top: 5px;float: left;width: 90px;'>
                ${uiLabelMap._facility_dateType}
                </div>
                <div id="dateType" class="span2" style="display:inline-block; vertical-align:top;margin-left:0px !important;"></div>
            </div>
            <div style="float:left;margin-left:20px;">
                <div style='margin-top: 5px;float: left;width: 90px;'>
                ${uiLabelMap._facility_thruDate}
                </div>
                <div id="date" class="span2" style="display:inline-block; vertical-align:top;margin-left:0px !important;"></div>
            </div>
        </div>
        <div class="span4" style="margin:0px auto;text-align: center;margin-left:80px;">
            <button type="button" class="btn btn-primary btn-mini"
                    onClick="load()" style="margin:0px auto;">
                <i class="icon-ok"></i>OK
            </button>
        </div>
    </div>
</div>
<div style='margin-top: 3px;'>
    <button id="btn_olap" type="button" class="btn btn-primary btn-mini" style="float:right;">
        <i class="fa-cogs"></i>
    </button>
</div>
<div class="clearfix"></div>
<div id="container" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>

<script type="text/javascript">

    var popup = (function () {
        function _addEventListeners() {
            $('#btn_olap').click(function () {
                $('#window').jqxWindow('open');
            });
        };
        function _createWindow() {
            $('#window').jqxWindow({
                showCollapseButton: false,
                maxWidth: 800,
                isModal: true,
                minWidth: 500,
                height: 150,
                width: 540,
                resizable: false, draggable:true,
                initContent: function () {
                    $('#window').jqxWindow('focus');
                    $('#window').jqxWindow('close');
                }
            });
        };
        return {
            config: {
                dragArea: null
            },
            init: function () {
                _addEventListeners();
                _createWindow();
            }
        };
    }());

    $(function () {
        $('#container').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
//            title: {
                <#--text: '${StringUtil.wrapString(uiLabelMap._facility_title)}'-->
//            },
//            subtitle: {
//                text: 'test'
//            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: [{
                type: 'pie', name: 'Browser share'
            }]
        });

        var facilityId = '${facilityId?if_exists}';
        if (!facilityId) {
            facilityId = null;
        }
        var dateType = '${dateType?if_exists}';

        if (!dateType) {
            dateType = null;
        }

        var geoId = '${geoId?if_exists}';
        if (!geoId) {
            geoId = null;
        }

        var geoType = '${geoType?if_exists}';
        if (!geoType) {
            geoType = null;
        }

        popup.init();
        loadPopup(facilityId, '${date}', '${olapType}', dateType,  geoId, geoType);
        loadFacilityOlap(facilityId, '${date}', '${olapType}', dateType, geoId, geoType);
    });

    function loadFacilityOlap(facilityId, date, olapType, dateType, geoId, geoType) {
        var fromDate;

        var thruDate;

        var date = new Date(date);

        date.setHours(0,0,0);

        if(dateType == "DAY") {
            fromDate = date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
            thruDate = fromDate
        }
        if(dateType == "WEEK") {
            var date2 = new Date(date.getFullYear(), date.getMonth(), date.getDate() - date.getDay(), 0, 0, 0);
            fromDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
            date2 = new Date(date.getFullYear(), date.getMonth(), date.getDate() + 6 - date.getDay(), 0, 0, 0);
            thruDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
        }
        if(dateType == "MONTH") {
            var date2 = new Date(date.getFullYear(), date.getMonth(), 1, 0, 0, 0);
            fromDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
            date2 = new Date(date2.getFullYear(), date2.getMonth()+1, 0, 0, 0, 0);
            thruDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
        }
        if(dateType == "QUARTER") {
            var month = date.getMonth();
            var quarter = Math.floor(month/3);
            console.log(quarter);
            var date2 = new Date(date.getFullYear(), 12 * quarter / 4, 1, 0, 0, 0);
            fromDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
            date2 = new Date(date2.getFullYear(), date2.getMonth()+3, 0, 0, 0, 0);
            thruDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
        }
        if(dateType == "YEAR") {
            var date2 = new Date(date.getFullYear(), 0, 1, 0, 0, 0);
            fromDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
            date2 = new Date(date2.getFullYear(), 11, 31, 0, 0, 0);
            thruDate = date2.getFullYear()+"-"+(date2.getMonth()+1)+"-"+date2.getDate();
        }

        var chart = $('#container').highcharts();
        jQuery.ajax({
            url: 'facilityProductOlap',
            async: true,
            type: 'POST',
            beforeSend: function () {
                $("#checkoutInfoLoader").show();
            },
            data: {
                'olapType': olapType,
                'facilityId': facilityId,
                'fromDate': fromDate,
                'thruDate': thruDate,
                'dateType': dateType,
                'geoId': geoId,
                'geoType': geoType
            },
            success: function (data) {

                if(!data.xAxis) {
                    chart.series[0].setData(null);
                    chart.setTitle({
                        text : null
                    }, {
                        text : null
                    });
                } else {
                    chart.setTitle({
                        text : $("#objectType").val() + " : " + $("#objectId").val()
                    }, {
                        text : $("#olapType").val() + " " + $("#dateType").val() + " : " + data.xAxis[0]
                    });

                    var array = [];

                    for (var i in data.yAxis) {
                        var tmp = [];
                        tmp.push(i);
                        tmp.push(data.yAxis[i][0]);
                        array.push(tmp);
                    }
                    chart.series[0].setData(array);
                }

            },
            complete: function() {
                $("#checkoutInfoLoader").hide();
            }
        });
    }

    function loadFacility(facility) {
        jQuery.ajax({
            url: 'getFacility',
            async: true,
            type: 'POST',
            success: function (data) {
                $("#objectId").jqxDropDownList('clear');
                $("#objectId").jqxDropDownList('addItem', "ALL");
                for(var i in data.facility) {
                    $("#objectId").jqxDropDownList('addItem', data.facility[i]);
                }
                if(facility) {
                    $("#objectId").val(facility);
                } else {
                    $("#objectId").val("ALL");
                }
            }
        });
    }
    function loadGeo(geoType, geoId) {
        jQuery.ajax({
            url: 'getGeo',
            async: true,
            type: 'POST',
            data: {'geoType' : geoType},
            success: function (data) {
                $("#objectId").jqxDropDownList('clear');
                $("#objectId").jqxDropDownList('addItem', "ALL");
                for(var i in data.geo) {
                    $("#objectId").jqxDropDownList('addItem', data.geo[i]);
                }
                if(geoId) {
                    $("#objectId").val(geoId);
                } else {
                    $("#objectId").val("ALL");
                }
            }
        });
    }
    function loadPopup(facilityId, date, olapType, dateType, geoId, geoType) {

        $("#objectId").jqxDropDownList({selectedIndex: 1, width: '140', height: '25'});

        jQuery.ajax({
            url: 'getGeoType',
            async: false,
            type: 'POST',
            success: function (data) {
                var source = [];
                source.push("${StringUtil.wrapString(uiLabelMap._facility_facilityId)}");
                for(var i in data.geoType) {
                    source.push(data.geoType[i]);
                }
                $("#objectType").jqxDropDownList({source: source, selectedIndex: 1, width: '100', height: '25'});
                if (!facilityId && geoType) {
                    $("#objectType").val(geoType);
                    loadGeo(geoType, geoId);
                } else {
                    $("#objectType").val("${StringUtil.wrapString(uiLabelMap._facility_facilityId)}");
                    loadFacility(facilityId);
                }
                $('#objectType').on('select', function (event) {
                    var args = event.args;
                    var item = $('#objectType').jqxDropDownList('getItem', args.index);
                    if (item != null) {
                        if(item.label == "${StringUtil.wrapString(uiLabelMap._facility_facilityId)}") {
                            loadFacility(null)
                        } else {
                            loadGeo(item.label, null);
                        }
                    }
                });
            }
        });

        $("#olapType").jqxDropDownList({
            source: ["RECEIVE", "EXPORT", "INVENTORY", "BOOK", "AVAILABLE"],
            selectedIndex: 1,
            width: '140',
            height: '25'
        });
        $("#olapType").val(olapType);
        $("#dateType").jqxDropDownList({
            source: ["DAY", "WEEK", "MONTH", "QUARTER", "YEAR"],
            selectedIndex: 1,
            width: '140',
            height: '25'
        });
        $("#dateType").val(dateType);

        $.jqx.theme = 'olbius';
        var theme = $.jqx.theme;

        $("#date").jqxDateTimeInput({width: '140', height: '25', formatString: 'yyyy-MM-dd', theme: theme});

        $("#date").val(date);
    }

    function load() {

        var objectType = $("#objectType").val();

        var objectId = $("#objectId").val();

        var facilityId;
        var geoId;
        var geoType;

        if(objectType == "${StringUtil.wrapString(uiLabelMap._facility_facilityId)}") {
            facilityId = objectId;
            if (!facilityId || facilityId == 'ALL') {
                facilityId = null;
            }
            geoId = null;
            geoType = null;
        } else {
            geoType = objectType;
            geoId = objectId;
            if (!geoId || geoId == 'ALL') {
                geoId = null;
            }
            facilityId = null
        }

        var dateType = $("#dateType").val();
        if (!dateType) {
            dateType = null;
        }

        var olapType = $("#olapType").val();
        var date = $("#date").val();

        loadFacilityOlap(facilityId, date, olapType, dateType, geoId, geoType,true);
        $('#window').jqxWindow('close');
    }
</script>

<div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;z-index: 99999;margin-top: -250px" class="jqx-rc-all jqx-rc-all-olbius">
    <div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
        <div style="float: left;">
            <div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
            <span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
        </div>
    </div>
</div>