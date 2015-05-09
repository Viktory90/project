<#assign dataField="[{ name: 'partyId', type: 'string' },
					 { name: 'year', type: 'number' },
					 ]"/>

<#assign columnlist="{ text: '${uiLabelMap.Department}', datafield: 'partyId', width: 150},
                     { text: '${uiLabelMap.Year}', datafield: 'year', width: 150},
                     { text: '${uiLabelMap.Position}', datafield: 'emplPositionTypeId', width: 150},
                     { text: '${uiLabelMap.Status}', datafield: 'statusId', width: 150},
                     { text: '${uiLabelMap.FirstMonth}', datafield: 'firstMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.SecondMonth}', datafield: 'secondMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.ThirdMonth}', datafield: 'thirdMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.FourthMonth}', datafield: 'fourthMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.FifthMonth}', datafield: 'fifthMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.SixthMonth}', datafield: 'sixthMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.SeventhMonth}', datafield: 'seventhMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.EighthMonth}', datafield: 'eighthMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.NinthMonth}', datafield: 'ninthMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.TenthMonth}', datafield: 'tenthMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.EleventhMonth}', datafield: 'eleventhMonth', width: 100, filterable: false},
                     { text: '${uiLabelMap.TwelfthMonth}', datafield: 'twelfthMonth', width: 100, filterable: false}
					 "/>

<@jqGrid addrow="false" id="jqxgrid" filtersimplemode="true" addrow="true" showtoolbar="true" clearfilteringbutton="true"
		 url="jqxGeneralServicer?sname=JQGetListRecruitmentPlan" dataField=dataField columnlist=columnlist addColumns="partyId;year;emplPositionTypeId"
		 />