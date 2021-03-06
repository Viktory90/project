					<script type="text/javascript">
					
						var menuForAll = "<div class='row-fluid'><div class='span10'></div><div class='span2' style='height:34px; text-align:right'><a data-original-title='${uiLabelMap.FilterOptions}' href='javascript:openConfigSetting()' data-rel='tooltip' title='' data-placement='bottom' class='button-action'><i class='icon-filter'></i></a><a data-original-title='${uiLabelMap.createImportPlan}' href='createNewImportPlanForYear' data-rel='tooltip' title='' data-placement='bottom' class='button-action'><i class='icon-plus-sign open-sans'></i></a><a data-original-title='${uiLabelMap.ListImportPlan}' href='getImportPlans' target='_blank' data-rel='tooltip' title='' data-placement='bottom' class='button-action'><i class='icon-tasks'></i></a>/div></div>";
//						$("#myTab").html(menuForAll);
						$('[data-rel=tooltip]').tooltip();
					</script>
					
					<style type="text/css">
						.button-action {
							font-size:18px; padding:0 0 0 8px;
						}
					</style>
			

<#assign count = 1/>
<#assign colum = 1/>
<#assign row = 1/>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript">
	function showQuantityConvert(quantityConvert, coutCol) {
		var data = "${uiLabelMap.quantityPacking}: " + quantityConvert;
		 $("#proName_" + coutCol).jqxTooltip({ content: data, position: 'top', autoHideDelay: 3000});
	}
	function showContTooltip(count, totalRowMonth){
		var data = "${uiLabelMap.GoToDivideContainer} ";
		 $("#cont_" + count+"_month_" + totalRowMonth).jqxTooltip({ content: data, position: 'top', autoHideDelay: 3000});
	}
	function showAgreeTooltip(count,totalRowMonth){
		var data = "${uiLabelMap.GoToAgreeOfWeek} ";
		 $("#agreeWeek_" + count + "_" + totalRowMonth).jqxTooltip({ content: data, position: 'top', autoHideDelay: 3000});
	}
	function showQuantityMonth(totalRowMonth, productId_index, valueMonthQuantity){
		 var data = "${uiLabelMap.Quantity}: " + valueMonthQuantity;
		 $("#quantityMonth_" + totalRowMonth + "_" + productId_index).jqxTooltip({ content: data, position: 'top', autoHideDelay: 3000});
	}
	function showQuantityWeek(col, count, totalRowMonth, quantityWeek){
		 var data = "${uiLabelMap.Quantity}: " + quantityWeek;
		 $("#tdWeek_" + col + "_" + count + "_" + totalRowMonth).jqxTooltip({ content: data, position: 'top', autoHideDelay: 10000});
	//	alert();
	}
	function showQuantityWeekUp(col, count, totalRowMonth, quantityWeek){
		 var data = "${uiLabelMap.Quantity}: " + quantityWeek;
		 $("#tdWeek_" + col + "_" + count + "_" + totalRowMonth).jqxTooltip({ content: data, position: 'top', autoHideDelay: 10000});
	} 
</script>

<#if (security.hasEntityPermission("IMPORT_PLAN", "_UPDATE", session) || security.hasEntityPermission("IMPORT_PLAN", "_CREATE", session))>
<div id = "saveSuccess"></div>
<div id="window01" style="display: none">
<div>${uiLabelMap.FilterOptions}</div>
<div>
	<div class='row-fluid'>
		<div class='span12 no-left-margin'>
			<div class='span4'>${uiLabelMap.ProductProducts}: </div>
			<div class='span8'>
				<div id="jqxComboBoxPro"></div>
			</div>
		</div>
	</div>
	<div class='row-fluid'>
		<div class='span12 no-left-margin'>
			<div class='span4'>${uiLabelMap.FormFieldTitle_caFromDate}: </div>
			<div class='span8'>
				<div id="jqxComboBox"></div>
			</div>
		</div>
	</div>
	<div class='row-fluid'>
	<div class='span12 no-left-margin'>
		<div class='span4'></div>
		<div class='span8'><input style='margin-right: 5px;' type='button' id='alterSave5' value='${uiLabelMap.CommonSave}' /><input id='alterCancel5' type='button' value='${uiLabelMap.CommonCancel}' /></div>
	</div>
	</div>
	<input type="button" value="filter" id="filter" style="display: none" />
</div>
</div>

<div id="mydiv" style="width: 100%;overflow:auto; height:500px;">
<table id="devideTbl" style="width:auto!important; min-width: 100%;" class="table table-striped table-bordered table-hover">
	<thead>
	<tr class="sf-product">
		<th style="text-align:left; width:30px;" rowspan = "2">${uiLabelMap.Week}</th>
		<th style="text-align:center; min-width:65px;" rowspan = "2">${uiLabelMap.DateTime}</th>
		<th style="text-align:left; width: 80px !important;" rowspan = "2" id = "countContainer">${uiLabelMap.CountCont}</th>
		<th style="text-align:left; width: 100px;" rowspan = "2">${uiLabelMap.RePalletCont}</th>
		<#assign coutCol = 0/>
		<#list parameters.productId as re1>
		<#assign coutCol = coutCol + 1 />
			<th class="pro_${re1_index}" style="text-align:center;" colspan = "1" id = "proName_${coutCol}" onmouseenter="showQuantityConvert(${re1.quantityConvert}, ${coutCol})"><div style="width:100px;">${re1.productName}</div></th>
		</#list>
	</tr>
	<tr class="sf-product">
		<#list parameters.productId as re>	
			<th class="pro_${re_index}" style="text-align:center;">${uiLabelMap.PalletQuantity}</th>
			<th class="" style="text-align:center; display: none;">${uiLabelMap.ProductQuantity}</th>
		</#list>
	</tr>
	</thead>
