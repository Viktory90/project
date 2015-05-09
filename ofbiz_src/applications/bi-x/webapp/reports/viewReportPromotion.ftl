<script type="text/javascript" src="/highcharts/assets/js/highcharts.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-3d.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/highcharts-more.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/exporting.js"></script>
<script type="text/javascript" src="/highcharts/assets/js/drilldown.js"></script>
<script type="text/javascript"  src="/aceadmin/jqw/jqwidgets/jqxprogressbar.js"></script>
<@jqGridMinimumLib/>
<#function max value1 value2>
    <#if (value1 > value2)>
        <#return value1>
    <#else>
        <#return value2>
    </#if>
</#function>
<#if security.hasPermission("DELYS_PROMOS_APPROVE", session)>
    <#assign hasApproved = true>
<#else>
    <#assign hasApproved = false>
</#if>
<#assign currentStatusId = productPromo[0].productPromoStatusId?if_exists>
<div class="widget-body">
    <div class="widget-main">
        <div class="row-fluid">
            <div class="form-horizontal basic-custom-form form-decrease-padding" id="updateQuotation" name="updateQuotation" style="display: block;">
                <div class="row margin_left_10 row-desc">
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysPromoProductPromoId}:</label>
                            <div class="controls-desc">
                                <b>${productPromo[0].productPromoId?if_exists}</b>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysPromoPromotionName}:</label>
                            <div class="controls-desc">
                            ${productPromo[0].promoName?if_exists}
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysPromotionType}:</label>
                            <div class="controls-desc">
                                 ${productPromo[0].descriptionOfPromoTypeId?if_exists}
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysProductPromoStatusId}:</label>
                            <div class="controls-desc">
                            <#if currentStatusId?exists && currentStatusId?has_content>
									<#assign currentStatus = delegator.findOne("StatusItem", {"statusId" : currentStatusId}, true)>
									<#if currentStatus.statusCode?has_content>${currentStatus.get("description",locale)}</#if>
				                </#if>
                            </div>
                        </div>

                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.PromotionContentDelys}:</label>
                            <div class="controls-desc">
                             ${productPromo.promoText?if_exists}
                            </div>
                        </div>
                    </div>
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DAFromDate}:</label>
                            <div class="controls-desc">
                            <#if productPromo[0].fromDateValue?exists>${productPromo[0].fromDateValue?string("dd/MM/yyyy")}<#else>___</#if>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DAThroughDate}:</label>
                            <div class="controls-desc">
                            <#if productPromo[0].thruDateValue?exists>${productPromo[0].thruDateValue?string("dd/MM/yyyy")}<#else>___</#if>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysRoleTypeApply}:</label>
                            <div class="controls-desc">
                                <ul class="unstyled spaced2" style="margin: 0 0 0 15px;">
                                <#list promoRoleTypeApply as itemRoleTypeAppl>
                                    <li style="margin-bottom: 0; margin-top:0">
                                        <i class="icon-user green"></i>
                                        <#if itemRoleTypeAppl.description?exists>${itemRoleTypeAppl.description}<#else>${itemRoleTypeAppl.roleTypeId}</#if>
                                    </li>
                                </#list>
                                </ul>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysBudgetTotal}:</label>
                            <div class="controls-desc">
                               <#if productPromo[0].promoBugetDistributor?exists>
                                    <@ofbizCurrency amount=productPromo[0].promoBugetDistributor isoCode='VND'/>
                                    <#else>
                                      ${uiLabelMap.DANotData}
                               </#if>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysMiniRevenue}:</label>
                            <div class="controls-desc">
                                    <#if productPromo[0].promoMiniRevenue?exists>
                                         <@ofbizCurrency amount=productPromo[0].promoMiniRevenue isoCode='VND'/>
                                    <#else>
                                    ${uiLabelMap.DANotData}
                                    </#if>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysSalesTargets}:</label>
                            <div class="controls-desc">
                            <#if productPromo[0].promoSalesTargets?exists>
                                    <@ofbizCurrency amount=productPromo[0].promoSalesTargets isoCode='VND'/>
                                 <#else>
                                     ${uiLabelMap.DANotData}
                            </#if>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysPaymentMethod}:</label>
                            <div class="controls-desc">
                                ${productPromo[0].paymentMethod?if_exists}
                            </div>
                        </div>
                    </div><!--.span6-->
                </div><!--.row-->
            </div>

            <div style="clear:both"></div>
            <hr/>
            <div style="text-align:right">
                <h5 class="lighter block green" style="float:left"><b>${uiLabelMap.DelysPromoRuleListInPromos}</b></h5>

            </div>
            <div style="clear:both"></div>

            <div id="list-product-price-rules">
            <#if productPromoRules?exists && productPromoRules?has_content>
                <table cellspacing="0" cellpadding="1" border="0" class="table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th rowspan="2">${uiLabelMap.DelysSequenceOrder}</th>
                        <th rowspan="2">${uiLabelMap.DelysRuleName}</th>
                        <th colspan="2" class="align-center">${uiLabelMap.DelysConditon}</th>
                        <th colspan="2" class="align-center">${uiLabelMap.DelysPromoAction}</th>
                    <#--<th rowspan="2">&nbsp;</th>-->
                    </tr>
                    <tr>
                    <#--<th>${uiLabelMap.DelysSequenceOrder}</th>-->
                        <th>${uiLabelMap.DelysPromoCategoryProductApply}</th>
                        <th>${uiLabelMap.DelysPromoCondition} </th>
                    <#--<th>${uiLabelMap.DelysSequenceOrder}</th>-->
                        <th>${uiLabelMap.DelysPromoCategoryProductApply}</th>
                        <th>${uiLabelMap.DelysPromoAction}</th>
                    </tr>
                    </thead>
                    <tbody>
                        <#list productPromoRules as rule>
                            <#assign productPromoConds = rule.getRelated("ProductPromoCond", null, null, false)>
                            <#assign productPromoActions = rule.getRelated("ProductPromoAction", null, null, false)>
                            <#assign maxCondSeqId = 1>
                            <#if productPromoConds?has_content>
                                <#assign condSize = productPromoConds?size>
                            <#else>
                                <#assign condSize = 1>
                            </#if>
                            <#if productPromoActions?has_content>
                                <#assign actionSize = productPromoActions?size>
                                <#assign actionFist = productPromoActions?first>
                            <#else>
                                <#assign actionSize = 1>
                                <#assign actionFist = "">
                            </#if>
                            <#assign rowSpan = max(condSize, actionSize)>
                            <#if (condSize > 1) >
                                <#assign rowSpanCondFirst = 1>
                                <#assign rowSpanCondLast = (rowSpan - condSize + 1)>
                            <#else>
                                <#assign rowSpanCondFirst = (rowSpan - condSize + 1)>
                            </#if>
                            <#if (actionSize > 1)>
                                <#assign rowSpanActionFirst = 1>
                                <#assign rowSpanActionLast = (rowSpan - actionSize + 1)>
                            <#else>
                                <#assign rowSpanActionFirst = (rowSpan - actionSize + 1)>
                            </#if>

                            <#if condSize &gt; actionSize>
                                <#assign sizeBrowse = productPromoConds?size >
                            <#else>
                                <#assign sizeBrowse = productPromoActions?size >
                            </#if>
                            <#list 0..sizeBrowse as i>
                            <tr>
                                <#if i == 0>
                                    <td rowspan="${rowSpan}">${rule_index + 1}</td>
                                    <td rowspan="${rowSpan}">${rule.ruleName}</td>
                                </#if>

                                <#if (i &lt; productPromoConds?size) && (productPromoConds?size != 0)>
                                    <#assign productPromoCondListOne = productPromoConds[i..i] />
                                    <#assign productPromoCond = productPromoCondListOne?first />
                                    <td <#if  i == (productPromoConds?size - 1)>rowspan="${rowSpanCondLast?if_exists}" </#if><#if i != 0>style="border-top: 1px dashed #e7e7e7;"</#if>>
                                        <#assign condProductPromoCategories = productPromoCond.getRelated("ProductPromoCategory", null, null, false)>
                                        <#if condProductPromoCategories?has_content>
                                        <#--<span class="text-info display-block">${uiLabelMap.DelysPromoCategory}: </span>-->
                                            <#assign listCondCat = []>
                                            <#list condProductPromoCategories as condProductPromoCategory>
                                                <#assign condProductCategory = condProductPromoCategory.getRelatedOne("ProductCategory", true)>
                                                <#assign condApplEnumeration = condProductPromoCategory.getRelatedOne("ApplEnumeration", true)>
                                                <#assign listCondCat = listCondCat + [condProductCategory.productCategoryId] >
                                                <#assign includeSubCategoriesCond = condProductPromoCategory.includeSubCategories?default("N")>
                                                <div class="margin-top2">
                                                    <span class="text-success span-product-category">${uiLabelMap.DelysPromoC} </span>
                                                ${(condProductCategory.get("description",locale))?if_exists} [${condProductPromoCategory.productCategoryId}]
                                                </div>
                                            <#--- ${(condApplEnumeration.get("description",locale))?default(condProductPromoCategory.productPromoApplEnumId)}
                                            - ${uiLabelMap.DelysProductSubCats}: ${condProductPromoCategory.includeSubCategories?default("N")} -->
                                            </#list>
                                        <#--
                                         <#else>
                                            ${uiLabelMap.DelysProductNoConditionCategories}
                                        -->
                                        </#if>

                                        <#assign condProductPromoProducts = productPromoCond.getRelated("ProductPromoProduct", null, null, false)>
                                        <#if condProductPromoProducts?has_content>
                                        <#--<span class="text-info display-block">${uiLabelMap.DelysPromoProduct}: </span>-->
                                            <#assign productCondList = []>
                                            <#list condProductPromoProducts as condProductPromoProduct>
                                                <#assign condProduct = condProductPromoProduct.getRelatedOne("Product", true)?if_exists>
                                                <#assign condApplEnumeration = condProductPromoProduct.getRelatedOne("ApplEnumeration", true)>
                                                <#assign productCondList = productCondList + [condProduct.productId]>
                                                <div class="margin-top2">
                                                    <span class="text-success span-product-category">${uiLabelMap.DelysPromoP} </span>
                                                ${(condProduct.internalName)?if_exists} [${condProductPromoProduct.productId}]
                                                </div>
                                            <#-- - ${(condApplEnumeration.get("description",locale))?default(condProductPromoProduct.productPromoApplEnumId)} -->
                                            </#list>
                                        <#--
                                        <#else>
                                          ${uiLabelMap.DelysProductNoConditionProducts}
                                        -->
                                        </#if>
                                    </td>
                                    <td <#if  i == (productPromoConds?size - 1)>rowspan="${rowSpanCondLast?if_exists}" </#if>style="border-left: 1px dashed #e7e7e7;<#if i != 0> border-top: 1px dashed #e7e7e7;</#if>">
                                        <#if (productPromoCond.inputParamEnumId)?exists>
                                            <#assign inputParamEnum = productPromoCond.getRelatedOne("InputParamEnumeration", true)>
                                            <#if inputParamEnum?exists>
                                            ${(inputParamEnum.get("description",locale))?if_exists}
                                            <#else>
                                                [${(productPromoCond.inputParamEnumId)?if_exists}]
                                            </#if>
                                        </#if>
                                        &nbsp;
                                        <#if (productPromoCond.operatorEnumId)?exists>
                                            <#assign operatorEnum = productPromoCond.getRelatedOne("OperatorEnumeration", true)>
                                            <#if operatorEnum?exists>
                                            ${(operatorEnum.get("description",locale))?if_exists}
                                            <#else>
                                                [${(productPromoCond.operatorEnumId)?if_exists}]
                                            </#if>
                                        </#if>
                                        &nbsp;
                                    ${(productPromoCond.condValue)?if_exists}
                                        <#if productPromo[0].productPromoTypeId == "EXHIBITED">
                                            <br/>
                                        ${uiLabelMap.DelysExhibitedAt}: ${productPromoCond.condExhibited?if_exists} ${productPromoCond.notes?if_exists}
                                        </#if>
                                    </td>
                                <#elseif productPromoConds?size == 0>
                                    <td colspan="2" rowspan="${rowSpan}">${uiLabelMap.NoConditionApplyForRule}</td>
                                </#if>

                                <#if (i &lt; productPromoActions?size) && (productPromoActions?size != 0)>
                                    <#assign productPromoActionListOne = productPromoActions[i..i] />
                                    <#assign productPromoAction = productPromoActionListOne?first />
                                    <td <#if i == (productPromoActions?size - 1)>rowspan="${rowSpanActionLast?if_exists}" </#if><#if i != 0>style="border-top: 1px dashed #e7e7e7;"</#if>>
                                        <#assign actionProductPromoCategories = productPromoAction.getRelated("ProductPromoCategory", null, null, false)>
                                        <#if actionProductPromoCategories?has_content>
                                        <#--<span class="text-info display-block">${uiLabelMap.DelysPromoCategory}: </span>-->
                                            <#list actionProductPromoCategories as actionProductPromoCategory>
                                                <#assign actionProductCategory = actionProductPromoCategory.getRelatedOne("ProductCategory", true)>
                                                <#assign actionApplEnumeration = actionProductPromoCategory.getRelatedOne("ApplEnumeration", true)>
                                                <div class="margin-top2">
                                                    <span class="text-success span-product-category">${uiLabelMap.DelysPromoC} </span>
                                                ${(actionProductCategory.description)?if_exists} [${actionProductPromoCategory.productCategoryId}]
                                                </div>
                                            <#--- ${(actionApplEnumeration.get("description",locale))?default(actionProductPromoCategory.productPromoApplEnumId)}
                                            - ${uiLabelMap.ProductSubCats}? ${actionProductPromoCategory.includeSubCategories?default("N")} -->
                                            <#--- ${uiLabelMap.CommonAnd} ${uiLabelMap.CommonGroup}: ${actionProductPromoCategory.andGroupId}-->
                                            </#list>
                                        </#if>

                                        <#assign actionProductPromoProducts = productPromoAction.getRelated("ProductPromoProduct", null, null, false)>
                                        <#if actionProductPromoProducts?has_content>
                                        <#--<span class="text-info display-block">${uiLabelMap.DelysPromoProduct}: </span>-->
                                            <#assign productActList = []>
                                            <#list actionProductPromoProducts as actionProductPromoProduct>
                                                <#assign actionProduct = actionProductPromoProduct.getRelatedOne("Product", true)?if_exists>
                                                <#assign actionApplEnumeration = actionProductPromoProduct.getRelatedOne("ApplEnumeration", true)>
                                                <#assign productActList = productActList + [actionProduct.productId]>
                                                <div class="margin-top2">
                                                    <span class="text-success span-product-category">${uiLabelMap.DelysPromoP} </span>
                                                ${(actionProduct.internalName)?if_exists} [${actionProductPromoProduct.productId}]
                                                </div>
                                            <#-- - ${(actionApplEnumeration.get("description",locale))?default(actionProductPromoProduct.productPromoApplEnumId)} -->
                                            </#list>
                                        </#if>
                                    </td>
                                    <td <#if i == (productPromoActions?size - 1)>rowspan="${rowSpanActionLast?if_exists}" </#if>style="border-left: 1px dashed #e7e7e7;<#if i != 0> border-top: 1px dashed #e7e7e7;</#if>" nowrap>
                                        <#if (productPromoAction.productPromoActionEnumId)?exists>
                                            <#assign productPromoActionCurEnum = productPromoAction.getRelatedOne("ActionEnumeration", true)!>
                                            <#if productPromoActionCurEnum?exists>
                                            ${(productPromoActionCurEnum.get("description",locale))?if_exists}
                                            <#else>
                                                [${(productPromoAction.productPromoActionEnumId)?if_exists}]
                                            </#if>
                                        </#if>
                                        &nbsp;
                                        <input type="hidden" name="orderAdjustmentTypeId" value="${(productPromoAction.orderAdjustmentTypeId)?if_exists}" />
                                        <ul class="unstyled no-bottom-margin">
                                            <#if actionFist.quantity?exists>
                                                <li><i class="icon-angle-right"></i>${uiLabelMap.DelysQuantity}: ${actionFist.quantity}</li>
                                            </#if>
                                            <#if actionFist.amount?exists>
                                                <li><i class="icon-angle-right"></i>${uiLabelMap.DelysAmount}: ${actionFist.amount}</li>
                                            </#if>
                                            <#if actionFist.productId?exists>
                                                <li><i class="icon-angle-right"></i>${uiLabelMap.DelysProductId}: ${actionFist.productId}</li>
                                            </#if>
                                            <#if actionFist.partyId?exists>
                                                <li><i class="icon-angle-right"></i>${uiLabelMap.DelysPartyId}: ${actionFist.partyId}</li>
                                            </#if>
                                        </ul>
                                    </td>
                                <#elseif productPromoActions?size == 0>
                                    <td colspan="2" rowspan="${rowSpan}">${uiLabelMap.NoActionApplyForRule}</td>
                                </#if>
                            </tr>
                            </#list>

                        <#--asdsadasdsa2-->
                        </#list>
                    </tbody>
                </table>
            <#else>
                <div class="alert alert-info">${uiLabelMap.DANoRuleInPromotionToDisplay}</div>
            </#if>
            </div>



    <div style="clear:both"></div>
    <hr/>
    <div style="text-align:right">
        <h5 class="lighter block green" style="float:left"><b>Trang thai chuong trinh</b></h5>
    </div>
    <div style="clear:both"></div>
            <div class="form-horizontal basic-custom-form form-decrease-padding" id="updateQuotation" name="updateQuotation" style="display: block;">
                <div class="row margin_left_10 row-desc">
                    <div class="span6">
                        <div class="control-group">
                            <label class="control-label-desc">${uiLabelMap.DelysProductPromoStatusId}:</label>
                            <div class="controls-desc">
                                <#if productPromo[0]?exists>
                                    <#if productPromo[0].thruDateValue?exists>
                                        <#if nowTimestamp.getTime() gte productPromo[0].thruDateValue.getTime() >
                                            <div style="color: red">Chương trình đã kết thúc</div>
                                        <#else>
                                            <div style="color: #008000">Chương trình đang trong thời gian diễn ra</div>
                                        </#if>
                                    </#if>

                                </#if>

                             </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label-desc">Ngân sách đã sử dụng:</label>
                            <div class="controls-desc">
                                <div style='overflow: hidden;' id='budget_total'>
                                </div>
                             </div>

                        </div>

                        </div>
                        <div class="span6">
                            <div class="control-group">
                                <label class="control-label-desc">Doanh số tối thiểu:</label>
                                <div class="controls-desc">
                                    <div style='overflow: hidden;' id='mini_budget'>
                                    </div>
                                </div>

                            </div>

                            <div class="control-group">
                                <label class="control-label-desc"> Mục tiêu doanh số:</label>
                                <div class="controls-desc">
                                    <div style='overflow: hidden;' id='target_budget'>
                                    </div>
                                </div>

                            </div>

                        </div>
                     </div>
                </div>
                <div style="clear:both"></div>
                <hr/>
                <div style="text-align:right">
                    <h5 class="lighter block green" style="float:left"><b>${uiLabelMap.OlapReportSalesOrder}</b></h5>
                </div>
                <div style="clear:both"></div>
                <div class="row-fluid">
                    <div class="span6">
                        <div id="container"></div>
                    </div>
                    <div class="span6">
                        <div id="piecontainer"></div>
                    </div>
                    <div class="span12 no-left-margin">

                        <div id="columnLineChart"></div>
                    </div>

                </div>
             </div>
    </div>
