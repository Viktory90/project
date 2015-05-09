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
                    ${uiLabelMap._facility_productId}
		        </div>
	            <div id='productId' style="float: right"></div>
            </div>
        </div>
        <div class="span6" style="margin-top:10px;margin-left: 20px">
                <div style="float:left;">
                    <div style='margin-top: 5px;float: left;width: 90px;'>
                    ${uiLabelMap._facility_dateType}
                    </div>
                    <div id="dateType" class="span2" style="display:inline-block; vertical-align:top;margin-left:0px !important;"></div>
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
                    ${uiLabelMap._facility_fromDate}
		        </div>
		        <div id="fromDate" class="span2" style="display:inline-block; vertical-align:top;margin-left:0px !important;"></div>
	        </div>
	        <div style="float:left;margin-left:20px;">
		        <div style='margin-top: 5px;float: left;width: 90px;'>
                    ${uiLabelMap._facility_thruDate}
		        </div>
		        <div id="thruDate" class="span2" style="display:inline-block; vertical-align:top;margin-left:0px !important;"></div>
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
<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

<script type="text/javascript">

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
    function loadPopup(facilityId, productId, fromDate, thruDate, olapType, dateType, geoId, geoType) {

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

        jQuery.ajax({
            url: 'getProduct',
            async: false,
            type: 'POST',
            success: function (data) {
                var source = [];
                source.push("ALL");
                for(var i in data.product) {
                    source.push(data.product[i]);
                }
                $("#productId").jqxDropDownList({source: source, selectedIndex: 1, width: '140', height: '25'});
                if (productId) {
                    $("#productId").val(productId);
                } else {
                    $("#productId").val("ALL");
                }
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

        $("#fromDate").jqxDateTimeInput({width: '140', height: '25', formatString: 'yyyy-MM-dd', theme: theme});
        $("#thruDate").jqxDateTimeInput({width: '140', height: '25', formatString: 'yyyy-MM-dd', theme: theme});

        $("#fromDate").val(fromDate);
        $("#thruDate").val(thruDate);
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

        var productId = $("#productId").val();
        if (!productId || productId == 'ALL') {
            productId = null;
        }
        var dateType = $("#dateType").val();
        if (!dateType) {
            dateType = null;
        }
        var olapType = $("#olapType").val();
        var fromDate = $("#fromDate").val();
        var thruDate = $("#thruDate").val();

        loadFacilityOlap(facilityId, productId, fromDate, thruDate, olapType, dateType, geoId, geoType,true);
        $('#window').jqxWindow('close');
    }

    function loadFacilityOlap(facilityId, productId, fromDate, thruDate, olapType, dateType, geoId, geoType, removeSeries) {
        $("#divFromDate").text(fromDate);
        $("#divThruDate").text(thruDate);
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
                'productId': productId,
                'fromDate': fromDate,
                'thruDate': thruDate,
                'dateType': dateType,
                'geoId': geoId,
                'geoType': geoType
            },
            success: function (data) {
                chart.xAxis[0].update({
                    labels: {enabled: true},
                    title: {text: dateType},
                    categories: data.xAxis
                }, false);
                chart.yAxis[0].update({title: {text: olapType}}, true);

                if (removeSeries) {
                    while (chart.series.length > 0) {
                        chart.series[0].remove(true);
                    }
                }

                for (var i in data.yAxis) {
                    chart.addSeries({name: i, data: data.yAxis[i]}, true);
                }

            },
            complete: function() {
                $("#checkoutInfoLoader").hide();
            }
        });
    }

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
                height: 190,
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

        var facilityId = '${facilityId?if_exists}';
        if (!facilityId) {
            facilityId = null;
        }
        var productId = '${productId?if_exists}';
        if (!productId) {
            productId = null;
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

        $('#container').highcharts({
            title: {
                text: '${StringUtil.wrapString(uiLabelMap._facility_title)}',
                x: -20 //center
            },
            subtitle: {
                text: '${StringUtil.wrapString(uiLabelMap._facility_subtitle)}',
                x: -20
            },
            xAxis: {
                labels: {
                    enabled: false
                }
            },
            yAxis: {
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            }
        });

        loadFacilityOlap(facilityId, productId, '${fromDate}', '${thruDate}', '${olapType}', dateType, geoId, geoType, true);
        popup.init();
        loadPopup(facilityId, productId, '${fromDate}', '${thruDate}', '${olapType}', dateType, geoId, geoType);
    });
</script>

<div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;z-index: 99999;margin-top: -250px" class="jqx-rc-all jqx-rc-all-olbius">
    <div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
        <div style="float: left;">
            <div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
            <span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
        </div>
    </div>
</div>