<tbody>
<#assign totalRowMonth = 0/>
<#list parameters.resultPro as result>
	<#assign totalRowMonth = totalRowMonth +1/>
	<tr class="plant-month row_m_${result_index}">
		<td style="text-align:center;"><a style="cursor: pointer; text-decoration: none;" id="rowTr_${totalRowMonth}" class="monthClick" show="0" row = "${totalRowMonth}"><i class="fa fa-chevron-down"></i></a></td>
		<td style="width:80px;">${uiLabelMap.Month} ${result.month.periodName}</td>
		<td style="text-align:right;">${result.container}</td>
		<td>
			
		</td>
		<#list parameters.productId as productId>
			<#assign valueMonthPallet = 0/>
			<#assign valueMonthQuantity = 0/>
			<#list result.product as re>
				<#if re.productId == productId.productId>
					<#assign valueMonthPallet = re.quantityPallet/>
					<#assign valueMonthQuantity = re.quantity/>
				</#if>
			</#list>
			<td class="pro_${productId_index}" id="quantityMonth_${totalRowMonth}_${productId_index}" onmouseenter="showQuantityMonth('${totalRowMonth}', '${productId_index}', '${valueMonthQuantity?string(',##0')}')" style="text-align:right;">${valueMonthPallet?string(",##0")}</td>
			<td class="" style="text-align:right; display: none;">${valueMonthQuantity?string(",##0")}</td>
		</#list>
	</tr>
	<#list result.week as week>
	<#assign row = count/>
	<tr class="child_${totalRowMonth} plant-week w_row_m_${result_index}" style="display: none; line-height: 30px !important; height: 30px !important;" show="0" row = "${totalRowMonth}">
		<td style="text-align:center;">${week.weekOfYear}</td>
		<td>
			
			<a id="agreeWeek_${count}_${totalRowMonth}" onmouseenter="showAgreeTooltip('${count}','${totalRowMonth}')" href="javascript:showAgreementPopup('${week.productPlanHeaderWeek}')">${uiLabelMap.Week} ${week.timeWeek.periodName} </a>
			<label style="margin-top: 5px !important;" id="week_${count}_month_${totalRowMonth}" productPlanHeader="${week.productPlanHeader}" customTime="${week.timeWeek.customTimePeriodId}">
			</label>
		
		</td>
		
		<#if week.product?size == 0>
			<td style="text-align:right;">				
				<a onmouseenter="showContTooltip('${count}','${totalRowMonth}')" href="javascript:showPopup('${parameters.internalPartyId}', '${week.timeWeek.customTimePeriodId}')"><label style="margin-top: 5px;" id="cont_${count}_month_${totalRowMonth}" internalPartyId = "${parameters.internalPartyId}">0</label></a>			
			</td>
			<td style="text-align:right;">
				<label style="margin-top: 5px;" id="re_${count}_month_${totalRowMonth}">0</label>
			</td>
		<#else>
			<#assign sumPallet = 0/>
			<#list result.product as re>
				<#list week.product as pro>
					<#if re.productId == pro.productId>
						<#assign palletPro = (pro.planQuantity/re.quantityConvert)/>
						<#assign sumPallet = sumPallet +palletPro/>
					</#if>
				</#list>
			</#list>
			<#assign sumCont = (sumPallet/33)?floor/>
			<#assign sumRe = 33-(sumPallet%33)/>
			<td style="text-align:right;">				
				<a onmouseenter="showContTooltip('${count}','${totalRowMonth}')" href="javascript:showPopup('${parameters.internalPartyId}', '${week.timeWeek.customTimePeriodId}')"><label style="margin-top: 5px;" id="cont_${count}_month_${totalRowMonth}" internalPartyId = "${parameters.internalPartyId}">${sumCont}</label></a>
			</td>
			<#if sumRe == 33>
				<td style="text-align:right;"><label style="margin-top: 5px;" id="re_${count}_month_${totalRowMonth}">0</label></td>
				<#else>
					<td style="text-align:right;"><label style="margin-top: 5px;" id="re_${count}_month_${totalRowMonth}">${sumRe}</label></td>
			</#if>
		</#if>
		
		<#assign col = 1/>
		<#list parameters.productId as productId>
			<#assign colum = col/>
			<#assign palletWeek = 0/>
			<#assign quantityWeek = 0/>
			<#assign quantityConvert=0/>
			<#assign quantityUomId = '' />
			<#list week.product as pro>
				<#if pro.productId == productId.productId>
					<#assign quantityWeek = pro.planQuantity/>
				</#if>
			</#list>
			<#list result.product as re>
				<#if re.productId == productId.productId>
					<#assign quantityConvert = re.quantityConvert/>
					<#assign palletWeek= (quantityWeek/re.quantityConvert)/>
					<#assign quantityUomId = re.quantityUomId />
				</#if>
			</#list>
			<#if week.product?size == 0>
					<td class="pro_${productId_index}" id="tdWeek_${col}_${count}_${totalRowMonth}" onmouseenter="showQuantityWeek('${col}', '${count}', '${totalRowMonth}', '${quantityWeek?string(',##0')}')" style="text-align:right;">
						<#if week.statusId == "PLAN_CREATED" || week.statusId = "">
							<input style="text-align:right;" id="pallet_${col}_${count}_month_${totalRowMonth}" rowMonth = "${totalRowMonth}" colunm = "${col}" class = "pallet" convert="${quantityConvert}" count = "${count}" productId = "${col}" type="text"/>
							<#else>
							<input style="text-align:right;" id="pallet_${col}_${count}_month_${totalRowMonth}" rowMonth = "${totalRowMonth}" colunm = "${col}" class = "pallet" convert="${quantityConvert}" count = "${count}" productId = "${col}" disabled="disabled" type="text"/>
						</#if>
					</td>
					<td class="" style="text-align:right; display: none;"><label style="margin-top: 5px;" class = "quantity" quantityUomId = "${quantityUomId}" productId = "${productId.productId}" id="${col}_${count}_month_${totalRowMonth}">0</label></td>
					<#else>
								<td class="pro_${productId_index}" id="tdWeek_${col}_${count}_${totalRowMonth}" onmouseenter="showQuantityWeek('${col}', '${count}', '${totalRowMonth}', '${quantityWeek?string(',##0')}')" style="text-align:right;">
									<#if week.statusId == "PLAN_CREATED" || week.statusId = "">
										<input style="text-align:right;" id="pallet_${col}_${count}_month_${totalRowMonth}" rowMonth = "${totalRowMonth}" colunm = "${col}" value="${palletWeek}" class = "pallet" convert="${quantityConvert}" count = "${count}" productId = "${col}" type="text"/>
									<#else>
										<input style="text-align:right;" id="pallet_${col}_${count}_month_${totalRowMonth}" rowMonth = "${totalRowMonth}" colunm = "${col}" value="${palletWeek}" class = "pallet" convert="${quantityConvert}" count = "${count}" productId = "${col}" disabled="disabled" type="text"/>
									</#if>
								</td>
								<td class="" style="text-align:right; display: none;"><label style="margin-top: 5px;" class = "quantity" quantityUomId = "${quantityUomId}" productId = "${productId.productId}" id="${col}_${count}_month_${totalRowMonth}">${quantityWeek?string(",##0")}</label></td>
			</#if>
			
			<#assign col = col +1 />
		</#list>
	</tr>
	<#assign count = count +1 />
	</#list>
	<tr class="child_${totalRowMonth} plant-month-total w_row_m_${result_index}" style="display: none" show="0" row = "${totalRowMonth}">
		<td colspan="2">${uiLabelMap.TotalNumber}</td>
		<td style="text-align:right;" colspan="1"><label id = "sumCont_month_${totalRowMonth}">0</label></td>
		<td></td>
		<#assign colPallet = 1/>
		<#list parameters.productId as re>
			<td class="pro_${re_index}" style="text-align:right;" colspan="1"><label id = "sumPallet_${colPallet}_month_${totalRowMonth}">0</label></td>
			<#assign colPallet = colPallet + 1/>
		</#list>
	</tr>
