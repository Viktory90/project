package com.olbius.jackrabbit.client.core.security;

import java.security.Principal;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.security.AccessControlEntry;
import javax.jcr.security.AccessControlManager;

public interface OlbiusAccessControlManager {
	
	public void addEntry(String curPath, String principal, String[] privileges, boolean isAllow, boolean save) throws RepositoryException;
	
	public void removeEntry(String curPath, String principal, String privilege, boolean save) throws RepositoryException;
	
	public void removeEntry(String curPath, String principal, String[] privileges, boolean save) throws RepositoryException;
	
	public AccessControlManager getAccessControlManager();
	
	public AccessControlEntry[] getEntry(Node node) throws RepositoryException;
	
	public AccessControlEntry[] getEntry(Node node, Principal principal) throws RepositoryException;
	
	public Session getSession();
	
}
