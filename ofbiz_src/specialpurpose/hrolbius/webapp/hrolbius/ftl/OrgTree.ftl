<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<script type="text/javascript">
<#-- some labels are not unescaped in the JSON object so we have to do this manualy -->
function unescapeHtmlText(text) {
    return jQuery('<div />').html(text).text()
}
 
jQuery(window).load(createTree());

<#-- creating the JSON Data -->
var rawdata = [
        <#if (completedTree?has_content)>
            <@fillTree rootCat = completedTree/>
        </#if>
        
        <#macro fillTree rootCat>
            <#if (rootCat?has_content)>
                <#list rootCat as root>
                    {
                    "data": {"title" : unescapeHtmlText("<#if root.groupName?exists>${root.groupName?js_string} [${root.partyId}]<#else>${root.partyId?js_string}</#if>"), "attr": {"href" : "<@ofbizUrl>/mainEmployeeProfile?partyId=${root.partyId}</@ofbizUrl>","onClick" : "callDocument('${root.partyId}');"}},
                    <#if context.homePartyId == root.partyId>
                    "attr": {"id" : "${root.partyId}", "rel" : "C"}
                    <#else>
                    "attr": {"id" : "${root.partyId}", "rel" : "Y"}
                    </#if>
                    <#if root.child?exists>
                    ,"state" : "closed"
                    </#if>
                    <#if root_has_next>
                        },
                    <#else>
                        }
                    </#if>
                </#list>
            </#if>
        </#macro>
     ];
 <#-- create Tree-->
  function createTree() {
    jQuery(function () {
        $.cookie('jstree_select', null);
        $.cookie('jstree_open', null);        
        jQuery("#tree").jstree({
        "core" : {
			"initially_open" : ["${context.homePartyId}"],
			"async" : true
        },
        "search" : {
			"skip_async": false,
			"ajax": {
				"url": "<@ofbizUrl>searchTreeDir</@ofbizUrl>",
				"type": "POST",
				"data" : function(str) {
	                    return { "search_str" : str };
	            },
	        	"success": function(d){
					//$('#tree').jstree("_search_open", data.search_results);
					//console.log("data: ",d._ERROR_MESSAGE_);
					if(d._ERROR_MESSAGE_){
						bootbox.dialog({
							message: d._ERROR_MESSAGE_,
							title: "${uiLabelMap.ErrorWhenSearch}",
							buttons:{
								main: {
									label: "OK!",
									className: "btn-small btn-danger"
								}
							}
						});
						return;
					}else{
						return d.search_results;	
					}
					
	            }
			},
        },
        "plugins" : [ "themes","json_data","search","ui" ,"cookies", "types", "crrm", "contextmenu"],
            "json_data" : {
                "data" : rawdata,
                          "ajax" : { "url" : "<@ofbizUrl>getHRChild</@ofbizUrl>", "type" : "POST",
                          "data" : function (n) {
                            return { 
                                "partyId" : n.attr ? n.attr("id").replace("node_","") : 1 ,
                                "additionParam" : "','category" ,
                                "hrefString" : "viewprofile?partyId=" ,
                                "onclickFunction" : "callDocument"
                        }; 
                    }
                }
            },
            "types" : {
             "valid_children" : [ "root" ],
             "types" : {
                 "CATEGORY" : {
                     "icon" : { 
                         "image" : "/images/jquery/plugins/jsTree/themes/apple/d.png",
                         "position" : "10px40px"
                     }
                 }
             }
            },
            "contextmenu": {items: customMenu}
        }).bind("search.jstree", function (e, data) {
			//console.log("Found " + data.rslt.nodes.length + " nodes matching '" + data.rslt.str + "'.");
			//$('#tree').jstree._search_open("#DHR001");
			//console.log("search.jstree: " , data);
        });



        var to =false;
	     $('#jqsearch').keyup(function(event) {
	        /* Act on the event when enter button up*/
	        //$ ( "#tree" ). jstree ( "open_all" )
	        if(event.keyCode == '13'){
			if(to){
		            clearTimeout(to);
		        }
		       to = setTimeout(function () {
				      var v = $('#jqsearch').val();
				      $('#tree').jstree("search",v);
				    }, 250);
	        }
	    });

    });

  }
  
  

  function callDocument(id,type) {
  	
    //jQuerry Ajax Request
    var dataSet = {};
        URL = 'mainEmployeeProfile';
        dataSet = {"partyId" : id};
        
   jQuery.ajax({
        url: URL,
        type: 'POST',
        data: dataSet,
        error: function(msg) {
           alert("An error occured loading content! : " + msg);
        },
        success: function(msg) {;
            jQuery('div.contentarea').html(msg);
        }
    });
  }
  
  function callEmplDocument(id,type) {
    //jQuerry Ajax Request
    var dataSet = {};
        URL = 'emplPositionView';
        dataSet = {"emplPositionId" : id, "ajaxUpdateEvent" : "Y"};
        
    jQuery.ajax({
        url: URL,
        type: 'POST',
        data: dataSet,
        error: function(msg) {
            alert("An error occured loading content! : " + msg);
        },
        success: function(msg) {
            jQuery('div.contentarea').html(msg);
        }
    });
  }
  
  function customMenu(node) {
    // The default set of all items
	//C: root
	//Y: department
	//E: person
    if(node.attr('rel')=='Y'){ 
    var items = {
    		createMgrForOrg: {
   	    		label: "${uiLabelMap.AddManagerForOrg}",
   	    		action: function (NODE, TREE_OBJ){
   	    			var dataSet = {"orgId" : NODE.attr("id")};
   	    			jQuery.ajax({
   	    				type: "GET",
   	    				url: "EditMgrForOrg",
   	    				data: dataSet,
   	    				success: function(data){
   	    					jQuery('div.contentarea').html(data);
   	    				}, 
   	    				error: function(error){
   	    					bootbox.dialog({
   								message: error,
   								title: "${uiLabelMap.ErrorWhenLoadContent}",
   								buttons:{
   									main: {
   										label: "OK!",
   										className: "btn-small btn-danger"
   									}
   								}
   							});
   	    				}
   	    			});
   	    		}
   	    	},	
        // EmpPosition: { 
            // label: "${uiLabelMap.HrolbiusAddEmployee}",
            // action: function (NODE, TREE_OBJ) {
                // var dataSet = {};
                // dataSet = {"partyId" : NODE.attr("id")};
                // jQuery.ajax({
                    // type: "GET",
                    // url: "mainEditEmployment",
                    // data: dataSet,
                    // error: function(msg) {
                        // alert("An error occured loading content! : " + msg);
                    // },
                    // success: function(msg) {
                        // jQuery('div.contentarea').html(msg);
                    // }
                // });
            // }
        // },
        
        CreateAndAddEmp:{
        	label: "${uiLabelMap.HRCreateAndAddEmpl}",
        	action: function(NODE, TREE_OBJ){
        		/* var dataSet = {"internalOrgId" : NODE.attr("id")};
        		jQuery.ajax({
        			type: "POST",
        			url: "NewEmplDirectory",
        			data: dataSet,
        			error: function(msg){
        				alert("An error occured loading content! : " + msg);
        			},
        			success: function(data){
        				jQuery("div.createNewEmpl").html(data);
        			}
        			
        		}); */
        		window.open("<@ofbizUrl>NewEmployee?internalOrgId="+ NODE.attr("id") +"</@ofbizUrl>", "_blank");
        	}
        },
        
         AddIntOrg: { 
            label: "${uiLabelMap.HrolbiusAddOrganizationUnit}",
            action: function (NODE, TREE_OBJ) {
                var dataSet = {};
                dataSet = {"parentOrgId" : NODE.attr("id")};
				url: "mainCreateOrganizationalUnit";
                jQuery.ajax({
                    type: "GET",
                    url: "mainCreateOrganizationalUnit",
                    data: dataSet,
                    error: function(msg) {
                        alert("An error occured loading content! : " + msg);
                    },
                    success: function(msg) {
                    	jQuery('div.contentarea').html(msg);
                    }
                });
            }
        },
        
        RemoveIntOrg: { 
            label: "${uiLabelMap.HrolbiusRemoveInternalOrganization}",
            action: function (NODE, TREE_OBJ) {
                var dataSet = {};
                dataSet = {"partyId" : NODE.attr("id"),"parentpartyId" : $.jstree._focused()._get_parent(node).attr("id")};
                jQuery.ajax({
                    type: "GET",
                    url: "RemoveInternalOrgFtl",
                    data: dataSet,
                    error: function(msg) {
                        alert("An error occured loading content! : " + msg);
                    },
                    success: function(msg) {
                        jQuery('#dialog').html(msg);
                    }
                });
            }
        },
        PrintEmplList: {
        	label: "${uiLabelMap.PrintEmplList}",
        	action: function(NODE, TREE_OBJ){
        		window.open("<@ofbizUrl>EmplListPDF?internalOrgId="+ NODE.attr("id") +"</@ofbizUrl>");
        	}
        }
    };}
    if(node.attr('rel')=='C'){ 
        var items = {
           AddIntOrg: { 
            label: "${uiLabelMap.HrolbiusAddOrganizationUnit}",
            action: function (NODE, TREE_OBJ) {
                var dataSet = {};
                dataSet = {"parentOrgId" : NODE.attr("id")};
				url: "mainCreateOrganizationalUnit";
                jQuery.ajax({
                    type: "GET",
                    url: "mainCreateOrganizationalUnit",
                    data: dataSet,
                    error: function(msg) {
                        alert("An error occured loading content! : " + msg);
                    },
                    success: function(msg) {
                    	jQuery('div.contentarea').html(msg);
                    }
                });
            }
        },
        
        // EmpPosition: { 
            // label: "${uiLabelMap.HrolbiusAddEmployee}",
            // action: function (NODE, TREE_OBJ) {
                // var dataSet = {};
                // dataSet = {"partyId" : NODE.attr("id")};
                // jQuery.ajax({
                    // type: "GET",
                    // url: "mainEditEmployment",
                    // data: dataSet,
                    // error: function(msg) {
                        // alert("An error occured loading content! : " + msg);
                    // },
                    // success: function(msg) {
                        // jQuery('div.contentarea').html(msg);
                    // }
                // });
            // }
        // },
        CreateAndAddEmp:{
        	label: "${uiLabelMap.HRCreateAndAddEmpl}",
        	action: function(NODE, TREE_OBJ){
        		/* var dataSet = {"internalOrgId" : NODE.attr("id")};
        		jQuery.ajax({
        			type: "POST",
        			url: "NewEmplDirectory",
        			data: dataSet,
        			error: function(msg){
        				alert("An error occured loading content! : " + msg);
        			},
        			success: function(data){
        				jQuery("div.createNewEmpl").html(data);
        			}
        		}); */
        		window.open("<@ofbizUrl>NewEmployee?internalOrgId="+ NODE.attr("id") +"</@ofbizUrl>", "_blank");
        	}
        },
        PrintEmplList: {
        	label: "${uiLabelMap.PrintEmplList}",
        	action: function(NODE, TREE_OBJ){
        		window.open("<@ofbizUrl>EmplListPDF?internalOrgId="+ NODE.attr("id") +"</@ofbizUrl>");
        	}
        }
        }
    }
	if(node.attr('rel')=='N'){ 
        var items = {
            AddPerson: { 
                label: "Add Person",
                action: function (NODE, TREE_OBJ) {
                    var dataSet = {};
                    dataSet = {"emplPositionId" : NODE.attr("id")};
                    jQuery.ajax({
                        type: "GET",
                        url: "EditEmplPositionFulfillments",
                        data: dataSet,
                        error: function(msg) {
                            alert("An error occured loading content! : " + msg);
                        },
                        success: function(msg) {
                            jQuery('div.contentarea').html(msg);
                        }
                    });
                }
            }
        }
    }
    
    if(node.attr('rel')=='E'){ 
        var items = {
             RemoveIntOrg: { 
	            label: "${uiLabelMap.HrolbiusRemovePerson}",
	            action: function (NODE, TREE_OBJ) {
	                var dataSet = {};
	                dataSet = {"partyId" : NODE.attr("id"),"parentpartyId" : $.jstree._focused()._get_parent(node).attr("id")};
	                jQuery.ajax({
	                    type: "GET",
	                    url: "RemoveInternalPerson",
	                    data: dataSet,
	                    error: function(msg) {
	                        alert("An error occured loading content! : " + msg);
	                    },
	                    success: function(msg) {
	                        jQuery('#dialog').html(msg);
	                    }
	                });
	            }
	        }
        }
    }
    
    if ($(node).hasClass("folder")) {
        // Delete the "delete" menu item
        delete items.deleteItem;
    }

    return items;
}