</#list>
</tbody>
</table>
</div>
<button id="submit" class="btn btn-primary btn-small open-sans icon-ok">${uiLabelMap.CommonSave}</button>
<button id="send" class="btn btn-primary btn-small open-sans fa-send-o">${uiLabelMap.SentNotify}</button>


<div id="showPopup">
	
</div>



<div id="contentAgreementPopup" style="width: 80%;overflow: hidden;" class="modal hide fade modal-dialog" tabindex="-1">
<div class="modal-header no-padding">
	<div class="table-header">
		<button type="button" class="close" data-dismiss="modal">&times;</button>
		Danh Sach Hop Dong
	</div>
</div>
<div class="modal-body">
	<div id="jqxNotificationNested">
	<div id="notificationContentNested">
	</div>
	</div>
	<div id="showPurchaseAgreementPopup1" style="overflow:auto;">
	<#assign prHeaderId = parameters.productPlanHeader2 !>
		<#if prHeaderId?exists>
			${screens.render("component://delys/widget/import/ImportScreens.xml#receiveAgreementPopup")}
		</#if>
	</div>
</div>

</div>


<script type="text/javascript">
var checkedItems = [];
var itemsAll = [];
var checkedMonthItems = [];
var itemsMonth = [];
$("#alterCancel5").jqxButton();
$("#alterSave5").jqxButton();
$("#alterSave5").click(function () {
	for(var ii = 0; ii < itemsAll.length; ii++){
		if(checkedItems.indexOf(itemsAll[ii]) == -1){
			$('.'+itemsAll[ii]).css('display', 'none');
		}else{
			$('.'+itemsAll[ii]).css('display', 'table-cell');
		}
	}
	
	for(var ii = 0; ii < itemsMonth.length; ii++){
		if(checkedMonthItems.indexOf(itemsMonth[ii]) == -1){
			$('.'+itemsMonth[ii]).css('display', 'none');
			$('.w_'+itemsMonth[ii]).css('display', 'none');
			
			
		}else{
			$('.'+itemsMonth[ii]).css('display', 'table-row');
			$('.'+itemsMonth[ii]).attr('show',1);
			$('.w_'+itemsMonth[ii]).css('display', 'none');
			$('.'+itemsMonth[ii]).children().children().children().remove();
			$('.'+itemsMonth[ii]).children().children().append('<i class="fa fa-chevron-down"></i>');
			$('.'+itemsMonth[ii]).removeClass('styleMonth');
		}
	}
	$('#window01').jqxWindow('close');
});
$("#alterCancel5").click(function () {
	$('#window01').jqxWindow('close');
});
$('#window01').jqxWindow({ height: 150, width: 450, isModal: true, modalOpacity: 0.7, autoOpen: false, theme: 'olbius'});

//combobox Product
<#assign flag = 1/>
<#assign parametersProId = parameters.productId !>
	var source_product = new Array(
	{status:'${StringUtil.wrapString(uiLabelMap.CheckAll)}', value:"all"},
	<#list parametersProId as pro>
	<#if flag == parametersProId.size()>
		{status:'${StringUtil.wrapString(pro.productName)}', value:"pro_${pro_index}"}
	<#else>
		{status:'${StringUtil.wrapString(pro.productName)}', value:"pro_${pro_index}"},
	</#if>
	<#assign flag = flag +1/>
	</#list>
	);
	
	$("#jqxComboBoxPro").jqxDropDownList({
			source: source_product,
			placeHolder: '${StringUtil.wrapString(uiLabelMap.SelectProduct)}',
			displayMember: 'status',
			theme: 'energyblue',
			width: '220px',
			height: '25px',
			checkboxes: true
			});
