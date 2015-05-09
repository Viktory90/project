  <#-- <link rel="stylesheet" href="/bazar/css/chosen/docsupport/style.css"> -->
  <link rel="stylesheet" href="/bazar/css/chosen/docsupport/prism.css">
  <link rel="stylesheet" href="/bazar/css/chosen/chosen.css">
  <style type="text/css" media="all">
    /* fix rtl for demo */
    .chzn-rtl .chzn-drop { left: -9000px; }
  </style>











<div id="primary" class="sidebar-no">
	<div class="container group">
		<div class="row">
			<!-- START CONTENT -->
			<div id="content-page" class="span12 content group">
				<div id="post-390"
					class="post-390 page type-page status-publish hentry group instock">
					<div class="woocommerce">


						<p class="woocommerce_info">
							Have a coupon? <a href="#" class="showcoupon">Click here to
								enter your code</a>
						</p>

						<form class="checkout_coupon" method="post" style="display: none;">

							<p class="form-row form-row-first">
								<input type="text" name="coupon_code" class="input-text"
									placeholder="Coupon code" id="coupon_code" value="">
							</p>

							<p class="form-row form-row-last">
								<input type="submit" class="button" name="apply_coupon"
									value="Apply Coupon">
							</p>

							<div class="clear"></div>
						</form>
						<div id="checkout_multistep">

							<div id="multistep_resume">
								<div>
									<span class="checkout_progress"><img
										src="http://demo.yithemes.com/bazar/wp-content/themes/bazar/woocommerce/images/multistep_cart.png"
										alt="Checkout Progress"> Checkout Progress</span>
								</div>
								<div>
									<a href="#" data-step="1"
										class="user_logged_in multistep_section passed">Login</a>
								</div>
								<div>
									<a href="#" data-step="2" class="multistep_section current">Billing
										Address</a>
								</div>
								<div>
									<a href="#" data-step="3" class="multistep_section">Shipping
										Address</a>
								</div>
								<div>
									<a href="#" data-step="4" class="multistep_section">Payment
										Method</a>
								</div>
								<div>
									<a href="#" data-step="5" class="multistep_section">Order
										Review</a>
								</div>
							</div>

							<div class="clear"></div>

							<div class="row">
								<div id="multistep_progress"
									class="span12 progress progress-striped">
									<div class="bar" style="width: 50%;"></div>
								</div>
							</div>

							<div id="multistep_steps" class="row">

								<!-- step 1 -->
								<div class="multistep_step user_logged_in" id="multistep_step1"
									data-step="1"></div>


								<form name="checkout" method="post" class="checkout"
									action="http://demo.yithemes.com/bazar/checkout/">


									<!-- step 2 -->
									<div class="multistep_step span12 current" id="multistep_step2"
										data-step="2" style="display: block;">
										<div class="box_style">



											<h3>Billing Address</h3>




											<p class="form-row form-row-first validate-required"
												id="billing_first_name_field">
												<label for="billing_first_name" class="">
													First Name <abbr class="required" title="required">*</abbr>
												</label>
												
												<input type="text" class="input-text" name="billing_first_name" id="billing_first_name"
													placeholder="" value="${parameters.firstName?if_exists}">
											</p>

											<p class="form-row form-row-last validate-required"
												id="billing_last_name_field">
												<label for="billing_last_name" class="">Last Name <abbr
													class="required" title="required">*</abbr></label><input
													type="text" class="input-text" name="billing_last_name"
													id="billing_last_name" placeholder="" value="My">
											</p>
											<div class="clear"></div>

											<p class="form-row form-row-first" id="billing_company_field">
												<label for="billing_company" class="">Company Name</label><input
													type="text" class="input-text" name="billing_company"
													id="billing_company" placeholder="" value="ol123">
											</p>

											<p class="form-row form-row-last" id="billing_vat_field">
												<label for="billing_vat" class="">VAT/SSN</label><input
													type="text" class="input-text" name="billing_vat"
													id="billing_vat" placeholder="VAT or SSN" value="">
											</p>
											<div class="clear"></div>

											<p
												class="form-row form-row-first address-field validate-required"
												id="billing_address_1_field">
												<label for="billing_address_1" class="">Address <abbr
													class="required" title="required">*</abbr></label><input
													type="text" class="input-text" name="billing_address_1"
													id="billing_address_1" placeholder="Street address"
													value="Ha Noi">
											</p>

											<p class="form-row form-row-last address-field"
												id="billing_address_2_field" style="display: block;">
												<input type="text" class="input-text"
													name="billing_address_2" id="billing_address_2"
													placeholder="Apartment, suite, unit etc. (optional)"
													value="">
											</p>

											<p
												class="form-row form-row-last address-field validate-required"
												id="billing_city_field"
												data-o_class="form-row form-row-last address-field validate-required">
												<label for="billing_city" class="">Town / City <abbr
													class="required" title="required">*</abbr></label><input
													type="text" class="input-text" name="billing_city"
													id="billing_city" placeholder="Town / City" value="Ha Noi">
											</p>

											<p
												class="form-row form-row-first address-field update_totals_on_change validate-required woocommerce-validated"
												id="billing_country_field">
												<label for="billing_country" class="">
													Country 
													<abbr class="required" title="required">*</abbr>
												</label>
												<select name="billing_country" id="billing_country" 
												class="chzn-select" tabindex="1">
													<option>Select a country…</option>
													<option value="AX">Åland Islands</option>
													<option value="AF">Afghanistan</option>
													<option value="AL">Albania</option>
													<option value="DZ">Algeria</option>
													<option value="AD">Andorra</option>
													<option value="AO">Angola</option>
													<option value="AI">Anguilla</option>
													<option value="AQ">Antarctica</option>
													<option value="AG">Antigua and Barbuda</option>
												</select>
											
											<noscript>&lt;input type="submit"
												name="woocommerce_checkout_update_totals" value="Update
												country" /&gt;</noscript>
											</p>

											<p class="form-row form-row-first address-field"
												id="billing_state_field" style=""
												data-o_class="form-row form-row-first address-field">
												<label for="billing_state" class="">
													State 
													<abbr class="required" title="required">*</abbr>
												</label>
												
												<select name="billing_state" id="billing_state"
													class="chzn-select" placeholder="State / County" tabindex="2">
													<option value="">Choose a Country...</option>
													<option value="AL">Alabama</option>
													<option value="AK">Alaska</option>
													<option value="AZ">Arizona</option>
													<option value="AR">Arkansas</option>
													<option value="CA">California</option>
													<option value="CO">Colorado</option>
													<option value="CT">Connecticut</option>
													<option value="DE">Delaware</option>
													<option value="DC">District Of Columbia</option>
													<option value="FL">Florida</option>
													</select>
											
											</div>
											</p>
											<p class="form-row form-row-last address-field"
												id="billing_postcode_field" style="display: block;"
												data-o_class="form-row form-row-last address-field">
												<label for="billing_postcode" class="">Zip <abbr
													class="required" title="required">*</abbr></label><input
													type="text" class="input-text" name="billing_postcode"
													id="billing_postcode" placeholder="Postcode / Zip"
													value="10000">
											</p>

											<div class="clear"></div>

											<p
												class="form-row form-row-first validate-required validate-email"
												id="billing_email_field">
												<label for="billing_email" class="">Email Address <abbr
													class="required" title="required">*</abbr></label><input
													type="text" class="input-text" name="billing_email"
													id="billing_email" placeholder=""
													value="mytester1991@gmail.com">
											</p>

											<p class="form-row form-row-last validate-required"
												id="billing_phone_field">
												<label for="billing_phone" class="">Phone <abbr
													class="required" title="required">*</abbr></label><input
													type="text" class="input-text" name="billing_phone"
													id="billing_phone" placeholder="" value="0431234567">
											</p>
											<div class="clear"></div>




											<p class="form-row" id="shiptobilling_bill">
												<input id="shiptobilling_bill-checkbox"
													class="input-checkbox" checked="checked" type="checkbox"
													name="shiptobilling" value="1"> <label
													for="shiptobilling_bill-checkbox" class="checkbox">Ship
													to billing address?</label>
											</p>


											<input type="submit" class="button next" name="login"
												value="Payment Method ->" data-next="4"
												data-alternativelabel="Shipping Method ->">

											<div class="clear"></div>
										</div>
									</div>


									<!-- step 3 -->

									<!-- step 4 -->

									<!-- step 5 -->
									
								</form>
							</div>


						</div>



						<script type="text/javascript" charset="utf-8">
							jQuery(document).ready(function() {
								jQuery('#checkout_multistep').yit_checkout();
							});
						</script>
					</div>
				</div>
				<!-- START COMMENTS -->
				<div id="comments"></div>
				<!-- END COMMENTS -->
			</div>
			<!-- END CONTENT -->



			<!-- START EXTRA CONTENT -->
			<!-- END EXTRA CONTENT -->
		</div>
	</div>
</div>


























<#--
<script type="text/javascript">
var second= $.noConflict(true);
</script>
<script src="/bazar/js/chosen/jquery.min.js" type="text/javascript"></script>

 -->


  <script src="/bazar/js/chosen/chosen.jquery.js" type="text/javascript"></script>
  <script src="/bazar/js/chosen/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
  <script type="text/javascript">
    var config = {
      '.chzn-select'           : {},
      '.chzn-select-deselect'  : {allow_single_deselect:true},
      '.chzn-select-no-single' : {disable_search_threshold:10},
      '.chzn-select-no-results': {no_results_text:'Oops, nothing found!'},
      '.chzn-select-width'     : {width:"95%"}
    }
    for (var selector in config) {
      $(selector).chosen(config[selector]);
    }
  </script>