package com.olbius.jackrabbit.webdav;

import javax.jcr.Credentials;
import javax.jcr.LoginException;
import javax.jcr.Repository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.SimpleCredentials;
import javax.servlet.http.HttpSession;

import org.apache.jackrabbit.server.SessionProvider;
import org.apache.jackrabbit.webdav.DavException;
import org.apache.jackrabbit.webdav.DavSession;
import org.apache.jackrabbit.webdav.DavSessionProvider;
import org.apache.jackrabbit.webdav.WebdavRequest;
import org.apache.jackrabbit.webdav.simple.DavSessionImpl;
import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.webapp.control.LoginWorker;

public class OlbiusDavSessionProvider implements DavSessionProvider {
	private Repository repository;
	private final SessionProvider sesProvider;
	public static String module = OlbiusDavSessionProvider.class.getName();
	
	public OlbiusDavSessionProvider(Repository rep, SessionProvider sesProvider) {
        this.repository = rep;
        this.sesProvider = sesProvider;
    }

	@Override
	public boolean attachSession(WebdavRequest request) throws DavException {
		HttpSession session = request.getSession();
		String externalKey = request.getParameter(LoginWorker.EXTERNAL_LOGIN_KEY_ATTR);
		GenericValue userLogin;
        if (externalKey == null){
        	userLogin = (GenericValue) session.getAttribute("userLogin");
        }else{
        	userLogin = LoginWorker.externalLoginKeys.get(externalKey);
        }
        try {
	        String workspaceName = request.getRequestLocator().getWorkspaceName();
	        if (workspaceName != null && "".equals(workspaceName)) {
	            workspaceName = null;
	        }
	        Session repSession;
	        if (userLogin !=null){
	        	String tenant = userLogin.getDelegator().getDelegatorTenantId();
	        	String userName = userLogin.getString("userLoginId");
	        	String pwd = userLogin.getString("currentPassword");
	        	Credentials cred = null;
	        	if(tenant == null) {
	        		cred = new SimpleCredentials(userName, pwd.toCharArray());
	        	} else {
	        		cred = new SimpleCredentials(userName.concat("#").concat(tenant), pwd.toCharArray());
	        	}
	        	
	        	repSession = repository.login(cred,workspaceName);
	        }else{
	        	repSession = repository.login(workspaceName);
	        }
	        if (repSession == null) {
	            Debug.logError("Could not to retrieve a repository session.",module);
	            return false;
	        }
	        
	        DavSession ds = new DavSessionImpl(repSession);
            Debug.log("Attaching session '"+ ds + "' to request '" + request + "'");
            request.setDavSession(ds);
            return true;
		} catch (LoginException e) {
			Debug.logVerbose(e.getMessage(), module);
		} catch (RepositoryException e) {
			Debug.logError(e.getMessage(), module);
		}
		return false;
	}

	@SuppressWarnings("deprecation")
	@Override
	public void releaseSession(WebdavRequest request) {
		DavSession ds = request.getDavSession();
        if (ds != null && ds instanceof DavSessionImpl) {
            Session repSession = ((DavSessionImpl)ds).getRepositorySession();
            for (String lockToken : repSession.getLockTokens()) {
                repSession.removeLockToken(lockToken);
            }
            sesProvider.releaseSession(repSession);
            Debug.logVerbose("Releasing session '"+ ds + "' from request '" + request + "'", module);
        } 
        request.setDavSession(null);
	}

}
