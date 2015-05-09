<script type="text/javascript" src="/highcharts/assets/js/highcharts.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-3d.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-more.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/exporting.js"></script>

<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

<script type="text/javascript">
    $(function(){
        $('#container').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Member Chart',
                x: -20 //center
            },
            subtitle: {
                text: 'Chart',
                x: -20
            },
            xAxis: {
                labels: {
                    enabled: true
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
            },
            plotOptions: {
                series: {
                    borderWidth: 0,
                    dataLabels: {
                        enabled: true
                    }
                }
            }
        });
        loadMemberOlap(['company']);

        popup._addOK(function () {
            popup._close();
            loadMemberOlap(popup._getParty());
        });
    });

    function loadMemberOlap(group) {
        var chart = $('#container').highcharts();
        var date = new Date();
        jQuery.ajax({
            url: 'member',
            async: true,
            type: 'POST',
            beforeSend: function () {
                $("#checkoutInfoLoader").show();
            },
            data: {
                'group': group,
                'child': true,
                'cur': true,
                'fromDate': '1990-01-01',
                'thruDate': date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()
            },
            success: function (data) {

                chart.xAxis[0].update({categories: data.xAxis}, false);
                chart.yAxis[0].update({title: {text: 'number'}}, true);

                    while (chart.series.length > 0) {
                        chart.series[0].remove(true);
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
</script>

<div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;z-index: 99999;margin-top: -250px" class="jqx-rc-all jqx-rc-all-olbius">
    <div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
        <div style="float: left;">
            <div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
            <span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
        </div>
    </div>
</div>