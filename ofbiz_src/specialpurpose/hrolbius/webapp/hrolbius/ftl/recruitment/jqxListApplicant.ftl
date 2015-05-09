<#--=================================================Prepare Data==================================================================-->
<script>
	var genderData = new Array();
	var row = {};
	row['gender'] = 'M';
	row['description'] = "${uiLabelMap.Male}";
	genderData[0] = row;
	
	var row = {};
	row['gender'] = 'F';
	row['description'] = "${uiLabelMap.Female}";
	genderData[1] = row;
	
	//Prepare data for nationality 
	<#assign listNationality = delegator.findList("Nationality", null, null, null, null, false) >
	var nationalitypeData = new Array();
	<#list listNationality as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['nationalityId'] = '${item.nationalityId}';
		row['description'] = '${description}';
		nationalitypeData[${item_index}] = row;
	</#list>
	
	//Prepare data for maritalStatus 
	<#assign listMaritalStatus = delegator.findList("MaritalStatus", null, null, null, null, false) >
	var maritalStatusData = new Array();
	<#list listMaritalStatus as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['maritalStatusId'] = '${item.maritalStatusId}';
		row['description'] = '${description}';
		maritalStatusData[${item_index}] = row;
	</#list>
	
	//Prepare data for ethnicOrigin 
	<#assign listEthnicOrigin = delegator.findList("EthnicOrigin", null, null, null, null, false) >
	var ethnicOriginData = new Array();
	<#list listEthnicOrigin as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['maritalStatusId'] = '${item.ethnicOriginId}';
		row['description'] = '${description}';
		ethnicOriginData[${item_index}] = row;
	</#list>
	
	//Prepare data for religion 
	<#assign listReligion = delegator.findList("Religion", null, null, null, null, false) >
	var religionData = new Array();
	<#list listReligion as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['religionId'] = '${item.religionId}';
		row['description'] = '${description}';
		religionData[${item_index}] = row;
	</#list>
	
	//Prepare data for employment app source type 
	<#assign listEmplAppSourceTypes = delegator.findList("EmploymentAppSourceType", null, null, null, null, false) >
	var emplAppSourceTypeData = new Array();
	<#list listEmplAppSourceTypes as item>
		var row = {};
		<#assign description = StringUtil.wrapString(item.description?if_exists) />
		row['employmentAppSourceTypeId'] = '${item.employmentAppSourceTypeId}';
		row['description'] = '${description}';
		emplAppSourceTypeData[${item_index}] = row;
	</#list>
</script>
<#--=================================================/Prepare Data==================================================================-->

<#--=================================================Initial Grid==================================================================-->
<#assign dataField="[{ name: 'partyId', type: 'string'},
					 { name: 'firstName', type: 'string'},
					 { name: 'middleName', type: 'string'},
					 { name: 'lastName', type: 'string'},
					 { name: 'emplPositionTypeId', type: 'string' }
					 ]"/>

<#assign columnlist="{ text: '${uiLabelMap.CommonId}', datafield: 'partyId', width: 100, editable: false},
                     { text: '${uiLabelMap.fullName}', editable: false},
                     { text: '${uiLabelMap.Position}', width: 250, editable: false}
					 "/>

<@jqGrid id="jqxgrid" filtersimplemode="true" addrefresh="true" addType="popup" alternativeAddPopup="alterpopupNewApplicant" addrow="true" showtoolbar="true" clearfilteringbutton="true"
		 url="jqxGeneralServicer?sname=JQGetListApplicant" dataField=dataField columnlist=columnlist
		 createUrl="jqxGeneralServicer?sname=createJobRequest&jqaction=C" addColumns="emplPositionTypeId;fromDate(java.sql.Timestamp);thruDate(java.sql.Timestamp);resourceNumber(java.lang.Long);recruitmentTypeId;recruitmentFormId;listCriteria(java.util.List);jobDescription"
		/>
<#--=================================================/Initial Grid==================================================================-->

