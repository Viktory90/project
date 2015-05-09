<script type="text/javascript" language="Javascript">
	<#assign itlength = listGlAccountOrganizationAndClass.size()/>
    <#if listGlAccountOrganizationAndClass?size gt 0>
	    <#assign lglaoac ="var lglaoac = ['" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).glAccountId?if_exists) + "'"/>
		<#assign lglaoacValue="var lglaoacValue = [\"" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).glAccountId?if_exists) + "-" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(0).accountName?if_exists) +"\""/>
		<#if listGlAccountOrganizationAndClass?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lglaoac = lglaoac + ",'" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).glAccountId?if_exists) + "'"/>
				<#assign lglaoacValue=lglaoacValue + ",\"" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).glAccountId?if_exists) + "-" + StringUtil.wrapString(listGlAccountOrganizationAndClass.get(i).accountName?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lglaoac=lglaoac + "];"/>
		<#assign lglaoacValue=lglaoacValue + "];"/>
	<#else>
    	<#assign lglaoac="var lglaoac = [];"/>
    	<#assign lglaoacValue="var lglaoacValue = [];"/>
    </#if>
	${lglaoac}
	${lglaoacValue}	
	
	var dataGLOAC = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["glAccountId"] = lglaoac[i];
        row["description"] = lglaoacValue[i];
        dataGLOAC[i] = row;
    }
	var listlistGlAccountOrganizationAndClassRender = function (row, column, value) {
		var data = $('#jqxgrid').jqxGrid('getrowdata', row);
	    for(i=0;i < lglaoac.length; i++){
	    	if(lglaoac[i] == data.glAccountId){
	    		return "<span>" + lglaoacValue[i] + "</span>";
	    	}
	    }
	    return "";
	}
	
	<#assign itlength = finAccountTypes.size()/>
    <#if finAccountTypes?size gt 0>
	    <#assign lfat ="var lfat = ['" + StringUtil.wrapString(finAccountTypes.get(0).finAccountTypeId?if_exists) + "'"/>
		<#assign lflatValue="var lflatValue = [\"" + StringUtil.wrapString(finAccountTypes.get(0).finAccountTypeId?if_exists) + "-" + StringUtil.wrapString(finAccountTypes.get(0).description?if_exists) +"\""/>
		<#if finAccountTypes?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lfat = lfat + ",'" + StringUtil.wrapString(finAccountTypes.get(i).finAccountTypeId?if_exists) + "'"/>
				<#assign lflatValue=lflatValue + ",\"" + StringUtil.wrapString(finAccountTypes.get(i).finAccountTypeId?if_exists) + "-" + StringUtil.wrapString(finAccountTypes.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lfat=lfat + "];"/>
		<#assign lflatValue=lflatValue + "];"/>
	<#else>
    	<#assign lfat="var lfat = [];"/>
    	<#assign lflatValue="var lflatValue = [];"/>
    </#if>
	${lfat}
	${lflatValue}	
	
	var dataFLAT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["finAccountTypeId"] = lfat[i];
        row["description"] = lflatValue[i];
        dataFLAT[i] = row;
    }
	
</script>

<#assign dataField="[{ name: 'finAccountTypeId', type: 'string' },
               		{ name: 'organizationPartyId', type: 'string' },
               		{ name: 'glAccountId', type: 'string' }
               		]"/>
               		
<#assign columnlist="{ text: '${uiLabelMap.AccountTypeId}', datafield: 'finAccountTypeId', width: 400},
					 { text: '${uiLabelMap.GLAccountId}', datafield: 'glAccountId', columntype: 'dropdownlist', cellsrenderer:listlistGlAccountOrganizationAndClassRender,
					 		createeditor: function (row, column, editor) {
                            var sourceGloac =
						    {
						        localdata: dataGLOAC,
						        datatype: \"array\"
						    };
						   
						    var dataAdapterGloac1 = new $.jqx.dataAdapter(sourceGloac);
						    
                            editor.jqxDropDownList({source: dataAdapterGloac1, displayMember:\"glAccountId\", valueMember: \"glAccountId\",
                            renderer: function (index, label, value) {
			                    var datarecord = dataGLOAC[index];
			                    return datarecord.description;
			                } 
                        	}); 
					 	}},
					 "/>          
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListFinAccountTypeGlAccount" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true" 
		 addColumns="finAccountTypeId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 editable="true"  editrefresh="true"
		 
		 createUrl="jqxGeneralServicer?jqaction=C&sname=createFinAccountTypeGlAccount" alternativeAddPopup="alterpopupWindow" addrow="true" addType="popup"
		 addColumns="finAccountTypeId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 updateUrl="jqxGeneralServicer?jqaction=U&sname=updateFinAccountTypeGlAccount"
		 editColumns="finAccountTypeId;glAccountId;organizationPartyId[${parameters.organizationPartyId}]"
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=deleteFinAccountTypeGlAccount&jqaction=D" 
		 deleteColumn="finAccountTypeId;organizationPartyId[${parameters.organizationPartyId}]" 
 />	
<div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.AccountTypeId}:</td>
	 			<td align="left"><div id="accountTypeId" ></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.GLAccountId}:</td>
	 			<td align="left"><div id="GlAccountId"></div></td>
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
	$("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	
	var sourceFlat =
    {
        localdata: dataFLAT,
        datatype: "array"
    };
	var sourceGloac =
    {
        localdata: dataGLOAC,
        datatype: "array"
    };
    var dataAdapterFlat = new $.jqx.dataAdapter(sourceFlat);
    var dataAdapterGloac = new $.jqx.dataAdapter(sourceGloac);
    
    $('#accountTypeId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterFlat, displayMember: "description", valueMember: "finAccountTypeId"});
    $('#GlAccountId').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGloac, displayMember: "description", valueMember: "glAccountId"});
    $("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
    
	$("#alterSave").click(function () {
		var row;
		
        row = {
        		finAccountTypeId: $('#accountTypeId').val(),
        		glAccountId: $('#GlAccountId').val()
        	
        		 
        	  };
        
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
	   $("#jqxgrid").jqxGrid('clearSelection');                        
       $("#jqxgrid").jqxGrid('selectRow', 0);  
       $("#alterpopupWindow").jqxWindow('close');
		
	});

</script>		      		