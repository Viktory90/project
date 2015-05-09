package com.olbius.jackrabbit.client.api;

import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jcr.Binary;
import javax.jcr.Node;
import javax.jcr.NodeIterator;
import javax.jcr.PathNotFoundException;
import javax.jcr.Property;
import javax.jcr.PropertyType;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.nodetype.NodeType;

import com.olbius.jackrabbit.client.api.NodeTypeImpl;
import com.olbius.jackrabbit.client.core.OlbiusNode;
import com.olbius.jackrabbit.client.core.security.OlbiusAccessControlManager;
import com.olbius.jackrabbit.client.core.security.OlbiusPermisions;

public class OlbiusNodeImpl implements OlbiusNode {

	private final static OlbiusAccessControlManagerFactory FACTORY = new OlbiusAccessControlManagerFactory();
	
	private Session session;
	
	protected OlbiusNodeImpl(Session session) {
		this.session = session;
	}

	@Override
	public Session getSession() {
		return session;
	}

	private Node getNode(String curPath, boolean create) throws PathNotFoundException, RepositoryException {
		if(create) {
			
			String[] tmp = null;

			Node node = null;
			
			try {
				node = getNode(curPath, false);
			} catch (PathNotFoundException e) {
				
				tmp = curPath.substring(1).split("/");
				
				node = session.getRootNode();
				for (String x : tmp) {
					try {
						node = node.getNode(x);
					} catch (PathNotFoundException e1) {
						createFolder(node.getPath(), x);
					}
				}
				
			} catch (RepositoryException e) {
				throw new RepositoryException(e);
			}
			
			return node;
			
		}
		return session.getNode(curPath);
	}
	
	@Override
	public Node createFolder(String curPath, String name)
			throws RepositoryException {
		
		Node node = createNode(curPath, name, NodeType.NT_FOLDER);
		
		session.save();
		
		return node;
	}

	private Node createNode(String curPath, String name, String type) throws PathNotFoundException, RepositoryException {
		
		Node node = getNode(curPath, false);
		
		String _name = getNewName(node.getPath(), name);

		return node.addNode(_name, type);
	}
	
	private Node createNode(Node curNode, String name, String type) throws PathNotFoundException, RepositoryException {
		
		String _name = getNewName(curNode.getPath(), name);

		return curNode.addNode(_name, type);
	}
	
	@Override
	public void remove(String curPath) throws RepositoryException {
		Node node = getNode(curPath, false);
		node.remove();
		session.save();
	}

	@Override
	public List<String> getChildNode(String curPath) throws RepositoryException {
		
		List<Node> nodes = getNodes(curPath, false);
		List<String> strings = new ArrayList<String>();
		for (javax.jcr.Node x : nodes) {
			strings.add(x.getName());
		}
		return strings;
	}

	private List<Node> getNodes(String curPath, boolean isSystem) throws RepositoryException {
		Node node = getNode(curPath, false);
		
		NodeIterator iterator = node.getNodes();
		
		List<Node> list = new ArrayList<Node>();
		
		while (iterator.hasNext()) {
			Node n = iterator.nextNode();
			if (isSystem) {
				list.add(n);
			} else if (n.isNodeType(NodeType.NT_RESOURCE)) {
				list.add(n);
			} else if (n.getName().contains("jcr:") || n.getName().contains("rep:")) {

			} else {
				list.add(n);
			}
		}
		return list;
	}
	
	@Override
	public Map<String, List<String>> getChildItem(String curPath)
			throws RepositoryException {

		List<Node> nodes = getNodes(curPath, false);
		
		Map<String, List<String>> strings = new HashMap<String, List<String>>();
		
		List<String> folder = new ArrayList<String>();
		
		List<String> file = new ArrayList<String>();
		
		for (javax.jcr.Node x : nodes) {
			if (x.isNodeType(NodeType.NT_FILE)) {
				file.add(x.getName());
			} else if (x.isNodeType(NodeType.NT_FOLDER)) {
				folder.add(x.getName());
			}
		}
		Collections.sort(file);
		Collections.sort(folder);
		strings.put("folder", folder);
		strings.put("file", file);
		return strings;
	}

