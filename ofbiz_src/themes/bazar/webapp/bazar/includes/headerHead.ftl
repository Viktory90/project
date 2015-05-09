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
<#assign docLangAttr = locale.toString()?replace("_", "-")>
<#assign langDir = "ltr">
<#if "ar.iw"?contains(docLangAttr?substring(0, 2))>
    <#assign langDir = "rtl">
</#if>
<html lang="${docLangAttr}" dir="${langDir}" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><#if title?has_content>${title}<#elseif titleProperty?has_content>${uiLabelMap.get(titleProperty)}</#if>: ${(productStore.storeName)?if_exists}</title>
  <#if layoutSettings.VT_SHORTCUT_ICON?has_content>
    <#assign shortcutIcon = layoutSettings.VT_SHORTCUT_ICON.get(0)/>
  <#elseif layoutSettings.shortcutIcon?has_content>
    <#assign shortcutIcon = layoutSettings.shortcutIcon/>
  </#if>
  <#if shortcutIcon?has_content>
    <link rel="shortcut icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)}</@ofbizContentUrl>" />
  </#if>
  <#-- Append CSS for catalog -->
  <#if catalogStyleSheet?exists>
    <link rel="stylesheet" href="${StringUtil.wrapString(catalogStyleSheet)}" type="text/css"/>
  </#if>
  <#-- Append CSS for tracking codes -->
  <#if sessionAttributes.overrideCss?exists>
    <link rel="stylesheet" href="${StringUtil.wrapString(sessionAttributes.overrideCss)}" type="text/css"/>
  </#if>
  <#if layoutSettings.javaScripts?has_content>
    <#--layoutSettings.javaScripts is a list of java scripts. -->
    <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
    <#assign javaScriptsSet = Static["org.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
    <#list layoutSettings.javaScripts as javaScript>
      <#if javaScriptsSet.contains(javaScript)>
        <#assign nothing = javaScriptsSet.remove(javaScript)/>
        <script type="text/javascript" src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>"></script>
      </#if>
    </#list>
  </#if>
  <#if layoutSettings.VT_HDR_JAVASCRIPT?has_content>
    <#list layoutSettings.VT_HDR_JAVASCRIPT as javaScript>
      <script type="text/javascript" src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>"></script>
    </#list>
  </#if>
  ${layoutSettings.extraHead?if_exists}
  <#if layoutSettings.VT_EXTRA_HEAD?has_content>
    <#list layoutSettings.VT_EXTRA_HEAD as extraHead>
      ${extraHead}
    </#list>
  </#if>

  <#-- Meta tags if defined by the page action -->
  <meta name="generator" content="Apache OFBiz - eCommerce"/>
  <#if metaDescription?exists>
    <meta name="description" content="${metaDescription}"/>
  </#if>
  <#if metaKeywords?exists>
    <meta name="keywords" content="${metaKeywords}"/>
  </#if>
  <#if webAnalyticsConfigs?has_content>
    <script language="JavaScript" type="text/javascript">
    <#list webAnalyticsConfigs as webAnalyticsConfig>
      <#if  webAnalyticsConfig.webAnalyticsTypeId != "BACKEND_ANALYTICS">
        ${StringUtil.wrapString(webAnalyticsConfig.webAnalyticsCode?if_exists)}
      </#if>
    </#list>
    </script>
  </#if>
  <link rel="stylesheet" type="text/css" href="/bazar/css/style.css" />
  <link rel="stylesheet" href="/bazar/css/jquery-ui.css" />
  <link rel="stylesheet" href="/bazar/css/frontend.css" />
  <link rel="stylesheet" href="/bazar/css/style(1).css" />
  <link rel="shortcut icon" type="image/x-icon" href="/bazar/images/basic/favicon.ico">
  <link rel="icon" type="image/x-icon" href="/bazar/images/basic/favicon.ico">
  <script src="/bazar/js/hover.js"></script>
  

	
	
	
	
	
	
	
	
	
	
	
	
	
<meta charset="UTF-8">
    
<!-- this line will appear only if the website is visited with an iPad -->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.2, user-scalable=yes">
<meta property="og:site_name" content="Bazar [SHOP]">	
<meta property="og:title" content="Home">
<meta property="og:url" content="http://dev.olbius.com/bazastore">

<script async="" src="//www.google-analytics.com/analytics.js"></script>
<script type="text/javascript">
	var NREUMQ=NREUMQ||[];NREUMQ.push(["mark","firstbyte",new Date().getTime()]);
</script>

<title>Bazar SHOP | usable and clean e-commerce theme</title>


<link rel="stylesheet" href="/bazar/css/jquery-ui.css" type="text/css" media="all">

<link rel="stylesheet" href="/bazar/css/language-selector.css?v=2.6.3" type="text/css" media="all">