<#--====================================================Create new popup window==========================================================-->
<div class="row-fluid">
	<div class="span12">
		<div id="alterpopupNewApplicant">
			<div id="windowHeaderNewApplicant">
	            <span>
	               ${uiLabelMap.NewApplicant}
	            </span>
	        </div>
	        <div style="overflow: hidden; padding: 15px" id="windowContentNewApplicant">
			    <div id='jqxTabs'>
		            <ul>
		                <li style="margin-left: 30px;">${uiLabelMap.generalInfo}</li>
		                <li>${uiLabelMap.familyMemberInfo}</li>
		                <li>${uiLabelMap.trainingInfo}</li>
		                <li>${uiLabelMap.workProcessInfo}</li>
		                <li>${uiLabelMap.positionInfo}</li>
		            </ul>
		            <div id="newGeneralInfo">
		                <#include "jqxEditGeneralInfo.ftl" />
			            <div class="row-fluid" style="margin-top: 5px">
		                	<div class="span12" style="text-align: right;">
		                		<button type="button" style="margin-right: 15px" class="btn btn-mini btn-primary next" >${uiLabelMap.CommonNext} <i class="icon-arrow-right"></i></button>
		                	</div>
	                	</div>
		            </div>
		            <div>
		                JavaServer Pages (JSP) is a Java technology that helps software developers serve
		                dynamically generated web pages based on HTML, XML, or other document types. Released
		                in 1999 as Sun's answer to ASP and PHP,[citation needed] JSP was designed to address
		                the perception that the Java programming environment didn't provide developers with
		                enough support for the Web. To deploy and run, a compatible web server with servlet
		                container is required. The Java Servlet and the JavaServer Pages (JSP) specifications
		                from Sun Microsystems and the JCP (Java Community Process) must both be met by the
		                container.
			            <div class="row-fluid">
			            	<div class="span12" style="text-align: right; margin-top: 10px; padding-right: 18px">
			            		<button type="button" class="btn btn-mini btn-success back" ><i class="icon-arrow-left"></i>${uiLabelMap.CommonPrevious}</button>
		                		<button type="button" class="btn btn-mini btn-primary next" >${uiLabelMap.CommonNext}&nbsp;<i class="icon-arrow-right"></i></button>
		                	</div>
	                	</div>
		            </div>
		            <div>
		                ASP.NET is a web application framework developed and marketed by Microsoft to allow
		                programmers to build dynamic web sites, web applications and web services. It was
		                first released in January 2002 with version 1.0 of the .NET Framework, and is the
		                successor to Microsoft's Active Server Pages (ASP) technology. ASP.NET is built
		                on the Common Language Runtime (CLR), allowing programmers to write ASP.NET code
		                using any supported .NET language. The ASP.NET SOAP extension framework allows ASP.NET
		                components to process SOAP messages.
		                <div class="row-fluid">
			            	<div class="span12" style="text-align: right; margin-top: 10px; padding-right: 18px">
			            		<button type="button" class="btn btn-mini btn-success back" ><i class="icon-arrow-left"></i>${uiLabelMap.CommonPrevious}</button>
		                		<button type="button" class="btn btn-mini btn-primary next" >${uiLabelMap.CommonNext}&nbsp;<i class="icon-arrow-right"></i></button>
		                	</div>
	                	</div>
		            </div>
		            <div>
		                Python is a general-purpose, high-level programming language[5] whose design philosophy
		                emphasizes code readability. Python claims to "[combine] remarkable power with very
		                clear syntax",[7] and its standard library is large and comprehensive. Its use of
		                indentation for block delimiters is unique among popular programming languages.
		                Python supports multiple programming paradigms, primarily but not limited to object-oriented,
		                imperative and, to a lesser extent, functional programming styles. It features a
		                fully dynamic type system and automatic memory management, similar to that of Scheme,
		                Ruby, Perl, and Tcl. Like other dynamic languages, Python is often used as a scripting
		                language, but is also used in a wide range of non-scripting contexts.
		                <div class="row-fluid">
			            	<div class="span12" style="text-align: right; margin-top: 10px; padding-right: 18px">
			            		<button type="button" class="btn btn-mini btn-success back" ><i class="icon-arrow-left"></i>${uiLabelMap.CommonPrevious}</button>
		                		<button type="button" class="btn btn-mini btn-primary next" >${uiLabelMap.CommonNext}&nbsp;<i class="icon-arrow-right"></i></button>
		                	</div>
	                	</div>
		            </div>
		            <div>
		                Perl is a high-level, general-purpose, interpreted, dynamic programming language.
		                Perl was originally developed by Larry Wall in 1987 as a general-purpose Unix scripting
		                language to make report processing easier. Since then, it has undergone many changes
		                and revisions and become widely popular amongst programmers. Larry Wall continues
		                to oversee development of the core language, and its upcoming version, Perl 6. Perl
		                borrows features from other programming languages including C, shell scripting (sh),
		                AWK, and sed.[5] The language provides powerful text processing facilities without
		                the arbitrary data length limits of many contemporary Unix tools, facilitating easy
		                manipulation of text files.
		                <div class="row-fluid">
			            	<div class="span12" style="text-align: right; margin-top: 10px; padding-right: 36px">
			            		<button type="button" class="btn btn-mini btn-success back" ><i class="icon-arrow-left"></i>${uiLabelMap.CommonPrevious}</button>
		               			<button type="button" id='submitTrainingCourse' class="btn btn-mini btn-primary">${uiLabelMap.CommonCreate}</button>
		                	</div>
	                	</div>
		            </div>
		        </div>
	        </div>
		</div>
	</div>
</div>
<#--====================================================/Create new popup window==========================================================-->
	
