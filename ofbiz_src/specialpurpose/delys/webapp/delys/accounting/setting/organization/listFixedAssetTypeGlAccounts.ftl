<script type="text/javascript">
<#assign itlength = listFixedAssetType.size()/>
<#if listFixedAssetType?size gt 0>
    <#assign lfat="var lfat = ['" + StringUtil.wrapString(listFixedAssetType.get(0).fixedAssetTypeId?if_exists) + "'"/>
	<#assign lfatValue="var lfatValue = [\"" + StringUtil.wrapString(listFixedAssetType.get(0).fixedAssetTypeId?if_exists) + " - " + StringUtil.wrapString(listFixedAssetType.get(0).description?if_exists) +"\""/>
	<#if listFixedAssetType?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lfat=lfat + ",'" + StringUtil.wrapString(listFixedAssetType.get(i).fixedAssetTypeId?if_exists) + "'"/>
			<#assign lfatValue=lfatValue + ",\"" + StringUtil.wrapString(listFixedAssetType.get(i).fixedAssetTypeId?if_exists) + " - " + StringUtil.wrapString(listFixedAssetType.get(i).description?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lfat=lfat + "];"/>
	<#assign lfatValue=lfatValue + "];"/>
<#else>
	<#assign lfat="var lfat = [];"/>
	<#assign lfatValue="var lfatValue = [];"/>
</#if>
${lfat}
${lfatValue}	

var dataLFLAT = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["fixedAssetTypeId"] = lfat[i];
    row["description"] = lfatValue[i];
    dataLFLAT[i] = row;
}
var assetTypeRenderer = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < lfat.length; i++){
    	if(lfat[i] == data.fixedAssetTypeId){
    		return "<span>" + lfatValue[i] + "</span>";
    	}
    }
    return "";
}


<#assign itlength = listFixedAsset.size()/>
<#if listFixedAsset?size gt 0>
    <#assign lfa="var lfa = ['" + StringUtil.wrapString(listFixedAsset.get(0).fixedAssetId?if_exists) + "'"/>
	<#assign lfaValue="var lfaValue = [\"" + StringUtil.wrapString(listFixedAsset.get(0).fixedAssetId?if_exists) + " - " + StringUtil.wrapString(listFixedAsset.get(0).fixedAssetName?if_exists) +"\""/>
	<#if listFixedAsset?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lfa=lfa + ",'" + StringUtil.wrapString(listFixedAssetType.get(i).fixedAssetId?if_exists) + "'"/>
			<#assign lfaValue=lfaValue + ",\"" + StringUtil.wrapString(listFixedAsset.get(i).fixedAssetId?if_exists) + " - " + StringUtil.wrapString(listFixedAsset.get(i).fixedAssetName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lfa=lfa + "];"/>
	<#assign lfaValue=lfaValue + "];"/>
<#else>
	<#assign lfa="var lfa = [];"/>
	<#assign lfaValue="var lfaValue = [];"/>
</#if>
${lfa}
${lfaValue}	
var dataLFA = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["fixedAssetId"] = lfa[i];
    row["description"] = lfaValue[i];
    dataLFA[i] = row;
}
var fixedAssetRenderer = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < lfa.length; i++){
    	if(lfa[i] == data.fixedAssetId){
    		return "<span>" + lfaValue[i] + "</span>";
    	}
    }
    return "";
}


<#assign itlength = listLossGlAccount.size()/>
<#if listLossGlAccount?size gt 0>
    <#assign llgla="var llgla = ['" + StringUtil.wrapString(listLossGlAccount.get(0).glAccountId?if_exists) + "'"/>
	<#assign llglaValue="var llglaValue = [\"" + StringUtil.wrapString(listLossGlAccount.get(0).glAccountId?if_exists) + " - " + StringUtil.wrapString(listLossGlAccount.get(0).accountName?if_exists) +"\""/>
	<#if listLossGlAccount?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign llgla=llgla + ",'" + StringUtil.wrapString(listLossGlAccount.get(i).glAccountId?if_exists) + "'"/>
			<#assign llglaValue=llglaValue + ",\"" + StringUtil.wrapString(listLossGlAccount.get(i).glAccountId?if_exists) + " - " + StringUtil.wrapString(listLossGlAccount.get(i).accountName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign llgla=llgla + "];"/>
	<#assign llglaValue=llglaValue + "];"/>
<#else>
	<#assign llgla="var llgla = [];"/>
	<#assign llglaValue="var llglaValue = [];"/>
</#if>
${llgla}
${llglaValue}	