<!-- BOOTSTRAP STYLESHEET -->

<link rel="stylesheet" type="text/css" media="all" href="/bazar/css/reset-bootstrap.css">


<!-- MAIN THEME STYLESHEET -->

<link rel="stylesheet" type="text/css" media="all" href="/bazar/css/style.css">

<!-- PINGBACK & WP STANDARDS -->


<script language="javascript">
	var yit_responsive_menu_type = "arrow";
	var yit_responsive_menu_text = "NAVIGATE TO...";
</script>
<style type="text/css"></style>

<!-- [favicon] begin -->
<link rel="shortcut icon" type="image/x-icon" href="/bazar/images/favicon.ico">
<link rel="icon" type="image/x-icon" href="/bazar/images/favicon.ico">
<!-- [favicon] end -->

<!-- Touch icons more info: http://mathiasbynens.be/notes/touch-icons -->
<!-- For iPad3 with retina display: -->
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="/bazar/images/apple-touch-icon-144x.png">
<!-- For first- and second-generation iPad: -->
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="/bazar/images/apple-touch-icon-114x.png">
<!-- For first- and second-generation iPad: -->
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="/bazar/images/apple-touch-icon-72x.png">
<!-- For non-Retina iPhone, iPod Touch, and Android 2.1+ devices: -->
<link rel="apple-touch-icon-precomposed" href="/bazar/images/apple-touch-icon-57x.png">


