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
                        <button id="CompareButtonSales"  type="button" class="btn btn-small btn-primary" name="submitButton" ><i class="icon-ok"></i>${uiLabelMap.DAViewSalesStatement}</button>

                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<div style="clear:both"></div>
<hr/>
<div id="over_1" style="width: 100%;overflow:auto;">
    <div style="text-align:right">
        <h5 class="lighter block green" style="float:left"><b>Doanh số năm:</b><span id="text_one"></span></h5>
    </div>
    <div id="tree_year_one"></div>
</div>
<div style="clear:both"></div>
<hr/>
<div id="over_2" style="width: 100%;overflow:auto;">
    <div style="text-align:right">
        <h5 class="lighter block green" style="float:left"><b>Doanh số năm: </b><span id="text_two"></span></h5>
    </div>
    <div id="tree_year_two"></div>
</div>
<hr/>
<div id="over_3" style="width: 100%;overflow:auto;">
    <div style="text-align:right">
        <h5 class="lighter block green" style="float:left"><b>So sánh doanh số 2 năm: </b><span id="text_three"></span></h5>
    </div>
    <div id="tree_year_three"></div>
</div>
<#assign dataFields="[{name:'id',type:'string'},{name:'name',type:'string'},{name:'parentId',type:'string'},{name:'child',type:'array'},{ name: 'expanded',
          type: 'bool'}," />
<#assign columnList="[{text:'${uiLabelMap.organizationName}',datafield: 'name',width:250, align: 'center'},"/>
<#assign columnList_extends="[{text:'${uiLabelMap.organizationName}',datafield: 'name',width:250, align: 'center'},"/>
<#if productList?exists>
    <#list productList  as item>
        <#assign dataFields=dataFields+"{name:'${item.productId}',type:'string'},"/>
        <#if item.internalName?has_content>
            <#assign name=item.internalName/>
        <#else>
            <#assign name=item.productId/>
        </#if>
        <#assign columnList=columnList+"{text:'${name}',columngroup:'Product','cellsFormat':'D',datafield: '${item.productId}',width:100, cellsalign: 'right'},"/>
        <#assign columnList_extends=columnList_extends+"{text:'${name}',columngroup:'Product','cellsFormat':'p',datafield: '${item.productId}',width:100, cellsalign: 'right'},"/>
    </#list>
</#if>
<#assign dataFields=dataFields+"{name:'grandTotal',type:'string'}]" />
<#assign columnList=columnList+"{text:'${uiLabelMap.totalAmount}',datafield: 'grandTotal',cellsFormat: 'c0',width:150, align: 'center'}]"/>
<#assign columnList_extends=columnList_extends+"{text:'${uiLabelMap.totalAmount}',datafield: 'grandTotal',cellsFormat: 'p',width:150, align: 'center'}]"/>


