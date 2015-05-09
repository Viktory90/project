<div class="tab-pane" id="workProcessInfoTab">
	<#assign dataField="[{ name: 'partyId', type: 'string' },
						{ name: 'companyName', type: 'string' },
						{ name: 'emplPositionTypeId', type: 'string' },
						{ name: 'jobDescription', type: 'string'},
						{ name: 'payroll', type: 'string'},
						{ name: 'terminationReasonId', type: 'string'},
						{ name: 'rewardDiscrip', type: 'string'},
						{ name: 'fromDate', type: 'date', other: 'Timestamp' },
						{ name: 'thruDate', type: 'date', other: 'Timestamp' }
						]"/>

	<#assign columnlist="{ text: '${uiLabelMap.CompanyName}', datafield: 'companyName', width: 200,
							cellsrenderer: function(column, row, value){
								for(var i = 0; i < partyData.length; i++){
									if(value == partyData[i].partyId){
										return '<span title=' + value + '>' + partyData[i].description + '</span>';
									}
								}
								return '<span>' + value + '</span>';
							}
						 },
						 { text: '${uiLabelMap.EmplPositionTypeId}', datafield: 'emplPositionTypeId', width: 200},
						 { text: '${uiLabelMap.JobDescription}', datafield: 'jobDescription', width: 200},
						 { text: '${uiLabelMap.HRSalary}', datafield: 'payroll', width: 200},
						 { text: '${uiLabelMap.TerminationReason}', datafield: 'terminationReasonId', width: 200},
						 { text: '${uiLabelMap.HRRewardAndDisciplining}', datafield: 'rewardDiscrip', width: 200},
						 { text: '${uiLabelMap.CommonFromDate}', datafield: 'fromDate', width: 200, cellsformat: 'd', filtertype:'range'},
						 { text: '${uiLabelMap.CommonThruDate}', datafield: 'thruDate', width: 200, cellsformat: 'd', filtertype:'range'},
						"/>

	<@jqGrid addrow="false" addType="popup" isShowTitleProperty="false" id="jqxgridWorkProcessInfo" filtersimplemode="true" showtoolbar="true" clearfilteringbutton="true"
	url="jqxGeneralServicer?sname=JQGetListEmplWorkProcess&partyId=${parameters.partyId}" dataField=dataField columnlist=columnlist />
</div>