</div>
<script type="text/javascript">
    var budgetDistributor= 0;
    var miniBudget=0;
    var targetBudget=0;
    var subtitle="olbius";
    var promotionCode="";
    <#if productPromo[0]?exists>
        <#if productPromo[0].promoBugetDistributor?exists>
             budgetDistributor=parseFloat("${productPromo[0].promoBugetDistributor?if_exists}");
        </#if>
        <#if  productPromo[0].promoMiniRevenue?exists>
          miniBudget=parseFloat("${productPromo[0].promoMiniRevenue?if_exists}");
        </#if>
        <#if productPromo[0].promoSalesTargets?exists>
             targetBudget=parseFloat("${productPromo[0].promoSalesTargets?if_exists}");
        </#if>
        <#if productPromo[0].descriptionOfPromoTypeId?exists>
             subtitle="${StringUtil.wrapString(productPromo[0].descriptionOfPromoTypeId?if_exists)}";
        </#if>

        <#if productPromo[0].productPromoId?exists>
            promotionCode="${StringUtil.wrapString(productPromo[0].productPromoId?if_exists)}";
        </#if>
    </#if>
    var data=[];
    if(promotionCode){
        data= getAvaiableBudgetPromotion(promotionCode);
    }
    console.log(data);
    var prototal=0;
    var extNetAmount=0;
    var extNetpercent=0;
    var tarpercent=0;
    extNetAmount=data.extNetAmount;
    var extPromotionAmountdata=data.extPromotionAmount;

    if(budgetDistributor >0){
        if(extPromotionAmountdata){
            prototal=-parseFloat(extPromotionAmountdata)/budgetDistributor*100;
        }
    }
    if(miniBudget>0){
        if(extNetAmount){
            extNetpercent=extNetAmount/miniBudget*100;
        }
    }

    if(targetBudget>0){
        if(extNetAmount){
            tarpercent=extNetAmount/targetBudget*100;
        }
    }

    if(tarpercent>100){
        var value= formatcurrency(extNetAmount,'VND')
        $("#target_budget").empty();
        $("#target_budget").append("<span style='color: #008000'>"+ value+"(Đã vượt chỉ tiêu)"+"</span>")
    }else{
        $("#target_budget").jqxProgressBar({
            value: tarpercent,
            width: 200,
            height: 20,
            theme: 'energyblue',
            showText: true
        });
    }

    if(prototal>100){
        var value= formatcurrency(-extPromotionAmountdata,'VND')
        $("#budget_total").empty();
        $("#budget_total").append("<span style='color: red'>"+ value+"(Đã vượt quá hạn mức)"+"</span>")
    }else{
        $("#budget_total").empty();
        $("#budget_total").jqxProgressBar({
            value: prototal,
            width: 200,
            height: 20,
            theme: 'energyblue',
            showText: true
        });
    }


    $("#mini_budget").jqxProgressBar({
        value: extNetpercent,
        width: 200,
        height: 20,
        theme: 'energyblue',
        showText: true
    });


    console.log(extPromotionAmountdata);
    $(function () {
        $('#container').highcharts({
            chart: {
                type: 'column'
            },
            colors: ['#90ed7d', '#f7a35c', '#8085e9',
                '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],
            title: {
                text: "${StringUtil.wrapString(uiLabelMap.OlapBudgetAndSales)}"
            },
            subtitle: {
                text: subtitle
            },
            xAxis: {
                categories: [
                    'PromotionId: '+promotionCode
                ]
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'VNĐ'
                }
            },
            tooltip: {
                valueSuffix: ' VNĐ'
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0,
                    dataLabels: {
                        enabled: true
                    }

                }
            },
            series: [{
                name: '${StringUtil.wrapString(uiLabelMap.DelysBudgetTotal)}',
                data: [budgetDistributor]

            }, {
                name: '${StringUtil.wrapString(uiLabelMap.DelysMiniRevenue)}',
                data: [miniBudget]

            }, {
                name: '${StringUtil.wrapString(uiLabelMap.DelysSalesTargets)}',
                data: [targetBudget]

            }]
        });
    });
    $('#piecontainer').highcharts({
        title: {
            text: 'Doanh số sản phẩm đã bán'
        },
        xAxis: {
            tickWidth:10,
            categories: ['PromotionId: '+promotionCode]
        },
        colors: ['#f7a35c', '#8085e9',
            '#f15c80', '#e4d354', '#2b908f', '#f45b5b', '#91e8e1'],
        labels: {
            items: [{
                html: 'Tỉ lệ',
                style: {
                    left: '50px',
                    top: '18px',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                }
            }]
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0,
                dataLabels: {
                    enabled: true
                },
                pointWidth:40,
                tooltip: {
                    valueSuffix: ' VNĐ'
                }

            },
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                    enabled: false,
                    format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                }
            }
        },
        series: data.chartpie
    });


    $('#columnLineChart').highcharts({
        title: {
            text: 'Doanh số sản phẩm áp dụng tại các đối tượng khuyến mại '+data.year
        },
        xAxis: {
            categories: [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
            ]
        },
        labels: {
            items: [{
                html: '(Note: Doanh số được tính theo giá cuối cùng)',
                style: {
                    left: '50px',
                    top: '18px',
                    color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
                }
            }]
        },
        series: data.dataColumLine
    });
    function getAvaiableBudgetPromotion(promotionCode){
        var jsc="";
        $.ajax({
            url: '<@ofbizUrl>getAvaiableBudgetPromotion</@ofbizUrl>',
            type: 'POST',
            dataType: 'json',
            data:{promotionCode:promotionCode},
            async:false,
            success:function(data){
                jsc=data;
            }
        });
        return jsc;
    }

    function formatcurrency(num, uom){
        decimalseparator = ",";
        thousandsseparator = ".";
        currencysymbol = "đ";
        if(typeof(uom) == "undefined" || uom == null){
            uom = "${currencyUomId?if_exists}";
        }
        if(uom == "USD"){
            currencysymbol = "$";
            decimalseparator = ".";
            thousandsseparator = ",";
        }else if(uom == "EUR"){
            currencysymbol = "€";
            decimalseparator = ".";
            thousandsseparator = ",";
        }
        var str = num.toString().replace(currencysymbol, ""), parts = false, output = [], i = 1, formatted = null;
        if(str.indexOf(".") > 0) {
            parts = str.split(".");
            str = parts[0];
        }
        str = str.split("").reverse();
        for(var j = 0, len = str.length; j < len; j++) {
            if(str[j] != ",") {
                output.push(str[j]);
                if(i%3 == 0 && j < (len - 1)) {
                    output.push(thousandsseparator);
                }
                i++;
            }
        }
        formatted = output.reverse().join("");
        return(formatted + ((parts) ? decimalseparator + parts[1].substr(0, 2) : "") + "&nbsp;" + currencysymbol);
    };