<script type="text/javascript">
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
    var value2= $("#year_two").val();
    var value1= $("#year_one").val();

    $(document).ready(function () {
        $.jqx.theme = 'olbius';
        theme = $.jqx.theme;
        var data = getDataSalesGrowthOfDistributor(value1,value2);
        var getLocalization = function () {
            var localizationobj = {};
            localizationobj.currencySymbol = "đ";
            localizationobj.currencySymbolPosition = "after";
            return localizationobj;
        }
        var source_one =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: data.listOne_1
        };
        var source_two =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: data.listOne_2
        };

        var source_three =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: data.listOne_3
        };

        var dataAdapter_two="";
        var dataAdapter_one="";
        var dataAdapter_three="";
        dataAdapter_three= new $.jqx.dataAdapter(source_three);

        if(value1>value2){
            dataAdapter_one = new $.jqx.dataAdapter(source_two);
            dataAdapter_two = new $.jqx.dataAdapter(source_one);
            $("#text_one").text(value2);
            $("#text_two").text(value1);
            $("#text_three").text(value2+" và "+value1);
        }else{
            dataAdapter_one = new $.jqx.dataAdapter(source_one);
            dataAdapter_two = new $.jqx.dataAdapter(source_two);

            $("#text_one").text(value1);
            $("#text_two").text(value2);
            $("#text_three").text(value1+" và "+value2);
        }
        // create jqxTreeGrid.
        $("#tree_year_one").jqxTreeGrid(
                {
                    source: dataAdapter_one,
                    altRows: true,
                    columnsResize: true,
                    localization: getLocalization(),
                    ready: function () {
                        $("#tree_year_one").jqxTreeGrid('expandRow', '3');
                        $("#tree_year_one").jqxTreeGrid('expandRow', '5');
                    },
                    columns: ${columnList},
                    columnGroups: [
                        {text: "Product", name: "Product", align: "center"}
                    ]
                });



        $("#tree_year_two").jqxTreeGrid(
                {
                    source: dataAdapter_two,
                    altRows: true,
                    columnsResize: true,
                    localization: getLocalization(),
                    ready: function () {
                        $("#tree_year_two").jqxTreeGrid('expandRow', '3');
                        $("#tree_year_two").jqxTreeGrid('expandRow', '5');
                    },
                    columns: ${columnList},
                    columnGroups: [
                        {text: "Product", name: "Product", align: "center"}
                    ]
                });

        $("#tree_year_three").jqxTreeGrid(
                {
                    source: dataAdapter_three,
                    altRows: true,
                    columnsResize: true,
                    localization: getLocalization(),
                    ready: function () {
                        $("#tree_year_three").jqxTreeGrid('expandRow', '3');
                        $("#tree_year_three").jqxTreeGrid('expandRow', '5');
                    },
                    columns: ${columnList_extends},
                    columnGroups: [
                        {text: "Product", name: "Product", align: "center"}
                    ]
                });
    });

    $("#CompareButtonSales").on('click',function(){
        value2= $("#year_two").val();
        value1= $("#year_one").val();

        var newData= getDataSalesGrowthOfDistributor(value1,value2);

        var source_one =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: newData.listOne_1
        };
        var source_two =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: newData.listOne_2
        };

        var source_three =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: newData.listOne_3
        };

        var dataAdapter_two="";
        var dataAdapter_one="";
        var dataAdapter_three="";
        dataAdapter_three= new $.jqx.dataAdapter(source_three);

        if(value1>value2){
            dataAdapter_one = new $.jqx.dataAdapter(source_two);
            dataAdapter_two = new $.jqx.dataAdapter(source_one);
            $("#text_one").empty();
            $("#text_two").empty();
            $("#text_three").empty();

            $("#text_one").text(value2);
            $("#text_two").text(value1);
            $("#text_three").text(value2+" và "+value1);
        }else{
            dataAdapter_one = new $.jqx.dataAdapter(source_one);
            dataAdapter_two = new $.jqx.dataAdapter(source_two);
            $("#text_one").empty();
            $("#text_two").empty();
            $("#text_three").empty();

            $("#text_one").text(value1);
            $("#text_two").text(value2);
            $("#text_three").text(value1 +" và "+value2);
        }
        $("#tree_year_one").jqxTreeGrid(
                {
                    source: dataAdapter_one
                });

        $("#tree_year_one").jqxTreeGrid('updateBoundData');

        $("#tree_year_two").jqxTreeGrid(
                {
                    source: dataAdapter_two
                });
        $("#tree_year_two").jqxTreeGrid('updateBoundData');

        $("#tree_year_three").jqxTreeGrid(
                {
                    source: dataAdapter_three
                });
        $("#tree_year_three").jqxTreeGrid('updateBoundData');


    });

    function getDataSalesGrowthOfDistributor(year1, year2){
        var jsc = Array();
        $.ajax({
            url: '<@ofbizUrl>getDataSalesGrowthOfDistributor</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            data: {year_one:year1,year_two:year2},
            async: false,
            success: function (data) {
                jsc = data;
            }
        });
        return jsc;
    }

</script>