var dataLLGLA = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["glAccountId"] = llgla[i];
    row["description"] = llglaValue[i];
    dataLLGLA[i] = row;
}
var listLossGlAccountRender = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < llgla.length; i++){
    	if(llgla[i] == data.lossGlAccountId){
    		return "<span>" + llglaValue[i] + "</span>";
    	}
    }
    return "";
}

<#assign itlength = listProfitGlAccount.size()/>
<#if listProfitGlAccount?size gt 0>
    <#assign lpgla="var lpgla = ['" + StringUtil.wrapString(listProfitGlAccount.get(0).glAccountId?if_exists) + "'"/>
	<#assign lpglaValue="var lpglaValue = [\"" + StringUtil.wrapString(listProfitGlAccount.get(0).glAccountId?if_exists) + " - " + StringUtil.wrapString(listProfitGlAccount.get(0).accountName?if_exists) +"\""/>
	<#if listProfitGlAccount?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lpgla=lpgla + ",'" + StringUtil.wrapString(listProfitGlAccount.get(i).glAccountId?if_exists) + "'"/>
			<#assign lpglaValue=lpglaValue + ",\"" + StringUtil.wrapString(listProfitGlAccount.get(i).glAccountId?if_exists) + " - " + StringUtil.wrapString(listProfitGlAccount.get(i).accountName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lpgla=lpgla + "];"/>
	<#assign lpglaValue=lpglaValue + "];"/>
<#else>
	<#assign lpgla="var lpgla = [];"/>
	<#assign lpglaValue="var lpglaValue = [];"/>
</#if>
${lpgla}
${lpglaValue}	

var dataLPGLA = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["glAccountId"] = llgla[i];
    row["description"] = llglaValue[i];
    dataLPGLA[i] = row;
}
var listProfitGlAccountRender = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < lpgla.length; i++){
    	if(lpgla[i] == data.profitGlAccountId){
    		return "<span>" + lpglaValue[i] + "</span>";
    	}
    }
    return "";
}
<#assign itlength = listAssetGlAccount.size()/>
<#if listAssetGlAccount?size gt 0>
    <#assign lagla="var lagla = ['" + StringUtil.wrapString(listAssetGlAccount.get(0).glAccountId?if_exists) + "'"/>
	<#assign laglaValue="var laglaValue = [\"" + StringUtil.wrapString(listAssetGlAccount.get(0).glAccountId?if_exists) + " - " + StringUtil.wrapString(listAssetGlAccount.get(0).accountName?if_exists) +"\""/>
	<#if listAssetGlAccount?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign lagla=lagla + ",'" + StringUtil.wrapString(listAssetGlAccount.get(i).glAccountId?if_exists) + "'"/>
			<#assign laglaValue=laglaValue + ",\"" + StringUtil.wrapString(listAssetGlAccount.get(i).glAccountId?if_exists) + " - " + StringUtil.wrapString(listAssetGlAccount.get(i).accountName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign lagla=lagla + "];"/>
	<#assign laglaValue=laglaValue + "];"/>
<#else>
	<#assign lagla="var lagla = [];"/>
	<#assign laglaValue="var laglaValue = [];"/>
</#if>
${lagla}
${laglaValue}	
var dataLAGLA = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["glAccountId"] = lagla[i];
    row["description"] = laglaValue[i];
    dataLAGLA[i] = row;
}
var listAssetGlAccountRender = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < lagla.length; i++){
    	if(lagla[i] == data.assetGlAccountId){
    		return "<span>" + laglaValue[i] + "</span>";
    	}
    }
    return "";
}

<#assign itlength = listDepGlAccount.size()/>
<#if listDepGlAccount?size gt 0>
    <#assign ldgla="var ldgla = ['" + StringUtil.wrapString(listDepGlAccount.get(0).glAccountId?if_exists) + "'"/>
	<#assign ldglaValue="var ldglaValue = [\"" + StringUtil.wrapString(listDepGlAccount.get(0).glAccountId?if_exists) + " - " + StringUtil.wrapString(listDepGlAccount.get(0).accountName?if_exists) +"\""/>
	<#if listDepGlAccount?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign ldgla=ldgla + ",'" + StringUtil.wrapString(listDepGlAccount.get(i).glAccountId?if_exists) + "'"/>
			<#assign ldglaValue=ldglaValue + ",\"" + StringUtil.wrapString(listDepGlAccount.get(i).glAccountId?if_exists) + " - " + StringUtil.wrapString(listDepGlAccount.get(i).accountName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign ldgla=ldgla + "];"/>
	<#assign ldglaValue=ldglaValue + "];"/>
<#else>
	<#assign ldgla="var ldgla = [];"/>
	<#assign ldglaValue="var ldglaValue = [];"/>
