import org.ofbiz.base.util.UtilMisc;

productPromoId = parameters.productPromoId;
if (productPromoId) {
	context.productPromoId = productPromoId;
	productPromo = delegator.findOne("ProductPromo", UtilMisc.toMap("productPromoId", productPromoId), false);
	context.productPromo = productPromo;
	context.productStorePromoAppl = delegator.findByAnd("ProductStorePromoAppl", UtilMisc.toMap("productPromoId", productPromoId), null, false);
	context.promoRoleTypeApply = delegator.findByAnd("ProductPromoRoleTypeApply", UtilMisc.toMap("productPromoId", productPromoId), null, false);
	if(productPromo && (productPromo.productPromoTypeId == "EXHIBITED" || productPromo.productPromoTypeId == "PROMOTION")){
		promoBudgetDist = delegator.findByAnd("ProductPromoBudget", UtilMisc.toMap("productPromoId", productPromoId, "budgetTypeId", "PROMO_BUDGET_DIS"), null, false);
		promoMiniRevenue = delegator.findByAnd("ProductPromoBudget", UtilMisc.toMap("productPromoId", productPromoId, "budgetTypeId", "PROMO_MINI_REVENUE"), null, false);
		if(promoBudgetDist){
			context.promoBudgetDist = promoBudgetDist[0];
		}else{
			context.promoBudgetDist = delegator.makeValue("ProductPromoBudget");
		}
		if(promoMiniRevenue){
			context.promoMiniRevenue = promoMiniRevenue[0];
		}else{
			context.promoMiniRevenue = delegator.makeValue("ProductPromoBudget");
		}
	}
}