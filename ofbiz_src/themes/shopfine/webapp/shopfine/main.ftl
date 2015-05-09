<#-- Render the category page -->
<#if requestAttributes.productCategoryId?has_content>
			<div class="row">
				<div class="span12">
  ${screens.render("component://shopfine/widget/CatalogScreens.xml#bestsellingcategory")}
				</div><!--end span12-->
			</div><!--end row-->
			
			<div class="row">
				<div class="span12">
  ${screens.render("component://shopfine/widget/CatalogScreens.xml#categorydetailSimple")}
				</div><!--end span12-->
			</div><!--end row-->
<#else>
			<div class="row">
				<div class="span12">
  <center><h2>${uiLabelMap.EcommerceNoPROMOTIONCategory}</h2></center>
				</div><!--end span12-->
			</div><!--end row-->
</#if>