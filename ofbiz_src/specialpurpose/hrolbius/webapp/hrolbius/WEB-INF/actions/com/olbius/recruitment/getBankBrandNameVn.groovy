import org.ofbiz.base.util.UtilMisc;

import com.olbius.util.PartyUtil;

List<GenericValue> currBankBrandId = delegator.findByAnd("BankBrandVn",UtilMisc.toMap("bankId",parameters.bankId),null,false) ;
context.currBankBrandId = currBankBrandId;