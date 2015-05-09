import java.util.*;
import org.ofbiz.entity.util.EntityListIterator;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.accounting.invoice.InvoiceWorker;

totalToApply = 0.0;
totalValue = 0.0;
if (result){
	listIt = result.listIt;
	while ((invoiceItem = listIt.next()) != null){
		invoiceId = invoiceItem.getString("invoiceId")
		toApply = InvoiceWorker.getInvoiceNotApplied(delegator,invoiceId)*InvoiceWorker.getInvoiceCurrencyConversionRate(delegator,invoiceId);
		value = InvoiceWorker.getInvoiceTotal(delegator,invoiceId)*InvoiceWorker.getInvoiceCurrencyConversionRate(delegator,invoiceId);
		totalToApply += toApply;
		totalValue += value;
	}
	listIt.close();
}
context.totalToApply = totalToApply;
context.totalValue = totalValue;