//	for(var k=0; k < checkedItems.length; k++){
//		$('.'+checkedItems[k]).css('display', 'table-cell');
//	}
	filter = !filter;
	
	$("#jqxComboBoxPro").on('checkChange', function (event) {
			var args = event.args;
			if (args) {
				var index = args.item.index;
				var item = args.item;
				var label = item.label;
				var value = item.value;
				var checked = args.item.checked;
				if(checked == true && index == 0){
					$("#jqxComboBoxPro").jqxDropDownList("checkAll");
				}
				if(checked == false && index == 0){
					$("#jqxComboBoxPro").jqxDropDownList("uncheckAll");
				}
					var items = $("#jqxComboBoxPro").jqxDropDownList('getCheckedItems');
					checkedItems = [];
					var ind1 = 0;
					$.each(items, function (index) {
						if(this.value != "all"){
							checkedItems[ind1] = this.value;
							ind1 ++;
						}
					});
  				
				
			}
	});

	$('#filter').on('click', function(){
//	console.log(checkedItems);
	for(var ii = 0; ii < itemsAll.length; ii++){
		if(checkedItems.indexOf(itemsAll[ii]) == -1){
			$('.'+itemsAll[ii]).css('display', 'none');
		}else{
			$('.'+itemsAll[ii]).css('display', 'table-cell');
		}
	}
	
	for(var ii = 0; ii < itemsMonth.length; ii++){
		if(checkedMonthItems.indexOf(itemsMonth[ii]) == -1){
			$('.'+itemsMonth[ii]).css('display', 'none');
//			$('.'+itemsMonth[ii]).attr('show',0);
			$('.w_'+itemsMonth[ii]).css('display', 'none');
			
			
		}else{
			$('.'+itemsMonth[ii]).css('display', 'table-row');
			$('.'+itemsMonth[ii]).attr('show',1);
			$('.w_'+itemsMonth[ii]).css('display', 'none');
			$('.'+itemsMonth[ii]).children().children().children().remove();
			$('.'+itemsMonth[ii]).children().children().append('<i class="fa fa-chevron-down"></i>');
			$('.'+itemsMonth[ii]).removeClass('styleMonth');
//			$('.plan-week').css('display', 'none');
		}
	}
	
	});
	
	
	// combobox for month
	var source = new Array(
		{status:'${StringUtil.wrapString(uiLabelMap.CheckAll)}', value:"all"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 1', value:"row_m_0"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 2', value:"row_m_1"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 3', value:"row_m_2"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 4', value:"row_m_3"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 5', value:"row_m_4"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 6', value:"row_m_5"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 7', value:"row_m_6"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 8', value:"row_m_7"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 9', value:"row_m_8"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 10', value:"row_m_9"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 11', value:"row_m_10"},
		{status:'${StringUtil.wrapString(uiLabelMap.Month)}: 12', value:"row_m_11"}
	);
	$("#jqxComboBox").jqxDropDownList({
			source: source,
			theme: 'energyblue',
			placeHolder: '${StringUtil.wrapString(uiLabelMap.SelectMonth)}',
			displayMember: 'status',
			width: '220px',
			height: '25px',
			checkboxes: true
		});
	$("#jqxComboBox").on('checkChange', function (event) {
			var args = event.args;
			if (args) {
				var index = args.item.index;
				var item = args.item;
				var label = item.label;
				var value = item.value;
				var checked = args.item.checked;
				if(checked == true && index == 0){
					$("#jqxComboBox").jqxDropDownList("checkAll");
				}
				if(checked == false && index == 0){
					$("#jqxComboBox").jqxDropDownList("uncheckAll");
				}
				var items = $("#jqxComboBox").jqxDropDownList('getCheckedItems');
				checkedMonthItems = [];
				var ind1 = 0;
				$.each(items, function (index) {
					if(this.value != "all"){
						checkedMonthItems[ind1] = this.value;
						ind1 ++;
					}
				});
			}
		});
</script>
<script type="text/javascript">
$(document).ready(function(){
//combo check all
		$("#jqxComboBoxPro").jqxDropDownList("checkAll");
		var items2 = $("#jqxComboBoxPro").jqxDropDownList('getCheckedItems');
		var ind = 0;
		$.each(items2, function (index) {
			if(index !=0){
				itemsAll[ind] = this.value;
				checkedItems[ind] = this.value;
				ind ++;
			}
		});
//check all month
		$("#jqxComboBox").jqxDropDownList("checkAll");
		var monthChecked = $("#jqxComboBox").jqxDropDownList('getCheckedItems');
		var indexM = 0;
		$.each(monthChecked, function (index) {
			if(index !=0){
				itemsMonth[indexM] = this.value;
				checkedMonthItems[indexM] = this.value;
				indexM ++;
			}
		});
	});
</script>
</#if>


<#if security.hasEntityPermission("IMPORT_PLAN", "_VIEW", session)>
<div id="mydiv" style="width:100%;overflow:auto;">
<table id="devideTbl" class="table table-striped table-bordered table-hover">
	<thead>
	<tr class="sf-product">
		<td style="text-align:center;"  rowspan = "2">${uiLabelMap.Week}</td>
		<td style="text-align:center;"  rowspan = "2">${uiLabelMap.DateTime}</td>
		<td style="text-align:center;"  rowspan = "2">${uiLabelMap.CountCont}</td>
		<td style="text-align:center;"  rowspan = "2">${uiLabelMap.RePalletCont}</td>
		<#list parameters.productId as re1>
			<td style="text-align:center;"  colspan = "2">${re1.productName}</td>
		</#list>
	</tr>
	<tr class="sf-product">
		<#list parameters.productId as re>	
			<td style="text-align:center;" >${uiLabelMap.PalletQuantity}</td>
			<td style="text-align:center;" >${uiLabelMap.ProductQuantity}</td>
		</#list>
	</tr>
	</thead>
<tbody>
<#assign totalRowMonth = 0/>
<#list parameters.resultPro as result>
	<#assign totalRowMonth = totalRowMonth +1/>
	<tr class="plant-month">
		<td style="text-align:center;"><a style="cursor: pointer; text-decoration: none;" id="rowTr_${totalRowMonth}" class="monthClick" show="0" row = "${totalRowMonth}"><i class="fa fa-chevron-down"></i></a></td>
		<td  style="width:80px;">${result.month.periodName}</td>
		<td style="text-align:right;">${result.container?string(",##0")}</td>
		<td>
			
		</td>
		<#list parameters.productId as productId>
			<#assign valueMonthPallet = 0/>
			<#assign valueMonthQuantity = 0/>
			<#list result.product as re>
				<#if re.productId == productId.productId>
					<#assign valueMonthPallet = re.quantityPallet/>
					<#assign valueMonthQuantity = re.quantity/>
				</#if>
			</#list>
			<td style="text-align:right;">${valueMonthPallet}</td>
			<td style="text-align:right;">${valueMonthQuantity}</td>
		</#list>
	</tr>
	<#list result.week as week>
	<#assign row = count/>
	<tr class="child_${totalRowMonth} plant-week" style="display: none" show="0" row = "${totalRowMonth}">
		<td>${week.weekOfYear}</td>
		<td>
			
			<a href="javascript:showAgreementPopup('${week.productPlanHeaderWeek}')"> ${week.timeWeek.periodName} </a>
			<label style="margin-top: 5px !important;" id="week_${count}_month_${totalRowMonth}" productPlanHeader="${week.productPlanHeader}" customTime="${week.timeWeek.customTimePeriodId}">
			</label>
		
		</td>
		
		<#if week.product?size == 0>
			<td style="text-align:right;">
				<label id="cont_${count}_month_${totalRowMonth}" internalPartyId = "${parameters.internalPartyId}">0</label>
				<a href="javascript:showPopup('${parameters.internalPartyId}', '${week.timeWeek.customTimePeriodId}')"> ${uiLabelMap.Detail} </a>
				
			</td>
			<td style="text-align:right;">
				<label id="re_${count}_month_${totalRowMonth}">0</label>
			</td>
		<#else>
			<#assign sumPallet = 0/>
			<#list result.product as re>
				<#list week.product as pro>
					<#if re.productId == pro.productId>
						<#assign palletPro = (pro.planQuantity/re.quantityConvert)/>
						<#assign sumPallet = sumPallet +palletPro/>
					</#if>
				</#list>
			</#list>
			<#assign sumCont = (sumPallet/33)?floor/>
			<#assign sumRe = 33-(sumPallet%33)/>
			<td style="text-align:right;">
				<label id="cont_${count}_month_${totalRowMonth}" internalPartyId = "${parameters.internalPartyId}">${sumCont}</label>
				<a href="javascript:showPopup('${parameters.internalPartyId}', '${week.timeWeek.customTimePeriodId}')" class="green"> (${uiLabelMap.Detail}) </a>
				
			</td>
			<#if sumRe == 33>
				<td style="text-align:right;"><label id="re_${count}_month_${totalRowMonth}">0</label></td>
				<#else>
					<td style="text-align:right;"><label id="re_${count}_month_${totalRowMonth}">${sumRe}</label></td>
			</#if>
		</#if>
		
		<#assign col = 1/>
		<#list parameters.productId as productId>
			<#assign colum = col/>
			<#assign palletWeek = 0/>
			<#assign quantityWeek = 0/>
			<#assign quantityConvert=0/>
			<#assign quantityUomId = '' />
			<#list week.product as pro>
				<#if pro.productId == productId.productId>
					<#assign quantityWeek = pro.planQuantity/>
				</#if>
			</#list>
			<#list result.product as re>
				<#if re.productId == productId.productId>
					<#assign quantityConvert = re.quantityConvert/>
					<#assign palletWeek= (quantityWeek/re.quantityConvert)/>
					<#assign quantityUomId = re.quantityUomId />
				</#if>
			</#list>
			<#if week.product?size == 0>
					<td style="text-align:right;">
						<input style="text-align:right;" disabled id="pallet_${col}_${count}_month_${totalRowMonth}" rowMonth = "${totalRowMonth}" colunm = "${col}" class = "pallet" convert="${quantityConvert}" count = "${count}" productId = "${col}" type="text"/>
					</td>
					<td style="text-align:right;"><label class = "quantity" quantityUomId = "${quantityUomId}" productId = "${productId.productId}" id="${col}_${count}_month_${totalRowMonth}">0</label></td>
					<#else>
								<td style="text-align:right;">
									<input style="text-align:right;" disabled id="pallet_${col}_${count}_month_${totalRowMonth}" rowMonth = "${totalRowMonth}" colunm = "${col}" value="${palletWeek}" class = "pallet" convert="${quantityConvert}" count = "${count}" productId = "${col}" type="text"/>
								</td>
								<td style="text-align:right;"><label class = "quantity" quantityUomId = "${quantityUomId}" productId = "${productId.productId}" id="${col}_${count}_month_${totalRowMonth}">${quantityWeek?string(",##0")}</label></td>
			</#if>
			
			<#assign col = col +1 />
		</#list>
	</tr>
	<#assign count = count +1 />
	</#list>
	<tr class="child_${totalRowMonth} plant-month-total" style="display: none" show="0" row = "${totalRowMonth}">
		<td colspan="2">${uiLabelMap.TotalNumber}</td>
		<td colspan="2"><label id = "sumCont_month_${totalRowMonth}">0</label></td>
		<#assign colPallet = 1/>
		<#list parameters.productId as re>
			<td colspan="2"><label id = "sumPallet_${colPallet}_month_${totalRowMonth}">0</label></td>
			<#assign colPallet = colPallet + 1/>
		</#list>
	</tr>
</#list>
</tbody>
</table>
</div>
</#if>

<#if security.hasEntityPermission("IMPORT_PLAN", "_APPROVE", session)>

<div id="mydiv"  style="width:100%;overflow:auto; height:500px;">
<table id="devideTbl" style="width:auto!important; min-width: 100%;" class="table table-striped table-bordered table-hover">
	<thead>
	<tr class="sf-product">
		<th style="text-align:center; width: 25px;"  rowspan = "2">${uiLabelMap.accBudgetApprovement}</th>
		<th style="text-align:center;"  rowspan = "2">${uiLabelMap.Week}</th>
		<th style="text-align:left;" rowspan = "2"><div style="width: 65px;">${uiLabelMap.statusId}</div></th>
		<th style="text-align:left;" rowspan = "2"><div style="width: 65px;">${uiLabelMap.DateTime}</div></th>
		<th style="text-align:left;" rowspan = "2"><div style=" width: 80px;">${uiLabelMap.CountCont}</div></th>
		<#list parameters.productId as re1>
			<th style="text-align:center;"  colspan = "1">${re1.productName}</th>
		</#list>
	</tr>
	<tr class="sf-product">
		<#list parameters.productId as re>	
			<th style="text-align:center;" ><div style="width:100px;">${uiLabelMap.ProductQuantity}</div></th>
		</#list>
	</tr>
	</thead>
<tbody>
<#assign totalRowMonth = 0/>
<#list parameters.resultPro as result>
	<#assign totalRowMonth = totalRowMonth +1/>
	<tr class="plant-month">
		<td style='display: none'><label id="lblId_${totalRowMonth}">${result.productPlanHeader}</label></td>
		<#if result.StatusId == "PLAN_CREATED">
			<td style="width: 25px;text-align: center;"><label><input id='check_${totalRowMonth}' onchange='checkChange(${totalRowMonth})' type='checkbox' ><span class='lbl'></span></label></td>
			<#else>
			<td style="width: 25px;text-align: center;"><label><input id='check_${totalRowMonth}' onchange='checkChange(${totalRowMonth})' type='checkbox' checked ><span class='lbl'></span></label></td>
		</#if>
		
		<td style="text-align:center; width: 25px;"><a style="cursor: pointer; text-decoration: none;" id="rowTr_${totalRowMonth}" class="monthClick" show="0" row = "${totalRowMonth}"><i class="fa fa-chevron-down"></i></a></td>
		<td>${result.thisStatus}</td>
		<td  style="width:60px;">${uiLabelMap.Month} ${result.month.periodName}</td>
		<td style="text-align:right;"><label id="lblContainer_${totalRowMonth}">${result.container?string(",##0")}</label></td>
		<#list parameters.productId as productId>
			<#assign valueMonthPallet = 0/>
			<#assign valueMonthQuantity = 0/>
			<#list result.product as re>
				<#if re.productId == productId.productId>
					<#assign valueMonthPallet = re.quantityPallet/>
					<#assign valueMonthQuantity = re.quantity/>
				</#if>
			</#list>
			<td style="text-align:right;">${valueMonthQuantity?string(",##0")}</td>
		</#list>
	</tr>
	<#list result.week as week>
	<#assign row = count/>
	<tr class="child_${totalRowMonth} plant-week" style="display: none" show="0" row = "${totalRowMonth}">
		<td></td>
		<td style="text-align:center; width: 25px;">${week.weekOfYear}</td>
		<td></td>
		<td style="width:60px;">
			<label id="week_${count}_month_${totalRowMonth}" productPlanHeader="${week.productPlanHeader}" customTime="${week.timeWeek.customTimePeriodId}">
				<a>${uiLabelMap.Week} ${week.timeWeek.periodName}</a>
			</label>
		
		</td>
		
		<#if week.product?size == 0>
			<td style="text-align:right;">
				<label id="cont_${count}_month_${totalRowMonth}" internalPartyId = "${parameters.internalPartyId}">0</label>
			</td>
		<#else>
			<#assign sumPallet = 0/>
			<#list result.product as re>
				<#list week.product as pro>
					<#if re.productId == pro.productId>
						<#assign palletPro = (pro.planQuantity/re.quantityConvert)/>
						<#assign sumPallet = sumPallet +palletPro/>
					</#if>
				</#list>
			</#list>
			<#assign sumCont = (sumPallet/33)?floor/>
			<#assign sumRe = 33-(sumPallet%33)/>
			<td style="text-align:right;">
				<label id="cont_${count}_month_${totalRowMonth}" internalPartyId = "${parameters.internalPartyId}">${sumCont}</label>
			</td>
		</#if>
		
		<#assign col = 1/>
		<#list parameters.productId as productId>
			<#assign colum = col/>
			<#assign palletWeek = 0/>
			<#assign quantityWeek = 0/>
			<#assign quantityConvert=0/>
			<#assign quantityUomId = '' />
			<#list week.product as pro>
				<#if pro.productId == productId.productId>
					<#assign quantityWeek = pro.planQuantity/>
				</#if>
			</#list>
			<#list result.product as re>
				<#if re.productId == productId.productId>
					<#assign quantityConvert = re.quantityConvert/>
					<#assign palletWeek= (quantityWeek/re.quantityConvert)/>
					<#assign quantityUomId = re.quantityUomId />
				</#if>
			</#list>
			<#if week.product?size == 0>
					<td style="text-align:right;"><label class = "quantity" quantityUomId = "${quantityUomId}" productId = "${productId.productId}" id="${col}_${count}_month_${totalRowMonth}">0</label></td>
					<#else>
								<td style="text-align:right;"><label class = "quantity" quantityUomId = "${quantityUomId}" productId = "${productId.productId}" id="${col}_${count}_month_${totalRowMonth}">${quantityWeek?string(",##0")}</label></td>
			</#if>
			
			<#assign col = col +1 />
		</#list>
	</tr>
	<#assign count = count +1 />
	</#list>
	<tr class="child_${totalRowMonth}  plant-month-total" style="display: none" show="0" row = "${totalRowMonth}">
		<td colspan="4">${uiLabelMap.TotalNumber}</td>
		<td colspan="1"><label id = "sumCont_month_${totalRowMonth}">0</label></td>
		<#assign colPallet = 1/>
		<#list parameters.productId as re>
			<td colspan="1"><label id = "sumPallet_${colPallet}_month_${totalRowMonth}">0</label></td>
			<#assign colPallet = colPallet + 1/>
		</#list>
	</tr>
</#list>
</tbody>
</table>
</div>
<button id="approved" class="btn btn-primary btn-small open-sans fa-send-o"> ${uiLabelMap.Approved}</button>
</#if>

<img id="myImg" src="/delys/images/css/import/ajax-loader.gif">
<style>
#myImg { 
	position : fixed;
	left: 654px;
	top: 266px;
	visibility: hidden;
}
.modal-dialog {
	 margin: 0;
	    position: absolute;
	    outline: none;
	    left: 10%;
	   }
	.modal.fade.in{
	 	top: 0%;
	}  
	}
