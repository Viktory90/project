package com.olbius.jackrabbit.client.loader;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.jcr.Node;
import javax.jcr.PathNotFoundException;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.SimpleCredentials;
import javax.jcr.nodetype.NodeType;
import javax.jcr.security.Privilege;

import org.apache.jackrabbit.core.security.principal.EveryonePrincipal;
import org.ofbiz.base.container.Container;
import org.ofbiz.base.container.ContainerConfig;
import org.ofbiz.base.container.ContainerException;
import org.ofbiz.base.util.Debug;
import org.ofbiz.base.util.UtilMisc;
import org.ofbiz.base.util.UtilValidate;
import org.ofbiz.entity.Delegator;
import org.ofbiz.entity.DelegatorFactory;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.entity.condition.EntityCondition;
import org.ofbiz.entity.condition.EntityOperator;
import org.ofbiz.entity.config.EntityConfigUtil;
import org.ofbiz.entity.config.model.Datasource;
import org.ofbiz.entity.config.model.InlineJdbc;
import org.ofbiz.entity.datasource.GenericHelperInfo;

import com.olbius.jackrabbit.client.JcrClientProvider;
import com.olbius.jackrabbit.client.api.OlbiusAccessControlManagerFactory;
import com.olbius.jackrabbit.client.core.security.OlbiusAccessControlManager;
import com.olbius.jackrabbit.client.core.security.OlbiusPermisions;

public class JackrabbitOlbiusContainer implements Container{
	
	public static final String module = JackrabbitOlbiusContainer.class.getName();
	private ContainerConfig.Container cfg;
	private String CONTAINER_NAME;
	private static final String ADMIN = "user";
	private static final String PWD ="password";
	
	@Override
	public void init(String[] args, String name, String configFile)
			throws ContainerException {
		cfg = ContainerConfig.getContainer(name, configFile);
		CONTAINER_NAME = name;
		Debug.logInfo("Initializing " + CONTAINER_NAME, module);
	}

	@Override
	public boolean start() throws ContainerException {
		String admin = cfg.getProperty(ADMIN).value;
		String pwd = cfg.getProperty(PWD).value;
		Session sessionDefault = null;
		Session sessionSecurity = null;
		try {
			sessionDefault = JcrClientProvider.getInstance().getRepositoryRmi().login(new SimpleCredentials(admin, pwd.toCharArray()));
			sessionSecurity = JcrClientProvider.getInstance().getRepositoryRmi().login(new SimpleCredentials(admin, pwd.toCharArray()), "security");
		} catch (RepositoryException e) {
			Debug.logError("Initializing " + CONTAINER_NAME, module);
		}
		
		Delegator delegator = DelegatorFactory.getDelegator("default");
		
		GenericHelperInfo info = ((GenericDelegator) delegator).getGroupHelperInfo("org.ofbiz");
    	
    	Datasource datasourceInfo = EntityConfigUtil.getDatasource(info.getHelperBaseName());
    	
    	InlineJdbc jdbcElement = (InlineJdbc)datasourceInfo.getInlineJdbc();
    	
    	String _uri_ofbiz = UtilValidate.isNotEmpty(info.getOverrideJdbcUri()) ? info.getOverrideJdbcUri() : jdbcElement.getJdbcUri();
    	String _user_ofbiz = UtilValidate.isNotEmpty(info.getOverrideUsername()) ? info.getOverrideUsername() : jdbcElement.getJdbcUsername();
    	String _pwd_ofbiz = UtilValidate.isNotEmpty(info.getOverridePassword()) ? info.getOverridePassword() : EntityConfigUtil.getJdbcPassword(jdbcElement);
    	
    	List<EntityCondition> conditions = new ArrayList<EntityCondition>();
		
		conditions.add(EntityCondition.makeCondition("entityGroupName", EntityOperator.EQUALS, "org.ofbiz"));
		conditions.add(EntityCondition.makeCondition("jdbcUri", EntityOperator.EQUALS, _uri_ofbiz));
		conditions.add(EntityCondition.makeCondition("jdbcUsername", EntityOperator.EQUALS, _user_ofbiz));
		conditions.add(EntityCondition.makeCondition("jdbcPassword", EntityOperator.EQUALS, _pwd_ofbiz));
		
		List<GenericValue> values = null;
		
    	try {
    		values = delegator.findList("TenantDataSource", EntityCondition.makeCondition(conditions, EntityOperator.AND), null,
					UtilMisc.toList("tenantId"), null, false);
		} catch (GenericEntityException e) {
			Debug.logError(e, e.getMessage(), module);
		}
    	
    	if(values != null && !values.isEmpty()) {
    		String tenantId = values.get(0).getString("tenantId");
    		
    		try {
    			createFolder(sessionDefault, tenantId, false);
    			createFolder(sessionSecurity, tenantId, true);
    		} catch(RepositoryException e) {
    			Debug.logError(e, e.getMessage(), module);
    			return false;
    		}
    	}
		
		return true;
	}
	
	private void createFolder(Session session, String tenantId, boolean ser) throws RepositoryException {
		OlbiusAccessControlManagerFactory olbiusACMFactory = new OlbiusAccessControlManagerFactory();
		OlbiusAccessControlManager olbiusACM = olbiusACMFactory.newInstance(session);
		Node node = null;
		try {
			node = session.getRootNode().getNode(tenantId);
		} catch (PathNotFoundException e) {
			node = session.getRootNode().addNode(tenantId, NodeType.NT_FOLDER);
		}
		
		if(ser) {
			olbiusACM.addEntry(node.getPath(), EveryonePrincipal.NAME, new String[]{Privilege.JCR_READ}, false, false);
		}
		olbiusACM.addEntry(node.getPath(), tenantId.concat(".tenant"), new String[]{Privilege.JCR_READ}, true, false);
		
		String permission = null;
		String[] permissions = null;
		for (String s : cfg.getProperty("webapp").properties.keySet()) {
			permission = cfg.getProperty("webapp").getProperty(s).value.trim();
			permissions = permission.split(",");
			Set<String> tmp = OlbiusPermisions.getMapComponent().get(s);
			if (tmp == null) {
				tmp = new TreeSet<String>();
				OlbiusPermisions.getMapComponent().put(s, tmp);
			}
			for (String y : permissions) {
				tmp.add(y);
			}
		}
		for(String s : OlbiusPermisions.getMapComponent().keySet()) {
			Node node2 = null;
			try{
				node2 = node.getNode(s);
			}catch(PathNotFoundException e1) {
				node2 = node.addNode(s, NodeType.NT_FOLDER);
			}
			if(ser) {
				olbiusACM.addEntry(node2.getPath(), EveryonePrincipal.NAME, new String[]{Privilege.JCR_READ}, false, false);
			}
			for(String y : OlbiusPermisions.getMapComponent().get(s)) {
				for(String z : OlbiusPermisions.getMapPermission().keySet()) {
					olbiusACM.addEntry(node2.getPath(), y.concat("_").concat(z).concat("#").concat(tenantId).concat(".group"), OlbiusPermisions.getMapPermission().get(z), true, false);
				}
			}
		}
		session.save();
		
	}

	@Override
	public void stop() throws ContainerException {
		
	}

	@Override
	public String getName() {
		return CONTAINER_NAME;
	}

}
