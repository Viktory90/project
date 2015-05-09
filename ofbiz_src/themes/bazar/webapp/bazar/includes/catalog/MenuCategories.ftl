<script language="javascript" type="text/javascript" src="<@ofbizContentUrl>/bazar/js/plugins/jsTree/jquery.jstree.js</@ofbizContentUrl>"></script>
<script type="text/javascript" src="<@ofbizContentUrl>/bazar/js/basic/jquery.cookie.js</@ofbizContentUrl>"></script>

<#if (requestAttributes.topLevelList)?exists>
    <#assign topLevelList = requestAttributes.topLevelList>
</#if>
<#assign rootEle=true>
<#assign childEle=false>

<#--
<script type="text/javascript">
	$(document).ready(function(){
		$('ul#menu-menu li').click(function(){
			$('ul#menu-menu li').removeClass('current-menu-item');
			$(this).addClass('current-menu-item');
		});
	});
</script>
 -->

<style type="text/css">
	.level-1 > li > a {
		text-transform:uppercase;
	}
</style>
<!-- current-menu-item  current_page_item-->

<#macro fillTree rootCat>
  <#if (rootCat?has_content)>
	<ul id="menu-menu" class="<#if childEle=false>level-1<#else>sub-menu</#if>">
  		<#if rootEle=true>
  			<li class="home current-menu-item"><a  title="Home" href="<@ofbizUrl>main</@ofbizUrl>"><span>Home</span></a></li>
  		</#if>
  		<#assign rootEle=false>
    	<#list rootCat?sort_by("productCategoryId") as root>
	    	<li class="menu-item menu-item-type-post_type current-menu-item menu-item-object-page page_item page-item-2 dropdown menu-item-children-9">
	    		<a href="<@ofbizCatalogAltUrl productCategoryId=root.productCategoryId/>" style="padding-right: 31px;">
	    			<#if root.categoryName?exists>
	    				${root.categoryName}
	    			<#elseif root.categoryDescription?exists>
	    				${root.categoryDescription}
	    			<#else>
	    				${root.productCategoryId}
	    			</#if>
	    		</a>
	    		<#if root.child?has_content>
	    			<#assign childEle=true>
	                <@fillTree rootCat=root.child/>
	            <#else>
	            	<#assign childEle=false>
	            </#if>
	    	</li>
        </#list>
	</ul>		
  </#if>
</#macro>




    


















<script type="text/javascript">
<#-- some labels are not unescaped in the JSON object so we have to do this manuely -->
function unescapeHtmlText(text) {
    return jQuery('<div />').html(text).text()
}

 <#-------------------------------------------------------------------------------------define Requests-->
  var editDocumentTreeUrl = '<@ofbizUrl>/views/EditDocumentTree</@ofbizUrl>';
  var listDocument =  '<@ofbizUrl>/views/ListDocument</@ofbizUrl>';
  var editDocumentUrl = '<@ofbizUrl>/views/EditDocument</@ofbizUrl>';
  var deleteDocumentUrl = '<@ofbizUrl>removeDocumentFromTree</@ofbizUrl>';

 
<#-------------------------------------------------------------------------------------callDocument function-->
    function callDocument(id, parentCategoryStr) {
        var checkUrl = '<@ofbizUrl>productCategoryList</@ofbizUrl>';
        if(checkUrl.search("http"))
            var ajaxUrl = '<@ofbizUrl>productCategoryList</@ofbizUrl>';
        else
            var ajaxUrl = '<@ofbizUrl>productCategoryListSecure</@ofbizUrl>';

        //jQuerry Ajax Request
        jQuery.ajax({
            url: ajaxUrl,
            type: 'POST',
            data: {"category_id" : id, "parentCategoryStr" : parentCategoryStr},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#content').html(msg);
            }
        });
     }
<#-------------------------------------------------------------------------------------callCreateDocumentTree function-->
      function callCreateDocumentTree(contentId) {
        jQuery.ajax({
            url: editDocumentTreeUrl,
            type: 'POST',
            data: {contentId: contentId,
                        contentAssocTypeId: 'TREE_CHILD'},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#Document').html(msg);
            }
        });
    }
<#-------------------------------------------------------------------------------------callCreateSection function-->
    function callCreateDocument(contentId) {
        jQuery.ajax({
            url: editDocumentUrl,
            type: 'POST',
            data: {contentId: contentId},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#Document').html(msg);
            }
        });
    }
<#-------------------------------------------------------------------------------------callEditSection function-->
    function callEditDocument(contentIdTo) {
        jQuery.ajax({
            url: editDocumentUrl,
            type: 'POST',
            data: {contentIdTo: contentIdTo},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#Document').html(msg);
            }
        });

    }
<#-------------------------------------------------------------------------------------callDeleteItem function-->
    function callDeleteDocument(contentId, contentIdTo, contentAssocTypeId, fromDate) {
        jQuery.ajax({
            url: deleteDocumentUrl,
            type: 'POST',
            data: {contentId : contentId, contentIdTo : contentIdTo, contentAssocTypeId : contentAssocTypeId, fromDate : fromDate},
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                location.reload();
            }
        });
    }
 <#-------------------------------------------------------------------------------------callRename function-->
    function callRenameDocumentTree(contentId) {
        jQuery.ajax({
            url: editDocumentTreeUrl,
            type: 'POST',
            data: {  contentId: contentId,
                     contentAssocTypeId:'TREE_CHILD',
                     rename: 'Y'
                     },
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#Document').html(msg);
            }
        });
    }
 <#------------------------------------------------------pagination function -->
    function nextPrevDocumentList(url){
        url= '<@ofbizUrl>'+url+'</@ofbizUrl>';
         jQuery.ajax({
            url: url,
            type: 'POST',
            error: function(msg) {
                alert("An error occured loading content! : " + msg);
            },
            success: function(msg) {
                jQuery('#Document').html(msg);
            }
        });
    }

</script>

	<#if (topLevelList?has_content)>
		<div id="nav" style="margin-top:-20px">
	  		<div class="container">
	  			<div class="menu-responsive group">
	    			<div class="navigate-text">NAVIGATE TO...</div>
	    			<div class="menu-arrow"></div>
				</div>
				<@fillTree rootCat=completedTree/>
			</div> <!-- END CONTAINER -->
			<div class="border borderstrong borderpadding container"></div>
			<div class="border container"></div>
			<div class="border container"></div>
			<div class="border container"></div>
	    </div> <!-- END NAV -->
	</#if>

	
