<script type="text/javascript" src="/highcharts/assets/js/highcharts.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-3d.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-more.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/exporting.js"></script>

<div id="container" style="min-width: 310px; max-width: 600px; height: 400px; margin: 0 auto"></div>

<script type="text/javascript">
    $(function () {
        var categories = ['0-4', '5-9', '10-14', '15-19',
            '20-24', '25-29', '30-34', '35-39', '40-44',
            '45-49', '50-54', '55-59', '60-64', '65-69',
            '70-74', '75-79', '80-84', '85-89', '90-94',
            '95-99', '100 + '];
        $('#container').highcharts({
            chart: {
                type: 'bar'
            },
            title: {
                text: 'Population Chart'
            },
            xAxis: [{
//                categories: categories,
                reversed: false,
                labels: {
                    step: 1
                }
            }, { // mirror axis on right side
                opposite: true,
                reversed: false,
//                categories: categories,
                linkedTo: 0,
                labels: {
                    step: 1
                }
            }],
            yAxis: {
                title: {
                    text: null
                },
                labels: {
                    formatter: function () {
                        return Math.abs(this.value);
                    }
                },
                min: -40,
                max: 40
            },

            plotOptions: {
                series: {
                    stacking: 'normal'
                }
            },

            tooltip: {
                formatter: function () {
                    return '<b>' + this.series.name + ', age ' + this.point.category + '</b><br/>' +
                            'Population: ' + Highcharts.numberFormat(Math.abs(this.point.y), 0);
                }
            }
        });
        loadPersonBirth(['company']);

        popup._addOK(function () {
            popup._close();
            loadPersonBirth(popup._getParty());
        });
    });

    function loadPersonBirth(group) {
        var chart = $('#container').highcharts();
        jQuery.ajax({
            url: 'personBirth',
            async: true,
            type: 'POST',
            data: {'gender': true, 'group' : group},
            beforeSend: function () {
                $("#checkoutInfoLoader").show();
            },
            success: function (data) {
                chart.xAxis[0].update({
                    categories: data.xAxis
                }, false);
                chart.xAxis[1].update({
                    categories: data.xAxis
                }, false);
//                chart.yAxis[0].update({title: {text: olapType}}, true);

                while (chart.series.length > 0) {
                    chart.series[0].remove(false);
                }

                for (var i in data.yAxis) {
                    chart.addSeries({name: i, data: data.yAxis[i]}, false);
                }
                chart.redraw();
            },
            complete: function () {
                $("#checkoutInfoLoader").hide();
            }
        });
    }
</script>

<div id="checkoutInfoLoader"
     style="overflow: hidden; position: absolute; width: 1120px; height: 640px; display: none;z-index: 99999;margin-top: -250px"
     class="jqx-rc-all jqx-rc-all-olbius">
    <div style="z-index: 99999; margin-left: -66px; left: 50%; top: 5%; margin-top: -24px; position: relative; width: 100px; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;"
         class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
        <div style="float: left;">
            <div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
            <span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
        </div>
    </div>
</div>