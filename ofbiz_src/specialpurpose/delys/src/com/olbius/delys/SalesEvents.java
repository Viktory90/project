package com.olbius.delys;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javolution.util.FastMap;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilDateTime;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ServiceUtil;

public class SalesEvents {
	
	public static String module = SalesEvents.class.getName();
    public static final String resource = "DelysAdminUiLabels";
    public static final String resource_error = "DelysAdminErrorUiLabels";
    
    public static final String MULTI_ROW_DELIMITER = "_";
    /*private static final String NO_ERROR = "noerror";
    private static final String NON_CRITICAL_ERROR = "noncritical";
    private static final String ERROR = "error";*/
	
	public static String createUpdateSalesForecastAdvance(HttpServletRequest request, HttpServletResponse response) {
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        
        // Get the parameters as a MAP, remove the productId and quantity params.
        Map<String, Object> paramMap = UtilHttp.getParameterMap(request);

        String customTimePeriodId = null;
    	String tabCurrent = null;
    	
        Map<String, Object> colAndRow = getMultiFormRowCount(paramMap);
        @SuppressWarnings("unchecked")
		List<String> rowIds = (List<String>) colAndRow.get("rowIds");
        int colCount = (Integer) colAndRow.get("colCount");
        tabCurrent = (String) colAndRow.get("tabCurrent");
        String internalPartyId = null;
        String organizationPartyId = null;
        String currencyUomId = null;
        if (paramMap.containsKey("internalPartyId_" + tabCurrent)) {
        	internalPartyId = (String) paramMap.remove("internalPartyId_" + tabCurrent);
		}
        if (paramMap.containsKey("organizationPartyId_" + tabCurrent)) {
        	organizationPartyId = (String) paramMap.remove("organizationPartyId_" + tabCurrent);
		}
        if (paramMap.containsKey("currencyUomId_" + tabCurrent)) {
        	currencyUomId = (String) paramMap.remove("currencyUomId_" + tabCurrent);
		}
        
    	GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");
    	
        // The number of multi form rows is retrieved
        int rowCount = rowIds.size();
        if (rowCount < 1) {
            Debug.logWarning("No rows to process, as rowCount = " + rowCount, module);
        } else {
            for (int i = 0; i < rowCount; i++) {
            	if (paramMap.containsKey("customTimePeriodId_" + rowIds.get(i))) {
            		customTimePeriodId = (String) paramMap.remove("customTimePeriodId_" + rowIds.get(i));
        		}
            	for (int j = 0; j < colCount; j++) {
            		String salesForecastId = null;
                	String salesForecastDetailId = null;
                	String productId = null;
                	String quantityOldStr = null;
                	String quantityNewStr = null;
                	BigDecimal quantityOld = BigDecimal.ZERO;
                	BigDecimal quantityNew = BigDecimal.ZERO;
                	
            		String thisSuffix = "_" + rowIds.get(i) + "_" + j;
            		/*get //ayoSalesForecastId_ 
            		 *    //ayoSalesForecastDetailId_ 
            		 * ayoProductId_ 
            		 * salesForecastId_
            		 * salesForecastDetailId_
            		 * productId_
            		 * quantity_
            		 * forecastInput_
            		 * */
            		
            		if (paramMap.containsKey("salesForecastId" + thisSuffix)) {
            			salesForecastId = (String) paramMap.remove("salesForecastId" + thisSuffix);
            		}
            		if (paramMap.containsKey("salesForecastDetailId" + thisSuffix)) {
            			salesForecastDetailId = (String) paramMap.remove("salesForecastDetailId" + thisSuffix);
            		}
            		if (paramMap.containsKey("ayoProductId" + thisSuffix)) {
            			productId = (String) paramMap.remove("ayoProductId" + thisSuffix);
            		}
            		if (UtilValidate.isEmpty(productId)) {
            			if (paramMap.containsKey("productId" + thisSuffix)) {
                			productId = (String) paramMap.remove("productId" + thisSuffix);
                		}
            		}
            		if (paramMap.containsKey("quantity" + thisSuffix)) {
            			quantityOldStr = (String) paramMap.remove("quantity" + thisSuffix);
            		}
            		if ((quantityOldStr == null) || (quantityOldStr.equals(""))) {
            			quantityOldStr = "-1";
            		}
            		if (paramMap.containsKey("forecastInput" + thisSuffix)) {
            			quantityNewStr = (String) paramMap.remove("forecastInput" + thisSuffix);
            		}
            		if ((quantityNewStr == null) || (quantityNewStr.equals(""))) {
            			quantityNewStr = "-1";
            		}
            		try {
            			quantityOld = new BigDecimal(quantityOldStr);
                    } catch (Exception e) {
                        Debug.logWarning(e, "Problems parsing quantity string: " + quantityOldStr, module);
                        quantityOld = new BigDecimal("-1");
                    }
            		try {
                        quantityNew = new BigDecimal(quantityNewStr);
                    } catch (Exception e) {
                        Debug.logWarning(e, "Problems parsing quantity string: " + quantityNewStr, module);
                        quantityNew = new BigDecimal("-1");
                    }
            		
            		if ((quantityNew.compareTo(quantityOld) != 0) && (quantityNew.compareTo(BigDecimal.ZERO) >= 0) && UtilValidate.isNotEmpty(productId)) {
            			if (UtilValidate.isNotEmpty(salesForecastId)) {
            				if (UtilValidate.isNotEmpty(salesForecastDetailId)) {
                				// update sales forecast detail with id = (salesForecastId, salesForecastDetailId)
                				Map<String, Object> input = UtilMisc.toMap("userLogin", userLogin, "salesForecastId", salesForecastId, "salesForecastDetailId", salesForecastDetailId, "productId", productId, "quantity", quantityNew);
                                try {
                                    dispatcher.runSync("updateSalesForecastDetail", input);
                                } catch (GenericServiceException e) {
                                    Debug.logError(e, module);
                                    return "error";
                                }
                			} else {
                				// create new a sales forecast detail
                				Map<String, Object> input = UtilMisc.toMap("userLogin", userLogin, "salesForecastId", salesForecastId, "productId", productId, "quantity", quantityNew);
                                try {
                                    dispatcher.runSync("createSalesForecastDetail", input);
                                } catch (GenericServiceException e) {
                                    Debug.logError(e, module);
                                    return "error";
                                }
                			}
            			} else {
            				//create sales forecast, then create sales forecast detail
            				if (UtilValidate.isNotEmpty(customTimePeriodId) && UtilValidate.isNotEmpty(internalPartyId) && UtilValidate.isNotEmpty(customTimePeriodId) 
            						&& UtilValidate.isNotEmpty(organizationPartyId) && UtilValidate.isNotEmpty(currencyUomId)) {
            					Map<String, Object> inputSalesForecast = UtilMisc.toMap("userLogin", userLogin, "internalPartyId", 
                						internalPartyId, "customTimePeriodId", customTimePeriodId, "organizationPartyId", organizationPartyId, "currencyUomId", currencyUomId);
                				try {
                					List<GenericValue> listSalesForecast = delegator.findByAnd("SalesForecast", UtilMisc.toMap("internalPartyId", internalPartyId, "customTimePeriodId", customTimePeriodId, "organizationPartyId", organizationPartyId, "currencyUomId", currencyUomId), null, false);
                					if (UtilValidate.isNotEmpty(listSalesForecast)) {
                						GenericValue salesForecastFirst = listSalesForecast.get(0);
                						salesForecastId = salesForecastFirst.getString("salesForecastId");
                					} else {
                						Map<String, Object> resultService = dispatcher.runSync("createSalesForecast", inputSalesForecast);
                                        if (!ServiceUtil.isError(resultService)) {
                                        	salesForecastId = (String) resultService.get("salesForecastId");
                                        }
                					}
                                    if (UtilValidate.isNotEmpty(salesForecastId)) {
                                    	if (UtilValidate.isNotEmpty(salesForecastDetailId)) {
                            				// update sales forecast detail with id = (salesForecastId, salesForecastDetailId)
                            				Map<String, Object> input = UtilMisc.toMap("userLogin", userLogin, "salesForecastId", salesForecastId, "salesForecastDetailId", salesForecastDetailId, "productId", productId, "quantity", quantityNew);
                                            try {
                                                dispatcher.runSync("updateSalesForecastDetail", input);
                                            } catch (GenericServiceException e) {
                                                Debug.logError(e, module);
                                                return "error";
                                            }
                            			} else {
                            				// create new a sales forecast detail
                            				Map<String, Object> input = UtilMisc.toMap("userLogin", userLogin, "salesForecastId", salesForecastId, "productId", productId, "quantity", quantityNew);
                                            try {
                                                dispatcher.runSync("createSalesForecastDetail", input);
                                            } catch (GenericServiceException e) {
                                                Debug.logError(e, module);
                                                return "error";
                                            }
                            			}
                                    }
                                } catch (GenericServiceException e) {
                                    Debug.logError(e, module);
                                    return "error";
                                } catch (GenericEntityException e1) {
									// TODO Auto-generated catch block
									e1.printStackTrace();
								}
            				}
            			}
            		}
            	}
            }
        }

        // Determine where to send the browser
        return "success";
    }
	