</style>
<script type="text/javascript" src="/aceadmin/jqw/jqwidgets/jqxcore.js"></script>
<script type="text/javascript">
	
	$('.pallet').on('keypress', function(){
// alert(event.charCode);
// alert($('.pallet').val());
		return ((event.charCode >= 40 && event.charCode <= 57) || (event.charCode == 0));
		
	});
	$('.pallet').on('keyup', function(){
// alert(event.charCode);
		var count = $(this).attr("count");
		var colunm = $(this).attr("colunm");
		var productId = $(this).attr("productId");
		var convert = $(this).attr("convert");
		var rowMonth = $(this).attr("rowMonth");
		var val = convert*$(this).val();
		showQuantityWeekUp(colunm, count, rowMonth, val.toLocaleString('VI'));
	// alert(colunm);
		$('#'+colunm+'_'+count+'_month_'+rowMonth).text(val.toLocaleString('VI'));
		var sum = 0;
		var arr = [];
		var arrCol = [];
		var sumCol = 0;
		for(var i = 1; i <= ${colum}; i++){
			arr[i-1] = 0;
			var pallet = $('#pallet_'+i+'_'+count+'_month_'+rowMonth).val();
			if($.trim($('#pallet_'+i+'_'+count+'_month_'+rowMonth).val()) != ''){
				arr[i-1] = pallet;	
			}	
		}
		
		for(var i=0;i<arr.length;i++){
        if(parseInt(arr[i]))
            sum += parseInt(arr[i]);
		}
		
		for(var j = 1; j<= ${row}; j++){
			arrCol[j-1] = 0;
			var pallet = $('#pallet_'+colunm+'_'+j+'_month_'+rowMonth).val();
			if($.trim($('#pallet_'+colunm+'_'+j+'_month_'+rowMonth).val()) != ''){
				arrCol[j-1] = pallet;	
			}
		}
// alert(pallet);
		for(var k=0;k<arrCol.length;k++){
	        if(parseInt(arrCol[k]))
	        	sumCol += parseInt(arrCol[k]);
		}
		
		
    	var cont = parseInt(sum/33);
    	var remain = 33-parseInt(sum%33);
    	if(remain == 33) remain = 0;
		$('#cont_'+count+'_month_'+rowMonth).text(cont);
		$('#re_'+count+'_month_'+rowMonth).text(remain);
		$('#sumPallet_'+colunm+'_month_'+rowMonth).text(sumCol);
		var arrCont = [];
		var sumCont1 = 0;
		for(var jj = 1; jj<= ${row}; jj++){
			arrCont[jj-1] = 0;
			var pallet = 0;
			if($('#cont_'+jj+'_month_'+rowMonth).length){
				pallet = $('#cont_'+jj+'_month_'+rowMonth).text();
					arrCont[jj-1] = pallet;	
			}
			
		}
		
		for(var k=0;k<arrCont.length;k++){
	        if(parseInt(arrCont[k]))
	        	sumCont1 += parseInt(arrCont[k]);
		}
// alert(sumCont1);
		$('#sumCont_month_'+rowMonth).text(sumCont1);
	});
	
	
	$('.monthClick').on('click', function(){
		var row = $(this).attr('row');
// alert(row);
		var show = $(this).attr('show');
		if(show == 0){
			$(this).attr('show', 1);
			$(this).children().remove();
			$(this).append('<i class="fa fa-chevron-up"></i>');
			$('.child_' +row).css("display","table-row");
			var classNew = $(this).parent().parent();
			classNew.addClass('styleMonth');
		}else{
			$(this).attr('show', 0);
			$(this).children().remove();
			$(this).append('<i class="fa fa-chevron-down"></i>');
			$('.child_' +row).css("display","none");
			var classNew = $(this).parent().parent();
			classNew.removeClass('styleMonth');
		}
	});
	var myVar;
	function onLoadData() {
		clearInterval(myVar);
		$("body").css("opacity", 0.2);
		$("#myImg").css({"visibility": "visible", "opacity": 1});
	}
	function onLoadDone() {
		myVar = setInterval(function(){ 
		$("body").css("opacity", 1);
		$("#myImg").css({"visibility": "hidden"});
		 }, 1000);
	}
	$('#approved').on('click', function(){
		onLoadData();
		var oneTurn = false;
		for(var h = 1; h <= ${totalRowMonth}; h++){
			if (h == ${totalRowMonth}) {
				oneTurn = true;
				onLoadDone();
			}
			var id = $("#lblId_" + h).text();
			var check = $("#check_" + h).is(":checked");
			updateStatusPlanAjax({
				productPlanId: id,
				check: check,
    			},"updateStatusPlanAjax", oneTurn);
			
		}
	});
	function updateStatusPlanAjax(jsonObject, url, oneTurn) {
		var checkSave;
		jQuery.ajax({
	        url: url,
	        type: "POST",
	        data: jsonObject,
	        success : function(res) {
	        	checkSave = res["mess"];
	        }
	    }).done(function() {
	    	var message = "";
	    	if (checkSave != "") {
	    		if (oneTurn) {
	    			message = "<div id='contentMessages' class='alert alert-success' onclick='hiddenClick()'>" +
	    			"<p id='thisP' >" + '${uiLabelMap.DAUpdateSuccessful}' + "</p></div>";
	    	    	$("#myAlert").html(message);
	    	    	var productPlanId = "${productPlanId}";
	    	    	onLoadData();
	    	    	var header = "Ke hoach " + productPlanId + " da duoc duyet";
	    	    	createQuotaNotification(productPlanId, "importadmin", header, false);
	    	    	createQuotaNotification("", "qaadmin", "Co ke hoach moi duoc duyet", true);
	    	    	location.reload();
				}
			} else {
				if (oneTurn) {
	    			message = "<div id='contentMessages' class='alert alert-error' onclick='hiddenClick()'>" +
	    			"<p id='thisP' >" + '${uiLabelMap.DAUpdateError}' + "</p></div>";
	    	    	$("#myAlert").html(message);
				}
			}
		});
	}
