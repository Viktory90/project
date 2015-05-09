<script type="text/javascript" language="Javascript">
	<#assign itlength = listPaymentType.size()/>
    <#if listPaymentType?size gt 0>
	    <#assign lpt="var lpt = ['" + StringUtil.wrapString(listPaymentType.get(0).paymentTypeId?if_exists) + "'"/>
		<#assign lptValue="var lptValue = [\"" + StringUtil.wrapString(listPaymentType.get(0).paymentTypeId?if_exists) + " - " + StringUtil.wrapString(listPaymentType.get(0).description?if_exists) +"\""/>
		<#if listPaymentType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lpt=lpt + ",'" + StringUtil.wrapString(listPaymentType.get(i).paymentTypeId?if_exists) + "'"/>
				<#assign lptValue=lptValue + ",\"" + StringUtil.wrapString(listPaymentType.get(i).paymentTypeId?if_exists) + " - " + StringUtil.wrapString(listPaymentType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lpt=lpt + "];"/>
		<#assign lptValue=lptValue + "];"/>
	<#else>
    	<#assign lpt="var lpt = [];"/>
    	<#assign lptValue="var lptValue = [];"/>
    </#if>
	${lpt}
	${lptValue}	
	
	var dataPT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["paymentTypeId"] = lpt[i];
        row["description"] = lptValue[i];
        dataPT[i] = row;
    }
	<#assign itlength = listGlAccountType.size()/>
    <#if listGlAccountType?size gt 0>
	    <#assign lglat="var lglat = ['" + StringUtil.wrapString(listGlAccountType.get(0).glAccountTypeId?if_exists) + "'"/>
		<#assign lglatValue="var lglatValue =[\"" + StringUtil.wrapString(listGlAccountType.get(0).glAccountTypeId?if_exists) + " - " + StringUtil.wrapString(listGlAccountType.get(0).description?if_exists)+"\""/>
		<#if listGlAccountType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lglat=lglat + ",'" + StringUtil.wrapString(listGlAccountType.get(i).glAccountTypeId?if_exists) + "'"/>
				<#assign lglatValue=lglatValue + ",\"" + StringUtil.wrapString(listGlAccountType.get(i).glAccountTypeId?if_exists) + " - "  + StringUtil.wrapString(listGlAccountType.get(i).description?if_exists)+"\""/>
			</#list>
		</#if>
		<#assign lglat=lglat + "];"/>
		<#assign lglatValue=lglatValue + "];"/>
	<#else>
    	<#assign lglat="var lglat = [];"/>
    	<#assign lglatValue="var lglatValue = [];"/>
    </#if>
	${lglat}
	${lglatValue}	
	var dataGLAT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["description"] = lglatValue[i];
        row["glAccountTypeId"] = lglat[i];
        dataGLAT[i] = row;
    };
</script>


<#assign dataField="[{ name: 'paymentTypeId', type: 'string' },
					 { name: 'glAccountTypeId', type: 'string' }
					 ]
					"/>
<#assign columnlist="{ text: '${uiLabelMap.PaymentType}', datafield: 'paymentTypeId'},
					 { text: '${uiLabelMap.GlAccountType}', datafield: 'glAccountTypeId'}
					 
					 
					"/>
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListGlAccountTypePaymentType" dataField=dataField columnlist=columnlist 
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true" 
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow"
		 createUrl="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&jqaction=C&sname=addPaymentTypeGlAssignment"
		 addColumns="paymentTypeId;glAccountTypeId;organizationPartyId[${parameters.organizationPartyId}]"
		
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=removePaymentTypeGlAssignment&jqaction=D" 
		 deleteColumn="paymentTypeId;organizationPartyId[${parameters.organizationPartyId}]"
 />				
 <div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.PaymentType}:</td>
	 			<td align="left"><div id="paymentTypeId"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.GlAccountType}:</td>
	 			<td align="left"><div id="glAccountTypeId" ></div></td>
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
	
	var sourcePt =
    {
        localdata: dataPT,
        datatype: "array"
    };
	var sourceGlat =
    {
        localdata: dataGLAT,
        datatype: "array"
    };
    var dataAdapterPt = new $.jqx.dataAdapter(sourcePt);
    var dataAdapterGlat = new $.jqx.dataAdapter(sourceGlat);
    $('#paymentTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterPt, displayMember: "description", valueMember: "paymentTypeId"});
    $('#glAccountTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGlat, displayMember: "description", valueMember: "glAccountTypeId"});
    $("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
	$("#alterSave").click(function () {
		var row;
        row = {
        		paymentTypeId: $('#paymentTypeId').val(),
        		glAccountTypeId: $('#glAccountTypeId').val()
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	   $("#jqxgrid").jqxGrid('clearSelection');                        
       $("#jqxgrid").jqxGrid('selectRow', 0);  
       $("#alterpopupWindow").jqxWindow('close');
		
	});
</script>			