</script>
<div id="dialog" title="Basic dialog">
</div>
<div class="row-fluid">
	<div class="span5">
		<div class="widget-box transparent no-bottom-border">
			<div class="widget-header widget-header-small">
				<h4 style="margin-top: 3px">${uiLabelMap.FormFieldTitle_company}</h4>
				<div class="widget-toolbar">
					<div class="nav-search" id="nav-search" style="position: relative;">
						<span class="input-icon">
							<input type="text" id="jqsearch" placeholder="${uiLabelMap.CommonSearch} ..." class="input-small nav-search-input" id="nav-search-input" autocomplete="off" />
							<i class="icon-search nav-search-icon"></i>
						</span>
					</div>
				</div>
			</div>
			<div class="widget-body">
				<div id="tree" class="span12" style="margin-top: 5px"></div>				
			</div>
		</div>
	</div>
	<div class="span7">
		<div class="contentarea"></div>
	</div>
	<div class="page-container"></div>
</div>
<div class="row-fluid">
	<div class="span12 margin-top30">
		<div class="createNewEmpl"></div>
	</div>
</div>
<div></div>
<style>
	input[type=text]:focus {
		box-shadow: 0 0 5px rgba(81, 203, 238, 1);
  		border: 1px solid rgba(81, 203, 238, 1);
	}
</style>