</#if>
${ldgla}
${ldglaValue}	
var dataLDGLA = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["glAccountId"] = ldgla[i];
    row["description"] = ldglaValue[i];
    dataLDGLA[i] = row;
}
var listDeptGlAccountRender = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < ldgla.length; i++){
    	if(ldgla[i] == data.depGlAccountId){
    		return "<span>" + ldglaValue[i] + "</span>";
    	}
    }
    return "";
}


<#assign itlength = listAccDepGlAccount.size()/>
<#if listAccDepGlAccount?size gt 0>
    <#assign ladgla="var ladgla = ['" + StringUtil.wrapString(listAccDepGlAccount.get(0).glAccountId?if_exists) + "'"/>
	<#assign ladglaValue="var ladglaValue = [\"" + StringUtil.wrapString(listAccDepGlAccount.get(0).glAccountId?if_exists) + " - " + StringUtil.wrapString(listAccDepGlAccount.get(0).accountName?if_exists) +"\""/>
	<#if listAccDepGlAccount?size gt 1>
		<#list 1..(itlength - 1) as i>
			<#assign ladgla=ladgla + ",'" + StringUtil.wrapString(listAccDepGlAccount.get(i).glAccountId?if_exists) + "'"/>
			<#assign ladglaValue=ladglaValue + ",\"" + StringUtil.wrapString(listAccDepGlAccount.get(i).glAccountId?if_exists) + " - " + StringUtil.wrapString(listAccDepGlAccount.get(i).accountName?if_exists) + "\""/>
		</#list>
	</#if>
	<#assign ladgla=ladgla + "];"/>
	<#assign ladglaValue=ladglaValue + "];"/>
<#else>
	<#assign ladgla="var ladgla = [];"/>
	<#assign ladglaValue="var ladglaValue = [];"/>
</#if>
${ladgla}
${ladglaValue}	
var dataLADGLA = new Array();
for (var i = 0; i < ${itlength}; i++) {
    var row = {};
    row["glAccountId"] = ladgla[i];
    row["description"] = ladglaValue[i];
    dataLADGLA[i] = row;
}
var listAccDeptGlAccountRender = function (row, column, value) {
	var data = $('#jqxgrid').jqxGrid('getrowdata', row);
    for(i=0;i < ladgla.length; i++){
    	if(ladgla[i] == data.accDepGlAccountId){
    		return "<span>" + ladglaValue[i] + "</span>";
    	}
    }
    return "";
}

</script>

<#assign dataField="[{ name: 'fixedAssetTypeId', type: 'string'},
					 { name: 'fixedAssetId', type: 'string'},
					 { name: 'assetGlAccountId', type: 'string'},
					 { name: 'accDepGlAccountId', type: 'string'},
					 { name: 'depGlAccountId', type: 'string'},
					 { name: 'profitGlAccountId', type: 'string'},
					 { name: 'lossGlAccountId', type: 'string'},
					]"/>

<#assign columnlist="{ text: '${uiLabelMap.fixedAssetTypeId}', datafield: 'fixedAssetTypeId',cellsrenderer:assetTypeRenderer},
					 { text: '${uiLabelMap.fixedAssetId}', datafield: 'fixedAssetId',cellsrenderer:fixedAssetRenderer},
					 { text: '${uiLabelMap.assetGlAccountId}', datafield: 'assetGlAccountId', cellsrenderer:listAssetGlAccountRender},
					 { text: '${uiLabelMap.accDepGlAccountId}', datafield: 'accDepGlAccountId', cellsrenderer:listAccDeptGlAccountRender},
					 { text: '${uiLabelMap.depGlAccountId}', datafield: 'depGlAccountId', cellsrenderer:listDeptGlAccountRender},
					 { text: '${uiLabelMap.profitGlAccountId}', datafield: 'profitGlAccountId', cellsrenderer:listProfitGlAccountRender},
					 { text: '${uiLabelMap.lossGlAccountId}', datafield: 'lossGlAccountId', cellsrenderer:listLossGlAccountRender}
					"/>
	
<@jqGrid  filtersimplemode="false" addType="popup" dataField=dataField columnlist=columnlist clearfilteringbutton="true" showtoolbar="true"
		 addrow="true" deleterow="true" alternativeAddPopup="alterpopupWindow"
		 url="jqxGeneralServicer?sname=JQListFixedAssetTypeyGLAccounts&organizationPartyId=${parameters.organizationPartyId}"
		 removeUrl="jqxGeneralServicer?sname=deleteFixedAssetTypeGlAccount&jqaction=D&organizationPartyId=${parameters.organizationPartyId}"
		 
		 createUrl="jqxGeneralServicer?sname=createFixedAssetTypeGlAccount&jqaction=C&organizationPartyId=${parameters.organizationPartyId}"
		 
		 deleteColumn="fixedAssetTypeId;fixedAssetId;organizationPartyId[${parameters.organizationPartyId}]"
		 addColumns="fixedAssetTypeId;fixedAssetId;assetGlAccountId;accDepGlAccountId;depGlAccountId;profitGlAccountId;lossGlAccountId;organizationPartyId[${parameters.organizationPartyId}]" 
		 />
