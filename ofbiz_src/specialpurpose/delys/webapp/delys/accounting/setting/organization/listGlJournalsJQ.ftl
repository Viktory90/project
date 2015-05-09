<#assign dataField="[{ name: 'glJournalId', type: 'string' },
               		{ name: 'glJournalName', type: 'string' },
               		{ name: 'isPosted', type: 'string' },
               		{ name: 'postedDate', type: 'date', other: 'Timestamp'}
               		]"/>
               		
<#assign columnlist="{ text: '${uiLabelMap.Journals}', datafield: 'glJournalId', width: 200},
					 { text: '${uiLabelMap.JournalName}', datafield: 'glJournalName', width: 300},
                     { text : '${uiLabelMap.JournalIsPosted}', datafield: 'isPosted', width: 190},
                     { text : '${uiLabelMap.JournalPostedDate}', datafield: 'postedDate'}
					 "/>          
<@jqGrid url="jqxGeneralServicer?organizationPartyId=${parameters.organizationPartyId}&sname=JQListJournals" dataField=dataField columnlist=columnlist
		 id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true" 
		 addrefresh="true"
		 addrow="true" addType="popup" alternativeAddPopup="alterpopupWindow" createUrl="jqxGeneralServicer?jqaction=C&sname=createGlJournal"
		 addColumns="glJournalName;organizationPartyId[${parameters.organizationPartyId}]"
		 deleterow="true" removeUrl="jqxGeneralServicer?sname=deleteGlJournal&jqaction=D" 
		 deleteColumn="glJournalId;organizationPartyId[${parameters.organizationPartyId}]" 
 />	
<div id="alterpopupWindow">
    <div>${uiLabelMap.accCreateNew}</div>
    <div style="overflow: hidden;">
        <table>
    	 	<tr>
    	 		<td align="right">${uiLabelMap.JournalName}:</td>
	 			<td align="left"><input id="glJournalName" ></input></td>
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
	$("#alterCancel").jqxButton({theme:theme});
    $("#alterSave").jqxButton({theme:theme});
    
	$("#alterSave").click(function () {
		var row;
		
        row = {
        		glJournalName: $('#glJournalName').val()
        	
        		 
        	  };
        
	   $("#jqxgrid").jqxGrid('addRow', null, row, "first");
       $("#alterpopupWindow").jqxWindow('close');
		
	});

</script>		      		