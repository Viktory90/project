<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->
<head>
	
	<!-- Basic Page Needs
  ================================================== -->
	<meta charset="utf-8">
  	<title><#if title?has_content>${title}<#elseif titleProperty?has_content>${uiLabelMap.get(titleProperty)}</#if>: ${(productStore.storeName)?if_exists}</title>
	<meta name="description" content="">
	<meta name="author" content="Ahmed Saeed">
	<!-- Mobile Specific Metas
  ================================================== -->
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<!-- CSS
  ================================================== -->
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/bootstrap.min.css</@ofbizContentUrl>" media="screen">
	<!-- jquery ui css -->
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/jquery-ui-1.10.1.min.css</@ofbizContentUrl>">
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/customize.css</@ofbizContentUrl>">
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/font-awesome.css</@ofbizContentUrl>">
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/style.css</@ofbizContentUrl>">
	<!-- flexslider css-->
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/flexslider.css</@ofbizContentUrl>">
	<!-- fancybox -->
	<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/js/fancybox/jquery.fancybox.css</@ofbizContentUrl>">
	<!--[if lt IE 9]>
		<script src="<@ofbizContentUrl>/shopfine/js/html5.js</@ofbizContentUrl>"></script>
		<script src="<@ofbizContentUrl>/shopfine/js/IE9.js</@ofbizContentUrl>"></script>
		<link rel="stylesheet" href="<@ofbizContentUrl>/shopfine/css/font-awesome-ie7.css</@ofbizContentUrl>">
	<![endif]-->
	<!-- Favicons
	================================================== -->
	<link rel="shortcut icon" href="/images/favicon.ico">
	<link rel="apple-touch-icon" href="/images/apple-touch-icon.png">
	<link rel="apple-touch-icon" sizes="72x72" href="/images/apple-touch-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="114x114" href="/images/apple-touch-icon-114x114.png">

	<script src="<@ofbizContentUrl>/shopfine/js/jquery.min.js</@ofbizContentUrl>"></script>
  <#if VT_HDR_JAVASCRIPT?has_content>
    <#list VT_HDR_JAVASCRIPT as javaScript>
    <script type="text/javascript" src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>"></script>
    </#list>
  </#if>
</head>