<div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.assetGlAccountId}:</td>
	 			<td align="left"><div id="assetGlAccountId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.accDepGlAccountId}:</td>
	 			<td align="left"><div id="accDepGlAccountId" ></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.depGlAccountId}:</td>
	 			<td align="left"><div id="depGlAccountId" ></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.profitGlAccountId}:</td>
	 			<td align="left"><div id="profitGlAccountId" ></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.lossGlAccountId}:</td>
	 			<td align="left"><div id="lossGlAccountId" ></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.fixedAssetTypeId}:</td>
	 			<td align="left"><div id="fixedAssetTypeId" ></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.fixedAssetId}:</td>
	 			<td align="left"><div id="fixedAssetId" ></div></td>
    	 	</tr>
    	 	
            <tr>
                <td align="right"></td>
                <td style="padding-top: 10px;" align="right"><input style="margin-right: 5px;" type="button" id="alterSave" value="${uiLabelMap.CommonSave}" /><input id="alterCancel" type="button" value="${uiLabelMap.CommonCancel}" /></td>
            </tr>
        </table>
    </div>
</div>
<script type="text/javascript">
	$.jqx.theme = 'olbius';  
	theme = $.jqx.theme;
	
	var sourceLagla =
    {
        localdata: dataLAGLA,
        datatype: "array"
    };
	var sourceLadgla =
    {
        localdata: dataLADGLA,
        datatype: "array"
    };
	var sourceLdgla =
    {
        localdata: dataLDGLA,
        datatype: "array"
    };
	var sourceLpgla =
    {
        localdata: dataLPGLA,
        datatype: "array"
    };
	var sourceLlgla =
    {
        localdata: dataLLGLA,
        datatype: "array"
    };
	var sourceLflat =
    {
        localdata: dataLFLAT,
        datatype: "array"
    };
	var sourceLfa =
    {
        localdata: dataLFA,
        datatype: "array"
    };
	
    var dataAdapterLagla = new $.jqx.dataAdapter(sourceLagla);
    var dataAdapterLadgla = new $.jqx.dataAdapter(sourceLadgla);
    var dataAdapterLdgla = new $.jqx.dataAdapter(sourceLdgla);
    var dataAdapterLpgla = new $.jqx.dataAdapter(sourceLpgla);
    var dataAdapterLlgla = new $.jqx.dataAdapter(sourceLlgla);
    var dataAdapterLflat = new $.jqx.dataAdapter(sourceLflat);
    var dataAdapterLfa = new $.jqx.dataAdapter(sourceLfa);
    $('#assetGlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLagla, displayMember: "description", valueMember: "glAccountId"});
    $('#accDepGlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLadgla, displayMember: "description", valueMember: "glAccountId"});
    $('#depGlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLdgla, displayMember: "description", valueMember: "glAccountId"});
    $('#profitGlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLpgla, displayMember: "description", valueMember: "glAccountId"});
    $('#lossGlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLlgla, displayMember: "description", valueMember: "glAccountId"});
    $('#fixedAssetTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLflat, displayMember: "description", valueMember: "fixedAssetTypeId"});
    $('#fixedAssetId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterLfa, displayMember: "description", valueMember: "fixedAssetId"});
    
    $("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
   
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
	$("#alterSave").click(function () {
		var row;
		var fixedAssetId = $('#fixedAssetId').val(); 
		if(fixedAssetId == ""){
			fixedAssetId = "_NA_";
		}
		var fixedAssetTypeId = $('#fixedAssetTypeId').val();
		if(fixedAssetTypeId == ""){
			fixedAssetTypeId = "_NA_";
		}
        row = {
        		assetGlAccountId: $('#assetGlAccountId').val(),
        		accDepGlAccountId: $('#accDepGlAccountId').val(),
        		depGlAccountId: $('#depGlAccountId').val(),
        		profitGlAccountId: $('#profitGlAccountId').val(),
        		lossGlAccountId: $('#lossGlAccountId').val(),
        		fixedAssetTypeId: fixedAssetTypeId,
        		fixedAssetId: fixedAssetId
        		
        		
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	   $("#jqxgrid").jqxGrid('clearSelection');                        
       $("#jqxgrid").jqxGrid('selectRow', 0);  
       $("#alterpopupWindow").jqxWindow('close');
		
	});
	
</script>		 