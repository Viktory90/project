
<style type="text/css">
	.nav-pagesize select {
		padding:2px !important;
		margin:0 !important;
	}
</style>
    <div style="position:relative">
        <div class="widget-body">
            <div class="widget-main">
                <div class="row-fluid">
                    <div class="form-horizontal basic-custom-form form-decrease-padding" style="display: block;">
                        <table class="table table-striped table-bordered table-hover dataTable" cellspacing='0' style="width: 100%; margin-bottom: 2%;">
                            <thead>
                            <tr class="header-row">
                                <th width="3%">${uiLabelMap.DANo}</th>
                                <th>Mã service</th>
                                <th>Mô tả</th>
                                <th>Cấu hình Job với Ofbiz</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#if serviceDim?exists>
                                <#list serviceDim as item>
                                    <tr>
                                        <td >${item_index+1}</td>
                                        <td >${item.serviceId?if_exists}</td>
                                        <td>${item.description?if_exists}</td>
                                        <td style="text-align: center;font-size: large"><a href="<@ofbizUrl>editServiceJobDim?service_name=${item.serviceNameTranform?if_exists}</@ofbizUrl>"><i class="fa-gear"></i></a></td>
                                    </tr>
                                </#list>
                            </#if>


                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
        </div>
    </div>

<hr/>
<div style="clear:both"></div>
<div style="text-align:right">
    <div class="widget-box transparent no-bottom-border" id="screenlet_1">
        <div class="widget-header"><h4>Cấu hình trực tiếp Pentaho </h4></div>
        <div style="position:relative">
            <div id="checkoutInfoLoader" style="overflow: hidden; position: absolute; display: none; left: 45%; top: 25%; " class="jqx-rc-all jqx-rc-all-olbius">
                <div style="z-index: 99999; position: relative; width: auto; height: 33px; padding: 5px; font-family: verdana; font-size: 12px; color: #767676; border-color: #898989; border-width: 1px; border-style: solid; background: #f6f6f6; border-collapse: collapse;" class="jqx-rc-all jqx-rc-all-olbius jqx-fill-state-normal jqx-fill-state-normal-olbius">
                    <div style="float: left;">
                        <div style="float: left; overflow: hidden; width: 32px; height: 32px;" class="jqx-grid-load"></div>
                        <span style="margin-top: 10px; float: left; display: block; margin-left: 5px;">Loading...</span>
                    </div>
                </div>
            </div>
            <div class="widget-body">
                <div class="widget-main">
                    <div class="row-fluid">
                        <div class="form-horizontal basic-custom-form form-decrease-padding" style="display: block;">
                            <table class="table table-striped table-bordered table-hover dataTable" cellspacing='0' style="width: 100%; margin-bottom: 2%;">
                                <thead>
                                <tr class="header-row">
                                    <th width="3%" rowspan="2">${uiLabelMap.DANo}</th>
                                    <th rowspan="2" style="text-align: center;">Mã service</th>
                                    <th rowspan="2" style="text-align: center;">Mô tả</th>
                                    <th colspan="3" style="text-align: center">Run Job với pentaho</th>
                                    <th rowspan="2" style="text-align: center;">Run Tranfrom </br>Pentaho</th>
                                </tr>
                                <tr>
                                    <td style="text-align: center;">Status</td>
                                    <td style="text-align: center;">stop</td>
                                    <td style="text-align: center;">Run</td>
                                </tr>
                                </thead>
                                <tbody>
                                <#if serviceDim?exists>
                                    <#list serviceDim as item>
                                    <tr>
                                        <td >${item_index+1}</td>
                                        <td >${item.serviceId?if_exists}</td>
                                        <td>${item.description?if_exists}</td>
                                        <td id="status_${item_index}">${item.statusJob?if_exists}</td>
                                        <td style="text-align: center;font-size: large"><a href="#screenlet_1" onclick="runSynServicReturn('${item.serviceNameJobDestroy?if_exists}','status_${item_index}')" style="color: red;"><i class="fa-stop"></i></a></td>
                                        <td style="text-align: center;font-size: large;"><a href="#screenlet_1" onclick="runSynServicReturn('${item.serviceNameJob?if_exists}','status_${item_index}')"><i class="fa-caret-square-o-right"></i></a></td>
                                        <td  style="text-align: center;font-size: large;"><a href="#screenlet_1" style="color: #008000" onclick="runSynService('${item.serviceNameTranform?if_exists}')"><i class="fa-caret-square-o-right"></a></i></td>
                                    </tr>
                                    </#list>
                                </#if>


                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    function runSynServicReturn(name,id_index){
        if(name){
            $("#checkoutInfoLoader").show();
            $.ajax({
                url: '<@ofbizUrl>'+name+'</@ofbizUrl>',
                beforeSend: function () {
                    $("#checkoutInfoLoader").show();
                },
                success: function (data) {
                    if(data.statusJob){
                        $('#'+ id_index).empty();
                        $('#'+id_index).append(data.statusJob)
                    }
                },
                complete: function() {
                    $("#checkoutInfoLoader").hide();
                }
            });
        }
    }

        function runSynService(name){
            if(name){
                $("#checkoutInfoLoader").show();
                $.ajax({
                    url: '<@ofbizUrl>scheduleServiceSync</@ofbizUrl>',
                    type: 'POST',
                    data: {_RUN_SYNC_:'Y',SERVICE_NAME:name, POOL_NAME:'pool'},
                    beforeSend: function () {
                        $("#checkoutInfoLoader").show();
                    },
                    complete: function() {
                        $("#checkoutInfoLoader").hide();
                    }
                });
            }
        }


</script>
