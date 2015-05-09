package com.olbius.jackrabbit.session;

import java.util.Map;

import javax.jcr.RepositoryException;
import javax.jcr.Session;

import javolution.util.FastMap;

import org.ofbiz.entity.GenericValue;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ModelService;

import com.olbius.jackrabbit.client.JcrClientProvider;

public class JackrabbitOlbiusSessionServices {
	
	public static final String JCR_SESSION = "JCR_SESSION";
	public static final String module = JackrabbitOlbiusSessionServices.class.getName();

	public static Map<String, Object> jackrabbitLogin(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		GenericValue userLogin = (GenericValue) context.get("userLogin");
		String userLoginId = userLogin.getString("userLoginId");
		String pwd = userLogin.getString("currentPassword");
		String wsp = "default";
		String isPublic = (String) context.get("public");
		if("Y".equals(isPublic)) {
			wsp = "default";
		}
		if("N".equals(isPublic)) {
			wsp = "security";
		}
		String tenantId = ctx.getDelegator().getDelegatorTenantId();
		if(tenantId !=null && !tenantId.isEmpty()) {
			userLoginId = userLoginId.concat("#").concat(tenantId);
		}
		Session jcrSession = null;
		try {
			jcrSession = JcrClientProvider.getInstance().getSession(userLoginId, pwd, wsp, true);
		} catch (RepositoryException e) {
			throw new GenericServiceException(e.getMessage());
		}
		result.put(JackrabbitOlbiusSessionServices.JCR_SESSION, jcrSession);
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitLogout(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);
		if (jcrSession != null) {
			jcrSession.logout();
		}
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
}
