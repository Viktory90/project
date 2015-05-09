package org.ofbiz.mobileservices;

import static org.ofbiz.base.util.UtilGenerics.checkMap;

import java.io.BufferedReader;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javolution.util.FastList;
import net.sf.json.JSONObject;

import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilHttp;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilProperties;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.DelegatorFactory;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.security.Security;
import org.ofbiz.security.SecurityConfigurationException;
import org.ofbiz.security.SecurityFactory;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.LocalDispatcher;
import org.ofbiz.service.ModelService;
import org.ofbiz.service.ServiceUtil;
import org.ofbiz.webapp.control.ContextFilter;
import org.ofbiz.webapp.control.LoginWorker;
import org.ofbiz.webapp.stats.VisitHandler;

public class LoginMobileServices extends LoginWorker {
	public static String checkLogin(HttpServletRequest request,
			HttpServletResponse response) {
		GenericValue userLogin = checkLogout(request, response);
		// have to reget this because the old session object will be invalid
		HttpSession session = request.getSession();

		String username = null;
		String password = null;

		if (userLogin == null) {
			// check parameters
			username = request.getParameter("USERNAME");
			password = request.getParameter("PASSWORD");
			// check session attributes
			if (username == null)
				username = (String) session.getAttribute("USERNAME");
			if (password == null)
				password = (String) session.getAttribute("PASSWORD");

			// in this condition log them in if not already; if not logged in or
			// can't log in, save parameters and return error
			if ((username == null) || (password == null)
					|| ("error".equals(login(request, response)))) {

				// make sure this attribute is not in the request; this avoids
				// infinite recursion when a login by less stringent criteria
				// (like not checkout the hasLoggedOut field) passes; this is
				// not a normal circumstance but can happen with custom code or
				// in funny error situations when the userLogin service gets the
				// userLogin object but runs into another problem and fails to
				// return an error
				request.removeAttribute("_LOGIN_PASSED_");

				// keep the previous request name in the session
				session.setAttribute("_PREVIOUS_REQUEST_",
						request.getPathInfo());
				request.setAttribute("login", "FALSE");
				// NOTE: not using the old _PREVIOUS_PARAMS_ attribute at all
				// because it was a security hole as it was used to put data in
				// the URL (never encrypted) that was originally in a form field
				// that may have been encrypted
				// keep 2 maps: one for URL parameters and one for form
				// parameters
				Map<String, Object> urlParams = UtilHttp
						.getUrlOnlyParameterMap(request);
				if (UtilValidate.isNotEmpty(urlParams)) {
					session.setAttribute("_PREVIOUS_PARAM_MAP_URL_", urlParams);
				}
				Map<String, Object> formParams = UtilHttp.getParameterMap(
						request, urlParams.keySet(), false);
				if (UtilValidate.isNotEmpty(formParams)) {
					session.setAttribute("_PREVIOUS_PARAM_MAP_FORM_",
							formParams);
				}

				// if (Debug.infoOn()) Debug.logInfo("checkLogin: PathInfo=" +
				// request.getPathInfo(), module);

				return "error";
			}
		}
		request.setAttribute("login", "TRUE");
		return "success";
	}
}
