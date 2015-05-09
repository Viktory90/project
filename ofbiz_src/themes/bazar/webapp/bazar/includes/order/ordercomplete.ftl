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

<!-- START PRIMARY -->
<div id="primary" class= "sidebar -no">
  <div class="container group">
        <div class="row">
               <!-- START CONTENT -->
         <div id="content-page" class= "span12 content group">
              <div id="post-389" class= "post-389 page type-page status-publish hentry group instock">
                 <div class="woocommerce" >
                 <!-- START WOO -->

<h2>${uiLabelMap.EcommerceOrderConfirmation}</h2>
<#if !isDemoStore?exists || isDemoStore><p>${uiLabelMap.OrderDemoFrontNote}.</p></#if>
<#if orderHeader?has_content>
  ${screens.render("component://bazar/widget/OrderScreens.xml#orderheader")}
  ${screens.render("component://bazar/widget/OrderScreens.xml#orderitems")}
  <a href="<@ofbizUrl>main</@ofbizUrl>" class="button">${uiLabelMap.EcommerceContinueShopping}</a>
<#else>
  <h3>${uiLabelMap.OrderSpecifiedNotFound}.</h3>
</#if>

                              <!-- END WOO -->
                         </div>
                    </div>
               </div>
               <!-- END CONTENT -->
          </div>
     </div>
</div>
<!-- END PRIMARY -->

