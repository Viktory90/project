import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.jdbc.ConnectionFactory;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Test {
	public static Object getData(HttpServletRequest request, HttpServletResponse response){
		Delegator delegator = (Delegator) request.getAttribute("delegator");
		String helperName = delegator.getGroupHelperName("org.ofbiz"); 
        try {
			Connection conn = ConnectionFactory.getConnection(helperName);
			Statement statement = conn.createStatement();
			statement.execute("SELECT * FROM PARTY");
			ResultSet results = statement.getResultSet();
			List<GenericValue> listReturn = new ArrayList<GenericValue>(); 
			while(results.next()){
				GenericValue v = GenericValue.create(delegator.getModelEntity("Party"));
				v.set("partyId", results.getString(1));
				listReturn.add(v);
			}
			request.setAttribute("rongnk", listReturn);
			conn.close();
			return "success";
		} catch (Exception exc) {
		}
        return null;
	}
}
