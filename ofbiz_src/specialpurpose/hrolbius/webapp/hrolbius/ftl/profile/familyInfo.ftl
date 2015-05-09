<script>
	//Prepare for party data
	<#assign listParties = delegator.findList("PartyNameView", null, null, null, null, false) >
	var partyData = new Array();
	<#list listParties as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.firstName?if_exists) + " " + StringUtil.wrapString(item.middleName?if_exists) + " " + StringUtil.wrapString(item.lastName?if_exists) />
		row['partyId'] = '${item.partyId}';
		row['description'] = '${description}';
		partyData[${item_index}] = row;
	</#list>
</script>
<div class="tab-pane" id="familyMemberTab">
	<#assign dataField="[{ name: 'relPartyId', type: 'string' },
					 { name: 'partyFamilyId', type: 'string' },
					 { name: 'partyRelationshipTypeId', type: 'string' },
					 { name: 'occupation', type: 'string' },
					 { name: 'birthDate', type: 'date', other:'Timestamp' },
					 { name: 'placeWork', type: 'string'}
					 ]"/>

	<#assign columnlist="{ text: '${uiLabelMap.FullName}', datafield: 'partyFamilyId', width: 200,
							cellsrenderer: function(column, row, value){
								for(var i = 0;  i < partyData.length; i++){
									if(partyData[i].partyId == value){
										return '<span title=' + value + '>' + partyData[i].description + '</span>'
									}
								}
								return '<span>' + value + '</span>'
							}
						 },
				 { text: '${uiLabelMap.BirthDate}', datafield: 'birthDate', width: 200, cellsformat: 'd', filtertype:'range'},
				 { text: '${uiLabelMap.HROccupation}', datafield: 'occupation'},
				 { text: '${uiLabelMap.placeWork}', datafield: 'placeWork'}
					 "/>

	<@jqGrid addrow="false" addType="popup" isShowTitleProperty="false" id="jqxgrid" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true"
		 url="jqxGeneralServicer?sname=JQGetListEmplFamily&partyId=${parameters.partyId}" dataField=dataField columnlist=columnlist
		 />
</div>