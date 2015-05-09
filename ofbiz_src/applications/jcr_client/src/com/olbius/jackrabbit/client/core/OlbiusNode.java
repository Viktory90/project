package com.olbius.jackrabbit.client.core;

import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

public interface OlbiusNode {

	public Session getSession();

	public Node createFolder(String curPath, String name) throws RepositoryException;

	public void remove(String curPath) throws RepositoryException;

	public List<String> getChildNode(String curPath) throws RepositoryException;

	public Map<String, List<String>> getChildItem(String curPath) throws RepositoryException;

	public String rename(String curPath, String newName) throws RepositoryException;

	public String createFile(String curPath, String fileName, String mimeType, InputStream data, boolean version) throws RepositoryException, IOException, ParseException;

	public String move(String curPath, String newPath) throws RepositoryException;

	public String copy(String curPath, String path) throws RepositoryException;

	public void updateFile(String curPath, InputStream data) throws RepositoryException, IOException;

	public void updateFile(String curPath, InputStream data, Map<String, Object> properties) throws RepositoryException, IOException;

	public List<String> getAllVersion(String curPath) throws RepositoryException;

	public String getVersion(String curPath, String label) throws RepositoryException;

	public String publicNode(String curPath) throws RepositoryException;

	public String privateNode(String curPath) throws RepositoryException;

	public String createFile(Node curNode, String fileName, String mimeType, InputStream data, boolean version) throws RepositoryException, IOException, ParseException;

	public String createFile(Node curNode, String fileName, String mimeType, InputStream data, String nodeType, Map<String, String> properties, boolean version)
			throws RepositoryException, IOException, ParseException;
	
	public String createFile(String curPath, String fileName, String mimeType, InputStream data, String nodeType, Map<String, String> properties, boolean version)
			throws RepositoryException, IOException, ParseException;

	public Map<String, Map<String, String>> getFileProperties(Node curNode, String namespace) throws RepositoryException;
	
}
