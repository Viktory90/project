package com.olbius.jackrabbit.client.core.security;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.jcr.security.Privilege;

import org.apache.jackrabbit.core.security.authorization.PrivilegeRegistry;

public class OlbiusPermisions {
	
	public static final String ADMIN = "ADMIN";
	
	public static final String VIEW = "VIEW";
	
	public static final String DELETE = "DELETE";
	
	public static final String UPDATE = "UPDATE";
	
	public static final String CREATE = "CREATE";
	
	private static final Map<String, String[]> permission = initPermissionMap();
	
	private static Map<String, Set<String>> mapComponent = null;
	
	public static Map<String, String[]> getMapPermission() {
		return permission;
	}

	public static Map<String, Set<String>> getMapComponent() {
		if (mapComponent == null) {
			mapComponent = new HashMap<String, Set<String>>();
		}
		return mapComponent;
	}
	
	private static Map<String, String[]> initPermissionMap() {
		
		Map<String, String[]> map = new HashMap<String, String[]>();
		map.put(ADMIN, new String[] {Privilege.JCR_READ, PrivilegeRegistry.REP_WRITE, Privilege.JCR_READ_ACCESS_CONTROL,
				Privilege.JCR_MODIFY_ACCESS_CONTROL, Privilege.JCR_VERSION_MANAGEMENT });
		map.put(VIEW, new String[] { Privilege.JCR_READ, Privilege.JCR_VERSION_MANAGEMENT });
		map.put(DELETE, new String[] { Privilege.JCR_REMOVE_NODE, Privilege.JCR_READ, Privilege.JCR_VERSION_MANAGEMENT });
		map.put(UPDATE, new String[] { Privilege.JCR_MODIFY_PROPERTIES, Privilege.JCR_READ, Privilege.JCR_READ_ACCESS_CONTROL,
				Privilege.JCR_MODIFY_ACCESS_CONTROL, Privilege.JCR_NODE_TYPE_MANAGEMENT, Privilege.JCR_VERSION_MANAGEMENT });
		map.put(CREATE, new String[] { Privilege.JCR_ADD_CHILD_NODES, Privilege.JCR_READ, Privilege.JCR_READ_ACCESS_CONTROL,
				Privilege.JCR_MODIFY_ACCESS_CONTROL, Privilege.JCR_NODE_TYPE_MANAGEMENT, Privilege.JCR_VERSION_MANAGEMENT });
		return map;
	}
	
}