$('#send').on('click', function(){
	var productPlanId = "${productPlanId}";
	onLoadData();
	var header = "Ke hoach " + productPlanId + " can duoc duyet";
	createQuotaNotification(productPlanId, "DLS001", header, false);
});
function hiddenClick() {
	$('#contentMessages').css('display','none');
}

function createQuotaNotification(productPlanId, partyId, messages, isSync) {
	if (isSync) {
		var action = "ListQuotas";
		var header = messages;
		var jsonObject = {partyId: partyId,
							header: header,
							action: action};
	} else {
		var targetLink = "productPlanHeaderId=" + productPlanId;
		var action = "resultPlanOfYear";
		var header = messages;
		var d = new Date();
		var newDate = d.getTime() - (0*86400000);
		var dateNotify = new Date(newDate);
		var getFullYear = dateNotify.getFullYear();
		var getDate = dateNotify.getDate();
		var getMonth = dateNotify.getMonth() + 1;
		dateNotify = getFullYear + "-" + getMonth + "-" + getDate;
		var jsonObject = {partyId: partyId,
							header: header,
							openTime: dateNotify,
							action: action,
							targetLink: targetLink,};
	}
	
	jQuery.ajax({
        url: "createQuotaNotification",
        type: "POST",
        data: jsonObject,
        success: function(res) {
        	
        }
    }).done(function() {
    	onLoadDone();
    	var message = "<div id='contentMessages' class='alert alert-success'>" +
		"<p id='thisP' onclick='hiddenClick()'>" + '${uiLabelMap.sendRequestSuccess}' + "</p></div>";
    	$("#myAlert").html(message);
    	
	});
}

