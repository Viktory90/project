<script type="text/javascript" src="/highcharts/assets/js/highcharts.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-3d.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-more.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/exporting.js"></script>

<div class="clearfix"></div>
<div id="container" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>

<script type="text/javascript">


    $(function () {
        $('#container').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Position Chart'
            },
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

        loadPosition([]);
        
        popup._addOK(function () {
            popup._close();
            loadPosition(popup._getParty());
        });
    });

    function loadPosition(group) {

        var chart = $('#container').highcharts();
        jQuery.ajax({
            url: 'position',
            async: true,
            type: 'POST',
            beforeSend: function () {
                $("#checkoutInfoLoader").show();
            },
            data: {'group' : group},
            success: function (data) {

                if(!data.xAxis) {
                    chart.series[0].setData(null);
                    chart.setTitle({
                        text : null
                    }, {
                        text : null
                    });
                } else {

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

</script>

<div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;z-index: 99999;margin-top: -250px" class="jqx-rc-all jqx-rc-all-olbius">
    <div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
        <div style="float: left;">
            <div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
            <span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
        </div>
    </div>
</div>