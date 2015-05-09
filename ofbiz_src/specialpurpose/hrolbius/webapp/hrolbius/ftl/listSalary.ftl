<#--<!-- <#if parameters.listEmplSalaryInPeriod?exists && parameters.listEmplSalaryInPeriod?has_content && parameters.listEmplSalaryInPeriod.get(0)?has_content>	
	<#if !currencyUomId?exists>
		<#assign currencyUomId = defaultCurrencyUomId>
	</#if>
	<#assign listEmplSalary = parameters.listEmplSalaryInPeriod>
	<#list listEmplSalary as tempList>
		<h3>${uiLabelMap.CommonFromDate} ${tempList.fromDate?date} ${uiLabelMap.CommonThruDate} ${tempList.thruDate?date}</h3>
		<#assign formulaList = tempList.formulaList>
		<#assign salaryAmountList = tempList.salaryAmountList>
		<div style="overflow-x:scroll">
			<table class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th>${uiLabelMap.employee}</th>
						<#list formulaList?if_exists as header>
							<#assign formula = delegator.findOne("PayrollFormula", Static["org.ofbiz.base.util.UtilMisc"].toMap("code", header), false)>
							<th>
							<#if formula?has_content>
							${formula.name?if_exists}
							<#else>
								${header}
							</#if>
							</th>
						</#list>
					</tr>
				</thead>
				<tbody>
					<#list salaryAmountList as tmp>
						<tr>
							<#assign tmpPartyId = salaryAmountList.get(tmp_index).getListSalaryAmount().get(0).partyId/>
							<td>
							<#assign employeeName= Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator,tmpPartyId,false)>
							${employeeName}</td>
							<form target="_blank" id="pdfPayrollForm_${tmpPartyId}" name="pdfPayrollForm_${tmpPartyId}" action="payroll.pdf" method="post">
								<input type="hidden" name="pdfPartyId" value="${tmpPartyId?if_exists}">
								<input type="hidden" name="currencyUomId" value="${currencyUomId}">
								<input type="hidden" name="fromDate" value="${parameters.fromDate?if_exists}">
								<input type="hidden" name="thruDate" value="${parameters.thruDate?if_exists}">
								<#list formulaList?if_exists as header>
									<input type="hidden" name="formulaList" value="${header}">
								</#list>
							</form>
							<#list formulaList as header>
								<td><b class="green"><@ofbizCurrency amount= salaryAmountList.get(tmp_index).getListSalaryAmount().get(header_index).amount?number isoCode=currencyUomId /></b></td>
							</#list>
						</tr>
					</#list>
				</tbody>
			</table>
		</div>
	</#list>
<#else>
	
</#if> -->
<div class="widget-box transparent no-bottom-border">
	<div class="widget-header">
		<h4>${uiLabelMap.PayrollTableCalcResults}</h4>
		<div class="widget-toolbar none-content">
			<div id="dropdownlist" style="margin-top: 5px;"></div>
		</div>
	</div>
	<div class="widget-body">
		<div id="payrollTableData">
			${screens.render("component://hrolbius/widget/PayrollScreens.xml#PayrollTableRecord")}
		</div>
			
	</div>	
</div>


<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxdropdownlist.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript">
$(document).ready(function () {  
	<#assign listTimestamp = payrollTimestampResult.get("listTimestamp")>
	<#if listTimestamp?has_content>
		var theme = 'olbius';
		var dataTimestamp = new Array();
		<#list listTimestamp as timestamp>
			dataTimestamp.push({"date": '${uiLabelMap.CommonFromDate} ${timestamp.get("fromDate")?string["dd/MM/yyyy"]} ${uiLabelMap.CommonThruDate} ${timestamp.get("thruDate")?string["dd/MM/yyyy"]}', 'valueParam': '${timestamp.get("fromDate").getTime()}'});
		</#list>
		var source = {
           localdata: dataTimestamp,
           datatype: "array"
        };
		var dataAdapter = new $.jqx.dataAdapter(source);
		$('#dropdownlist').jqxDropDownList({ selectedIndex: 0,  source: dataAdapter, displayMember: "date", valueMember: "valueParam", height: 25, width: 330, autoDropDownHeight:true, theme: theme});
		
		$('#dropdownlist').on('select', function (event){
		    var args = event.args;
		    if (args) {
			    // index represents the item's index.                
			    var index = args.index;
			    var item = args.item;
			    // get item's label and value.
			    var label = item.label;
			    var value = item.value;
			    jQuery.ajax({
			    	url: "<@ofbizUrl>getPayrollTableRecord</@ofbizUrl>",
			    	type: "POST",
			    	data:{fromDate: value, payrollTableId: "${parameters.payrollTableId}"},
			    	success:function (data){
			    		jQuery("#payrollTableData").html(data);
			    	}
			    });
			}                        
		});
	</#if>
});
function formatcurrency(num, uom){
    decimalseparator = ",";
        thousandsseparator = ".";
        currencysymbol = "đ";
        if(typeof(uom) == "undefined" || uom == null){
         uom = "${currencyUomId?if_exists}";
        }
    if(uom == "USD"){
     currencysymbol = "$";
     decimalseparator = ".";
         thousandsseparator = ",";
    }else if(uom == "EUR"){
     currencysymbol = "€";
     decimalseparator = ".";
         thousandsseparator = ",";
    }
       var str = num.toString().replace(currencysymbol, ""), parts = false, output = [], i = 1, formatted = null;
       if(str.indexOf(".") > 0) {
           parts = str.split(".");
           str = parts[0];
       }
       str = str.split("").reverse();
       for(var j = 0, len = str.length; j < len; j++) {
           if(str[j] != ",") {
               output.push(str[j]);
               if(i%3 == 0 && j < (len - 1)) {
                   output.push(thousandsseparator);
               }
               i++;
           }
       }
       formatted = output.reverse().join("");
       console(formatted + ((parts) ? decimalseparator + parts[1].substr(0, 2) : "") + "&nbsp;" + currencysymbol);
       return(formatted + ((parts) ? decimalseparator + parts[1].substr(0, 2) : "") + "&nbsp;" + currencysymbol);
   }	
</script>