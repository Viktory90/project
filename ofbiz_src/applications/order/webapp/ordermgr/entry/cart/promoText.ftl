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
<#if showPromoText?exists && showPromoText>
<div class="widget-box olbius-extra">
    <div class="widget-header widget-header-small header-color-blue2">
        <h6>${uiLabelMap.OrderSpecialOffers}</h6>
        <div class="widget-toolbar">
        	<a href="#" data-action="collapse"><i class="icon-chevron-up"></i></a>
        </div>
    </div>
<div class="widget-body">
    <div class="widget-body-inner">
   		<div class="widget-main">
        	<table cellspacing="0" cellpadding="1" border="0" style="width: 100% !important">
          	<#-- show promotions text -->
          	<#list productPromos as productPromo>
	            <tr>
    	          <td>
        	        <div><a href="<@ofbizUrl>showPromotionDetails?productPromoId=${productPromo.productPromoId}</@ofbizUrl>" class="btn btn-mini btn-info">${uiLabelMap.CommonDetails}</a> ${StringUtil.wrapString(productPromo.promoText?if_exists)}</div>
            	  </td>
            	</tr>
            	<#if productPromo_has_next>
              	<tr style="width: 100% !important"><td style="width: 100% !important"><hr /></td></tr>
            	</#if>
          	</#list>
          	<tr style="width: 100% !important"><td><hr /></td></tr>
          	<tr>
	            <td>
             	<div><a href="<@ofbizUrl>showAllPromotions</@ofbizUrl>" class="btn btn-primary btn-small">${uiLabelMap.OrderViewAllPromotions}</a></div>
            	</td>
          	</tr>
        	</table>
    	</div>
    </div>
</div></div>
</#if>