	/** Returns the number or rows submitted by a multi form.
     */
    public static Map<String, Object> getMultiFormRowCount(Map<String, ?> requestMap) {
        // The number of multi form rows is computed selecting the maximum index
    	Map<String, Object> mapResult = FastMap.newInstance();
    	List<String> rowIds = new ArrayList<String>();
    	String tabCurrent = null;
    	int colCount = 0;
    	int colValue = 0;
        for (String parameterName : requestMap.keySet()) {
        	String[] parameterNameSplit = parameterName.split(MULTI_ROW_DELIMITER);
        	if (parameterNameSplit.length == 2) {
        		if ("internalPartyId".equals(parameterNameSplit[0])) {
        			tabCurrent = parameterNameSplit[1];
        		}
        	} else if (parameterNameSplit.length == 4) {
        		String preId = parameterNameSplit[1] + "_" + parameterNameSplit[2];
            	String afterId = parameterNameSplit[3];
            	if (!rowIds.contains(preId)) {
            		rowIds.add(preId);
            	}
            	try {
            		colValue = Integer.parseInt(afterId);
                } catch (NumberFormatException e) {
                    Debug.logWarning("Invalid value for row index found: " + afterId, module);
                }
            	
            	if (colCount < colValue) {
            		colCount = colValue;
            	}
        	}
        }
        if (UtilValidate.isNotEmpty(colCount)) {
        	colCount++; // row indexes are zero based
        }
        mapResult.put("colCount", colCount);
        mapResult.put("rowIds", rowIds);
        mapResult.put("tabCurrent", tabCurrent);
        return mapResult;
    }
    
