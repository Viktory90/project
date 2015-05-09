<link rel="stylesheet" href="/aceadmin/jqw/jqwidgets/styles/jqx.base.css" type="text/css" />
<@jqGridMinimumLib/>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdatatable.js"></script>
<script type="text/javascript"  src="/aceadmin/jqw/jqwidgets/jqxtreegrid.js"></script>

<div id="screenlet_1_col" class="widget-body-inner">
    <div class="widget-body">
        <form class="form-horizontal" name="SalesIn" id="SalesIn">
            <div class="row-fluid">
                <div class="control-group no-left-margin ">
                    <label class="">
                        <label for="SalesIn_chanelsales" class="control-label" id="getInforDepartment_chanelsales_title">${uiLabelMap.PeriodTypeId}</label>
                    </label>
                    <div class="controls">
						<span class="ui-widget">
							<div id="sale_in_date_time"></div>
						</span>
                    </div>
                </div>

                <div class="control-group no-left-margin ">
                    <label class="">
                        &nbsp;  </label>
                    <div class="controls">
                        <button id="sale_in_button" type="button" class="btn btn-small btn-primary" name="submitButton" ><i class="icon-ok"></i>${uiLabelMap.DAViewSalesStatement}</button>

                    </div>
                </div>
            </div>
        </form>
    </div>
</div>

<#assign dataFields="[{name:'id',type:'string'},{name:'name',type:'string'},{name:'parentId',type:'string'},{name:'child',type:'array'},{ name: 'expanded',
          type: 'bool'}," />
<#assign columnList="[{text:'${uiLabelMap.organizationName}',datafield: 'name',width:250, align: 'center'},"/>
<#if productList?exists>
	<#list productList  as item>
	    <#assign dataFields=dataFields+"{name:'${item.productId}',type:'string'},"/>
	    <#if item.internalName?has_content>
	        <#assign name=item.internalName/>
	    <#else>
	        <#assign name=item.productId/>
	    </#if>
	    <#assign columnList=columnList+"{text:'${name}',columngroup:'Product',datafield: '${item.productId}',width:100, cellsalign: 'right'},"/>
	</#list>
</#if>
<#assign dataFields=dataFields+"{name:'grandTotal',type:'string'}]" />
<#assign columnList=columnList+"{text:'${uiLabelMap.totalAmount}',datafield: 'grandTotal',cellsFormat: 'c0',width:150, align: 'center'}]"/>

<script type="text/javascript">
    function getDataSalesIn(fromDate,thruDate) {
        var jsc = Array();
        $.ajax({
            url: '<@ofbizUrl>getDataSaleInWithRole</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            data: {fromDate:fromDate,thruDate:thruDate},
            async: false,
            success: function (data) {
                jsc = data;
            }
        });
        return jsc;
    }
    $(document).ready(function () {
        $.jqx.theme = 'olbius';
        theme = $.jqx.theme;
        $("#sale_in_date_time").jqxDateTimeInput({ width: 220, height: 25,  selectionMode: 'range' });
        var getLocalization = function () {
            var localizationobj = {};
            localizationobj.currencySymbol = "đ";
            localizationobj.currencySymbolPosition = "after";
            return localizationobj;
        }
        var data = getDataSalesIn();
//        console.log(data);
        var source =
        {
            dataType: "json",
            dataFields: ${dataFields},
            hierarchy: {
                keyDataField: { name: 'id' },
                parentDataField: { name: 'parentId' }
            },
            id:'id',
            localData: data
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        console.log(data);
        // create jqxTreeGrid.
        $("#treeGrid").jqxTreeGrid(
                {
                    source: dataAdapter,
                    altRows: true,
                    columnsResize: true,
                    localization: getLocalization(),
                    ready: function () {
                        $("#treeGrid").jqxTreeGrid('expandRow', '3');
                        $("#treeGrid").jqxTreeGrid('expandRow', '5');
                    },
                    columns: ${columnList},
                    columnGroups: [
                        {text: "Product", name: "Product", align: "center"}
                    ]
                });
    });

    $("#sale_in_button").on('click',function(){
        var fromDate="";
        var thruDate="";
        var b_date= $("#sale_in_date_time").val();
        if(b_date){
            var arr= b_date.split("-");
            if(arr.length==2){
                fromDate= arr[0].trim();
                thruDate=arr[1].trim();
            }
        }
        var tree= $("#treeGrid").jqxTreeGrid();
        var data= getDataSalesIn(fromDate,thruDate);
        if(data){
            var source =
            {
                dataType: "json",
                dataFields: ${dataFields},
                hierarchy: {
                    keyDataField: { name: 'id' },
                    parentDataField: { name: 'parentId' }
                },
                id:'id',
                localData: data
            };
            var dataAdapter = new $.jqx.dataAdapter(source);

            $("#treeGrid").jqxTreeGrid(
                    {
                        source: dataAdapter
                    });

            $("#treeGrid").jqxTreeGrid('updateBoundData');

        }

    });
</script>

<div id="treeGrid">
  
</div>