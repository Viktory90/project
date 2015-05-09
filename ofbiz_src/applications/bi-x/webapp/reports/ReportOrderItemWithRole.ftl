<@jqGridMinimumLib/>

<div class="row-fluid">
    <div class="">
        <form method="post" class="basic-custom-form form-horizontal" name="staticProductOrder" id="staticProductOrder">
            <div class="control-group  no-left-margin">
                <label class="control-label" for="type_report">Kiểu báo cáo</label>
                <div class="controls">
                    <select name="type_report" id="type_report">
                        <option value="SALES_IN"> SALES IN</option>
                        <option value="SALES_OUT">SALES OUT</option>
                    </select>
                </div>
            </div>
            <#--<div class="control-group">-->
                <#--<label class="control-label" for="form-chanel_report-1">Kênh bán hàng</label>-->
                <#--<div class="controls">-->
                    <#--<select name="chanel_report" id="chanel_report">-->
                        <#--<option value="SALES_ALL"> All Chanel</option>-->
                        <#--<option value="SALES_GT"> SALES GT</option>-->
                        <#--<option value="SALES_MT">SALES MT</option>-->
                    <#--</select>-->
                <#--</div>-->
            <#--</div>-->

            <#--<div class="control-group">-->
            <#--<label class="control-label" for="type_time">Xem báo cáo theo</label>-->
            <#--<div class="controls">-->
                <#--<select name="type_time" id="type_time">-->
                    <#--<option value="YEAR"> Năm</option>-->
                    <#--<option value="MONTH"> Tháng</option>-->
                    <#--<option value="QUARTER">Quý</option>-->
                    <#--<option value="DATE">Ngày</option>-->
                <#--</select>-->
            <#--</div>-->
        <#--</div>-->
            <#--<div class="control-group" id="child">-->

            <#--</div>-->
            <div class="control-group no-left-margin ">
                <label class="">
                    &nbsp;  </label>
                <div class="controls">
                    <button id="staticButton" type="button" class="btn btn-small btn-primary" name="submitButton" ><i class="icon-ok"></i>${uiLabelMap.DAViewSalesStatement}</button>

                </div>
            </div>

        </form>

    </div>
</div>

<#assign currentYear = currentDateTime.get(Static["java.util.Calendar"].YEAR)>
<#assign currentMonth = currentDateTime.get(Static["java.util.Calendar"].MONTH) + 1>
<#assign minYear = currentYear-15>
<#assign maxYear = currentYear+15>

<script type="text/javascript">
    function getOrderItemStaticWithRole(){
        var jsc="";
        $.ajax({
            url: '<@ofbizUrl>OrderItemStaticWithRole</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            async:false,
            success:function(data){
                jsc=data;
            }
        });
        return jsc;
    }
    var data= getOrderItemStaticWithRole();
    console.log("asda",data);
</script>

<#assign dataField="[{name:'name',type:'string'},
                     {name:'quantity',type:'string'},
                     {name:'grandTotal', type:'string'}]"

/>