<style>
    .yith-wcwl-add-button > a.button.alt{background:#4F4F4F;color:#FFFFFF;border-color:#4F4F4F;}
    .wishlist_table a.add_to_cart.button.alt{background:#4F4F4F;color:#FFFFFF;border-color:#4F4F4F;}
    .wishlist_table{background:#FFFFFF;color:#676868;border-color:#676868;}
</style>




<link rel="stylesheet" id="thickbox-css" href="/bazar/css/thickbox.css" type="text/css" media="all">
<link rel="stylesheet" id="google-fonts-css" href="http://fonts.googleapis.com/css?family=Playfair+Display%7COpen+Sans+Condensed%3A300%7COpen+Sans%7CShadows+Into+Light%7COswald%7CPlay%7CMuli%7CArbutus+Slab%7CAbel&amp;ver=3.5.2" type="text/css" media="all">
<link rel="stylesheet" id="open-sans-font-css" href="//fonts.googleapis.com/css?family=Open+Sans%3A400%2C700%2C600&amp;ver=3.5.2" type="text/css" media="all">
<link rel="stylesheet" id="yith-theme-banner-css" href="/bazar/css/yit.css" type="text/css" media="all">
<link rel="stylesheet" id="poshytip-css" href="/bazar/css/poshytip.css" type="text/css" media="all">
<link rel="stylesheet" id="jquery-colorbox-css" href="/bazar/css/colorbox.css" type="text/css" media="all">
<link rel="stylesheet" id="yith-wcwl-user-main-css" href="/bazar/css/wishlist.css" type="text/css" media="all">
<link rel="stylesheet" id="woocommerce_frontend_styles-css" href="/bazar/css/style.css" type="text/css" media="all">

<link rel="stylesheet" id="styles-minified-css" href="/bazar/css/style-28.css" type="text/css" media="all">
<link rel="stylesheet" id="custom-css" href="/bazar/css/custom.css" type="text/css" media="all">
<link rel="stylesheet" id="cache-custom-css" href="/bazar/css/custom-28.css" type="text/css" media="all">
<link rel="stylesheet" id="style-changer-css" href="/bazar/css/picker-celestino.css" type="text/css" media="all">
<link rel="stylesheet" id="colorpicker-css" href="/bazar/css/colorpicker.css" type="text/css" media="all">







<script type="text/javascript" src="/bazar/js/jquery.js"></script>
<script type="text/javascript" src="/bazar/js/anti-spam.js"></script>
<script type="text/javascript" src="/bazar/js/comment-reply.min.js"></script>
<script type="text/javascript" src="/bazar/js/jquery.poshytip.min.js"></script>
<script type="text/javascript" src="/bazar/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/bazar/js/colorpicker.js"></script>

<meta name="generator" content="WordPress 3.5.2">
<script type="text/javascript" src="/bazar/js/sitepress.js"></script>
<meta name="generator" content="WPML ver:2.6.3 stt:1,27;0">

<style type="text/css">
    body { background-color: #ffffff; }      
</style>
<style type="text/css">
    .blog-big .meta, .blog-small .meta { background-color: #ffffff; }      
</style>
<style type="text/css">
	ul.products li.product.list {padding-left:293px}
	ul.products li.product.list .product-thumbnail {margin-left:-293px}
    .widget.widget_onsale li,
    .widget.widget_best_sellers li,
    .widget.widget_recent_reviews li,
    .widget.widget_recent_products li,
    .widget.widget_random_products li,
    .widget.widget_featured_products li,
    .widget.widget_top_rated_products li,
    .widget.widget_recently_viewed_products li {min-height: 80px}

    .widget.widget_onsale li .star-rating,
    .widget.widget_best_sellers li .star-rating,
    .widget.widget_recent_reviews li .star-rating,
    .widget.widget_recent_products li .star-rating,
    .widget.widget_random_products li .star-rating,
    .widget.widget_featured_products li .star-rating,
    .widget.widget_top_rated_products li .star-rating,
    .widget.widget_recently_viewed_products li .star-rating { margin-left: 115px}

    /* IE8, Portrait tablet to landscape and desktop till 1024px */
    .single-product div.images { width:50.8045977011%; }
    .single-product div.summary { width:42.6666666667%; }

    /* WooCommerce standard images */
    .single-product .images .thumbnails > a { width:80px !important; height:80px !important; }
    /* Slider images */
    .single-product .images .thumbnails li img { max-width:80px !important; }

    /* Desktop above 1200px */
    @media (min-width:1200px) {
            .single-product div.images .yith_magnifier_zoom_wrap a img,
        .single-product div.images > a img{ width:462px; height:392px; }
            /* WooCommerce standard images */
        .single-product .images .thumbnails > a { width:100px !important; height:80px !important; }
        /* Slider images */
        .single-product .images .thumbnails li img { max-width:100px !important; }
    }

    /* Desktop above 1200px */
    @media (max-width: 979px) and (min-width: 768px) {
        /* WooCommerce standard images */
        .single-product .images .thumbnails > a { width:63px !important; height:63px !important; }
        /* Slider images */
        .single-product .images .thumbnails li img { max-width:63px !important; }
    }

        /* Below 767px, mobiles included */
    @media (max-width: 767px) {
        .single-product div.images,
        .single-product div.summary { float:none;margin-left:0px !important;width:100% !important; }

        .single-product div.images { margin-bottom:20px; }

        /* WooCommerce standard images */
        .single-product .images .thumbnails > a { width:65px !important; height:65px !important; }
        /* Slider images */
        .single-product .images .thumbnails li img { max-width:65px !important; }
    }
</style>

<!-- WooCommerce Version -->
<meta name="generator" content="WooCommerce 2.0.8">

<style type="text/css">.recentcomments a{display:inline !important;padding:0 !important;margin:0 !important;}</style>
<style id="poshytip-css-tip-twitter" type="text/css">
	div.tip-twitter{visibility:hidden;position:absolute;top:0;left:0;}
	div.tip-twitter table, div.tip-twitter td{margin:0;font-family:inherit;font-size:inherit;font-weight:inherit;font-style:inherit;font-variant:inherit;}
	div.tip-twitter td.tip-bg-image span{display:block;font:1px/1px sans-serif;height:10px;width:10px;overflow:hidden;}
	div.tip-twitter td.tip-right{background-position:100% 0;}
	div.tip-twitter td.tip-bottom{background-position:100% 100%;}
	div.tip-twitter td.tip-left{background-position:0 100%;}
	div.tip-twitter div.tip-inner{background-position:-10px -10px;}
	div.tip-twitter div.tip-arrow{visibility:hidden;position:absolute;overflow:hidden;font:1px/1px sans-serif;}
</style>

<script>window["_GOOG_TRANS_EXT_VER"] = "1";</script>


<script type="text/javascript" src="/bazar/js/jquery/jquery-ui.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.cycle2.carousel.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.cycle2.carousel.min.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.dcjqaccordion.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.easing-1.3.min.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.jcarousel.min.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.nivo.slider.pack.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.mockjax.js"></script>
<script type="text/javascript" src="/bazar/js/cart.min.js"></script>
<script type="text/javascript" src="/bazar/js/basic/productAdditionalView.js"></script>
<script type="text/javascript" src="/bazar/js/basic/cloud_zoom.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/profile.js"></script>
<script type="text/javascript" src="/bazar/js/jquery/jquery.validate.min.js"></script>

<link rel="stylesheet" id="colorpicker-css" href="/bazar/css/mystyle.css" type="text/css" media="all">

<style type="text/css">
	a.button{
		color:#FFFFFF;
		background-color:#333333;
	}
	a.button:hover{
		color:#FFFFFF;
	}
</style>

<style type="text/css">
	#product-id {
		width:auto; 
		height:auto; 
		max-width:150px !important; 
		max-height:150px !important; 
		margin-left: auto; 
		margin-right: auto;
	}
</style>

<script type="text/javascript" src="/bazar/js/woocommerce.js"></script>
<script type="text/javascript" src="/bazar/js/woocommerce.min.js"></script>
<script type="text/javascript" src="/bazar/js/add-to-cart.min.js"></script>
</head>
