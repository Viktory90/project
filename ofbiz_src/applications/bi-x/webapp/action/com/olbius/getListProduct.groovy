import javolution.util.FastMap;

import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.GenericValue;



List<GenericValue> products= delegator.findList("ProductDimension", null, null,null,null, false);
Map<String, String> mapProduct= FastMap.newInstance()
for(GenericValue item:products){
	String productId= item.getString("productId");
	String productName= item.getString("productName");
	if(UtilValidate.isEmpty(productName)){
		productName=productId;
	}
	mapProduct.put(productId, productName);
}

println("dmm"+mapProduct);
context.mapProduct= mapProduct;