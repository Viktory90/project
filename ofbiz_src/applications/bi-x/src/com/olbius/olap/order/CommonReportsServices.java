package com.olbius.olap.order;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import javolution.util.FastList;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.condition.EntityCondition;

public class CommonReportsServices {
	public static final String module = CommonReportsServices.class.getName();
	
	public static void toJsonObjectList(List attrList, HttpServletResponse response){
        String jsonStr = "[";
        JSONArray jsonarr= new JSONArray();
        JSONObject object= new JSONObject();
        for (Object attrMap : attrList) {
            JSONObject json = JSONObject.fromObject(attrMap);
//            jsonStr = jsonStr + json.toString() + ',';
            jsonarr.add(json);
        }
        String js= jsonarr.toString();
        object.put("result", jsonarr);
//        jsonStr = jsonStr + "{ } ]";
        if (UtilValidate.isEmpty(js)) {
            Debug.logError("JSON Object was empty; fatal error!",module);
        }
        // set the X-JSON content type
        response.setContentType("application/json");
        // jsonStr.length is not reliable for unicode characters
        try {
            response.setContentLength(js.getBytes("UTF8").length);
        } catch (UnsupportedEncodingException e) {
            Debug.logError("Problems with Json encoding",module);
        }
        // return the JSON String
        Writer out;
        try {
            out = response.getWriter();
            out.write(js);
            out.flush();
        } catch (IOException e) {
            Debug.logError("Unable to get response writer",module);
        }
    }
	
	
	public static List<Map<String, Object>>getListAllMap(List<EntityCondition> listAllConditions){// filter listallcondition from widget
		List<Map<String, Object>> allCondition= FastList.newInstance();
		
		if(UtilValidate.isNotEmpty(listAllConditions)){
			for(EntityCondition condition:listAllConditions){
				if(UtilValidate.isNotEmpty(condition)){
					String condString= condition.toString();
					Map<String, Object> agent= new HashMap<String, Object>();
					String[] condArray= condString.split(" ");
					String field= condArray[0];
					String operator= condArray[1].trim();
					String value= condArray[2];
					if(field.contains("(")){
						field= field.replace("(","").trim();
					}
					if(field.contains(")")){
						field.replace(")", "").trim();
					}
					if(value.contains(")")){
						value=value.replace(")", "").trim();
					}
					if(value.contains("(")){
						value=value.replace("(", "").trim();
					}
					if(value.contains("'")){
						value=value.replace("'","").trim();
					}if(value.contains("%")){
						value=value.replace("%", "").trim();
					}
					agent.put("field",field);
					agent.put("operator", operator);
					agent.put("value", value);
					allCondition.add(agent);
					
				}
			}
		}
		
		return allCondition;
	}
	
	public static List<Map<String,Object>>fillerConditionProduct(List<Map<String,Object>> conditons, List<Map<String,Object>> products){
		List<Map<String,Object>> result=FastList.newInstance();
		for(Map<String, Object> product:products){
			boolean flad= true;
			for(Map<String,Object> condition:conditons){
				String field= (String)condition.get("field");
				String operator=(String)condition.get("operator");
				String value=(String)condition.get("value");
				if(operator.equals("LIKE")){
					String agen= (String)product.get(field);
					if(!agen.contains(value)){
						flad=false;
						break;
					}
				}
				else if(operator.equals("NOT_LIKE")){
					String agen=(String)product.get(field);
					if(agen.contains(value)){
						flad=false;
						break;
					}
				}else if(operator.equals("EQUAL")){
					String agen=(String)product.get(field);
					if(!agen.equals(value)){
						flad=false;
						break;
					}
				}else if(operator.equals("NOT_EQUAL")){
					String agen=(String)product.get(field);
					if(agen.equals(value)){
						flad=false;
						break;
						
					}
				}else if(operator.equals("=")){
					BigDecimal agen=(BigDecimal)product.get(field);
		 			BigDecimal valueAlter= new BigDecimal(value);
		 			if(UtilValidate.isNotEmpty(agen)&&UtilValidate.isNotEmpty(valueAlter) ){
		 				if(agen.compareTo(valueAlter)!=0){
		 					flad=false;
		 					break;
		 				}
		 			}
				}
				else{
					flad=false;
					break;
				}
				
			}
			if(flad){
				result.add(product);
			}
		}
		
		return result;
	}
	
	public static List<Map<String, Object>> sortList(List<Map<String,Object>> listProductCaculateds,String sortField){
		JqxUtilSort poUtil = new JqxUtilSort();
		poUtil.setSortField(sortField);
		Collections.sort(listProductCaculateds, poUtil);
			 	
		return listProductCaculateds;
	}
}
