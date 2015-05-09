package com.olbius.jackrabbit.client;

import javax.jcr.LoginException;
import javax.jcr.Repository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.SimpleCredentials;

import org.apache.jackrabbit.commons.JcrUtils;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilProperties;

public class JcrClientProvider {

	public static final String module = JcrClientProvider.class.getName();

	private String remoteJcrWebDavUrl;
	private String remoteJcrRmiUrl;
	private Repository repositoryWebDav;
	private Repository repositoryRmi;
	private static JcrClientProvider instance;

	public static final String WSP_SECURITY = "security";
	public static final String WSP_DEFAULT = "default";
	
	public static final String WEB_DAV_URI = "/webdavClient/repository/";
	
	private JcrClientProvider() {
		this.remoteJcrWebDavUrl = UtilProperties.getPropertyValue("jcr_client",
				"jcr.remote.webdav.url");
		this.remoteJcrRmiUrl = UtilProperties.getPropertyValue("jcr_client",
				"jcr.remote.rmi.url");
	}

	public static JcrClientProvider getInstance() {
		if (instance == null) {
			instance = new JcrClientProvider();
		}
		return instance;
	}

	public Session getSession(String userName, String password,
			String workspace, boolean security) throws LoginException,
			RepositoryException {
		if (security) {
			return getRepositoryRmi().login(
					new SimpleCredentials(userName, password.toCharArray()),
					workspace);
		} else {
			return getRepositoryWebDav().login(new SimpleCredentials(userName,
					password.toCharArray()), workspace);
		}
	}

	public Repository getRepositoryWebDav() throws RepositoryException {
		if (repositoryWebDav == null) {
			try {
				repositoryWebDav = JcrUtils.getRepository(remoteJcrWebDavUrl);
			} catch (RepositoryException e) {
				Debug.logError(e, e.getMessage(), module);
				throw new RepositoryException(e);
			}
		}
		return repositoryWebDav;
	}

	public Repository getRepositoryRmi() throws RepositoryException {
		if (repositoryRmi == null) {
			try {
				repositoryRmi = JcrUtils.getRepository(remoteJcrRmiUrl);
			} catch (RepositoryException e) {
				Debug.logError(e, e.getMessage(), module);
				throw new RepositoryException(e);
			}
		}
		return repositoryRmi;
	}
}