<script>
$(document).ready(function () {
    
    //Create window
	$("#alterpopupNewApplicant").jqxWindow({
        showCollapseButton: false, maxHeight: 1000, autoOpen: false, maxWidth: "80%", height: 600, minWidth: '40%', width: "80%", isModal: true,
        theme:theme, collapsed:false,
        initContent: function () {
        	// Create jqxTabs.
            $('#jqxTabs').jqxTabs({ width: '95%', height: 520, position: 'top'});
        }
    });
	
	//Create lastName
	$("#lastName").jqxInput({width: 195});
	
	//Create middleName
	$("#middleName").jqxInput({width: 195});
	
	//Create firstName
	$("#firstName").jqxInput({width: 195});
	
	//Create firstName
	$("#firstName").jqxInput({width: 195});
	
	//Create height
	$("#height").jqxInput({width: 195});
	
	//Create weight
	$("#weight").jqxInput({width: 195});
	
	//Create idNumber
	$("#idNumber").jqxInput({width: 195});
	
	//Create idIssuePlace
	$("#idIssuePlace").jqxInput({width: 195});
	
	//Create Gender
	$("#gender").jqxDropDownList({source: genderData, selectedIndex: 0, valueMember: "gender", displayMember: "description"});
	
	//Create birthDate
	$("#birthDate").jqxDateTimeInput({});
	
	//Create nationality
	$("#birthPlace").jqxInput({width: 195});
	
	//Create idIssueDate
	$("#idIssueDate").jqxDateTimeInput({});
	
	//Party Grid
	var sourceP =
	{
			datafields:
				[
				 { name: 'partyId', type: 'string' },
				 { name: 'middleName', type: 'string' },
				 { name: 'firstName', type: 'string' },
				 { name: 'lastName', type: 'string' }
				],
			cache: false,
			root: 'results',
			datatype: "json",
			updaterow: function (rowid, rowdata) {
				// synchronize with the server - send update command   
			},
			beforeprocessing: function (data) {
				sourceP.totalrecords = data.TotalRows;
			},
			filter: function () {
				// update the grid and send a request to the server.
				$("#jqxReferPartyGridId").jqxGrid('updatebounddata');
			},
			pager: function (pagenum, pagesize, oldpagenum) {
				// callback called when a page or page size is changed.
			},
			sort: function () {
				$("#jqxReferPartyGridId").jqxGrid('updatebounddata');
			},
			sortcolumn: 'partyId',
			sortdirection: 'asc',
			type: 'POST',
			data: {
				noConditionFind: 'Y',
				conditionsFind: 'N',
			},
			pagesize:15,
			contentType: 'application/x-www-form-urlencoded',
			url: 'jqxGeneralServicer?sname=getListPeople',
	};
	var dataAdapterP = new $.jqx.dataAdapter(sourceP);
	$("#referredByPartyId").jqxDropDownButton({ width: 200, height: 25});
	$("#jqxReferPartyGridId").jqxGrid({
		source: dataAdapterP,
		filterable: true,
		showfilterrow: true,
		virtualmode: true, 
		sortable:true,
		theme: theme,
		editable: false,
		autoheight:true,
		pageable: true,
		rendergridrows: function(obj)
		{
			return obj.data;
		},
	columns: [
	  { text: '${uiLabelMap.CommonId}', datafield: 'partyId', filtertype: 'input'},
	  { text: '${uiLabelMap.lastName}', datafield: 'lastName', filtertype: 'input'},
	  { text: '${uiLabelMap.middleName}', datafield: 'middleName', filtertype: 'input'},
	  { text: '${uiLabelMap.firstName}', datafield: 'firstName', filtertype: 'input'}
	]
	});
	$("#jqxReferPartyGridId").on('rowselect', function (event) {
		var args = event.args;
		var row = $("#jqxReferPartyGridId").jqxGrid('getrowdata', args.rowindex);
		var dropDownContent = '<div style=\"position: relative; margin-left: 3px; margin-top: 5px;\">'+ row['partyId'] +'</div>';
		$('#referredByPartyId').jqxDropDownButton('setContent', dropDownContent);
	});
	
	//Create employmentAppSourceTypeId
	$("#employmentAppSourceTypeId").jqxDropDownList({source: emplAppSourceTypeData, selectedIndex: 0, valueMember: 'emplAppSourceTypeId', displayMember: 'description'});
	
	//Create maritalStatus
	$("#maritalStatus").jqxDropDownList({source: maritalStatusData, selectedIndex: 0, valueMember: 'maritalStatusId', displayMember: 'description'});
	
	//Create numberChildren
	$("#numberChildren").jqxInput({width: 195});
	
	//Create ethnicOrigin
	$("#ethnicOrigin").jqxDropDownList({source: ethnicOriginData, selectedIndex: 0, valueMember: 'ethnicOriginId', displayMember: 'description'});
	
	//Create religion
	$("#religion").jqxDropDownList({source: religionData, selectedIndex: 0, valueMember: 'religionId', displayMember: 'description'});
	
	//Create nativeLand
	$("#nativeLand").jqxInput({width: 195});
	
	$(".next").click(function(){
		$("#jqxTabs").jqxTabs('next');
	});
	
	jQuery(".back").click(function(){
		$('#jqxTabs').jqxTabs('previous');
	});
});
</script>