	@Override
	public String rename(String curPath, String newName)
			throws RepositoryException {
		
		Node node = getNode(curPath, false);
		
		String _path = getNewPath(node.getParent().getPath() + "/" + newName);
		
		session.move(node.getPath(), _path);
		session.save();
		
		return _path;
	}

	@Override
	public String createFile(String curPath, String fileName,
			String mimeType, InputStream data, boolean version)
			throws RepositoryException, IOException, ParseException {
		
		Node node = getNode(curPath, true);
		
		return createFile(node, fileName, mimeType, data, version);
	}

	@Override
	public String move(String curPath, String newPath) throws RepositoryException {
		
		Node curNode = getNode(curPath, false);
		Node newPerantNode = getNode(newPath, false);

		String _path = getNewPath(newPerantNode.getPath() + "/" + curNode.getName());
		
		session.move(curNode.getPath(), _path);
		session.save();
		return _path;
	}

	private String getNewPath(String path) throws RepositoryException {
		
		String _path = null;
		
		String s = "";
		int i = 2;
		while (true) {
			try {
				_path = path.concat(s);
				session.getNode(_path);
				s = "(".concat(Integer.toString(i)).concat(")");
				i++;
			} catch (PathNotFoundException e) {
				break;
			}
		}
		
		return _path;
	}
	
	private String getNewName(String path, String name) throws RepositoryException {
		
		String _path = null;
		
		String s = "";
		int i = 2;
		while (true) {
			try {
				if(path.equals("/")) {
					_path = path.concat(name).concat(s);
				} else {
					_path = path.concat("/").concat(name).concat(s);
				}
				session.getNode(_path);
				s = "(".concat(Integer.toString(i)).concat(")");
				i++;
			} catch (PathNotFoundException e) {
				break;
			}
		}
		
		return name.concat(s);
	}
	
	@Override
	public String copy(String curPath, String path) throws RepositoryException {
		Node curNode = session.getNode(curPath);
		Node node = session.getNode(path);

		String _path = getNewPath( node.getPath() + "/" + curNode.getName());
		
		session.getWorkspace().copy(curNode.getPath(), _path);
		session.save();
		
		return _path;
	}

	@Override
	public void updateFile(String curPath, InputStream data)
			throws RepositoryException, IOException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateFile(String curPath, InputStream data,
			Map<String, Object> properties) throws RepositoryException,
			IOException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<String> getAllVersion(String curPath)
			throws RepositoryException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getVersion(String curPath, String label)
			throws RepositoryException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String publicNode(String curPath) throws RepositoryException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String privateNode(String curPath) throws RepositoryException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String createFile(Node curNode, String fileName, String mimeType,
			InputStream data, boolean version) throws RepositoryException,
			IOException, ParseException {
		
		return createFile(curNode, fileName, mimeType, data, null, null, version);
	}

	@Override
	public String createFile(Node curNode, String fileName, String mimeType,
			InputStream data, String nodeType, Map<String, String> properties,
			boolean version) throws RepositoryException, IOException,
			ParseException {

		Node file = createNode(curNode, fileName, NodeType.NT_FILE);
		
		Node resNode = file.addNode(Node.JCR_CONTENT, NodeType.NT_RESOURCE);
		resNode.setProperty(Property.JCR_MIMETYPE, mimeType);
		
		Binary b = session.getValueFactory().createBinary(data);
		resNode.setProperty(Property.JCR_DATA, b);
		session.save();

		if(properties != null && nodeType != null && !nodeType.isEmpty()) {
			com.olbius.jackrabbit.client.core.NodeType type = new NodeTypeImpl(session);

			Map<String, String> map = type.getProperties(nodeType);

			for (String x : properties.keySet()) {
				if (map.get(x).equals(PropertyType.TYPENAME_BOOLEAN)) {
					resNode.setProperty(x, Boolean.parseBoolean(properties.get(x)));
				} else if (map.get(x).equals(PropertyType.TYPENAME_DATE)) {
					SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy hh:mm");
					Date date = format.parse(properties.get(x));
					Calendar calendar = Calendar.getInstance();
					calendar.setTime(date);
					resNode.setProperty(x, calendar);
				} else if (map.get(x).equals(PropertyType.TYPENAME_STRING)) {
					resNode.setProperty(x, properties.get(x));
				} else if (map.get(x).equals(PropertyType.TYPENAME_DOUBLE)) {
					resNode.setProperty(x, Double.parseDouble(properties.get(x)));
				} else if (map.get(x).equals(PropertyType.TYPENAME_LONG)) {
					resNode.setProperty(x, Long.parseLong(properties.get(x)));
				} else if (map.get(x).equals(PropertyType.TYPENAME_NAME)) {
					resNode.setProperty(x, properties.get(x));
				}
				// resNode.setProperty(x, properties.get(x));
			}
		}
		
		session.save();
		
		file.addMixin(NodeType.MIX_VERSIONABLE);
		
		session.save();

		data.close();
		
		OlbiusAccessControlManager oAcm = FACTORY.newInstance(session);
		
		oAcm.addEntry(file.getPath(), session.getUserID(), OlbiusPermisions.getMapPermission().get("ADMIN"), true, true);
		
		return file.getPath();
	}

