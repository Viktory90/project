
		<!--begain footer-->
		<footer>
		<div class="footerOuter">
			<div class="container">
				<div class="row-fluid">

					<div class="span6">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.EcommerceUsefullLinks}</h3>
						</div>

						
						<div class="usefullLinks">
							<div class="row-fluid">
								<div class="span6">
									<ul class="unstyled">
										<li><a class="invarseColor" href="#"><i class="icon-caret-right"></i> ${uiLabelMap.CustomerSupport}</a></li>
										<li><a class="invarseColor" href="#"><i class="icon-caret-right"></i> ${uiLabelMap.DeliveryInformation}</a></li>
									</ul>
								</div>
								<div class="span6">
									<ul class="unstyled">
										<li><a class="invarseColor" href="#"><i class="icon-caret-right"></i> ${uiLabelMap.SiteMap}</a></li>
										<li><a class="invarseColor" href="<@ofbizUrl>policies</@ofbizUrl>"><i class="icon-caret-right"></i> ${uiLabelMap.PrivacyPolicies}</a></li>
									</ul>
								</div>
							</div>
						</div>

					</div><!--end span6-->

					<div class="span3">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.EcommerceContacts}</h3>
						</div>

						<div class="contactInfo">
							<ul class="unstyled">
								<li>
									<button class="btn btn-small">
										<i class="icon-volume-up"></i>
									</button>
									<#assign telecomNumber = parameters.companyContact.getTelNumber()>
									${uiLabelMap.CallUs}: <a class="invarseColor" href="#">
									${telecomNumber.countryCode?if_exists}
				                      <#if telecomNumber.areaCode?has_content>${telecomNumber.areaCode?default("000")}-</#if><#if telecomNumber.contactNumber?has_content>${telecomNumber.contactNumber?default("000-0000")}</#if>
									</a>
								</li>
								<li>
									<button class="btn btn-small">
										<i class="icon-envelope-alt"></i>
									</button>
									<a class="invarseColor" href="mailto:contact@olbius.com">${parameters.companyContact.getEmailAddress()}</a>
								</li>
								<li>
									<button class="btn btn-small">
										<i class="icon-map-marker"></i>
									</button>
									 <#assign postalAddress = parameters.companyContact.getPostalAddress()>
    								${postalAddress.address1?if_exists},&nbsp;<#if postalAddress.address2?has_content>,&nbsp;${postalAddress.address2}</#if>${postalAddress.city?if_exists},&nbsp;${postalAddress.postalCode?if_exists}
								    <#if postalAddress.countryGeoId?has_content>&nbsp;
								      <#assign country = postalAddress.getRelatedOne("CountryGeo", true)>
								      ${country.get("geoName", locale)?default(country.geoId)}
								    </#if>
								    
								</li>
							</ul>
						</div>

					</div><!--end span3-->

					<div class="span3">
						<div class="titleHeader clearfix">
							<h3>${uiLabelMap.EcommerceNewsletter}</h3>
						</div>

						<div class="newslatter">
							${screens.render("component://shopfine/widget/EmailContactListScreens.xml#signupforcontactlist")}
						</div>

					</div><!--end span3-->

				</div><!--end row-fluid-->

			</div><!--end container-->
		</div><!--end footerOuter-->

		<div class="container">
			<div class="row">
				<div class="span12">
					<!-- PayPal Logo --><a href="https://www.paypal.com/webapps/mpp/paypal-popup" title="How PayPal Works" onclick="javascript:window.open('https://www.paypal.com/webapps/mpp/paypal-popup','WIPaypal','toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, width=1060, height=700'); return false;"><img src="https://www.paypalobjects.com/webstatic/mktg/logo/AM_SbyPP_mc_vs_dc_ae.jpg" border="0" alt="PayPal Acceptance Mark" class="pull-right"></a><!-- PayPal Logo -->
					<p>Copyrights 2013 for olbius.com</p>
				</div>
			</div>
		</div>
		</footer>
		<!--end footer-->

	</div><!--end mainContainer-->


	<!-- Sidebar Widget
	================================================== -->
	<div class="switcher">
		<h3>Site Switcher</h3>
		<a class="Widget-toggle-link">+</a>

		<div class="switcher-content clearfix">
			<div class="layout-switch">
				<h4>Layout Style</h4>
				<div class="btn-group">
					<a id="wide-style" class="btn">Wide</a>
	  				<a id="boxed-style" class="btn">Boxed</a>
				</div>
			</div><!--end layout-switch-->

			<div class="color-switch clearfix">
				<h4>Color Style</h4>
				<a id="orange-color" class="color-switch-link">orange</a>
				<a id="blue-color" class="color-switch-link">blue</a>
				<a id="green-color" class="color-switch-link">green</a>
				<a id="brown-color" class="color-switch-link">brown</a>
				<a id="red-color" class="color-switch-link">red</a>
			</div><!--end color-switch-->

			<div class="pattern-switch">
				<h4>BG Pattern</h4>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/retina_wood.png</@ofbizContentUrl>);">retina_wood</a>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/bgnoise_lg.png</@ofbizContentUrl>);">bgnoise_lg</a>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/purty_wood.png</@ofbizContentUrl>);">purty_wood</a>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/irongrip.png</@ofbizContentUrl>);">irongrip</a>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/low_contrast_linen.png</@ofbizContentUrl>);">low_contrast_linen</a>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/tex2res5.png</@ofbizContentUrl>);">tex2res5</a>
				<a style="background:url(<@ofbizContentUrl>/shopfine/img/backgrounds/wood_pattern.png</@ofbizContentUrl>);">wood_pattern</a>
			</div><!--end pattern-switch-->

		</div><!--end switcher-content-->
	</div>
	<!-- End Sidebar Widget-->


	<!-- JS
	================================================== -->
	<script src="<@ofbizContentUrl>/shopfine/js/jquery-ui.min.js</@ofbizContentUrl>"></script>
	<!-- jQuery.Cookie -->
	<script src="<@ofbizContentUrl>/shopfine/js/jquery.cookie.js</@ofbizContentUrl>"></script>
	<!-- bootstrap -->
    <script src="<@ofbizContentUrl>/shopfine/js/bootstrap.min.js</@ofbizContentUrl>"></script>
    <!-- flexslider -->
    <script src="<@ofbizContentUrl>/shopfine/js/jquery.flexslider-min.js</@ofbizContentUrl>"></script>
    <!-- cycle2 -->
    <script src="<@ofbizContentUrl>/shopfine/js/jquery.cycle2.min.js</@ofbizContentUrl>"></script>
    <script src="<@ofbizContentUrl>/shopfine/js/jquery.cycle2.carousel.min.js</@ofbizContentUrl>"></script>
    <!-- tweets -->
    <script src="<@ofbizContentUrl>/shopfine/js/jquery.tweet.js</@ofbizContentUrl>"></script>
    <!-- fancybox -->
    <script src="<@ofbizContentUrl>/shopfine/js/fancybox/jquery.fancybox.js</@ofbizContentUrl>"></script>
    <!-- custom function-->
    <script src="<@ofbizContentUrl>/shopfine/js/custom.js</@ofbizContentUrl>"></script>