    public static String updateReturnProductReqs(HttpServletRequest request, HttpServletResponse response) {
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		Locale locale = UtilHttp.getLocale(request);
		String listData = request.getParameter("listData");
		Timestamp nowTimestamp = UtilDateTime.nowTimestamp();
		GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");  
		JSONArray json = new JSONArray();
		if(UtilValidate.isNotEmpty(listData)){
			 json = JSONArray.fromObject(listData);
		}
		if (json != null && json.size() > 0) {
			List<GenericValue> toBeStored = new LinkedList<GenericValue>();
			for (int i = 0; i < json.size(); i++) {
				JSONObject groupItem = json.getJSONObject(i);
				String requirementId = groupItem.getString("requirementId");
				String statusId = groupItem.getString("statusId");
				if (UtilValidate.isEmpty(statusId)) {
					request.setAttribute("responseMessage", "error");
					request.setAttribute("errorMessage", UtilProperties.getMessage(resource_error, "DAStatusCannotEmpty", locale));
				}
				if (UtilValidate.isNotEmpty(requirementId)) {
					try {
						GenericValue itemData = delegator.findOne("Requirement", UtilMisc.toMap("requirementId", requirementId), false);
						if (itemData != null) {
							GenericValue statusItem = delegator.findOne("StatusItem", UtilMisc.toMap("statusId", statusId), false);
							if (UtilValidate.isNotEmpty(statusItem)) {
								itemData.put("statusId", statusId);
								toBeStored.add(itemData);
								Map<String, Object> contextMap = UtilMisc.<String, Object>toMap("requirementId", itemData.get("requirementId"), "statusId", statusId, "statusDate", nowTimestamp, "statusUserLogin", userLogin.get("userLoginId"));
								GenericValue requirementStatus = delegator.makeValue("RequirementStatus", contextMap);
								toBeStored.add(requirementStatus);
							}
							List<GenericValue> listRequirementItem = delegator.findByAnd("RequirementItem", UtilMisc.toMap("requirementId", itemData.get("requirementId")), null, false);
							if (UtilValidate.isNotEmpty(listRequirementItem)) {
								for (GenericValue requirementItem : listRequirementItem) {
									if (UtilValidate.isEmpty(requirementItem.get("quantityAccepted")) && UtilValidate.isNotEmpty(requirementItem.get("quantity"))) {
										requirementItem.put("quantityAccepted", requirementItem.get("quantity"));
										toBeStored.add(requirementItem);
									}
								}
							}
						}
					} catch (GenericEntityException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			try {
	            // store line items, etc so that they will be there for the foreign key checks
	            delegator.storeAll(toBeStored);
	        } catch (GenericEntityException e) {
	            Debug.logError(e, "Problem with store all data updateReturnProductReqs event", module);
	            return "error";
	        }
		}
		return "success";
	}
}