$('#submit').on('click', function(){
		
		var jsonArrTotal = [];
		for(var h = 1; h <= ${totalRowMonth}; h++){
			var jsonArr = [];
// week_${count}_month_${totalRowMonth}
			for(var i = 1; i <= ${row}; i++){
				
				var productPlanHeader = '';
				var customTimePeriodId = '';
				var productPlanName = '';
				var internalPartyId = '';
				
				if($('#week_'+i+'_month_'+h).length){
					if($('#cont_'+i+'_month_'+h).length){
						internalPartyId = $('#cont_'+i+'_month_'+h).attr('internalPartyId');
					}
					productPlanHeader = $('#week_'+i+'_month_'+h).attr('productPlanHeader');
					customTimePeriodId = $('#week_'+i+'_month_'+h).attr('customTime');
					productPlanName = $('#week_'+i+'_month_'+h).text();
					
					var json = [];
					for(var j = 1; j <= ${colum}; j++){
						
						var quantity = '';
						var productId = '';
						var quantityUomId = '';
						if($('#'+j+'_'+i+'_month_'+h).length){
							
							quantity = $('#'+j+'_'+i+'_month_'+h).text().replace(/\./g,'');
							productId = $('#'+j+'_'+i+'_month_'+h).attr('productId');
							quantityUomId = $('#'+j+'_'+i+'_month_'+h).attr('quantityUomId');
							json.push({
								quantity: quantity,
								productId: productId,
								quantityUomId: quantityUomId
							});
						}
						
		// alert(productPlanName);
					}
					
					jsonArr.push({
						productPlanHeader: productPlanHeader,
						customTimePeriodId: customTimePeriodId,
						productPlanName: productPlanName,
						internalPartyId: internalPartyId,
						product: json
					});
					
				}
			}
			jsonArrTotal.push({
				total: jsonArr
			});
			
		}
		
		$.ajax({
			url: 'createImportPlanWeek',
        	type: "POST",
        	data: {json: JSON.stringify(jsonArrTotal)},
        	success: function(data) {
        	// var json = res[data];
//        		alert('OK');
        	},
        	error: function(data){
//        		alert('Fail');
        	}
			}).done(function() {
		    	onLoadDone();
		    	var message = "<div id='contentMessages' class='alert alert-success'>" +
				"<p id='thisP' onclick='hiddenClick()'>" + '${uiLabelMap.SaveSuccess}' + "</p></div>";
		    	$("#saveSuccess").html(message);
			});;
		
		// end ajax
	});
