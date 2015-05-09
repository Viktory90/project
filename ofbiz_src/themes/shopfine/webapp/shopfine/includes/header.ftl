
	<div id="mainContainer" class="clearfix">
		<!--begain header-->
		<header>
			<div class="upperHeader">
				<div class="container">
					<ul class="pull-right inline">
				      <#if !userLogin?has_content || (userLogin.userLoginId)?if_exists != "anonymous">
				        <li><a class="invarseColor" href="<@ofbizUrl>viewprofile</@ofbizUrl>">${uiLabelMap.CommonProfile}</a></li>
				        <li><a class="invarseColor" href="<@ofbizUrl>messagelist</@ofbizUrl>">${uiLabelMap.CommonMessages}</a></li>
				        <li><a class="invarseColor" href="<@ofbizUrl>ListQuotes</@ofbizUrl>">${uiLabelMap.OrderOrderQuotes}</a></li>
				        <li><a class="invarseColor" href="<@ofbizUrl>ListRequests</@ofbizUrl>">${uiLabelMap.OrderRequests}</a></li>
				        <li><a class="invarseColor" href="<@ofbizUrl>editShoppingList</@ofbizUrl>">${uiLabelMap.EcommerceShoppingLists}</a></li>
				        <li><a class="invarseColor" href="<@ofbizUrl>orderhistory</@ofbizUrl>">${uiLabelMap.EcommerceOrderHistory}</a></li>
				      </#if>
				      <#if catalogQuickaddUse>
				        <li><a class="invarseColor" href="<@ofbizUrl>quickadd</@ofbizUrl>">${uiLabelMap.CommonQuickAdd}</a></li>
				      </#if>
					</ul>
					<p>
				      <#if userLogin?has_content && userLogin.userLoginId != "anonymous">
					${uiLabelMap.CommonWelcome}&nbsp;${sessionAttributes.autoName?html}! <a href="<@ofbizUrl>logout</@ofbizUrl>">${uiLabelMap.CommonLogout}</a>
				      <#else/>
					${uiLabelMap.CommonWelcome}! <a href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>">${uiLabelMap.CommonLogin}</a> or <a href="<@ofbizUrl>newcustomer</@ofbizUrl>">${uiLabelMap.EcommerceRegister}</a>
				      </#if>
					</p>
				</div><!--end container-->
			</div><!--end upperHeader-->

			<div class="middleHeader">
				<div class="container">

					<div class="middleContainer clearfix">

					<div class="siteLogo pull-left">
						<h1><a href="<@ofbizUrl>main</@ofbizUrl>">OLBIUS</a></h1>
					</div>

					<div class="pull-right">
						<form method="post" action="<@ofbizUrl>keywordsearch</@ofbizUrl>" class="siteSearch">
							<div class="input-append">
								<input type="text" name="SEARCH_STRING" maxlength="50" class="span2" id="appendedInputButton" placeholder="${uiLabelMap.CommonFind}..." value="${requestParameters.SEARCH_STRING?if_exists}">
								
						        <input type="hidden" name="VIEW_SIZE" value="10" />
						        <input type="hidden" name="PAGING" value="Y" />
						        <#if productCategory?exists>
          						<input type="hidden" name="SEARCH_CATEGORY_ID" value="${productCategory.productCategoryId?if_exists}" />
          						</#if>
								<button class="btn btn-primary" type="submit" name=""><i class="icon-search"></i></button>
							</div>
						</form>
					</div>

					<div class="pull-right">
						<div class="btn-group">
      						${screens.render("component://shopfine/widget/CommonScreens.xml#language")}
						</div>

						<div class="btn-group">
      						${screens.render("component://shopfine/widget/CartScreens.xml#minicart")}
						</div>
					</div><!--end pull-right-->

					</div><!--end middleCoontainer-->

				</div><!--end container-->
			</div><!--end middleHeader-->

			<div class="mainNav">
				<div class="container">
					<div class="navbar">
  						${screens.render("component://shopfine/widget/CatalogScreens.xml#menuCategories")}
					</div>
				</div><!--end container-->
			</div><!--end mainNav-->
			
		</header>
		<!-- end header -->
