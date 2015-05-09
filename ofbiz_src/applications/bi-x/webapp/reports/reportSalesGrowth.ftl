<link rel="stylesheet" href="/aceadmin/jqw/jqwidgets/styles/jqx.base.css" type="text/css" />
<script type="text/javascript" src="/highcharts/assets/js/highcharts.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-3d.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-more.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/exporting.js"></script>
<@jqGridMinimumLib/>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdatatable.js"></script>
<script type="text/javascript"  src="/aceadmin/jqw/jqwidgets/jqxtreegrid.js"></script>
<script type="text/javascript" src="/delys/images/js/bootbox.min.js"></script>
<script type="text/javascript"  src="/aceadmin/jqw/jqwidgets/jqxcombobox.js"></script>

<div id="screenlet_1_col" class="widget-body-inner">
    <div class="widget-body">
        <form class="form-horizontal" name="salesGrowth" id="salesGrowth">
            <div class="row-fluid">
                <div class="control-group no-left-margin ">
                    <label class="">
                        <label for="getInforDepartment_department" class="control-label" id="getInforDepartment_department_title">Sản phẩm</label>
                    </label>
                    <div class="controls">
						<span class="ui-widget">
							<select name="product" id="salesGrowth_product" size="1">
                            <#assign keys = mapProduct.keySet() !/>
                            <#if keys?exists>
                                <#list keys as key>
                                    <option value="${key}">${mapProduct.get(key)}</option>
                                </#list>
                            </#if>
                            </select>
						</span>
                    </div>
                </div>

                <div class="control-group no-left-margin span12">
                    <label class="">
                        <label for="getInforDepartment_department" class="control-label" id="getInforDepartment_department_title">So sánh năm </label>
                    </label>

                    <div class="controls">
                        <div  style="float: left;margin-right: 20px;" id='year_one'></div>
                        <span style="float: left;margin-right: 20px;"> và </span>
                        <div   id='year_two'></div>

                    </div>
                </div>
                <div class="control-group no-left-margin ">
                    <label class="">
                        &nbsp;  </label>
                    <div class="controls">
                        <button id="CompareButton" disabled="true" type="button" class="btn btn-small btn-primary" name="submitButton" ><i class="icon-ok"></i>${uiLabelMap.DAViewSalesStatement}</button>

                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
    $("#salesGrowth_product").jqxComboBox({ width: 256, height: 25 });
    var date = new Date();
    var year= date.getFullYear();
    date.setYear(year-1);

    $("#year_one").jqxDateTimeInput({
        width: '100px',
        height: '25px',
        theme: 'energyblue',
        formatString: "yyyy"
    });

    //prepare for first run
    $('#year_one ').jqxDateTimeInput('setDate', date);

    $("#year_two").jqxDateTimeInput({
        width: '100px',
        height: '25px',
        theme: 'energyblue',
        formatString: "yyyy"
    });

    var value1= $("#year_two").val();
    var value2= $("#year_one").val();
    var productId= $("#salesGrowth_product").val();
    var productName= $("#salesGrowth_product>option:selected").text();
    var subtittle= "";

    if(value1 != null && value1 !== undefined && value2!=null && value2 !=undefined && value1 !=value2 ){
        $("#CompareButton").attr('disabled',false);
    }else{
        $("#CompareButton").attr('disabled',true);
    }
    $('#year_two').on('valueChanged', function (event) {
        value1= $("#year_two").val();
        value2= $("#year_one").val();
        if(value1 != null && value1 !== undefined && value2!=null && value2 !=undefined && value1 !=value2 ){
            $("#CompareButton").attr('disabled',false);
        }else{
            $("#CompareButton").attr('disabled',true);
            bootbox.alert("Khong duoc de trong các trường hoặc cùng năm ", function(result) {
                if(result) {

                }
            });
        }
    });

    $('#year_one').on('valueChanged', function (event) {
        value1= $("#year_two").val();
        value2= $("#year_one").val();
        if(value1 != null && value1 !== undefined && value2!=null && value2 !=undefined && value1 !=value2 ){
            $("#CompareButton").attr('disabled',false);
        }else{
            $("#CompareButton").attr('disabled',true);
            bootbox.alert("Khong duoc de trong các trường hoặc cùng năm ", function(result) {
                if(result) {

                }
            });
        }
    });

    // click event on button CompareButton

    var columnList='[{"text":"${StringUtil.wrapString(uiLabelMap.organizationName)}","datafield": "name","width":450, "align": "center"},';
    var dataFields='[{"name":"id","type":"string"},{"name":"name","type":"string"},{"name":"parentId","type":"string"},{ "name": "expanded","type": "bool"},';
    if(value1>value2){
        dataFields=dataFields+'{"name":"'+value2+'","type":"string"},{"name":"'+value1+ '","type":"string"}, {"name":"percent","type":"string"}]';
        columnList=columnList+'{"text":"'+value2+'","type":"string","cellsFormat":"D","width":220, "columngroup":"'+productId+'","datafield":"'+value2+'"},{"text":"'+value1+'","cellsFormat":"D","type":"string","width":220,"columngroup":"'+productId+'","datafield":"'+value1+'"},';
        subtittle= value2.concat(" - ",value1);
    }else{
        dataFields=dataFields+'{"name":"'+value1+'","type":"string"},{"name":"'+value2+ '","type":"string"}, {"name":"percent","type":"string"}]';
        columnList=columnList+'{"text":"'+value1+'","width":220,"cellsFormat":"D","type":"string", "columngroup":"'+productId+'","datafield":"'+value1+'"},{"text":"'+value2+'","cellsFormat":"D","width":220,"type":"string","columngroup":"'+productId+'","datafield":"'+value2+'"},';
        subtittle= value1.concat(" - ",value2);
    }
    columnList=columnList+'{"text":"${StringUtil.wrapString(uiLabelMap.OlapPercent)}","cellsFormat":"p","type":"string","width":220,"datafield":"percent","align": "center"}]';


    var columnGroup= '[{"text": "'+productName+'", "name": "'+productId+'", "align": "center"}]';






    $(document).ready(function () {
        $.jqx.theme = 'olbius';
        theme = $.jqx.theme;

        var result= getDataSalesGrowth(value1,value2,productId);
        var data= result.result;
        var xfield = JSON.parse(dataFields);
        var source =
        {
            dataType: "json",
            dataFields:xfield,
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: data
        };

        var dataAdapter = new $.jqx.dataAdapter(source);
        var objColGroup= JSON.parse(columnGroup);
        var obColumnlist = JSON.parse(columnList);
        var quantity_data= result.dataColumsQuan;
        var bill_data=result.dataColumsBill;
        $("#tree_sales_growth").jqxTreeGrid(
                {
                    source: dataAdapter,
                    altRows: true,
                    columnsResize: true,
//                    localization: getLocalization(),
                    ready: function () {
                        $("#tree_sales_growth").jqxTreeGrid('expandRow', '3');
                        $("#tree_sales_growth").jqxTreeGrid('expandRow', '5');
                    },
                    columns: obColumnlist,
                    columnGroups:objColGroup
                });

        $('#quantity_col').highcharts({
            chart: {
                type: 'column'
            },
            colors: ['#90ed7d', '#f7a35c', '#8085e9',
                '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],
            title: {
                text: "${StringUtil.wrapString(uiLabelMap.OlapQuantitySales)}"
            },
            subtitle: {
                text: subtittle
            },
            xAxis: {
                categories: ['Số lượng']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Đơn vị cơ bản'
                }
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0,
                    dataLabels: {
                        enabled: true
                    }

                }
            },
            series:quantity_data
        });


    $('#bill_col').highcharts({
        chart: {
            type: 'column'
        },
        colors: ['#90ed7d', '#f7a35c', '#8085e9',
            '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],
        title: {
            text: "${StringUtil.wrapString(uiLabelMap.OlapBillSales)}"
        },
        subtitle: {
            text: subtittle
        },
        xAxis: {
            categories: ['Doanh thu']
        },
        yAxis: {
            min: 0,
            title: {
                text: 'VNĐ'
            }
        },
        tooltip: {
            valueSuffix: ' VNĐ'
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0,
                dataLabels: {
                    enabled: true
                }

            }
        },
        series:bill_data
    });

    });
    $("#CompareButton").on('click',function(){
        value1= $("#year_two").val();
        value2= $("#year_one").val();
        productId= $("#salesGrowth_product").val();
        productName= $("#salesGrowth_product>option:selected").text();

        columnList='[{"text":"${StringUtil.wrapString(uiLabelMap.organizationName)}","datafield": "name","width":450, "align": "center"},';
        dataFields='[{"name":"id","type":"string"},{"name":"name","type":"string"},{"name":"parentId","type":"string"},{ "name": "expanded","type": "bool"},';
        if(value1>value2){
            dataFields=dataFields+'{"name":"'+value2+'","type":"string"},{"name":"'+value1+ '","type":"string"}, {"name":"percent","type":"string"}]';
            columnList=columnList+'{"text":"'+value2+'","type":"string","cellsFormat":"D","width":220, "columngroup":"'+productId+'","datafield":"'+value2+'"},{"text":"'+value1+'","cellsFormat":"D","type":"string","width":220,"columngroup":"'+productId+'","datafield":"'+value1+'"},';
            subtittle= value2.concat(" - ",value1);
        }else{
            dataFields=dataFields+'{"name":"'+value1+'","type":"string"},{"name":"'+value2+ '","type":"string"}, {"name":"percent","type":"string"}]';
            columnList=columnList+'{"text":"'+value1+'","width":220,"cellsFormat":"D","type":"string", "columngroup":"'+productId+'","datafield":"'+value1+'"},{"text":"'+value2+'","cellsFormat":"D","width":220,"type":"string","columngroup":"'+productId+'","datafield":"'+value2+'"},';
            subtittle= value1.concat(" - ",value2);
        }
        columnList=columnList+'{"text":"${StringUtil.wrapString(uiLabelMap.OlapPercent)}","cellsFormat":"p","type":"string","width":220,"datafield":"percent","align": "center"}]';


        columnGroup= '[{"text": "'+productName+'", "name": "'+productId+'", "align": "center"}]';


        result= getDataSalesGrowth(value1,value2,productId);
        data= result.result;
        xfield = JSON.parse(dataFields);
        source = {
            dataType: "json",
            dataFields:xfield,
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: data
        };


        dataAdapter = new $.jqx.dataAdapter(source);
        objColGroup= JSON.parse(columnGroup);
        obColumnlist = JSON.parse(columnList);
        quantity_data= result.dataColumsQuan;
        bill_data=result.dataColumsBill;
        $("#tree_sales_growth").jqxTreeGrid('destroy');
        $("#parentTree").append("<div id='tree_sales_growth'></div>")
        $("#tree_sales_growth").jqxTreeGrid(
                {
                    source: dataAdapter,
                    altRows: true,
                    columnsResize: true,
                    ready: function () {
                        $("#tree_sales_growth").jqxTreeGrid('expandRow', '3');
                        $("#tree_sales_growth").jqxTreeGrid('expandRow', '5');
                    },
                    columns: obColumnlist,
                    columnGroups:objColGroup
                });

        $("#tree_sales_growth").jqxTreeGrid('updateBoundData');

        var chart_quant= $('#quantity_col').highcharts();
        if(chart_quant){
            chart_quant.destroy();
        }

        $('#quantity_col').highcharts({
            chart: {
                type: 'column'
            },
            colors: ['#90ed7d', '#f7a35c', '#8085e9',
                '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],
            title: {
                text: "${StringUtil.wrapString(uiLabelMap.OlapQuantitySales)}"
            },
            subtitle: {
                text: subtittle
            },
            xAxis: {
                categories: ['Số lượng']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Đơn vị cơ bản'
                }
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0,
                    dataLabels: {
                        enabled: true
                    }

                }
            },
            series:quantity_data
        });

        var chart_bill=  $('#bill_col').highcharts();

        if(chart_bill){
            chart_bill.destroy();
        }
        $('#bill_col').highcharts({
            chart: {
                type: 'column'
            },
            colors: ['#90ed7d', '#f7a35c', '#8085e9',
                '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],
            title: {
                text: "${StringUtil.wrapString(uiLabelMap.OlapBillSales)}"
            },
            subtitle: {
                text: subtittle
            },
            xAxis: {
                categories: ['Doanh thu']
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'VNĐ'
                }
            },
            tooltip: {
                valueSuffix: ' VNĐ'
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0,
                    dataLabels: {
                        enabled: true
                    }

                }
            },
            series:bill_data
        });

    });

    function getDataSalesGrowth(year1, year2, productId){
        var jsc = Array();
        $.ajax({
            url: '<@ofbizUrl>getDataSalesGrowth</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            data: {year_one:year1,year_two:year2, productId: productId},
            async: false,
            success: function (data) {
                jsc = data;
            }
        });
        return jsc;
    }
</script>

    <hr/>
    <div style="clear:both"></div>
    <div style="text-align:right">
        <h5 class="lighter block green" style="float:left"><b>Số lượng sản phẩm bán trong cùng kì:</b></h5>
    </div>
    <div id="parentTree">
        <div id="tree_sales_growth"  style="width: 100%;">
        </div>
    </div>

    <div style="clear:both"></div>
    <hr/>
    <div style="text-align:right">
        <h5 class="lighter block green" style="float:left"><b>Biều đồ so sánh</b></h5>
    </div>
    <br/>
<div style="clear:both"></div>
<div class="row-fluid">
    <div  class="span6 no-left-margin">
        <div id="quantity_col"></div>
    </div>
    <div  class="span6">
        <div id="bill_col"></div>
    </div>
</div>

