<#macro paginationControls>
<#if productIds?has_content>
        <#assign viewIndexMax = Static["java.lang.Math"].ceil((listSize)?double / viewSize?double)>
						<div class="pagination pagination-right">
        <#if (listSize?int > 0)>
							<span class="pull-left">${lowIndex+1} - ${highIndex} ${uiLabelMap.CommonOf} ${listSize}</span>
        </#if>
							<ul>
        <#if (viewIndex?int > 0)>
          <li><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex?int - 1}/~clearSearch=N</@ofbizUrl>" class="invarseColor">${uiLabelMap.CommonPrevious}</a></li>
        </#if>

          <#list 0..viewIndexMax-1 as curViewNum>
          	<#if curViewNum==viewIndex?int>
								<li class="active"><a class="invarseColor" href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~clearSearch=N</@ofbizUrl>">${curViewNum + 1}</a></li>
			<#else>
								<li><a class="invarseColor" href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${curViewNum?int}/~clearSearch=N</@ofbizUrl>">${curViewNum + 1}</a></li>
			</#if>
          </#list>

        <#if highIndex?int < listSize?int>
          <li><a href="<@ofbizUrl>keywordsearch/~VIEW_SIZE=${viewSize}/~VIEW_INDEX=${viewIndex+1}/~clearSearch=N</@ofbizUrl>" class="invarseColor">${uiLabelMap.CommonNext}</a></li>
        </#if>
							</ul>
						</div><!--end pagination-->
</#if>
</#macro>


					<div id="row">
							<!-- <div class="span12"> -->
							<div class="titleHeader clearfix">
								<h3>${uiLabelMap.ProductYouSearchedFor}:</h3>
							</div><!--end titleHeader-->
							<!-- </div> -->

<ul>
<#list searchConstraintStrings as searchConstraintString>
    <li><a href="<@ofbizUrl>keywordsearch?removeConstraint=${searchConstraintString_index}&amp;clearSearch=N</@ofbizUrl>" class="buttontext">X</a>&nbsp;${searchConstraintString}</li>
</#list>
</ul>
<br />
<div>${uiLabelMap.CommonSortedBy}: ${searchSortOrderString}</div>

<#if !productIds?has_content>
  <h2>&nbsp;${uiLabelMap.ProductNoResultsFound}.</h2>
</#if>


        <@paginationControls/>

<#if productIds?has_content>
						<div class="row">
							<ul class="hProductItems clearfix">
        <#list productIds as productId> <#-- note that there is no boundary range because that is being done before the list is put in the content -->
            ${setRequestAttribute("optProductId", productId)}
            ${setRequestAttribute("listIndex", productId_index)}
            ${screens.render(productsummaryScreen)}
        </#list>
							</ul>
						</div><!--end row-->
</#if>

        <@paginationControls/>

					</div><!--end featuredItems-->

					