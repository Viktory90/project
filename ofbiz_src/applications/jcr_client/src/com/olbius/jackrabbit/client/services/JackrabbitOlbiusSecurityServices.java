package com.olbius.jackrabbit.client.services;

import java.util.Map;

import javax.jcr.RepositoryException;
import javax.jcr.Session;

import javolution.util.FastMap;

import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ModelService;

import com.olbius.jackrabbit.client.api.OlbiusAccessControlManagerFactory;
import com.olbius.jackrabbit.client.core.security.OlbiusAccessControlManager;
import com.olbius.jackrabbit.client.core.security.OlbiusPermisions;
import com.olbius.jackrabbit.session.JackrabbitOlbiusSessionServices;

public class JackrabbitOlbiusSecurityServices {
	
	public final static String module = JackrabbitOlbiusSecurityServices.class.getName();
	
	private final static OlbiusAccessControlManagerFactory FACTORY = new OlbiusAccessControlManagerFactory();
	
	public static Map<String, Object> jackrabbitSetPermision(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		
		String curPath = (String) context.get("curPath");

		String userId = (String) context.get("userId");
		
		String groupId = (String) context.get("groupId");
		
		String permision = (String) context.get("permision");
		
		String tenantId = ctx.getDelegator().getDelegatorTenantId();
		
		Boolean allow = (Boolean) context.get("allow");
		
		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusAccessControlManager manager = FACTORY.newInstance(jcrSession);
				String[] privileges = OlbiusPermisions.getMapPermission().get(permision);
				
				if(privileges == null) {
					result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_ERROR);
					result.put(ModelService.ERROR_MESSAGE, "Permision not found");
					return result;
				}
				
				if(userId != null && !userId.isEmpty()) {
					if(tenantId != null && !tenantId.isEmpty()) {
						userId = userId.concat("#").concat(tenantId);
					}
					manager.addEntry(curPath, userId, privileges, allow, true);
				} else if(groupId != null && !groupId.isEmpty()) {
					if(tenantId != null && !tenantId.isEmpty()) {
						groupId = groupId.concat("#").concat(tenantId);
					}
					groupId = groupId.concat(".group");
					manager.addEntry(curPath, groupId, privileges, allow, true);
				} else {
					result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_ERROR);
					result.put(ModelService.ERROR_MESSAGE, "GroupID or UserID not found");
					return result;
				}
				
			} catch (RepositoryException e) {
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
	
	public static Map<String, Object> jackrabbitRemovePermision(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		
		String curPath = (String) context.get("curPath");

		String userId = (String) context.get("userId");
		
		String groupId = (String) context.get("groupId");
		
		String permision = (String) context.get("permision");
		
		String tenantId = ctx.getDelegator().getDelegatorTenantId();
		
		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusAccessControlManager manager = FACTORY.newInstance(jcrSession);
				String[] privileges = OlbiusPermisions.getMapPermission().get(permision);
				
				if(privileges == null) {
					result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_ERROR);
					result.put(ModelService.ERROR_MESSAGE, "Permision not found");
					return result;
				}
				
				if(userId != null && !userId.isEmpty()) {
					if(tenantId != null && !tenantId.isEmpty()) {
						userId = userId.concat("#").concat(tenantId);
					}
					manager.removeEntry(curPath, userId, privileges, true);
				} else if(groupId != null && !groupId.isEmpty()) {
					if(tenantId != null && !tenantId.isEmpty()) {
						groupId = groupId.concat("#").concat(tenantId);
					}
					groupId = groupId.concat(".group");
					manager.removeEntry(curPath, groupId, privileges, true);
				} else {
					result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_ERROR);
					result.put(ModelService.ERROR_MESSAGE, "GroupID or UserID not found");
					return result;
				}
				
			} catch (RepositoryException e) {
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
}