	@Override
	public Map<String, Map<String, String>> getFileProperties(Node curNode,
			String namespace) throws RepositoryException {
		
		if (!curNode.isNodeType(NodeType.NT_FILE)) {
			throw new RepositoryException(curNode.getName() + " is not file");
		}

		Map<String, Map<String, String>> map = new HashMap<String, Map<String, String>>();

		Map<String, String> fileProperties = new HashMap<String, String>();

		Map<String, String> contentProperties = new HashMap<String, String>();

		String fileName = curNode.getName();

		fileName = fileName.substring(0, fileName.lastIndexOf("."));

		if (curNode.getName().endsWith(")")) {
			fileName += curNode.getName().substring(curNode.getName().lastIndexOf("("));
		}

		String createdBy = curNode.getProperty(Property.JCR_CREATED_BY).getString();

		Calendar created = curNode.getProperty(Property.JCR_CREATED).getDate();

		Node content = curNode.getNode(javax.jcr.Node.JCR_CONTENT);

		Calendar lastModified = content.getProperty(Property.JCR_LAST_MODIFIED).getDate();

		String lastModifiedBy = content.getProperty(Property.JCR_LAST_MODIFIED_BY).getString();

		String mimeType = content.getProperty(Property.JCR_MIMETYPE).getString();

		fileProperties.put("fileName", fileName);
		fileProperties.put("createdBy", createdBy);
		fileProperties.put("created", created.getTime().toString());
		fileProperties.put("lastModified", lastModified.getTime().toString());
		fileProperties.put("lastModifiedBy", lastModifiedBy);
		fileProperties.put("mimeType", mimeType);

		com.olbius.jackrabbit.client.core.NodeType nodeType = new NodeTypeImpl(session);

		if (namespace != null) {

			Map<String, String> tmp = nodeType.getProperties(content.getPrimaryNodeType().getName(), namespace);

			for (String x : tmp.keySet()) {
				try {
					Property property = content.getProperty(x);

					if (property.getType() != PropertyType.BINARY) {
						if (property.getType() == PropertyType.BOOLEAN) {
							contentProperties.put(property.getName(), Boolean.toString(property.getBoolean()));
						} else if (property.getType() == PropertyType.DATE) {
							Calendar calendar = property.getDate();
							contentProperties.put(property.getName(), calendar.getTime().toString());
						} else if (property.getType() == PropertyType.DOUBLE) {
							contentProperties.put(property.getName(), Double.toString(property.getDouble()));
						} else if (property.getType() == PropertyType.LONG) {
							contentProperties.put(property.getName(), Long.toString(property.getLong()));
						} else if (property.getType() == PropertyType.NAME) {
							contentProperties.put(property.getName(), property.getValue().getString());
						} else if (property.getType() == PropertyType.STRING) {
							contentProperties.put(property.getName(), property.getString());
						} else {
							contentProperties.put(x, "");
						}
					}
				} catch (PathNotFoundException e) {
					contentProperties.put(x, "");
				}
			}
		}

		map.put("fileProperties", fileProperties);
		map.put("contentProperties", contentProperties);

		return map;
	}

	@Override
	public String createFile(String curPath, String fileName, String mimeType,
			InputStream data, String nodeType, Map<String, String> properties,
			boolean version) throws RepositoryException, IOException,
			ParseException {
		
		Node node = getNode(curPath, true);
		
		return createFile(node, fileName, mimeType, data, null, null, version);
	}
	

}
