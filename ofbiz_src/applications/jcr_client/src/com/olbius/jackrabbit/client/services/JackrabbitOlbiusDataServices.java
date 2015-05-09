package com.olbius.jackrabbit.client.services;

import java.awt.image.ImagingOpException;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jcr.RepositoryException;
import javax.jcr.Session;

import javolution.util.FastMap;

import org.jdom.JDOMException;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.GenericServiceException;
import org.ofbiz.service.ModelService;

import com.olbius.jackrabbit.client.api.OlbiusNodeFactory;
import com.olbius.jackrabbit.client.api.image.JackrabbitScaleImage;
import com.olbius.jackrabbit.client.core.OlbiusNode;
import com.olbius.jackrabbit.session.JackrabbitOlbiusSessionServices;

public class JackrabbitOlbiusDataServices {
	
	public final static String module = JackrabbitOlbiusDataServices.class.getName();

	private final static OlbiusNodeFactory NODE_FACTORY = new OlbiusNodeFactory();
	
	public static Map<String, Object> jackrabbitCopyNode(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");
		String parentPath = (String) context.get("parentPath");

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				String _path = node.copy(curPath, parentPath);
				result.put("path", _path);
			} catch (RepositoryException e) {
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitCreateFolder(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");
		String folderName = (String) context.get("folderName");

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				javax.jcr.Node folder = node.createFolder(curPath, folderName);
				result.put("path", folder.getPath());
			} catch (RepositoryException e) {
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitDeleteNode(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				node.remove(curPath);
			} catch (RepositoryException e) {
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitGetChildNode(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				
				List<String> nodes = node.getChildNode(curPath);
				
				result.put("childNodes", nodes);
				
			} catch (RepositoryException e) {
				throw new GenericServiceException(e);
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitMoveNode(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");
		String newPath = (String) context.get("newPath");
		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				
				String _path = node.move(curPath, newPath);
				
				result.put("path", _path);
			} catch (RepositoryException e) {
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitRenameNode(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");
		String newName = (String) context.get("newName");

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				
				String _path = node.rename(curPath, newName);
				
				result.put("path", _path);
			} catch (RepositoryException e) {
				jcrSession.logout();
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitUploadFile(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();

		ByteBuffer fileBytes = (ByteBuffer) context.get("uploadedFile");
		String fileName = (String) context.get("_uploadedFile_fileName");
		String mimeType = (String) context.get("_uploadedFile_contentType");
		String folder = (String) context.get("folder");

		InputStream stream = new ByteArrayInputStream(fileBytes.array());

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				String _path = null;
				
				if(folder == null) {
					_path = node.createFile("/", fileName, mimeType, stream, false);
				} else {
					_path = node.createFile(folder, fileName, mimeType, stream, false);
				}
				result.put("path", _path);
			} catch (RepositoryException e) {
				jcrSession.logout();
				throw new GenericServiceException(e.getMessage());
			} catch (IOException e) {
				jcrSession.logout();
				throw new GenericServiceException(e.getMessage());
			} catch (ParseException e) {
				jcrSession.logout();
				throw new GenericServiceException(e.getMessage());
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitUploadFileProperties(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();

		ByteBuffer fileBytes = (ByteBuffer) context.get("uploadedFile");
		String fileName = (String) context.get("_uploadedFile_fileName");
		String mimeType = (String) context.get("_uploadedFile_contentType");
		String folder = (String) context.get("folder");
		Map<?, ?> map = (Map<?, ?>) context.get("properties");

		String nodeType = (String) context.get("nodeType");

		Map<String, String> properties = new HashMap<String, String>();

		for (Object x : map.keySet()) {
			properties.put((String) x, (String) map.get(x));
		}

		InputStream stream = new ByteArrayInputStream(fileBytes.array());

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			if (jcrSession != null) {
				try {
					OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
					String _path = null;
					
					if(folder == null) {
						_path = node.createFile("/", fileName, mimeType, stream, nodeType, properties, false);
					} else {
						_path = node.createFile(folder, fileName, mimeType, stream, nodeType, properties, false);
					}
					result.put("path", _path);
				} catch (RepositoryException e) {
					jcrSession.logout();
					throw new GenericServiceException(e.getMessage());
				} catch (IOException e) {
					jcrSession.logout();
					throw new GenericServiceException(e.getMessage());
				} catch (ParseException e) {
					jcrSession.logout();
					throw new GenericServiceException(e.getMessage());
				}
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}
		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitScaleImageService(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException, ParseException {
		Map<String, Object> result = FastMap.newInstance();
		Map<String, Object> map = null;

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);
		String curPath = (String) context.get("curPath");

		if (jcrSession != null) {
			try {
				map = JackrabbitScaleImage.scaleImageInAllSize(context, curPath, jcrSession);
				result.put("imageUrl", map.get("imageUrlMap"));
			} catch (RepositoryException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			} catch (IllegalArgumentException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			} catch (ImagingOpException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			} catch (IOException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			} catch (JDOMException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitGetNodeProperties(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();

		Map<String, Map<String, String>> map = null;

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		String path = (String) context.get("path");

		String namespace = (String) context.get("namespace");
		
		if (jcrSession != null) {
			OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
			try {
				map = node.getFileProperties(jcrSession.getNode(path), namespace);
			} catch (RepositoryException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put("properties", map);

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}

	public static Map<String, Object> jackrabbitGetChildItem(DispatchContext ctx, Map<String, ?> context) throws GenericServiceException {
		Map<String, Object> result = FastMap.newInstance();
		String curPath = (String) context.get("curPath");

		Session jcrSession = (Session) context.get(JackrabbitOlbiusSessionServices.JCR_SESSION);

		if (jcrSession != null) {
			try {
				OlbiusNode node = NODE_FACTORY.newInstance(jcrSession);
				Map<String, List<String>> nodes = node.getChildItem(curPath);
				result.put("childNodes", nodes);
			} catch (RepositoryException e) {
				jcrSession.logout();
				throw new GenericServiceException(e);
			}
		} else {
			throw new GenericServiceException("JCR_SESSION not found");
		}

		result.put(ModelService.RESPONSE_MESSAGE, ModelService.RESPOND_SUCCESS);
		return result;
	}
}
