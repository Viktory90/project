<script type="text/javascript" language="Javascript">
	<#assign itlength = listGlAccountCategoryType.size()/>
    <#if listGlAccountCategoryType?size gt 0>
	    <#assign lglact="var lglact = ['" + StringUtil.wrapString(listGlAccountCategoryType.get(0).glAccountCategoryTypeId?if_exists) + "'"/>
		<#assign lglactValue="var lglactValue = [\"" + StringUtil.wrapString(listGlAccountCategoryType.get(0).glAccountCategoryTypeId?if_exists) + ":" + StringUtil.wrapString(listGlAccountCategoryType.get(0).description?if_exists) +"\""/>
		<#if listGlAccountCategoryType?size gt 1>
			<#list 1..(itlength - 1) as i>
				<#assign lglact=lglact + ",'" + StringUtil.wrapString(listGlAccountCategoryType.get(i).glAccountTypeId?if_exists) + "'"/>
				<#assign lglactValue=lglactValue + ",\"" + StringUtil.wrapString(listGlAccountCategoryType.get(i).glAccountCategoryTypeId?if_exists) + ":" + StringUtil.wrapString(listGlAccountCategoryType.get(i).description?if_exists) + "\""/>
			</#list>
		</#if>
		<#assign lglact=lglact + "];"/>
		<#assign lglactValue=lglactValue + "];"/>
	<#else>
    	<#assign lglact="var lglact = [];"/>
    	<#assign lglactValue="var lglactValue = [];"/>
    </#if>
	${lglact}
	${lglactValue}	
	
	var dataGLACT = new Array();
	for (var i = 0; i < ${itlength}; i++) {
        var row = {};
        row["glAccountCategoryTypeId"] = lglact[i];
        row["description"] = lglactValue[i];
        dataGLACT[i] = row;
    }
</script>

<#assign dataField="[{ name: 'glAccountCategoryId', type: 'string' },
						 { name: 'glAccountCategoryTypeId', type: 'string'},
						 { name: 'description', type: 'string' }
						 ]
						 "/>
<#assign columnlist="{ text: '${uiLabelMap.GlAccountCategoryID}', datafield: 'glAccountCategoryId', width: 250},
					 { text: '${uiLabelMap.GlAccountCategoryTypeID}', datafield: 'glAccountCategoryTypeId', width: 250, columntype: 'dropdownlist',
					 		createeditor: function (row, column, editor) {
                            var sourceGlact =
						    {
						        localdata: dataGLACT,
						        datatype: \"array\"
						    };
						   
						    var dataAdapterGlact = new $.jqx.dataAdapter(sourceGlact);
						    
                            editor.jqxDropDownList({source: dataAdapterGlact, displayMember:\"glAccountCategoryTypeId\", valueMember: \"glAccountCategoryTypeId\",
                            renderer: function (index, label, value) {
			                    var datarecord = dataGLACT[index];
			                    return datarecord.description;
			                } 
                        	}); 
					 	}},
					 { text: '${uiLabelMap.description}', datafield: 'description'}
                      "/>		
<@jqGrid url="jqxGeneralServicer?sname=JQListGlAccountCategory" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true"
		 editable="true"  editrefresh="true"
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow" 
		 createUrl="jqxGeneralServicer?jqaction=C&sname=createGlAccountCategory"
		 addColumns="description;glAccountCategoryTypeId" clearfilteringbutton="true"
		 updateUrl="jqxGeneralServicer?jqaction=U&sname=updateGlAccountCategory" 
		 editColumns="glAccountCategoryId;glAccountCategoryTypeId;description"
		 
 />  
 <div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.GlAccountCategoryTypeID}:</td>
	 			<td align="left"><div id="glAccountCategoryTypeID"></div></td>
    	 	</tr>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.description}:</td>
	 			<td align="left"><input id="description" ></input></td>
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
	var sourceGlact =
    {
        localdata: dataGLACT,
        datatype: "array"
    };
    var dataAdapterGlact = new $.jqx.dataAdapter(sourceGlact);
    $('#glAccountCategoryTypeID').jqxDropDownList({theme:theme, selectedIndex: 0,  source: dataAdapterGlact, displayMember: "description", valueMember: "glAccountCategoryTypeId"});
    $('#description').jqxInput({width:195,theme:theme, placeHolder: "${StringUtil.wrapString(uiLabelMap.description	)}"} );
    $("#alterpopupWindow").jqxWindow({
        width: 600, resizable: false,  isModal: true, autoOpen: false, cancelButton: $("#alterCancel"), modalOpacity: 0.7, theme:theme           
    });
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
	$("#alterSave").click(function () {
		var row;
        row = {
        		
        		glAccountCategoryTypeId: $('#glAccountCategoryTypeID').val(),
        		description: $('#description').val()
        		
        	       
        	  };
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
       $("#alterpopupWindow").jqxWindow('close');
		
	});
</script>	                     				