function checkChange(thisCount) {
	var check = $("#check_" + thisCount).is(":checked");
	var thisCont = $("#lblContainer_" + thisCount).text();
	if (check && thisCont != 0) {
//		$("#lblContainer_" + thisCount).notify( "Container chua chan!", "warn");
	}
}
function showPopup(internalPartyId, customTimePeriodId){
// alert(internalPartyId);
	onLoadData();
	$.ajax({
		url: 'devideContainer',
    	type: "POST",
    	data: {internalPartyId: internalPartyId, customTimePeriodId: customTimePeriodId},
    	async: false,
    	success: function(data) {
    		$("#showPopup").html(data);
			$('#pos-show-hold-cart').modal('show');
    	},
    	error: function(data){
// console.log("234", data);
			// $('#modal-table').modal('hide');
    	}
		}).done(function() {
			onLoadDone();
		});
}

function showAgreementPopup(productPlanHeader){
	onLoadData();
	$.ajax({
		url: 'showPurchaseAgreementPopup?productPlanHeader2='+productPlanHeader,
    	type: "POST",
    	data: {},
    	async: false,
    	success: function(data) {
    		$("#showPurchaseAgreementPopup1").html(data);
			$('#contentAgreementPopup').modal('show');
    	},
    	error: function(data){
    	}
		}).done(function() {
			onLoadDone();
		});
}


$(document).ready(function(){
	for(var m = 1; m <= ${totalRowMonth}; m++){	
		for(var i = 1; i <= ${colum}; i++){
			var sumCol2 = 0;
			var arrCol2 = [];
			for(var j = 1; j<= ${row}; j++){
				arrCol2[j-1] = 0;
				var pallet2 = 0;
				if($('#pallet_'+i+'_'+j+'_month_'+m).length){
					pallet2 = $('#pallet_'+i+'_'+j+'_month_'+m).val();
				}
					arrCol2[j-1] = pallet2;	
			}
	// alert(pallet);
			for(var k=0;k<arrCol2.length;k++){
		        if(parseInt(arrCol2[k]))
		        	sumCol2 += parseInt(arrCol2[k]);
			}
			

			$('#sumPallet_'+i+'_month_'+m).text(sumCol2);
		}
	}
//		$('.child_1').attr('show', 1);
////		$('#rowTr_1').text('-An');
//		$('#rowTr_1').children().remove();
//		$('#rowTr_1').append('<i class="fa fa-chevron-up"></i>');
//		$('.child_1').css('display','table-row');
//		$('#rowTr_1').parent().parent().addClass('styleMonth');
	
	$('.modal .modal-body').css('max-height', $(window).height() * 0.75);
	});

	function openConfigSetting() {
		$('#window01').css("display", "block");
		$('#window01').jqxWindow('open');
	}
</script>