</script>




<script type="text/javascript" src="/delys/images/js/bootbox.min.js">
</script>
<script type="text/javascript">
    function acceptProductPromo() {
        bootbox.confirm("${uiLabelMap.DAAreYouSureAccept}", function(result) {
            if(result) {
                document.PromoAccept.submit();
            }
        });
    }
    function cancelProductPromo() {
        bootbox.confirm("${uiLabelMap.DAAreYouSureCancelNotAccept}", function(result) {
            if(result) {
                document.PromoCancel.submit();
            }
        });
    }
    function updatePromoThruDate2() {
        if(!$('#updatePromoThruDate').valid()) {
            return false;
        } else {
            bootbox.confirm("${uiLabelMap.DAAreYouSureWantCreateThruDate}", function(result){
                if(result){
                    document.getElementById("updatePromoThruDate").submit();
                }
            });
        }
    }
    function enterCancelPromo() {
        bootbox.prompt("${uiLabelMap.DelysPromoReasonCancelPromo}:", function(result) {
            if(result === null) {
            } else {
                document.getElementById('changeReason').value = "" + result;
                document.PromoCancel.submit();
            }
        });
    }
    $(function() {
        $('#updatePromoThruDate').validate({
            errorElement: 'span',
            errorClass: 'help-inline',
            focusInvalid: false,
            rules: {
                thruDate: {
                    required: true
                }
            },

            messages: {
                thruDate: {
                    required: "${uiLabelMap.DAThisFieldIsRequired}"
                }
            },

            invalidHandler: function (event, validator) { //display error alert on form submit
                $('.alert-error', $('.login-form')).show();
            },

            highlight: function (e) {
                $(e).closest('.control-group').removeClass('info').addClass('error');
            },

            success: function (e) {
                $(e).closest('.control-group').removeClass('error').addClass('info');
                $(e).remove();
            },

            errorPlacement: function (error, element) {
                if(element.is(':checkbox') || element.is(':radio')) {
                    var controls = element.closest('.controls');
                    if(controls.find(':checkbox,:radio').length > 1) controls.append(error);
                    else error.insertAfter(element.nextAll('.lbl').eq(0));
                }
                else if(element.is('.chzn-select')) {
                    error.insertAfter(element.nextAll('[class*="chzn-container"]').eq(0));
                }
                else error.insertAfter(element);
            },
            submitHandler: function (form) {
                if(!$('#updatePromoThruDate').valid()) return false;
            },
            invalidHandler: function (form) {
            }
        });
    });
</script>
