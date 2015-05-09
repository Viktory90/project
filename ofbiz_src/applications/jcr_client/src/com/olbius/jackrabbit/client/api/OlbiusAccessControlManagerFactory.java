package com.olbius.jackrabbit.client.api;

import javax.jcr.RepositoryException;
import javax.jcr.Session;

import com.olbius.jackrabbit.client.core.security.OlbiusAccessControlManager;

public class OlbiusAccessControlManagerFactory {
	
	public OlbiusAccessControlManager newInstance(Session session) {
		try {
			return new OlbiusAccessControlManagerImpl(session);
		} catch (RepositoryException e) {
			return null;
		}
	}
	
}
