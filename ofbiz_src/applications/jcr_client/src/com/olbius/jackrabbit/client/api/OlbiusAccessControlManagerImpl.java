package com.olbius.jackrabbit.client.api;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.UnsupportedRepositoryOperationException;
import javax.jcr.security.AccessControlEntry;
import javax.jcr.security.AccessControlList;
import javax.jcr.security.AccessControlManager;

import org.apache.jackrabbit.rmi.client.security.ClientAccessControlManager;

import com.olbius.jackrabbit.client.core.security.OlbiusAccessControlManager;

public class OlbiusAccessControlManagerImpl implements OlbiusAccessControlManager {

	private AccessControlManager acm;
	private Session session;
	
	public OlbiusAccessControlManagerImpl(Session session) throws UnsupportedRepositoryOperationException, RepositoryException {
		this.session = session;
		acm = session.getAccessControlManager();
	}


	@Override
	public AccessControlManager getAccessControlManager() {
		return acm;
	}

	@Override
	public AccessControlEntry[] getEntry(Node node) throws RepositoryException {
		AccessControlList acl;
		
		try {
			acl = (AccessControlList) acm.getPolicies(node.getPath())[0];
		} catch (Exception e) {
			acl = (AccessControlList) acm.getApplicablePolicies(node.getPath()).nextAccessControlPolicy();
		}
		
		return acl.getAccessControlEntries();
	}

	@Override
	public AccessControlEntry[] getEntry(Node node, Principal principal) throws RepositoryException {
		List<AccessControlEntry> list = new ArrayList<AccessControlEntry>();
		AccessControlEntry[] entries = getEntry(node);
		for (AccessControlEntry entry : entries) {
			if (entry.getPrincipal().getName().equals(principal.getName())) {
				list.add(entry);
			}
		}
		entries = new AccessControlEntry[list.size()];
		list.toArray(entries);
		return entries;
	}

	@Override
	public Session getSession() {
		return session;
	}

	@Override
	public void addEntry(String curPath, String principal, String[] privileges,
			boolean isAllow, boolean save) throws RepositoryException {
		if(acm instanceof ClientAccessControlManager) {
			((ClientAccessControlManager) acm).setPolicy(curPath, principal, privileges, isAllow);
		}
		if(save) {
			session.save();
		}
	}

	@Override
	public void removeEntry(String curPath, String principal, String privilege, boolean save)
			throws RepositoryException {
		if(acm instanceof ClientAccessControlManager) {
			((ClientAccessControlManager) acm).removePolicy(curPath, principal, privilege);
		}
		if(save) {
			session.save();
		}
	}

	@Override
	public void removeEntry(String curPath, String principal,
			String[] privileges, boolean save) throws RepositoryException {
		if(acm instanceof ClientAccessControlManager) {
			for(String privilege : privileges) {
				((ClientAccessControlManager) acm).removePolicy(curPath, principal, privilege);
			}
		}
		if(save) {
			session.save();
		}
	}
}
